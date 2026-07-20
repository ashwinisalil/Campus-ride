<?php
include '../db.php';

$route_id = $_POST['route_id'];

$sql = "DELETE FROM routes WHERE route_id='$route_id'";

if($conn->query($sql)){
    echo "Route Deleted Successfully";
}else{
    echo "Error : ".$conn->error;
}

$conn->close();
?>