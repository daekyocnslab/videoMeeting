package com.daekyo.clab.common.vo;

import org.springframework.security.oauth2.provider.token.store.InMemoryTokenStore;

public class TokenVO {
	private InMemoryTokenStore tokenstore;

	public InMemoryTokenStore getTokenstore() {
		return tokenstore;
	}

	public void setTokenstore(InMemoryTokenStore tokenstore) {
		this.tokenstore = tokenstore;
	}
}
