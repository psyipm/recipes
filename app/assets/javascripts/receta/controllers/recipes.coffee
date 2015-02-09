Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output

angular.module('receta').controller("RecipesController", ['$scope','$location','TokenfieldHelpers','Component','RecipeService', 
  ($scope,$location,tf,Component,RecipeService)->
    $scope.tfCallback = (request, response)->
      Component.find(request.term, (c)-> response(c))

    $scope.tokenhelpers = tf.bind "keywords-inp"
    $scope.tokenhelpers.init $scope.tfCallback

    $(".keyword-ex-lnk").on("click", ()-> $scope.tokenhelpers.addToken $(this).text())

    $scope.recipes = []
    $scope.offset = 0

    searchCallback = (recipes, replace = false)->
      $scope.no_more = false
      $scope.recipes = unless replace is true then recipes else [].concat($scope.recipes, recipes)
      unless recipes.length < 10
        $scope.offset += 10
      else
        $scope.no_more = true
      $("#more").attr("disabled", $scope.no_more)

    $scope.search = (load_more = false)->
      try
        tokens = $scope.tokenhelpers.getTokens()
        $location.search("components", tokens.join(","))
        RecipeService.find({tokens: tokens}, $scope.offset).then((res)-> searchCallback res, load_more) if load_more is true
      catch e
        console.log e   

    $scope.searchFromLocation = ()->
      search = $location.search()
      query = {}
      if search.hasOwnProperty "components"
        $scope.tokenhelpers.setTokens search.components
        query = $.extend true, query, {tokens: $scope.tokenhelpers.getTokens()}
      if search.hasOwnProperty "tags"
        query = $.extend true, query, {tags: search.tags.split(",")}

      RecipeService.find(query, $scope.offset).then((res)-> searchCallback res) unless $.isEmptyObject query

    $(".fotorama").fotorama()

    $scope.searchFromLocation()
])