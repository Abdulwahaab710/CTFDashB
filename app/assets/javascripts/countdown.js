// Set the date we're counting down to
$(document).ready(
  function() {
    var countDownDate = new Date($('#countdown').data('countdown').toString()).getTime();

    // Update the count down every 1 second
    var x = setInterval(function() {

      // Get todays date and time
      var now = new Date().getTime();

      // Find the distance between now and the count down date
      var distance = countDownDate - now;

      // Time calculations for days, hours, minutes and seconds
      var days = Math.floor(distance / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);

      // Output the result in an element with id="countdown"
      var timeLeft = '';
      if(days > 0) { timeLeft += `${days} d `; }
      if(hours > 0) { timeLeft += `${hours} h `; }
      if(minutes > 0) { timeLeft += `${minutes} m `; }
      if(seconds > 0) { timeLeft += `${seconds} s `; }
      document.getElementById("countdown").textContent = timeLeft;

      // If the count down is over, write some text
      if (distance < 0) {
        clearInterval(x);
        location.reload
      }
    }, 1000);
  }
)
