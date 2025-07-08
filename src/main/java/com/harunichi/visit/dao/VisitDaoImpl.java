package com.harunichi.visit.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.harunichi.visit.vo.VisitVo;

@Repository("visitDao")
public class VisitDaoImpl implements VisitDao {
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void insertVisit(String ip) {
		sqlSession.insert("mapper.visit.insertVisit", ip);
	}

	@Override
	public int selectTodayVisitCount() {
		return sqlSession.selectOne("mapper.visit.selectTodayVisitCount");
	}

	@Override
	public int selectTotalVisitCount() {
		return sqlSession.selectOne("mapper.visit.selectTotalVisitCount");
	}

	@Override
	public List<VisitVo> selectVisitTrend7Days() {
		return sqlSession.selectList("mapper.visit.selectVisitTrend7Days");
	}
}
