package com.harunichi.product.vo;

import lombok.Data;

@Data
public class ProductLikeVo {

    private int productId;       // 상품 ID
    private String likeUserId;   // 좋아요 누른 회원 ID

    // 아래는 조인 결과를 통해 보여줄 상품 정보
    private String productTitle;   // 상품 제목
    private int productPrice;      // 상품 가격
    private String productImg;     // 상품 이미지 경로
}
