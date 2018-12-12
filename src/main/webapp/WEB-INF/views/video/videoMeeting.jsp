<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css" />
<script src="https://code.jquery.com/jquery.js"></script>
<script src="https://cdn.webrtc-experiment.com/getScreenId.js"></script>
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/html2pdf.bundle.min.js"></script> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bluebird.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/html2canvas.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jspdf.min.js"></script>
<script type="text/javascript">
navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;

/* var configuration = {
'iceServers': [{url:'stun:stun01.sipphone.com'},
	{url:'stun:stun.ekiga.net'},
	{url:'stun:stun.fwdnet.net'},
	{url:'stun:stun.ideasip.com'},
	{url:'stun:stun.iptel.org'},
	{url:'stun:stun.rixtelecom.se'},
	{url:'stun:stun.schlund.de'},
	{url:'stun:stun.l.google.com:19302'},
	{url:'stun:stun1.l.google.com:19302'},
	{url:'stun:stun2.l.google.com:19302'},
	{url:'stun:stun3.l.google.com:19302'},
	{url:'stun:stun4.l.google.com:19302'},
	{url:'stun:stunserver.org'},
	{url:'stun:stun.softjoys.com'},
	{url:'stun:stun.voiparound.com'},
	{url:'stun:stun.voipbuster.com'},
	{url:'stun:stun.voipstunt.com'},
	{url:'stun:stun.voxgratia.org'},
	{url:'stun:stun.xten.com'}]
}; */
/* var configuration = {
	'iceServers': [{
		url: 'turn:192.168.0.199:2222',
		username: 'daekyo',
		credential: 'daekyo1234'
	}]
}; */
var timestamp = parseInt(Date.now()/1000) + 24*3600;

var configuration = {
	'iceServers': [
		/*{urls:'stun:stun01.sipphone.com'},
		{urls:'stun:stun.ekiga.net'},
		{urls:'stun:stun.fwdnet.net'},
		{urls:'stun:stun.ideasip.com'},
		{urls:'stun:stun.iptel.org'},
		{urls:'stun:stun.rixtelecom.se'},
		{urls:'stun:stun.schlund.de'},
		{urls:'stun:stun.l.google.com:19302'},
		{urls:'stun:stun1.l.google.com:19302'},
		{urls:'stun:stun2.l.google.com:19302'},
		{urls:'stun:stun3.l.google.com:19302'},
		{urls:'stun:stun4.l.google.com:19302'},
		{urls:'stun:stunserver.org'},
		{urls:'stun:stun.softjoys.com'},
		{urls:'stun:stun.voiparound.com'},
		{urls:'stun:stun.voipbuster.com'},
		{urls:'stun:stun.voipstunt.com'},
		{urls:'stun:stun.voxgratia.org'},
		{urls:'stun:stun.xten.com'},*/
		/*{
	        urls: 'turn:192.168.56.131:3478?transport=udp',
	        username: timestamp + ':daekyo',
	        credential: '1a29891f0d10e29aba7d3263e2389b01',
	        credentialType: 'password'
	     },{
	        urls: 'turn:192.168.56.131:3478?transport=tcp',
	        username: timestamp + ':daekyo',
	        credential: '1a29891f0d10e29aba7d3263e2389b01',
	        credentialType: 'password'
	     }*/
	     /*{
	        urls: 'turn:192.168.56.131:3478?transport=udp',
	        username: 'north',
	        //credential: 'daekyo1234',
	        credential: 'MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEK',
	        //credentialType: 'password'
	        	credentialType: 'token'
	     },{
	        urls: 'turn:192.168.56.131:3478?transport=tcp',
	        username: 'north',
	        //credential: 'daekyo1234',
	        credential: 'MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEK',
	        //credentialType: 'password'
	        credentialType: 'token'
	     }*/
	     {
	        urls: 'turn:192.168.56.131:3478?transport=udp',
	        username: 'daekyo',
	        //credential: 'daekyo1234',
	        credential: {
	            macKey: 'MWEyOTg5MWYwZDEwZTI5YWJhN2QzMjYzZTIzODliMDE=',
	            accessToken: 'AAwns7z83TYXZM4sJkM1r//5Gugxy1GLthrSSZug8LMHpxDJB+41Mrg+0hOkHfHCqdM8GW4uMP/pQYwtWiha9ptajRY='
	        },
	        	credentialType: 'oauth'
	     },{
	        urls: 'turn:192.168.56.131:3478?transport=tcp',
	        username: 'daekyo',
	        credential: {
	            macKey: 'MWEyOTg5MWYwZDEwZTI5YWJhN2QzMjYzZTIzODliMDE=',
	            accessToken: 'AAwns7z83TYXZM4sJkM1r//5Gugxy1GLthrSSZug8LMHpxDJB+41Mrg+0hOkHfHCqdM8GW4uMP/pQYwtWiha9ptajRY='
	        },
	        credentialType: 'oauth'
	     }
     ]
};

var streamData;
var rtcMap = new Map();
var peerList = [];
var user;

var canvas;
var context;
var isLeftButtonPressed = false;
var isEraser = false;
var oldX = 0;
var oldY = 0;
var dMap = new Map();
var lMap = new Map();

var screenMap = new Map();
var dSMap = new Map();
var canvasS;
var contextS;
var sOldX = 0;
var sOldY = 0;
var screenIsLeftButtonPressed = false;
var sIsEraser = false;
var canvasSave;
var contextSave;
var totalPeerList = [];

var imgs;
var imgCount;
var imgPosition = 1;

var dPMap = new Map();
var dPTMap = new Map();
var dPCMap = new Map();
var canvasP;
var canvasPMap = new Map();
var contextP;
var pOldX = new Map();
var pOldY = new Map();
var pdfIsLeftButtonPressed = false;
var pIsEraser = false;
var pdfRes;

$(function(){
	if(isMobile.Android()){
		window.location.href = '/room/videoMobileIntro/${roomId}';
	}

	canvas = $('#canvasView')[0];
	canvas.width  = $('.content2').width();
	canvas.height = $('.content2').height();
	context = canvas.getContext('2d');
	$('.content1').hide();
	$('.content3').hide();
	$('#toolbar3').hide();
	$('#pClose').hide();
	
	canvasS = $('#screenCView')[0];
	contextS = canvasS.getContext('2d');
	canvasS.width  = $('.content1').width();
	canvasS.height  = $('.content1').height();
	canvasS.style.top = -$('.content1').height()+'px';
	canvasSave = $('#screenSave')[0];
	canvasSave.width = $('.content1').width();
	canvasSave.height = $('.content1').height();
	contextSave = canvasSave.getContext('2d');
	showChromeExtensionStatus();
	
    window.IsAndroidChrome = false;
    try {
        if (navigator.userAgent.toLowerCase().indexOf("android") > -1 && /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor)) {
            window.IsAndroidChrome = true;
        }
    } catch (e) {}
    
    var obj = $(".content3");

    obj.on('dragenter', function (e) {
         e.stopPropagation();
         e.preventDefault();
    });

    obj.on('dragleave', function (e) {
         e.stopPropagation();
         e.preventDefault();
    });

    obj.on('dragover', function (e) {
         e.stopPropagation();
         e.preventDefault();
    });

    obj.on('drop', function (e) {
         e.preventDefault();

         var files = e.originalEvent.dataTransfer.files;
         if(files.length < 1)
              return;

         F_FileMultiUpload(files, obj);
    });
	
	var loc = window.location
	//var uri = "ws://" + loc.hostname + ":8080/api/websocket/echo.do?roomId=${roomId}";
	var uri = "wss://" + loc.hostname + ":8443/api/websocket/echo.do?roomId=${roomId}";
	sock = new WebSocket(uri);
	    
	sock.onopen = function(e) {
		sendMessage({type:"login", width:$('#canvasView').width(), height:$('#canvasView').height()});
		console.log('open', e);
	}
	
	sock.onclose = function(e) {
		console.log('close', e);
	}
	
	sock.onerror = function(e) {
		console.log('error', e);
	}
	
	sock.onmessage = function(e) {
		console.log('message', e.data);
		
		var message = JSON.parse(e.data);
		
		if(message.type === 'login'){
			var peers = message.dests;
			user = message.user;
			for(var i=0; i<peers.length; i++){
				peerList.push(peers[i].dest);
				totalPeerList.push(peers[i].dest);
			}

			if(peerList.length !== 0){
				startRTC(peerList);
			}
			
			if(message.screen === true){
				
			}
		}else if(message.type === 'loginData'){
			for(var i=0; i<message.draws.length; i++){
				if(message.draws[i].type === 'draw_down'){
					lMap.set(message.user, message.draws[i]);
				}else if(message.draws[i].type === 'draw_move'){
					context.beginPath();
					var msg = lMap.get(message.user);

					context.moveTo(msg.x, msg.y);
					
					if(message.draws[i].eraser === true){
						context.clearRect(message.draws[i].x-5, message.draws[i].y-5, 10, 10);
					}else if(message.draws[i].eraser === false){
						context.lineTo(message.draws[i].x, message.draws[i].y);
					}

					lMap.set(message.user, message.draws[i]);
					
					context.lineWidth = 2;
					context.strokeStyle = message.draws[i].color;
					context.stroke();
				}
			}
			
			if(message.pdf !== undefined){
				$('#pdf').click();
				$('#toolbar3').show();
				
				var strDom = "";
				strDom += '<div class="back"><img id="back" src="${pageContext.request.contextPath}/resources/image/btn_prev.png" alt="" onclick="back()"></div><ul>';
				
				for(var i=0; i<message.pdf.data.list.length; i++){
					strDom += '<li><img src="'+message.pdf.data.url+'/pdfImg/${roomId}/'+message.pdf.data.list[i].pdfPath+'" alt="" onload="imgCallBack()" style="position: relative; z-index: 1;">'
					+'<canvas onmousedown="pdfMouseDown(event)" onmousemove="pdfMouseMove(event)" onmouseup="pdfMouseEnd()" onmouseout="pdfMouseEnd()" style="position: relative; z-index: 2;"></canvas></li>';
				}
				
				strDom += '</ul><div class="next"><img id="next" src="${pageContext.request.contextPath}/resources/image/btn_next.png" alt="" onclick="next()"></div>';
				
				$('#silde').append(strDom);
				
				$('#silde').children('ul').css('width', ($('#silde').width()-$('#silde').children('div').width()*2)*message.pdf.data.list.length);
				$('#silde').children('ul').css('height', $('#silde').height());
				$('#silde').children('ul').css('margin-left', $('.back').width());
				$('#silde').children('ul').children('li').css('width', ($('#silde').width()-$('#silde').children('div').width()*2));
				$('#silde').children('ul').children('li').children('img').css('width', ($('#silde').width()-$('#silde').children('div').width()*2));
				
				imgs = $('#silde ul');
				imgCount = message.pdf.data.list.length;
				pdfRes = message.pDraws;
			}
		}else if(message.type === 'logout'){
			rtcMap.get(message.dest).close();
			rtcMap.delete(message.dest);
			document.getElementById(message.dest).setAttribute('src','');
			
			var pos = totalPeerList.indexOf(message.dest);
			totalPeerList.splice(pos, 1);
			if(screenMap.get(message.dest) !== undefined){
				if(screenMap.size === 1){
					$('#screenViewDiv').hide();
					$('#screenShare').show();
				}
				
				screenMap.get(message.dest).close();
				screenMap.delete(message.dest);	
			}
		}else if (message.type === 'rtc') {
			var peer = message.dest;
			peerList = [];
			peerList.push(peer);
			
			if(rtcMap.get(peer) === undefined){
				totalPeerList.push(peer);
				startRTC(peerList);
			}
			
			if (message.data.sdp) {
				rtcMap.get(peer).setRemoteDescription(
				new RTCSessionDescription(message.data.sdp),
				function () {
					if (rtcMap.get(peer).remoteDescription.type == 'offer') {
						peer = message.dest;
						rtcMap.get(peer).createAnswer(localDescCreated.bind({type: 'rtc', peer: peer}), logError);
					}
				},
				logError);
			}else {
				rtcMap.get(peer).addIceCandidate(new RTCIceCandidate(message.data.candidate));
			}
		}else if(message.type === 'draw_down'){
			dMap.set(message.user, message);
		}else if(message.type === 'draw_move'){
			context.beginPath();
			var msg = dMap.get(message.user);

			context.moveTo(msg.x, msg.y);
			
			if(message.eraser === true){
				context.clearRect(message.x-5, message.y-5, 10, 10);
			}else if(message.eraser === false){
				context.lineTo(message.x, message.y);
			}

			dMap.set(message.user, message);
			
			context.lineWidth = 2;
			context.strokeStyle = msg.color;
			context.stroke();
		}else if(message.type === 'draw_clear'){
			context.clearRect(0, 0, canvas.width, canvas.height);
			context.beginPath();
		}else if(message.type === 'screen_on'){
			var peer = message.dest;
			
			if(screenMap.get(peer) === undefined){
				$('#screen').click();
				$('#screenShare').hide();
				$('#close').hide();
				$('#screenViewDiv').show();
				$('#screenView').css({ width: $('.content1').width(), height: $('.content1').height() });
				
				var pc = new RTCPeerConnection();
				pc.onicecandidate = onicecandi.bind({type: 'screen_on', peer: peer});
				pc.onaddstream = gotRemoteStream;
				screenMap.set(peer, pc);
			}
			
			if (message.data.sdp) {
				screenMap.get(peer).setRemoteDescription(
				new RTCSessionDescription(message.data.sdp),
				function () {
				              // if we received an offer, we need to answer
					if (screenMap.get(peer).remoteDescription.type == 'offer') {
						peer = message.dest;
						var sdpConstraints = {
						    'mandatory': {
						      'OfferToReceiveAudio': true,
						      'OfferToReceiveVideo': true
						    }
						};
						
						screenMap.get(peer).createAnswer(localDescCreated.bind({type: 'screen_on', peer: peer}), logError, sdpConstraints);
					}
				},
				logError);
			}else {
				screenMap.get(peer).addIceCandidate(new RTCIceCandidate(message.data.candidate));
			}
		}else if(message.type === 'screen_off'){
			screenMap.get(message.dest).close();
			screenMap.delete(message.dest);
			
			$('#screenViewDiv').hide();
			$('#screenShare').show();
		}else if(message.type === 's_draw_down'){
			dSMap.set(message.user, message);
		}else if(message.type === 's_draw_move'){
			contextS.beginPath();
			var msg = dSMap.get(message.user);

			contextS.moveTo(msg.x, msg.y);
			
			if(message.eraser === true){
				contextS.clearRect(message.x-5, message.y-5, 10, 10);
			}else if(message.eraser === false){
				contextS.lineTo(message.x, message.y);
			}

			dSMap.set(message.user, message);
			
			contextS.lineWidth = 2;
			contextS.strokeStyle = msg.color;
			contextS.stroke();
		}else if(message.type === 's_draw_clear'){
			contextS.clearRect(0, 0, canvasS.width, canvasS.height);
			contextS.beginPath();
		}else if(message.type === 'pdf_on'){
			$('#pdf').click();
			$('#toolbar3').show();
			
            var strDom = "";
			strDom += '<div class="back"><img id="back" src="${pageContext.request.contextPath}/resources/image/btn_prev.png" alt="" onclick="back()"></div><ul>';
			
			for(var i=0; i<message.data.list.length; i++){
				strDom += '<li><img src="'+message.data.url+'/pdfImg/${roomId}/'+message.data.list[i].pdfPath+'" alt="" onload="imgCallBack()" style="position: relative; z-index: 1;">'
				+'<canvas onmousedown="pdfMouseDown(event)" onmousemove="pdfMouseMove(event)" onmouseup="pdfMouseEnd()" onmouseout="pdfMouseEnd()" style="position: relative; z-index: 2;"></canvas></li>';
			}
			
			strDom += '</ul><div class="next"><img id="next" src="${pageContext.request.contextPath}/resources/image/btn_next.png" alt="" onclick="next()"></div>';
			
			$('#silde').append(strDom);
			
			$('#silde').children('ul').css('width', ($('#silde').width()-$('#silde').children('div').width()*2)*message.data.list.length);
			$('#silde').children('ul').css('height', $('#silde').height());
			$('#silde').children('ul').css('margin-left', $('.back').width());
			$('#silde').children('ul').children('li').css('width', ($('#silde').width()-$('#silde').children('div').width()*2));
			$('#silde').children('ul').children('li').children('img').css('width', ($('#silde').width()-$('#silde').children('div').width()*2));
			
			imgs = $('#silde ul');
			imgCount = message.data.list.length;
		}else if(message.type === 'pdf_off'){
			dPMap = new Map();
			dPTMap = new Map();
			canvasPMap = new Map();
			dPCMap = new Map();
			pOldX = new Map();
			pOldY = new Map();
			
			$('#toolbar3').hide();
			imgPosition = 1;
			$("#silde").empty();
			pdfRes = undefined;
		}else if(message.type === 'pdf_back'){
			if(1<imgPosition){
				imgs.animate({
					left:"+="+$('#silde').children('ul').children('li').width()
				});
				imgPosition--;
			}
		}else if(message.type === 'pdf_next'){
			if(imgCount>imgPosition){
				imgs.animate({
					left:"-="+$('#silde').children('ul').children('li').width()
				});
				imgPosition++;
			}
		}else if(message.type === 'p_draw_down'){
			dPTMap.set(imgPosition, dPMap.set(message.user, message));
		}else if(message.type === 'p_draw_move'){
			dPCMap.get(imgPosition).beginPath();
			var msg = dPTMap.get(imgPosition).get(message.user);
			
			dPCMap.get(imgPosition).moveTo(msg.x, msg.y);
			
			if(message.eraser === true){
				dPCMap.get(imgPosition).clearRect(message.x-5, message.y-5, 10, 10);
			}else if(message.eraser === false){
				dPCMap.get(imgPosition).lineTo(message.x, message.y);
			}

			dPTMap.get(imgPosition).set(message.user, message);
			
			dPCMap.get(imgPosition).lineWidth = 2;
			dPCMap.get(imgPosition).strokeStyle = msg.color;
			dPCMap.get(imgPosition).stroke();
		}else if(message.type === 'p_draw_clear'){
			dPCMap.get(imgPosition).clearRect(0, 0, canvasPMap.get(imgPosition).width, canvasPMap.get(imgPosition).height);
			dPCMap.get(imgPosition).beginPath();
		}else if(message.type === 'error'){
			window.location.href = '/room/error/'+message.code;
		}
	}

	navigator.getUserMedia({
		'audio': true,
		'video': {
			width: $('.meeting').children().width(),
			height:  $('.meeting').children().height()
		}
	}, function (stream) {
		selfView.src = URL.createObjectURL(stream);

		streamData = stream;
		
		if(peerList.length !== 0){
			peerList.forEach(function(item, index, array){
				rtcMap.get(peerList[index]).addStream(stream);
			});
			
			offer();
		}
	}, logError);
});

function logError(error) {
	console.log(error.name + ': ' + error.message);
}

function startRTC(peerList) {
	peerList.forEach(function(item, index, array){
		var pc = new RTCPeerConnection();
		
		pc.setConfiguration(configuration);
		pc.onicecandidate = onicecandi.bind({type: 'rtc', peer: peerList[index]});
		pc.onaddstream = addstream.bind({peer: peerList[index]});
		
		if(streamData !== undefined){
			pc.addStream(streamData);
		}
		
		rtcMap.set(peerList[index], pc);
	});
}

function offer() {
	peerList.forEach(function(item, index, array){
		rtcMap.get(peerList[index]).createOffer(localDescCreated.bind({type: 'rtc', peer: peerList[index]}), logError)	;
	});
}

function addstream(evt){
	for(var i=0; i<$('.remoteView').length; i++){
		if($('.remoteView')[i].getAttribute('src') == ""){
			$('.remoteView')[i].setAttribute('src', URL.createObjectURL(evt.stream));
			$('.remoteView')[i].setAttribute('id', this.peer);
			break;
		}
	}
}

function onicecandi(evt){
	if (evt.candidate) {
		sendMessage({type: this.type, dest: this.peer, data: {'candidate': evt.candidate}});
	}
}


function localDescCreated(desc) {
	if(this.type === 'rtc'){
		rtcMap.get(this.peer).setLocalDescription(desc, function(){}, logError);
	}else if(this.type === 'screen_on'){
		screenMap.get(this.peer).setLocalDescription(desc, function(){}, logError);
	}
	
	sdpSendData(this.type, this.peer);
};

function sdpSendData(type, peer){
	var sdp;
	
	if(type === 'rtc'){
		sdp = rtcMap.get(peer).localDescription;
	}else if(type === 'screen_on'){
		sdp = screenMap.get(peer).localDescription;
	}
	
	sendMessage({type: type, dest: peer, data: {'sdp': sdp}});
}

function sendMessage(payload) {
	sock.send(JSON.stringify(payload));
}

function onMouseDown(event){
	var event = event || window.event;
	var button = event.which || event.button;
	
	if (button == 1) {
		isLeftButtonPressed = true;
		oldX = event.offsetX;
		oldY = event.offsetY;
		var color = $('#color').val();
		sendMessage({type:"draw_down", user:user, x:oldX, y:oldY, color:color, eraser:isEraser, width:$('#canvasView').width(), height:$('#canvasView').height()});
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
		var color = $('#color').val();
		sendMessage({type:"draw_move", user:user, x:oldX, y:oldY, color:color, eraser:isEraser, width:$('#canvasView').width(), height:$('#canvasView').height()});
		
		context.lineWidth = 2;
		context.strokeStyle = color;
		context.stroke();
	}
}

function onMouseEnd(){
	isLeftButtonPressed = false;
	var color = $('#color').val();
	sendMessage({type:"draw_up", user:user, x:oldX, y:oldY, color:color, eraser:isEraser, width:$('#canvasView').width(), height:$('#canvasView').height()});
}

function pen(){
	isEraser = false;
}

function eraser(){
	isEraser = true;
}

function canvasClear(){
	var color = $('#color').val();
	sendMessage({type:"draw_clear", user:user, x:oldX, y:oldY, color:color, eraser:isEraser, width:$('#canvasView').width(), height:$('#canvasView').height()});
	context.clearRect(0, 0, canvas.width, canvas.height);
	context.beginPath();
}

function contentChange(evt){
	if(evt.id === 'writer'){
		$('.content1').hide();
		$('.content2').show();
		$('.content3').hide();
		$('#screen').attr('src', '${pageContext.request.contextPath}/resources/image/btn_1_off.png');
		$('#writer').attr('src', '${pageContext.request.contextPath}/resources/image/btn_2_on.png');
		$('#pdf').attr('src', '${pageContext.request.contextPath}/resources/image/btn_3_off.png');
	}else if(evt.id === 'screen'){
		$('.content1').show();
		$('.content2').hide();
		$('.content3').hide();
		$('#screen').attr('src', '${pageContext.request.contextPath}/resources/image/btn_1_on.png');
		$('#writer').attr('src', '${pageContext.request.contextPath}/resources/image/btn_2_off.png');
		$('#pdf').attr('src', '${pageContext.request.contextPath}/resources/image/btn_3_off.png');
	}else if(evt.id === 'pdf'){
		$('.content1').hide();
		$('.content2').hide();
		$('.content3').show();
		$('#screen').attr('src', '${pageContext.request.contextPath}/resources/image/btn_1_off.png');
		$('#writer').attr('src', '${pageContext.request.contextPath}/resources/image/btn_2_off.png');
		$('#pdf').attr('src', '${pageContext.request.contextPath}/resources/image/btn_3_on.png');
	}
}

function showChromeExtensionStatus() {
	if(typeof window.getChromeExtensionStatus !== 'function'){
		return;
	}
	
	var gotResponse;
	
	window.getChromeExtensionStatus(function(status) {
		gotResponse = true;
		
		if(status == 'not-installed') {
			alert('필수 프로그램을 설치하고 재접속하여 주시기 바랍니다.');                    
	        window.open('https://chrome.google.com/webstore/detail/screen-capturing/ajhifddimkapgcifgcodmmfdlknahffk', '_blank'); 
	        window.opener='Self';
	        window.open('','_parent','');
	        window.close();
		}else{
			$('#screenViewDiv').hide();
		}
	});
}

function gotRemoteStream(event) {
	  try {
		  screenView.srcObject = event.stream;
	  } catch (error) {
		  screenView.src = URL.createObjectURL(event.stream);
	  }
}

function screenShare(){
	if(totalPeerList.length !== 0){
		getScreenId(function(error, sourceId, screen_constraints) {
			navigator.mediaDevices.getUserMedia(screen_constraints).then(function(stream) {
				if (IsAndroidChrome) {
	                screen_constraints = {
	                    mandatory: {
	                        chromeMediaSource: 'screen'
	                    },
	                    optional: []
	                };
	                
	                screen_constraints = {
	                    video: screen_constraints
	                };

	                error = null;
	            }
				
				if(error == 'permission-denied') {
	                return;
				}
				
				$('#screenShare').hide();
				$('#screenViewDiv').show();
				$('#close').show();
				$('#screenView').css({ width: $('.content1').width(), height: $('.content1').height() });
				
				screenView.srcObject = stream;
				
				totalPeerList.forEach(function(item, index, array){
					var pc = new RTCPeerConnection();
		            pc.onicecandidate = onicecandi.bind({type: 'screen_on', peer: totalPeerList[index]});
		            pc.addStream(stream);
		            
		            screenMap.set(totalPeerList[index], pc);
				});
				
				totalPeerList.forEach(function(item, index, array){
					screenMap.get(totalPeerList[index]).createOffer(localDescCreated.bind({type: 'screen_on', peer: totalPeerList[index]}), logError);		
				});
				
	            stream.oninactive = stream.onended = function() {
	            		screenView.src = '';
	            };
	        }).catch(function(error) {
	            console.error('getScreenId error', error);
	        });
		});
	}else{
		alert('접속자 2명 이상일 경우 사용 가능합니다.');
	}
	
}

function screenShareDone(){
	totalPeerList.forEach(function(item, index, array){
		sendMessage({type:"screen_off", user:user, dest: item});
		screenMap.get(item).close();
		screenMap.delete(item);
	});
	screenView.src = '';
	$('#screenViewDiv').hide();
	$('#screenShare').show();
}

function screenMouseDown(event){
	var event = event || window.event;
	var button = event.which || event.button;
	
	if (button == 1) {
		screenIsLeftButtonPressed = true;
		sOldX = event.offsetX;
		sOldY = event.offsetY;
		var color = $('#sColor').val();
		sendMessage({type:"s_draw_down", user:user, x:sOldX, y:sOldY, color:color, eraser:sIsEraser, width:$('#screenCView').width(), height:$('#screenCView').height()});
	}else{
		screenIsLeftButtonPressed = false;
	}	
}

function screenMouseMove(event){
	if (screenIsLeftButtonPressed) {
		contextS.beginPath();

		contextS.moveTo(sOldX, sOldY);
		if(sIsEraser === true){
			contextS.clearRect(event.offsetX-5, event.offsetY-5, 10, 10);
		}else if(sIsEraser === false){
			contextS.lineTo(event.offsetX, event.offsetY);
		}
		
		sOldX = event.offsetX;
		sOldY = event.offsetY;
		var color = $('#sColor').val();
		sendMessage({type:"s_draw_move", user:user, x:sOldX, y:sOldY, color:color, eraser:sIsEraser, width:$('#screenCView').width(), height:$('#screenCView').height()});
		
		contextS.lineWidth = 2;
		contextS.strokeStyle = color;
		contextS.stroke();
	}
}

function screenMouseEnd(){
	screenIsLeftButtonPressed = false;
	var color = $('#sColor').val();
	sendMessage({type:"s_draw_up", user:user, x:sOldX, y:sOldY, color:color, eraser:sIsEraser, width:$('#screenCView').width(), height:$('#screenCView').height()});
}

function sPen(){
	sIsEraser = false;
}

function sEraser(){
	sIsEraser = true;
}

function sCanvasClear(){
	var color = $('#sColor').val();
	sendMessage({type:"s_draw_clear", user:user, x:sOldX, y:sOldY, color:color, eraser:sIsEraser, width:$('#screenCView').width(), height:$('#screenCView').height()});
	contextS.clearRect(0, 0, canvasS.width, canvasS.height);
	contextS.beginPath();
}

function sPdfSave(){
	contextSave.drawImage($('#screenView')[0], 0, 0, $('#screenView').width(), $('#screenView').height());
	contextSave.drawImage(canvasS, 0, 0);
	//var myImage = canvasS.toDataURL("image/png"); 
	var link = document.createElement('a');
    link.download = "bottle-design.png";
    link.href = canvasSave.toDataURL("image/png").replace("image/png", "image/octet-stream");
    link.click();
	/* html2canvas($("#screenDiv"), {
		  onrendered: function(canvas) {
		 
		    // 캔버스를 이미지로 변환
		    var imgData = canvas.toDataURL('image/png');
		     
		    var imgWidth = 210; // 이미지 가로 길이(mm) A4 기준
		    var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
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
		}); */
	/*  var canvas ="";
	  html2canvas($("#screenDiv"), {
	  onrendered: function(canvas) {
	  // canvas is the final rendered <canvas> element
	   location.href = canvas.toDataURL('image/png').replace(/^data:image\/png/, 'data:application/octet-stream');
	     //Canvas2Image.saveAsPNG(canvas);
	  }
	  }); */
	 
	/* var div = $('#screenCView')[0];
	var opt = {
		filename:     'myfile.pdf',
		image:        { type: 'jpeg', quality: 0.98 },
		html2canvas:  { scale: 2, width: $('#screenView').width(), height: $('#screenView').height() },
		jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
		};
		
		// New Promise-based usage:
	html2pdf().from(div).set(opt).save(); */
}

var isMobile = { 
	Android: function() { 
		return /Android/i.test(navigator.userAgent); 
	}, 
	BlackBerry:function() { 
		return /BlackBerry/i.test(navigator.userAgent); 
	}, 
	iOS: function() { 
		return /iPhone|iPad|iPod/i.test(navigator.userAgent); 
	}, 
	Windows: function() { 
		return /IEMobile/i.test(navigator.userAgent); 
	}, 
	any: function() { 
		return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Windows()); 
	} 
};

function F_FileMultiUpload(files, obj) {
    if(confirm(files.length + "개의 파일을 업로드 하시겠습니까?") ) {
        var data = new FormData();
        for (var i = 0; i < files.length; i++) {
           data.append('file', files[i]);
        }

        $.ajax({
			url: 'upload/${roomId}',
			method: 'post',
			data: data,
			dataType: 'json',
			processData: false,
			contentType: false,
			success: function(res) {
				$('#toolbar3').show();
				$('#pClose').show();
				
	            var strDom = "";
				strDom += '<div class="back"><img id="back" src="${pageContext.request.contextPath}/resources/image/btn_prev.png" alt="" onclick="back()"></div><ul>';
				
				for(var i=0; i<res.list.length; i++){
					strDom += '<li><img src="'+res.url+'/pdfImg/${roomId}/'+res.list[i].pdfPath+'" alt="" onload="imgCallBack()" style="position: relative; z-index: 1;">'
					+'<canvas onmousedown="pdfMouseDown(event)" onmousemove="pdfMouseMove(event)" onmouseup="pdfMouseEnd()" onmouseout="pdfMouseEnd()" style="position: relative; z-index: 2;"></canvas></li>';
				}
				
				strDom += '</ul><div class="next"><img id="next" src="${pageContext.request.contextPath}/resources/image/btn_next.png" alt="" onclick="next()"></div>';
				
				$('#silde').append(strDom);
				
				$('#silde').children('ul').css('width', ($('#silde').width()-$('#silde').children('div').width()*2)*res.list.length);
				$('#silde').children('ul').css('height', $('#silde').height());
				$('#silde').children('ul').css('margin-left', $('.back').width());
				$('#silde').children('ul').children('li').css('width', ($('#silde').width()-$('#silde').children('div').width()*2));
				$('#silde').children('ul').children('li').children('img').css('width', ($('#silde').width()-$('#silde').children('div').width()*2));
				
				imgs = $('#silde ul');
				imgCount = res.list.length;
				sendMessage({type:"pdf_on", user:user, data:res});
           }
        });
    }
}

function imgCallBack(){
	for(var i=0; i<$('#silde').children('ul').children('li').length; i++){
		canvasP = $('#silde').children('ul').children('li').children('canvas')[i];
		$('#silde').children('ul').children('li').children('canvas')[i].style.width = $('#silde').children('ul').children('li').children('img')[i].width+'px';
		$('#silde').children('ul').children('li').children('canvas')[i].style.height = $('#silde').children('ul').children('li').children('img')[i].height+'px';            	   
		$('#silde').children('ul').children('li').children('canvas')[i].style.top = -$('#silde').children('ul').children('li').children('img')[i].height+'px';
		canvasP.width = $('#silde').children('ul').children('li').children('img')[i].width;
		canvasP.height = $('#silde').children('ul').children('li').children('img')[i].height;
		canvasPMap.set(i+1, canvasP);
		contextP = canvasP.getContext('2d');
		dPCMap.set(i+1, contextP);
		pOldX.set(i+1, 0);
		pOldY.set(i+1, 0);
	} 
	
	if(pdfRes !== undefined){
		for(var i=0; i<pdfRes.length; i++){
			var type = pdfRes[i].type;
			
			if(type === 'p_draw_down'){
				dPTMap.set(pdfRes[i].imgPosition, dPMap.set(pdfRes[i].user, pdfRes));
			}else if(type === 'p_draw_move'){
				dPCMap.get(pdfRes[i].imgPosition).beginPath();
				var msg = dPTMap.get(pdfRes[i].imgPosition).get(pdfRes[i].user);
				
				dPCMap.get(pdfRes[i].imgPosition).moveTo(msg.x, msg.y);
				
				if(pdfRes[i].eraser === true){
					dPCMap.get(pdfRes[i].imgPosition).clearRect(pdfRes[i].x-5, pdfRes[i].y-5, 10, 10);
				}else if(pdfRes[i].eraser === false){
					dPCMap.get(pdfRes[i].imgPosition).lineTo(pdfRes[i].x, pdfRes[i].y);
				}

				dPTMap.get(pdfRes[i].imgPosition).set(pdfRes[i].user, pdfRes);
				
				dPCMap.get(pdfRes[i].imgPosition).lineWidth = 2;
				dPCMap.get(pdfRes[i].imgPosition).strokeStyle = msg.color;
				dPCMap.get(pdfRes[i].imgPosition).stroke();
			}
		}
	}
}

function back(){
	if(1<imgPosition){
		imgs.animate({
			left:"+="+$('#silde').children('ul').children('li').width()
			//left: '+=644px'
		});
		imgPosition--;
		sendMessage({type:"pdf_back", user:user, imgPosition:imgPosition});
	}
}

function next(){
	if(imgCount>imgPosition){
		imgs.animate({
			left:"-="+$('#silde').children('ul').children('li').width()
			//left: '-=644px'
		});
		imgPosition++;
		sendMessage({type:"pdf_next", user:user, imgPosition:imgPosition});
	}
}

function pdfMouseDown(event){
	var event = event || window.event;
	var button = event.which || event.button;
	
	if (button == 1) {
		pdfIsLeftButtonPressed = true;
		pOldX.set(imgPosition, event.offsetX);
		pOldY.set(imgPosition, event.offsetY);
		var color = $('#pColor').val();
		sendMessage({type:"p_draw_down", user:user, x:pOldX.get(imgPosition), y:pOldY.get(imgPosition), color:color, eraser:pIsEraser, imgPosition:imgPosition, width:canvasPMap.get(imgPosition).width, height:canvasPMap.get(imgPosition).height});
	}else{
		pdfIsLeftButtonPressed = false;
	}	
}

function pdfMouseMove(event){
	if (pdfIsLeftButtonPressed) {
		dPCMap.get(imgPosition).beginPath();

		dPCMap.get(imgPosition).moveTo(pOldX.get(imgPosition), pOldY.get(imgPosition));
		if(pIsEraser === true){
			dPCMap.get(imgPosition).clearRect(event.offsetX-5, event.offsetY-5, 10, 10);
		}else if(pIsEraser === false){
			dPCMap.get(imgPosition).lineTo(event.offsetX, event.offsetY);
		}
		
		pOldX.set(imgPosition, event.offsetX);
		pOldY.set(imgPosition, event.offsetY);
		var color = $('#pColor').val();
		sendMessage({type:"p_draw_move", user:user, x:pOldX.get(imgPosition), y:pOldY.get(imgPosition), color:color, eraser:pIsEraser, imgPosition:imgPosition, width:canvasPMap.get(imgPosition).width, height:canvasPMap.get(imgPosition).height});
		
		dPCMap.get(imgPosition).lineWidth = 2;
		dPCMap.get(imgPosition).strokeStyle = color;
		dPCMap.get(imgPosition).stroke();
	}
}

function pdfMouseEnd(){
	pdfIsLeftButtonPressed = false;
	var color = $('#pColor').val();
	sendMessage({type:"p_draw_up", user:user, x:pOldX.get(imgPosition), y:pOldY.get(imgPosition), color:color, eraser:pIsEraser, imgPosition:imgPosition, width:canvasPMap.get(imgPosition).width, height:canvasPMap.get(imgPosition).height});
}

function pPen(){
	pIsEraser = false;
}

function pEraser(){
	pIsEraser = true;
}

function pCanvasClear(){
	var color = $('#pColor').val();
	sendMessage({type:"p_draw_clear", user:user, x:pOldX.get(imgPosition), y:pOldY.get(imgPosition), color:color, eraser:pIsEraser, imgPosition:imgPosition, width:canvasPMap.get(imgPosition).width, height:canvasPMap.get(imgPosition).height});
	dPCMap.get(imgPosition).clearRect(0, 0, canvasPMap.get(imgPosition).width, canvasPMap.get(imgPosition).height);
	dPCMap.get(imgPosition).beginPath();
}

function pdfShareDone(){
	dPMap = new Map();
	dPTMap = new Map();
	canvasPMap = new Map();
	dPCMap = new Map();
	pOldX = new Map();
	pOldY = new Map();
	
	sendMessage({type:"pdf_off", user:user});
	
	$('#toolbar3').hide();
	$('#pClose').hide();
	imgPosition = 1;
	$("#silde").empty();
	pdfRes = undefined;
}

function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr;
	for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++){
		x.src=x.oSrc;		
	}
}

function MM_preloadImages() { //v3.0
var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
<title>화상회의 화면공유</title>
</head>
<body onLoad="MM_preloadImages('${pageContext.request.contextPath}/resources/image/btn_1_off.png','${pageContext.request.contextPath}/resources/image/btn_2_on.png','${pageContext.request.contextPath}/resources/image/toolbar_icon_02_on.png','${pageContext.request.contextPath}/resources/image/toolbar_icon_03_on.png','${pageContext.request.contextPath}/resources/image/toolbar_icon_04_on.png')">
	<div id="wrap">
		<div class="header">
			<p class="title">화상회의 시스템 연구개발 회의</p>
			<div class="button">
				<span>
					<img src="${pageContext.request.contextPath}/resources/image/btn_2_on.png" width="153" height="48" id="writer" onclick="contentChange(this)">
				</span>
				<span>
					<img src="${pageContext.request.contextPath}/resources/image/btn_1_off.png" width="153" height="48" id="screen" onclick="contentChange(this)">
				</span>
				<span>
					<img src="${pageContext.request.contextPath}/resources/image/btn_3_off.png" width="153" height="48" id="pdf" onclick="contentChange(this)">
				</span>
			</div>
		</div>
		<div class="main">
			<div class="left">
				<ul class="meeting">
					<li>
						<video id="selfView" autoplay></video>
					</li>
					<li>
						<video class="remoteView" src="" autoplay></video>
					</li>
					<li>
						<video class="remoteView" src="" autoplay></video>
					</li>
					<li>
						<video class="remoteView" src="" autoplay></video>
					</li>
				</ul>
			</div>
			<div class="content1">
				<div id="screenViewDiv">
					<div id="close" class="close">
	                    	<img src="${pageContext.request.contextPath}/resources/image/btn_close.png" alt="" onclick="screenShareDone()">
	                </div>
					<div class="toolbar">
						<span class="span">
							<input type="color" id="sColor"/>
						</span>
						<span>
							<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_02.png" id="sPen" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('sPen','','${pageContext.request.contextPath}/resources/image/toolbar_icon_02_on.png',1)" onclick="sPen()">
						</span>
						<span>
							<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_03.png" id="sEraser" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('sEraser','','${pageContext.request.contextPath}/resources/image/toolbar_icon_03_on.png',1)" onclick="sEraser()">
						</span>
						<span>
							<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_04_1.png" id="sCanvasClear" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('sCanvasClear','','${pageContext.request.contextPath}/resources/image/toolbar_icon_04_1_on.png',1)" onclick="sCanvasClear()">
						</span>
						<span>
							<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_05.png" id="sPdfSave" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('sPdfSave','','${pageContext.request.contextPath}/resources/image/toolbar_icon_05_on.png',1)" onclick="sPdfSave()">
						</span>
					</div>
					<div id="screenDiv">
						<video id="screenView" src="" autoplay></video>
						<canvas id="screenCView" onmousedown="screenMouseDown(event)" onmousemove="screenMouseMove(event)" onmouseup="screenMouseEnd()" onmouseout="screenMouseEnd()"></canvas>
						<canvas id="screenSave"></canvas>
					</div>
				</div>
				<img src="${pageContext.request.contextPath}/resources/image/btn_sharing.png" id="screenShare" onclick="screenShare()">
			</div>
			<div class="content2">
				<div class="toolbar">
					<span class="span">
						<input type="color" id="color"/>
					</span>
					<span>
						<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_02.png" id="pen" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('pen','','${pageContext.request.contextPath}/resources/image/toolbar_icon_02_on.png',1)" onclick="pen()">
					</span>
					<span>
						<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_03.png" id="eraser" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('eraser','','${pageContext.request.contextPath}/resources/image/toolbar_icon_03_on.png',1)" onclick="eraser()">
					</span>
					<span>
						<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_04.png" id="canvasClear" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('canvasClear','','${pageContext.request.contextPath}/resources/image/toolbar_icon_04_on.png',1)" onclick="canvasClear()">
					</span>
				</div>
				<canvas id="canvasView" onmousedown="onMouseDown(event)" onmousemove="onMouseMove(event)" onmouseup="onMouseEnd()" onmouseout="onMouseEnd()"></canvas>
			</div>
			<div class="content3">
				<div id="pClose" class="close">
                   	<img src="${pageContext.request.contextPath}/resources/image/btn_close.png" alt="" onclick="pdfShareDone()">
	            </div>
				<div id="toolbar3" class="toolbar">
					<span class="span">
						<input type="color" id="pColor"/>
					</span>
					<span>
						<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_02.png" id="pPen" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('pPen','','${pageContext.request.contextPath}/resources/image/toolbar_icon_02_on.png',1)" onclick="pPen()">
					</span>
					<span>
						<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_03.png" id="pEraser" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('pEraser','','${pageContext.request.contextPath}/resources/image/toolbar_icon_03_on.png',1)" onclick="pEraser()">
					</span>
					<span>
						<img src="${pageContext.request.contextPath}/resources/image/toolbar_icon_04.png" id="pCanvasClear" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('pCanvasClear','','${pageContext.request.contextPath}/resources/image/toolbar_icon_04_on.png',1)" onclick="pCanvasClear()">
					</span>
				</div>
				<div id="silde">
					
				</div>
			</div>
		</div>		
	</div>
</body>
</html>