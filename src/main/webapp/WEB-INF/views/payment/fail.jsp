<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/resources/css/payment.css" />

<div class="payment-result fail">
    <h2>❌ 결제에 실패했습니다.</h2>
    <p>${errorMessage}</p>

	<div class="buttons">
	    <a href="${ctx}/product/list" class="btn">목록으로</a>
	    <a href="${ctx}/product/view?productId=${productId}" class="btn">상품으로</a>
	</div>
</div>