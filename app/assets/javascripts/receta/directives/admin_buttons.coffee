angular.module('receta').directive('adminButtons', ()->
	restrict: "E"
	templateUrl: 'admin/admin_buttons.html'
	controller: ['$scope', '$location', ($scope, $location)->
		$scope.publish = (publish)->
			id = $scope.n.recipe.id
			console.log "publish #{id}"

		$scope.edit = ()->
			id = $scope.n.recipe.id
			console.log "edit #{id}"
			# $location.path("/recipes/#{id}/edit").search("")

		$scope.delete = ()->
			console.log "delete #{$scope.n.recipe.id}"

	]
)