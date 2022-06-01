<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <meta charset="utf-8">
    <script src="../js/jquery-3.6.0.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
</head>
<body>
<h6>Select Product Table Result : ${fn:length(select)} row(s) selected</h6>
<c:if test="${not empty select}">
<table class="table table-success table-hover table-striped w-100">
    <thead>
    <tr>
        <th scope="col">序號</th>
        <th scope="col">編輯</th>
        <th scope="col">產品名稱</th>
        <th scope="col">產品類別</th>
        <th scope="col">產品價格</th>
        <th scope="col">庫存量</th>
        <th scope="col"></th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${select}">
        <tr>
            <td>${row.productId }</td>
            <td><img class="edit" src="images/edit.png" alt=""
                     onclick="fnc1('${row.productId}')">
            </td>
            <td>${row.productName }</td>
            <td>${row.productCatalog }</td>
            <td>${row.productPrice }</td>
            <td>${row.productStock }</td>
            <td><button onclick="return deleteProductItemConfirm('${row.productId}');">刪除品項</button></td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</c:if>

<span>
    <button id="QQQ">Prev</button>
    <b id="pdPage">1</b>
    <button>Next</button>
</span>
<div class="container">
    <div class="row" id="content">
    </div>
    <nav aria-label="Page navigation example">
        <ul class="pagination" id="pageid">
        </ul>
    </nav>
</div>
<table class="table table-success table-hover table-striped w-100">
    <thead>
    <tr>
        <th scope="col">序號</th>
        <th scope="col">編輯</th>
        <th scope="col">產品名稱</th>
        <th scope="col">產品類別</th>
        <th scope="col">產品價格</th>
        <th scope="col">庫存量</th>
        <th scope="col"></th>
    </tr>
    </thead>
    <tbody id="content2">
    </tbody>
</table>
</body>
</html>