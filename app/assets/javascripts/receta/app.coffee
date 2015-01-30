receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ipCookie',
  'ng-token-auth',
  'ngSanitize',
  'delayed-change',
  'recetaServices'
])

receta.config([ '$routeProvider','$locationProvider',
  ($routeProvider,$locationProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
      # .when('/recipes/new'
      #   templateUrl: 'recipes/new.html',
      #   controller: 'AddRecipeController'
      # )
      .when('/users/login',
        templateUrl: 'user_sessions/new.html'
        controller: 'UserSessionsController'
      )
      .when('/users/register',
        templateUrl: 'user_regisrations/new.html'
        controller: 'UserRegistrationsController'
      )
      # .otherwise(
      #   redirectTo: '/'
      # )

    $locationProvider.html5Mode(true)
])