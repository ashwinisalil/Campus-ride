<?php
include '../db.php';

$student_id = $_POST['student_id'];

$sql = "DELETE FROM students WHERE student_id='$student_id'";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Student Deleted Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>