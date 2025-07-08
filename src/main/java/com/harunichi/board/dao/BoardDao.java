package com.harunichi.board.dao;

import java.util.List;

import com.harunichi.board.vo.BoardVo;

public interface BoardDao {

	// 전체 게시글 목록
	List<BoardVo> selectBoardList() throws Exception;

	// 게시글 등록
	void insertBoard(BoardVo boardVo) throws Exception;

	// 게시글 수정
	void updateBoard(BoardVo boardVo) throws Exception;

	// 게시글 상세 조회
	BoardVo getBoardById(int boardId) throws Exception;

	// 조회수 증가
	void incrementBoardCount(int boardId) throws Exception;

	// 조회수 증가 없이 정보만 가져오기
	BoardVo getBoardByIdWithoutIncrement(int boardId) throws Exception;

	// 게시글 삭제
	public int deleteBoard(int boardId) throws Exception;

	// 게시글 좋아요 수 업데이트
	void updateBoardLikeCount(BoardVo boardVo) throws Exception;

	// 게시글의 좋아요 데이터 삭제
	int deleteLikesByBoardId(int boardId) throws Exception;

	// 게시글 검색 (아이디, 닉네임, 글 내용)
	List<BoardVo> searchBoards(String keyword) throws Exception;

	// 인기글 5개 (사이드용)
	List<BoardVo> selectTop5ByViews() throws Exception;

	// 카테고리별 게시글 목록
	List<BoardVo> selectBoardsByCategory(String category) throws Exception;

	// 관리자용
	List<BoardVo> selectAllBoardsForAdmin() throws Exception;
	
	void updateBoardFromAdmin(BoardVo board) throws Exception;

	void deleteBoardFromAdmin(int boardId) throws Exception;
	
	// 게시글 검색
    public List<BoardVo> searchBoardsFromAdmin(String searchType, String keyword) throws Exception;
    
    // 인기글 100개
	List<BoardVo> selectTop100ByViews() throws Exception;
	

}
