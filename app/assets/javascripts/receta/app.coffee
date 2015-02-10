receta = angular.module('receta',[
  'templates',
  'restangular',
  'ui.bootstrap',
  'ngRoute',
  'ipCookie',
  'ng-token-auth',
  'ngSanitize',
  'delayed-change',
  'recetaServices'
])

receta.config([ '$routeProvider','$locationProvider','$httpProvider'
  ($routeProvider,$locationProvider,$httpProvider)->
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
        templateUrl: 'recipes/view_recipe.html',
        controller: 'ViewRecipeController'
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

    # $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])