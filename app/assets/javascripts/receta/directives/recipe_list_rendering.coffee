angular.module('receta')
.directive('recipeListRenderingDirective', ['fotorama', '$location', (fotorama, $location)->
  (scope, element, attrs)->
    bindRecipeLinks = ()->
      $(".recipe-wrapper").click (e)->
        if $(e.target).hasClass("recipe-wrapper")
          link = $(e.target).find("recipe").find("a").attr("href")
          
          $location.path(link).search({})
          scope.$apply()

    if scope.$last
      bindRecipeLinks()
      fotorama.apply()

    return
])