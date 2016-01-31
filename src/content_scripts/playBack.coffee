findElementByXpath = (xpath) ->
  return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue

clickPlayer = (eventData) ->
  element = findElementByXpath(eventData.data.path)
  element.click()

eventPlayers = {
  'click': clickPlayer
}

playBack = (data) ->
  for eventData in data
    eventPlayers[eventData.name](eventData)

module.exports = {playBack}
