json.array! @recipes do |recipe|
	json.recipe recipe, :id, :title, :text, :serving, :cook_time, :rating
	json.components recipe.components, :title
	json.photos recipe.photos, :original, :medium, :thumb
	json.tags recipe.tags, :title
end