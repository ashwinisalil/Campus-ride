<?php

session_start();

if(!isset($_SESSION['admin_id'])){
    header("Location: login.html");
    exit();
}

include "config.php";


// Count total buses
$bus_query = "SELECT COUNT(*) AS total FROM buses";
$bus_result = mysqli_query($conn,$bus_query);
$bus_data = mysqli_fetch_assoc($bus_result);


// Count total drivers
$driver_query = "SELECT COUNT(*) AS total FROM drivers";
$driver_result = mysqli_query($conn,$driver_query);
$driver_data = mysqli_fetch_assoc($driver_result);


// Count total routes
$route_query = "SELECT COUNT(*) AS total FROM routes";
$route_result = mysqli_query($conn,$route_query);
$route_data = mysqli_fetch_assoc($route_result);


?>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Campus Ride Admin Dashboard</title>


<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">


<style>

body{
    background:#f4f8ff;
}


.sidebar{

    min-height:100vh;
    background:#0d6efd;
    color:white;
    padding:25px;

}


.sidebar h3{

    font-weight:bold;

}


.sidebar a{

    display:block;
    color:white;
    text-decoration:none;
    padding:12px;
    margin-top:10px;
    border-radius:8px;

}


.sidebar a:hover{

    background:rgba(255,255,255,0.2);

}



.dashboard-card{

    background:white;
    padding:25px;
    border-radius:20px;
    box-shadow:0 10px 30px rgba(0,0,0,0.1);

}


.number{

    font-size:35px;
    font-weight:bold;
    color:#0d6efd;

}

</style>


</head>


<body>


<div class="container-fluid">

<div class="row">


<!-- Sidebar -->

<div class="col-md-3 sidebar">


<h3>
Campus Ride
</h3>

<p>
Admin Panel
</p>

<hr>


<a href="dashboard.php">
🏠 Dashboard
</a>


<a href="buses.php">
🚌 Manage Buses
</a>


<a href="routes.php">
📍 Manage Routes
</a>


<a href="drivers.php">
👨‍✈️ Manage Drivers
</a>


<a href="tracking.php">
📡 Live Tracking
</a>


<a href="logout.php" class="btn btn-danger mt-3">
Logout
</a>


</div>



<!-- Dashboard Content -->


<div class="col-md-9 p-5">


<h2>
Welcome to Campus Ride
</h2>


<p class="text-muted">
Manage campus buses, routes, drivers and live tracking.
</p>



<div class="row mt-4">


<div class="col-md-4">

<div class="dashboard-card">


<h5>
Total Buses
</h5>


<p class="number">

<?php echo $bus_data['total']; ?>

</p>


</div>

</div>




<div class="col-md-4">

<div class="dashboard-card">


<h5>
Total Drivers
</h5>


<p class="number">

<?php echo $driver_data['total']; ?>

</p>


</div>

</div>




<div class="col-md-4">

<div class="dashboard-card">


<h5>
Total Routes
</h5>


<p class="number">

<?php echo $route_data['total']; ?>

</p>


</div>

</div>


</div>





<div class="dashboard-card mt-5">


<h4>
Campus Ride Features
</h4>


<ul>

<li>Bus Management</li>

<li>Driver Management</li>

<li>Campus Route Management</li>

<li>Live Bus Tracking</li>

<li>Student Transportation Monitoring</li>


</ul>


</div>



</div>


</div>

</div>


</body>

</html>