package com.harunichi.payment.dao;

import java.util.List;

import com.harunichi.payment.vo.OrderVo;

public interface OrderDao {

    void insertOrder(OrderVo order) throws Exception;

    List<OrderVo> findByBuyerId(String buyerId) throws Exception;

    OrderVo findByImpUid(String impUid) throws Exception;
}
