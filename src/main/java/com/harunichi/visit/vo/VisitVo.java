package com.harunichi.visit.vo;

public class VisitVo {
	private String date;
	private int cnt;
	
	public VisitVo() {
    }

	public VisitVo(String date, int cnt) {
	    this.date = date;
	    this.cnt = cnt;
	}
	
	// getter & setter
	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public int getCnt() {
		return cnt;
	}

	public void setCnt(int cnt) {
		this.cnt = cnt;
	}

	@Override
	public String toString() {
		return "VisitVo [date=" + date + ", cnt=" + cnt + "]";
	}

	
}
