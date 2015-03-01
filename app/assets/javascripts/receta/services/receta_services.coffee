angular.module('recetaServices', [
	'LocalStorageModule',
	'angular-md5'
])

.config(['localStorageServiceProvider',(localStorageServiceProvider)->
	localStorageServiceProvider
		.setStorageType('localStorage')
		.setPrefix('receta')
		
	return
])