angular.module('receta').controller("AddRecipeController", ['$scope', '$http', 'DropZoneHelpers', 'TokenfieldHelpers', 'Component', 'Tag', 'RecipeService',
  ($scope,$http,dz,tf,Component,Tag,RecipeService)->
    tfCallback = (request, response) ->
      Tag.find request.term, (t)-> response(t)

    $scope.tfHelpers = tf.bind "tags"
    $scope.tfHelpers.init tfCallback

    dz.init()

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
      try
        $scope.dictionary.filter (word)->
          ~$scope.text.toLowerCase().indexOf word
      catch e
        console.log e

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

    $scope.getFormData = ()->
      $scope.alerts = []
      messages = {
        tags: { type: "danger", msg: "Нужно ввести теги (через запятую)" }
        photos: { type: "danger", msg: "Нужно загрузить фото" }
        components: { type: "danger", msg: "Нужно ввести ингредиенты" }
      }
      getComponents = ()->
        if $scope.components and $scope.components.length
          $scope.components.join(", ")
        else
          $scope.alerts.push messages.components; return

      getTags = ()->
        tokens = $scope.tfHelpers.getTokens()
        if tokens.length and tokens[0].length
          tokens.join(", ")
        else
          $scope.alerts.push messages.tags; return

      getPhotos = ()->
        photos = dz.getPhotos true
        if photos.length
          photos
        else
          $scope.alerts.push messages.photos; return

      getRecipe = ()->
        title: $scope.title
        text: $scope.text
        serving: $scope.serving
        cook_time: $scope.cook_time

      return { recipe: getRecipe(), components: getComponents(), photos: getPhotos(), tags: getTags() }

    $scope.reset = ()->
      $scope.title = ""
      $scope.text = ""
      $scope.tags = ""
      $scope.serving = ""
      $scope.cook_time = ""
      $scope.components = ""
      $scope.photos = ""
      $scope.tfHelpers.setTokens []
      dz.reset()

    $scope.submitRecipe = ($event)->
      $event.preventDefault()

      data = $scope.getFormData()

      unless $scope.alerts.length
        $scope.waiting = true
        RecipeService.create(data)
          .then((data)-> 
            $scope.alerts.push {type: "success", msg: data.message}
            $scope.waiting = false
            $scope.reset()
          ,(data)->
            $scope.waiting = false
            $scope.alerts.push {type: "danger", msg: data.data.message}
          )

    $scope.$on('$destroy', ()->
      dz.instance.destroy.call dz.instance
      $scope.reset()
      $scope = {}
    )
])