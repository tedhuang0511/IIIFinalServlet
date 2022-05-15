<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<% request.setCharacterEncoding("UTF-8"); %>
<sql:setDataSource
        driver="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost/iii"
        user="root"
        password=""
/>

<%--<c:if test="${pageContext.request.method == 'GET'}">--%>
<%--    <c:if test="${!empty param.pd-name }" >--%>
<%--        <c:redirect url="home.jsp" />--%>
<%--    </c:if>--%>
<%--</c:if>--%>

<c:if test="${!empty param.pdname }">
    <sql:update>
        INSERT into products(product_name,product_catalog,product_price,product_desc) VALUES (?,?,?,?)
        <sql:param>${param.pdname }</sql:param>
        <sql:param>${param.pdtypeselect}</sql:param>
        <sql:param>${param.pdprice }</sql:param>
        <sql:param>${param.ptaname }</sql:param>
    </sql:update>

    <%--    <c:redirect url="home.jsp"></c:redirect>--%>
</c:if>

<sql:query var="rs">
    SELECT * FROM products where product_id = ?
    <sql:param>${param.x}</sql:param>
</sql:query>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <style>
        .edit {
            width: 19px;
        }
    </style>
</head>
<body>

<form method="post" id="p-add-form">
    pname: <input type="text" name="pdname" value="安">
    <hr>

    type:<input type="text" name="pdtypeselect" list="pdtypeselect">
    <datalist id="pdtypeselect">
        <option value="3C">
        <option value="家電">
        <option value="服飾">
        <option value="配件">
    </datalist>
    <hr>
    price: <input type="number" name="pdprice">
    <hr>
    desc: <textarea form="p-add-form" name="ptaname" id="ptaid" cols="35"
                    wrap="soft"></textarea></td><br>
    <hr>
    <input type="submit" value="新增">
</form>

<hr>
${error}
<hr>
產品名稱:${param.pdname } <br>
pdtypeselect:${param.pdtypeselect}<br>
price:${param.pdprice }<br>
desc:${param.ptaname }<br>
<hr>

<c:forEach items="${rs.rows }" var="row" varStatus="status">
    <tr>
        <td>${status.count }</td>
        <td><a href="test.jsp?editid=${row.product_id}"><img class="edit" src="images/edit.png" alt=""></a></td>
        <td>${row.product_name }</td>
        <td>${row.product_catalog }</td>
        <td>${row.product_price }</td>
        <td>${row.product_stock }</td>
    </tr>
</c:forEach>
<jsp:include page="test2.jsp">
    <jsp:param name="key1" value="123"/>
    <jsp:param name="key2" value="222"/>
</jsp:include>

<c:if test="${rs.rows[0]==null}">
<hr>
rs.row等於null = ${rs.rows[0]}
<hr>
</c:if>
<c:if test="${rs.rows[0]!=null}">
    <hr>
    rs.row不等於null = ${rs.rows[0]}
    <hr>
</c:if>


<div style="display:none;">
    <jsp:include page="test3.jsp">
        <jsp:param name="key1" value="123"/>
        <jsp:param name="key2" value="222"/>
    </jsp:include>
    something inside div
</div>

</body>
</html>
