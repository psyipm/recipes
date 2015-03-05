angular.module('receta').controller('ViewRecipeController', 
['$scope', '$routeParams', 'RecipeService',
	($scope, $routeParams, RecipeService)->
		id = $routeParams.id

		RecipeService.one(id).then((recipes)-> 
			$scope.recipes = recipes 

			if $scope.recipes[0]
				title = $scope.recipes[0].recipe.title
				$("title").text("#{title} - Recipes4You")
		)
])