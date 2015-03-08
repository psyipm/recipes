angular.module('receta').controller('ViewRecipeController', [
	'$scope', '$routeParams', 'RecipeService', 'titleService',
	($scope, $routeParams, RecipeService, titleService)->
		id = $routeParams.id

		RecipeService.one(id).then((recipes)-> 
			$scope.recipes = recipes 

			if $scope.recipes[0]
				titleService.setTitle $scope.recipes[0].recipe.title
		)
])