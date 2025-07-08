package com.harunichi.chat.vo;

import java.sql.Timestamp;
import org.springframework.stereotype.Component;
import lombok.Data;

@Component
@Data
public class ChatVo {

	private int messageId;			//메시지 고유 ID
	private String roomId;			//채팅방 ID
	private String senderId; 		//보낸 사람 ID
	private String nickname;		//채팅방에 표시할 닉네임
	private String receiverId; 		//받는 사람 ID (개인 채팅일 때만)
	private String chatType;		//채팅 종류 (개인:personal, 단체:group)
	private String message;			//채팅 내용
	private Timestamp sentTime;		//보낸 시간
	
	private String displayTime;		//채팅방 목록 표시화면에서 포맷팅한 날짜, 시간 보여주기 위한 변수	
	
//	private String chatFile; 		//첨부 파일 경로 
//	private boolean isRead;			//읽음 여부 (0/false: 안읽음, 1/true: 읽음)
// 	private Timestamp receivedTime; //받은 시간 (안읽음 NULL, 읽는 순간 시간 들어가도록)
//	private boolean isReported;		//신고 여부 (0/false: 정상, 1/true: 신고됨)
	
}
