receta = angular.module('receta',[
  'templates',
  'restangular',
  'ui.bootstrap',
  'ngRoute',
  'ipCookie',
  'ng-token-auth',
  'ngSanitize',
  'delayed-change',
  'recetaServices',
  'ngDisqus'
])

receta.config([ '$routeProvider','$locationProvider','$disqusProvider'
  ($routeProvider,$locationProvider,$disqusProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
      .when('/recipes/new'
        templateUrl: 'recipes/new.html',
        controller: 'AddRecipeController'
      )
      .when('/recipes/:id'
        templateUrl: 'recipes/show.html',
        controller: 'ViewRecipeController'
      )
      .when('/recipes/:id/edit'
        templateUrl: 'recipes/new.html',
        controller: 'EditRecipeController'
      )
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

    $disqusProvider.setShortname "recipes4you"
])