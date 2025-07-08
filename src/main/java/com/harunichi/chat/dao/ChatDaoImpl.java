package com.harunichi.chat.dao;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.harunichi.chat.vo.ChatRoomVo;
import com.harunichi.chat.vo.ChatVo;
import com.harunichi.member.vo.MemberVo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class ChatDaoImpl implements ChatDao {

	@Autowired
	private SqlSession sqlSession;		

	private static final String NAMESPACE = "mapper.chat.";
	
	//채팅 메세지 DB에 저장
	@Override	
	public void saveMessage(ChatVo chatMsg) {		
		System.out.println("===ChatDao의 saveMessage 메소드 실행");	
		sqlSession.insert(NAMESPACE + "saveMessage", chatMsg);			
	}
	
	//chatRoom 테이블에 최신 메세지 시간 업데이트
	@Override
	public void updateChatRoomTime(String roomId) {
		log.info("===ChatDao의 updateChatRoomTime 메소드 실행");
		sqlSession.update(NAMESPACE + "updateChatRoomTime", roomId);
	}

	//친구 추천 리스트 조회	
	@Override
	public List<MemberVo> selectMembers(String id) {
		System.out.println("===ChatDao의 selectMembers 메소드 실행");		
		
		//사용자의 관심사 조회하여 변수에 저장
		String myLike = sqlSession.selectOne(NAMESPACE + "selectMyLike", id);		
		System.out.println("myLike : " + myLike);
		System.out.println("id : " + id);
		
		//조회한 관심사를 ","로 구분하여 자른 후 List에 저장
		List<String> likeList = Arrays.stream(myLike.split(","))
								      .map(String::trim) 
								      .collect(Collectors.toList());
		
		//map에 관심사와 아이디를 저장하여 매퍼파일 매개변수로 전달
		Map<String, Object> MyLikeMap = new HashMap<String, Object>();
		MyLikeMap.put("likeList", likeList);
		MyLikeMap.put("id", id);
		
		//관심사와 연령대가 비슷한 사람 10명 조회하여 List에 저장
		List<MemberVo> resultList = sqlSession.selectList(NAMESPACE + "selectMembers", MyLikeMap);
		
		//List에 10명이 저장되지않았을 경우 (랜덤으로 추천하기 위함)
		if (resultList.size() < 10) {
		    int shortage = 10 - resultList.size();	//부족한 멤버수 계산하여 저장
		    
		    //조회된 멤버들 중복 조회 방지를 위해 조회된 멤버들 id를 List에 저장
		    List<String> alreadySelectedIds = resultList.stream()
									          .map(MemberVo::getId)
									          .collect(Collectors.toList());
		    
		    //사용자 아이디, 조회된 멤버 아이디, 부족한 멤버수를 Map에 저장하여 매퍼파일 매개변수로 전달
		    Map<String, Object> randomMap = new HashMap<>();
		    randomMap.put("id", id);
		    randomMap.put("alreadySelectedIds", alreadySelectedIds);
		    randomMap.put("shortage", shortage);

		    List<MemberVo> randomMembers = sqlSession.selectList(NAMESPACE + "selectRandomMember", randomMap);
		    resultList.addAll(randomMembers);
		}
		return resultList;		
	}
	
	//친구 추천 리스트 조회(비로그인)
	@Override
	public List<MemberVo> selectRandomMembers() {
		return sqlSession.selectList(NAMESPACE + "selectRandomMembers");
	}
	
	//DB에서 채팅방 ID 조회
	@Override
	public String selectRoomId(String senderId, String receiverId, String chatType) {		
		System.out.println("===ChatDao의 selectRoomId 메소드 실행");	
		
		Map<String, String> idMap = new HashMap<String, String>();
		idMap.put("senderId", senderId);
		idMap.put("receiverId", receiverId);
		idMap.put("chatType", chatType);
			
		return sqlSession.selectOne(NAMESPACE + "selectRoomId", idMap);
	}	
	
	//DB의 chatRoom테이블에 roomId 저장
	@Override
	public void insertRoomId(Map<String, Object> roomMap) {
		System.out.println("===ChatDao의 insertRoomId 메소드 실행");
		sqlSession.insert(NAMESPACE + "insertRoomId", roomMap);				
	}
	
	//DB에서 채팅 내역 조회	
	@Override
	public List<ChatVo> selectChatHistory(String roomId, String userId) {
		System.out.println("===ChatDao의 selectChatHistory 메소드 실행");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("roomId", roomId);
		map.put("userId", userId);	
		return sqlSession.selectList(NAMESPACE + "selectChatHistory", map);
	}
	
	//채팅방에 참여하고 있는 유저 조회
	@Override
	public int selectUserCount(String roomId) {
		System.out.println("===ChatDao의 selectUserCount 메소드 실행");
		return sqlSession.selectOne(NAMESPACE + "selectUserCount", roomId);
	}

	//특정 오픈 채팅방 정보 조회
	@Override
	public ChatRoomVo selectOpenChatById(String roomId) {		
		System.out.println("===ChatDao의 selectOpenChatById 메소드 실행");
		return sqlSession.selectOne(NAMESPACE + "selectOpenChatById", roomId);
	}
	
	//나와 채팅 중인 상대방 ID 조회
	@Override
	public String selectChatMemberId(String userId, String roomId) {
		log.info("===ChatDao의 selectChatMemberId 메소드 실행");
		Map<String, String> map = new HashMap<String, String>();
		map.put("userId", userId);
		map.put("roomId", roomId);
		return sqlSession.selectOne(NAMESPACE + "selectChatMemberId", map);
	}

	//채팅 상대 프로필 정보 조회
	@Override
	public MemberVo selectProfile(String receiverId) {
		System.out.println("===ChatDao의 selectProfile 메소드 실행");
		return sqlSession.selectOne(NAMESPACE + "selectProfile", receiverId);
	}

	//오픈 채팅방 리스트 조회
	@Override
	public List<ChatRoomVo> selectOpenChat() {
		System.out.println("===ChatDao의 selectOpenChat 메소드 실행");
		return sqlSession.selectList(NAMESPACE + "selectOpenChat");
	}
	
	//참여중인 채팅방 정보 조회
	@Override
	public List<ChatRoomVo> selectMyChatList(String id) {
		log.info("===ChatDao의 selectMyChatList 메소드 실행");
		return sqlSession.selectList(NAMESPACE + "selectMyChatList",  id);
	}

	//참여중인 채팅의 메세지 정보 조회
	@Override
	public ChatVo selectMyChatMessage(String roomId) {
		System.out.println("===ChatDao의 selectMyChat 메소드 실행");
		return sqlSession.selectOne(NAMESPACE + "selectMyChatMessage", roomId);
	}
	
	//로그인 사용자가 참여하려는 채팅방에 이미 참여하고 있는지 확인
	@Override
	public boolean isUserInRoom(Map<String, String> map) {
		return sqlSession.selectOne(NAMESPACE + "isUserInRoom", map);
	}
	
	//오픈 채팅 참여
	@Override
	public void doOpenChat(ChatRoomVo chatRoomVo) {
		sqlSession.insert(NAMESPACE + "doOpenChat", chatRoomVo);		
	}

	//채팅방 정보에 상품ID 업데이트
	@Override
	public void updateChatProduct(String roomId, int productId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("roomId", roomId);
		map.put("productId", productId);		
		sqlSession.update(NAMESPACE + "updateChatProduct", map);
	}

	//채팅방 정보에 상품ID 제거
	@Override
	public void deleteProductId(String roomId, int productId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("roomId", roomId);
		map.put("productId", productId);	
		sqlSession.update(NAMESPACE + "deleteProductId", map);		
	}

	//채팅방 나가기
	@Override
	public void leaveChatRoom(Map<String, String> map) {
		sqlSession.update(NAMESPACE + "leaveChatRoom", map);
	}

	//채팅 내역 삭제
	@Override
	public void deleteChat(String roomId) {
		sqlSession.delete(NAMESPACE + "deleteChat", roomId);
	}

	//채팅방 삭제
	@Override
	public void deleteChatRoom(String roomId) {
		sqlSession.delete(NAMESPACE + "deleteChatRoom", roomId);
	}

	//특정 오픈 채팅방의 방장 ID 조회
	@Override
	public String selectLeaderId(String roomId) {		
		return sqlSession.selectOne(NAMESPACE + "selectLeaderId", roomId);
	}

	//채팅방에 참여하고 있는 유저 ID 조회
	@Override
	public List<String> selectUserByRoomId(String roomId) {
		return sqlSession.selectList(NAMESPACE + "selectUserByRoomId", roomId);
	}

	//오픈 채팅방 정보 업데이트
	@Override
	public void updateChatRoom(ChatRoomVo vo) {
		sqlSession.update(NAMESPACE + "updateChatRoom", vo);
	}

	//채팅방에서 나갔다가 다시 참여할 경우
	@Override
	public void changeIsDeleted(String senderId, String roomId) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("userId", senderId);
		map.put("roomId", roomId);		
		sqlSession.update(NAMESPACE + "changeIsDeleted", map);
	}

	//오픈 채팅방 방장 위임
	@Override
	public void changeRoomLeader(String roomId, String userId) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("roomId", roomId);
		map.put("userId", userId);				
		sqlSession.update(NAMESPACE + "changeRoomLeader", map);		
	}

	//오픈 채팅방 멤버 강퇴
	@Override
	public void kickMember(String roomId, String userId) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("roomId", roomId);
		map.put("userId", userId);				
		sqlSession.update(NAMESPACE + "kickMember", map);			
	}

	//강퇴 당한 채팅방인지 확인
	@Override
	public boolean isKicked(String roomId, String userId) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("roomId", roomId);
		map.put("userId", userId);		
		return sqlSession.selectOne(NAMESPACE + "isKicked", map);
	}

	//관리자 페이지 채팅방 검색
	@Override
	public List<ChatRoomVo> searchChatRoomList(String searchKeyword, String searchType, int offset, int pageSize) {	
	    Map<String, Object> params = new HashMap<>();
	    params.put("searchKeyword", searchKeyword);
	    params.put("searchType", searchType);
	    params.put("offset", offset);
	    params.put("pageSize", pageSize);
	    return sqlSession.selectList(NAMESPACE + "searchChatRoomList", params);
	}

	//관리자 채팅방 정보 수정
	@Override
	public void updateChatRoomAdmin(ChatRoomVo vo) {
		sqlSession.update(NAMESPACE + "updateChatRoomAdmin", vo);
	}
	
	//관리자 채팅방 삭제
	@Override
	public void deleteChatRoomAdmin(String roomId) {
		sqlSession.delete(NAMESPACE + "deleteChatRoom", roomId);
	}

	
	
	
}
