package com.harunichi.product.vo;


import java.sql.Timestamp;

import lombok.Data;

@Data
public class ProductVo {
	
    private int productId;
    private String productTitle;
    private int productPrice;
    private int productStatus;
    private String productCategory;
    private String productContent;
    private Timestamp productDate;
    private String productImg;
    private int productCount;
    
    private String productWriterId;
    private String writerNick; 
    private String writerProfileImg;
    
    
}
