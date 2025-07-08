package com.harunichi.product.dao;

import com.harunichi.product.vo.ProductVo;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("productDao")
public class ProductDaoImpl implements ProductDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "mapper.product.";

    @Override
    public List<ProductVo> findAll() throws Exception {
        return sqlSession.selectList(NAMESPACE + "findAll");
    }

    @Override
    public ProductVo findById(int productId) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "findById", productId);
    }

    @Override
    public List<ProductVo> findPaged(int offset, int limit) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("limit", limit);
        return sqlSession.selectList(NAMESPACE + "findPaged", params);
    }

    @Override
    public void insert(ProductVo product) throws Exception {
        sqlSession.insert(NAMESPACE + "insert", product);
    }

    @Override
    public void update(ProductVo product) throws Exception {
        sqlSession.update(NAMESPACE + "update", product);
    }

    @Override
    public void delete(int productId) throws Exception {
        sqlSession.delete(NAMESPACE + "delete", productId);
    }
    
	@Override
	public void markAsSoldOut(int productId) throws Exception {
		sqlSession.update(NAMESPACE+"markAsSoldOut",productId);		
	}

    @Override
    public void incrementViewCount(int productId) throws Exception {
        sqlSession.update(NAMESPACE + "incrementViewCount", productId);
    }

    @Override
    public List<ProductVo> searchFiltered(String keyword, String category, Integer status, int offset, int limit) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("category", category);
        params.put("status", status);
        params.put("offset", offset);
        params.put("limit", limit);
        return sqlSession.selectList(NAMESPACE + "searchFiltered", params);
    }

    @Override
    public List<ProductVo> findOtherProducts(Map<String, Object> paramMap) throws Exception {
        return sqlSession.selectList(NAMESPACE + "findOtherByWriter", paramMap);
    }
    
    @Override
    public List<ProductVo> selectProductsByWriterId(String writerId) throws Exception {
        return sqlSession.selectList(NAMESPACE + "selectProductsByWriterId", writerId);
    }
    
    @Override
    public List<ProductVo> selectTopViewedProducts() throws Exception {
        return sqlSession.selectList(NAMESPACE + "selectTopViewedProducts");
    }


}
