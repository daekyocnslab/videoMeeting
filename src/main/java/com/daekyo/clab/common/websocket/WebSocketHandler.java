package com.daekyo.clab.common.websocket;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.daekyo.clab.common.vo.RoomAddVO;
import com.daekyo.clab.user.UserVO;

public class WebSocketHandler extends TextWebSocketHandler{
	
	protected Log log = LogFactory.getLog(WebSocketHandler.class);
	
	@Resource(name="websocketProperties")
	private Properties wProperties;
    private RoomAddVO roomAddVO = RoomAddVO.getInstance();
    private Iterator<String> keys;
    
	
	public WebSocketHandler() {
		super();
		log.info("create SocketHandler instance!");
	}
	
	@Override
	public boolean supportsPartialMessages() {
		log.info("call method!");
		return super.supportsPartialMessages();
	}
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);

		Map<String, Object> map = session.getAttributes();
		String roomId = map.get(wProperties.get("websocket.roomId")).toString();
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(wProperties.get("websocket.date").toString());
		Date date = new Date();
		
		//if(roomAddVO.getRoomList().get(roomId).getUserList().size() < roomAddVO.getRoomList().get(roomId).getMaxPersons()) {
			int startDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getRoomList().get(roomId).getStartDate())); 
			int endDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getRoomList().get(roomId).getEndDate()));
			
			if(startDate >= 0 && 0 >= endDate) {
				UserVO userVO = new UserVO();
				userVO.setSession(session);
				
				roomAddVO.getRoomList().get(roomId).getUserList().put(session.getId(), userVO);
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put(wProperties.get("websocket.type"), wProperties.get("websocket.login"));
				jsonObject.put(wProperties.get("websocket.user"), session.getId());
				jsonObject.put(wProperties.get("websocket.screen"), roomAddVO.getRoomList().get(roomId).isScreenAt());
				
				JSONArray destArray = new JSONArray();
				
				Iterator<String> keys = roomAddVO.getRoomList().get(roomId).getUserList().keySet().iterator();
				
				while(keys.hasNext()) {
					String key = keys.next();
					
					if(!key.equals(session.getId())) {
						JSONObject object = new JSONObject();
						object.put(wProperties.get("websocket.dest"), key);
						destArray.add(object);
					}
				}
				
				jsonObject.put(wProperties.get("websocket.dests"), destArray);
				
				System.out.println(jsonObject.toJSONString());
				synchronized (session) {
					session.sendMessage(new TextMessage(jsonObject.toJSONString()));											
				}
			}else {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put(wProperties.get("websocket.type"), wProperties.get("websocket.error"));
				jsonObject.put(wProperties.get("websocket.code"), "999");
				
				synchronized (session) {
					session.sendMessage(new TextMessage(jsonObject.toJSONString()));											
				}
			}
		/*}else {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put(wProperties.get("websocket.type"), wProperties.get("websocket.error"));
			jsonObject.put(wProperties.get("websocket.code"), "998");
			
			synchronized (session) {
				session.sendMessage(new TextMessage(jsonObject.toJSONString()));											
			}
		}*/
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		super.handleTextMessage(session, message);
		try {
			Map<String, Object> map = session.getAttributes();
			String roomId = map.get("roomId").toString();
			
			System.out.println(message.getPayload());
			
			JSONObject jsonObject = new JSONObject();
			JSONParser jsonParser = new JSONParser();
			JSONObject object = (JSONObject) jsonParser.parse(message.getPayload());
			
			String type = object.get("type").toString();
			
			switch (type) {
				case "login":
					roomAddVO.getRoomList().get(roomId).getUserList().get(session.getId()).setBoardWidth(Double.parseDouble(object.get(wProperties.get("websocket.width")).toString()));
					roomAddVO.getRoomList().get(roomId).getUserList().get(session.getId()).setBoardHeight(Double.parseDouble(object.get(wProperties.get("websocket.height")).toString()));
					
					JSONArray drawArray = new JSONArray();
					
					jsonObject.put(wProperties.get("websocket.type"), wProperties.get("websocket.loginData"));
					
					for(int i=0; i<roomAddVO.getRoomList().get(roomId).getDrawData().size(); i++) {
						jsonParser = new JSONParser();
						//object = (JSONObject) jsonParser.parse(roomAddVO.getRoomList().get(roomId).getDrawData().get(i));
						
						//if(object.get(wProperties.get("websocket.user")).toString() != null) {
							//JSONObject drawData = boardCoordformat(roomId, session.getId(), object.get(wProperties.get("websocket.user")).toString(), roomAddVO.getRoomList().get(roomId).getDrawData().get(i));
							
							JSONObject drawData = (JSONObject) jsonParser.parse(roomAddVO.getRoomList().get(roomId).getDrawData().get(i));
							drawArray.add(drawData);
						//}						
					}
					
					jsonObject.put(wProperties.get("websocket.draws"), drawArray);
					
					JSONArray pdfDrawArray = new JSONArray();
					
					if(roomAddVO.getRoomList().get(roomId).getPdfFiles() != null) {
						jsonObject.put(wProperties.get("websocket.pdf"), roomAddVO.getRoomList().get(roomId).getPdfFiles());
						
						for(int i=0; i<roomAddVO.getRoomList().get(roomId).getpDrawData().size(); i++) {
							//JSONObject pdfDrawData = boardCoordformat(roomId, session.getId(), object.get(wProperties.get("websocket.user")).toString(), roomAddVO.getRoomList().get(roomId).getpDrawData().get(i));
							jsonParser = new JSONParser();
							JSONObject pdfDrawData = (JSONObject) jsonParser.parse(roomAddVO.getRoomList().get(roomId).getpDrawData().get(i));
							pdfDrawArray.add(pdfDrawData);
						}
						
						jsonObject.put(wProperties.get("websocket.pDraws"), pdfDrawArray);
					}
					
					synchronized (session) {
						session.sendMessage(new TextMessage(jsonObject.toJSONString()));
					}
					break;
				case "rtc":
				case "screen_on":
				case "screen_off":
					if(type.equals("screen_on")) {
						roomAddVO.getRoomList().get(roomId).setScreenAt(true);
					}else if(type.equals("screen_off")){
						roomAddVO.getRoomList().get(roomId).getsDrawData().clear();
						roomAddVO.getRoomList().get(roomId).setScreenAt(false);
					}
					
					keys = roomAddVO.getRoomList().get(roomId).getUserList().keySet().iterator();
					
					while(keys.hasNext()) {
						String key = keys.next();
						
						if(key.equals(object.get(wProperties.get("websocket.dest")).toString())) {
							WebSocketSession webSocketSession = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getSession();

							jsonObject.put(wProperties.get("websocket.type"), type);
							jsonObject.put(wProperties.get("websocket.dest"), session.getId());
							jsonObject.put(wProperties.get("websocket.user"), webSocketSession.getId());
							jsonObject.put(wProperties.get("websocket.data"), object.get(wProperties.get("websocket.data")));
							
							synchronized (webSocketSession) {
								webSocketSession.sendMessage(new TextMessage(jsonObject.toJSONString()));
							}
						}
					}
					break;
				case "s_draw_down":
				case "s_draw_move":
				case "s_draw_up":
				case "s_draw_clear":
					JSONObject sDrawData = new JSONObject();
					
					if(type.equals("s_draw_down") || type.equals("s_draw_move") || type.equals("s_draw_up")) {
						roomAddVO.getRoomList().get(roomId).getsDrawData().add(message.getPayload());
						
						//drawData = boardCoordformat(roomId, session.getId(), key, message.getPayload());
					}else if(type.equals("s_draw_clear")){
						roomAddVO.getRoomList().get(roomId).getsDrawData().clear();
						
						//drawData = (JSONObject) jsonParser.parse(message.getPayload());
					}
					
					keys = roomAddVO.getRoomList().get(roomId).getUserList().keySet().iterator();
					
					while(keys.hasNext()) {
						String key = keys.next();
						
						if(!key.equals(session.getId())) {
							sDrawData = (JSONObject) jsonParser.parse(message.getPayload());
							
							WebSocketSession webSocketSession = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getSession();
							
							synchronized (webSocketSession) {
								webSocketSession.sendMessage(new TextMessage(sDrawData.toJSONString()));
							}
						}
					}
					break;
				case "draw_down":
				case "draw_move":
				case "draw_up":
				case "draw_clear":
					JSONObject drawData = new JSONObject();
					
					if(type.equals("draw_down") || type.equals("draw_move") || type.equals("draw_up")) {
						roomAddVO.getRoomList().get(roomId).getDrawData().add(message.getPayload());
						
						//drawData = boardCoordformat(roomId, session.getId(), key, message.getPayload());
					}else if(type.equals("draw_clear")){
						roomAddVO.getRoomList().get(roomId).getDrawData().clear();
						
						//drawData = (JSONObject) jsonParser.parse(message.getPayload());
					}
					
					keys = roomAddVO.getRoomList().get(roomId).getUserList().keySet().iterator();
					
					while(keys.hasNext()) {
						String key = keys.next();
						
						if(!key.equals(session.getId())) {
							drawData = (JSONObject) jsonParser.parse(message.getPayload());
							
							WebSocketSession webSocketSession = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getSession();
							
							synchronized (webSocketSession) {
								webSocketSession.sendMessage(new TextMessage(drawData.toJSONString()));
							}
						}
					}
					break;
				case "pdf_on":
				case "pdf_off":	
				case "pdf_back":
				case "pdf_next":
					if(type.equals("pdf_on")) {
						roomAddVO.getRoomList().get(roomId).setPdfFiles((JSONObject) jsonParser.parse(message.getPayload()));
					}else if(type.equals("pdf_off")) {
						roomAddVO.getRoomList().get(roomId).getPdfFiles().clear();
						roomAddVO.getRoomList().get(roomId).getpDrawData().clear();
						roomAddVO.getRoomList().get(roomId).setImgPosition("1");
					}else if(type.equals("pdf_back") || type.equals("pdf_next")) {
						roomAddVO.getRoomList().get(roomId).setImgPosition(object.get("imgPosition").toString());
					}
					
					keys = roomAddVO.getRoomList().get(roomId).getUserList().keySet().iterator();
					
					while(keys.hasNext()) {
						String key = keys.next();
						
						if(!key.equals(session.getId())) {
							WebSocketSession webSocketSession = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getSession();
							
							synchronized (webSocketSession) {
								webSocketSession.sendMessage(new TextMessage(message.getPayload()));
							}
						}
					}
					break;
				case "p_draw_down":
				case "p_draw_move":
				case "p_draw_up":
				case "p_draw_clear":
					JSONObject pDrawData = new JSONObject();
					
					if(type.equals("p_draw_down") || type.equals("p_draw_move") || type.equals("p_draw_up")) {
						roomAddVO.getRoomList().get(roomId).getpDrawData().add(message.getPayload());
						
						//drawData = boardCoordformat(roomId, session.getId(), key, message.getPayload());
					}else if(type.equals("p_draw_clear")){
						roomAddVO.getRoomList().get(roomId).getpDrawData().clear();
						
						//drawData = (JSONObject) jsonParser.parse(message.getPayload());
					}
					
					keys = roomAddVO.getRoomList().get(roomId).getUserList().keySet().iterator();
					
					while(keys.hasNext()) {
						String key = keys.next();
						
						if(!key.equals(session.getId())) {
							pDrawData = (JSONObject) jsonParser.parse(message.getPayload());
							
							WebSocketSession webSocketSession = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getSession();
							
							synchronized (webSocketSession) {
								webSocketSession.sendMessage(new TextMessage(pDrawData.toJSONString()));
							}
						}
					}
					break;
				default:
					break;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		super.afterConnectionClosed(session, status);
		Map<String, Object> map = session.getAttributes();
		String roomId = map.get(wProperties.get("websocket.roomId")).toString();
		
		removeSession(session, roomId);
		log.info("remove session!");
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		Map<String, Object> map = session.getAttributes();
		String roomId = map.get(wProperties.get("websocket.roomId")).toString();
		
		removeSession(session, roomId);
		log.error("web socket error!", exception);
	}
	
	private void removeSession(WebSocketSession session, String roomId) throws Exception {
		keys = roomAddVO.getRoomList().get(roomId).getUserList().keySet().iterator();
		
		while(keys.hasNext()) {
			String key = keys.next();
			
			if(!key.equals(session.getId())) {
				WebSocketSession webSocketSession = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getSession();
				
				JSONObject jsonObject = new JSONObject();
				jsonObject.put(wProperties.get("websocket.type"), wProperties.get("websocket.logout"));
				jsonObject.put(wProperties.get("websocket.dest"), session.getId());
				jsonObject.put(wProperties.get("websocket.user"), webSocketSession.getId());
				
				synchronized (webSocketSession) {
					webSocketSession.sendMessage(new TextMessage(jsonObject.toJSONString()));
				}
			}else {
				roomAddVO.getRoomList().get(roomId).getUserList().remove(key);
			}
		}
	}
	
	private JSONObject boardCoordformat(String roomId, String sessionId, String key, String message) throws Exception {
		Double ownWidth = roomAddVO.getRoomList().get(roomId).getUserList().get(sessionId).getBoardWidth();
		Double ownHeight = roomAddVO.getRoomList().get(roomId).getUserList().get(sessionId).getBoardHeight();
		Double otherWidth = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getBoardWidth();
		Double otherHeight = roomAddVO.getRoomList().get(roomId).getUserList().get(key).getBoardHeight();
		
		Double width = otherWidth / ownWidth;
		Double height = otherHeight / ownHeight;
		
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = (JSONObject) jsonParser.parse(message);
		jsonObject.put(wProperties.get("websocket.x"), Math.round(Double.parseDouble(jsonObject.get(wProperties.get("websocket.x")).toString()) * width));
		jsonObject.put(wProperties.get("websocket.y"), Math.round(Double.parseDouble(jsonObject.get(wProperties.get("websocket.y")).toString()) * height));
		
		return jsonObject;
	}
}
