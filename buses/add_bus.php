<?php
include '../db.php';

$bus_number = $_POST['bus_number'];
$capacity = $_POST['capacity'];
$route_id = $_POST['route_id'];
$status = $_POST['status'];

$sql = "INSERT INTO buses (bus_number, capacity, route_id, status)
VALUES ('$bus_number','$capacity','$route_id','$status')";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Bus Added Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>