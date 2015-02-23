class CreateFingerprints < ActiveRecord::Migration
  def change
    create_table :fingerprints do |t|
      t.string :text, limit: 256, index: true
      t.references :recipe, index: true, unique: true
    end
    add_foreign_key :fingerprints, :recipes
  end
end
