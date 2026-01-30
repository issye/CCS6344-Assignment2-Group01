<?php
session_start();
include 'db_connect.php';

// Ensure only receptionists can access
if ($_SESSION['role'] != 'receptionist') {
    header("Location: login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    // Collect input
    $pet_name      = trim($_POST['pet_name'] ?? '');
    $owner         = trim($_POST['owner_name'] ?? '');
    $contact       = trim($_POST['owner_contact'] ?? '');
    $diagnosis     = trim($_POST['diagnosis'] ?? '');
    $treatment_fee = trim($_POST['treatment_fee'] ?? '');
    $age           = trim($_POST['age'] ?? '');

    // Server-side validation
    if (empty($pet_name) || empty($owner) || empty($contact) || empty($age)) {
        die("Invalid input: Name, Owner, Contact, and Age are required.");
    }

    // Insert using prepared statement
    $stmt = $conn->prepare("
        INSERT INTO pets (pet_name, owner_name, owner_contact, diagnosis, treatment_fee, age)
        VALUES (?, ?, ?, ?, ?, ?)
    ");

    $stmt->execute([
        $pet_name,
        $owner,
        $contact,
        $diagnosis,
        $treatment_fee,
        $age
    ]);

    // --- Audit log ---
    $stmtLog = $conn->prepare(
        "INSERT INTO audit_log (user_id, action_type, details) VALUES (?, ?, ?)"
    );
    $stmtLog->execute([
        $_SESSION['user_id'],
        'Add Pet',
        "Receptionist added pet: Name=$pet_name, Owner=$owner, Fee=$treatment_fee"
    ]);

    $_SESSION['success'] = "Pet record added successfully.";

    header("Location: pets_list_receptionist.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Pet (Receptionist)</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<h2>Add Pet Record</h2>

<form method="post">
    Pet Name: <input type="text" name="pet_name" required><br>
    Owner Name: <input type="text" name="owner_name" required><br>
    Contact: <input type="text" name="owner_contact" required><br>
    Diagnosis: <input type="text" name="diagnosis"><br>
    Treatment Fee: <input type="number" step="0.01" name="treatment_fee"><br>
    Age: <input type="number" name="age" required><br><br>
    <button type="submit">Save</button>
</form>

<br>
<a href="pets_list_receptionist.php">⬅ Back</a>

</body>
</html>
