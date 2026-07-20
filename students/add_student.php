<?php
include '../db.php';

$user_id = $_POST['user_id'];
$roll_number = $_POST['roll_number'];
$department = $_POST['department'];
$year = $_POST['year'];
$assigned_bus_id = $_POST['assigned_bus_id'];

$sql = "INSERT INTO students(user_id, roll_number, department, year, assigned_bus_id)
VALUES('$user_id','$roll_number','$department','$year','$assigned_bus_id')";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Student Added Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>