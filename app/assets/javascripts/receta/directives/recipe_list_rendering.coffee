angular.module('receta').directive "recipeListRenderingDirective", ->
  (scope, element, attrs) ->
    fotorama = ()->
      window.setTimeout(()->
        $(".fotorama").fotorama()
      , 100)

    fotorama() if scope.$last
    return