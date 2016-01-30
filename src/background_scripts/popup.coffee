setRecording = () ->
  chrome.tabs.query({active: true, currentWindow: true}, (tabs)->
    recording = chrome.extension.getBackgroundPage().toggleRecording()
    chrome.tabs.sendMessage(tabs[0].id, {recording})
  )

setUpListeners = ->
  document.getElementById('recording-button').addEventListener('click', setRecording)


# init
setUpListeners()
