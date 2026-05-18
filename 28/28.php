<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $dob1_raw = $_POST['dob1'];
    $dob2_raw = $_POST['dob2'];

    $p1 = new DateTime($dob1_raw);
    $p2 = new DateTime($dob2_raw);
    $today = new DateTime();

    $age1 = $today->diff($p1)->y;
    $age2 = $today->diff($p2)->y;

    echo "<h2>Comparison Results</h2>";
    
    echo "<table border='1' cellpadding='10' style='border-collapse: collapse; text-align: left;'>
            <tr style='background-color: #f2f2f2;'>
                <th>Pattern / Data</th>
                <th>Person 1</th>
                <th>Person 2</th>
            </tr>
            <tr>
                <td><strong>DD-Month-YYYY</strong></td>
                <td>" . $p1->format('d-F-Y') . "</td>
                <td>" . $p2->format('d-F-Y') . "</td>
            </tr>
            <tr>
                <td><strong>DD/MM/YY</strong></td>
                <td>" . $p1->format('d/m/y') . "</td>
                <td>" . $p2->format('d/m/y') . "</td>
            </tr>
            <tr>
                <td><strong>YYYYMMDD</strong></td>
                <td>" . $p1->format('Ymd') . "</td>
                <td>" . $p2->format('Ymd') . "</td>
            </tr>
            <tr style='background-color: #e8f4fd;'>
                <td><strong>Current Age</strong></td>
                <td>" . $age1 . " Years</td>
                <td>" . $age2 . " Years</td>
            </tr>
          </table>";

    echo "<br><hr>";

    if ($p1 > $p2) {
        echo "<h3>Result: Person 1 is Younger.</h3>";
    } elseif ($p2 > $p1) {
        echo "<h3>Result: Person 2 is Younger.</h3>";
    } else {
        echo "<h3>Result: Both are born on the same day!</h3>";
    }

    echo "<br><a href='28.html'><button>Change Dates</button></a>";
}
?>