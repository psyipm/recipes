receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'controllers',
  'ngSanitize',
  'delayed-change'
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])