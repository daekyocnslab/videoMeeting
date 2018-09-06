package com.daekyo.clab.user.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.daekyo.clab.common.dao.MybatisDAO;
import com.daekyo.clab.user.UserVO;
import com.daekyo.clab.user.service.UserService;

@Service("userService")
public class UserServiceImpl implements UserService{

	@Resource(name="mybatisDAO")
	private MybatisDAO mybatisDAO;

	@Override
	public UserVO selectLogin(UserVO vo) throws Exception {
		return (UserVO) mybatisDAO.selectOne("user.selectLogin", vo);
	}

	@Override
	public UserVO selectUser(String id) throws Exception {
		return (UserVO) mybatisDAO.selectOne("user.selectUser", id);
	}
}
