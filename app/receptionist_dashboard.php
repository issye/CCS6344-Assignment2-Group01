<?php
session_start();
if ($_SESSION['role'] != 'receptionist') {
    header("Location: login.php");
    exit();
}
?>

<!DOCTYPE html>
<html>
    <head>
        <title>Receptionist Dashboard</title>
        <link rel="stylesheet" href="style.css">
</head>
<body>

<h2>Receptionist Dashboard</h2>

<ul>
    <li><a href="pets_list_receptionist.php">🐾 Manage Pets</a></li>
    <li><a href="login.php">Logout</a></li>
</ul>

</body>
</html>