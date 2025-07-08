<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- PortOne JS SDK -->
<script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<link rel="stylesheet" href="${ctx}/resources/css/payment.css" />

<div class="payment-wrapper">
    <div class="payment-box">
        <h2 class="payment-title">💳 ${product.productTitle} 결제</h2>

        <p class="payment-price">
            가격: <strong><fmt:formatNumber value="${product.productPrice}" type="number" /> 원</strong>
        </p>

        <div class="payment-option">
            <label for="pgSelect">결제 수단 선택</label>
            <select id="pgSelect">
                <option value="html5_inicis">KG이니시스</option>
                <option value="eximbay">엑심베이(Eximbay)</option>
            </select>
        </div>

        <button class="btn-pay"
            onclick="requestPayment(
              '${product.productId}', 
              '${product.productTitle}', 
              '${product.productPrice}',
              '${loginMember.email}',
              '${loginMember.nick}',
              '${loginMember.tel}',
              '${loginMember.address}',
              '${loginMember.postcode}'
            )">
            결제하기
        </button>

        <a href="${ctx}/product/list" class="btn-back">상품 목록으로</a>
    </div>
</div>

<script>
    const IMP = window.IMP;
    IMP.init("imp78561661"); // 포트원 상점 아이디

    function requestPayment(productId, productName, amount, buyerEmail, buyerName, buyerTel, buyerAddr, buyerPostcode) {
        const selectedPg = document.getElementById("pgSelect").value;
        const cleanName = productName.replace(/[^\w\sㄱ-ㅎ가-힣]/g, '') || "상품명";

        // 가격이 0원인 경우 포트원 생략하고 바로 주문 처리
        if (Number(amount) === 0) {
            if (!confirm("이 상품은 무료 나눔입니다. 결제 없이 바로 구입 요청하시겠습니까?")) return;

            $.ajax({
                url: "${ctx}/payment/verify",
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify({
                    imp_uid: "FREE_" + new Date().getTime(),
                    merchant_uid: "FREE_" + new Date().getTime(),
                    product_id: productId,
                    product_name: cleanName,
                    amount: 0
                }),
                success: function (res) {
                    if (res.success) {
                        location.href = "${ctx}/payment/success";
                    } else {
                        location.href = "${ctx}/payment/fail?productId=" + productId + "&errorMessage=" + encodeURIComponent(res.message || '무료 주문 처리 실패');
                    }
                },
                error: function () {
                    location.href = "${ctx}/payment/fail?productId=" + productId + "&errorMessage=" + encodeURIComponent('무료 주문 처리 중 서버 오류');
                }
            });

            return;
        }

        // 유료 상품 결제
        IMP.request_pay({
            pg: selectedPg,
            pay_method: "card",
            merchant_uid: "order_" + new Date().getTime(),
            name: cleanName,
            amount: Number(amount),
            buyer_email: buyerEmail || "example@example.com",
            buyer_name: buyerName || "회원",
            buyer_tel: buyerTel || "010-0000-0000",
            buyer_addr: buyerAddr || "주소 없음",
            buyer_postcode: buyerPostcode || "00000"
        }, function (rsp) {
            if (rsp.success) {
                $.ajax({
                    url: "${ctx}/payment/verify",
                    method: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        imp_uid: rsp.imp_uid,
                        merchant_uid: rsp.merchant_uid,
                        product_id: productId,
                        product_name: cleanName,
                        amount: amount
                    }),
                    success: function (res) {
                        if (res.success) {
                            location.href = "${ctx}/payment/success";
                        } else {
                            location.href = "${ctx}/payment/fail?productId=" + productId + "&errorMessage=" + encodeURIComponent(res.message || '결제 검증 실패');
                        }
                    },
                    error: function () {
                        location.href = "${ctx}/payment/fail?productId=" + productId + "&errorMessage=" + encodeURIComponent('서버 오류로 인해 결제 검증 실패');
                    }
                });
            } else {
                location.href = "${ctx}/payment/fail?productId=" + productId + "&errorMessage=" + encodeURIComponent('사용자 결제 취소 또는 실패');
            }
        });
    }
</script>
