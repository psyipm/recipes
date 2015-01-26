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

	def find
		query = params[:query] || []
		if query[:tokens] and query[:tokens].length > 0 and query[:tokens][0].length > 0
			@recipes = Recipe.find query, params[:offset], params[:limit]
		elsif query[:tags] and query[:tags].length > 0
			@recipes = Recipe.find_by_tag query[:tags], params[:offset], params[:limit]
		else
			@recipes = Recipe.published params[:offset], params[:limit]
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