receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'controllers',
  'ngSanitize',
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])