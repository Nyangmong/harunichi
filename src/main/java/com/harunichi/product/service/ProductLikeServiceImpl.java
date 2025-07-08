package com.harunichi.product.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.harunichi.product.dao.ProductLikeDao;
import com.harunichi.product.vo.ProductLikeVo;

@Service
public class ProductLikeServiceImpl implements ProductLikeService {

    @Autowired
    private ProductLikeDao productLikeDao;

    @Override
    public boolean toggleLike(ProductLikeVo likeVo) {
        boolean alreadyLiked = productLikeDao.isLiked(likeVo);
        if (alreadyLiked) {
            productLikeDao.deleteLike(likeVo);
            return false; // 좋아요 취소
        } else {
            productLikeDao.insertLike(likeVo);
            return true; // 좋아요 추가
        }
    }

    @Override
    public boolean isLiked(int productId, String userId) {
        ProductLikeVo likeVo = new ProductLikeVo();
        likeVo.setProductId(productId);
        likeVo.setLikeUserId(userId);
        return productLikeDao.isLiked(likeVo);
    }

    @Override
    public int getLikeCount(int productId) {
        return productLikeDao.getLikeCount(productId);
    }

    @Override
    public List<ProductLikeVo> getLikedProducts(String userId) {
        return productLikeDao.selectLikedProductsByUser(userId);
    }

    @Override
    public String getProductOwnerId(int productId) {
        return productLikeDao.selectProductOwnerId(productId);
    }

}
