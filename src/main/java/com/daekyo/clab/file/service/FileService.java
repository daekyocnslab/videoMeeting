package com.daekyo.clab.file.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

public interface FileService {
	List<HashMap<String, String>> pdfUpload(String roomId, HttpServletRequest request) throws Exception; 
}
