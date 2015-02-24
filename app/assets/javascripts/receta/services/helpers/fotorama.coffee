angular.module('recetaServices')
.service('fotorama', ["$timeout", "RecipeService", ($timeout, RecipeService)->
	apply: ()->
		$timeout(()->
			$(".fotorama").slice(-RecipeService.per_page).fotorama()

			$(".recipe-images").slice(-RecipeService.per_page).animate({opacity: 1}, "slow", ()->
				$(".recipe-images").css({height: "auto"})
			)
			return
		, 10)
])