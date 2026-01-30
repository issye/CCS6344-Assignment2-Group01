<?php
session_start();
include 'db_connect.php';

if ($_SESSION['role'] != 'vet') {
    header("Location: login.php");
    exit();
}

$logs = $conn->query(
    "SELECT a.id, u.username, a.action_type, a.details, a.action_time
    FROM audit_log a
    LEFT JOIN users u ON a.user_id = u.id
    ORDER BY a.action_time DESC"
)->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
    <head>
        <title>Audit Log</title>
        <link rel="stylesheet" href="style.css">
</head>
<body>
    <h2>Audit Log</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>User</th>
            <th>Action</th>
            <th>Details</th>
            <th>Time</th>
</tr>

<?php foreach ($logs as $log): ?>
    <tr>
        <td><?= $log['id'] ?></td>
        <td><?= $log['username'] ?></td>
        <td><?= $log['action_type'] ?></td>
        <td><?= $log['details'] ?></td>
        <td><?= $log['action_time'] ?></td>
</tr>
<?php endforeach; ?>
</table>

<br>
<a href= "vet_dashboard.php">⬅ Back</a>

</body>
</html>
