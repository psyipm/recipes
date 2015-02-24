class Recipe < ActiveRecord::Base
	has_many :components, dependent: :destroy, autosave: true
	has_many :tags, dependent: :destroy, autosave: true
	has_many :photos, dependent: :destroy, autosave: true
	has_one :fingerprint, dependent: :destroy, autosave: true

	self.per_page = 10

	after_save :update_fingerprint

	def self.search(query, offset = 0, limit = 10, admin = false)
		components = query[:tokens]

		args = components.join("|").mb_chars.downcase.to_s

		counts = Recipe.select("count(*)").
				from("recipes as r").
				joins("INNER JOIN components AS c ON (c.recipe_id = r.id)").
				where("r.id = cm.recipe_id")

		recipe_ids = Component.select("cm.recipe_id, (#{counts.to_sql}) - count(*) as missing_comp_count").
				from("components as cm").
				where("LOWER(title) regexp ?", args).
				group("cm.recipe_id")

		sql = Recipe.select("rc.*").
				from("recipes as rc, (#{recipe_ids.to_sql}) as c").
				where(["rc.id in (c.recipe_id)"]).
				order("c.missing_comp_count").
				offset(offset).
				limit(limit)

		if query[:tags]
			tags = query[:tags].join("|").mb_chars.downcase.to_s

			tags_sql = Recipe.select("r.*").
					from("recipes as r").
					joins("INNER JOIN tags AS t ON (r.id = t.recipe_id)").
					where("LOWER(t.title) regexp ?", tags)

			counts = counts.from("(#{tags_sql.to_sql}) as r")
			sql = sql.from("(#{tags_sql.to_sql}) as rc, (#{recipe_ids.to_sql}) as c")
		end

		unless admin == true
			sql = sql.where ["rc.published = ?", true]
		end

		recipes = sql.load
	end

	def self.find_by_tag(tag, offset = 0, limit = 10, admin = false)
		tags = tag.join("|").mb_chars.downcase.to_s
		recipes = Recipe.joins(:tags).
				where("LOWER(tags.title regexp ?)", tags).
				order(id: :desc).
				offset(offset).
				limit(limit).
				distinct

		unless admin == true
			recipes = recipes.where ["recipes.published = ?", true]
		end
		recipes = recipes.load
	end

	def self.published(offset = 0, limit = 10)
		Recipe.where(["published = ?", true]).order(id: :desc).offset(offset).limit(limit)
	end

	def create_fingerprint
		words = self.text.mb_chars.downcase.to_s.gsub(/[^а-я]/i, " ").split(" ")
		i = 0
		words.collect! do |word| 
			i+=1
			len = word.length
			word.slice(0, len-len/3) if word.match(/[а-я]{5,8}/i) and i%3 == 0
		end
		words.compact!.uniq!
		words.join(" ").slice(0, 255)
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
end
