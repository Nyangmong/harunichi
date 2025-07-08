package com.harunichi.mypage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.harunichi.board.vo.BoardVo;
import com.harunichi.main.controller.MainController;
import com.harunichi.member.service.MemberService;
import com.harunichi.member.vo.MemberVo;

@Controller
public class MyPageController {

    private static final Logger logger = LoggerFactory.getLogger(MainController.class);

    @Autowired
    private MemberService memberService;

    @Autowired
    private SqlSession sqlSession;

    // 마이페이지 메인
    @RequestMapping(value = "/mypage", method = RequestMethod.GET)
    public String showMypage(@RequestParam(required = false) String id,
                             Locale locale,
                             Model model,
                             HttpServletRequest request,
                             HttpServletResponse response,
                             HttpSession session) throws Exception {
    	
    	// 🔍 로그 찍어보기
        System.out.println("요청받은 id: " + id);
        
        MemberVo pageOwner = null;

        if (id != null) {
            pageOwner = memberService.selectMemberById(id);
            if (pageOwner == null) {
                sendAlertAndBack(response, "존재하지 않는 사용자입니다.");
                return null;
            }
        } else {
            pageOwner = (MemberVo) session.getAttribute("member");
            if (pageOwner == null) {
                sendAlertAndBack(response, "로그인이 필요합니다.");
                return null;
            }
        }

        model.addAttribute("pageOwner", pageOwner);

        MemberVo loginMember = (MemberVo) session.getAttribute("member");
        boolean isMyPage = (loginMember != null && pageOwner.getId().equals(loginMember.getId()));
        model.addAttribute("isMyPage", isMyPage);

        int followerCount = sqlSession.selectOne("mapper.follow.getFollowerCount", pageOwner.getId());
        int followingCount = sqlSession.selectOne("mapper.follow.getFollowingCount", pageOwner.getId());
        
        model.addAttribute("followerCount", followerCount);
        model.addAttribute("followingCount", followingCount);

        return "/mypage";
    }
    // 내가쓴 게시글
    @RequestMapping("/member/myBoardList")
    public String myBoardList(@RequestParam("id") String memberId, Model model) {
        System.out.println("🔥🔥 요청으로 넘어온 memberId = " + memberId);

        // 내가 쓴 게시글 조회
        List<BoardVo> boardList = sqlSession.selectList("mapper.member.selectMyBoards", memberId);
        model.addAttribute("boardList", boardList);

        // 좋아요한 게시글 ID 조회
        List<Integer> likedIds = sqlSession.selectList("mapper.member.selectLikedBoardIds", memberId);
        java.util.Map<Integer, Boolean> likedPosts = new java.util.HashMap<>();
        for (Integer id : likedIds) {
            likedPosts.put(id, true);
        }
        model.addAttribute("likedPosts", likedPosts);

        return "member/MyboardList";
    }
    // 내가 좋아요한 게시글
    @RequestMapping("/member/myLikeBoardList")
    public String myLikeBoardList(@RequestParam("id") String memberId, Model model, HttpSession session) {
        System.out.println("💗 좋아요한 게시글 요청 memberId = " + memberId);

        // 좋아요한 게시글 목록
        List<BoardVo> boardList = sqlSession.selectList("mapper.member.selectMyLikedBoards", memberId);
        model.addAttribute("boardList", boardList);

        // 로그인한 사용자 기준 좋아요한 글 표시용 map
        MemberVo loginMember = (MemberVo) session.getAttribute("member");
        if (loginMember != null) {
            List<Integer> likedIds = sqlSession.selectList("mapper.member.selectLikedBoardIds", loginMember.getId());
            Map<Integer, Boolean> likedPosts = new HashMap<>();
            for (Integer id : likedIds) {
                likedPosts.put(id, true);
            }
            model.addAttribute("likedPosts", likedPosts);
        }

        return "member/MyboardList";
    }

    // 나의 거래글 (partial view)
    @RequestMapping("/product/myList")
    public String myProductList(@RequestParam("id") String userId, Model model) {
        model.addAttribute("productList", sqlSession.selectList("mapper.member.selectMyProducts", userId));
        return "mypage/partial/myProductList";
    }

    // 좋아요한 거래글 (partial view)
    @RequestMapping("/like/myLike")
    public String myLikeProductList(@RequestParam("id") String userId, Model model) {
        model.addAttribute("likeProductList", sqlSession.selectList("mapper.member.selectMyLikedProducts", userId));
        return "mypage/partial/myLikeProductList";
    }

    // 나의 주문 내역 (partial view)
    @RequestMapping("/payment/orders")
    public String myOrders(@RequestParam("id") String userId, Model model) {
        model.addAttribute("orderList", sqlSession.selectList("mapper.member.selectMyOrders", userId));
        return "mypage/partial/myOrders";
    }


    // 공용 alert + history.back
    private void sendAlertAndBack(HttpServletResponse response, String msg) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().write("<script>alert('" + msg + "'); history.back();</script>");
        response.getWriter().flush();
    }

}
