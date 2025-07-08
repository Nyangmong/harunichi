package com.harunichi.chat.server;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;


//@ServerEndpoint 안에서 Spring 빈 수동 주입을 위한 클래스
// -> 웹소켓에서는 @Autowired가 안 먹힘! (스프링 컨테이너가 관리 안 하기 때문에!)
@Component
public class SpringContext implements ApplicationContextAware {

	//어디서든 SpringContext.getBean()사용을 위해 static 변수에 저장
	private static ApplicationContext context;

	
	//스프링이 ApplicationContext를 주입해줄 때 호출하는 메소드
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		context = applicationContext;		
	}
	
	
	//빈 호출 메소드	
	public static <T> T getBean(Class<T> clazz) {			
		return context.getBean(clazz);			
	}
	
}
