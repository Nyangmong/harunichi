package com.harunichi.product.service;

import com.harunichi.product.dao.ProductDao;
import com.harunichi.product.vo.ProductVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("productService")
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductDao productDao;

    @Override
    public List<ProductVo> findAll() throws Exception {
        return productDao.findAll();
    }

    @Override
    public ProductVo findById(int productId) throws Exception {
        return productDao.findById(productId);
    }
    
    @Override
    public List<ProductVo> findPaged(int offset, int pageSize) throws Exception {
        return productDao.findPaged(offset, pageSize);
    }
    
    @Override
    public void insert(ProductVo product) throws Exception {
        productDao.insert(product);
    }

    @Override
    public void update(ProductVo product) throws Exception {
        productDao.update(product);
    }

    @Override
    public void delete(int productId) throws Exception {
        productDao.delete(productId);
    }
    @Override
    public void markAsSoldOut(int productId) throws Exception {
        productDao.markAsSoldOut(productId);
    }

    @Override
    public void incrementViewCount(int productId) throws Exception {
        productDao.incrementViewCount(productId);
    }

    @Override
    public List<ProductVo> findOtherProducts(String writerId, int productId, int offset, int size) throws Exception {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("writerId", writerId);
        paramMap.put("productId", productId);
        paramMap.put("offset", offset);
        paramMap.put("size", size);

        return productDao.findOtherProducts(paramMap);
    }

	@Override
	public List<ProductVo> searchFiltered(String keyword, String category, Integer status, int offset, int pageSize) throws Exception {
		 return productDao.searchFiltered(keyword, category, status, offset, pageSize);
	}
	
	@Override
	public List<ProductVo> findProductsByWriterId(String writerId) throws Exception {
	    return productDao.selectProductsByWriterId(writerId);
	}

	@Override
	public List<ProductVo> getTopViewedProducts() throws Exception {
	    return productDao.selectTopViewedProducts();
	}

    
}
