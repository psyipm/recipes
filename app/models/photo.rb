class Photo < ActiveRecord::Base
  belongs_to :recipe

  has_attached_file :image, 
  					:styles => { 
  						:medium => "300x300>",
  						:thumb => "100x100>"
  					},
  					:path => ":rails_root/public/system/:attachment/:id_partition/:hash.:extension",
  					:hash_secret => "CCLYDnUvJuDsfcFC1aFf",
  					:url => "/system/:attachment/:id_partition/:hash.:extension"

  validates_attachment 	:image, 
						:presence => true,
						:content_type => { :content_type => /\Aimage\/.*\Z/ },
						:size => { :less_than => 1.megabyte }

  def self.update_urls(recipe_id, id)
  	photo = Photo.find id 
  	styles = photo.image.styles
	photo.update recipe_id: recipe_id, 
				 original: photo.image.url, 
				 medium: styles[:medium].attachment.url, 
				 thumb: styles[:thumb].attachment.url
  end
  
  def self.remove_unused
  	photos = Photo.where recipe_id: nil
  	photos.each {|p| p.destroy }
  end
end
