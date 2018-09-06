<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="//code.jquery.com/jquery.js"></script>
<script type="text/javascript">
function dataSend(){
	$.ajax({
        url:"insert",
        type:'POST',
        data: jQuery("#form").serialize(),
        success:function(data){
            alert("완료!");
            //location.reload();
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("에러 발생~~ \n" + textStatus + " : " + errorThrown);
        }
    });
}
</script>
<title>Insert title here</title>
</head>
<body>
<form id="form">
	<input type="text" name="contents" />
	<input type="text" name="startDate" />
	<input type="text" name="endDate" />
	<input type="text" name="fromEmail" />
	<input type="text" name="toEmail1" />
	<input type="text" name="toEmail2" />
	<input type="text" name="toEmail3" />
</form>
<input type="button" value="등록" onclick="dataSend()"/>
</body>
</html>