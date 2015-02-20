angular.module('recetaServices').service('queryCache', [
	'md5', 'localStorageService', '$q',
	(md5, localStorageService, $q)->
		_expire = 10 * 60 * 1000 # minutes
		_prefix = "recipe_cache"

		_getKey = (query)->
			querystring = JSON.stringify query
			hash = md5.createHash(querystring)
			return "#{_prefix}_#{hash}"

		_isExpired = (query, cached)->
			now = Date.now()
			try
				# debug
				console.log "will expire in: #{(_expire-(now-cached.timestamp))/1000/60} minutes"

				if cached.timestamp and (now-cached.timestamp) > _expire
					remove(query)
					return true
				else
					return false
			catch ignore
				return true

		cache = (query, data)->
			timestamp = Date.now()
			key = _getKey(query)
			data = {data: data, timestamp: timestamp}
			localStorageService.set(key, data)

		remove = (query)->
			key = _getKey(query)
			localStorageService.remove(key)

		get = (query)->
			key = _getKey(query)
			localStorageService.get(key)

		clearAll = ()->
			for key in localStorageService.getKeys()
				localStorageService.remove(key) if key.indexOf _prefix == 0
			return

		fromCache = (query, callback)->
			cached = get(query)
			unless _isExpired(query, cached)
				$q((resolve, reject)-> resolve(cached.data); return)
			else
				# debug
				console.log "expired"
				promise = callback()
				promise
					.then((data)-> cache(query, data))
				return promise

		return {
			cache: cache
			remove: remove
			get: get
			clearAll: clearAll
			fromCache: fromCache
		}
])