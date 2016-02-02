findElementByXpath = (xpath) ->
  return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue

clickPlayer = (eventData) ->
  element = findElementByXpath(eventData.path)
  element.click()

eventPlayers = {
  'click': clickPlayer
}

playBack = (name, data) ->
  # data is one step
  eventPlayers[name](data)

module.exports = {playBack}
