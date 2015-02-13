angular.module('receta').directive('adminButtons', ()->
  restrict: "E"
  templateUrl: 'admin/admin_buttons.html'
  controller: ['$scope', '$location', 'RecipeService', '$modal', ($scope, $location, RecipeService, $modal)->
    $scope.publish = (published)->
      recipe = $scope.n.recipe

      RecipeService.put({ id: recipe.id, published: published })
        .then((data)->
          $scope.n.recipe = data.recipe
        )

    # TODO: edit recipe
    $scope.edit = ()->
      console.log $scope
      id = $scope.n.recipe.id
      console.log "edit #{id}"
      # $location.path("/recipes/#{id}/edit").search("")

    $scope.confirmDelete = ($index)->
      $scope.index = $index
      $scope.modalInstance = $modal.open({
        scope: $scope
        templateUrl: 'recipes/confirm_destroy.html'
      })

    $scope.remove = ()->
      RecipeService.remove($scope.n.recipe.id)
        .then((data)->
          $scope.recipes.splice $scope.index, 1
        )
      $scope.modalInstance.close()

    $scope.dismiss = ()->
      $scope.modalInstance.dismiss()
  ]
)