<?php
include '../db.php';

$student_id = $_POST['student_id'];
$user_id = $_POST['user_id'];
$roll_number = $_POST['roll_number'];
$department = $_POST['department'];
$year = $_POST['year'];
$assigned_bus_id = $_POST['assigned_bus_id'];

$sql = "UPDATE students SET
user_id='$user_id',
roll_number='$roll_number',
department='$department',
year='$year',
assigned_bus_id='$assigned_bus_id'
WHERE student_id='$student_id'";

if($conn->query($sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Student Updated Successfully"
    ]);
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>$conn->error
    ]);
}

$conn->close();
?>