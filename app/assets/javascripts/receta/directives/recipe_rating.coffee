angular.module('receta').directive('recipeRating', ['Rating', '$timeout', (Rating, $timeout)->
  restrict: "E"
  templateUrl: 'recipes/user_rating.html'
  controller: 'RecipeUserRatingController'
  scope: {
    recipe: "="
  }
  link: (scope, element)->
    $timeout((-> scope.setUserRate(Rating.check scope.recipe.id)), 1)
])