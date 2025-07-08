package com.harunichi.payment.controller;

import com.harunichi.common.util.LoginCheck;
import com.harunichi.payment.service.IamportService;
import com.harunichi.payment.service.OrderService;
import com.harunichi.payment.vo.OrderVo;
import com.harunichi.product.service.ProductService;
import com.harunichi.product.vo.ProductVo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private ProductService productService;

    @Autowired
    private IamportService iamportService;

    @Autowired
    private OrderService orderService;

    // 로그인 체크 공통 메서드
    private boolean isNotLoggedIn(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return !LoginCheck.loginCheck(request.getSession(), request, response);
    }

    // 결제 폼 진입 (로그인 필요)
    @RequestMapping(value = "/form", method = RequestMethod.GET)
    public ModelAndView paymentForm(@RequestParam("productId") int productId,
                                    HttpServletRequest request,
                                    HttpServletResponse response) throws Exception {
        if (isNotLoggedIn(request, response)) return null;

        ProductVo product = productService.findById(productId);
        ModelAndView mav = new ModelAndView("/payment/form");
        mav.addObject("product", product);
        return mav;
    }

    // 결제 검증 및 주문 저장 (포트원 연동)
    @RequestMapping(value = "/verify", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> verifyAndSave(@RequestBody Map<String, String> payload,
                                             HttpServletRequest request,
                                             HttpServletResponse response) throws Exception {
        if (isNotLoggedIn(request, response)) return null;

        Map<String, Object> result = new HashMap<>();

        String impUid = payload.get("imp_uid");
        String merchantUid = payload.get("merchant_uid");
        String productName = payload.get("product_name");
        int amount = Integer.parseInt(payload.get("amount"));
        int productId = Integer.parseInt(payload.get("product_id"));

        String buyerId = (String) request.getSession().getAttribute("id");
        String buyerName = (String) request.getSession().getAttribute("name");
        if (buyerName == null) buyerName = "비회원";

        try {
            boolean isFree = amount == 0 || impUid.startsWith("FREE_");

            if (!isFree) {
                String accessToken = iamportService.getAccessToken();
                Map<String, Object> paymentData = iamportService.getPaymentData(impUid, accessToken);
                String status = (String) paymentData.get("status");

                if (!"paid".equals(status)) {
                    result.put("success", false);
                    result.put("message", "결제 상태가 유효하지 않습니다: " + status);
                    return result;
                }
            }

            OrderVo order = new OrderVo();
            order.setImpUid(impUid);
            order.setMerchantUid(merchantUid);
            order.setProductId(productId);
            order.setProductName(productName);
            order.setAmount(amount);
            order.setBuyerId(buyerId);
            order.setBuyerName(buyerName);
            order.setStatus("결제완료");

            orderService.insertOrder(order);
            productService.markAsSoldOut(productId);

            result.put("success", true);
            result.put("message", "주문이 성공적으로 저장되었습니다.");

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "예외 발생: " + e.getMessage());
        }

        return result;
    }

    // 결제 성공 페이지
    @RequestMapping(value = "/success", method = RequestMethod.GET)
    public ModelAndView success() {
        return new ModelAndView("/payment/success");
    }

    // 결제 실패 페이지
    @RequestMapping(value = "/fail", method = RequestMethod.GET)
    public ModelAndView fail(@RequestParam(value = "productId", required = false) Integer productId,
                             @RequestParam(value = "errorMessage", required = false) String errorMessage) {

        ModelAndView mav = new ModelAndView("/payment/fail");
        mav.addObject("productId", productId != null ? productId : 0);
        mav.addObject("errorMessage", errorMessage != null ? errorMessage : "결제에 실패했습니다.");
        return mav;
    }
    
    // 주문 내역 보기 (로그인 필요) tiles.xml 보내기
    @RequestMapping(value = "/orders", method = RequestMethod.GET)
    public ModelAndView orderList(HttpServletRequest request,
                                  HttpServletResponse response) throws Exception {
        if (isNotLoggedIn(request, response)) return null;

        String loginId = (String) request.getSession().getAttribute("id");
        List<OrderVo> orderList = orderService.findByBuyerId(loginId);

        ModelAndView mav = new ModelAndView("/payment/orders");
        mav.addObject("orderList", orderList);
        return mav;
    }  

    // 주문 내역 보기 (로그인 필요) jsp로 보내기
    @RequestMapping(value = "/orderList", method = RequestMethod.GET)
    public String orderListJsp(HttpServletRequest request,
                               HttpServletResponse response,
                               Model model) throws Exception {
        if (isNotLoggedIn(request, response)) return null;

        String loginId = (String) request.getSession().getAttribute("id");
        List<OrderVo> orderList = orderService.findByBuyerId(loginId);
        model.addAttribute("orderList", orderList);

        return "/payment/orderList"; 
    }


} 
