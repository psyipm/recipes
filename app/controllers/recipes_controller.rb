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
		
	end

	def create
		@params = ActionController::Parameters.new(params[:recipe])
	end
end