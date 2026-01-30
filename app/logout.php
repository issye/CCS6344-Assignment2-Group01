<head>
    <title>Logout</title>
    <link rel="stylesheet" href="style.css">
</head>


<?php
session_start();
session_unset();
session_destroy();

header("Location: login.php");
exit;
