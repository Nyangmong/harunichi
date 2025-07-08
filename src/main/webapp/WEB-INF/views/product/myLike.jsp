<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- 스타일 적용 -->
<link rel="stylesheet" href="${ctx}/resources/css/product.css" />

<div class="product-detail-container">
    <h2 class="product-title">좋아요한 상품 목록</h2>

    <c:choose>
        <c:when test="${empty likedProducts}">
            <p style="text-align: center; margin: 30px 0;">좋아요한 상품이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <div class="product-grid">
                <c:forEach var="item" items="${likedProducts}">
				    <div class="product-card" onclick="location.href='${ctx}/product/view?productId=${item.productId}'">
				        <c:choose>
				            <c:when test="${not empty item.productImg}">
				                <img src="${ctx}/images/product/${item.productImg}" alt="${item.productTitle}" class="product-thumb" />
				            </c:when>
				            <c:otherwise>
				                <img src="${ctx}/images/product/no-image.png" alt="기본 이미지" class="product-thumb" />
				            </c:otherwise>
				        </c:choose>
				        <div class="product-info">
				            <div class="product-title">${item.productTitle}</div>
				            <div class="product-price">
				                <fmt:formatNumber value="${item.productPrice}" type="number" groupingUsed="true" />원
				            </div>
				        </div>
				    </div>
				</c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <div style="text-align: center; margin-top: 30px;">
        <a href="${ctx}/mypage" class="btn btn-list">마이페이지로</a>
    </div>
</div>
