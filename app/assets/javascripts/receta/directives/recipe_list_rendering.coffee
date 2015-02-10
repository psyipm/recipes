angular.module('receta').directive "recipeListRenderingDirective", ->
  (scope, element, attrs) ->
    fotorama = ()->
      window.setTimeout(()->
        $(".fotorama").fotorama()
        $(".recipe-images").animate({opacity: 1}, "slow")
      , 100)

    fotorama() if scope.$last
    return