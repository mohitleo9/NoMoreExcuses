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
  ensureUrl = (step) ->
    console.log 'step'
    console.log step
    deferred = Q.defer()

    checkUrl = (step) ->
      console.log 'stepping'
      console.log step
      if step.data.location?
        console.log 'query'
        chrome.tabs.query({active: true, currentWindow: true}, (tabs) ->
          console.log 'tabs'
          console.log tabs[0].url
          console.log tabs[0].url
          if tabs[0].url == step.data.location
            deferred.resolve(step)
          else setTimeout(_.partial(checkUrl, step), 100)
        )
    checkUrl(step)

    forceResolve = ->
      console.log 'forcing ensureUrl'
      deferred.resolve()
    setTimeout(forceResolve, 4000)
    return deferred.promise



  sendMessageP = (step) ->
    console.log 'sending step now'
    console.log step
    deferred = Q.defer()
    responseCallback = (data) ->
      console.log 'resolved'
      if data.done?
        deferred.resolve()
      else
        deferred.reject()

      forceResolve = ->
        console.log 'forcing'
        deferred.resolve()
      setTimeout(forceResolve, 4000)

    sendMessage({playBack: true, name: step.name, data: step.data}, responseCallback)
    return deferred.promise

  _.reduce(allData.data, (promise, step) ->
    return promise.then(->
      return ensureUrl(step).then(-> return sendMessageP(step))
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
