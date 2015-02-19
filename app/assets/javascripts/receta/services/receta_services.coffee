angular.module('recetaServices', [
	'LocalStorageModule'
])

.config((localStorageServiceProvider)->
	localStorageServiceProvider
		.setPrefix 'receta'
)