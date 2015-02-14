angular.module('receta').controller('EditRecipeController', [
  '$scope', '$routeParams', 'RecipeService', 'TokenfieldHelpers', 'DropZoneHelpers',
  ($scope, $routeParams, RecipeService, tfHelpers, dz)->
    $scope.formTitle = "Редактировать рецепт"
    $scope.edit = true

    $scope.loadComponents = (components)->
      for i in components
        $scope.editCtrlScope.addComponent(i.title); continue

    $scope.loadTags = (tags)->
      $scope.tags = (i.title for i in tags)
      tfHelpers.getInstance().setTokens $scope.tags

    $scope.loadPhotos = (photos)->
      for photo in photos
        dz.addUploadedFile photo; continue

    RecipeService.edit($routeParams.id)
      .then((data)->
        $scope.recipe = data
        $scope.recipe.id = data.recipe.id

        ctrlElement = document.querySelector('[ng-controller=AddRecipeController]')
        $scope.editCtrlScope = angular.element(ctrlElement).scope()

        $scope.title = data.recipe.title
        $scope.text = data.recipe.text.replace(/<br>/g, "\n")
        $scope.serving = data.recipe.serving
        $scope.cook_time = data.recipe.cook_time

        $scope.loadComponents(data.components)
        $scope.loadTags(data.tags)
        $scope.loadPhotos(data.photos)
    )

    $scope.editRecipe = ($event)->
      $event.preventDefault()

      data = $scope.editCtrlScope.getFormData()

      unless $scope.editCtrlScope.alerts.length
        $scope.waiting = true
        recipe = $.extend({}, $scope.recipe, data)

        RecipeService.put(recipe)
          .then((data)-> 
            $scope.waiting = false
            $scope.editCtrlScope.alerts.push {type: "success", msg: data.message}
          , (data)->
            $scope.waiting = false
            $scope.editCtrlScope.alerts.push {type: "danger", msg: data.data.message}
          )

    $scope.$on('$destroy', ()->
      dz.instance.destroy.call dz.instance
      $scope.editCtrlScope.reset()
      $scope = {}
    )          
])