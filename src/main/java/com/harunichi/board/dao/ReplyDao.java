package com.harunichi.board.dao;

import java.util.List;
import java.util.Map;

import com.harunichi.board.vo.ReplyVo;

public interface ReplyDao {

	// 특정 게시글의 모든 댓글 삭제
	public int deleteRepliesByBoardId(int boardId) throws Exception;

	// 댓글 작성
	public int insertReply(ReplyVo reply) throws Exception;

	// 특정 게시글의 모든 댓글 조회
	public List<ReplyVo> selectRepliesByBoardId(int boardId) throws Exception;

	// 특정 게시글의 모든 댓글 갯수
	public int countRepliesByBoardId(int boardId) throws Exception;

	// 댓글 삭제
	public int deleteReply(Map<String, Object> paramMap) throws Exception;

	// 댓글 수정
	public int updateReply(Map<String, Object> paramMap) throws Exception;
}
