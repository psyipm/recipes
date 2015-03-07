class Photo < ActiveRecord::Base
  belongs_to :recipe

  has_attached_file :image, 
            :styles => { 
              :medium => "320x320>",
              :thumb => "100x100>"
            }

  validates_attachment  :image, 
            :presence => true,
            :content_type => { :content_type => /\Aimage\/.*\Z/ },
            :size => { :less_than => 1.megabyte }

  can_attach_from_remote_url :image

  def get_urls
    original = self.image.url
    medium = self.image.url :medium
    thumb = self.image.url :thumb
    return original, medium, thumb
  end

  def update_urls
    self.original, self.medium, self.thumb = self.get_urls
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
