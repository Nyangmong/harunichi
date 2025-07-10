package com.harunichi.translate;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.*;
import java.net.*;
import java.util.*;

@Controller
public class TranslateController {
	
	//번역 요청 처리 메서드
	@RequestMapping(value = "/translate", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> translateText(
	        @RequestParam("text") String text,
	        @RequestParam("lang") String country // "kr" 또는 "jp"
	) throws Exception {
	    // 명시적 매핑
	    String targetLang;
	    switch (country) {
	        case "kr": targetLang = "ko"; break;
	        case "jp": targetLang = "ja"; break;
	        default:
	            throw new IllegalArgumentException("지원하지 않는 언어 코드입니다: " + country);
	    }

	    String translated = googleTranslate(text, targetLang);

	    Map<String, String> result = new HashMap<>();
	    result.put("translatedText", translated);
	    return result;
	}


	// Google Cloud Translation API 호출 메서드
	private String googleTranslate(String text, String targetLang) throws Exception {
	    String sourceLang = "ko";  // 기본 소스 언어는 한국어로 고정
	    
	    // sourceLang과 targetLang이 같으면 번역하지 않고 원본 텍스트 그대로 반환
	    if (sourceLang.equals(targetLang)) {
	        return text;
	    }

	    String apiKey = "유효한 API 키 사용"; // 유효한 API 키 사용
	    String urlStr = "https://translation.googleapis.com/language/translate/v2?key=" + apiKey;

	    URL url = new URL(urlStr);
	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	    conn.setRequestMethod("POST");
	    conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
	    conn.setDoOutput(true);

	    String body = String.format(
	        "{\"q\":\"%s\", \"source\":\"%s\", \"target\":\"%s\", \"format\":\"text\"}",
	        text, sourceLang, targetLang
	    );

	    try (OutputStream os = conn.getOutputStream()) {
	        os.write(body.getBytes("utf-8"));
	    }

	    int responseCode = conn.getResponseCode();
	    InputStream is = (responseCode == 200)
	        ? conn.getInputStream()
	        : conn.getErrorStream(); // 에러 응답도 처리해야 함

	    BufferedReader br = new BufferedReader(new InputStreamReader(is, "utf-8"));
	    StringBuilder response = new StringBuilder();
	    String line;
	    while ((line = br.readLine()) != null) {
	        response.append(line.trim());
	    }

	    if (responseCode != 200) {
	        System.out.println("[Google 번역 에러] 응답 코드: " + responseCode);
	        System.out.println("[응답 본문]: " + response);
	        throw new RuntimeException("Google 번역 API 오류");
	    }

	    JSONObject json = new JSONObject(response.toString());
	    return json.getJSONObject("data").getJSONArray("translations")
	               .getJSONObject(0).getString("translatedText");
	}

}
