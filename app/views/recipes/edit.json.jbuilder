json.recipe @recipe, :id, :title, :text, :serving, :cook_time, :rating
json.photos @recipe.photos, :id, :original, :medium, :thumb
json.tags @recipe.tags, :title
json.components @recipe.components, :title