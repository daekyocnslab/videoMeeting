<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css" />
<script src="https://code.jquery.com/jquery.js"></script>
<title>화상회의 화면공유</title>
</head>
<body>
<div id="wrap">
	<div class="btn_app">
		<a href="videomeeting://daekyocns?roomId=${roomId}"><img alt="" src="${pageContext.request.contextPath}/resources/image/btn_in.png"></a>	
	</div>
</div>
</body>
</html>