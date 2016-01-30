{registerAllEvents, unregisterAllEvents} = require "./recordEvents"
_ = require "lodash"


class EventData
  constructor: ->
    @data = []

  addData: (name, data) =>
    @data.push({name: name, data: data})
    console.log @data


setRecording = (recording) ->
  console.log " the recording is #{recording}"
  console.log recording
  if recording
    registerAllEvents(allData.addData)
  else
    unregisterAllEvents()


setupMessageListeners = ->
  chrome.runtime.onMessage.addListener((request, sender) ->
    if request.recording?
      setRecording(request.recording)
  )

# init code
setupMessageListeners()
allData = new EventData
