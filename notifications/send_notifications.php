<?php
include '../db.php';

$title = $_POST['title'];
$message = $_POST['message'];
$user_id = $_POST['user_id'];

$sql = "INSERT INTO notifications (title, message, user_id, created_at)
VALUES ('$title','$message','$user_id',NOW())";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Notification Sent Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>