<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script type="text/javascript" src="https://code.jquery.com/jquery.js"></script>
<script type="text/javascript" src="https://html2canvas.hertzen.com/dist/html2canvas.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bluebird.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jspdf.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/html2pdf.bundle.min.js"></script>
<script type="text/javascript">
var canvas;
var context;
var isLeftButtonPressed = false;
var isEraser = false;
var oldX = 0;
var oldY = 0;

$(window).load(function(){
	canvas = $('#canvasView')[0];
	canvas.width  = $('#img').width();
	canvas.height = $('#img').height();
	canvas.style.top = (-($('#img').height()))+'px';
	$('#pdfDiv').css('height', $('#img').height());
	context = canvas.getContext('2d');
});

function onMouseDown(event){
	var event = event || window.event;
	var button = event.which || event.button;
	
	if (button == 1) {
		isLeftButtonPressed = true;
		oldX = event.offsetX;
		oldY = event.offsetY;
	}else{
		isLeftButtonPressed = false;
	}	
}

function onMouseMove(event){
	if (isLeftButtonPressed) {
		context.beginPath();

		context.moveTo(oldX, oldY);
		if(isEraser === true){
			context.clearRect(event.offsetX-5, event.offsetY-5, 10, 10);
		}else if(isEraser === false){
			context.lineTo(event.offsetX, event.offsetY);
		}
		
		oldX = event.offsetX;
		oldY = event.offsetY;
		
		context.lineWidth = 2;
		context.strokeStyle = "#000000";
		context.stroke();
	}
}

function onMouseEnd(){
	isLeftButtonPressed = false;
}

function pdfSave(){
	var div = $('#pdfDiv')[0];
	var opt = {
			  filename:     'myfile.pdf',
			  image:        { type: 'jpeg', quality: 0.98 },
			  html2canvas:  { scale: 2, width: $('#canvasView').width(), height: $('#canvasView').height() },
			  jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
			};

			// New Promise-based usage:
			html2pdf().from(div).set(opt).save();

	/*html2canvas(div, {
		  onrendered: function(canvas) {
		 
		    // 캔버스를 이미지로 변환
		    var imgData = canvas.toDataURL('image/png');
		     
		    var imgWidth = div.width; // 이미지 가로 길이(mm) A4 기준
		    var pageHeight = div.height;  // 출력 페이지 세로 길이 계산 A4 기준
		    var imgHeight = canvas.height * imgWidth / canvas.width;
		    var heightLeft = imgHeight;
		     
		        var doc = new jsPDF('p', 'mm');
		        var position = 0;
		         
		        // 첫 페이지 출력
		        doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
		        heightLeft -= pageHeight;
		         
		        // 한 페이지 이상일 경우 루프 돌면서 출력
		        while (heightLeft >= 20) {
		          position = heightLeft - imgHeight;
		          doc.addPage();
		          doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
		          heightLeft -= pageHeight;
		        }
		 
		        // 파일 저장
		        doc.save('sample_A4.pdf');
		  }
		});*/
}
</script>
<title>Insert title here</title>
</head>
<body>
<div id="pdfDiv">
	<img id="img" alt="" src="http://localhost:8080/img/${imgName }" style="position: relative; z-index: 1;"/>
	<canvas id="canvasView" onmousedown="onMouseDown(event)" onmousemove="onMouseMove(event)" onmouseup="onMouseEnd()" onmouseout="onMouseEnd()" style="position: relative; z-index: 2;"></canvas>
</div>
<button onclick="pdfSave()">저장</button>
</body>
</html>