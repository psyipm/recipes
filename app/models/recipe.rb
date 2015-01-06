class Recipe < ActiveRecord::Base
	has_many :components, dependent: :destroy
	has_many :tags
	has_many :photos, dependent: :destroy

	def self.find_by_components(components)
		recipe_ids = Component.where("LOWER(title) regexp ?", components.join("|").downcase()).pluck('DISTINCT recipe_id')
		recipes = Recipe.find(recipe_ids)
	end
end
