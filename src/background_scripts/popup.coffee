sendMessage = (message) ->
  chrome.tabs.query({active: true, currentWindow: true}, (tabs)->
    chrome.tabs.sendMessage(tabs[0].id, message)
  )

setRecording = () ->
  recording = chrome.extension.getBackgroundPage().toggleRecording()
  sendMessage({recording})

playBack = ->
  console.log 'sending'
  sendMessage({playBack: true})

setUpListeners = ->
  document.getElementById('recording-button').addEventListener('click', setRecording)
  document.getElementById('playback-button').addEventListener('click', playBack)


# init
setUpListeners()
