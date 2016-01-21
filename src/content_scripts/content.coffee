{getXpath} = require "./domUtils"
{registerAllEvents} = require "./recordEvents"
_ = require "lodash"


class EventData
  constructor: ->
    @data = []

  addData: (name, data) =>
    @data.push({name: name, data: data})
    console.log @data


# init code
allData = new EventData
registerAllEvents(allData.addData)
