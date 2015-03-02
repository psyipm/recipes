class BrowseController < ApplicationController
	def index
		@tags = Tag.cloud
		@recipes = Recipe.published.paginate(:page => params[:page])
		if params[:tag]
			@recipes = Recipe.search_by_tags([params[:tag]]).paginate(:page => params[:page])
		end
	end
end
