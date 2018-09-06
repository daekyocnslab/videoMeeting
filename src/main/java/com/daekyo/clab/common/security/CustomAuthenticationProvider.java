package com.daekyo.clab.common.security;

import java.util.ArrayList;
import java.util.Collection;

import javax.annotation.Resource;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import com.daekyo.clab.user.UserVO;
import com.daekyo.clab.user.service.UserService;

public class CustomAuthenticationProvider implements AuthenticationProvider {
	
	@Resource(name="userService")
	private UserService userService;
	
	public Authentication authenticate(Authentication auth) throws AuthenticationException {
		String userName = (String) auth.getPrincipal();
		String password = (String) auth.getCredentials();
		
		UserVO vo = new UserVO();
		vo.setUserId(userName);
		vo.setUserPw(password);
		
		try {
			vo = userService.selectLogin(vo);
			
			if (vo.getUserId().equals(userName)) {
				Collection<SimpleGrantedAuthority> authorties = fillUserAuthorities(vo.getAuthority());
				
				return new UsernamePasswordAuthenticationToken(userName, password, authorties);
			}else {
				throw new BadCredentialsException("Invalid credentials");
			}
		} catch (Exception e) {
			return (Authentication) new BadCredentialsException("Invalid credentials");
		}
	}

	public boolean supports(Class<?> arg0) {
		return true;
	}
	
	private Collection<SimpleGrantedAuthority> fillUserAuthorities(String role) {
		Collection<SimpleGrantedAuthority> authorties = new ArrayList<SimpleGrantedAuthority>();
		
		authorties.add(new SimpleGrantedAuthority(role));
		
		return authorties;
	}
}
