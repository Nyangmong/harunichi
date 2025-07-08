package com.harunichi.product.service;

import java.util.List;

import com.harunichi.product.vo.ProductLikeVo;

public interface ProductLikeService {

    // 좋아요 토글 (추가 or 취소)
    boolean toggleLike(ProductLikeVo likeVo);

    // 특정 사용자가 좋아요 눌렀는지 여부
    boolean isLiked(int productId, String userId);

    // 특정 상품의 좋아요 수 조회
    int getLikeCount(int productId);

    // 내가 좋아요한 상품 목록
	List<ProductLikeVo> getLikedProducts(String userId);

	// 내 글에는 좋아요가 되면 안 됨
	String getProductOwnerId(int productId);

}
