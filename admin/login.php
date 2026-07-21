<?php
session_start();
include("config.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = $_POST['password'];

    $sql = "SELECT * FROM admin WHERE email='$email'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) == 1) {

        $row = mysqli_fetch_assoc($result);

        if (password_verify($password, $row['password'])) {

            $_SESSION['admin_id'] = $row['id'];
            $_SESSION['admin_email'] = $row['email'];

            header("Location: dashboard.php");
            exit();

        } else {

            echo "<script>
                    alert('Wrong Password');
                    window.location='admin/login.html';
                  </script>";

        }

    } else {

        echo "<script>
                alert('Invalid Email');
                window.location='admin/login.html';
              </script>";

    }

}

mysqli_close($conn);
?>