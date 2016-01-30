console.log " I am background."

RECORDING = false

window.toggleRecording = ->
  RECORDING = !RECORDING
  return RECORDING

