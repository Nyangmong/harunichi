package com.harunichi.board.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.harunichi.board.vo.BoardLikeVo;

@Repository("BoardLikeDao")
public class BoardLikeDaoImpl implements BoardLikeDao {
	
	private static final String NAMESPACE = "mapper.boardLike.";

	@Autowired
	private SqlSession sqlSession;

	@Override
	public void insertBoardLike(BoardLikeVo likeVo) {
		  sqlSession.insert(NAMESPACE + "insertBoardLike", likeVo);		
	}

	@Override
	public int selectMyLikeCount(BoardLikeVo likeVo) {
		return sqlSession.selectOne(NAMESPACE + "selectMyLikeCount", likeVo);
	}

	@Override
	public void deleteBoardLike(BoardLikeVo likeVo) {
		 sqlSession.delete(NAMESPACE + "deleteBoardLike", likeVo);		
	}

	@Override
	public int selectTotalLikeCount(int boardId) {
		 return sqlSession.selectOne(NAMESPACE + "selectTotalLikeCount", boardId);
	}

}
