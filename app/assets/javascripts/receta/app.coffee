receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'controllers',
  'ngSanitize',
  'delayed-change',
  'ngResource',
  'recetaServices'
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])