package com.harunichi.payment.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class OrderVo {

	private String impUid;
	private String merchantUid;
	private int productId;
	private String productName;
	private int amount;
	private String buyerId;
	private String buyerName;
	private String status;
	private Timestamp orderDate;

}
