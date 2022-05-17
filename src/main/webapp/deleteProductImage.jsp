<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource
        driver="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost/iii"
        user="root"
        password=""
/>

<c:if test="${param.x == 1 }">
    <sql:update>
        UPDATE products SET product_img1 = NULL WHERE product_name = ?
        <sql:param>${param.pdname }</sql:param>
    </sql:update>
    <c:redirect url="home.jsp"></c:redirect>
</c:if>

<c:if test="${param.x == 2 }">
    <sql:update>
        UPDATE products SET product_img2 = NULL WHERE product_name = ?
        <sql:param>${param.pdname }</sql:param>
    </sql:update>
    <c:redirect url="home.jsp"></c:redirect>
</c:if>

<c:if test="${param.x == 3 }">
    <sql:update>
        UPDATE products SET product_img3 = NULL WHERE product_name = ?
        <sql:param>${param.pdname }</sql:param>
    </sql:update>
    <c:redirect url="home.jsp"></c:redirect>
</c:if>

<c:if test="${param.x == 4 }">
    <sql:update>
        UPDATE products SET product_img4 = NULL WHERE product_name = ?
        <sql:param>${param.pdname }</sql:param>
    </sql:update>
    <c:redirect url="home.jsp"></c:redirect>
</c:if>