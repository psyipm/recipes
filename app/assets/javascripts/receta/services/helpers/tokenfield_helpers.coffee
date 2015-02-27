angular.module('recetaServices')
.service('TokenfieldHelpers', ['$rootScope', ($rootScope)->
	$scope = $rootScope.$new()

	class TokenfieldHelpers
		constructor: (inputId) ->
			@keyInput = $("#"+inputId)
		
		init: (data, minLength = 2)->
			engine = new Bloodhound(
				local: $.map(data, (item)-> return { value: item }; )
				datumTokenizer: (d)->
					Bloodhound.tokenizers.whitespace(d.value)
				queryTokenizer: Bloodhound.tokenizers.whitespace
			)
			engine.initialize()
			tfparams = { 
				typeahead: [{hint: true, highlight: true}, { source: engine.ttAdapter() }], 
				createTokensOnBlur: true 
				showAutocompleteOnFocus: true 
			}
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