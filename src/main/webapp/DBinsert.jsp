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

<sql:query var="rs">
    SELECT * FROM PRODUCTS WHERE PRODUCT_NAME = ?
    <sql:param>${param.pdname }</sql:param>
</sql:query>

<c:if test="${pageContext.request.method == 'GET'}">
    <c:if test="${!empty param.pdname }">
        <c:redirect url="home.jsp"/>
    </c:if>
</c:if>

<%--新增產品--%>
<c:if test="${!empty param.pdname}">
    <script>alert("新增1")</script>
    <c:if test="${rs.rows[0]==null}">
        <script>console.log("新增2")</script>
        <sql:update>
            INSERT into products(product_name,product_catalog,product_price,product_desc) VALUES (?,?,?,?);
            <sql:param>${param.pdname }</sql:param>
            <sql:param>${param.pdtypeselect}</sql:param>
            <sql:param>${param.pdprice }</sql:param>
            <sql:param>${param.pdesc }</sql:param>
        </sql:update>
        <c:redirect url="home.jsp"></c:redirect>
    </c:if>
</c:if>

<%--更新產品--%>
<c:if test="${!empty param.pdname}">
    <script>console.log("更新1")</script>
    <c:if test="${rs.rows[0]!=null}">
        <script>console.log("更新2")</script>
        <sql:update>
            UPDATE products SET product_name = ?, product_catalog =? ,product_price=? ,product_desc=? WHERE product_id=?
            <sql:param>${param.pdname }</sql:param>
            <sql:param>${param.pdtypeselect}</sql:param>
            <sql:param>${param.pdprice }</sql:param>
            <sql:param>${param.pdesc }</sql:param>
            <sql:param>${rs.rows[0].product_id }</sql:param>
        </sql:update>
        <c:redirect url="home.jsp"></c:redirect>
    </c:if>
</c:if>
