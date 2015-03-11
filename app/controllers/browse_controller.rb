class BrowseController < ApplicationController
	def index
		@tags = Tag.cloud
		@page = params[:page]
		@recipes = Recipe.published.paginate(:page => @page)
		if params[:tag]
			@recipes = Recipe.search_by_tags([params[:tag]]).paginate(:page => @page)
		end
	end
end
