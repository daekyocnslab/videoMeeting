package com.daekyo.clab.common.vo;

import java.util.concurrent.ConcurrentHashMap;

import com.daekyo.clab.room.RoomVO;

public class RoomAddVO {
	private volatile static RoomAddVO instance;
	
	public static RoomAddVO getInstance() {
		if(instance == null) {
			synchronized(RoomAddVO.class) {
				if(instance == null) {
					instance = new RoomAddVO();
				}
			}
		}
		return instance;
	}
	
	private ConcurrentHashMap<String, RoomVO> roomList = new ConcurrentHashMap<>();

	public ConcurrentHashMap<String, RoomVO> getRoomList() {
		return roomList;
	}
	public void setRoomList(ConcurrentHashMap<String, RoomVO> roomList) {
		this.roomList = roomList;
	}
}
