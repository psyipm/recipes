require File.expand_path "../environment", __FILE__

components = ["фарш","лук","яйца","болгарский перец","сыр","хлеб","кабачок","цуккини","картофель","горчица","пекинская капуста","курица","индейка","шампиньоны","творог","чеснок","мука","панировочные сухари","растительное масло","сливочное масло","кефир","рис","фасоль","плавленный сыр","сметана","мясо","помидор","соевый соус","креветки","морковь","авокадо","желатин","майонез","свинина","шоколад","сгущенное молоко","кокосовая стружка","разрыхлитель","масло","сахар","манка","сливки","киви","мята","лайм","тоник","водка","лаваш","кетчуп","бекон","банан","карамельный соус","крахмал","молоко","ванилин","печенье","взбитые сливки","овсяная крупа","какао","сельдерей","оливковое масло","спагетти","куриное филе","кукуруза","капустный салат","крупа манная","куриный окорочок","тимьян","бульон","лимон","ягоды","куриные крылышки","пармезан","сливочный соус","грибы","ветчина","маслины","темный ром","сахарная пудра","ванильный сахар","какао-порошок","блинчики","клубника","сгущенка","фруктовый сок","фундук","грецкие орехи","маринованные огурцы","гочица","чернослив","горошек","лосось","форель","изюм","ликер","белое вино","оливки","колбаса","багет"]

job "recipes.save" do |args|
	recipes = args["recipes"]
	recipes.each do |r|
		recipe = Recipe.new r["recipe"]
		next if recipe.similar.length > 0

		comp = components.collect {|c| c if recipe.text.mb_chars.downcase.to_s.include? c }
		comp.compact!

		ActiveRecord::Base.transaction do
			recipe.photos = r["photos"].collect do |p| 
				photo = Photo.new image_remote_url: p["original"]
				photo.download_remote_image
				photo
			end

			recipe.components = comp.collect {|c| Component.new title: c }

			recipe.published = false
			recipe.save

			recipe.photos.each do |p| 
				p.update_urls
			end
		end
	end
end