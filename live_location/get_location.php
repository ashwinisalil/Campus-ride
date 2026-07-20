<?php
include '../db.php';

$trip_id = $_GET['trip_id'];

$sql = "SELECT * FROM live_locations
WHERE trip_id='$trip_id'
ORDER BY updated_at DESC
LIMIT 1";

$result = $conn->query($sql);

if($result->num_rows > 0){
    echo json_encode($result->fetch_assoc());
}else{
    echo json_encode([
        "status"=>"error",
        "message"=>"No Location Found"
    ]);
}

$conn->close();
?>