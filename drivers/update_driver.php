<?php
include '../db.php';

$driver_id = $_POST['driver_id'];
$user_id = $_POST['user_id'];
$license_number = $_POST['license_number'];
$assigned_bus_id = $_POST['assigned_bus_id'];

$sql = "UPDATE drivers SET
user_id='$user_id',
license_number='$license_number',
assigned_bus_id='$assigned_bus_id'
WHERE driver_id='$driver_id'";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Driver Updated Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>