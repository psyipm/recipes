angular.module('receta')
.directive('recipeListRenderingDirective', ['fotorama', (fotorama)->
  (scope, element, attrs)->
    fotorama.apply() if scope.$last
    return
])