<?php
include '../db.php';

$route_name = $_POST['route_name'];
$start_point = $_POST['start_point'];
$end_point = $_POST['end_point'];
$distance = $_POST['distance'];

$sql = "INSERT INTO routes (route_name, start_point, end_point, distance)
VALUES ('$route_name','$start_point','$end_point','$distance')";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Route Added Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>