class BrowseController < ApplicationController
	def index
		@tags = Tag.cloud
		@recipes = Recipe.where(:published => true).order(id: :desc).paginate(:page => params[:page])
		if params[:tag]
			@recipes = Recipe.find_by_tag([params[:tag]]).paginate(:page => params[:page])
		end
	end
end
