console.log " I am background."

RECORDING = false

window.isRecording = ->
  return RECORDING

window.toggleRecording = ->
  RECORDING = !RECORDING
  return RECORDING

