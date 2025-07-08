package com.harunichi.product.controller;

import com.harunichi.product.vo.ProductVo;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.multipart.MultipartFile;

public interface ProductController {

    ModelAndView list(HttpServletRequest request, HttpServletResponse response) throws Exception;

    ModelAndView view(@RequestParam("productId") int productId,
                      HttpServletRequest request, HttpServletResponse response) throws Exception;

    ModelAndView writeForm(HttpServletRequest request, HttpServletResponse response) throws Exception;

    ModelAndView write(ProductVo product, MultipartFile uploadFile, HttpServletRequest request, HttpServletResponse response) throws Exception;
    
    ModelAndView delete(@RequestParam("productId") int productId,
                        HttpServletRequest request, HttpServletResponse response) throws Exception;
    
    ModelAndView editForm(@RequestParam("productId") int productId,
            HttpServletRequest request, HttpServletResponse response) throws Exception;

	ModelAndView edit(ProductVo product, MultipartFile uploadFile, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes rttr) throws Exception;


}
