package com.harunichi.board.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.harunichi.board.vo.BoardVo;
import com.harunichi.board.vo.ReplyVo;

public interface BoardController {

	// 전체 글 목록
	ModelAndView boardList(HttpServletRequest request, HttpServletResponse response) throws Exception;

	// 게시글 등록
	ModelAndView boardPost(HttpServletRequest request, HttpServletResponse response, List<MultipartFile> imageFiles)
			throws Exception;

	// 게시글 수정 폼
	ModelAndView editBoardForm(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;

	// 게시글 수정 폼에서 넘어온 데이터를 처리하는 메소드
	// ModelAndView updateBoard(HttpServletRequest request, HttpServletResponse
	// response, List<MultipartFile> imageFiles) throws Exception;
	ModelAndView updateBoard(HttpServletRequest request, HttpServletResponse response, List<MultipartFile> imageFiles,
			List<Integer> deleteIndices);

	// 게시글 삭제
	ModelAndView deleteBoard(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;

	// 게시글 상세 (댓글 목록 포함)
	ModelAndView viewBoard(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;

	public String addReply(ReplyVo reply, HttpServletRequest request, HttpServletResponse response) throws Exception;

	// 게시글 좋아요
	String boardLike(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;

	// 게시글 좋아요 취소
	String boardLikeCancel(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;

	// 게시글 좋아요 상태
	String boardLikeStatus(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;

	// 게시글 총 좋아요 수 조회
	String boardLikeCount(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;

	// 게시글 검색 (아이디, 닉네임, 글 내용)
	ModelAndView searchBoard(String keyword, HttpServletRequest request, HttpServletResponse response) throws Exception;

	// 카테고리별 게시글 목록
	String listByCategory(String category, HttpServletRequest request, HttpServletResponse response) throws Exception;

	// 관리자 게시글 목록
	ModelAndView boardManage(HttpServletRequest request, HttpServletResponse response) throws Exception;

	 // 관리자 게시글 삭제
    String deleteInAdmin (String action, List<Integer> selectedIds, List<BoardVo> boards, HttpServletRequest request) throws Exception;
    
    // 관리자 게시글 수정 폼
    public ModelAndView editFormInAdmin(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception;
    
    // 관리자 게시글 수정 처리
    public String updateInAdminBoard(HttpServletRequest request, HttpServletResponse response) throws Exception;

	ModelAndView top100List(HttpServletRequest request, HttpServletResponse response) throws Exception;
    
}
