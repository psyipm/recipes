require File.expand_path "../environment", __FILE__

job "recipes.save" do |args|
	recipes = args["recipes"]
	recipes.each do |r|
		recipe = Recipe.new r["recipe"]
		recipe.photos = r["photos"].collect {|p| Photo.new p }
		recipe.published = false

		ap recipe.similar
	end
end