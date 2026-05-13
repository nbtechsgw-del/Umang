<?php
session_start();
include 'db_connect.php';

$email = mysqli_real_escape_string($conn, $_POST['email']);
$password = $_POST['password'];

$sql = "SELECT * FROM users WHERE email = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();

    if ($password === $user['password']) {
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_role'] = $user['role'];
        $_SESSION['user_name'] = $user['name'];
        
        echo $user['role'];
    } else {
        echo "error";
    }
} else {
    echo "error";
}
?>