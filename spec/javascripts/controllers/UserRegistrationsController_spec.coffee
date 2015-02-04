describe "UserRegistrationsController", ->
  scope        = null
  ctrl         = null
  location     = null
  rootScope    = null
  auth         = null

  setupController =(keywords)->
    inject(($rootScope, $controller, $location, $auth)->
      rootScope   = $rootScope
      scope       = $rootScope.$new()
      location    = $location
      auth        = $auth

      ctrl        = $controller("UserRegistrationsController",
                                $scope: scope
                                $location: location
                                )
    )

  beforeEach(module("receta"))
  beforeEach(setupController())

  describe "on init", ->
    it "should not display ajax-loader", ->
      expect(scope.waiting).not.toEqual(true)

  describe "on submit", ->
    beforeEach ->
      try
        scope.handleRegBtnClick()
      catch ignore
        # ...

    it "should display ajax-loader", ->
      expect(scope.waiting).toEqual(true)

  describe "on successfull registration", ->
    beforeEach ->
      rootScope.$broadcast('auth:registration-email-success', {"status":"success","data":{}})

    it "should display success message", ->
      expect(scope.alerts[0]).toEqual(jasmine.objectContaining({ type : 'success' }))

    it "should hide ajax-loader", ->
      expect(scope.waiting).not.toEqual(true)

  describe "on error", ->
    beforeEach ->
      rootScope.$broadcast('auth:registration-email-error', {"status":"error","data":{},"errors":{"email":["This email address is already in use"],"full_messages":["Email This email address is already in use"]}})

    it "should display error message", ->
      expect(scope.alerts[0]).toEqual(jasmine.objectContaining({ type : 'danger' }))

    it "should hide ajax-loader", ->
      expect(scope.waiting).not.toEqual(true)

  describe "on confirmation", ->
    beforeEach ->
      location.hash("?account_confirmation_success=true&client_id=p")
      setupController()

    it "should redirect to login and clear hash", ->
      expect(location.path()).toEqual('/users/login')
      expect(location.hash()).toEqual('')