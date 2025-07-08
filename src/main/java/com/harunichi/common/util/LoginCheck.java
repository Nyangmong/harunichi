package com.harunichi.common.util;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginCheck {

    public static boolean loginCheck(HttpSession session, HttpServletRequest request,
                                     HttpServletResponse response) throws IOException {
        System.out.println("loginCheck------------------------------------");

        String userId = (String) session.getAttribute("id");
        System.out.println("userId : " + userId);

        if (userId == null || userId.trim().isEmpty()) {
            // 현재 요청 URL 저장 (로그인 후 돌아가기 위해)
            String originalUrl = getFullURL(request);
            session.setAttribute("redirectAfterLogin", originalUrl);
            System.out.println("redirectAfterLogin 저장: " + originalUrl);

            // 요청이 Ajax인지 판단
            String ajaxHeader = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(ajaxHeader);

            if (isAjax) {
                response.setContentType("application/json;charset=utf-8");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false, \"message\":\"로그인이 필요합니다.\"}");
                out.flush();
                out.close();
            } else {
                response.setContentType("text/html;charset=utf-8");
                String contextPath = request.getContextPath();
                PrintWriter out = response.getWriter();
                out.println("<script>");
                out.println("alert('로그인 후 이용 가능합니다.');");
                out.println("location.href='" + contextPath + "/member/loginpage.do';");
                out.println("</script>");
                out.flush();
                out.close();
            }

            return false;
        }

        return true;
    }

    // 현재 요청의 전체 URL 생성
    private static String getFullURL(HttpServletRequest request) {
        StringBuffer requestURL = request.getRequestURL();
        String queryString = request.getQueryString();

        if (queryString != null) {
            return requestURL.append("?").append(queryString).toString();
        } else {
            return requestURL.toString();
        }
    }
}
