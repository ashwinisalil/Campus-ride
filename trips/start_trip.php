<?php
include '../db.php';

$bus_id = $_POST['bus_id'];
$driver_id = $_POST['driver_id'];
$route_id = $_POST['route_id'];
$trip_date = $_POST['trip_date'];
$start_time = $_POST['start_time'];

$sql = "INSERT INTO trips (bus_id, driver_id, route_id, trip_date, start_time, status)
VALUES ('$bus_id','$driver_id','$route_id','$trip_date','$start_time','Running')";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Trip Started Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>