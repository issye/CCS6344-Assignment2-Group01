<?php
session_start(); // NEW
include 'db_connect.php';

// Get pet id
$id = $_GET['id'];

// Get pet info before deleting for log
$pet = $conn->prepare("SELECT pet_name, owner_name, treatment_fee FROM pets WHERE id=?");
$pet->execute([$id]);
$pet = $pet->fetch(PDO::FETCH_ASSOC);

// Now delete the pet
$stmt = $conn->prepare("DELETE FROM pets WHERE id=?");
$stmt->execute([$id]);

// --- Audit log ---
$stmtLog = $conn->prepare(
    "INSERT INTO audit_log (user_id, action_type, details) VALUES (?, ?, ?)"
);
$stmtLog->execute([
    $_SESSION['user_id'],
    'Delete Pet',
    "Deleted pet ID $id: Name={$pet['pet_name']}, Owner={$pet['owner_name']}, Fee={$pet['treatment_fee']}"
]);

header("Location: pets_list_receptionist.php");