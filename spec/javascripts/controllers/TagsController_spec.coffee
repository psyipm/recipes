describe "TagsController", ->
  scope        = null
  ctrl         = null
  location     = null

  event        = { preventDefault: ()-> }

  getEventFor = (targetText)->
    $.extend(event, {target: $("<a>#{targetText}</a>")})

  setupController =(keywords)->
    inject(($rootScope, $controller, $location)->
      scope       = $rootScope.$new()
      location    = $location

      ctrl        = $controller("TagsController",
                                $scope: scope
                                $location: location
                                )
    )

  beforeEach(module("receta"))
  beforeEach(setupController())

  describe "addTag", ->
    search = null
    addTags = ()->
      scope.addTag getEventFor("торт")
      scope.addTag getEventFor("десерт")
      search = location.search()

    describe "should change location", ->
      beforeEach ()->
        addTags()

      it "url should contain 'tags' key", ->
        expect(search.hasOwnProperty("tags")).toEqual(true)

      it "tags property should be a string", ->
        expect(typeof search.tags.split).toEqual("function")

    describe "when multi search is off", ->
      beforeEach ()->
        scope.multiTagSearch = false
        addTags()

      it "should replace tag in search", ->
        data = search.tags.split(",")
        expect(data).toContain("десерт")
        expect(data).not.toContain("торт")

    describe "when multi is on", ->
      beforeEach ()->
        scope.multiTagSearch = true
        addTags()

      it "should add multiple tags delimited by comma to url", ->
        data = search.tags.split(",")
        expect(data).toContain("торт")
        expect(data).toContain("десерт")

  describe "clearTags", ->
    search = null
    beforeEach ()->
      scope.addTag getEventFor("торт")
      scope.addTag getEventFor("десерт")
      search = location.search()

    it "should remove all tags from search location", ->
      scope.clearTags(event)
      expect(location.search().hasOwnProperty("tags")).toEqual(false)
