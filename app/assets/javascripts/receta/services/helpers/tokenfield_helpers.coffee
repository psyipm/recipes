angular.module('recetaServices')
.service('TokenfieldHelpers', ['$rootScope', ($rootScope)->
	$scope = $rootScope.$new()

	class TokenfieldHelpers
		constructor: (inputId) ->
			@keyInput = $("#"+inputId)
			@sourceFn = {}
		
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
			try
				@keyInput.tokenfield('getTokensList').split(", ").unique()
			catch e
				[]

		setTokens: (tokens, add = false, triggerChange = false)->
			@keyInput.tokenfield('setTokens', tokens, add, triggerChange)

		addToken: (token)->
			@setTokens(token, true)
			@updateTokens()

		updateTokens: ()->
			@setTokens(@getTokens())

	bind: (inputId)->
		$scope.instance = new TokenfieldHelpers inputId

	getInstance: ()->
		$scope.instance
])