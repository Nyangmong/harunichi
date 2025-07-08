package com.harunichi.board.vo;

import lombok.Data;

@Data
public class BoardLikeVo {
	private int boardLikeId;
	private String boardLikeUser;
	private int boardLikePost;
	private boolean userLiked; // 현재 로그인한 사용자의 좋아요 상태
}
