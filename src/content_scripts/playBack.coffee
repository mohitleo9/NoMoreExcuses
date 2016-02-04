Q = require "q"

findElementByXpath = (xpath) ->
  return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue

clickPlayer = (eventData) ->
  deferred = Q.defer()

  element = findElementByXpath(eventData.path)
  element.click()
  setTimeout(deferred.resolve, 3000)
  return deferred.promise

eventPlayers = {
  'click': clickPlayer
}

playBack = (name, data) ->
  # data is one step
  return eventPlayers[name](data)

module.exports = {playBack}
