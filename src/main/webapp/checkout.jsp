<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <meta charset="utf-8">
    <script
            src="https://code.jquery.com/jquery-3.6.0.min.js"
            integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
            crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
</head>
<body>
<h1>Select Product Table Result : ${fn:length(cart)} row(s) selected</h1>
<c:if test="${not empty cart}">
    <table class="table table-success table-hover table-striped w-100">
        <thead>
        <tr>
            <th scope="col">產品名稱</th>
            <th scope="col">產品類別</th>
            <th scope="col">產品價格</th>
            <th scope="col"></th>
            <th scope="col"></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${cart}">
            <tr>
                <td>${row.productName }</td>
                <td>${row.productCatalog }</td>
                <td>${row.productPrice }</td>
                <td><img src="${row.productImg1 }" alt="" style="width: 120px"></td>
                <td><button onclick="removeProductFromCart(${row.productId})">移除</button></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</c:if>

<script>
    function removeProductFromCart(pid) {
        $.ajax({
            url: "CartServlet",
            method: "post",
            data: {
                pdaction: "removeProductFromCart",
                editProductId: pid
            },
            success: function (response) {
                alert(response);
                window.location.reload();
            },
            error: function () {
                alert("cart remove error");
            }
        });
    }
</script>
</body>
</html>
