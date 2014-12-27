class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :title
      t.references :recipe, index: true
    end
    add_foreign_key :components, :recipes
  end
end
