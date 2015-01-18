receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'controllers',
  'ngSanitize',
  'delayed-change',
  'ngResource',
  'recetaServices'
])
.directive "recipeListRenderingDirective", ->
  (scope, element, attrs) ->
    fotorama = ()->
      window.setTimeout(()->
        $(".fotorama").fotorama()
      , 100)

    fotorama() if scope.$last
    return

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])