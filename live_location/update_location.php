<?php
include '../db.php';

$trip_id = $_POST['trip_id'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$speed = $_POST['speed'];

$sql = "INSERT INTO live_locations (trip_id, latitude, longitude, speed, updated_at)
VALUES ('$trip_id','$latitude','$longitude','$speed',NOW())";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Location Updated Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>