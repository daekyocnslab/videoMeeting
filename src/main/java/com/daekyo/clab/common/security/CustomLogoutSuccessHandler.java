package com.daekyo.clab.common.security;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import com.daekyo.clab.common.vo.TokenVO;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler  {
	
	@Resource(name="tokenVO")
	TokenVO tokenVO;

	@Override
	public void onLogoutSuccess(HttpServletRequest request,	HttpServletResponse response, Authentication authentication) throws IOException {
		System.out.println(request.getHeader("Authorization"));
		System.out.println(request.getHeader("Authorization").split(" ")[1]);
		//System.out.println(tokenVO.getTokenstore().readAuthentication(request.getParameter("access_token")).getPrincipal());
		
		tokenVO.getTokenstore().removeAccessToken(request.getHeader("Authorization").split(" ")[1]);
		response.sendError(200);
	}
}
