angular.module('recetaServices').service('queryCache', [
  'md5', 'localStorageService', '$q',
  (md5, localStorageService, $q)->
    class QueryCache
      constructor: (prefix = "query_cache", expire = 10, multiplier = 60 * 1000) ->
        @expire = expire * multiplier #minutes
        @prefix = prefix
        @multiplier = multiplier

      getKey: (query)->
        querystring = JSON.stringify query
        hash = md5.createHash(querystring)
        return "#{@prefix}_#{hash}"

      isExpired: (query, cached)->
        now = Date.now()
        try
          # debug
          console.log "will expire in: #{(@expire-(now-cached.timestamp))/@multiplier} minutes"

          if cached.timestamp and (now-cached.timestamp) > @expire
            @remove(query)
            return true
          else
            return false
        catch ignore
          return true

      cache: (query, data)->
        timestamp = Date.now()
        key = @getKey(query)
        data = { data: data, timestamp: timestamp }
        localStorageService.set(key, data)

      remove: (query)->
        key = @getKey(query)
        localStorageService.remove(key)

      get: (query)->
        key = @getKey(query)
        localStorageService.get(key)

      clearAll: ()->
        for key in localStorageService.keys()
          localStorageService.remove(key) if key.indexOf(@prefix) == 0
        return

      fromCache: (query, callback)->
        cached = @get(query)
        _self = this
        unless @isExpired(query, cached)
          $q((resolve, reject)-> resolve(cached.data); return)
        else
          # debug
          console.log "expired"
          promise = callback()
          promise
            .then((data)-> _self.cache(query, data))
          return promise
        
    return {
      configure: (pr, ex, ml)-> new QueryCache(pr, ex, ml)
    }
])