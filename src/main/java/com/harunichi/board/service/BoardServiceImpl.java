package com.harunichi.board.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.harunichi.board.controller.BoardControllerImpl;
import com.harunichi.board.dao.BoardDao;
import com.harunichi.board.dao.BoardLikeDao;
import com.harunichi.board.dao.ReplyDao;
import com.harunichi.board.vo.BoardLikeVo;
import com.harunichi.board.vo.BoardVo;
import com.harunichi.board.vo.ReplyVo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("BoardService")
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDao boardDao;

	@Autowired
	private ReplyDao replyDao;

	@Autowired
	private BoardLikeDao boardLikeDao;

	@Override
	public List<BoardVo> selectBoardList() throws Exception {
		return boardDao.selectBoardList();
	}

	@Override
	public void insertBoard(BoardVo boardVo) throws Exception {
		boardDao.insertBoard(boardVo);
	}

	@Override
	public void updateBoard(BoardVo boardVo) throws Exception {
		boardDao.updateBoard(boardVo);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED)
	public BoardVo getBoardById(int boardId) throws Exception {
		// 1. 해당 boardId의 게시글 조회수를 1 증가
		incrementBoardCount(boardId);
		// 2. 조회수가 증가된 최신 게시글 정보를 가져옴
		BoardVo board = boardDao.getBoardById(boardId);
		// 3. 댓글 개수 조회 및 설정 로직은 Controller로 이동했으므로 여기서는 제거
		if (board != null) {
			log.info(">>게시글 정보 조회 완료.");
		} else {
			log.warn(">>조회할 게시글(ID:{})을 찾을 수 없습니다.", boardId);
		}
		log.info(">>BoardServiceImpl-getBoardById() 호출 종료.");
		return board; // 게시글 정보만 반환
	}

	// 조회수 증가 메소드
	// getBoardById 메소드에서 내부로 호출
	@Override
	public void incrementBoardCount(int boardId) throws Exception {
		boardDao.incrementBoardCount(boardId);
	}

	// 조회수 증가 없이 게시글 정보만 가져오는 메소드
	@Override
	public BoardVo getBoardByIdWithoutIncrement(int boardId) throws Exception {
		return boardDao.getBoardByIdWithoutIncrement(boardId);
	}

	// 게시글 삭제
	@Override
	@Transactional(propagation = Propagation.REQUIRED) // DB 작업에 트랜잭션 적용
	public int deleteBoardData(int boardId) throws Exception {
		int result = 0;
		try {
			// 1. 해당 게시글의 좋아요 데이터 먼저 삭제
			int deletedLikesCount = boardDao.deleteLikesByBoardId(boardId);
			// 2. 해당 게시글에 속한 댓글 삭제
			int deletedRepliesCount = replyDao.deleteRepliesByBoardId(boardId);
			// 3. 게시글 삭제
			result = boardDao.deleteBoard(boardId);

		} catch (Exception e) {
			log.error(">> 데이터베이스 삭제 중 예외 발생, boardId: {}", boardId, e);
			throw e; // 트랜잭션 롤백을 위해 예외 다시 던지기
		}
		log.info(">> BoardServiceImpl-deleteBoardData() 호출 종료, 삭제된 행 수: {}", result);
		return result;
	}

	// 댓글 추가
	@Override
	public int addReply(ReplyVo reply) throws Exception {
		// ReplyDao의 insertReply 메소드를 호출하여 DB에 댓글 저장
		int result = replyDao.insertReply(reply);
		return result; // 삽입된 행 수 반환
	}

	// 특정 게시물의 댓글 조회
	@Override
	public List<ReplyVo> getRepliesByBoardId(int boardId) throws Exception {
		List<ReplyVo> replyList = replyDao.selectRepliesByBoardId(boardId);
		return replyList; // 조회된 댓글 목록 반환
	}

	@Override
	@Transactional(readOnly = true) // 읽기 전용 트랜잭션
	public int getReplyCountByBoardId(int boardId) throws Exception {
		log.info(">>BoardServiceImpl-getReplyCountByBoardId() 호출 시작, boardId:{}", boardId);
		// ReplyDao의 countRepliesByBoardId 메소드를 호출하여 댓글 개수를 가져옵니다.
		int replyCount = replyDao.countRepliesByBoardId(boardId);
		log.info(">>BoardServiceImpl-getReplyCountByBoardId() 호출 종료. 댓글 개수:{}", replyCount);
		return replyCount; // 댓글 개수 반환
	}

	@Override
	public int deleteReply(int replyId, String replyWriter) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("replyId", replyId);
		paramMap.put("currentUserId", replyWriter);
		return replyDao.deleteReply(paramMap);
	}

	@Override
	public int updateReply(int replyId, String replyCont, String replyWriter) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("replyId", replyId);
		paramMap.put("replyCont", replyCont);
		paramMap.put("replyWriter", replyWriter);
		return replyDao.updateReply(paramMap);
	}

	@Override
	public boolean addBoardLike(BoardLikeVo likeVo) throws Exception {

		try {
			// 이미 좋아요를 눌렀는지 확인
			int count = boardLikeDao.selectMyLikeCount(likeVo);

			if (count > 0) {
				// 이미 좋아요를 누른 경우
				log.info(">> 이미 좋아요를 누른 게시글입니다.");
				return false;
			} else {
				// 좋아요 추가
				boardLikeDao.insertBoardLike(likeVo);
				log.info(">> 게시글 좋아요 추가 완료");
				return true;
			}
		} catch (Exception e) {
			log.error(">> 게시글 좋아요 추가 중 예외 발생", e);
			throw e;
		}
	}

	@Override
	public boolean cancelBoardLike(BoardLikeVo likeVo) throws Exception {
		try {
			// 좋아요를 눌렀는지 확인
			int count = boardLikeDao.selectMyLikeCount(likeVo);

			if (count > 0) {
				// 좋아요를 누른 경우, 취소 처리
				boardLikeDao.deleteBoardLike(likeVo);
				log.info(">> 게시글 좋아요 취소 완료");
				return true;
			} else {
				// 좋아요를 누르지 않은 경우
				log.info(">> 좋아요를 누르지 않은 게시글입니다.");
				return false;
			}
		} catch (Exception e) {
			log.error(">> 게시글 좋아요 취소 중 예외 발생", e);
			throw e;
		}
	}

	@Override
	public boolean checkBoardLikeStatus(BoardLikeVo likeVo) throws Exception {
		try {
			int count = boardLikeDao.selectMyLikeCount(likeVo);
			return count > 0;
		} catch (Exception e) {
			log.error(">> 게시글 좋아요 상태 확인 중 예외 발생", e);
			throw e;
		}
	}

	@Override
	public int getBoardLikeCount(int boardId) throws Exception {
		try {
			return boardLikeDao.selectTotalLikeCount(boardId);
		} catch (Exception e) {
			log.error(">> 게시글 총 좋아요 수 조회 중 예외 발생", e);
			throw e;
		}
	}

	@Override
	public void updateBoardLikeCount(int boardId, int likeCount) throws Exception {
		try {
			BoardVo boardVo = new BoardVo();
			boardVo.setBoardId(boardId);
			boardVo.setBoardLike(likeCount);

			boardDao.updateBoardLikeCount(boardVo);
			log.info(">> 게시글 좋아요 수 업데이트 완료");
		} catch (Exception e) {
			log.error(">> 게시글 좋아요 수 업데이트 중 예외 발생", e);
			throw e;
		}
	}

	@Override
	public List<BoardVo> searchBoards(String keyword) throws Exception {
		return boardDao.searchBoards(keyword);
	}

	@Override
	public List<BoardVo> getTop5BoardsByViews() throws Exception {
		return boardDao.selectTop5ByViews();
	}

	@Override
	public List<BoardVo> getBoardsByCategory(String category) throws Exception {
		return boardDao.selectBoardsByCategory(category);
	}

	@Override
	public List<BoardVo> getAllBoardsForAdmin() throws Exception {
		return boardDao.selectAllBoardsForAdmin();
	}

	@Override
	public void updateBoardFromAdmin(BoardVo board) throws Exception {
		boardDao.updateBoardFromAdmin(board);
	}

	@Override
	public void deleteBoardFromAdmin(int boardId) throws Exception {
		replyDao.deleteRepliesByBoardId(boardId);
		boardDao.deleteLikesByBoardId(boardId);
		boardDao.deleteBoard(boardId);
	}

	@Override
	public List<BoardVo> searchBoardsForAdmin(String searchType, String keyword) throws Exception {
		return boardDao.searchBoardsFromAdmin(searchType, keyword);
	}
	
	@Override
	public List<BoardVo> getTop100BoardsByViews() throws Exception {
		return boardDao.selectTop100ByViews();
	}


	
}
