import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "output", "spinner", "word"];

  generate() {
    this.spinnerTarget.style.display = 'block';
    this.buttonTarget.setAttribute('disabled', true);
    const word = this.buttonTarget.dataset.word;
    fetch(`/api/gpt/${word}`)
      .then(response => {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.json();
      })
      .then(data => {
        console.log(data); // Log the data here
        this.spinnerTarget.style.display = 'none';
        this.buttonTarget.removeAttribute('disabled');
        this.outputTarget.innerText = data.result;
      })
      .catch(error => {
        console.error('There has been a problem with your fetch operation:', error);
        this.spinnerTarget.style.display = 'none';
        this.buttonTarget.removeAttribute('disabled');
      });
  }
  
}