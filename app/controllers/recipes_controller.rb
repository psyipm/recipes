class RecipesController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def index
		@tags = Tag.cloud
	end

	def show
		recipe = Recipe.find params[:id]
		@tags = Tag.for_recipe params[:id]
		@recipes = [recipe]
	end

	def find
		query = params[:query] || []
		@admin = current_user.try(:admin?)
		offset = params[:offset]
		limit = params[:limit]
		search_query = ""

		if query[:tokens] and query[:tokens].length > 0 and query[:tokens][0].length > 0
			search_query = query[:tokens].join("|").mb_chars.downcase.to_s
			@recipes = Recipe.search query, offset, limit, @admin
		elsif query[:tags] and query[:tags].length > 0
			search_query += "|" + query[:tags].join("|").mb_chars.downcase.to_s
			@recipes = Recipe.find_by_tag query[:tags], offset, limit, @admin
		elsif @admin == true
			@recipes = Recipe.all().order(id: :desc).offset(offset).limit(limit)
		else
			@recipes = Recipe.published offset, limit
		end

		if @recipes.length < Recipe.per_page
			pages = ENV['vk_public_pages'].split("|")
			vk = VkontakteApi::Client.new
			if search_query.length > 0
				data = vk.wall.search owner_id: pages.sample, query: search_query, offset: offset, count: limit*2
			else
				data = vk.wall.get owner_id: pages.sample, offset: offset, count: limit*2
			end
			recipes = Parse.get_posts(data).first(limit-@recipes.length)

			Stalker.enqueue("recipes.save", recipes: recipes)

			tmp = []
			@recipes.each do |r|
				obj = { 
					recipe: { 
						id: r.id, 
						title: r.title, 
						text: r.text, 
						published: r.published, 
						rating: r.rating,
						cook_time: r.cook_time, 
						serving: r.serving 
					}, 
					photos: r.photos 
				}
				tmp += [obj]
			end

		  render :json => tmp + recipes, status => 200
		end
	end

	def new
		@recipe = Recipe.new
	end

	def create
		begin
			@recipe = Recipe.create recipe_params
			ActiveRecord::Base.transaction do
				tag_params.each {|t| @recipe.tags.create title: t }
				component_params.each {|c| @recipe.components.create title: c }
				photo_params.each {|p| Photo.update_urls @recipe.id, p }
				Photo.remove_unused
			end

			message = current_user.try(:admin?) ? "Your recipe added successfully" : "Your recipe will be added after moderation"

			render json: { success: 1, message: message}, :status => 200
		rescue Exception => e
			render json: { message: "Cannot create a recipe", error: e.message }, :status => 400
		end
	end

	def edit
		authenticate_user!
		begin
			

			@recipe = Recipe.find params[:id]

			# render json: { success: 1, recipe: @recipe }, status => 200
		rescue Exception => e
			# render json: { message: "message" }, status => 400
		end
	end

	def update
		authenticate_user!
		begin
			if current_user.try(:admin?)
				@recipe = Recipe.find params[:id]
				ActiveRecord::Base.transaction do
					update_collection @recipe.tags, tag_params if params[:tags]
					update_collection @recipe.components, component_params if params[:components]

					if params[:photos]
						photo_params.each {|p| Photo.update_urls @recipe.id, p }
						Photo.remove_unused
					end

					@recipe.update recipe_params
					render json: { success: 1, recipe: @recipe, message: "Recipe updated successfully"}, :status => 200
				end
			else
				render json: { message: "You are not allowed to edit" }, :status => 400
			end
		rescue Exception => e
			render json: { message: "Cannot update the recipe", exception: e.message }, :status => 400
		end
	end

	def update_rating
		@id, @rate = rating_params

		if allow_rate?
			@recipe = Recipe.find @id
			@recipe.rating += @rate
			if @recipe.save
				save_to_session @id
				render json: { success: 1, rating: @recipe.rating }, :status => 200
			else
				render json: { error: "Unable to save recipe" }, :status => 400
			end
		else
			render json: { error: "You already rated this recipe" }, :status => 400
		end
	end

	def destroy
		authenticate_user!
		begin
			if current_user.try(:admin?)
				@recipe = Recipe.find params[:id]
				@recipe.destroy
				render json: { success: 1 }, :status => 200
			end
		rescue Exception => e
			render json: { message: "Cannot delete the recipe" }, :status => 400
		end
	end

  private
	def recipe_params
		recipe = params.require(:recipe).permit(:title, :text, :cook_time, :serving, :published)
		unless recipe[:text].nil?
			recipe[:text].gsub! /(\r\n)|(\n)/, '<br>'
		end
		if recipe[:published].nil?
			recipe[:published] = true if current_user.try(:admin?)
		end
		recipe
	end
	def component_params
		params.require(:components)
		components = params[:components].split ", "
	end
	def tag_params
		params.require(:tags)
		tags = params[:tags].split ", "
	end
	def photo_params
		params.require :photos
		data = params[:photos].split ", "
	end
	def rating_params
		params.require(:id)
		params.require(:rate)
		return params[:id], params[:rate]
	end
	def update_collection(collection, params)
		collection.each do |c|
			unless params.include? c.title
				c.destroy
			else
				params = params - [c.title]
			end
		end
		params.each { |param| collection.create title: param }
	end
	def allow_rate?
		@session_key = (@rate == 1) ? :liked_recipes : :disliked_recipes
		@inverted_key = (@rate == -1) ? :liked_recipes : :disliked_recipes

		unless session[@inverted_key].respond_to? :include?
			session[@inverted_key] = Array.new
		end

		if session[@session_key].respond_to? :include?
			return !session[@session_key].include?(@id)
		else
			session[@session_key] = Array.new
			return true
		end
	end
	def save_to_session(id)
		session[@session_key].push id
		session[@inverted_key] -= [id]
	end
end