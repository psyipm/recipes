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


controllers = angular.module('controllers',[])
controllers.controller("RecipesController", [ '$scope', '$http', 'TokenfieldHelpers',
    ($scope,$http,tf)->
        tfCallback = (request, response)->
            $http.post(
                '/components/find.json',
                {query: request.term}
            ).success((data)->
                components = (i.title for i in data)
                response( components )
            )

        $scope.tokenhelpers = tf.bind "keywords-inp"
        $scope.tokenhelpers.init tfCallback

        $(".keyword-ex-lnk").on("click", ()-> $scope.tokenhelpers.addToken $(this).text())

        $scope.recipes = []

        $scope.search = ()->
            $http.post(
                '/recipes/find.json',
                {selected: $scope.tokenhelpers.getTokens()}
            ).success((data)->
                $scope.recipes = data
            )

        t = new ToggleText()
        $scope.toggle = ($event)->
            t.toggle($event)

        $(".fotorama").fotorama()
])


controllers.controller("AddRecipeController", ['$scope', '$http', 'DropZoneHelpers', 'TokenfieldHelpers',
    ($scope,$http,dz,tf)->
        $scope.getComponents = ()->
            $http.post(
                '/components/get.json',
                {}
            ).success((data)->
                $scope.dictionary = data
                $scope.components = $scope.parseComponents()

                #debug
                console.log $scope.dictionary
                console.log $scope.components
            )

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
            $http.post(
                '/tags/find.json',
                {query: request.term}
            ).success((data)->
                tags = (i.title for i in data)
                response( tags )
            )

        $scope.tfHelpers = tf.bind "tags"
        $scope.tfHelpers.init tfCallback

        dz.init()
])