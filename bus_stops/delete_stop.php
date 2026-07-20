<?php
include '../db.php';

$stop_id = $_POST['stop_id'];

$sql = "DELETE FROM bus_stops WHERE stop_id='$stop_id'";

if($conn->query($sql)){
    echo "Bus Stop Deleted Successfully";
}else{
    echo "Error : ".$conn->error;
}

$conn->close();
?>