window.addEventListener("load", function() {
  $('#listen-word-btn').on('click', function() {
    speechSynthesis.speak(
      new SpeechSynthesisUtterance(
        $(this).closest('#wrap-word-card-elem').find('#card-word').text().trim()
      )
    );
  });
});