package com.harunichi.board.service;

import java.util.List;

import com.harunichi.board.vo.BoardLikeVo;
import com.harunichi.board.vo.BoardVo;
import com.harunichi.board.vo.ReplyVo;

public interface BoardService {

	List<BoardVo> selectBoardList() throws Exception;

	void insertBoard(BoardVo boardVo) throws Exception;

	void updateBoard(BoardVo boardVo) throws Exception;

	BoardVo getBoardById(int boardId) throws Exception;

	void incrementBoardCount(int boardId) throws Exception;

	BoardVo getBoardByIdWithoutIncrement(int boardId) throws Exception;

	// 특정 게시물의 데이터와 댓글 모두 삭제
	public int deleteBoardData(int boardId) throws Exception;

	// 댓글 추가
	public int addReply(ReplyVo reply) throws Exception;

	// 특정 게시물의 댓글 목록 조회
	public List<ReplyVo> getRepliesByBoardId(int boardId) throws Exception;

	// 특정 게시물의 댓글 갯수
	public int getReplyCountByBoardId(int boardId) throws Exception;

	// 댓글 삭제
	public int deleteReply(int replyId, String replyWriter) throws Exception;

	// 댓글 수정
	public int updateReply(int replyId, String replyCont, String replyWriter) throws Exception;

	// 게시글 좋아요
	boolean addBoardLike(BoardLikeVo likeVo) throws Exception;

	// 게시글 좋아요 취소
	boolean cancelBoardLike(BoardLikeVo likeVo) throws Exception;

	// 게시글 좋아요 상태
	boolean checkBoardLikeStatus(BoardLikeVo likeVo) throws Exception;

	// 게시글 총 좋아요 수 조회
	int getBoardLikeCount(int boardId) throws Exception;

	// 게시글 좋아요 수 업데이트
	void updateBoardLikeCount(int boardId, int likeCount) throws Exception;

	// 검색
	List<BoardVo> searchBoards(String keyword) throws Exception;

	// 인기글 5개 (사이드용)
	List<BoardVo> getTop5BoardsByViews() throws Exception;

	// 카테고리별 게시글
	List<BoardVo> getBoardsByCategory(String category) throws Exception;

	// 관리자용
	List<BoardVo> getAllBoardsForAdmin() throws Exception;

	void updateBoardFromAdmin(BoardVo board) throws Exception;

	void deleteBoardFromAdmin(int boardId) throws Exception;
	
	// 관리자용 게시글 검색
    public List<BoardVo> searchBoardsForAdmin(String searchType, String keyword) throws Exception;

    // 인기글 100개 (사이드용)
 	List<BoardVo> getTop100BoardsByViews() throws Exception;


}
