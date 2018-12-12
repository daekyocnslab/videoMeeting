package com.daekyo.clab.user;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import org.springframework.web.socket.WebSocketSession;

@XmlRootElement(name="user")
@XmlAccessorType(XmlAccessType.FIELD)
public class UserVO {
	
	@XmlAttribute(name="userId")
	private String userId;
	private String userPw;
	private String authority;
	private String enabled;
	private String email;
	private String userName;
	private String department;
	private String extNum;
	private String company;

	@XmlTransient
	private WebSocketSession session;
	private Double boardWidth;
	private Double boardHeight;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	public String getEnabled() {
		return enabled;
	}
	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getExtNum() {
		return extNum;
	}
	public void setExtNum(String extNum) {
		this.extNum = extNum;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public WebSocketSession getSession() {
		return session;
	}
	public void setSession(WebSocketSession session) {
		this.session = session;
	}
	public Double getBoardWidth() {
		return boardWidth;
	}
	public void setBoardWidth(Double boardWidth) {
		this.boardWidth = boardWidth;
	}
	public Double getBoardHeight() {
		return boardHeight;
	}
	public void setBoardHeight(Double boardHeight) {
		this.boardHeight = boardHeight;
	}
}
