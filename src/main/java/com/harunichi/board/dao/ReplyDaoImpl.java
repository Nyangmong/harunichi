package com.harunichi.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.harunichi.board.vo.ReplyVo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository("replyDao")
public class ReplyDaoImpl implements ReplyDao {

	private static final String NAMESPACE = "mapper.reply.";

	// sqlSession.insert(네임스페이스.쿼리ID, 파라미터객체)

	@Autowired
	private SqlSession sqlSession;

	@Override
	public int deleteRepliesByBoardId(int boardId) throws Exception {
		int deletedCount = sqlSession.delete(NAMESPACE + "deleteRepliesByBoardId", boardId);
		return deletedCount; // 삭제된 행 수 반환
	}

	@Override
	public int insertReply(ReplyVo reply) throws Exception {
		int insertedCount = sqlSession.insert(NAMESPACE + "insertReply", reply);
		return insertedCount; // 삽입된 행 수 반환
	}

	@Override
	public List<ReplyVo> selectRepliesByBoardId(int boardId) throws Exception {
		List<ReplyVo> replyList = sqlSession.selectList(NAMESPACE + "selectRepliesByBoardId", boardId);
		return replyList; // 조회된 댓글 목록 반환
	}

	@Override
	public int countRepliesByBoardId(int boardId) throws Exception {
		Integer count = sqlSession.selectOne(NAMESPACE + "countRepliesByBoardId", boardId);
		// selectOne은 결과가 없을 경우 null을 반환할 수 있으므로 null 체크 후 0으로 처리
		int replyCount = (count != null) ? count : 0;
		return replyCount; // 댓글 개수 반환
	}

	@Override
	public int deleteReply(Map<String, Object> paramMap) throws Exception {
		return sqlSession.delete(NAMESPACE + "deleteReply", paramMap);
	}

	@Override
	public int updateReply(Map<String, Object> paramMap) throws Exception {
		return sqlSession.update(NAMESPACE + "updateReply", paramMap);
	}

}
