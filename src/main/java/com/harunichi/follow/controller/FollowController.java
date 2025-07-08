package com.harunichi.follow.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.harunichi.follow.vo.FollowVo;
import com.harunichi.member.service.MemberService;
import com.harunichi.member.vo.MemberVo;

@Controller
@RequestMapping("/follow")
public class FollowController {
	
	@Resource
	private SqlSession sqlSession;
	
	@Autowired
	private MemberService memberService;

	
	
	//팔로우
	@RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String addFollow(@RequestParam String followeeId, HttpSession session) {
		// 로그인한 사용자 정보 가져오기
		String followerId = getLoginUserId(session);
		if(followerId == null) {
			return "fail";
		}
		
		FollowVo followVo = new FollowVo();
		followVo.setFollower_id(followerId);
		followVo.setFollowee_id(followeeId);
		
		sqlSession.insert("mapper.follow.insertFollow", followVo);
		return "success";
	}
	
	
	//언팔로우
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	@ResponseBody
	public String removeFollow(@RequestParam String followeeId, HttpSession session) {
		 String followerId = getLoginUserId(session);
	        if (followerId == null) {
	            return "fail";
	        }

	        FollowVo vo = new FollowVo();
	        vo.setFollower_id(followerId);
	        vo.setFollowee_id(followeeId);

	        sqlSession.delete("mapper.follow.deleteFollow", vo);
	        return "success";
	}
	
	
	//팔로우 여부 확인
	@RequestMapping(value = "/isFollowing", method = RequestMethod.GET)
    @ResponseBody
    public boolean isFollowing(@RequestParam String followeeId, HttpSession session) {
        String followerId = getLoginUserId(session);
        if (followerId == null) {
            return false;
        }

        FollowVo vo = new FollowVo();
        vo.setFollower_id(followerId);
        vo.setFollowee_id(followeeId);

        return sqlSession.selectOne("mapper.follow.isFollowing", vo);
    }
	
	
	//팔로잉 수
	@RequestMapping(value = "/followingCount", method = RequestMethod.GET)
	@ResponseBody
	public int getFollowingCount(@RequestParam String followerId) {
	    return sqlSession.selectOne("mapper.follow.getFollowingCount", followerId);
	}
	
	
	//팔로워 수
	@RequestMapping(value = "/followerCount", method = RequestMethod.GET)
    @ResponseBody
    public int getFollowerCount(@RequestParam String followeeId) {
        return sqlSession.selectOne("mapper.follow.getFollowerCount", followeeId);
    }
	
	
	//로그인 사용자 ID 추출
	private String getLoginUserId(HttpSession session) {
		Object member = session.getAttribute("member");
	    if (member != null && member instanceof com.harunichi.member.vo.MemberVo) {
	        String id = ((com.harunichi.member.vo.MemberVo) member).getId();
	        System.out.println("getLoginUserId() 추출 ID: " + id);
	        return id;
	    }
	    System.out.println("getLoginUserId() 로그인 사용자 없음");
	    return null;
    }
	
	
	//팔로우 리스트 조회
	@RequestMapping(value = "/mypageFollow", method = RequestMethod.GET)
	public String showFollowList(
	        @RequestParam String id,
	        @RequestParam String type,
	        Model model,
	        HttpSession session,
	        HttpServletResponse response) throws Exception {

	    MemberVo pageOwner = memberService.selectMemberById(id);
	    if (pageOwner == null) {
	        sendAlertAndBack(response, "존재하지 않는 사용자입니다.");
	        return null;
	    }

	    model.addAttribute("pageOwner", pageOwner);
	    model.addAttribute("activeTab", type);

	    if ("following".equals(type)) {
	        model.addAttribute("followList", sqlSession.selectList("mapper.follow.getFollowingList", id));
	    } else if ("follower".equals(type)) {
	        model.addAttribute("followList", sqlSession.selectList("mapper.follow.getFollowerList", id));
	    } else {
	        sendAlertAndBack(response, "잘못된 접근입니다.");
	        return null;
	    }

	    // 타일즈 name 반환
	    return "/mypage/follow";
	}

	
	// alert 창 띄우고 뒤로가기 스크립트 출력
    private void sendAlertAndBack(HttpServletResponse response, String msg) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().write(
            "<script>alert('" + msg + "'); history.back();</script>"
        );
        response.getWriter().flush();
    }
	
}
