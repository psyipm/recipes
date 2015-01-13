class Recipe < ActiveRecord::Base
	has_many :components, dependent: :destroy
	has_many :tags
	has_many :photos, dependent: :destroy

	def self.find_by_components(components)
		# recipe_ids = Component.where("LOWER(title) regexp ?", components.join("|").downcase()).pluck('DISTINCT recipe_id')
		# puts recipe_ids
		# recipes = Recipe.where(["published = ? and id in (?)", 1, recipe_ids])



		# recipe_ids = Component.select('recipe_id').where("LOWER(title) regexp ?", query)

		# comp_counts = Recipe.select("count(*)").
		# 					joins("LEFT JOIN components c ON recipes.id = c.recipe_id")

		# query1 = comp_counts.where("recipes.id = #{recipe_ids.recipe_id}")

		# puts recipe_ids.to_sql
		# puts comp_counts.to_sql
		# puts query1.to_sql


# @subquery = table_a.select("DISTINCT ON(table_a.id) table_a.name as alias_a, table_b.time")     
# @subquery = @subquery.joins("LEFT OUTER JOIN table_b ON table_a.id = table_b.id")
# @subquery = @subquery.order("table_a.id, table_b.time asc")
# @query = OtherModel.from("(#{@subquery.to_sql}) table_name, other_model_table, etc ...").where(:field => table_name.alias_a) ...etc.

		test = "select 
cm.recipe_id, 
(select count(*) from recipes r join components c on (c.recipe_id = r.id) where r.id = cm.recipe_id) - count(*) as missing_comp_count
from components cm

where LOWER(title) regexp 'сыр|грибы|Сметана|картофель'

group by cm.recipe_id
order by missing_comp_count"
		query = components.join("|").mb_chars.downcase.to_s
		# recipe_ids = Component.where("LOWER(title) regexp ?", query).pluck('DISTINCT recipe_id')
		# counts = Component.joins(:recipe).where(["recipe_id in (?)", recipe_ids]).group(:recipe_id).count
		# c = components.count
		# ids = counts.keys.sort {|a, b| b-c <=> a-c}

		# recipes = Recipe.where(["published = ? and id in (?)", 1, ids])

		sub = Recipe.select("count(*)").
				from("recipes as r").
				joins("INNER JOIN components AS c ON (c.recipe_id = r.id)").
				where("r.id = cm.recipe_id")

		recipe_ids = Component.select("cm.recipe_id, (#{sub.to_sql}) - count(*) as missing_comp_count").
				from("components as cm").
				where("LOWER(title) regexp ?", query).
				group("cm.recipe_id")

		recipes = Recipe.select("rc.*").
				from("recipes as rc, (#{recipe_ids.to_sql}) as c").
				where(["rc.id in (c.recipe_id) AND rc.published = ?", 1]).
				order("c.missing_comp_count")

		puts recipes.to_sql
		# puts comp_counts.to_sql

		# recipes = Recipe.all
	end
end
