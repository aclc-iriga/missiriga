<?php
const LOGIN_PAGE_PATH = '../crud/';
require_once '../crud/auth.php';
require_once '../config/database.php';

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="../crud/dist/bootstrap-5.2.3/css/bootstrap.min.css">
    <script src="../crud/dist/vue-3.2.47/vue.global.js"></script>
    <style>
        th, td {
            vertical-align: middle !important;
        }
        .help-blink {
            animation: helpBlink 1.2s infinite;
            color: inherit;
        }
        @keyframes helpBlink {
            0%, 100% {
                color: inherit;
                background: orange;
            }
            50% {
                color: orangered;
                background: inherit;
            }
        }
    </style>
    <title>Dashboard</title>
</head>
<body style="background-color: #eee">
    <?php require_once __DIR__ . '/components/TeamBlock.vue.php'; ?>
    <?php require_once __DIR__ . '/components/JudgeBlock.vue.php'; ?>
    <?php require_once __DIR__ . '/components/JudgeAvatar.vue.php'; ?>
    <?php require_once __DIR__ . '/components/JudgesTable.vue.php'; ?>
    <?php require_once __DIR__ . '/components/TeamsTable.vue.php'; ?>
    <?php require_once __DIR__ . '/Dashboard.vue.php'; ?>

    <div id="app" class="container-fluid py-3">
        <dashboard></dashboard>
    </div>

    <script>
        const app = Vue.createApp({});
        app.component('dashboard', Dashboard);
        app.mount('#app');
    </script>
    <script src="../crud/dist/bootstrap-5.2.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>