class Tag < ActiveRecord::Base
  belongs_to :recipe

  def self.cloud
  	tags = Tag.select("title, count(*) as weight").group(:title)
  end
end
