{getXpath} = require "./domUtils"


class EventBinder
  constructor: (@eventName, @handler) ->

  register: ->
    document.addEventListener(@eventName, @handler)

  unregister: ->
    document.removeEventListener(@eventName, @handler)


clickHandlerMaker = (resultCallback) ->
  return (event) ->
    element = event.target
    path = getXpath(element)
    resultCallback('click', {path})


eventHanlerMakers = {
  'click': clickHandlerMaker
}


# global list of binders
eventBinders = []

# start listening for all the events
registerAllEvents = (resultCallback) ->
  console.log 'called ok'
  for eventName, maker of eventHanlerMakers
    binder = new EventBinder(eventName, maker(resultCallback))
    binder.register()
    eventBinders.push(binder)

unregisterAllEvents = ->
  for binder in eventBinders
    binder.unregister()

module.exports = {registerAllEvents, unregisterAllEvents}
