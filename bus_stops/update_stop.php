<?php
include '../db.php';

$stop_id = $_POST['stop_id'];
$route_id = $_POST['route_id'];
$stop_name = $_POST['stop_name'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$arrival_time = $_POST['arrival_time'];

$sql = "UPDATE bus_stops SET
route_id='$route_id',
stop_name='$stop_name',
latitude='$latitude',
longitude='$longitude',
arrival_time='$arrival_time'
WHERE stop_id='$stop_id'";

if($conn->query($sql)){
    echo "Bus Stop Updated Successfully";
}else{
    echo "Error : ".$conn->error;
}

$conn->close();
?>