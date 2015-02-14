class RecipesController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def index
		@tags = Tag.cloud
		if params[:tag]
			@recipes = Recipe.find_by_tag params[:tag]
		end
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

		if query[:tokens] and query[:tokens].length > 0 and query[:tokens][0].length > 0
			@recipes = Recipe.search query, offset, limit, @admin
		elsif query[:tags] and query[:tags].length > 0
			@recipes = Recipe.find_by_tag query[:tags], offset, limit, @admin
		elsif @admin == true
			@recipes = Recipe.all().order(id: :desc).offset(offset).limit(limit)
		else
			@recipes = Recipe.published offset, limit
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
				# byebug
				ActiveRecord::Base.transaction do
					update_collection @recipe.tags, tag_params if params[:tags]
					update_collection @recipe.components, component_params if params[:components]

					if params[:photos]
						photo_params.each {|p| Photo.update_urls @recipe.id, p }
						Photo.remove_unused
					end

					@recipe.update recipe_params
				end

				render json: { success: 1, recipe: @recipe, message: "Recipe updated successfully"}, :status => 200
			end
		rescue Exception => e
			render json: { message: "Cannot update the recipe", exception: e.message }, :status => 400
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
end