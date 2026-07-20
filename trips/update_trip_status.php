<?php
include '../db.php';

$trip_id = $_POST['trip_id'];
$status = $_POST['status'];

$sql = "UPDATE trips
SET status='$status'
WHERE trip_id='$trip_id'";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Trip Status Updated"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>