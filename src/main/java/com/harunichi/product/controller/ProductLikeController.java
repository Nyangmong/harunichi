package com.harunichi.product.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.harunichi.common.util.LoginCheck;
import com.harunichi.product.service.ProductLikeService;
import com.harunichi.product.vo.ProductLikeVo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/like")
public class ProductLikeController {

    @Autowired
    private ProductLikeService productLikeService;

    // 로그인 체크 공통 메서드
    private boolean isNotLoggedIn(HttpServletRequest request, HttpServletResponse response) {
        try {
            return !LoginCheck.loginCheck(request.getSession(), request, response);
        } catch (Exception e) {
            return true;
        }
    }

    @RequestMapping(value = "/toggle", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> toggleLike(@RequestBody ProductLikeVo likeVo,
                                          HttpServletRequest request,
                                          HttpServletResponse response) {
        Map<String, Object> result = new HashMap<>();

        if (isNotLoggedIn(request, response)) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        String userId = (String) request.getSession().getAttribute("id");
        likeVo.setLikeUserId(userId);

        // 본인 글에 좋아요 방지
        String productOwnerId = productLikeService.getProductOwnerId(likeVo.getProductId());
        if (userId.equals(productOwnerId)) {
            result.put("success", false);
            result.put("message", "본인 글에는 좋아요를 할 수 없습니다.");
            return result;
        }

        boolean liked = productLikeService.toggleLike(likeVo);
        int likeCount = productLikeService.getLikeCount(likeVo.getProductId());

        result.put("success", true);
        result.put("liked", liked);
        result.put("likeCount", likeCount);
        return result;
    }

    @RequestMapping(value = "/count", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> getLikeCount(@RequestParam int productId) {
        int count = productLikeService.getLikeCount(productId);
        Map<String, Object> result = new HashMap<>();
        result.put("likeCount", count);
        return result;
    }

    @RequestMapping(value = "/status", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> isLiked(@RequestParam int productId,
                                       HttpServletRequest request,
                                       HttpServletResponse response) {
        Map<String, Object> result = new HashMap<>();

        if (isNotLoggedIn(request, response)) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        String userId = (String) request.getSession().getAttribute("id");
        boolean liked = productLikeService.isLiked(productId, userId);
        int likeCount = productLikeService.getLikeCount(productId);

        result.put("success", true);
        result.put("liked", liked);
        result.put("likeCount", likeCount);
        return result;
    }

//    @RequestMapping(value = "/myLike", method = RequestMethod.GET)
//    public ModelAndView likedProductList(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        String loginId = (String) request.getSession().getAttribute("id");
//        if (loginId == null || loginId.trim().isEmpty()) {
//            return new ModelAndView("redirect:/member/loginpage.do");
//        }
//
//        List<ProductLikeVo> likedProducts = productLikeService.getLikedProducts(loginId);
//        ModelAndView mav = new ModelAndView("/product/myLike");
//        mav.addObject("likedProducts", likedProducts);
//        return mav;
//    }
    
    @RequestMapping(value = "/myLike", method = RequestMethod.GET)
    public ModelAndView likedProductList(@RequestParam("id") String userId,
                                         HttpServletRequest request,
                                         HttpServletResponse response) throws Exception {
        List<ProductLikeVo> likedProducts = productLikeService.getLikedProducts(userId);

        ModelAndView mav = new ModelAndView("/product/myLike");
        mav.addObject("likedProducts", likedProducts);
        return mav;
    }
} 
