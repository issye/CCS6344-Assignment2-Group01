<?php
session_start();
include 'db_connect.php';

if ($_SESSION['role'] != 'vet') {
    header("Location: login.php");
    exit();
}

// Get pet ID from query
$id = $_GET['id'] ?? null;
if (!$id) {
    die("Pet ID not specified.");
}

// Fetch pet data
$stmt = $conn->prepare("SELECT * FROM pets WHERE id = ?");
$stmt->execute([$id]);
$pet = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$pet) {
    die("Pet not found.");
}

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pet_name      = trim($_POST['pet_name']);
    $owner         = trim($_POST['owner_name']);
    $contact       = trim($_POST['owner_contact']);
    $diagnosis     = trim($_POST['diagnosis']);
    $treatment_fee = trim($_POST['treatment_fee']);
    $age           = trim($_POST['age']);

    $stmt = $conn->prepare(
        "UPDATE pets SET pet_name=?, owner_name=?, owner_contact=?, diagnosis=?, treatment_fee=?, age=? WHERE id=?"
    );
    $stmt->execute([$pet_name, $owner, $contact, $diagnosis, $treatment_fee, $age, $id]);

    // --- Audit log ---
    $stmtLog = $conn->prepare(
        "INSERT INTO audit_log (user_id, action_type, details) VALUES (?, ?, ?)"
    );
    $stmtLog->execute([
        $_SESSION['user_id'],
        'Edit Pet',
        "Edited pet ID $id: Name=$pet_name, Owner=$owner, Fee=$treatment_fee"
    ]);

    header("Location: pets_list_vet.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Pet Record (Vet)</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<h2>Edit Pet Record</h2>

<form method="POST">
    Pet Name: <input type="text" name="pet_name" value="<?= htmlspecialchars($pet['pet_name']) ?>" required><br>
    Owner Name: <input type="text" name="owner_name" value="<?= htmlspecialchars($pet['owner_name']) ?>" required><br>
    Contact: <input type="text" name="owner_contact" value="<?= htmlspecialchars($pet['owner_contact']) ?>" required><br>
    Diagnosis: <input type="text" name="diagnosis" value="<?= htmlspecialchars($pet['diagnosis']) ?>"><br>
    Treatment Fee: <input type="number" step="0.01" name="treatment_fee" value="<?= htmlspecialchars($pet['treatment_fee']) ?>"><br>
    Age: <input type="number" name="age" value="<?= htmlspecialchars($pet['age']) ?>" required><br><br>
    <button type="submit">Update</button>
</form>

<br>
<a href="pets_list_vet.php">⬅ Back</a>

</body>
</html>
