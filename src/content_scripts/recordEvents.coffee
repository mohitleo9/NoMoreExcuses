registerClick = (resultCallback) ->
  document.addEventListener 'click', (event) ->
    element = event.target
    path = getXpath(element)
    resultCallback('click', {path})

# list of all handlers
eventHanlers = [registerClick]

# start listening for all the events
registerAllEvents = (resultCallback) ->
  for handler in eventHanlers
    handler(resultCallback)

module.exports = {registerAllEvents}
