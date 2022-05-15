<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<sql:setDataSource
	driver="com.mysql.cj.jdbc.Driver"
	url="jdbc:mysql://localhost/iii"
	user="root"
	password=""
	/> 
<sql:query var="rs">
	SELECT * FROM member
</sql:query>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script><title>Brad Big Company</title>
</head>
<body>
<h1>Brad Big Company</h1>
<hr />
<a href="brad64.jsp"><button type="button" class="btn btn-primary">新增</button></a> 
<table border="1" width="100%" class="table">
	<tr>
		<th>id.</th>
		<th>Account</th>
		<th>Realname</th>
		<th>Edit</th>

	</tr>
	<c:forEach items="${rs.rows }" var="row" varStatus="status">
		<tr>
			<td>${row.id }</td>
			<td>${row.account }</td>
			<td>${row.realname }</td>
			<td><a href="brad65.jsp?editid=${row.id }" >Edit</a></td>
		</tr>
	</c:forEach>
	
</table>

</body>
</html>