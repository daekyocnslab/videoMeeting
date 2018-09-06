<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="//code.jquery.com/jquery.js"></script>
<script type="text/javascript">
function Map() {
	this.elements = {};
	this.length = 0;
}

Map.prototype.put = function(key,value) {
	this.length++;
	this.elements[key] = value;
}

Map.prototype.get = function(key) {
	return this.elements[key];
}

function List() {
	this.elements = {};
	this.idx = 0;
	this.length = 0;
}

List.prototype.add = function(element) {
	this.length++;
	this.elements[this.idx++] = element;
};
	
List.prototype.get = function(idx) {
	return this.elements[idx];
};

navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
var configuration = {
	'iceServers': [{
	'url': 'stun:stun.example.org'
	}]
};

var streamData;
var map = new Map();
var peerList = new List();
var user;

var canvas;
var context;
var isLeftButtonPressed = false;
var oldX = 0;
var oldY = 0;
var opOldX = 0;
var opOldY = 0;

$(function(){
	var loc = window.location
	var uri = "ws://" + loc.hostname + ":8080/websocket/echo.do?roomId=" + "${roomId}"
	//var uri = "wss://" + loc.hostname + ":8443/api/websocket/echo.do?roomId=" + "${roomId}"
	sock = new WebSocket(uri);
	    
	sock.onopen = function(e) {
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
				peerList.add(peers[i].dest);
			}

			if(peerList.length !== 0){
				startRTC(peerList);
			}
		}else if(message.type === 'logout'){
			map.get(message.dest).close();
			document.getElementById(message.dest).setAttribute('src','');
		}else if (message.type === 'rtc') {
			var peer = message.dest;
			peerList = new List();
			peerList.add(peer);
			if(map.get(peer) === undefined){
				startRTC(peerList);
			}
			
			if (message.data.sdp) {
				map.get(peer).setRemoteDescription(
				new RTCSessionDescription(message.data.sdp),
				function () {
				              // if we received an offer, we need to answer
					if (map.get(peer).remoteDescription.type == 'offer') {
						peer = message.dest;
						map.get(peer).createAnswer(localDescCreated.bind({peer: peer}), logError);
					}
				},
				logError);
			}else {
				map.get(peer).addIceCandidate(new RTCIceCandidate(message.data.candidate));
			}
		}else if(message.type === 'draw_down'){
			opOldX = message.x;
			opOldY = message.y;
		}else if(message.type === 'draw_move'){
			context.beginPath();
			
			context.moveTo(opOldX, opOldY);
			context.lineTo(message.x, message.y);
			
			opOldX = message.x;
			opOldY = message.y;
			
			context.lineWidth = 2;
			context.strokeStyle = '#ff0000';
			context.stroke();
		}else if(message.type === 'error'){
			window.location.href = '/room/error/'+message.code;
		}
	}

	navigator.getUserMedia({
		'audio': true,
		'video': true
	}, function (stream) {
		selfView.src = URL.createObjectURL(stream);
		
		canvas = $('#canvasView')[0];
		context = canvas.getContext('2d');
		
		streamData = stream;
		
		if(peerList.length !== 0){
			for(var i=0; i<peerList.length; i++){
				map.get(peerList.get(i)).addStream(stream);
			}
			
			offer();
		}
	}, logError);
	
	
});

function logError(error) {
	console.log(error.name + ': ' + error.message);
}

function startRTC(peerList) {
	for(var i=0; i<peerList.length; i++){
		var pc = new webkitRTCPeerConnection(configuration);

		pc.onicecandidate = onicecandi.bind({peer: peerList.get(i)});
		pc.onaddstream = addstream.bind({peer: peerList.get(i)});
		
		if(streamData !== undefined){
			pc.addStream(streamData);
		}
		
		map.put(peerList.get(i), pc);
	}
}

function offer() {
	for(var i=0; i<peerList.length; i++){
		map.get(peerList.get(i)).createOffer(localDescCreated.bind({peer: peerList.get(i)}), logError)	;
	}
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
		sendMessage(
		{
			type: "rtc",
			dest: this.peer,
			data: {
				'candidate': evt.candidate
			}
		}
		);
	}
}


function localDescCreated(desc) {
	map.get(this.peer).setLocalDescription(desc, function(){}, logError);
	
	sdpSendData(this.peer);
};

function sdpSendData(peer){
	sendMessage(
		{
			type: "rtc",
			dest: peer,
			data: {
				'sdp': map.get(peer).localDescription
			}
		}
	);
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
		sendMessage({type:"draw_down", user:user, x:oldX, y:oldY});
	}else{
		isLeftButtonPressed = false;
	}	
}

function onMouseMove(event){
	if (isLeftButtonPressed) {
		context.beginPath();
		
		context.moveTo(oldX, oldY);
		context.lineTo(event.offsetX, event.offsetY);
		
		oldX = event.offsetX;
		oldY = event.offsetY;
		sendMessage({type:"draw_move", user:user, x:oldX, y:oldY});
		
		context.lineWidth = 2;
		context.strokeStyle = '#FF9933';
		context.stroke();
	}
}

function onMouseUp(){
	isLeftButtonPressed = false;
}
</script>
<title>Insert title here</title>
</head>
<body>
	<div>
		<video id="selfView" width="320" height="240" autoplay style="display: inline;"></video>
	</div>
	<div>
		<video class="remoteView" src="" width="320" height="240" autoplay style="display: inline;"></video>
	</div>
	<div>
		<video class="remoteView" src="" width="320" height="240" autoplay style="display: inline;"></video>
	</div>
	<div>
		<video class="remoteView" src="" width="320" height="240" autoplay style="display: inline;"></video>
	</div>
	<div>
		<canvas id="canvasView" width="500" height="500" onmousedown="onMouseDown(event)" onmousemove="onMouseMove(event)" onmouseup="onMouseUp()" style="border:1px solid black;"></canvas>
	</div>
</body>
</html>