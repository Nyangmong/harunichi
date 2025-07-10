package com.harunichi.payment.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.stereotype.Service;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

@Service
public class IamportServiceImpl implements IamportService {

    private static final String API_KEY = "발급받은_REST_API_KEY" ; // "발급받은_REST_API_KEY";
    private static final String API_SECRET = "발급받은_REST_API_SECRET"; // "발급받은_REST_API_SECRET";

    private final ObjectMapper objectMapper = new ObjectMapper();

    // 포트원 API로부터 AccessToken을 발급받음
    @Override
    public String getAccessToken() throws Exception {
        URL url = new URL("https://api.iamport.kr/users/getToken");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // 요청 JSON 작성
        String json = String.format("{\"imp_key\":\"%s\",\"imp_secret\":\"%s\"}", API_KEY, API_SECRET);
        try (OutputStream os = conn.getOutputStream()) {
            os.write(json.getBytes());
        }

        Scanner sc = new Scanner(conn.getInputStream());
        StringBuilder response = new StringBuilder();
        while (sc.hasNext()) response.append(sc.nextLine());

        JsonNode rootNode = objectMapper.readTree(response.toString());
        return rootNode.path("response").path("access_token").asText();
    }

    // imp_uid로 결제 정보를 조회
    @Override
    public Map<String, Object> getPaymentData(String impUid, String accessToken) throws Exception {
        URL url = new URL("https://api.iamport.kr/payments/" + impUid);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", accessToken);

        Scanner sc = new Scanner(conn.getInputStream());
        StringBuilder response = new StringBuilder();
        while (sc.hasNext()) response.append(sc.nextLine());

        JsonNode rootNode = objectMapper.readTree(response.toString());
        JsonNode res = rootNode.path("response");

        Map<String, Object> paymentInfo = new HashMap<>();
        paymentInfo.put("amount", res.path("amount").asDouble());
        paymentInfo.put("status", res.path("status").asText());

        return paymentInfo;
    }
}
