<%@page import="java.util.Properties" %>
<%@page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource
        driver="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost/iii"
        user="root"
        password=""
/>
<c:if test="${!empty param.delid }">
    <sql:update>
        DELETE FROM PRODUCTS WHERE PRODUCT_id = ?
        <sql:param>${param.delid }</sql:param>
    </sql:update>
    <c:redirect url="home.jsp"></c:redirect>
</c:if>

<sql:query var="rs">
    SELECT * FROM products
</sql:query>

<html>
<head>
    <meta charset="utf-8">
    <title>JAVA42-生活倉庫</title>
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

        .edit:hover {
            width: 22px;
        }
    </style>
</head>
<body>
<div id="product01" class="d-block">
    <div class="pt-3 pb-2 mb-3">
        <div class="fw-bold fs-3">產品維護</div>
        <div>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button id="queryTab" class="active nav-link">搜尋條件</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button id="editTab" class="nav-link ">編輯頁</button>
                </li>
            </ul>
        </div>
    </div>

    <div id="productContent">
        <!--產品維護搜尋條件的區域控制 START-->
        <div class="tab-pane fade show active" id="query" role="tabpanel" aria-labelledby="query-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <button class="button-54 p-query"><img src="images/search.png" style="width: 20px"
                                                       alt="">查詢
                </button>
                <button class="button-54 p-add"><img src="images/add.png" style="width: 20px" alt="">新增
                </button>
            </div>
            <table class="table table-hover">
                <thead>
                <tr>
                    <th scope="col" colspan="4">

                    </th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th scope="row" style="text-align: end">產品名稱</th>
                    <td><input type="text"></td>
                    <td style="text-align: end; font-weight: bold">產品編號</td>
                    <td><input type="text"></td>
                </tr>
                <tr>
                    <th scope="row" style="text-align: end">產品類別</th>
                    <td><input type="text"></td>
                    <td scope="row" style="text-align: end;font-weight: bold">產品價格</td>
                    <td><input type="text"></td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id="productList" class="d-none">
            <table class="table table-success table-hover table-striped w-100">
                <thead>
                <tr>
                    <th scope="col">序號</th>
                    <th scope="col">編輯</th>
                    <th scope="col">產品名稱</th>
                    <th scope="col">產品類別</th>
                    <th scope="col">產品價格</th>
                    <th scope="col">庫存量</th>
                    <th scope="col">  </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${rs.rows }" var="row" varStatus="status">
                    <tr>
                        <td>${status.count }</td>
                        <td><img class="edit" src="images/edit.png" alt=""
                                 onclick="fnc1('${row.product_name }','${row.product_catalog }','${row.product_price }','${row.product_desc }','${row.product_img1}', '${row.product_img2}', '${row.product_img3}', '${row.product_img4}')">
                        </td>
                        <td>${row.product_name }</td>
                        <td>${row.product_catalog }</td>
                        <td>${row.product_price }</td>
                        <td>${row.product_stock }</td>
                        <td><a href="products.jsp?delid=${row.product_id}"
                               onclick="return delConfirm('${row.product_name}');">刪除</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div> <!--產品維護搜尋條件與結果的區域控制 END-->
    <!--產品編輯的區域控制 START-->
    <div id="productEdit" class="d-none">
        <div class="tab-pane fade show active " role="tabpanel"
             aria-labelledby="productEdit-tab">
            <div style="margin-top: -18px; margin-bottom: -8px">
                <form id="p-add-form" method="post" action="DBinsert.jsp">
                    <button type="submit" class="button-54 p-save" onclick="return saveConfirm()"><img
                            src="images/search.png" style="width: 20px"
                            alt="">新增/儲存
                    </button>
                    </input>

                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th scope="col" colspan="4">
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <th scope="row" style="text-align: end">產品名稱</th>
                            <td><input type="text" name="pdname" id="pdname" class="productquery" value=""></td>
                            <td style="text-align: end; font-weight: bold">產品類別</td>
                            <td>
                                <input type="text" name="pdtypeselect" class="pdtypeselect productquery" list="pdtypeselect"
                                       value="">
                                <datalist id="pdtypeselect">
                                    <option value="3C">
                                    <option value="家電">
                                    <option value="服飾">
                                    <option value="配件">
                                </datalist>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: end">產品價格</th>
                            <td><input type="number" name="pdprice" id="pdprice" class="productquery" value=""></td>
                            <td scope="row" style="text-align: end;font-weight: bold">產品描述</td>
                            <td><textarea form="p-add-form" name="pdesc" id="pdesc" class="productquery" cols="35"
                                          wrap="soft"></textarea></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: end">產品照片1</th>
                            <td>
                                <input class="form-control" type="file" id="formFile1" name="formFile1">
                            </td>
                            <td scope="row" style="text-align: end;font-weight: bold">產品照片2</td>
                            <td>
                                <input class="form-control" type="file" id="formFile2" name="formFile2">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: end">產品照片3</th>
                            <td>
                                <input class="form-control" type="file" id="formFile3" name="formFile3">
                            </td>
                            <td scope="row" style="text-align: end;font-weight: bold">產品照片4</td>
                            <td>
                                <input class="form-control" type="file" id="formFile4" name="formFile4">
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form>
                <%--產品照片區--%>
                <div id="productImages" class="d-none">
                    <table>
                        <th>

                        </th>
                        <tr>
                            <td>照片1  <button onclick="delImg()">刪除</button></td>
                            <td>照片2</td>
                        </tr>
                        <tr>
                            <td><img id="prodimg1" src="" alt="Product Image1" width="300px"></td>
                            <td><img id="prodimg2" src="" alt="Product Image2" width="300px"></td>
                        </tr>
                        <tr>
                            <td>照片3</td>
                            <td>照片4</td>
                        </tr>
                        <tr>
                            <td><img id="prodimg3" src="" alt="Product Image3" width="300px"></td>
                            <td><img id="prodimg4" src="" alt="Product Image4" width="300px"></td>
                        </tr>
                    </table>
                </div>
                <%--產品照片區END--%>
            </div>
        </div>
    </div>
</div><!--產品編輯的區域控制 END-->

<script>
    //產品清單的編輯按鈕被點擊時觸發fnc1
    function fnc1(pname, ptype, price, pdesc, pimg1, pimg2, pimg3, pimg4) {
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
        $('#pdname').prop('value', pname)
        $('#pdprice').prop('value', price)
        $('.pdtypeselect').prop('value', ptype)
        $('#pdesc').prop('value', pdesc)
        $('#productImages').prop('class', 'd-block');
        $('#prodimg1').prop('src', pimg1)
        $('#prodimg2').prop('src', pimg2)
        $('#prodimg3').prop('src', pimg3)
        $('#prodimg4').prop('src', pimg4)

    }

    function delConfirm(pname) {
        const isDel = confirm("確定刪除 " + pname + "?");
        return isDel;
    }

    function saveConfirm() {
        const isDel = confirm("確定新增/修改?");
        return isDel;
    }

    function delImg(){
        const isDel = confirm("確定刪除??")
        if (isDel==true){
            const pid = $('#pdname').val();
            console.log(pid);
        //TODO
        }
    }



    $('.p-query').on('click', function () {
        $('#productList').removeClass('d-none')
    })

    $('#editTab').on('click', function () {
        console.log("123123")
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
    })

    $('#queryTab').on('click', function () {
        console.log("123123")
        $('#editTab').removeClass("active").addClass('nav-link')
        $('#queryTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-block')
        $('#productEdit').prop('class', 'd-none')
    })

    $('.p-add').on('click', function () {
        console.log("p-add")
        $('#queryTab').removeClass("active").addClass('nav-link')
        $('#editTab').prop('class', 'nav-link active')
        $('#productContent').prop('class', 'd-none')
        $('#productEdit').prop('class', 'd-block')
        $('.productquery').prop('value','')
        $('#productImages').prop('class', 'd-none');
    })

</script>
</body>
</html>
