package com.harunichi.payment.service;

import java.util.List;

import com.harunichi.payment.vo.OrderVo;

public interface OrderService {

    void insertOrder(OrderVo order) throws Exception;

    List<OrderVo> findByBuyerId(String buyerId) throws Exception;

    OrderVo findByImpUid(String impUid) throws Exception;
}
