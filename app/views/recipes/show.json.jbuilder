json.array! @recipes do |recipe|
	json.recipe recipe, :id, :title, :text, :serving, :cook_time, :rating, :dislikes
	json.photos recipe.photos, :original, :medium, :thumb
	json.tags @tags, :title, :weight
end