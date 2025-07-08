package com.harunichi.product.dao;

import com.harunichi.product.vo.ProductVo;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface ProductDao {
    
    List<ProductVo> findAll() throws Exception;

    ProductVo findById(int productId) throws Exception;

    List<ProductVo> findPaged(int offset, int limit) throws Exception;

    void insert(ProductVo product) throws Exception;

    void update(ProductVo product) throws Exception;

    void delete(int productId) throws Exception;
    
	void markAsSoldOut(int productId) throws Exception ;

    void incrementViewCount(int productId) throws Exception;

    List<ProductVo> searchFiltered(String keyword, String category, Integer status,
            int offset, int pageSize) throws Exception;

    List<ProductVo> findOtherProducts(Map<String, Object> paramMap) throws Exception;

	List<ProductVo> selectProductsByWriterId(String writerId)throws Exception;

	List<ProductVo> selectTopViewedProducts() throws Exception;


}
