class Photo < ActiveRecord::Base
  belongs_to :recipe

  has_attached_file :image, 
            :styles => { 
              :medium => "320x320>",
              :thumb => "100x100>"
            },
            :path => ":rails_root/public/system/:attachment/:id_partition/:hash.:extension",
            :hash_secret => "CCLYDnUvJuDsfcFC1aFf",
            :url => "/system/:attachment/:id_partition/:hash.:extension"

  validates_attachment  :image, 
            :presence => true,
            :content_type => { :content_type => /\Aimage\/.*\Z/ },
            :size => { :less_than => 1.megabyte }

  def update_urls
    self.original = self.image.url
    self.medium = self.image.url :medium
    self.thumb = self.image.url :thumb
    self.save
  end

  def self.update_urls(recipe_id, id)
    photo = Photo.find id 
    photo.update_urls
    photo.update recipe_id: recipe_id
  end
  
  def self.remove_unused
    photos = Photo.where recipe_id: nil
    photos.each {|p| p.destroy }
  end
end
