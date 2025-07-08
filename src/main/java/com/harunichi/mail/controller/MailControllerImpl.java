package com.harunichi.mail.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.harunichi.member.vo.MemberVo;

@Controller
@RequestMapping("/mail") // 메일 관련 요청은 "/mail"로 시작하기
public class MailControllerImpl implements MailController {
	
	@Autowired
    private JavaMailSender mailSender;
	
	// 이메일과 인증 코드를 저장할 Map
	private Map<String, String> authCodeMap = new HashMap<String, String>();
	
	// 랜덤한 인증코드를 만드는 메서드
	private String createAuthCode() {
		
		int length = 6; // 인증 코드는 6글자로 설정
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"; // 사용할 문자 설정
        
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        
        for (int i = 0; i < 6; i++) {
        	int index = random.nextInt(characters.length()); // characters 문자열에서 랜덤한 인덱스 선택
            code.append(characters.charAt(index)); // 해당 인덱스의 문자 추가
        }
        return code.toString();
    }
	
	//인증코드를 메일로 보내는 메서드
	@Override
	@RequestMapping(value = "/sendAuthEmail.do", method = RequestMethod.POST)
    @ResponseBody
	public String sendAuthEmail(@RequestParam("email") String email, @RequestParam("nationality") String nationality) {
		
		String authCode = createAuthCode(); // 인증 코드 생성
	    String htmlContent; // 보낼 이메일 내용
	    String emailSubject; // 이메일 제목
		
	    // 사용자가 일본어 사용자일 경우, 일본어 메일을 발송한다.
	    if ("jp".equals(nationality)) {
	    	emailSubject = "harunichi メール認証コード"; // 일본어 제목
	        htmlContent = "<!DOCTYPE html>"
	                     + "<html lang='ja'>" // lang 속성 ja (일본어)
	                     + "<head>"
	                     + "<meta charset='UTF-8'>"
	                     + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
	                     + "<title>harunichi メール認証</title>"
	                     + "</head>"
	                     + "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px; background-color: #f4f4f4;'>"
	                         + "<div style='max-width: 600px; margin: 20px auto; padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);'>"
	                             + "<div style='text-align: center; margin-bottom: 20px;'>"
	                                 + "<h1 style='color: #A3DAFF; font-size: 28px; margin: 0;'>harunichi</h1>"
	                             + "</div>"
	                             + "<h2 style='color: #555; font-size: 22px; margin-bottom: 15px; text-align: center;'>メール認証コード</h2>"
	                             + "<p style='font-size: 16px; color: #333; margin-bottom: 20px; text-align: center;'>こんにちは！harunichi会員登録のためのメール認証コードです。</p>"
	                             + "<p style='font-size: 16px; color: #333; margin-bottom: 20px; text-align: center;'>下記の認証コードを会員登録画面に入力してください。</p>"
	                             + "<div style='text-align: center; margin: 30px 0;'>"
	                                 + "<h2 style='color: #A3DAFF; font-size: 36px; margin: 0; padding: 15px 20px; background-color: #e0f7fa; display: inline-block; border-radius: 5px; letter-spacing: 2px;'>" + authCode + "</h2>"
	                             + "</div>"
	                             + "<p style='font-size: 16px; color: #333; margin-top: 20px; text-align: center;'>このコードはしばらくすると無効になります。</p>"
	                             + "<p style='font-size: 16px; color: #333; margin-bottom: 0; text-align: center;'>ありがとうございます。<br/>harunichi チームより</p>"
	                         + "</div>"
	                     + "</body>"
	                     + "</html>";
	    } else { // 일본어 사용자가 아닌경우, 한국어 메일을 발송한다.
	    	emailSubject = "harunichi 회원가입 이메일 인증 코드입니다.";
	        htmlContent = "<!DOCTYPE html>"
	                     + "<html lang='ko'>" // lang 속성 ko (한국어)
	                     + "<head>"
	                     + "<meta charset='UTF-8'>"
	                     + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
	                     + "<title>harunichi 이메일 인증</title>"
	                     + "</head>"
	                     + "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px; background-color: #f4f4f4;'>"
	                         + "<div style='max-width: 600px; margin: 20px auto; padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);'>"
	                             + "<div style='text-align: center; margin-bottom: 20px;'>"
	                                 + "<h1 style='color: #A3DAFF; font-size: 28px; margin: 0;'>harunichi</h1>"
	                             + "</div>"
	                             + "<h2 style='color: #555; font-size: 22px; margin-bottom: 15px; text-align: center;'>이메일 인증 코드</h2>"
	                             + "<p style='font-size: 16px; color: #333; margin-bottom: 20px; text-align: center;'>안녕하세요! harunichi 회원가입을 위한 이메일 인증 코드입니다.</p>"
	                             + "<p style='font-size: 16px; color: #333; margin-bottom: 20px; text-align: center;'>다음 인증 코드를 회원가입 화면에 입력해주세요:</p>"
	                             + "<div style='text-align: center; margin: 30px 0;'>"
	                                 + "<h2 style='color: #A3DAFF; font-size: 36px; margin: 0; padding: 15px 20px; background-color: #e0f7fa; display: inline-block; border-radius: 5px; letter-spacing: 2px;'>" + authCode + "</h2>"
	                             + "</div>"
	                             + "<p style='font-size: 16px; color: #333; margin-top: 20px; text-align: center;'>본 코드는 잠시 후에 만료됩니다.</p>"
	                             + "<p style='font-size: 16px; color: #333; margin-bottom: 0; text-align: center;'>감사합니다.<br/>harunichi 팀 드림</p>"
	                         + "</div>"
	                     + "</body>"
	                     + "</html>";
	    }

	    try {
	        MimeMessage message = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
	        helper.setTo(email);
	        helper.setSubject(emailSubject);
	        helper.setText(htmlContent, true);

	        mailSender.send(message);

	        authCodeMap.put(email, authCode);

	        return "success";

	    } catch (Exception e) {
	        e.printStackTrace();
	        return "error";
	    }
	    
	}
	
	//메일로보낸 인증코드를 확인하는 메서드
	@Override
	@RequestMapping(value = "/verifyAuthCode.do", method = RequestMethod.POST)
	@ResponseBody
	public String verifyAuthCode(@RequestParam("email") String email, @RequestParam("authCode") String authCode, HttpSession session) {
		
		String storedAuthCode = authCodeMap.get(email);

	    if (storedAuthCode != null && storedAuthCode.equals(authCode)) {
	    	
	    	// 1. 세션에서 기존 memberVo 객체 꺼내오기 (국가 정보가 이미 담겨있을 것으로 예상)
	    	MemberVo memberVo = (MemberVo) session.getAttribute("memberVo");
	    	// 세션에 memberVo가 없을경우(비정상적인 흐름) : 처음단계로 리다이렉트
	    	if (memberVo == null) {
	    		return "redirect:/member/addMemberForm.do";
	    	}
	    	
	    	// 2. 이메일 정보 저장
	    	memberVo.setEmail(email);
	    	session.setAttribute("memberVo", memberVo);
	    	System.out.println("세션 memberVo에 이메일 정보 (" + email + ") 저장 완료!");
	    	System.out.println("현재 memberVo 상태 - 국가: " + memberVo.getContry() + ", 이메일: " + memberVo.getEmail());
	    	
	    	// 3. 업데이트된 memberVo 객체를 세션에 다시 저장 (덮어쓰기)
	    	session.setAttribute("memberVo", memberVo);
	    	
	    	authCodeMap.remove(email); // 이메일 인증 성공했으면 맵에서 제거
	        return "success"; // 인증 성공
	    } else {
	        return "error"; // 인증 실패
	    }
	}

	
	
}
