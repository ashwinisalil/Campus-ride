<?php
include '../db.php';

$route_id = $_POST['route_id'];
$stop_name = $_POST['stop_name'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$arrival_time = $_POST['arrival_time'];

$sql = "INSERT INTO bus_stops (route_id, stop_name, latitude, longitude, arrival_time)
VALUES ('$route_id','$stop_name','$latitude','$longitude','$arrival_time')";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Bus Stop Added Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>