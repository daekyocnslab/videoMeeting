package com.daekyo.clab.room.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Service;

import com.daekyo.clab.common.dao.MybatisDAO;
import com.daekyo.clab.common.vo.RoomAddVO;
import com.daekyo.clab.room.RoomVO;
import com.daekyo.clab.room.service.RoomService;

@Service("roomService")
public class RoomServiceImpl implements RoomService{
	
	protected Log log = LogFactory.getLog(RoomServiceImpl.class);

	@Autowired
	private JavaMailSenderImpl mailSender;
	
	@Resource(name="mybatisDAO")
	private MybatisDAO mybatisDAO;

	@Override
	public String insertRoom(RoomVO roomVO) throws Exception {
		String result = "000";
		
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
			
			System.out.println(emails.length);
			String roomId = UUID.randomUUID().toString().replace("-", "");
			String url = "http://localhost:8080/room/videoMeeting/" + roomId;
			//String url = "https://itlab1.daekyocns.co.kr:8443/api/room/videoMeeting/" + roomId;
			
			MimeMessagePreparator preparator = new MimeMessagePreparator() {
				@Override
				public void prepare(MimeMessage mimeMessage) throws Exception {
					MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
		            helper.setFrom(roomVO.getFromEmail());
		            helper.setTo(emails);
		            helper.setSubject("화상회의 예약입니다.");
		            helper.setText(roomVO.getContents() + roomVO.getStartDate() + roomVO.getEndDate() + url, true);
				}	
			};
			
			mailSender.send(preparator);
		
			RoomAddVO roomAddVO = RoomAddVO.getInstance();
			roomVO.setRoomId(roomId);
			roomVO.setMaxPersons(4);
			roomAddVO.getList().add(roomVO);
			
			for(int i=0; i<roomAddVO.getList().size(); i++) {
				log.debug(roomAddVO.getList().get(i).getRoomId());
			}
		}catch(Exception e) {
			result = "999";
		}
		
		return result;
	}

	@Override
	public int getRoomIdCheck(String roomId) throws Exception {
		int result = 999;
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmmss");
		Date date = new Date();
		
		RoomAddVO roomAddVO = RoomAddVO.getInstance();
		
		for(int i=0; i<roomAddVO.getList().size(); i++) {
			if(roomAddVO.getList().get(i).getRoomId().equals(roomId)) {
				if(roomAddVO.getList().get(i).getList().size() < roomAddVO.getList().get(i).getMaxPersons()) {
					int startDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getList().get(i).getStartDate())); 
					int endDate = date.compareTo(simpleDateFormat.parse(roomAddVO.getList().get(i).getEndDate()));
					
					if(startDate >= 0 && 0 >= endDate) {
						result = 000;
					}
				}else {
					result = 998;
				}
			}
		}
		
		return result;
	}
}
