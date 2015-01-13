class ComponentsController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def find
		query = params[:query]
		@components = Component.where('title like ?', "%#{query}%")
	end

	def get
		@components = Component.uniq(params[:offset], params[:limit])
		@components.collect! { |c| c.title }
	end
end
