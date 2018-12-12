package com.daekyo.clab.file.service.impl;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.daekyo.clab.file.service.FileService;

@Service("fileService")
public class FileServiceImpl implements FileService{
	
	@Resource(name="fileUploadProperties")
	private Properties fProperties;

	@Override
	public List<HashMap<String, String>> pdfUpload(String roomId, HttpServletRequest request) throws Exception {
		SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String mTime = mSimpleDateFormat.format (currentTime);

		String filePath = fProperties.getProperty("file.upload.path")+roomId+"/"+mTime;
		
		File file = new File(filePath);
		
		if(!file.isDirectory()) {
			file.mkdirs();
		}
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
	    Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
	    MultipartFile multipartFile = null;
	    
	    List<HashMap<String, String>> fileNames = new ArrayList<>();
	    
	    while(iterator.hasNext()){
	        multipartFile = multipartHttpServletRequest.getFile(iterator.next());
	        if(multipartFile.isEmpty() == false){
	        	File pdfFile = new File(filePath+"/"+multipartFile.getOriginalFilename()); 
	        	
	        	if(pdfFile.exists()) {
	        		pdfFile.delete();
	        	}
	        	
	        	multipartFile.transferTo(pdfFile);
	        	
	        	int idx = multipartFile.getOriginalFilename().lastIndexOf(".");
	        	
	        	PDDocument doc = PDDocument.load(pdfFile);		
	        	PDFRenderer renderer = new PDFRenderer(doc);

	        	for(int i = 0 ; i < doc.getNumberOfPages() ; i++){			
	        		BufferedImage image = renderer.renderImageWithDPI(i, 130);  // 해상도 조절
	        		
	        		String fileName = String.format("%s_%d.jpg", pdfFile.getName().substring(0, idx), (i+1));
	        		
	        		ImageIO.write(image, "JPEG", new File(String.format("%s/%s", filePath, fileName)));	
	        		
	        		HashMap<String, String> hashMap = new HashMap<>();
	        		hashMap.put("pdfPath", mTime+"/"+fileName);
	        		fileNames.add(hashMap);
	        	}
	        }
	    }

		return fileNames;
	}

}
