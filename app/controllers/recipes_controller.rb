class RecipesController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	# protect_from_forgery
	
	def index
		
	end

	def find
		if params[:selected].length > 0 and params[:selected][0].length > 0
			@recipes = Recipe.find_by_components params[:selected]
		else
			@recipes = Recipe.where(["published = ?", 1]).order id: :desc
		end
	end

	def new
		@recipe = Recipe.new
	end

	def create
		# render json: {recipe: recipe_params, components: component_params, tags: tag_params, photos: photo_params}
		begin
			@recipe = Recipe.create recipe_params
			ActiveRecord::Base.transaction do
				tag_params.each {|t| @recipe.tags.create title: t }
				component_params.each {|c| @recipe.components.create title: c }
				photo_params.each {|p| Photo.update_urls @recipe.id, p }
				Photo.remove_unused
			end

			@ok = true
		rescue Exception => e
			@ok = false
		end
	end

  private
	def recipe_params
		recipe = params.require(:recipe).permit(:title, :text, :cook_time, :serving)
		recipe[:text].gsub!(/(\r\n)/, '<br>')
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
end