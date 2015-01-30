angular.module('receta').controller("AddRecipeController", ['$scope', '$http', 'DropZoneHelpers', 'TokenfieldHelpers', 'Component', 'Tag',
  ($scope,$http,dz,tf,Component,Tag)->
    $scope.getComponents = ()->
      Component.get (data)->
        $scope.dictionary = data
        $scope.components = $scope.parseComponents()

        #debug
        console.log $scope.dictionary
        console.log $scope.components

    pushToArray = (word, array) ->
      return array unless word
      word = word.toLowerCase()
      array.push word unless word in array
      array

    filterRemoved = ()->
      $scope.components.filter (val)->
        val not in $scope.user_removed

    mergeWithCreated = ()->
      [].concat.apply($scope.user_created, $scope.components).unique()

    $scope.parseComponents = ()->
      $scope.dictionary.filter (word)->
        ~$scope.text.toLowerCase().indexOf word

    $scope.textChanged = ()->
      return $scope.getComponents() unless $scope.dictionary
      $scope.components = $scope.parseComponents()
      $scope.components = mergeWithCreated()
      $scope.components = filterRemoved()

    $scope.user_created = []
    $scope.addComponent = (word)->
      $scope.user_created = pushToArray(word, $scope.user_created)
      $scope.user_removed = $scope.user_removed.filter (val) -> val.toLowerCase() != word.toLowerCase()
      $scope.components = mergeWithCreated()
      $scope.components = filterRemoved()
      this.newcmp = ""

    $scope.user_removed = []
    $scope.removeComponent = (word)->
      $scope.user_removed = pushToArray(word, $scope.user_removed)
      $scope.components = filterRemoved()

    tfCallback = (request, response) ->
      Tag.find request.term, (t)-> response(t)

    $scope.tfHelpers = tf.bind "tags"
    $scope.tfHelpers.init tfCallback

    $scope.submitRecipe = ()->
      recipe = $("form").serialize()
      console.log recipe

    dz.init()
])