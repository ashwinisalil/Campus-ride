<?php
include '../db.php';

$user_id = $_POST['user_id'];
$license_number = $_POST['license_number'];
$assigned_bus_id = $_POST['assigned_bus_id'];

$sql = "INSERT INTO drivers(user_id, license_number, assigned_bus_id)
VALUES('$user_id','$license_number','$assigned_bus_id')";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Driver Added Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>