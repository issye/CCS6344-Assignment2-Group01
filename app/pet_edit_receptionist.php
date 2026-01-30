<?php
session_start(); // NEW: start session to get user_id
include 'db_connect.php';

$id = $_GET['id'];

if (isset($_POST['update'])) {
    $stmt = $conn->prepare(
        "UPDATE pets SET pet_name=?, owner_name=?, owner_contact=?, diagnosis=?, treatment_fee=?, age=? WHERE id=?"
    );
    $stmt->execute([
        $_POST['pet_name'],
        $_POST['owner_name'],
        $_POST['owner_contact'],
        $_POST['diagnosis'],
        $_POST['treatment_fee'],
        $_POST['age'],
        $id
    ]);

    // --- Audit log ---
    $stmtLog = $conn->prepare(
        "INSERT INTO audit_log (user_id, action_type, details) VALUES (?, ?, ?)"
    );
    $stmtLog->execute([
        $_SESSION['user_id'],
        'Edit Pet',
        "Edited pet ID $id: Name={$_POST['pet_name']}, Owner={$_POST['owner_name']}, Fee={$_POST['treatment_fee']}"
    ]);
    
    header("Location: pets_list_receptionist.php");
}

$pet = $conn->prepare("SELECT * FROM pets WHERE id=?");
$pet->execute([$id]);
$pet = $pet->fetch(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<head>
        <title>Edit Pet</title>
        <link rel="stylesheet" href="style.css">
</head>

<body>
<h2> Edit Pet</h2>
<form method="POST">
    Pet Name: <input name="pet_name" value="<?= htmlspecialchars($pet['pet_name']) ?>" required><br>
    Owner Name: <input name="owner_name" value="<?= htmlspecialchars($pet['owner_name']) ?>" required><br>
    Owner Contact: <input name="owner_contact" value="<?= htmlspecialchars($pet['owner_contact']) ?>" required><br>
    Diagnosis: <input name="diagnosis" value="<?= htmlspecialchars($pet['diagnosis']) ?>"><br>
    Fee: <input type="number" step="0.01" name="treatment_fee" value="<?= htmlspecialchars($pet['treatment_fee']) ?>" required><br>
    Age: <input type="number" name="age" value="<?= htmlspecialchars($pet['age']) ?>" required><br><br>
    <button name="update">Update</button>
</form>
</body>
</html>
