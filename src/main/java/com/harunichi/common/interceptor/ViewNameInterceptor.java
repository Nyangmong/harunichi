package com.harunichi.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class ViewNameInterceptor extends  HandlerInterceptorAdapter{

	// 컨트롤러 클래스 실행전 요청한 주소에 관하여 뷰주소를 얻어 request메모리에 뷰주소를 저장하는 메소드
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {	

		//뷰 경로 얻기
		try {

			String viewName = getViewName(request);

			System.out.println("ViewNameInterceptor인터셉터 내부의 preHandle메소드가 만든 뷰주소 : " + viewName);

			request.setAttribute("viewName", viewName);

		} catch (Exception e) {
			e.printStackTrace();
		}
		// 클라이언트가 요청한 주소와 매핑된 특정 컨트롤러 클래스의 @RequestMapping된 메소드로 다시 재요청해 이동 되게 된다.
		return true;
	}

	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
						   ModelAndView modelAndView) throws Exception {

		System.out.println("ViewNameInterceptor의 2번째 postHandle메소드가 호출됨");
	}

	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
				throws Exception {
	}

	
	//뷰 전체 주소를 얻기 위한 메소드
	//메인 화면 요청 주소 - http://localhost:8090/harunichi/main/main.do를 입력하면 
	//                 요청한 전체 주소에서 main/main 뷰 전체 주소를 얻기 위한 메소드 
	private String getViewName(HttpServletRequest request) throws Exception {
		String contextPath = request.getContextPath();
		String uri = (String) request.getAttribute("javax.servlet.include.request_uri");
		if (uri == null || uri.trim().equals("")) {
			uri = request.getRequestURI();
		}

		int begin = 0;
		if (!((contextPath == null) || ("".equals(contextPath)))) {
			begin = contextPath.length();
		}

		int end;
		if (uri.indexOf(";") != -1) {
			end = uri.indexOf(";");
		} else if (uri.indexOf("?") != -1) {
			end = uri.indexOf("?");
		} else {
			end = uri.length();
		}

		String fileName = uri.substring(begin, end);
		if (fileName.indexOf(".") != -1) {
			fileName = fileName.substring(0, fileName.lastIndexOf("."));
		}
		if (fileName.lastIndexOf("/") != -1) {
			fileName = fileName.substring(fileName.lastIndexOf("/", 1), fileName.length());
		}
		return fileName;
	}
}