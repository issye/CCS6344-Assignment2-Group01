<?php
session_start();
if ($_SESSION['role'] != 'vet') {
    header("Location: login.php");
    exit();
}
?>

<!DOCTYPE html>
<html>
    <head>
        <title>Vet Dashboard</title>
        <link rel="stylesheet" href="style.css">
</head>
<body>

<h2>Vet Dashboard</h2>

<ul>
    <li><a href="pets_list_vet.php">🐾 Manage Pets</a></li>
    <li><a href="audit_log.php">📜 View Audit Log</a></li>
    <li><a href="logout.php">Logout</a></li>
</ul>

</body>
</html>