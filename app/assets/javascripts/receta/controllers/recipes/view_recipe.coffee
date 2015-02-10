angular.module('receta').controller('ViewRecipeController', 
['$scope', '$routeParams', 'RecipeService',
	($scope, $routeParams, RecipeService)->
		id = $routeParams.id

		RecipeService.one(id).then((recipes)-> $scope.recipes = recipes )
])