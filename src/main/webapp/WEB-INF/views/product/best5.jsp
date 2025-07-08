<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
.popular-box {
    margin: 40px auto;
    max-width: 1000px;
    text-align: center;
}

.popular-box h3 {
    font-size: 20px;
    margin-bottom: 16px;
    font-weight: bold;
    color: #333;
}

.popular-row {
    display: flex;
    justify-content: center;
    gap: 16px;
    flex-wrap: nowrap;
}

.popular-card {
    width: 180px;
    border: 1px solid #ddd;
    border-radius: 10px;
    background: #fff;
    padding: 10px;
    cursor: pointer;
    transition: 0.2s ease;
}

.popular-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 10px rgba(163, 218, 255, 0.3);
}

.popular-card img {
    width: 100%;
    height: 120px;
    object-fit: cover;
    border-radius: 6px;
}

.popular-title {
    font-size: 14px;
    font-weight: bold;
    margin-top: 8px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.popular-price {
    font-size: 13px;
    color: #e60000;
    margin-top: 4px;
}
</style>

<div class="popular-box">
    <h3>🔥 인기 상품 Top 5</h3>
    <div class="popular-row">
		<c:forEach var="item" items="${topProducts}">
		  <div class="popular-card" onclick="location.href='${ctx}/product/view?productId=${item.productId}'">
		    <c:choose>
				<c:when test="${not empty item.productImg}">
				  <img src="${ctx}/images/product/${item.productImg}" alt="상품 이미지" />
				</c:when>
				<c:otherwise>
				  <img src="${ctx}/images/product/no-image.png" alt="기본 이미지" />
				</c:otherwise>
		    </c:choose>
		    <div class="popular-title">${item.productTitle}</div>
		    <div class="popular-price">
		      <fmt:formatNumber value="${item.productPrice}" type="number" groupingUsed="true" />원
		    </div>
		  </div>
		</c:forEach>
    </div>
</div>
