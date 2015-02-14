if @admin
  	json.recipe recipe, :id, :title, :text, :serving, :cook_time, :rating, :published
else
	json.recipe recipe, :id, :title, :text, :serving, :cook_time, :rating
end
json.photos recipe.photos, :original, :medium, :thumb