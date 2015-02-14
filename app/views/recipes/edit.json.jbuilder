json.recipe @recipe, :id, :title, :text, :serving, :cook_time, :rating
json.photos @recipe.photos, :id, :original, :medium, :thumb
json.tags @recipe.tags, :id, :title
json.components @recipe.components, :id, :title