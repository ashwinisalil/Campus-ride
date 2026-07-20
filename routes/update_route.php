<?php
include '../db.php';

$route_id = $_POST['route_id'];
$route_name = $_POST['route_name'];
$start_point = $_POST['start_point'];
$end_point = $_POST['end_point'];
$distance = $_POST['distance'];

$sql = "UPDATE routes
SET
route_name='$route_name',
start_point='$start_point',
end_point='$end_point',
distance='$distance'
WHERE route_id='$route_id'";

if($conn->query($sql)){
    echo "Route Updated Successfully";
}else{
    echo "Error : ".$conn->error;
}

$conn->close();
?>