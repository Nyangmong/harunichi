package com.harunichi.visit.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.harunichi.visit.vo.VisitVo;

public interface VisitDao {
	void insertVisit(String ip);

	int selectTodayVisitCount();

	int selectTotalVisitCount();

	List<VisitVo> selectVisitTrend7Days();

}
