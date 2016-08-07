_ = require "lodash"
Q = require "q"
{tryFunc} = require "common/utils"
thenChrome = require('then-chrome/out/api')(Q.Promise)

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

  getData: =>
    return @data || []



activeTab = ->
  return thenChrome.tabs.query({active: true, currentWindow: true}).then (tabs) -> return tabs[0]

sendMessageActive = (message) ->
  return activeTab().then (tab)->
    return thenChrome.tabs.sendMessage(tab.id, message)

startRecording = ->
  allData.clear()
  sendMessageActive({recording: true})
  activeTab().then (tab) ->
    session({tab: tab})

stopRecording = ->
  sendMessageActive({recording: false})
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

window.getRecordingData = () ->
  return allData.getData()

window.session = (session) ->
  if session?
    # use as setter
    currentRecordingSession.data = session
  else
    return currentRecordingSession.data


window.play = ->
  ensureUrl = (step) ->
    checkUrl = (step) ->
      found = false
      if step.data.location?
        return activeTab().then((tab) ->
          if tab.url == step.data.location
            found = true
          return found
        )
    return tryFunc(_.partial(checkUrl, step))

  playStep = (step) ->
    deferred = Q.defer()
    responseCallback = (data) ->
      if data.done?
        deferred.resolve()
      else
        deferred.reject()

    sendMessageActive({playBack: true, name: step.name, data: step.data}).then(responseCallback)
    return deferred.promise.timeout(7000)

  _.reduce(allData.data, (promise, step) ->
    return promise.then(->
      return ensureUrl(step).then(-> return playStep(step))
    )
  , Q.when())

storeRecordingData = (name, data) ->
  allData.addData(name, data)

updatePopupData = () ->
  # something here
  chrome.runtime.sendMessage({message: "popupData", data: allData.getData()})

# init
chrome.extension.onMessage.addListener((request, sender, sendResponse) ->
  if request.message? and request.message == 'isRecording'
    if recording() and sender.tab.id == session().tab.id
      sendResponse({recording: true})
    else
      sendResponse({recording: false})

  else if request.message? and request.message == 'recordingData'
    storeRecordingData(request.name, request.data)
    updatePopupData()
)

allData = new EventData
