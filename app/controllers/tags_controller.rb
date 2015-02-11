class TagsController < ApplicationController
	def find
		query = params[:query]
		@tags = Tag.select('distinct lower(title) as title').where('lower(title) like ?', "%#{query.mb_chars.downcase}%")
	end

	def cloud
		@tags = Tag.cloud
	end

	def for_recipe
		@tags = Tag.for_recipe params[:recipe_id], params[:limit]
	end
end
