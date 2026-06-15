function isPrime(num) {
      if (num < 2) return false;
      for (let i = 2; i <= Math.sqrt(num); i++) {
        if (num % i === 0) return false;
      }
      return true;
}

function generatePrimes() {
      let start = parseInt(document.getElementById("start").value);
      let end = parseInt(document.getElementById("end").value);
      let result = [];

      if (isNaN(start) || isNaN(end)) {
        alert("Please enter valid numbers");
        return;
      }

      if (start > end) {
        alert("Start should be less than End");
        return;
      }

      for (let i = start; i <= end; i++) {
        if (isPrime(i)) {
          result.push(i);
        }
      }

      document.getElementById("result").value = result.join(", ");
    }