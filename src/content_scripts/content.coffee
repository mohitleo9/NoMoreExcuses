{getXpath} = require "./domUtils"

registerClick = (resultCallback) ->
  document.addEventListener 'click', (event) ->
    element = event.target
    path = getXpath(element)
    resultCallback('click', {path})


class EventData
  constructor: ->
    @data = []

  addData: (name, data) =>
    @data.push({name: name, data: data})
    console.log @data


console.log "msg"
console.log "msg"
console.log "msg"
console.log "msg"
# init code
allData = new EventData
registerClick(allData.addData)
