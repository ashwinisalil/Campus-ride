<?php
include 'db.php';

$user_id = $_GET['user_id'];

$sql = "SELECT * FROM users WHERE user_id='$user_id'";

$result = $conn->query($sql);

if($result->num_rows>0){
    echo json_encode($result->fetch_assoc());
}else{
    echo "No Data";
}
?>