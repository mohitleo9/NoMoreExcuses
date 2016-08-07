Q = require "q"
# a function that tries a function for timeout, times with interval timeInterval,
# and returns a promise which resolves with the return value of the function.
# The test to see if a function passed is usually a false value but can be customized with testFunc
# The TestFunc should return a truthy value to pass (can be a promise)

tryFunc = (func, qtimeout=5000, qinterval=400,  testFunc) ->
  if not testFunc?
    testFunc = (func) ->
      return func()
  deferred = Q.defer()
  promise = deferred.promise.timeout(qtimeout)

  chain = ->
    Q.when(testFunc(func)).then((result)->
      if result
        deferred.resolve(result)
      else if promise.isPending()
        setTimeout(chain, qinterval)
    )

  chain()
  return deferred.promise.timeout(qtimeout)

module.exports = {tryFunc}
