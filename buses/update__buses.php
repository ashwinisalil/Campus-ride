<?php
include '../db.php';

$bus_id = $_POST['bus_id'];
$bus_number = $_POST['bus_number'];
$capacity = $_POST['capacity'];
$route_id = $_POST['route_id'];
$status = $_POST['status'];

$sql = "UPDATE buses
SET
bus_number='$bus_number',
capacity='$capacity',
route_id='$route_id',
status='$status'
WHERE bus_id='$bus_id'";

if($conn->query($sql)){
    echo "Bus Updated Successfully";
}else{
    echo "Error : ".$conn->error;
}

$conn->close();
?>