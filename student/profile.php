<?php
session_start();
include("db_connect.php");

if (!isset($_SESSION['student_id'])) {
    header("Location: student_login.html");
    exit();
}

$student_id = $_SESSION['student_id'];

$sql = "SELECT * FROM students WHERE student_id='$student_id'";
$result = mysqli_query($conn, $sql);
$student = mysqli_fetch_assoc($result);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile</title>

    <link rel="stylesheet" href="css/dashboard.css">

    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>

<div class="sidebar">

    <h2>Campus Ride</h2>

    <ul>
        <li><a href="student_dashboard.php"><i class="fa fa-home"></i> Dashboard</a></li>

        <li class="active"><a href="profile.php"><i class="fa fa-user"></i> Profile</a></li>

        <li><a href="bus_details.php"><i class="fa fa-bus"></i> Bus Details</a></li>

        <li><a href="stop_details.php"><i class="fa fa-location-dot"></i> Stop Details</a></li>

        <li><a href="attendance.php"><i class="fa fa-calendar-check"></i> Attendance</a></li>

        <li><a href="logout.php"><i class="fa fa-right-from-bracket"></i> Logout</a></li>
    </ul>

</div>

<div class="main">

<h1>Student Profile</h1>

<div class="profile-card">

<div class="profile-image">

<img src="../assets/student.png" alt="Student">

</div>

<div class="profile-details">

<table>

<tr>
<th>Student ID</th>
<td><?php echo $student['student_id']; ?></td>
</tr>

<tr>
<th>Name</th>
<td><?php echo $student['student_name']; ?></td>
</tr>

<tr>
<th>User ID</th>
<td><?php echo $student['user_id']; ?></td>
</tr>

<tr>
<th>Email</th>
<td><?php echo $student['email']; ?></td>
</tr>

<tr>
<th>Mobile</th>
<td><?php echo $student['mobile']; ?></td>
</tr>

<tr>
<th>Department</th>
<td><?php echo $student['department']; ?></td>
</tr>

<tr>
<th>Year</th>
<td><?php echo $student['year']; ?></td>
</tr>

<tr>
<th>Bus ID</th>
<td><?php echo $student['bus_id']; ?></td>
</tr>

<tr>
<th>Stop ID</th>
<td><?php echo $student['stop_id']; ?></td>
</tr>

</table>

</div>

</div>

</div>

</body>
</html>