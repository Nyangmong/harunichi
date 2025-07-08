package com.harunichi.admin.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.harunichi.follow.service.FollowService;
import com.harunichi.member.service.MemberService;
import com.harunichi.member.vo.MemberVo;

@Controller
@RequestMapping("/admin/member")
public class AdminMemberController {
    
	private static final Logger logger = LoggerFactory.getLogger(AdminMemberController.class);

    @Autowired
    private MemberService memberService;

    @Autowired
    private FollowService followService;

    // 전체 회원 조회
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String showMemberList(HttpServletRequest request, Model model,
            					 @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
            					 @RequestParam(value = "searchType", defaultValue = "all") String searchType,
            					 @RequestParam(value = "page", defaultValue = "1") int page) {
    		model.addAttribute("currentUri", request.getRequestURI());
    	    model.addAttribute("activeTab", "member");

    	    Map<String, Object> result = memberService.getMemberList(searchKeyword, searchType, page);
    	    model.addAttribute("result", result);
    	    model.addAttribute("searchKeyword", searchKeyword);
    	    model.addAttribute("searchType", searchType);

    	    return "/admin/member";
    }
    
    // 팔로우 조회
    @RequestMapping(value = "/follow", method = RequestMethod.GET)
    public String showFollowList(HttpServletRequest request, Model model,
                                 @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                 @RequestParam(value = "page", defaultValue = "1") int page) {
        model.addAttribute("currentUri", request.getRequestURI());
        model.addAttribute("activeTab", "follow");

        Map<String, Object> result = followService.getFollowList(searchKeyword, page);
        model.addAttribute("result", result);
        model.addAttribute("searchKeyword", searchKeyword);

        return "/admin/member";
    }
    
    //수정 저장 삭제
    @RequestMapping(value = "/saveOrDelete.do", method = RequestMethod.POST)
    public String saveOrDelete(
        @ModelAttribute("members") MemberListWrapper membersWrapper,
        @RequestParam("action") String action,
        @RequestParam(value = "selectedIds", required = false) String[] selectedIds,
        @RequestParam(value = "resetId", required = false) String resetId,
        RedirectAttributes redirectAttributes) {

        try {
            if ("update".equals(action)) {
                for (MemberVo member : membersWrapper.getMembers()) {
                    memberService.updateMember(member);
                }
                redirectAttributes.addFlashAttribute("message", "회원 정보가 수정되었습니다.");

            } else if ("delete".equals(action)) {
                if (selectedIds != null) {
                    for (String id : selectedIds) {
                        memberService.deleteMember(id);
                    }
                    redirectAttributes.addFlashAttribute("message", "회원이 삭제되었습니다.");
                } else {
                    redirectAttributes.addFlashAttribute("message", "삭제할 회원을 선택하세요.");
                }

            } else if ("resetProfileImg".equals(action) && resetId != null) {
                memberService.resetProfileImg(resetId);
                redirectAttributes.addFlashAttribute("message", "프로필 이미지가 기본 이미지로 초기화되었습니다.");
            }

        } catch (Exception e) {
            logger.error("회원 관리 처리 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("message", "처리 중 오류가 발생했습니다.");
        }

        return "redirect:/admin/member";
    }
    
    //팔로우 삭제 기능 (어드민)
    @RequestMapping(value = "/deleteFollows.do", method = RequestMethod.POST)
    public String deleteFollows(
        @RequestParam(value = "selectedFollows", required = false) String[] selectedFollows,
        RedirectAttributes redirectAttributes) {
        
        logger.debug("팔로우 삭제 요청 selectedFollows: {}", Arrays.toString(selectedFollows));

        if (selectedFollows != null && selectedFollows.length > 0) {
            for (String pair : selectedFollows) {
                if (pair != null && !pair.trim().isEmpty()) {
                    String[] ids = pair.split("::");
                    if (ids.length == 2) {
                        String followerId = ids[0].trim();
                        String followeeId = ids[1].trim();
                        logger.debug("삭제 요청: followerId = [{}], followeeId = [{}]", followerId, followeeId);
                        try {
                            followService.deleteFollowAdmin(followerId, followeeId);
                        } catch (Exception e) {
                            logger.error("팔로우 삭제 중 오류", e);
                        }
                    } else {
                        logger.warn("잘못된 pair 값: {}", pair);
                    }
                }
            }
            redirectAttributes.addFlashAttribute("message", "팔로우 관계가 삭제되었습니다.");
        } else {
            logger.debug("삭제할 팔로우 관계가 선택되지 않았습니다.");
            redirectAttributes.addFlashAttribute("message", "삭제할 팔로우 관계를 선택하세요.");
        }

        return "redirect:/admin/member/follow";
    }
    
    public static class MemberListWrapper {
        private List<MemberVo> members;

        public List<MemberVo> getMembers() {
            return members;
        }

        public void setMembers(List<MemberVo> members) {
            this.members = members;
        }
    }
}
