<html>
<head>
    <title>PHP Calculator</title>
    <style>
        body { font-family: sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; padding-top: 50px; }
        .calc-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 300px; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        input[type="submit"] { background-color: #28a745; color: white; border: none; cursor: pointer; font-size: 16px; }
        input[type="submit"]:hover { background-color: #218838; }
        .result { margin-top: 15px; padding: 10px; background-color: #e9ecef; border-radius: 4px; text-align: center; font-weight: bold; }
    </style>
</head>
<body>

<div class="calc-card">
    <h2 style="text-align:center;">PHP Calculator</h2>
    <form method="POST">
        <input type="number" name="num1" placeholder="First Number" step="any" required>
        
        <select name="operator">
            <option value="add">Add (+)</option>
            <option value="subtract">Subtract (-)</option>
            <option value="multiply">Multiply (*)</option>
            <option value="divide">Divide (/)</option>
        </select>

        <input type="number" name="num2" placeholder="Second Number" step="any" required>
        
        <input type="submit" name="submit" value="Calculate">
    </form>

    <?php
    if (isset($_POST['submit'])) {
        $n1 = $_POST['num1'];
        $n2 = $_POST['num2'];
        $op = $_POST['operator'];
        $res = "";
        switch ($op) {
            case "add":
                $res = $n1 + $n2;
                break;
            case "subtract":
                $res = $n1 - $n2;
                break;
            case "multiply":
                $res = $n1 * $n2;
                break;
            case "divide":
                if ($n2 != 0) {
                    $res = $n1 / $n2;
                } else {
                    $res = "Error: Cannot divide by zero";
                }
                break;
        }
        echo "<div class='result'>Result: $res</div>";
    }
    ?>
</div>

</body>
</html>