package com.harunichi.admin.controller;


import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.harunichi.chat.service.ChatService;
import com.harunichi.chat.vo.ChatRoomVo;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/admin/chat")
public class AdminChatController {
	
	@Autowired
	ChatService chatService;

	//채팅방 검색
	@RequestMapping(value = {"", "/chatRoomSearch"})
	public String searchChatRoomList(HttpServletRequest request, Model model,
									 @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
									 @RequestParam(value = "searchType", defaultValue = "all") String searchType,
									 @RequestParam(value = "page", defaultValue = "1") int page) {
		
		model.addAttribute("currentUri", request.getRequestURI());
		model.addAttribute("activeTab", "chat");
		
	    Map<String, Object> result = chatService.searchChatRoomList(searchKeyword, searchType, page);
	    model.addAttribute("result", result);
	    model.addAttribute("searchKeyword", searchKeyword);
	    model.addAttribute("searchType", searchType); 
	
		return "/admin/chat";
	}
	
	//관리자 채팅방 수정
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String updateChatRoom(HttpServletRequest request) {
	
		String[] roomIds = request.getParameterValues("roomId");
	    String[] titles = request.getParameterValues("title");
	    String[] imgResets = request.getParameterValues("imgReset");

	    for (int i = 0; i < roomIds.length; i++) {
	        ChatRoomVo vo = new ChatRoomVo();
	        vo.setRoomId(roomIds[i]);
	        vo.setTitle(titles[i]);
	        vo.setProfileImg("".equals(imgResets[i]) ? null : imgResets[i]);

	        chatService.updateChatRoomAdmin(vo);
	    }
	    return "redirect:/admin/chat?result=updateSuccess";
	}
	
	//관리자 채팅방 삭제
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String deleteChatRoom(HttpServletRequest request) {
		
		String[] roomIds = request.getParameterValues("roomId");
		
	    for (String roomId : roomIds) {
	        chatService.deleteChatRoomAdmin(roomId);
	    }		
		return "redirect:/admin/chat?result=deleteSuccess";
	}
	
	
	

	
}
    
	
  
