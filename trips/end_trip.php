<?php
include '../db.php';

$trip_id = $_POST['trip_id'];
$end_time = $_POST['end_time'];

$sql = "UPDATE trips
SET end_time='$end_time',
status='Completed'
WHERE trip_id='$trip_id'";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Trip Ended Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>