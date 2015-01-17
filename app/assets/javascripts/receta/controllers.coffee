recipes = 
    `[
        {
            "recipe":
            {
                "id":1,
                "title":"Салат с креветками",
                "text":"Вам потребуется:<br>- креветки 500 гр<br>- картофель 1 шт<br>- морковь 1шт,<br>- авокадо 1-2 часть<br>- яйца 2 шт<br>- соль<br>- желатин 2 ч<br>- вода о,5 стакана<br>- майонез<br>- сметана<br><br>Украшения:<br>- зелень<br>- лимон<br>- креветки<br><br>Приготовление:<br>Креветки отварить 3 минуты,с доб приправы для морепродуктов,соли,лаврового листа и перца горошком.Остудить и очистить<br>Желатин залить холодной водой и оставить набухать,далее растворить его на водяной бане,хорошо размешать.<br>Остудить.<br>Соединить сметану и майонез в равных пропорциях и доб желатин,перемешать.<br>Выбрать форму для салата,в которую будут укладываться все слои.Застелить плёнку пищевой плёнкой,так чтобы концы плёнки торчали с формы.<br>На дно формы укладываем очищенные креветки,смазать смесью из желатина и майонеза,Это первый слой.<br>Второй слой-варёные яйца тертые на тёрке.Посолить и смазать майонезом.<br>Третий слой-авокадо.Разрезать мякоть кубиками,сбрызнуть лимонным соком.Смазать майонезом.<br>Четвёртый слой-варёная морковь,нарезать на мелкие кубики и смазать майонезом,посолить.<br>Пятый слой-варёный картофель.На тёрке.Посолить и смазать майонезом.<br>Поставить форму с салатом в холодильник на 30 мин для пропитки и застывания.<br>Далее на большую,красивую тарелку переворачиваем форму и осторожно снимаем плёнку.Украшаем.<br>салат готов.",
                "serving":null,
                "cook_time":45,
                "rating":123
            },
            "components":
                [
                    {"title":"креветки"},
                    {"title":"картофель"},
                    {"title":"морковь"},
                    {"title":"авокадо"},
                    {"title":"яйца"},
                    {"title":"сметана"},
                    {"title":"майонез"},
                    {"title":"лимон"}
                ],
            "photos":
                [
                    {
                        "src":"http://cs540102.vk.me/c540103/v540103796/2c41b/bfxceZpuYCw.jpg",
                        "src_big":"http://cs540102.vk.me/c540103/v540103796/2c41c/D6K9hbmSjXc.jpg"
                    }
                ],
            "tags":
                [
                    {"title":"Салаты"}
                ]
        }
    ]`

Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output


class TokenfieldHelpers
    @keyInput = {}
    @sourceFn = {}

    constructor: (inputId)->
        @keyInput = $("#" + inputId);

    init: (autoCompleteSource, minLength = 2)->
        @sourceFn = autoCompleteSource
        tfparams = `{ autocomplete: { source: this.sourceFn, delay: 300, minLength: minLength, select: this.getSelectFn() }, showAutocompleteOnFocus: true }`
        @keyInput.tokenfield tfparams

    getSelectFn: ()->
        context = this
        updateFn = @updateTokens
        fn = (e)-> 
            updateFn.call(context)

    getTokens: ()->
        @keyInput.tokenfield('getTokensList').split(", ").unique();

    setTokens: (tokens, add = false, triggerChange = false)->
        @keyInput.tokenfield('setTokens', tokens, add, triggerChange)

    addToken: (token)->
        @setTokens(token, true)
        @updateTokens()

    updateTokens: ()->
        @setTokens(@getTokens())


class ToggleText
    toggle: ($event) ->
        target = $event.target
        @collapsed = !@collapsed
        $arrow = $(target).parent().parent().find("a.toggle-text")

        if(@collapsed)
            $(target).removeClass("collapsed")
            $arrow.text("▴")
            return
        else
            $(target).addClass("collapsed")
            $arrow.text("▾")
            return


controllers = angular.module('controllers',[])
controllers.controller("RecipesController", [ '$scope', '$http',
    ($scope,$http)->
        tfCallback = (request, response)->
            $http.post(
                '/components/find.json',
                {query: request.term}
            ).success((data)->
                components = (i.title for i in data)
                response( components )
            )

        $scope.tokenhelpers = new TokenfieldHelpers("keywords-inp")
        $scope.tokenhelpers.init tfCallback

        $(".keyword-ex-lnk").on("click", ()-> $scope.tokenhelpers.addToken $(this).text())

        $scope.recipes = recipes

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
])

class DropZoneHelpers
    @attached = false

    init: ->
        _self = this
        if not @attached
            try
                $("body").dropzone { 
                    url: "/photos", 
                    previewsContainer: "#previews", 
                    clickable: "#clickable",
                    maxFilesize: 1,
                    paramName: "upload[image]",
                    addRemoveLinks: true,
                    sending: _self.onSending
                    success: _self.onSuccess
                    removedfile: _self.onRemove
                }
            catch ignore
        @attached = true

    onSending: (file, xhr, formData)->
        formData.append "authenticity_token", $("input[name='authenticity_token']").val()

    onSuccess: (file, response)->
        $(file.previewTemplate).find(".dz-remove").attr("data-file-id", response.id)
        $(file.previewElement).addClass("dz-success")

    onRemove: (file)->
        id = $(file.previewTemplate).find(".dz-remove").attr("data-file-id")
        success = (data) ->
            $(file.previewTemplate).remove() if data.hasOwnProperty "success"

        $.ajax {type: "delete", url: "/photos/" + id, success: success}


controllers.controller("AddRecipeController", ['$scope', '$http',
    ($scope,$http)->
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
                ~$scope.text.indexOf word

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

        $scope.tfHelpers = new TokenfieldHelpers("tags")
        $scope.tfHelpers.init tfCallback

        dz = new DropZoneHelpers()
        dz.init()
])