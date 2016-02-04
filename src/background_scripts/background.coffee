_ = require "lodash"
Q = require "q"
RECORDING = false
currentRecordingSession = {}


class EventData
  constructor: ->
    @data = []

  addData: (name, data) =>
    @data.push({name: name, data: data})
    console.log @data

  clear: ->
    @data = []


sendMessage = (message, responseCallback) ->
  chrome.tabs.query({active: true, currentWindow: true}, (tabs) ->
    chrome.tabs.sendMessage(tabs[0].id, message, responseCallback)
  )

startRecording = ->
  allData.clear()
  sendMessage({recording: true})
  chrome.tabs.query({active: true, currentWindow: true}, (tabs) ->
    session({tab: tabs[0]})
  )

stopRecording = ->
  sendMessage({recording: false})
  session({})

window.recording = (recording) ->
  if recording?
    RECORDING = recording
    if recording
      startRecording()
    else
      stopRecording()
  else
    return RECORDING

window.session = (session) ->
  if session?
    # use as setter
    currentRecordingSession.data = session
  else
    return currentRecordingSession.data


window.play = ->
  # ugh chrome, why the fuck do you not return promises
  sendMessageP = (step) ->
    deferred = Q.defer()
    responseCallback = (data) ->
      if data.done?
        deferred.resolve()
      else
        deferred.reject()

    sendMessage({playBack: true, name: step.name, data: step.data}, responseCallback)
    return deferred.promise

  _.reduce(allData.data, (promise, step) ->
    return promise.then(->
      return sendMessageP(step)
    )
  , Q.when())

storeRecordingData = (name, data) ->
  allData.addData(name, data)


# init
chrome.extension.onMessage.addListener((request, sender, sendResponse) ->
  if request.message? and request.message == 'isRecording'
    if recording() and sender.tab.id == session().tab.id
      sendResponse({recording: true})
    else
      sendResponse({recording: false})

  else if request.message? and request.message == 'recordingData'
    storeRecordingData(request.name, request.data)
)

allData = new EventData
