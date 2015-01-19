class TagsController < ApplicationController
	def find
		query = params[:query]
		@tags = Tag.select('distinct lower(title) as title').where('lower(title) like ?', "%#{query.mb_chars.downcase}%")
	end
end
