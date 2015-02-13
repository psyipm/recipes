angular.module('receta').controller('EditRecipeController', [
  '$scope', '$routeParams', 'RecipeService', 'TokenfieldHelpers', 'DropZoneHelpers',
  ($scope, $routeParams, RecipeService, tfHelpers, dz)->
    $scope.loadComponents = (components)->
      $scope.components = (i.title for i in components)

    $scope.loadTags = (tags)->
      $scope.tags = (i.title for i in tags)
      tfHelpers.getInstance().setTokens $scope.tags

    $scope.loadPhotos = (photos)->
      for photo in photos
        dz.addUploadedFile photo; continue

    RecipeService.edit($routeParams.id)
      .then((data)->
        $scope.recipe = data

        $scope.title = data.recipe.title
        $scope.text = data.recipe.text.replace(/<br>/g, "\n")
        $scope.serving = data.recipe.serving
        $scope.cook_time = data.recipe.cook_time

        $scope.loadComponents(data.components)
        $scope.loadTags(data.tags)
        $scope.loadPhotos(data.photos)
    )
])