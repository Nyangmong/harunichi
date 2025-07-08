package com.harunichi.payment.service;

import java.util.Map;

public interface IamportService {
    String getAccessToken() throws Exception;
    
    Map<String, Object> getPaymentData(String impUid, String accessToken) throws Exception;
}
