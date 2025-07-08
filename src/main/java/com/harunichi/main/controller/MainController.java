package com.harunichi.main.controller;

import java.util.List;
import java.util.Locale;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.harunichi.product.service.ProductService;
import com.harunichi.product.vo.ProductVo;
import com.harunichi.board.service.BoardService;
import com.harunichi.board.vo.BoardVo;
import com.harunichi.chat.service.ChatService;
import com.harunichi.member.vo.MemberVo;
import com.harunichi.visit.service.VisitService;


@Controller
public class MainController {
	
	@Autowired
    private VisitService visitService;
	@Autowired
	private ChatService chatService;
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
		
    @Autowired
    private ProductService productService;
    
    @Autowired
    private BoardService boardService;
	
	
	//메인 페이지를 보여주는 메서드
	//http://localhost:8090/harunichi 요청시 메인페이지, 또는
	//http://localhost:8090/harunichi/main 요청시 메인페이지
	@RequestMapping(value = {"/", "/main"}, method = RequestMethod.GET)
	public String showMainPage(Locale locale, Model model, HttpServletRequest request) throws Exception {
		
		logger.info("메인페이지입니다.", locale);
		
		// 인기 게시글 TOP 100 (5개만 출력됨)
		List<BoardVo> top100List = boardService.getTop100BoardsByViews();
		 model.addAttribute("top100List", top100List);
		
	    // 인기 상품 조회
	    List<ProductVo> topProducts = productService.getTopViewedProducts();
	    model.addAttribute("topProducts", topProducts);
		
		// 인터셉터가 넣어둔 viewName 가져오기
		String viewName = (String) request.getAttribute("viewName");
		System.out.println("컨트롤러에서 가져온 viewName: " + viewName);
		
		// 세션에 국가 정보 확인 및 설정
	    HttpSession session = request.getSession();
	    String selectedCountry = (String) session.getAttribute("selectedCountry");
	    // 세션에 국가 정보가 없으면 기본값 'kr'로 설정
	    if (selectedCountry == null || selectedCountry.isEmpty()) {
	        session.setAttribute("selectedCountry", "kr");
	        logger.info("세션에 국가 정보가 없어 기본값 'kr' 저장.");
	        selectedCountry = "kr";
	    } else {
	        logger.info("세션에 이미 저장된 국가 정보 확인: " + selectedCountry);
	    }

	    // 세션에 저장된 국가 정보를 Model에 담아서 JSP로 전달
	    model.addAttribute("selectedCountry", selectedCountry);
	    
//친구 추천 슬라이드 시작-----------------------------------------
	    
	    MemberVo member = (MemberVo) session.getAttribute("member");
	    
	    String id = null;
	    
	    if(member != null && member.getId() != null && !member.getId().isEmpty()) {
	    	id = member.getId();
	    }
	    
		//DB에서 채팅친구추천 리스트 조회
		List<MemberVo> memberList = chatService.selectMembers(id);		
		model.addAttribute("memberList", memberList);
		
//친구 추천 슬라이드 끝-----------------------------------------	  
	    
		logger.info("MainController - showMainPage() 메소드 종료. Returning view name: /main");
		return "/main"; 
	}
	
	
	//세션에 국가를 저장하는 메서드
	@RequestMapping(value = "/main/selectCountry", method = RequestMethod.POST)
	@ResponseBody // 이 메서드는 뷰 이름을 반환하는 대신 응답 본문에 직접 내용을 씁니다. (AJAX 통신 시 주로 사용)
	public String selectCountry(@RequestParam("nationality") String nationality, HttpServletRequest request) {
		logger.info("Received country selection: " + nationality);

		HttpSession session = request.getSession(); // 세션 객체 가져오기
		session.setAttribute("selectedCountry", nationality); // 세션에 "selectedCountry"라는 이름으로 국가 정보 저장
		// 헤더의 국가 선택 셀렉트 박스에서
		// - 일본 선택 시: selectedCountry 세션 속성에 "jp" 저장
		// - 한국 선택 시: selectedCountry 세션 속성에 "kr" 저장

		logger.info("Saved nationality '" + nationality + "' to session.");

		return "success"; // 클라이언트(JavaScript)로 성공 응답 보내기
	}

}
