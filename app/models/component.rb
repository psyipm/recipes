class Component < ActiveRecord::Base
  belongs_to :recipe

  def self.uniq(offset = 0, limit = 200)
  	components = Component.select("distinct lower(title) as title").offset(offset).limit(limit).load
  end
end
