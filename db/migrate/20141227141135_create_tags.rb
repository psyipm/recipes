class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.references :recipe, index: true
    end
    add_foreign_key :tags, :recipes
  end
end
