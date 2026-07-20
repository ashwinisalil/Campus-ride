<?php
include '../db.php';

$driver_id = $_POST['driver_id'];

$sql = "DELETE FROM drivers WHERE driver_id='$driver_id'";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Driver Deleted Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>