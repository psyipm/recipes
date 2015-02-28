class AddRecipeDislikes < ActiveRecord::Migration
  def change
  	add_column :recipes, :dislikes, :integer, default: 0
  end
end
