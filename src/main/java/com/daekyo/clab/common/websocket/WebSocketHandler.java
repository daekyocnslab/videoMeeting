package com.daekyo.clab.common.websocket;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.daekyo.clab.common.vo.DataVO;
import com.daekyo.clab.common.vo.RoomAddVO;
import com.daekyo.clab.user.UserVO;
import com.fasterxml.jackson.databind.ObjectMapper;

public class WebSocketHandler extends TextWebSocketHandler{
	
	protected Log log = LogFactory.getLog(WebSocketHandler.class);

    private ObjectMapper objectMapper = new ObjectMapper();
    private RoomAddVO roomAddVO = RoomAddVO.getInstance();
	
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
		try{
			Map<String, Object> map = session.getAttributes();
			String roomId = map.get("roomId").toString();
			
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmmss");
			Date date = new Date();
			
			for(int i=0; i<roomAddVO.getList().size(); i++) {
				if(roomAddVO.getList().get(i).getRoomId().equals(roomId)) {
					if(roomAddVO.getList().get(i).getList().size() < roomAddVO.getList().get(i).getMaxPersons()) {
						int startDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getList().get(i).getStartDate())); 
						int endDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getList().get(i).getEndDate()));
						
						if(startDate >= 0 && 0 >= endDate) {
							UserVO userVO = new UserVO();
							userVO.setSession(session);
							
							roomAddVO.getList().get(i).getList().add(userVO);
							
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("type", "login");
							jsonObject.put("user", session.getId());
							
							JSONArray array = new JSONArray();
							JSONObject object = null;
							
							for(int j=0; j<roomAddVO.getList().get(i).getList().size(); j++) {
								if(!roomAddVO.getList().get(i).getList().get(j).getSession().getId().equals(session.getId())) {
									object = new JSONObject();
									object.put("dest", roomAddVO.getList().get(i).getList().get(j).getSession().getId());
									array.add(object);
								}
							}
							
							jsonObject.put("dests", array);
							
							synchronized (session) {
								session.sendMessage(new TextMessage(jsonObject.toJSONString()));											
							}
						}else {
							JSONObject jsonObject = new JSONObject();
							jsonObject.put("type", "error");
							jsonObject.put("code", "999");
							
							synchronized (session) {
								session.sendMessage(new TextMessage(jsonObject.toJSONString()));											
							}
						}
					}else {
						JSONObject jsonObject = new JSONObject();
						jsonObject.put("type", "error");
						jsonObject.put("code", "998");
						
						synchronized (session) {
							session.sendMessage(new TextMessage(jsonObject.toJSONString()));											
						}
					}
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		super.handleTextMessage(session, message);
		try {
			Map<String, Object> map = session.getAttributes();
			String roomId = map.get("roomId").toString();
			
			System.out.println(message.getPayload());
			
			DataVO dataVO = objectMapper.readValue(message.getPayload(), DataVO.class);
			
			switch (dataVO.getType()) {
			case "rtc":
				for(int i=0; i<roomAddVO.getList().size(); i++) {
					if(roomAddVO.getList().get(i).getRoomId().equals(roomId)) {
						for(int j=0; j<roomAddVO.getList().get(i).getList().size(); j++) {
							if(roomAddVO.getList().get(i).getList().get(j).getSession().getId().equals(dataVO.getDest())) {
								WebSocketSession webSocketSession = roomAddVO.getList().get(i).getList().get(j).getSession();
								System.out.println(webSocketSession.getId());
								DataVO vo = new DataVO();
								vo.setType("rtc");
								vo.setDest(session.getId());
								vo.setUser(webSocketSession.getId());
								vo.setData(dataVO.getData());
								
								String jsonString = objectMapper.writeValueAsString(vo);
								
								synchronized (webSocketSession) {
									webSocketSession.sendMessage(new TextMessage(jsonString));
								}
							}
						}
					}
				}
				break;
			case "draw_down":
			case "draw_move":
				for(int i=0; i<roomAddVO.getList().size(); i++) {
					if(roomAddVO.getList().get(i).getRoomId().equals(roomId)) {
						for(int j=0; j<roomAddVO.getList().get(i).getList().size(); j++) {
							if(!roomAddVO.getList().get(i).getList().get(j).getSession().getId().equals(session.getId())) {
								WebSocketSession webSocketSession = roomAddVO.getList().get(i).getList().get(j).getSession();
								
								synchronized (webSocketSession) {
									webSocketSession.sendMessage(new TextMessage(message.getPayload()));
								}
							}
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
		String roomId = map.get("roomId").toString();
		
		removeSession(session, roomId);
		log.info("remove session!");
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		Map<String, Object> map = session.getAttributes();
		String roomId = map.get("roomId").toString();
		
		removeSession(session, roomId);
		log.error("web socket error!", exception);
	}
	
	private void removeSession(WebSocketSession session, String roomId) throws Exception {
		for(int i=0; i<roomAddVO.getList().size(); i++) {
			if(roomAddVO.getList().get(i).getRoomId().equals(roomId)) {
				int userTrun = 0;
				
				for(int j=0; j<roomAddVO.getList().get(i).getList().size(); j++) {
					if(!roomAddVO.getList().get(i).getList().get(j).getSession().getId().equals(session.getId())){
						WebSocketSession webSocketSession = roomAddVO.getList().get(i).getList().get(j).getSession();
						
						DataVO vo = new DataVO();
						vo.setType("logout");
						vo.setDest(session.getId());
						vo.setUser(webSocketSession.getId());
						
						String jsonString = objectMapper.writeValueAsString(vo);
						
						synchronized (webSocketSession) {
							webSocketSession.sendMessage(new TextMessage(jsonString));
						}
					}else {
						userTrun = j;
					}
				}
				
				roomAddVO.getList().get(i).getList().remove(userTrun);
			}
		}
	}
}
