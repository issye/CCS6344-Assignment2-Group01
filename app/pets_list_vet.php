<?php
include 'db_connect.php';

/* SECURITY: Content Security Policy */
header("Content-Security-Policy: default-src 'self'");

/* Fetch all pets */
$pets = $conn->query("SELECT * FROM pets")->fetchAll(PDO::FETCH_ASSOC);

/* SECURITY: Output Escaping Function to prevent XSS */
function e($value) {
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Pet Records</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
<h2> Pet Records (Vet)</h2>
<a href="pet_add_vet.php">✚ Add Pet</a>
<br><br>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Pet's Name</th>
        <th>Owner</th>
        <th>Contact</th>
        <th>Diagnosis</th>
        <th>Treatment Fee</th>
        <th>Age</th>
        <th>Actions</th>
    </tr>

<?php foreach ($pets as $p): ?>
    <tr>
        <td><?= e($p['id']) ?></td>
        <td><?= e($p['pet_name']) ?></td>
        <td><?= e($p['owner_name']) ?></td>
        <td><?= e($p['owner_contact']) ?></td>
        <td><?= e($p['diagnosis']) ?></td>
        <td><?= e($p['treatment_fee']) ?></td>
        <td><?= e($p['age']) ?></td>
        <td>
            <a href="pet_edit_vet.php?id=<?= e($p['id']) ?>">Edit</a> |
            <a href="pet_delete_vet.php?id=<?= e($p['id']) ?>" 
               onclick="return confirm('Are you sure?');">Delete</a>
        </td>
    </tr>
<?php endforeach; ?>
</table>

<br>
<a href="vet_dashboard.php">⬅ Back</a>
</body>
</html>
