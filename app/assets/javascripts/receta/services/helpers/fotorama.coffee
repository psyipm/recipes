angular.module('recetaServices')
.service('fotorama', ["$timeout", ($timeout)->
	apply: ()->
		$timeout(()->
			$(".fotorama").fotorama()
			$(".recipe-images").animate({opacity: 1}, "slow", ()->
				$(".recipe-images").css({height: "auto"})
			)
			return
		, 100)
])