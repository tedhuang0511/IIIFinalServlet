<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <meta charset="utf-8">
    <title>JAVA42-生活倉庫</title>
    <!-- Bootstrap core CSS -->
    <!--    <link rel="stylesheet" href="../test/css/bootstrap.css">-->
    <!-- Custom styles for this template -->
    <link href="css/dashboard.css" rel="stylesheet">
    <script src="js/jquery-3.6.0.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
    <script src="js/queryEditButtons.js"></script>
    <style>
        .button-54 {
            font-family: "Open Sans", sans-serif;
            font-size: 14px;
            letter-spacing: 2px;
            text-decoration: none;
            text-transform: uppercase;
            color: #000;
            cursor: pointer;
            border: 3px solid;
            padding: 0.25em 0.5em;
            box-shadow: 1px 1px 0 0, 2px 2px 0 0, 3px 3px 0 0, 4px 4px 0 0, 5px 5px 0 0;
            position: relative;
            user-select: none;
            -webkit-user-select: none;
            touch-action: manipulation;
            margin-right: 2px;
        }

        .button-54:active {
            box-shadow: 0 0 0 0;
            top: 5px;
            left: 5px;
        }

        @media (min-width: 768px) {
            .button-54 {
                padding: 0.25em 0.75em;
            }
        }

        .edit {
            width: 19px;
        }

        .edit:hover{
            width: 22px;
        }
    </style>
</head>

<body>

<header class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0 shadow">
    <a id="home" class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="home.jsp">Java42 - 後台管理</a>
    <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" data-bs-toggle="collapse"
            data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false"
            aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="hello form-control form-control-dark w-75 bg-dark"></div>
    <div class="navbar-nav">
        <div class="nav-item text-nowrap mx-1 w-75">
            <div id="time" class="nav-link px-3 text-white"></div>
        </div>
    </div>
    <div class="navbar-nav">
        <div class="nav-item text-nowrap bg-primary mx-3">
            <a class="nav-link px-3 text-white" href="logout">登出</a>
        </div>
    </div>
</header>

<div class="container-fluid">
    <div class="row">
        <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column" id="nav_accordion">
                    <li class="nav-item has-submenu">
                        <a class="nav-link dropdown-toggle show" href="#" id="dropdown01" data-bs-toggle="dropdown"
                           aria-expanded="true">權限設定</a>
                        <ul class="submenu collapse" aria-labelledby="dropdown01">
                            <li><a class="dropdown-item" href="#">使用者維護</a></li>
                            <li><a class="dropdown-item" href="#" id="accountInfo">帳號資訊</a></li>
                        </ul>
                    </li>
                    <li class="nav-item has-submenu">
                        <a class="nav-link dropdown-toggle show" href="#" id="dropdown02" data-bs-toggle="dropdown"
                           aria-expanded="true">產品設定</a>
                        <ul class="submenu collapse" aria-labelledby="dropdown02">
                            <li><a class="dropdown-item products" href="#">產品維護</a></li>
                            <li><a class="dropdown-item" href="#">產品目錄</a></li>
                        </ul>
                    </li>
                    <li class="nav-item has-submenu">
                        <a class="nav-link dropdown-toggle show" href="#" id="dropdown03" data-bs-toggle="dropdown"
                           aria-expanded="true"> 客戶模組 </a>
                        <ul class="submenu collapse" aria-labelledby="dropdown03">
                            <li><a class="dropdown-item members" href="#">客戶資料維護</a></li>
                        </ul>
                    </li>
                    <li class="nav-item has-submenu">
                        <a class="nav-link dropdown-toggle show" href="#" id="dropdown04" data-bs-toggle="dropdown"
                           aria-expanded="true"> 銷售模組 </a>
                        <ul class="submenu collapse" aria-labelledby="dropdown04">
                            <li><a class="dropdown-item" href="#">銷售訂單維護</a></li>
                        </ul>
                    </li>
                    <li class="nav-item has-submenu">
                        <a class="nav-link dropdown-toggle show" href="#" id="dropdown05" data-bs-toggle="dropdown"
                           aria-expanded="true"> 報表資訊 </a>
                        <ul class="submenu collapse" aria-labelledby="dropdown05">
                            <li><a class="dropdown-item" href="#">銷售報表</a></li>
                            <li><a class="dropdown-item" href="#">交易明細表</a></li>
                            <li><a class="dropdown-item" href="#">會員報表</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div id="Dashboard">
                <div
                        class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">Share</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle">
                            <span data-feather="calendar"></span>
                            This week
                        </button>
                    </div>
                </div>
                <canvas class="my-4 w-100" id="myChart" width="900" height="380"></canvas>
            </div>

            <div id="product01" class="d-none">
                <jsp:include page="products.jsp">
                    <jsp:param name="key1" value="123"/>
                </jsp:include>
            </div><!--產品編輯的區域控制 END-->

            <div id="main_members" class="d-none">
                <div
                        class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">會員資料維護</h1>
                </div>
                <div>
                    <button class="button-54 m-query"><img src="images/search.png" style="width: 20px" alt="">查詢
                    </button>
                    <button class="button-54"><img src="images/add.png" style="width: 20px" alt="">新增</button>
                </div>
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th scope="col" colspan="4">#搜尋條件</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th scope="row" style="text-align: end">會員編號</th>
                        <td><input type="text"></td>
                        <td style="text-align: end; font-weight: bold">會員姓名</td>
                        <td><input type="text"></td>
                    </tr>
                    <tr>
                        <th scope="row" style="text-align: end">會員暱稱</th>
                        <td><input type="text"></td>
                        <td scope="row" style="text-align: end;font-weight: bold">會員信箱</td>
                        <td><input type="text"></td>
                    </tr>
                    <tr>
                        <th scope="row" style="text-align: end">會員電話</th>
                        <td><input type="text"></td>
                        <td style="text-align: end"></td>
                        <td></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div id="memberList" class="d-none">
                <table class="table table-success table-hover table-striped w-100">
                    <thead>
                    <tr>
                        <th scope="col">會員編號</th>
                        <th scope="col">編輯</th>
                        <th scope="col">會員姓名</th>
                        <th scope="col">會員帳號</th>
                        <th scope="col">會員信箱</th>
                        <th scope="col">會員電話</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th scope="row">1</th>
                        <td><img class="edit" src="images/edit.png" alt=""></td>
                        <td>黃春翰</td>
                        <td>aaa123123</td>
                        <td>haru@gmail.com</td>
                        <td>0912345678</td>
                    </tr>
                    <tr>
                        <th scope="row">2</th>
                        <td><img class="edit" src="images/edit.png" alt=""></td>
                        <td>林宗翰</td>
                        <td>bbb591239</td>
                        <td>han@gmail.com</td>
                        <td>0932456789</td>
                    </tr>
                    <tr>
                        <th scope="row">3</th>
                        <td><img class="edit" src="images/edit.png" alt=""></td>
                        <td>黃柏憲</td>
                        <td>sss1239510</td>
                        <td>sbb@gmail.com</td>
                        <td>0987464313</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/feather-icons@4.28.0/dist/feather.min.js"
        integrity="sha384-uO3SXW5IuS1ZpFPKugNNWqTZRRglnUJK6UAZ/gxOX80nxEkN9NcGZTftn6RzhGWE"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"
        integrity="sha384-zNy6FEbO50N+Cg5wap8IKA4M/ZnLJgzc6w2NqACZaK0u0FXfOWRRJOnQtpZun8ha"
        crossorigin="anonymous"></script>
<script src="js/dashboard.js"></script>

<script>
    // submenu的JS
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll('.sidebar .nav-link').forEach(function (element) {
            element.addEventListener('click', function (e) {
                let nextEl = element.nextElementSibling;
                let parentEl = element.parentElement;

                if (nextEl) {
                    e.preventDefault();
                    let mycollapse = new bootstrap.Collapse(nextEl);

                    if (nextEl.classList.contains('show')) {
                        mycollapse.hide();
                    } else {
                        mycollapse.show();
                        // find other submenus with class=show
                        let opened_submenu = parentEl.parentElement.querySelector('.submenu.show');
                        // if it exists, then close all of them
                        if (opened_submenu) {
                            new bootstrap.Collapse(opened_submenu);
                        }
                    }
                }
            }); // addEventListener
        }) // forEach
    });

    function timer() {
        const date = new Date();
        document.getElementById("time").innerHTML =
            "Hello 城武! 現在時間:" + date.toLocaleTimeString();
    }
    setInterval(timer, 500);

    $('.products').on('click', function () {
        $('main>div').prop('class', 'd-none')
        $('#productList').prop('class', 'd-none')
        $('#product01').removeClass('d-none')
    })
    $('.members').on('click', function () {
        $('main>div').prop('class', 'd-none')
        $('#main_members').prop('class', 'd-block')
    })
    $('.m-query').on('click', function () {
        $('#memberList').removeClass('d-none')
    })

</script>
</body>

</html>