package com.harunichi.chat.service;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.harunichi.chat.dao.ChatDao;
import com.harunichi.chat.vo.ChatRoomVo;
import com.harunichi.chat.vo.ChatVo;
import com.harunichi.common.util.FileUploadUtil;
import com.harunichi.member.vo.MemberVo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChatServiceImpl implements ChatService {

	@Autowired
	private ChatDao chatDao;
	
	//채팅 메세지 DB에 저장
	@Override
	public void saveMessage(ChatVo chatMsg) {		
		System.out.println("---ChatService의 saveMessage메소드 호출");		
		chatDao.saveMessage(chatMsg);
		//chatRoom 테이블에 최신 메세지 시간 업데이트
		chatDao.updateChatRoomTime(chatMsg.getRoomId());		
	}

	//친구 추천 리스트 조회
	@Override
	public List<MemberVo> selectMembers(String id) {
		System.out.println("---ChatService의 selectMembers메소드 호출");			
		//비로그인
		if(id == null) { return chatDao.selectRandomMembers();
		//로그인
		}else { return chatDao.selectMembers(id); }	
	}
		
	//채팅방 ID 조회
	@Override
	public String selectRoomId(String senderId, String receiverId,  String chatType) {
		System.out.println("---ChatService의 selectRoomId메소드 호출");		
		
		String roomId = chatDao.selectRoomId(senderId, receiverId, chatType);	
		log.info("roomId : " + roomId);
				
		ChatRoomVo vo = new ChatRoomVo();
		vo.setUserId(senderId);
		vo.setReceiverId(receiverId);
		vo.setChatType(chatType);	
		
		//채팅방에서 나갔다가 다시 참여할 경우
		changeIsDeleted(senderId, roomId);
		
		//DB에 조회된 채팅방ID가 없다면?
		if(roomId == null) { roomId = insertRoomId(vo); }	
		
		//DB에서 조회된 채팅방ID 반환
		return roomId;
	}
	
	//채팅방에서 나갔다가 다시 참여할 경우
	@Override
	public void changeIsDeleted(String senderId, String roomId) {
		chatDao.changeIsDeleted(senderId, roomId);
	}
	
	//채팅방 ID DB에 저장
	@Override
	public String insertRoomId(ChatRoomVo vo) {		
		System.out.println("---ChatService의 insertRoomId메소드 호출");		
		
		Map<String, Object> roomMap = new HashMap<String, Object>();
	
		//새로운 채팅방 아이디 생성
		//현재 날짜
		String now = new SimpleDateFormat("yyyyMMdd").format(new Date());		
		//랜덤 숫자 (0 ~ 999999)
		int randomInt = new Random().nextInt(1_000_000);			
		//6자리로 포맷 (앞에 0 채움)
		String random = String.format("%06d", randomInt);			
		//새로운 채팅방 ID 생성 후 반환
		String newRoomId = now + "_" + random;			
		System.out.println("newRoomId : " + newRoomId);		
		
		roomMap.put("roomId", newRoomId);
		roomMap.put("chatType", vo.getChatType());
	
		//단체 채팅일 경우
		if(vo.getChatType().equals("group")) {		
				
			roomMap.put("userId", vo.getUserId());
			roomMap.put("title", vo.getTitle());		
			roomMap.put("persons", vo.getPersons());
			roomMap.put("profileImg", vo.getProfileImg());			

		//개인 채팅일 경우
		}else {			
			List<String> userList = new ArrayList<String>();
			userList.add(vo.getReceiverId()); //상대방
			userList.add(vo.getUserId());	  //로그인 사용자			
			roomMap.put("userList", userList);	
		}

			
		chatDao.insertRoomId(roomMap);
		
		return newRoomId;
	}
	
	//채팅방 프로필 이미지 C드라이브에 저장
	@Override
	public String chatProfileImgUpload(MultipartFile file) {
		log.info("---ChatService의 chatProfileImgUpload메소드 호출");
		
		String imgPath = "C:\\harunichi\\images\\chat";
		String fileName = "";
		
		try {
			fileName = FileUploadUtil.uploadFile(file, imgPath);			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("⚠ 프로필 이미지 저장 실패");
		}		
		return fileName;		
	}
	
	//과거 채팅 내역 불러오기
	@Override
	public List<ChatVo> selectChatHistory(String roomId, String userId) {
		System.out.println("---ChatService의 selectChatHistory메소드 호출");	
		return chatDao.selectChatHistory(roomId, userId);
	}
	
	//채팅방 참여 인원 확인
	@Override
	public int selectUserCount(String roomId) {		
		System.out.println("---ChatService의 selectUserCount메소드 호출");		
		return chatDao.selectUserCount(roomId);
	}
	
	//특정 오픈 채팅방 정보 조회
	@Override
	public ChatRoomVo selectOpenChatById(String roomId) {
		System.out.println("---ChatService의 selectOpenChatById메소드 호출");
		System.out.println("roomId : " + roomId);
		return chatDao.selectOpenChatById(roomId);
	}
	
	//나와 채팅 중인 상대방 ID 조회
	@Override
	public String selectChatMemberId(String userId, String roomId) {
		log.info("---ChatService의 selectChatMemberId메소드 호출");
		return chatDao.selectChatMemberId(userId, roomId);
	}

	//채팅 상대 프로필 정보 조회
	@Override
	public MemberVo selectProfile(String receiverId) {
		System.out.println("---ChatService의 selectProfile메소드 호출");
		return chatDao.selectProfile(receiverId);
	}

	//오픈 채팅방 리스트 조회
	@Override
	public List<ChatRoomVo> selectOpenChat() {	
		System.out.println("---ChatService의 selectOpenChat메소드 호출");
		List<ChatRoomVo> openChatList = chatDao.selectOpenChat();		
		//채팅방 참여 인원 확인
		for(ChatRoomVo vo : openChatList) {
			int count = selectUserCount(vo.getRoomId());
			vo.setUserCount(count);
		}	
		return openChatList;
	}
	
	//참여중인 채팅방 정보 조회
	@Override
	public List<ChatRoomVo> selectMyChatList(String id) {
		System.out.println("---ChatService의 selectMyChatList메소드 호출");
		
		List<ChatRoomVo> myChatList = chatDao.selectMyChatList(id);
		
		//채팅방 참여 인원 확인
		for(ChatRoomVo vo : myChatList) {
			int count = selectUserCount(vo.getRoomId());
			vo.setUserCount(count);
		}	
			
		return myChatList;
	}
	
	//참여중인 채팅의 메세지 정보 조회
	@Override
	public ChatVo selectMyChatMessage(String roomId) {
		System.out.println("---ChatService의 selectMyChat메소드 호출");
		
		//최신 채팅 정보 조회
		ChatVo myChatMessage = chatDao.selectMyChatMessage(roomId);
						
		try {
			//채팅 목록에 나타낼 최신 메세지 시간 나타내기 위한 반복문
			Timestamp sentTime = myChatMessage.getSentTime();
			
			//Timestamp -> LocalDateTime 데이터타입 변환
			LocalDateTime sentDateTime = sentTime.toLocalDateTime();
			
			LocalDate today = LocalDate.now();
			LocalDate sentDate = sentDateTime.toLocalDate();
			
			//날짜와 시간 포맷팅
			DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("a hh:mm", Locale.KOREAN); 
			DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			
			//조건문에서 포맷팅한 날짜와 시간 담을 변수
			String displayTime;
			
			if (sentDate.equals(today)) {
			    displayTime = sentDateTime.format(timeFormatter);
			} else {
			    displayTime = sentDateTime.format(dateFormatter);
			}
			myChatMessage.setDisplayTime(displayTime);
		} catch (Exception e) {
			e.printStackTrace();
		}	
		
		return myChatMessage;		
	}

	//로그인 사용자가 참여하려는 채팅방에 이미 참여하고 있는지 확인
	@Override
	public boolean isUserInRoom(String roomId, String userId) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("roomId", roomId);
		map.put("userId", userId);		
		return chatDao.isUserInRoom(map);
	}
	
	//오픈 채팅 참여
	@Override
	public void doOpenChat(ChatRoomVo chatRoomVo) {
		chatDao.doOpenChat(chatRoomVo);	
	}
	
	//채팅방 정보에 상품ID 업데이트
	@Override
	public void updateChatProduct(String roomId, int productId) {
		chatDao.updateChatProduct(roomId, productId);		
	}

	//채팅방 정보에 상품ID 제거
	@Override
	public void deleteProductId(String roomId, int productId) {
		chatDao.deleteProductId(roomId, productId);
		
	}

	//채팅방 나가기
	@Override
	public void leaveChatRoom(String userId, String roomId) {
		Map<String, String> map = new HashMap<>();
		map.put("userId", userId);
		map.put("roomId", roomId);
		chatDao.leaveChatRoom(map);
	}

	//채팅방 정보와 채팅 내역 삭제
	@Override
	public void deleteChat(String roomId) {			
		//채팅 내역 삭제
		chatDao.deleteChat(roomId);	
		//채팅방 정보 삭제
		chatDao.deleteChatRoom(roomId);	
	}

	//특정 오픈 채팅방의 방장 ID 조회
	@Override
	public String selectLeaderId(String roomId) {
		return chatDao.selectLeaderId(roomId);
	}

	//채팅방에 참여하고 있는 유저 ID 조회
	@Override
	public List<String> selectUserByRoomId(String roomId) {
		return chatDao.selectUserByRoomId(roomId);
	}

	//오픈 채팅방 정보 업데이트
	@Override
	public void updateChatRoom(ChatRoomVo vo) {
		chatDao.updateChatRoom(vo);
	}

	//오픈 채팅방 방장 위임
	@Override
	public void changeRoomLeader(String roomId, String userId) {
		chatDao.changeRoomLeader(roomId, userId);
	}

	//오픈 채팅방 멤버 강퇴
	@Override
	public void kickMember(String roomId, String userId) {
		chatDao.kickMember(roomId, userId);
	}

	//강퇴 당한 채팅방인지 확인
	@Override
	public boolean isKicked(String roomId, String userId) {
		return chatDao.isKicked(roomId, userId);
	}

	//관리자 페이지 채팅방 검색
	@Override
	public Map<String, Object> searchChatRoomList(String searchKeyword, String searchType, int page) {	
		int pageSize = 7;
	    int offset = (page - 1) * pageSize;

	    Map<String, Object> result = new HashMap<>();
	    List<ChatRoomVo> chatRoomList = chatDao.searchChatRoomList(searchKeyword, searchType, offset, pageSize);
	    	    
	    for(ChatRoomVo chatRoom : chatRoomList) {
	    	int count = chatDao.selectUserCount(chatRoom.getRoomId());
	    	chatRoom.setUserCount(count);
	    }
	    
	    result.put("list", chatRoomList);
	    result.put("totalCount", chatRoomList.size());    
	    result.put("currentPage", page);
	    result.put("pageSize", pageSize);	
	    
		return result;
	}

	//관리자 채팅방 정보 수정
	@Override
	public void updateChatRoomAdmin(ChatRoomVo vo) {
		chatDao.updateChatRoomAdmin(vo);
	}
	
	//관리자 채팅방 삭제
	@Override
	public void deleteChatRoomAdmin(String roomId) {
		chatDao.deleteChatRoomAdmin(roomId);		
	}


}

