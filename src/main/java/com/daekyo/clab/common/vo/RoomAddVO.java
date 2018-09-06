package com.daekyo.clab.common.vo;

import java.util.ArrayList;
import java.util.List;

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
	
	private List<RoomVO> list = new ArrayList<>();

	public List<RoomVO> getList() {
		return list;
	}

	public void setList(List<RoomVO> list) {
		this.list = list;
	}

	public static void setInstance(RoomAddVO instance) {
		RoomAddVO.instance = instance;
	}
}
