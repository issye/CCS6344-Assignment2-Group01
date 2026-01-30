<?php
include 'db_connect.php';

/* Basic Content Security Policy */
header("Content-Security-Policy: default-src 'self'");

/* Fetch data */
$stmt = $conn->query("SELECT * FROM pets");
$pets = $stmt->fetchAll(PDO::FETCH_ASSOC);

/* Output escaping helper */
function e($value) {
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pet Records</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<h2>Pet Records</h2>

<a href="pet_add_receptionist.php">✚ Add Pet</a>
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
        <th>Action</th>
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
            <a href="pet_edit_receptionist.php?id=<?= urlencode($p['id']) ?>">Edit</a> |
            <a href="pet_delete_receptionist.php?id=<?= urlencode($p['id']) ?>"
               onclick="return confirm('Are you sure you want to delete this record?');">
               Delete
            </a>
        </td>
    </tr>
<?php endforeach; ?>

</table>

<br>
<a href="receptionist_dashboard.php">⬅ Back</a>

</body>
</html>
