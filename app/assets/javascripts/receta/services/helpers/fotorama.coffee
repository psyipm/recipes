angular.module('recetaServices')
.service('fotorama', ["$timeout", "RecipeService", ($timeout, RecipeService)->
	apply: ()->
		$timeout(()->
			len = $(".fotorama").length - RecipeService.per_page
			i = 0
			$(".fotorama").each(()->
				$(this).fotorama() if i >= len
				i++
			)
			$(".recipe-images").animate({opacity: 1}, "slow", ()->
				$(".recipe-images").css({height: "auto"})
			)
			return
		, 10)
])