<?php
include '../db.php';

$notification_id = $_POST['notification_id'];

$sql = "DELETE FROM notifications
WHERE notification_id='$notification_id'";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Notification Deleted Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>