Q = require "q"
{tryFunc} = require "common/utils"

findElementByXpath = (xpath) ->
  return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue

foundElement = (xpath) ->

  isPresent = (xpath) ->
    return !!findElementByXpath(xpath)
  return tryFunc(_.partial(isPresent, xpath))


clickPlayer = (eventData) ->

  console.log 'path is', eventData.path
  p =  foundElement(eventData.path).then(->
    element = findElementByXpath(eventData.path)
    console.log 'element'
    console.log element
    element.click()
  )
  console.log 'promise'
  console.log p
  return p

eventPlayers = {
  'click': clickPlayer
}

playBack = (name, data) ->
  # data is one step
  return eventPlayers[name](data)

module.exports = {playBack}
