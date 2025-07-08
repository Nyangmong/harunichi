package com.harunichi.board.vo;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data 
public class ReplyVo {
    private int replyId;
    private String replyCont;
    private Timestamp replyDate;
    private int replyLike;
    private int boardId; // 해당 댓글이 속한 게시글의 ID 작성자 정보 등 추가 필드 정의
    private String replyWriter;
    private String replyWriterImg;
    private String replyWriterId;
    private int parentId;
    
    // 자식 댓글 리스트 (대댓글용)
    private List<ReplyVo> children = new ArrayList<>();
    
}