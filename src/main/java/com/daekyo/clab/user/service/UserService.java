package com.daekyo.clab.user.service;

import com.daekyo.clab.user.UserVO;

public interface UserService {

	UserVO selectLogin(UserVO vo) throws Exception;

	UserVO selectUser(String id) throws Exception;
}
