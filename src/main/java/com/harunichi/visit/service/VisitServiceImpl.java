package com.harunichi.visit.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.harunichi.visit.dao.VisitDao;
import com.harunichi.visit.vo.VisitVo;

@Service("visitService")
public class VisitServiceImpl implements VisitService {
	
	@Autowired
	private VisitDao visitDao;

	@Override
	public void insertVisit(String ip) {
		visitDao.insertVisit(ip);
	}

	@Override
	public int getTodayVisitCount() {
		return visitDao.selectTodayVisitCount();
	}

	@Override
	public int getTotalVisitCount() {
		return visitDao.selectTotalVisitCount();
	}

	@Override
	public List<VisitVo> getVisitTrend7Days() {
		return visitDao.selectVisitTrend7Days();
	}
}
