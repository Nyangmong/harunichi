package com.harunichi.board.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired; // 의존성 주입을 위한 어노테이션
import org.springframework.stereotype.Repository; // 이 클래스가 DAO 역할을 한다는 걸 알려주는 어노테이션

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.harunichi.board.vo.BoardVo;
import com.harunichi.member.vo.MemberVo;

@Repository("boardDao")
public class BoardDaoImpl implements BoardDao { // BoardDao 인터페이스 구현

	// boardMapper.xml 의 쿼리 실행 하는 곳

	private static final String NAMESPACE = "mapper.board.";

	@Autowired
	private SqlSession sqlSession;

	// 전체 게시글 목록 가져오기
	@Override
	public List<BoardVo> selectBoardList() throws Exception {
		return sqlSession.selectList(NAMESPACE + "selectBoardList");
	}

	// 객체의 상태를 변경하는 등의 작업을 수행하는 메서드는 void로 선언
	// 게시글 등록
	@Override
	public void insertBoard(BoardVo boardVo) throws Exception {
		sqlSession.insert(NAMESPACE + "insertBoard", boardVo);
	}

	// 게시글 수정
	@Override
	public void updateBoard(BoardVo boardVo) throws Exception {
		sqlSession.update(NAMESPACE + "updateBoard", boardVo);
	}

	// 게시글 조회
	@Override
	public BoardVo getBoardById(int boardId) throws Exception {
		return sqlSession.selectOne(NAMESPACE + "getBoardById", boardId);
	}

	// 게시글 조회수 증가
	@Override
	public void incrementBoardCount(int boardId) throws Exception {
		sqlSession.update(NAMESPACE + "incrementBoardCount", boardId);
	}

	// 조회수 증가 없이 게시글 정보만 가져오는 메소드
	@Override
	public BoardVo getBoardByIdWithoutIncrement(int boardId) throws Exception {
		return sqlSession.selectOne(NAMESPACE + "getBoardByIdWithoutIncrement", boardId);
	}

	// 게시글 삭제
	@Override
	public int deleteBoard(int boardId) throws Exception {
		// BoardMapper.xml에 정의된 deleteBoard 쿼리 실행
		// 네임스페이스.쿼리ID 형식으로 호출함
		return sqlSession.delete(NAMESPACE + "deleteBoard", boardId);
	}

	// 게시글 좋아요 수 업데이트
	@Override
	public void updateBoardLikeCount(BoardVo boardVo) throws Exception {
		sqlSession.update(NAMESPACE + "updateBoardLikeCount", boardVo);
	}

	// 좋아요 삭제
	@Override
	public int deleteLikesByBoardId(int boardId) throws Exception {
		return sqlSession.delete(NAMESPACE + "deleteLikesByBoardId", boardId);
	}

	// 게시글 검색
	@Override
	public List<BoardVo> searchBoards(String keyword) throws Exception {
		return sqlSession.selectList(NAMESPACE + "searchBoards", keyword);
	}

	// 인기글 5개 (사이드용)
	@Override
	public List<BoardVo> selectTop5ByViews() throws Exception {
		return sqlSession.selectList(NAMESPACE + "selectTop5ByViews");
	}

	// 카테고리별 게시글 목록
	@Override
	public List<BoardVo> selectBoardsByCategory(String category) throws Exception {
		return sqlSession.selectList(NAMESPACE + "selectBoardsByCategory", category);
	}

	// 관리자용
	@Override
	public List<BoardVo> selectAllBoardsForAdmin() throws Exception {
		return sqlSession.selectList(NAMESPACE + "selectAllBoardsForAdmin");
	}

	@Override
	public void updateBoardFromAdmin(BoardVo boardVo) throws Exception {
		sqlSession.update(NAMESPACE + "updateBoardForAdmin", boardVo);
	}

	@Override
	public void deleteBoardFromAdmin(int boardId) throws Exception {
		sqlSession.delete(NAMESPACE + "deleteBoard", boardId);
	}
	
	// 게시글 검색
    @Override
    public List<BoardVo> searchBoardsFromAdmin(String searchType, String keyword) throws Exception {      
        
        Map<String, Object> params = new HashMap<>();
        params.put("searchType", searchType);
        params.put("keyword", keyword);
        
        return sqlSession.selectList(NAMESPACE + "searchBoardsForAdmin", params);
    }
    
    // 인기글 100개
 	@Override
 	public List<BoardVo> selectTop100ByViews() throws Exception {
 		return sqlSession.selectList(NAMESPACE + "selectTop100ByViews");
 	}

}
