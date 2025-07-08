package com.harunichi.chat.vo;

import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class ChatRoomVo {

	private String roomId;				//채팅방 고유 ID
	private String userId;				//참여 유저 ID
	private String title;				//채팅방 제목
	private String leader;				//채팅방 방장
	private int persons;				//채팅방 인원 수 
	private String chatType;			//채팅방 타입 (개인채팅 or 단체채팅)
	private Timestamp admissionTime;	//채팅방 입장 시간 (채팅 내역 불러올 때 사용)
	private String profileImg;			//채팅방 프로필 이미지
	private int productId;				//중고거래 채팅시 상품 ID
	private Timestamp lastMessageTime;	//채팅방의 최신 메세지 시간
	private boolean isDeleted;			//삭제 여부 (0/false, 1/true: 삭제함)
	private boolean isKicked;			//강퇴 여부 (0/false, 1/true: 강퇴당함)

	private String receiverId; 			//채팅방 ID 조회시 값 저장을 위한 변수
	private int userCount;				//오픈 채팅방에 참여중인 인원 수 카운팅

	
}


