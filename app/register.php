<head>
    <title>Register</title>
    <link rel="stylesheet" href="style.css">
</head>


<?php
require 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username']);
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT);
    $role = $_POST['role'];

    try {
        $stmt = $conn->prepare(
            "INSERT INTO users (username, password, role) VALUES (?, ?, ?)"
        );
        $stmt->execute([$username, $password, $role]);
        echo "User registered successfully!";
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Register User</title>
</head>
<body>
<h2>Register (Testing Only)</h2>
<form method="POST">
    Username: <input type="text" name="username" required><br><br>
    Password: <input type="password" name="password" required><br><br>
    Role:
    <select name="role">
        <option value="vet">Vet</option>
        <option value="receptionist">Receptionist</option>
    </select><br><br>
    <button type="submit">Register</button>
</form>
</body>
</html>
