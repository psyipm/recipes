angular.module('recetaServices')
.service('fotorama', ["$timeout", ($timeout)->
	apply: ()->
		$timeout(()->
			$(".fotorama").fotorama()
			$(".recipe-images").animate({opacity: 1}, "slow")
			return
		, 100)
])