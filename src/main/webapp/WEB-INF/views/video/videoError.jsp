<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css" />
<title>화상회의 화면공유</title>
</head>
<body>
<div id="wrap">
	<div class="error">
		<c:choose>
			<c:when test="${result eq '998'}">
				<img alt="" src="${pageContext.request.contextPath}/resources/image/error_998.png" />
			</c:when>
			<c:when test="${result eq '999'}">
				<img alt="" src="${pageContext.request.contextPath}/resources/image/error_999.png" />
			</c:when>
		</c:choose>
	</div>
</div>
</body>
</html>