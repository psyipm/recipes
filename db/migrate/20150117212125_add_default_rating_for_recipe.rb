class AddDefaultRatingForRecipe < ActiveRecord::Migration
  def change
  	change_column :recipes, :rating, :integer, default: 0
  end
end
