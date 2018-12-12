package com.daekyo.clab.room;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="response")
@XmlAccessorType(XmlAccessType.FIELD)
public class RoomListVO {

	@XmlElementWrapper(name="list")
	@XmlElement(name="room")
	private List<RoomVO> roomList;
	private int count;
	
	public List<RoomVO> getRoomList() {
		return roomList;
	}
	public void setRoomList(List<RoomVO> roomList) {
		this.roomList = roomList;
		this.count = roomList.size();
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
}
