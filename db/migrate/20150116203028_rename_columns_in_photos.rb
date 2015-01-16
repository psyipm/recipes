class RenameColumnsInPhotos < ActiveRecord::Migration
  def change
  	remove_column :photos, :src, :string
  	remove_column :photos, :src_big, :string
  	add_column :photos, :original, :string, :after => :id
  	add_column :photos, :medium, :string, :after => :original
  	add_column :photos, :thumb, :string, :after => :medium
  end
end
