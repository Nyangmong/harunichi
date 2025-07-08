package com.harunichi.admin.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.harunichi.member.service.MemberService;
import com.harunichi.visit.service.VisitService;
import com.harunichi.visit.vo.VisitVo;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private VisitService visitService;

	@Autowired
	private MemberService memberService;

	@RequestMapping({ "", "/" })
	public String showAdminMain(HttpServletRequest request, Model model) throws Exception {
		// 방문자 7일 추이
		List<VisitVo> dbTrend = visitService.getVisitTrend7Days();
		Map<String, Integer> trendMap = dbTrend.stream().collect(Collectors.toMap(VisitVo::getDate, VisitVo::getCnt));

		List<VisitVo> filledTrend = new ArrayList<>();
		LocalDate today = LocalDate.now();
		for (int i = 6; i >= 0; i--) {
			String date = today.minusDays(i).toString();
			int count = trendMap.getOrDefault(date, 0);
			filledTrend.add(new VisitVo(date, count));
		}

		// JSON 생성
		ObjectMapper mapper = new ObjectMapper();
		model.addAttribute("visitTrendJson", mapper.writeValueAsString(filledTrend));

		// genderDistJson: 그대로 mapper -> controller -> JSP
		model.addAttribute("genderDistJson", mapper.writeValueAsString(memberService.getGenderDistribution()));

		// countryDistJson
		model.addAttribute("countryDistJson", mapper.writeValueAsString(memberService.getCountryDistribution()));

		// 방문자 수
		model.addAttribute("todayVisit", visitService.getTodayVisitCount());
		model.addAttribute("totalVisit", visitService.getTotalVisitCount());

		model.addAttribute("currentUri", request.getRequestURI());

		return "/admin/main";
	}
}
