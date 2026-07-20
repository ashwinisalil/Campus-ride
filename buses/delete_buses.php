<?php
include '../db.php';

$bus_id = $_POST['bus_id'];

$sql = "DELETE FROM buses WHERE bus_id='$bus_id'";

if($conn->query($sql)){
    echo "Bus Deleted Successfully";
}else{
    echo "Error : ".$conn->error;
}

$conn->close();
?>