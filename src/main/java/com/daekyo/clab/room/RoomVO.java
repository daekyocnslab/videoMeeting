package com.daekyo.clab.room;

import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;

import org.json.simple.JSONObject;

import com.daekyo.clab.user.UserVO;

@XmlRootElement(name="room")
@XmlAccessorType(XmlAccessType.FIELD)
public class RoomVO {
	
	@XmlAttribute(name="roomId")
	private String roomId;
	private int maxPersons;
	private String title;
	private String startDate;
	private String endDate;
	private String fromName = "";
	private String fromEmail;
	private String toEmail1;
	private String toEmail2;
	private String toEmail3;
	private JSONObject pdfFiles;
	private String imgPosition = "1";
	private List<String> drawData = Collections.synchronizedList(new ArrayList<>());
	private List<String> sDrawData = Collections.synchronizedList(new ArrayList<>());
	private List<String> pDrawData = Collections.synchronizedList(new ArrayList<>());
    private boolean screenAt = false;
	private ConcurrentHashMap<String, UserVO> userList = new ConcurrentHashMap<>();
	private URL url;
	
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
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
	public String getFromName() {
		return fromName;
	}
	public void setFromName(String fromName) {
		this.fromName = fromName;
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
	public JSONObject getPdfFiles() {
		return pdfFiles;
	}
	public void setPdfFiles(JSONObject pdfFiles) {
		this.pdfFiles = pdfFiles;
	}
	public String getImgPosition() {
		return imgPosition;
	}
	public void setImgPosition(String imgPosition) {
		this.imgPosition = imgPosition;
	}
	public List<String> getDrawData() {
		return drawData;
	}
	public void setDrawData(List<String> drawData) {
		this.drawData = drawData;
	}
	public List<String> getsDrawData() {
		return sDrawData;
	}
	public void setsDrawData(List<String> sDrawData) {
		this.sDrawData = sDrawData;
	}
	public List<String> getpDrawData() {
		return pDrawData;
	}
	public void setpDrawData(List<String> pDrawData) {
		this.pDrawData = pDrawData;
	}
	public boolean isScreenAt() {
		return screenAt;
	}
	public void setScreenAt(boolean screenAt) {
		this.screenAt = screenAt;
	}
	public ConcurrentHashMap<String, UserVO> getUserList() {
		return userList;
	}
	public void setUserList(ConcurrentHashMap<String, UserVO> userList) {
		this.userList = userList;
	}
	public URL getUrl() {
		return url;
	}
	public void setUrl(URL url) {
		this.url = url;
	}
}
