package com.daekyo.clab.room.service;

import java.util.HashMap;

import com.daekyo.clab.room.RoomVO;
import com.daekyo.clab.user.UserVO;

public interface RoomService {

	int insertRoom(RoomVO roomVO) throws Exception;

	HashMap<String, Object> selectUserInfo(UserVO userVO) throws Exception;
	
	int getRoomIdCheck(String roomId) throws Exception;
	
	String deleteRoom() throws Exception;
}
