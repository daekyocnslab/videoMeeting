package com.daekyo.clab.room.controller;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.daekyo.clab.room.RoomVO;
import com.daekyo.clab.room.service.RoomService;

@Controller
@RequestMapping(value="room")
public class RoomController {
	
	protected Log log = LogFactory.getLog(RoomController.class);
	
	@Resource(name="roomService")
	private RoomService roomService;
	
	@RequestMapping(value="/insert", method=RequestMethod.GET)
	public String insertView(@ModelAttribute RoomVO roomVO) throws Exception {
		
		return "room/insert";
	}
	
	@ResponseBody
	@RequestMapping(value="/insert", method=RequestMethod.POST)
	public ResponseEntity<String> insert(@ModelAttribute RoomVO roomVO) throws Exception {
		
		String result = roomService.insertRoom(roomVO);
		
		return new ResponseEntity<String>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="/videoMeeting/{roomId}", method=RequestMethod.GET)
	public String videoMeeting(@PathVariable("roomId") String roomId, ModelMap model) throws Exception {
		
		int result = roomService.getRoomIdCheck(roomId);
		
		model.addAttribute("roomId", roomId);
		model.addAttribute("result", result);
		
		if(result == 000) {
			return "video/videoMeeting";
		}else {
			return "video/videoError";
		}
	}
	
	@RequestMapping(value="/error/{code}", method=RequestMethod.GET)
	public String error(@PathVariable("code") String code, ModelMap model) {
		
		model.addAttribute("result", code);
		
		return "video/videoError";
	}
}