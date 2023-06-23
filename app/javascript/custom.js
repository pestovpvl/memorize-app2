window.speakText = function(text) {
  var utterance = new SpeechSynthesisUtterance(text);
  window.speechSynthesis.speak(utterance);
}


