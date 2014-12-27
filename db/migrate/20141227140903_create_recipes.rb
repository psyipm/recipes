class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title, limit: 512
      t.text :text
      t.integer :serving
      t.integer :cook_time
      t.integer :rating
      t.boolean :published

      t.timestamps null: false
    end
  end
end
