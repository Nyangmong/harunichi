package com.harunichi.member.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.harunichi.member.vo.MemberVo;

public interface MemberController {
	//요청 페이지 보여주는 메소드
	public ModelAndView showForms(HttpServletRequest request, HttpServletResponse response) throws Exception;
	//로그인메소드
	public String login (@RequestParam("id") String id, @RequestParam("password") String password, HttpSession session);
	//로그아웃메소드
	public String logout(HttpServletRequest request);
	//일반 회원가입메소드
	public String addMemberProcess(@RequestParam("id") String id, @RequestParam("pass") String pass, @RequestParam("name") String name, @RequestParam("nick") String nick, @RequestParam("year") String yearString, @RequestParam(value = "gender", required = false) String gender, @RequestParam(value = "tel", required = false) String tel, @RequestParam(value = "address", required = false) String address, HttpSession session) throws Exception;
	// 프로필이미지, 관심사 세팅 후 가입완료까지(insert까지 처리)
	public void profileImgAndMyLikeSettingProcess( @RequestParam("profileImg") MultipartFile profileImg, @RequestParam(value = "myLike", required = false) String[] myLikes, HttpServletRequest request, HttpServletResponse response, Model model);
	//아이디 중복확인 메소드
	public ResponseEntity checkId(@RequestParam("id") String id,HttpServletRequest request, HttpServletResponse response) throws Exception;
	//회원 정보 수정 메소드
	public String updateMyInfoProcess(@RequestParam("id") String id, @RequestParam(value = "pass", required = false) String pass, @RequestParam("name") String name, @RequestParam("nick") String nick, @RequestParam("email") String email, @RequestParam("year") String yearString, @RequestParam(value = "gender", required = false) String gender, @RequestParam(value = "tel", required = false) String tel, @RequestParam(value = "address", required = false) String address, @RequestParam(value = "detailAddress", required = false) String detailAddress, @RequestParam(value = "contry") String contry, @RequestParam(value = "myLike", required = false) String[] myLikes, @RequestParam(value = "profileImg", required = false) MultipartFile profileImg, @RequestParam(value = "resetProfile", required = false) String resetProfile, HttpSession session, HttpServletRequest request, HttpServletResponse response) throws Exception;
}
