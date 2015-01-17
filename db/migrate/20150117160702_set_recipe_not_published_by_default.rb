class SetRecipeNotPublishedByDefault < ActiveRecord::Migration
  def change
  	change_column :recipes, :published, :boolean, default: false
  end
end
