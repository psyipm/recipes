Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output


class ToggleText
    toggle: ($event) ->
        target = $event.target
        console.log $event
        collapsed = $(target).hasClass("collapsed")
        $arrow = $(target).parent().parent().find("a.toggle-text")

        if(collapsed)
            $(target).removeClass("collapsed")
            $arrow.text("▴")
            return
        else
            $(target).addClass("collapsed")
            $arrow.text("▾")
            return


angular.module('receta').controller("RecipesController", ['$scope','$location','TokenfieldHelpers','Component','Recipe', 
    ($scope,$location,tf,Component,Recipe)->
        $scope.tfCallback = (request, response)->
          Component.find(request.term, (c)-> response(c))

        $scope.tokenhelpers = tf.bind "keywords-inp"
        $scope.tokenhelpers.init $scope.tfCallback

        $(".keyword-ex-lnk").on("click", ()-> $scope.tokenhelpers.addToken $(this).text())

        $scope.recipes = []
        $scope.offset = 0

        searchCallback = (recipes)->
          $scope.no_more = false
          $scope.recipes = [].concat($scope.recipes, recipes)
          unless recipes.length < 10
            $scope.offset += 10
          else
            $scope.no_more = true
          $("#more").attr("disabled", $scope.no_more)

        $scope.search = ()->
          try
            tokens = $scope.tokenhelpers.getTokens()
            $location.search("components", tokens.join(","))
            Recipe.find {tokens: tokens}, searchCallback, $scope.offset
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

          Recipe.find query, searchCallback, $scope.offset unless $.isEmptyObject query

        $scope.addTag = (text)->
          search = $location.search()
          if search.hasOwnProperty("tags")
            tags = search.tags.split(",")
            tags.push text unless text in tags
            value = tags.join(",")
          else
            value = text
          search = $.extend true, search, {tags: value}
          $scope.search()

        $scope.clearTags = ()->
          params = {}
          for key, val of $location.search()
            params[key] = val unless key is "tags"

          $location.search(params)
          $scope.search()

        t = new ToggleText()
        $scope.toggle = ($event)->
            t.toggle($event)

        $(".fotorama").fotorama()
        $("#tagcloud").tx3TagCloud()
        $(".tag").on("click", (e)-> e.preventDefault(); $scope.addTag $(this).text())
        $(".clear-tags").on("click", (e)-> e.preventDefault(); $scope.clearTags())
        $scope.searchFromLocation()
])