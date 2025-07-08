package com.harunichi.payment.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.harunichi.payment.vo.OrderVo;

@Repository
public class OrderDaoImpl implements OrderDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "order.";

    @Override
    public void insertOrder(OrderVo order) throws Exception {
        sqlSession.insert(NAMESPACE + "insertOrder", order);
    }

    @Override
    public List<OrderVo> findByBuyerId(String buyerId) throws Exception {
        return sqlSession.selectList(NAMESPACE + "selectOrdersByBuyerId", buyerId);
    }

    @Override
    public OrderVo findByImpUid(String impUid) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "findByImpUid", impUid);
    }
}
