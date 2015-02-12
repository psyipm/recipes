angular.module('receta').directive('adminButtons', ()->
	restrict: "E"
	templateUrl: 'admin/admin_buttons.html'
	controller: ['$scope', '$location', 'RecipeService', ($scope, $location, RecipeService)->
		$scope.publish = (published)->
			recipe = $scope.n.recipe

			RecipeService.put({ id: recipe.id, published: published })
				.then((data)->
					$scope.n.recipe = data.recipe
				)

		$scope.edit = ()->
			id = $scope.n.recipe.id
			console.log "edit #{id}"
			# $location.path("/recipes/#{id}/edit").search("")

		$scope.delete = ()->
			console.log "delete #{$scope.n.recipe.id}"

	]
)