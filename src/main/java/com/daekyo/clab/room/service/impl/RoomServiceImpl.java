package com.daekyo.clab.room.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Service;

import com.daekyo.clab.common.dao.MybatisDAO;
import com.daekyo.clab.common.vo.RoomAddVO;
import com.daekyo.clab.room.RoomVO;
import com.daekyo.clab.room.service.RoomService;
import com.daekyo.clab.user.UserVO;

@Service("roomService")
public class RoomServiceImpl implements RoomService{
	
	protected Log log = LogFactory.getLog(RoomServiceImpl.class);

	@Autowired
	private JavaMailSenderImpl mailSender;
	
	@Resource(name="emailProperties")
	private Properties eProperties;
	
	@Resource(name="mybatisDAO")
	private MybatisDAO mybatisDAO;

	@Override
	public int insertRoom(RoomVO roomVO) throws Exception {
		int result = 000;
		
		try {
			List<String> list = new ArrayList<>();
			list.add(roomVO.getFromEmail());
			
			if(!roomVO.getToEmail1().equals("")) {
				list.add(roomVO.getToEmail1());
			}
			
			if(!roomVO.getToEmail2().equals("")) {
				list.add(roomVO.getToEmail2());
			}
			
			if(!roomVO.getToEmail3().equals("")) {
				list.add(roomVO.getToEmail3());
			}
			
			String[] emails = new String[list.size()];
			
			for(int i=0; i<list.size(); i++) {
				emails[i] = list.get(i);
			}

			String roomId = UUID.randomUUID().toString().replace("-", "");
			String url = String.format(new String(eProperties.getProperty("email.url").getBytes("ISO-8859-1"), "UTF-8") + roomId, roomVO.getUrl().getProtocol(), roomVO.getUrl().getAuthority());

			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			
			Date startDate = simpleDateFormat.parse(roomVO.getStartDate());
			Date endDate = simpleDateFormat.parse(roomVO.getEndDate());
			
			SimpleDateFormat startDateFormat = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");
			SimpleDateFormat endDateFormat = new SimpleDateFormat("HH:mm");
			
			String date = startDateFormat.format(startDate) + "~" + endDateFormat.format(endDate);
			
			String subject = String.format(new String(eProperties.getProperty("email.subject").getBytes("ISO-8859-1"), "UTF-8"), roomVO.getTitle());
			String text = String.format(new String(eProperties.getProperty("email.text").getBytes("ISO-8859-1"), "UTF-8"), roomVO.getFromName(), roomVO.getFromEmail(), roomVO.getTitle(), date, url, url);
			
			MimeMessagePreparator preparator = new MimeMessagePreparator() {
				@Override
				public void prepare(MimeMessage mimeMessage) throws Exception {
					MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
		            helper.setFrom(roomVO.getFromEmail());
		            helper.setTo(emails);
		            helper.setSubject(subject);
		            helper.setText(text, true);
				}	
			};
			
			mailSender.send(preparator);
		
			RoomAddVO roomAddVO = RoomAddVO.getInstance();
			roomVO.setRoomId(roomId);
			roomVO.setMaxPersons(list.size());
			roomAddVO.getRoomList().put(roomId, roomVO);
		}catch(Exception e) {
			result = 999;
		}
		
		return result;
	}
	
	@Override
	public HashMap<String, Object> selectUserInfo(UserVO userVO) throws Exception{
		int result = 000;
		HashMap<String, Object> hashMap = new HashMap<>();
		
		try {
			List<UserVO> list = mybatisDAO.selectList("user.info", userVO);
			hashMap.put("list", list);
		}catch (Exception e) {
			result = 999;
		}
		
		hashMap.put("result", result);
		
		return hashMap;
	}

	@Override
	public int getRoomIdCheck(String roomId) throws Exception {
		int result = 999;
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmmss");
		Date date = new Date();
		
		RoomAddVO roomAddVO = RoomAddVO.getInstance();
		
		if(roomAddVO.getRoomList().get(roomId) != null) {
			//if(roomAddVO.getRoomList().get(roomId).getUserList().size() < roomAddVO.getRoomList().get(roomId).getMaxPersons()) {
				int startDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getRoomList().get(roomId).getStartDate())); 
				int endDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getRoomList().get(roomId).getEndDate()));
				
				if(startDate >= 0 && 0 >= endDate) {
					result = 000;
				}
			/*}else {
				result = 998;
			}*/
		}
		
		return result;
	}

	@Override
	public String deleteRoom() throws Exception {
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();

		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmmss");
		Date date = new Date();
		
		RoomAddVO roomAddVO = RoomAddVO.getInstance();
		
		Iterator<String> keys = roomAddVO.getRoomList().keySet().iterator();

		while(keys.hasNext()) {
			String key = keys.next();
			JSONObject object = new JSONObject();
			object.put("roomId", key);
			
			if(roomAddVO.getRoomList().get(key).getUserList().size() == 0) {
				int endDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getRoomList().get(key).getEndDate()));
				
				if(0 <= endDate) {
					object.put("result", "000");
					
					roomAddVO.getRoomList().remove(key);
				}else {
					object.put("result", "999");
				}
			}else {
				object.put("result", "998");
			}
			jsonArray.add(object);
		}
		
		jsonObject.put("result", jsonArray);
		
		return jsonObject.toJSONString();
	}
}
