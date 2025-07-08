<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- 스타일 적용 -->
<link rel="stylesheet" href="${ctx}/resources/css/payment.css" />

<section class="mypage-wrap">
    <div class="order-container">
        <div class="order-title">🧾 내 주문 내역</div>

        <c:choose>
            <c:when test="${not empty orderList}">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>상품명</th>
                            <th>결제금액</th>
                            <th>주문상태</th>
                            <th>주문일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orderList}">
                            <tr>
                                <td>${order.merchantUid}</td>
                                <td>${order.productName}</td>
                                <td><fmt:formatNumber value="${order.amount}" type="number" /> 원</td>
                                <td>${order.status}</td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="order-none">주문 내역이 없습니다.</div>
            </c:otherwise>
        </c:choose>
        
            <div style="text-align: center; margin-top: 30px;">
		        <a href="${ctx}/mypage" class="btn btn-back">마이페이지로</a>
		    </div>        
    </div>
</section>

