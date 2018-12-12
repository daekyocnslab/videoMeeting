package com.daekyo.clab.room.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URL;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.daekyo.clab.file.service.FileService;
import com.daekyo.clab.room.RoomVO;
import com.daekyo.clab.room.service.RoomService;
import com.daekyo.clab.user.UserVO;

@Controller
@RequestMapping(value="room")
public class RoomController {
	
	protected Log log = LogFactory.getLog(RoomController.class);
	
	@Resource(name="roomService")
	private RoomService roomService;
	
	@Resource(name="fileService")
	private FileService fileService;
	
	@RequestMapping(value="/insert", method=RequestMethod.GET)
	public String insertView(@ModelAttribute RoomVO roomVO) throws Exception {
		
		return "room/insert";
	}
	
	@ResponseBody
	@RequestMapping(value="/insert", method=RequestMethod.POST)
	public ResponseEntity<Integer> insert(HttpServletRequest request, @ModelAttribute RoomVO roomVO) throws Exception {
		roomVO.setUrl(new URL(request.getRequestURL().toString()));

		int result = roomService.insertRoom(roomVO);
		
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping(value="/user/info", method=RequestMethod.POST)
	public ResponseEntity<HashMap<String, Object>> selectUserInfo(@ModelAttribute UserVO userVO) throws Exception{
		HashMap<String, Object> hashMap = roomService.selectUserInfo(userVO);
		
		return new ResponseEntity<HashMap<String, Object>>(hashMap, HttpStatus.OK);
	}
	
	@RequestMapping(value="/videoMeeting/{roomId}", method=RequestMethod.GET)
	public String videoMeeting(@PathVariable("roomId") String roomId, ModelMap model) throws Exception {
		
		int result = roomService.getRoomIdCheck(roomId);
		
		model.addAttribute("roomId", roomId);
		model.addAttribute("result", result);
		
		if(result == 000) {
			return "video/videoMeeting";
		}else {
			return "video/videoError";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/videoMeeting/upload/{roomId}", method=RequestMethod.POST)
	public ResponseEntity<HashMap<String, Object>> pdfUpload(HttpServletRequest request, @PathVariable("roomId") String roomId) throws Exception {
		HashMap<String, Object> hashMap = new HashMap<>();
		String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();

		List<HashMap<String, String>> filePaths = fileService.pdfUpload(roomId, request);
		
		hashMap.put("url", url);
		hashMap.put("list", filePaths);
		
		return new ResponseEntity<HashMap<String, Object>>(hashMap, HttpStatus.OK);
	}
	
	@RequestMapping(value="/videoMobileIntro/{roomId}", method=RequestMethod.GET)
	public String mobileIntro(@PathVariable("roomId") String roomId, ModelMap model) throws Exception{
		
		int result = roomService.getRoomIdCheck(roomId);
		
		model.addAttribute("roomId", roomId);
		
		if(result == 000) {
			return "video/videoMobileIntro";
		}else {
			return "video/videoError";
		}
	}
	
	@RequestMapping(value="/error/{code}", method=RequestMethod.GET)
	public String error(@PathVariable("code") String code, ModelMap model) {
		
		model.addAttribute("result", code);
		
		return "video/videoError";
	}
	
	@RequestMapping(value="/pdf", method=RequestMethod.GET)
	public String pdfTest(ModelMap model) throws Exception{

		String pdfFilePath = "/Users/woobinlee/Documents/pdfTest/pdf.pdf";

		String savePath = "/Users/woobinlee/Documents/pdfTest/";
		
		String imgName = "";

		File file = new File(pdfFilePath);

		PDDocument doc = PDDocument.load(file);		

		PDFRenderer renderer = new PDFRenderer(doc);

		for(int i = 0 ; i < doc.getNumberOfPages() ; i++){			
			BufferedImage image = renderer.renderImageWithDPI(i, 130);  // 해상도 조절
			
			ImageIO.write(image, "JPEG", new File(String.format("%s/pdf%d.jpg", savePath , (i+1))));
			imgName = String.format("pdf%d.jpg", (i+1));
		}

		doc.close();

		model.addAttribute("imgName", imgName);
		
		return "pdf";
	}
	
	
}