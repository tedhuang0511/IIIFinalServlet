<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<% request.setCharacterEncoding("UTF-8"); %>
<sql:setDataSource
	driver="com.mysql.cj.jdbc.Driver"
	url="jdbc:mysql://localhost/iii"
	user="root"
	password=""
	/> 

<c:if test="${!empty param.id }">
	<sql:update>
		UPDATE member SET account = ?, realname = ? WHERE id = ?
		<sql:param>${param.account }</sql:param>
		<sql:param>${param.realname }</sql:param>
		<sql:param>${param.id }</sql:param>
	</sql:update>
	<c:redirect url="brad63.jsp" />
</c:if>
	
<c:if test="${empty param.editid }">
	<c:redirect url="brad63.jsp" />
</c:if>	

<sql:query var="rs">
	SELECT * FROM member WHERE id = ?
	<sql:param>${param.editid }</sql:param>
</sql:query>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Brad Big Company</title>
</head>
<body>
編輯資料
<form>
	<input type="hidden" name="id" value="${rs.rows[0].id }" />
	Account: <input type="text" name="account" value="${rs.rows[0].account }" /><br />
	Realname: <input type="text" name="realname" value="${rs.rows[0].realname }" /><br />
	<input type="submit" value="更新" />
</form>

</body>
</html>