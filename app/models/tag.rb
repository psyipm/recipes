class Tag < ActiveRecord::Base
  belongs_to :recipe

  def self.cloud(limit = 200)
  	Tag.select("title, count(*) as weight").group(:title).limit(limit)
  end

  def self.for_recipe(recipe_id, limit = 5)
  	tags = cloud(limit)
  	tags = tags.where(["recipe_id = ?", recipe_id]).order("weight")
  end
end
