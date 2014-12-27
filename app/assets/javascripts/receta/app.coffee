receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'controllers',
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])