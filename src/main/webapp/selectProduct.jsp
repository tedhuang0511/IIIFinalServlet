<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource
        driver="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost/iii"
        user="root"
        password=""
/>

<c:choose>

    <c:when test="${!empty param.pdname }">
        <sql:query var="rs">
            SELECT * FROM products where product_name = ?
            <sql:param>${param.pdname}</sql:param>
        </sql:query>
    </c:when>
    <c:otherwise>
        <sql:query var="rs">
            SELECT * FROM products
        </sql:query>
    </c:otherwise>

</c:choose>

<html>
<head>
    <meta charset="utf-8">
    <script src="js/jquery-3.6.0.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
</head>
<body>
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
</body>
</html>