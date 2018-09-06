package com.daekyo.clab.room.service;

import com.daekyo.clab.room.RoomVO;

public interface RoomService {

	String insertRoom(RoomVO roomVO) throws Exception;

	int getRoomIdCheck(String roomId) throws Exception;

}
