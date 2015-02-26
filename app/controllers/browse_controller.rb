class BrowseController < ApplicationController
	def index
		@tags = Tag.cloud
		@recipes = Recipe.published.paginate(:page => params[:page])
		if params[:tag]
			@recipes = Recipe.find_by_tag([params[:tag]]).paginate(:page => params[:page])
		end
	end
end
