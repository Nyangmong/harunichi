package com.harunichi.chat.dao;

import java.util.List;
import java.util.Map;

import com.harunichi.chat.vo.ChatRoomVo;
import com.harunichi.chat.vo.ChatVo;
import com.harunichi.member.vo.MemberVo;

public interface ChatDao {

	//채팅 메세지 DB에 저장
	void saveMessage(ChatVo chatMsg);
	
	//chatRoom 테이블에 최신 메세지 시간 업데이트
	void updateChatRoomTime(String roomId);

	//친구 추천 리스트 조회	
	List<MemberVo> selectMembers(String id);

	//친구 추천 리스트 조회(비로그인)
	List<MemberVo> selectRandomMembers();

	//DB에서 채팅방 ID 조회
	String selectRoomId(String senderId, String receiverId, String chatType);

	//DB의 chatRoom테이블에 roomId 저장
	void insertRoomId(Map<String, Object> roomMap);

	//DB에서 채팅 내역 조회	
	List<ChatVo> selectChatHistory(String roomId, String userId);

	//채팅방에 참여하고 있는 유저 조회
	int selectUserCount(String roomId);

	//특정 오픈 채팅방 정보 조회
	ChatRoomVo selectOpenChatById(String roomId);
	
	//나와 채팅 중인 상대방 ID 조회
	String selectChatMemberId(String userId, String roomId);

	//채팅 상대 프로필 정보 조회
	MemberVo selectProfile(String receiverId);

	//오픈 채팅방 리스트 조회
	List<ChatRoomVo> selectOpenChat();

	//참여중인 채팅방 정보 조회
	List<ChatRoomVo> selectMyChatList(String id);
	
	//참여중인 채팅의 메세지 정보 조회
	ChatVo selectMyChatMessage(String roomId);

	//로그인 사용자가 참여하려는 채팅방에 이미 참여하고 있는지 확인
	boolean isUserInRoom(Map<String, String> map);
	
	//오픈 채팅 참여
	void doOpenChat(ChatRoomVo chatRoomVo);

	//채팅방 정보에 상품ID 업데이트
	void updateChatProduct(String roomId, int productId);

	//채팅방 정보에 상품ID 제거
	void deleteProductId(String roomId, int productId);

	//채팅방 나가기
	void leaveChatRoom(Map<String, String> map);
	
	//채팅내역 삭제
	void deleteChat(String roomId);

	//채팅방 삭제
	void deleteChatRoom(String roomId);

	//특정 오픈 채팅방의 방장 ID 조회
	String selectLeaderId(String roomId);

	//채팅방에 참여하고 있는 유저 ID 조회
	List<String> selectUserByRoomId(String roomId);

	//오픈 채팅방 정보 업데이트
	void updateChatRoom(ChatRoomVo vo);

	//채팅방에서 나갔다가 다시 참여할 경우
	void changeIsDeleted(String senderId, String roomId);

	//오픈 채팅방 방장 위임
	void changeRoomLeader(String roomId, String userId);

	//오픈 채팅방 멤버 강퇴
	void kickMember(String roomId, String userId);

	//강퇴 당한 채팅방인지 확인
	boolean isKicked(String roomId, String userId);

	//관리자 페이지 채팅방 검색
	List<ChatRoomVo> searchChatRoomList(String searchKeyword, String searchType, int offset, int pageSize);

	//관리자 채팅방 정보 수정
	void updateChatRoomAdmin(ChatRoomVo vo);

	//관리자 채팅방 삭제
	void deleteChatRoomAdmin(String roomId);

	



}
