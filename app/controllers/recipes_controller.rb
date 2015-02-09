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
			@recipes = Recipe.search query, params[:offset], params[:limit]
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

			message = current_user.try(:admin?) ? "Your recipe added successfully" : "Your recipe will be added after moderation"

			render json: { success: 1, message: message}, :status => 200
		rescue Exception => e
			render json: { message: "Cannot create a recipe", error: e.message }, :status => 400
		end
	end

  private
	def recipe_params
		recipe = params.require(:recipe).permit(:title, :text, :cook_time, :serving)
		recipe[:text].gsub! /(\r\n)|(\n)/, '<br>'
		recipe[:published] = true if current_user.try(:admin?)
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