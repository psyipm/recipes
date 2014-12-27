class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :src
      t.string :src_big
      t.references :recipe, index: true
    end
    add_foreign_key :photos, :recipes
  end
end
