package com.harunichi.translate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class TranslationInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) throws Exception {

        if (modelAndView != null) {
            HttpSession session = request.getSession(false);
            String selectedCountry = "kr"; // 기본값

            if (session != null && session.getAttribute("selectedCountry") != null) {
                selectedCountry = (String) session.getAttribute("selectedCountry");
            }

            modelAndView.addObject("selectedCountry", selectedCountry);
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) throws Exception {
        // 필요 시 정리 로직 작성
    }
}