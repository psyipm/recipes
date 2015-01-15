class TagsController < ApplicationController
	def find
		query = params[:query]
		@tags = Tag.where('title like ?', "%#{query.mb_chars.downcase}%")
	end
end
