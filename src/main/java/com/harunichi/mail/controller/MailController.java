package com.harunichi.mail.controller;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

public interface MailController {
	
	//인증코드를 메일로 보내는 메서드
	@ResponseBody
    String sendAuthEmail(@RequestParam("email") String email, @RequestParam("nationality") String nationality);
	
	//메일로보낸 인증코드를 확인하는 메서드
    @ResponseBody
    String verifyAuthCode(@RequestParam("email") String email, @RequestParam("authCode") String authCode, HttpSession session);
    
}
