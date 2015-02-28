if current_user.try(:admin?)
  	json.recipe recipe, :id, :title, :text, :serving, :cook_time, :rating, :dislikes, :published
else
	json.recipe recipe, :id, :title, :text, :serving, :cook_time, :rating, :dislikes
end
json.photos recipe.photos, :original, :medium, :thumb