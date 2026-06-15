<?php
$servername = "localhost";
$username = "root";     // Default XAMPP username
$password = "Umang@23SQL";         // Default XAMPP password is empty
$dbname = "exam_system"; // The name of the DB you created

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>