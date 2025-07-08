<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product.css">

<div class="product-detail-container">
    <h2 class="product-title">작성한 거래글</h2>

    <c:choose>
        <c:when test="${empty myProducts}">
            <p style="text-align: center; margin: 40px 0;">작성한 거래글이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <div class="product-grid">
                <c:forEach var="product" items="${myProducts}">
                    <div class="product-card" onclick="location.href='${ctx}/product/view?productId=${product.productId}'">
                        <c:choose>
                            <c:when test="${not empty product.productImg}">
                                <img src="${ctx}/images/product/${product.productImg}" alt="상품 이미지" class="product-thumb" />                                
                            </c:when>
                            <c:otherwise>
                                <img src="${ctx}/images/product/no-image.png" alt="기본 이미지" class="product-thumb" />
                            </c:otherwise>
                        </c:choose>
                        <div class="product-info">
                            <div class="product-title">${product.productTitle}</div>
                            <div class="product-price">
                                <fmt:formatNumber value="${product.productPrice}" type="number" />원
                            </div>
                            <div class="product-status">
                                <c:choose>
                                    <c:when test="${product.productStatus == -1}">판매완료</c:when>
                                    <c:when test="${product.productStatus == 1}">나눔</c:when>
                                    <c:otherwise>판매</c:otherwise>
                                </c:choose>
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
