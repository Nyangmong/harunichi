package com.harunichi.chat.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.harunichi.chat.service.ChatService;
import com.harunichi.chat.vo.ChatRoomVo;
import com.harunichi.chat.vo.ChatVo;
import com.harunichi.common.util.LoginCheck;
import com.harunichi.member.service.MemberService;
import com.harunichi.member.vo.MemberVo;
import com.harunichi.product.service.ProductService;
import com.harunichi.product.vo.ProductVo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/chat")
public class ChatControllerImpl implements ChatController {
	
	@Autowired private ChatService chatService;
	@Autowired private ProductService productService;
	@Autowired private MemberService memberService;
	
	
	//채팅 메인 페이지 불러올 때 호출되는 함수
	@Override
	@RequestMapping("/main")
	public String chatMain(HttpServletRequest request, 
						   HttpServletResponse response, HttpSession session, Model model) throws Exception{		
		log.info("chatController의 chatMain 메소드 실행 -------------");
		
		MemberVo member = (MemberVo) session.getAttribute("member");
		
		String id = null;
		String nick = null;
				
		//로그인 했다면?
		if(member != null && member.getId() != null && !member.getId().isEmpty()) {
			log.info("나의 채팅방 정보 조회중....");	
			id = member.getId();
			nick = member.getNick();	
			String profileImg = null;
			try {							
				//참여중인 채팅방 정보 조회
				List<ChatRoomVo> myChatList = chatService.selectMyChatList(id);
				model.addAttribute("myChatList", myChatList);
									
				//상대방 프로필 담을 변수
				List<MemberVo> profileList = new ArrayList<MemberVo>();	
				MemberVo memberProfile = new MemberVo();
								
				//참여중인 채팅방 프로필 사진 조회
				for(ChatRoomVo vo : myChatList) {
					
					//개인채팅방은 상대방 프로필 사진이 보이도록 설정
					if(vo.getChatType().equals("personal")) {			
						//개인 채팅 상대방 ID 조회
						String chatMemberId = chatService.selectChatMemberId(id, vo.getRoomId());					
						//상대방 프로필 조회
						memberProfile = chatService.selectProfile(chatMemberId);					

						profileImg = memberProfile.getProfileImg();				
							
						//상대방 프로필 없을 경우 기본 이미지 보여주기
						if(profileImg == null || profileImg == "") {										
							memberProfile.setProfileImg(null);				
						}
											
					//오픈채팅방은 방장이 설정한 프로필 사진으로 설정		
					}else {
						memberProfile = null;
					}					
					profileList.add(memberProfile);	
				}
				
				model.addAttribute("profileList", profileList);	
				
				//참여중인 채팅의 메세지 정보 조회
				List<ChatVo> myChatMessage = new ArrayList<ChatVo>();
				for(ChatRoomVo chatRoomVo : myChatList) {
					String roomId = chatRoomVo.getRoomId();										
					myChatMessage.add(chatService.selectMyChatMessage(roomId));							
				}
				model.addAttribute("myChatMessage", myChatMessage);								
			} catch (Exception e) {
				e.printStackTrace();
				log.error("⚠" + id + "의 채팅 목록을 조회할 수 없습니다.");
			}	
		}
		//DB에서 채팅친구추천 리스트 조회
		List<MemberVo> memberList = chatService.selectMembers(id);		
		model.addAttribute("memberList", memberList);
		
		//오픈채팅방 최신 메세지 담을 변수
		String message = "";
		List<ChatVo> messageList = new ArrayList<ChatVo>();
				
		try {		
			//오픈 채팅방 리스트 조회
			List<ChatRoomVo> openChatList = chatService.selectOpenChat();
			
			//최신 채팅 메세지 정보 조회
			for(ChatRoomVo vo : openChatList) {				
				String roomId = vo.getRoomId();				
				ChatVo myChatMessage = chatService.selectMyChatMessage(roomId);
				messageList.add(myChatMessage);
			}
			model.addAttribute("messageList", messageList);
			model.addAttribute("openChatList", openChatList);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("⚠오픈 채팅 목록을 조회할 수 없습니다.");
		}
		return "/chatMain";
	}

	
	//오픈 채팅방 만들기 버튼 클릭시 로그인 유무 확인하는 메소드
	@Override
	@RequestMapping(value = "/loginChek")
	public String loginChek (HttpServletRequest request, 
			   HttpServletResponse response, Model model, HttpSession session) throws Exception{		
		log.info("GET chatController의 loginChek 메소드 실행 -------------");
		
		if (!LoginCheck.loginCheck(session, request, response)) {
		    return null; 
		}		
		String roomId = request.getParameter("roomId");		
		return "/chatWindow";
	}

	
	//오픈 채팅방 생성
	@Override
	@RequestMapping(value = "createOpenChat", method = RequestMethod.POST)
	public String createOpenChat(HttpServletRequest request, HttpServletResponse response, 
			   				   Model model, HttpSession session,
			   				   @RequestParam("imgUpload") MultipartFile file) throws Exception{	
		log.info("chatController의 createOpenChat 메소드 실행 -------------");
			
		//로그인 유무 확인
		if (!LoginCheck.loginCheck(session, request, response)) { return null; }
		
		String fileName = "";
		
		//이미지 파일이 있다면?
		if(file != null && !file.isEmpty()) {
			//이미지 파일을 C드라이브에 저장
			fileName = chatService.chatProfileImgUpload(file);
		}
		
		MemberVo member = (MemberVo) session.getAttribute("member");
		String senderId = member.getId();
		String nickname = member.getNick();
		model.addAttribute("nickname", nickname);
		
		int	persons = Integer.parseInt(request.getParameter("persons"));
		
		ChatRoomVo vo = new ChatRoomVo();
		vo.setUserId(senderId);
		vo.setPersons(persons);
		vo.setProfileImg(fileName);
		vo.setTitle(request.getParameter("title"));
		vo.setChatType(request.getParameter("chatType"));
		
		//채팅방 ID 생성 후 DB에 채팅방 정보 저장
		String roomId = chatService.insertRoomId(vo);
		model.addAttribute("roomId", roomId);
		model.addAttribute("profileImg", vo.getProfileImg());

		//채팅방 참여 인원수 조회
		int count = chatService.selectUserCount(roomId);		
		model.addAttribute("count", count);
		model.addAttribute("title", vo.getTitle());
		
		//채팅방에 참여하고 있는 유저 ID 조회
		List<String> userIdList = chatService.selectUserByRoomId(roomId);
		List<MemberVo> userList = new ArrayList<MemberVo>();
		
		for(String user : userIdList) {
			//유저 ID로 프로필 정보 조회
			MemberVo memberVo = memberService.selectMemberById(user);
			userList.add(memberVo);
		}
		model.addAttribute("userList", userList);
						
		return "/chatWindow";		
	}
	
	
	//개인 채팅방 생성
	@Override
	@RequestMapping(value = "/createChat", method = RequestMethod.POST)
	public String createChat (HttpServletRequest request, 
							  HttpServletResponse response, Model model, HttpSession session) throws Exception{			
		log.info("hatController의 createChat 메소드 실행 -------------");
		
		//로그인 유무 확인
		if (!LoginCheck.loginCheck(session, request, response)) { return null; }
		
		MemberVo member = (MemberVo) session.getAttribute("member");
		
		//채팅방 고유 ID 확인 후 신규채팅일 경우 DB에 저장
		String senderId = member.getId();
		String chatType = request.getParameter("chatType");
		model.addAttribute("chatType", chatType);
		String receiverId = request.getParameter("receiverId");
	
		String roomId = chatService.selectRoomId(senderId, receiverId, chatType);

		model.addAttribute("roomId", roomId);

		//채팅방 참여 인원 수 조회
		int count = chatService.selectUserCount(roomId);		
		model.addAttribute("count", count);
		model.addAttribute("persons", "2");	
		
		//채팅방 타이틀이 없을 경우 상대방 유저 닉네임 사용(개인채팅)
		MemberVo vo = chatService.selectProfile(receiverId);
		model.addAttribute("title", vo.getNick());	
		model.addAttribute("profileImg", vo.getProfileImg());	
		
		//채팅방에 참여하고 있는 유저 ID 조회
		List<String> userIdList = chatService.selectUserByRoomId(roomId);
		List<MemberVo> userList = new ArrayList<MemberVo>();
		
		for(String user : userIdList) {
			//유저 ID로 프로필 정보 조회
			MemberVo memberVo = memberService.selectMemberById(user);
			userList.add(memberVo);
		}
		model.addAttribute("userList", userList);

		return "/chatWindow";	
	}
	
	
	//채팅 목록에서 채팅방을 눌렀을 경우 실행
	@Override
	@RequestMapping(value = "/doChat")
	public String doChat(@RequestParam("roomId") String roomId,
			HttpServletRequest request, HttpServletResponse response, 
						 Model model, HttpSession session) throws Exception{
		log.info("ChatController의 doChat 메소드 실행 -------------");
		
		//로그인 유무 확인
		if (!LoginCheck.loginCheck(session, request, response)) { return null; }
		
		MemberVo member = (MemberVo) session.getAttribute("member");
		String userId = member.getId();
		
		String chatType = request.getParameter("chatType");
		model.addAttribute("chatType", chatType);
		
		//채팅방에 참여하고 있는 유저 ID 조회
		List<String> userIdList = chatService.selectUserByRoomId(roomId);
		List<MemberVo> userList = new ArrayList<MemberVo>();
		
		for(String user : userIdList) {
			//유저 ID로 프로필 정보 조회
			MemberVo memberVo = memberService.selectMemberById(user);
			userList.add(memberVo);
		}
		model.addAttribute("userList", userList);
		
		//상품ID가 있을 경우
		String param = request.getParameter("productId");	
		int productId = 0;		
		if(param != null) {
			productId = Integer.parseInt(param);
			//상품 정보 조회
			ProductVo productVo = productService.findById(productId);
			model.addAttribute("productVo", productVo);		
		}

		//채팅방 참여 인원 조회
		int count = chatService.selectUserCount(roomId);		
		model.addAttribute("count", count);
		model.addAttribute("persons", "2");	
				
		//채팅 상대 프로필 정보 조회
		if(chatType.equals("personal")) { //개인채팅
		
			//채팅 상대 ID 조회
			String memberId = chatService.selectChatMemberId(userId, roomId);
			
			MemberVo memberVo = chatService.selectProfile(memberId);
			model.addAttribute("title", memberVo.getNick());	
			model.addAttribute("profileImg", memberVo.getProfileImg());				
			model.addAttribute("receiverId", memberId);	
		
		}else {	//오픈채팅	

			//채팅방 ID로 채팅방 정보 조회
			ChatRoomVo chatRoomVo = chatService.selectOpenChatById(roomId);

			model.addAttribute("title", chatRoomVo.getTitle());	
			model.addAttribute("profileImg", chatRoomVo.getProfileImg());	
			model.addAttribute("leader", chatService.selectLeaderId(roomId));	
			model.addAttribute("nickname", member.getNick());
			model.addAttribute("persons", chatRoomVo.getPersons());					
		}		
		model.addAttribute("roomId", roomId);

		return "/chatWindow";		
	}
	
	
	//오픈 채팅 참여
	@Override
	@RequestMapping(value = "/doOpenChat")
	public String doOpenChat (@RequestParam("roomId") String roomId,
							HttpServletRequest request, HttpServletResponse response, 
							Model model, HttpSession session) throws Exception{	
		log.info("ChatController의 doOpenChat 메소드 실행 -------------");
		
		//로그인 유무 확인
		if (!LoginCheck.loginCheck(session, request, response)) { return null; }
		
		MemberVo member = (MemberVo) session.getAttribute("member");
		String userId = member.getId();
		model.addAttribute("nickname", member.getNick());
			
		//로그인 사용자가 참여하려는 채팅방에 이미 참여하고 있는지 확인	
		boolean isUserInRoom = chatService.isUserInRoom(roomId, userId);
	
		if(isUserInRoom) {
			if(chatService.isKicked(roomId, userId)) { return "/chat/kicked"; }
		}
			
		//채팅방에서 나갔다가 다시 참여할 경우
		chatService.changeIsDeleted(userId, roomId);
		
		//오픈 채팅방 정보 조회
		ChatRoomVo chatRoomVo = chatService.selectOpenChatById(roomId);
		chatRoomVo.setUserId(userId);
		
		//채팅방에 참여하고 있다면 doChat으로 리다이렉트
		if(isUserInRoom) { return "redirect:/chat/doChat?roomId=" + roomId + "&chatType=" + chatRoomVo.getChatType(); }	
		
		//해당 채팅방에 로그인한 사용자 ID 추가
		chatService.doOpenChat(chatRoomVo);
		
		int count = chatService.selectUserCount(roomId);
		model.addAttribute("count", count);
		model.addAttribute("persons", chatRoomVo.getPersons());		
		model.addAttribute("roomId", roomId);	
		model.addAttribute("title", chatRoomVo.getTitle());	
		model.addAttribute("profileImg", chatRoomVo.getProfileImg());		
		model.addAttribute("chatType", chatRoomVo.getChatType());		
		model.addAttribute("leader", chatService.selectLeaderId(roomId));	
		
		//채팅방에 참여하고 있는 유저 ID 조회
		List<String> userIdList = chatService.selectUserByRoomId(roomId);
		List<MemberVo> userList = new ArrayList<MemberVo>();
		
		for(String user : userIdList) {
			//유저 ID로 프로필 정보 조회
			MemberVo memberVo = memberService.selectMemberById(user);
			userList.add(memberVo);
		}
		model.addAttribute("userList", userList);
		
		return "/chatWindow";	
	}
		
			
	//중고거래에서 요청받은 채팅
	@RequestMapping(value = "/productChat")
	public String productChat(@RequestParam("productId") int productId,
							  HttpServletRequest request, HttpServletResponse response, 
							  Model model, HttpSession session) throws Exception{		
		log.info("chatController의 productChat 메소드 실행 -------------");
		
		if (!LoginCheck.loginCheck(session, request, response)) { return null; }
		
		MemberVo member = (MemberVo) session.getAttribute("member");				
		String senderId = member.getId();
		String chatType = "personal";
		model.addAttribute("chatType", chatType);		
		
		//판매글 ID로 판매글 정보 조회
		ProductVo productVo = productService.findById(productId);
		model.addAttribute("productVo", productVo);
		
		//판매자 ID
		String receiverId = productVo.getProductWriterId();
		
		//판매자 정보 조회
		MemberVo memberVo = memberService.selectMemberById(receiverId);
		model.addAttribute("receiverId", receiverId);	
		model.addAttribute("title", memberVo.getNick());	
		model.addAttribute("profileImg", memberVo.getProfileImg());	
		
		//채팅방 ID 조회
		String roomId = chatService.selectRoomId(senderId, receiverId, chatType);
		model.addAttribute("roomId", roomId);
		
		//채팅방 정보에 상품ID 업데이트
		chatService.updateChatProduct(roomId, productId);
		
		//채팅방 참여 인원수 조회
		int count = chatService.selectUserCount(roomId);		
		model.addAttribute("count", count);
		
		//채팅방에 참여하고 있는 유저 ID 조회
		List<String> userIdList = chatService.selectUserByRoomId(roomId);
		List<MemberVo> userList = new ArrayList<MemberVo>();
		
		for(String user : userIdList) {
			//유저 ID로 프로필 정보 조회
			MemberVo userVo = memberService.selectMemberById(user);
			userList.add(userVo);
		}
		model.addAttribute("userList", userList);

		return "/chatWindow";	
	}
	
	//채팅방 정보에 상품ID 제거
	@RequestMapping(value = "/deleteProductId")
	public String deleteProductId(@RequestParam("productId") int productId,
							  HttpServletRequest request, HttpServletResponse response, 
							  Model model, HttpSession session) throws Exception{				
		log.info("chatController의 deleteProductId 메소드 실행 -------------");
		
		String roomId = request.getParameter("roomId");	
		chatService.deleteProductId(roomId, productId);
		
		return "redirect:/chat/doChat?roomId=" + roomId + "&chatType=personal";
	}
	
	//과거 채팅 내역 불러오기
	@Override
	@RequestMapping("/history")
	@ResponseBody
	public List<ChatVo> selectChatHistory(@RequestParam String roomId, HttpSession session){
		log.info("chatController의 selectChatHistory 메소드 실행 -------------");
		
		MemberVo member = (MemberVo) session.getAttribute("member");
		String userId = member.getId();
		
		return chatService.selectChatHistory(roomId, userId);
	}
	
	//채팅방 나가기
	@RequestMapping("/leaveChatRoom")
	public String leaveChatRoom(@RequestParam String roomId, HttpSession session){
		log.info("chatController의 leaveChatRoom 메소드 실행 -------------");
		
		MemberVo member = (MemberVo) session.getAttribute("member");				
		String userId = member.getId();
		
		chatService.leaveChatRoom(userId, roomId);
		
		int count = chatService.selectUserCount(roomId);
	
		//채팅방에 참여 인원이 없다면 채팅방 정보와 채팅 내역 삭제
		if(count == 0) {
			chatService.deleteChat(roomId);
		}
		return "redirect:/chat/main";
	}
	
	//오픈 채팅방 정보 수정
	@Override
	@RequestMapping(value = "updateOpenChat", method = RequestMethod.POST)
	public String updateOpenChat(HttpServletRequest request, HttpServletResponse response, 
			 					 Model model, HttpSession session,
			   				   	 @RequestParam("imgUpload") MultipartFile file) throws Exception{	
		log.info("chatController의 updateOpenChat 메소드 실행 -------------");
			
		//로그인 유무 확인
		if (!LoginCheck.loginCheck(session, request, response)) { return null; }
		
		String fileName = "";
		ChatRoomVo vo = new ChatRoomVo();	
		
		//이미지 파일이 있다면?
		if(file != null && !file.isEmpty()) {
			//이미지 파일을 C드라이브에 저장
			fileName = chatService.chatProfileImgUpload(file);
			vo.setProfileImg(fileName);
		}else {
			vo.setProfileImg(request.getParameter("chatProfileImg"));
		}
		
		int	persons = Integer.parseInt(request.getParameter("persons"));
			
		vo.setPersons(persons);		
		vo.setRoomId(request.getParameter("roomId"));
		vo.setTitle(request.getParameter("title"));
		vo.setChatType(request.getParameter("chatType"));
		
		//채팅방 정보 업데이트
		chatService.updateChatRoom(vo);
						
		return "redirect:/chat/doChat?roomId=" + vo.getRoomId() + "&chatType=" + vo.getChatType();	
	}
	

	//오픈 채팅방 방장 위임
	@Override
	@RequestMapping(value = "/changeLeader", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changeLeader(@RequestBody Map<String, String> param) {
		String userId = param.get("userId");
		String roomId = param.get("roomId");

		Map<String, Object> result = new HashMap<>();
		
		try {
			chatService.changeRoomLeader(roomId, userId);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}
	
	
	//오픈 채팅방 멤버 강퇴
	@Override
	@RequestMapping(value = "/kickMember", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> kickMember(@RequestBody Map<String, String> param) {
		String userId = param.get("userId");
		String roomId = param.get("roomId");

		Map<String, Object> result = new HashMap<>();
		
		try {
			chatService.kickMember(roomId, userId);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}	


}
