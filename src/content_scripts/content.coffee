_ = require "lodash"
{registerAllEvents, unregisterAllEvents} = require "./recordEvents"
{playBack} = require "./playBack"


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
    console.log request
    if request.recording?
      setRecording(request.recording)
    else if request.playBack? and request.playBack
      console.log 'called playback'
      console.log allData.data
      playBack(allData.data)
  )

# init code
setupMessageListeners()
allData = new EventData
