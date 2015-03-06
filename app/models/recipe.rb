class Recipe < ActiveRecord::Base
	has_many :components, dependent: :destroy, autosave: true
	has_many :tags, dependent: :destroy, autosave: true
	has_many :photos, dependent: :destroy, autosave: true
	has_one :fingerprint, dependent: :destroy, autosave: true

	self.per_page = 10

	after_save :update_fingerprint

	def self.default(page = 1)
		@recipes = Recipe.all.
			order("id desc").
			offset(self.get_offset page).
			limit(self.per_page)
	end

	def self.published(page = 1)
		@recipes = self.default(page).
			where(["published = ?", true])
	end

	def self.unpublished(page = 1)
		@recipes = self.default(page).
			where(["published = ?", false])
	end

	def self.search_by_components(params, page = 1)
		components = self.join_tokens params
		@recipes = self.published page unless @recipes

		@recipes = @recipes.
			select("recipes.*, count(c.id) as `c_count`").
			joins("LEFT JOIN components AS c ON (recipes.id = c.recipe_id)").
			where(["LOWER(c.title) regexp ?", components]).
			group("recipes.id").
			reorder("`c_count` desc").
			offset(self.get_offset page).
			limit(self.per_page)
	end

	def self.search_by_tags(params, page = 1)
		tags = self.join_tokens params
		@recipes = self.published page unless @recipes

		@recipes = @recipes.
			joins("LEFT JOIN tags as t ON (recipes.id = t.recipe_id)").
			where("LOWER(t.title) regexp ?", tags)
	end

	def self.search(query, page = 1)
		@recipes = if query[:unpublished] then self.default page else self.published page end

		if query[:tokens] and query[:tokens][0].length > 0
			@recipes = self.search_by_components query[:tokens], page
		end

		if query[:tags]
			@recipes = self.search_by_tags query[:tags], page
		end

		@recipes
	end

	def create_fingerprint
		begin
			words = self.text.mb_chars.downcase.to_s.gsub(/[^а-я]/i, " ").split(" ")
			count = words.length
			i = 0
			words.collect! do |word| 
				len = word.length
				word.slice(0, len-len/3) if word.match(/[а-я]{5,8}/i) and i % (count/10) == 0
			end
			words.compact!.uniq!
			words.join(" ").slice(0, 255)
		rescue
			return self.text.slice(0, 255)
		end
	end

	def update_fingerprint
		fp = self.fingerprint || Fingerprint.new(recipe_id: self.id)
		fp.text = self.create_fingerprint
		fp.save
		return true
	end

	def similar
		size = 5
		arr = self.create_fingerprint.split(" ")
		fp = arr.slice(rand(arr.length-size), size)
		regexp = fp.join(".*") + ".*"

		Fingerprint.where(["text regexp ?", regexp])
	end

	private
		def self.get_offset(page)
			(page - 1) * self.per_page
		end

		def self.join_tokens(params)
			params.join("|").mb_chars.downcase.to_s
		end
end
