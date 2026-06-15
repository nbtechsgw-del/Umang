function calculate() {
      let h = parseFloat(document.getElementById("hindi").value) || 0;
      let e = parseFloat(document.getElementById("english").value) || 0;
      let m = parseFloat(document.getElementById("maths").value) || 0;
      let s = parseFloat(document.getElementById("science").value) || 0;
      let a = parseFloat(document.getElementById("art").value) || 0;
      let c = parseFloat(document.getElementById("computer").value) || 0;

      let marks = [h, e, m, s, a, c];
      for (let i = 0; i < marks.length; i++) {
        if (marks[i] < 0 || marks[i] > 100) {
          alert("Marks should be between 0 and 100");
          return;
        }
      }

      let total = h + e + m + s + a + c;
      let percentage = total / 6;

      let grade = "";

      if (percentage >= 90) grade = "A+";
      else if (percentage >= 75) grade = "A";
      else if (percentage >= 60) grade = "B";
      else if (percentage >= 50) grade = "C";
      else if (percentage >= 40) grade = "D";
      else grade = "Fail";

      document.getElementById("total").value = total;
      document.getElementById("percentage").value = percentage.toFixed(2) + "%";
      document.getElementById("grade").value = grade;
}