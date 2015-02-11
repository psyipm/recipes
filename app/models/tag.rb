class Tag < ActiveRecord::Base
  belongs_to :recipe

  def self.cloud(limit = 200)
  	Tag.select("title, count(*) as weight").group(:title).limit(limit)
  end

  def self.for_recipe(recipe_id, limit = 5, sort = true)
  	tags = cloud(limit)
  	if sort
  		tags = tags.order("weight desc")
  	end
  	tags = tags.where(["recipe_id = ?", recipe_id])
  end
end
