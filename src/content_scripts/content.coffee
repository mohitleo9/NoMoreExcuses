_ = require "lodash"
{registerAllEvents, unregisterAllEvents} = require "./recordEvents"
{playBack} = require "./playBack"


resultCallback = (name, data) ->
  chrome.runtime.sendMessage({message: 'recordingData', name, data})


setRecording = (recording) ->
  console.log " the recording is #{recording}"
  console.log recording
  if recording
    registerAllEvents(resultCallback)
  else
    unregisterAllEvents()


setupMessageListeners = ->
  chrome.runtime.onMessage.addListener((request, sender, sendResponse) ->
    console.log request
    if request.recording?
      setRecording(request.recording)
    else if request.playBack? and request.playBack
      playBack(request.name, request.data).then(->
        sendResponse({done: 'ok'})
      )
      # return true so we can send response later!!.
      return true
  )

getRecordingState = ->
  # this is called on first time loading to get the initial recording state.
  chrome.runtime.sendMessage({message: 'isRecording'}, (response) ->
    setRecording(response.recording)
  )

# init code
getRecordingState()
setupMessageListeners()
