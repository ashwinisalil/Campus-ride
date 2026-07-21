<?php
session_start();
include("db_connect.php");

if(!isset($_SESSION['student_id']))
{
    header("Location: login.html");
    exit();
}

$student_id = mysqli_real_escape_string($conn, $_SESSION['student_id']);

$sql = "SELECT * FROM students WHERE student_id='$student_id'";
$result = mysqli_query($conn,$sql);
$student = mysqli_fetch_assoc($result);

if (!$student) {
    header("Location: login.html");
    exit();
}
?>

<!DOCTYPE html>
<html>
<head>

<title>Student Dashboard</title>

<link rel="stylesheet" href="css/dashboard.css">

</head>

<body>

<div class="sidebar">

<h2>🚌 Bus Attendance</h2>

<ul>

<li>🏠 Dashboard</li>

<li>👤 Profile</li>

<li>🚌 Bus Details</li>

<li>📍 Stop Details</li>

<li>📅 Attendance</li>

<li><a href="logout.php">Logout</a></li>

</ul>

</div>

<div class="main">

<h1>Welcome Student <?php echo $student['student_id']; ?></h1>

<h2>Student Information</h2>

<table>

<tr>
<td>User ID</td>
<td><?php echo $student['user_id']; ?></td>
</tr>

<tr>
<td>Email</td>
<td><?php echo $student['email']; ?></td>
</tr>

<tr>
<td>Mobile</td>
<td><?php echo $student['mobile']; ?></td>
</tr>

<tr>
<td>Gender</td>
<td><?php echo $student['gender']; ?></td>
</tr>

<tr>
<td>Department</td>
<td><?php echo $student['department']; ?></td>
</tr>

<tr>
<td>Year</td>
<td><?php echo $student['year']; ?></td>
</tr>

</table>

<br><br>

<h2>Bus Details</h2>

<table>

<tr>
<td>Bus Number</td>
<td><?php echo $student['bus_number']; ?></td>
</tr>

<tr>
<td>Driver Name</td>
<td><?php echo $student['driver_name']; ?></td>
</tr>

<tr>
<td>Driver Mobile</td>
<td><?php echo $student['driver_mobile']; ?></td>
</tr>

<tr>
<td>Route</td>
<td><?php echo $student['route_name']; ?></td>
</tr>

</table>

<br><br>

<h2>Stop Details</h2>

<table>

<tr>
<td>Stop Name</td>
<td><?php echo $student['stop_name']; ?></td>
</tr>

<tr>
<td>Arrival Time</td>
<td><?php echo $student['arrival_time']; ?></td>
</tr>

</table>

</div>

</body>
</html>