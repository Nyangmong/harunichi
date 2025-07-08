package com.harunichi.payment.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.harunichi.payment.dao.OrderDao;
import com.harunichi.payment.vo.OrderVo;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;

    @Override
    public void insertOrder(OrderVo order) throws Exception {
        orderDao.insertOrder(order);
    }

    @Override
    public List<OrderVo> findByBuyerId(String buyerId) throws Exception {
        return orderDao.findByBuyerId(buyerId);
    }

    @Override
    public OrderVo findByImpUid(String impUid) throws Exception {
        return orderDao.findByImpUid(impUid);
    }
}
