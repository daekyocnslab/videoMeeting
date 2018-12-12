<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript">
var fromName;

$(function(){
    var nowDate = new Date();
   	var nowYear = nowDate.getFullYear();
   	var nowMonth;
   	var nowDay;
   	var nowHours;
   	var nowMinutes;
   	
   	if((eval(nowDate.getMonth())+1) < 10){
  		nowMonth = "0"+(eval(nowDate.getMonth())+1);
   	}else{
   		nowMonth = eval(nowDate.getMonth())+1;
   	}
   	
   	if(eval(nowDate.getDate()) < 10){
   		nowDay = "0"+eval(nowDate.getDate());
   	}else{
   		nowDay = eval(nowDate.getDate());
   	}
   	
   	if(eval(nowDate.getHours()) < 10){
   		nowHours = "0"+eval(nowDate.getHours());
   	}else{
   		nowHours = eval(nowDate.getHours());
   	}
    	
	if(eval(nowDate.getMinutes()) < 10){
		nowMinutes = "0"+eval(nowDate.getMinutes());
   	}else{
   		nowMinutes = eval(nowDate.getMinutes());
   	}

    var startYear = nowYear - 10;
    
    for( var i=0; i<20; i++ ) {
    	$('#year').append(new Option(startYear+i, startYear+i));
    }

    for (var i=0; i<12; i++) {
   		if(i<9){
   			$('#month').append(new Option(i+1, "0"+(i+1)));
   		}else{
   			$('#month').append(new Option(i+1, i+1));
   		}
    }

    for (var i=0; i<24; i++) {
   		if(i<10){
   			$('#beforeHour').append(new Option(i, "0"+i));
   			$('#afterHour').append(new Option(i, "0"+i));
   		}else{
   			$('#beforeHour').append(new Option(i, i));
   			$('#afterHour').append(new Option(i, i));
   		}
    }

    for (var i=0; i<60; i++) {
   		if(i<10){
   	        $('#beforeMinute').append(new Option(i, "0"+i));
   			$('#afterMinute').append(new Option(i, "0"+i));
   		}else{
   	        $('#beforeMinute').append(new Option(i, i));
   			$('#afterMinute').append(new Option(i, i));
   		}
    }  

    $('#year').val(nowYear);
    $('#month').val(nowMonth);
    setDay();
    $('#day').val(nowDay);
    $('#beforeHour').val(nowHours);
    $('#beforeMinute').val(nowMinutes);
    $('#afterHour').val(nowHours);
    $('#afterMinute').val(nowMinutes);
     
     $("#fromEmail, .toEmail").autocomplete({
    	 source : function( request, response ) {
    		var userName = this.element.val();
    		var param = {"userName":userName};
			
			$.ajax({
		        url:"user/info",
		        type:'POST',
		        data: param,
		        success:function(result){
		        	var data;
		        	
		        	if(result.list.length > 10){
		        		data = [{
    						label: '"'+userName+'" - 동명이인이 10명 초과',
    						value: userName
    					}]
		        	}else{
		        		data = result.list.map(function(item) {
	    					return {
	    						label: '"'+item.userName+'"<'+item.email+'>::'+item.company+'('+item.department+')',
	    						value: item.email 
	    					} 
	    				});
		        	}
		        	
		        	response(data);
		        },
		        error:function(jqXHR, textStatus, errorThrown){
		            alert("에러가 발생하였습니다. 관리자에게 문의하여 주십시오.");
		        }
		    });
    	},
    	minLength: 1,
    	focus: function() {
			return false;
		},
		select: function( event, ui ) {
			//this.value = ui.item.value;
			//fromName = ui.item.label.split('"')[1];
			if(this.id === 'fromEmail'){			
				fromName = this.value;
			}
    	} 
    });	 
});

function setDay() {
    var year = $('#year').val();
    var month = $('#month').val();
    var day = $('#day').val();    
    var dateDay = $('#day')[0];
    
    var arrayMonth = [31,28,31,30,31,30,31,31,30,31,30,31];

    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        arrayMonth[1] = 29;
    }

    for( var i=dateDay.length; i>0; i--) {
        dateDay.remove(dateDay.selectedIndex);
    }

    for (var i=1; i<=arrayMonth[month-1]; i++) {
    		if(i<10){
    			dateDay.options[i-1] = new Option(i, "0"+i);
    		}else{
    			dateDay.options[i-1] = new Option(i, i);
    		}
        
    }

    if( day != null || day != "" ) {
        if( day > arrayMonth[month-1] ) {
            dateDay.options.selectedIndex = arrayMonth[month-1]-1;
        } else {
            dateDay.options.selectedIndex = day-1;
        }
    }
}

function validateEmail(sEmail) {
	var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	
	if (filter.test(sEmail)) {
		return true;
	}else {
		return false;
	}
}

function dataSend(){
	var title = $("#title").val();
	var year = $("#year").val();
	var month = $("#month").val();
	var day = $("#day").val();
	var beforeHour = $("#beforeHour").val();
	var beforeMinute = $("#beforeMinute").val();
	var afterHour = $("#afterHour").val();
	var afterMinute = $("#afterMinute").val();
	var fromEmail = $("#fromEmail").val();
	var toEmail = $(".toEmail");
	
	var startDate = year+month+day+beforeHour+beforeMinute+"00";
	var endDate = year+month+day+afterHour+afterMinute+"00";
	
	if(title == ""){
		alert('방 제목를 입력하여 주십시오.');
		return;
	}
	if(startDate >= endDate){
		alert('회의시간이 제대로 설정하여 주십시오.');
		return;
	}
	if(fromEmail == ""){
		alert('보내는 분 메일을 입력하여 주십시오.');
		return;
	}
	
	if(!validateEmail(fromEmail)){
		alert('메일 형식이 잘못되었습니다.');
		return;
	}

	var cnt = 0;
	
	for(var i=0; i<toEmail.length; i++){
		if(toEmail[i].value != ""){
			cnt++;
			
			if(!validateEmail(toEmail[i].value)){
				alert('메일 형식이 잘못되었습니다.');
				return;
			}
		}
	}
	
	if(cnt == 0){
		alert('받는 분 메일을 입력하여 주십시오.');
		return;
	}
	
	var param = {"title":title, "startDate":startDate, "endDate":endDate, "fromName":fromName, "fromEmail":fromEmail, "toEmail1":toEmail[0].value, "toEmail2":toEmail[1].value, "toEmail3":toEmail[2].value};

	$.ajax({
        url:"insert",
        type:'POST',
        data: param,
        success:function(data){
	        	if(data == "000"){
	        		alert("예약이 완료되었습니다.");
	            location.reload();
	        	}else{
	        		alert("에러가 발생하였습니다. 관리자에게 문의하여 주십시오.");
	            location.reload();
	        	}
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("에러가 발생하였습니다. 관리자에게 문의하여 주십시오.");
            location.reload();
        }
    });
}
</script>
<title>화상회의 화면공유</title>
</head>
<body>
<div id="wrap">
	<div>
		<p class="e_title">화상회의 참석안내</p>
		<div class="form_area">
			<div>
				<span class="stitle">회의 제목</span>
				<span>
					<input type="text" id="title" name="title" class="box1" placeholder="화상회의 시스템 연구개발 회의" />
				</span>
			</div>
			<div>
				<span class="stitle">회의 날짜</span>
				<span class="select_box">
					<select id="year" name="year" class="box2" ></select>
					<select id="month" name="month" class="box3" ></select>
					<select id="day" name="day" class="box3" ></select>
				</span>
			</div>
			<div class="start_time">
				<span class="stitle">회의시작 시간</span>
				<span class="select_box">
					<select id="beforeHour" name="hour" class="box4" ></select>
					<select id="beforeMinute" name="minute" class="box3" ></select>
				</span>
			</div>
			<div class="end_time">					
				<span class="stitle">회의종료 시간</span>
				<span class="select_box" style="width:364px;">
					<select id="afterHour" name="hour" class="box4" ></select>
					<select id="afterMinute" name="minute" class="box3" ></select>
				</span>
			</div>
			<div>
				<span class="stitle">보내는 사람</span>
				<span>
					<input type="text" id="fromEmail" name="fromEmail" class="box1" autocomplete="off">
				</span>
			</div>
			<div>
				<span class="stitle">받는 사람</span>
				<span>
					<input type="text" class="toEmail box1" autocomplete="off">
					<input type="text" class="toEmail box1" autocomplete="off">
					<input type="text" class="toEmail box1" autocomplete="off">
				</span>
			</div>
			<div class="btn_send">
				<button class="send" onclick="dataSend()">이메일 보내기</button>
			</div>
		</div>		
	</div>		
</div>
</body>
</html>