class Recipe < ActiveRecord::Base
	has_many :components, dependent: :destroy
	has_many :tags
	has_many :photos, dependent: :destroy

	def self.search(query, offset = 0, limit = 10)
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
				where(["rc.id in (c.recipe_id) AND rc.published = ?", 1]).
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

		recipes = sql.load
	end

	def self.find_by_tag(tag, offset = 0, limit = 10)
		tags = tag.join("|").mb_chars.downcase.to_s
		Recipe.joins(:tags).
				where("LOWER(tags.title regexp ? and recipes.published = ?)", tags, 1).
				order(id: :desc).
				offset(offset).
				limit(limit).
				distinct
	end

	def self.published(offset = 0, limit = 10)
		Recipe.where(["published = ?", 1]).order(id: :desc).offset(offset).limit(limit)
	end
end
