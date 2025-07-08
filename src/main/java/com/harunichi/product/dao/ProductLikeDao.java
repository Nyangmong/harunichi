package com.harunichi.product.dao;

import java.util.List;

import com.harunichi.product.vo.ProductLikeVo;

public interface ProductLikeDao {

    // 현재 사용자가 특정 상품을 좋아요 눌렀는지 확인
    boolean isLiked(ProductLikeVo likeVo);

    // 좋아요 추가
    void insertLike(ProductLikeVo likeVo);

    // 좋아요 취소
    void deleteLike(ProductLikeVo likeVo);

    // 해당 상품의 총 좋아요 수 조회
    int getLikeCount(int productId);

    // 내가 좋아요한 상품 목록
    List<ProductLikeVo> selectLikedProductsByUser(String userId);

	// 내 글에는 좋아요가 되면 안 됨
	String selectProductOwnerId(int productId);

}
