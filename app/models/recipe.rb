class Recipe < ActiveRecord::Base
	has_many :components, dependent: :destroy
	has_many :tags
	has_many :photos, dependent: :destroy
end
