package com.harunichi.product.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.harunichi.common.util.FileUploadUtil;
import com.harunichi.common.util.LoginCheck;
import com.harunichi.product.service.ProductService;
import com.harunichi.product.vo.ProductVo;

@Controller("productController")
@RequestMapping("/product")
public class ProductControllerImpl implements ProductController {

    @Autowired
    private ProductService productService;
    
    @Autowired
    private ServletContext servletContext;

    @PostConstruct
    public void init() {
        copyDummyProductImagesOnStartup(servletContext);
    }

    // 상품 이미지 복사 메서드 추가
    public void copyDummyProductImagesOnStartup(ServletContext context) {
        String sourceDirPath = context.getRealPath("/resources/images/product");
        String targetDirPath = "C:/harunichi/images/product";

        File sourceDir = new File(sourceDirPath);
        File targetDir = new File(targetDirPath);

        if (!targetDir.exists()) {
            targetDir.mkdirs();
        }

        File[] files = sourceDir.listFiles();
        if (files != null) {
            for (File file : files) {
                System.out.println("상품 더미 이미지 복사 시도 파일: " + file.getName());
                if (file.isFile()) {
                    File targetFile = new File(targetDir, file.getName());
                    try {
                        Files.copy(file.toPath(), targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        System.out.println("복사됨: " + file.getName());
                    } catch (IOException e) {
                        System.err.println("상품 복사 실패: " + file.getName());
                        e.printStackTrace();
                    }
                }
            }
        }
        System.out.println("상품 복사 소스 경로: " + sourceDirPath);
        System.out.println("상품 복사 대상 경로: " + targetDirPath);
    }

    
    // 계정 로그인 체크
    private boolean isNotLoggedIn(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return !LoginCheck.loginCheck(request.getSession(), request, response);
    }

    // 상품 목록 페이지 진입
    @Override
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView list(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("/product/list");
    }

    // 상품 목록 Ajax 페이징 처리
    @RequestMapping(value = "/moreList", method = RequestMethod.GET)
    @ResponseBody
    public List<Map<String, Object>> moreList(@RequestParam("page") int page) throws Exception {
        int pageSize = 8;
        int offset = (page - 1) * pageSize;
        List<ProductVo> products = productService.findPaged(offset, pageSize);

        List<Map<String, Object>> result = new ArrayList<>();
        for (ProductVo product : products) {
            Map<String, Object> map = new HashMap<>();
            map.put("productId", product.getProductId());
            map.put("productTitle", product.getProductTitle());
            map.put("productPrice", product.getProductPrice());
            map.put("productImg", product.getProductImg());
            map.put("productStatus", product.getProductStatus());
            map.put("productCategory", product.getProductCategory());
            map.put("productCount", product.getProductCount());
            map.put("writerNick", product.getWriterNick());
            map.put("writerProfileImg", product.getWriterProfileImg());
            result.add(map);
        }
        return result;
    }

    // 상품 상세보기
    @Override
    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public ModelAndView view(@RequestParam("productId") int productId,
                             HttpServletRequest request,
                             HttpServletResponse response) throws Exception {

        productService.incrementViewCount(productId);

        ProductVo product = productService.findById(productId);
        if (product == null) {
            return new ModelAndView("redirect:/product/list");
        }

        ModelAndView mav = new ModelAndView("/product/view");
        mav.addObject("product", product);
        return mav;
    }

    // 상품 등록 포맷 진입
    @Override
    @RequestMapping(value = "/write", method = RequestMethod.GET)
    public ModelAndView writeForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (isNotLoggedIn(request, response)) return null;
        return new ModelAndView("/product/write");
    }

    // 상품 등록 처리
    @Override
    @RequestMapping(value = "/write", method = RequestMethod.POST)
    public ModelAndView write(ProductVo product,
                              @RequestParam("uploadFile") MultipartFile uploadFile,
                              HttpServletRequest request,
                              HttpServletResponse response) throws Exception {
        if (isNotLoggedIn(request, response)) return null;
        String loginId = (String) request.getSession().getAttribute("id");
        product.setProductWriterId(loginId);

        if (!uploadFile.isEmpty()) {
        	// 외부 경로에 저장
        	String uploadDir = "C:/harunichi/images/product"; // 팀원과 동일한 방식
            String savedFile = FileUploadUtil.uploadFile(uploadFile, uploadDir);
            product.setProductImg(savedFile);  // 경로 제외, 파일명만 저장

        }

        productService.insert(product);
        return new ModelAndView("redirect:/product/list");
    }

    // 상품 삭제
    @Override
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public ModelAndView delete(@RequestParam("productId") int productId,
                               HttpServletRequest request,
                               HttpServletResponse response) throws Exception {
        if (isNotLoggedIn(request, response)) return null;
        String loginId = (String) request.getSession().getAttribute("id");
        ProductVo product = productService.findById(productId);

        boolean isWriter = product != null && product.getProductWriterId().equals(loginId);
        boolean isAdmin = "admin".equalsIgnoreCase(loginId);

        if (!(isWriter || isAdmin)) {
            return new ModelAndView("redirect:/product/view?productId=" + productId);
        }

        if (product != null) {
            String productImgPath = product.getProductImg();
            if (productImgPath != null && !productImgPath.trim().isEmpty()) {
                String uploadDir = request.getSession().getServletContext().getRealPath("/resources/images/product");
                String fileName = new File(productImgPath).getName();
                FileUploadUtil.deleteFile(uploadDir, fileName);
            }
            productService.delete(productId);
        }
        return new ModelAndView("redirect:/product/list");
    }

    // 상품 수정 포맷 진입
    @Override
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public ModelAndView editForm(@RequestParam("productId") int productId,
                                 HttpServletRequest request,
                                 HttpServletResponse response) throws Exception {
        if (isNotLoggedIn(request, response)) return null;
        ProductVo product = productService.findById(productId);
        ModelAndView mav = new ModelAndView("/product/edit");
        mav.addObject("product", product);
        return mav;
    }

    // 상품 수정 처리
    @Override
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    public ModelAndView edit(ProductVo product,
                             @RequestParam(value = "uploadFile", required = false) MultipartFile uploadFile,
                             HttpServletRequest request,
                             HttpServletResponse response,
                             RedirectAttributes rttr) throws Exception {
        if (isNotLoggedIn(request, response)) return null;
        String loginId = (String) request.getSession().getAttribute("id");

        ProductVo original = productService.findById(product.getProductId());

        if (original == null) {
            rttr.addFlashAttribute("msg", "존재하지 않는 상품입니다.");
            return new ModelAndView("redirect:/product/list");
        }

        boolean isWriter = original != null && original.getProductWriterId().equals(loginId);
        boolean isAdmin = "admin".equalsIgnoreCase(loginId);

        if (!(isWriter || isAdmin)) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return new ModelAndView("redirect:/product/view?productId=" + product.getProductId());
        }

        String uploadDir = request.getSession().getServletContext().getRealPath("/resources/images/product");
        String deleteImg = request.getParameter("deleteImg");
        boolean isDeleteRequested = (deleteImg != null);

        if (isDeleteRequested && original.getProductImg() != null) {
            String fileName = new File(original.getProductImg()).getName();
            FileUploadUtil.deleteFile(uploadDir, fileName);
            product.setProductImg(null);
        } else {
            product.setProductImg(original.getProductImg());
        }

        if (uploadFile != null && !uploadFile.isEmpty()) {
            if (original.getProductImg() != null) {
                String fileName = new File(original.getProductImg()).getName();
                FileUploadUtil.deleteFile(uploadDir, fileName);
            }
            String savedFile = FileUploadUtil.uploadFile(uploadFile, uploadDir);
            product.setProductImg("/resources/images/product/" + savedFile);
        }

        product.setProductWriterId(original.getProductWriterId());
        productService.update(product);

        rttr.addFlashAttribute("msg", "상품이 수정되었습니다.");
        return new ModelAndView("redirect:/product/view?productId=" + product.getProductId());
    }

    // 내가 작성한 거래 목록 조회
//    @RequestMapping(value = "/myList", method = RequestMethod.GET)
//    public ModelAndView myProductList(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        if (isNotLoggedIn(request, response)) return null;
//
//        String loginId = (String) request.getSession().getAttribute("id");
//        List<ProductVo> myProducts = productService.findProductsByWriterId(loginId);
//
//        ModelAndView mav = new ModelAndView("/product/myList");
//        mav.addObject("myProducts", myProducts);
//        return mav;
//    }
    
    // 마이페이지가 상대방페이지일 경우
    @RequestMapping(value = "/myList", method = RequestMethod.GET)
    public ModelAndView myProductList(@RequestParam("id") String userId,
                                      HttpServletRequest request,
                                      HttpServletResponse response) throws Exception {
        List<ProductVo> myProducts = productService.findProductsByWriterId(userId);

        ModelAndView mav = new ModelAndView("/product/myList");
        mav.addObject("myProducts", myProducts);
        return mav;
    }

    // 검색/필터링 Ajax 상품 목록 조회
    @RequestMapping(value = "/search", method = RequestMethod.GET)
    @ResponseBody
    public List<Map<String, Object>> searchList(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "page", defaultValue = "1") int page) throws Exception {

        int pageSize = 8;
        int offset = (page - 1) * pageSize;

        Integer statusVal = null;
        if (status != null && !status.isEmpty()) {
            try {
                statusVal = Integer.valueOf(status);
            } catch (NumberFormatException e) {
                statusVal = null;
            }
        }

        List<ProductVo> products = productService.searchFiltered(keyword, category, statusVal, offset, pageSize);

        List<Map<String, Object>> result = new ArrayList<>();
        for (ProductVo product : products) {
            Map<String, Object> map = new HashMap<>();
            map.put("productId", product.getProductId());
            map.put("productTitle", product.getProductTitle());
            map.put("productPrice", product.getProductPrice());
            map.put("productImg", product.getProductImg());
            map.put("productStatus", product.getProductStatus());
            map.put("productCount", product.getProductCount());
            map.put("writerNick", product.getWriterNick());
            map.put("writerProfileImg", product.getWriterProfileImg());
            result.add(map);
        }
        return result;
    }

    // 작상자의 기타 거래 조회
    @RequestMapping(value = "/other", method = RequestMethod.GET)
    @ResponseBody
    public List<Map<String, Object>> findOtherProducts(
            @RequestParam String writerId,
            @RequestParam int productId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "4") int size) throws Exception {

        int offset = (page - 1) * size;
        List<ProductVo> products = productService.findOtherProducts(writerId, productId, offset, size);

        List<Map<String, Object>> result = new ArrayList<>();
        for (ProductVo product : products) {
            Map<String, Object> map = new HashMap<>();
            map.put("productId", product.getProductId());
            map.put("productTitle", product.getProductTitle());
            map.put("productPrice", product.getProductPrice());
            map.put("productImg", product.getProductImg());
            map.put("writerNick", product.getWriterNick());
            map.put("writerProfileImg", product.getWriterProfileImg());
            result.add(map);
        }
        return result;
    }
    
    // best5 보여주기
    @RequestMapping(value = "/topViewed", method = RequestMethod.GET)
    public String topViewedProducts(Model model) throws Exception {
        List<ProductVo> topProducts = productService.getTopViewedProducts();
        model.addAttribute("topProducts", topProducts);
        return "product/best5";  // best5.jsp forward
    }

    
}
