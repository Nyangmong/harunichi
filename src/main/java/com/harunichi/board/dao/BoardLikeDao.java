package com.harunichi.board.dao;

import com.harunichi.board.vo.BoardLikeVo;

public interface BoardLikeDao {
	
	// 게시글 좋아요 기록 추가 (BoardLikeVo 객체를 받아서 처리)
	void insertBoardLike(BoardLikeVo likeVo);

	// 사용자가 특정 게시글에 좋아요를 눌렀는지 확인 (BoardLikeVo 객체를 받아서 처리)
	int selectMyLikeCount(BoardLikeVo likeVo); 

	// 게시글 좋아요 기록 삭제 (취소) (BoardLikeVo 객체를 받아서 처리)
	void deleteBoardLike(BoardLikeVo likeVo);

	// 특정 게시글의 총 좋아요 개수 조회 (게시글 번호(boardId)를 받아서 처리)
	int selectTotalLikeCount(int boardId); 

}
