json.array! @recipes do |recipe|
	json.recipe recipe, :id, :title, :text, :serving, :cook_time, :rating
	json.components recipe.components, :title
	json.photos recipe.photos, :src, :src_big
	json.tags recipe.tags, :title
end