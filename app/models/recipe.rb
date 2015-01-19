class Recipe < ActiveRecord::Base
	has_many :components, dependent: :destroy
	has_many :tags
	has_many :photos, dependent: :destroy

	def self.find_by_components(components, offset = 0, limit = 10)
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

		recipes = sql.load
	end

	def self.find_by_tag(tag)
		Recipe.joins(:tags).where("lower(tags.title) like ?", "%#{tag.mb_chars.downcase.to_s}%")
	end
end
