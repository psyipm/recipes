class ComponentsController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def find
		query = params[:query]
		@components = Component.select('distinct lower(title) as title').where('lower(title) like ?', "%#{query.mb_chars.downcase}%")
	end

	def get
		@components = Component.uniq(params[:offset], params[:limit])
		@components.collect! { |c| c.title }
	end
end
