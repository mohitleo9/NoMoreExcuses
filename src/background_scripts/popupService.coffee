sendMessage = (message) ->
  chrome.tabs.query({active: true, currentWindow: true}, (tabs)->
    chrome.tabs.sendMessage(tabs[0].id, message)
  )

module.exports = {sendMessage}
