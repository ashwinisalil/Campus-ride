<?php

session_start();

include("db_connect.php");

if($_SERVER["REQUEST_METHOD"]=="POST")
{

    $student_id = mysqli_real_escape_string($conn, $_POST['student_id']);
    $user_id = mysqli_real_escape_string($conn, $_POST['user_id']);

    $sql = "SELECT * FROM students
            WHERE student_id='$student_id'
            AND user_id='$user_id'";

    $result = mysqli_query($conn,$sql);

    if(mysqli_num_rows($result)==1)
    {

        $row = mysqli_fetch_assoc($result);

        $_SESSION['student_id'] = $row['student_id'];
        $_SESSION['user_id'] = $row['user_id'];
        $_SESSION['department'] = $row['department'];
        $_SESSION['year'] = $row['year'];
        $_SESSION['bus_id'] = $row['bus_id'];
        $_SESSION['stop_id'] = $row['stop_id'];

        header("Location: student_dashboard.php");
        exit();

    }
    else
    {

        echo "<script>
                alert('Invalid Student ID or User ID');
                window.location='student_login.html';
              </script>";

    }

}

?>