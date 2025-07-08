package com.harunichi.visit.service;

import java.util.List;

import com.harunichi.visit.vo.VisitVo;

public interface VisitService {
	void insertVisit(String ip);

	int getTodayVisitCount();

	int getTotalVisitCount();

	List<VisitVo> getVisitTrend7Days();
}
