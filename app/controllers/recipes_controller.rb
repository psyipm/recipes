class RecipesController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	# protect_from_forgery
	
	def index
		
	end

	def find
		if(params[:selected])
			@recipes = Recipe.find_by_components params[:selected]
		else
			@recipes = Recipe.where(["published = ?", 1])
		end
	end

	def new
		@recipe = Recipe.new
	end

	def create
		@params = photo_params
	end

  private
	def recipe_params
		params.require(:recipe).permit(:title, :text, :cook_time, :serving, :components, :tags, :photos)
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
		photos = params[:photos]
	end
end