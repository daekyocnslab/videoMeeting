package com.daekyo.clab.room;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;

import com.daekyo.clab.user.UserVO;

@XmlRootElement(name="room")
@XmlAccessorType(XmlAccessType.FIELD)
public class RoomVO {
	
	@XmlAttribute(name="roomId")
	private String roomId;
	private int maxPersons;
	private String contents;
	private String startDate;
	private String endDate;
	private String fromEmail;
	private String toEmail1;
	private String toEmail2;
	private String toEmail3;
	private List<UserVO> list = new ArrayList<>();
	
	public String getRoomId() {
		return roomId;
	}
	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}
	public int getMaxPersons() {
		return maxPersons;
	}
	public void setMaxPersons(int maxPersons) {
		this.maxPersons = maxPersons;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getFromEmail() {
		return fromEmail;
	}
	public void setFromEmail(String fromEmail) {
		this.fromEmail = fromEmail;
	}
	public String getToEmail1() {
		return toEmail1;
	}
	public void setToEmail1(String toEmail1) {
		this.toEmail1 = toEmail1;
	}
	public String getToEmail2() {
		return toEmail2;
	}
	public void setToEmail2(String toEmail2) {
		this.toEmail2 = toEmail2;
	}
	public String getToEmail3() {
		return toEmail3;
	}
	public void setToEmail3(String toEmail3) {
		this.toEmail3 = toEmail3;
	}
	public List<UserVO> getList() {
		return list;
	}
	public void setList(List<UserVO> list) {
		this.list = list;
	}
	
	
}
