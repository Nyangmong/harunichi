<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 공통 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product.css" />

<section class="product-form-container">
    <h2 class="form-title">상품 수정</h2>

    <form action="${pageContext.request.contextPath}/product/edit"
          method="post" enctype="multipart/form-data" class="product-form">

        <input type="hidden" name="productId" value="${product.productId}" />

        <div class="form-row">
            <label for="productTitle">상품명</label>
            <input type="text" id="productTitle" name="productTitle"
                   value="${product.productTitle}" required />
        </div>

		<div class="form-row">
		    <label>기존 이미지</label>
		    <c:choose>
		        <c:when test="${not empty product.productImg}">
		            <img id="currentPreview" src="${pageContext.request.contextPath}/resources/images/product/${product.productImg}" width="100"
		                 style="border:1px solid #ccc; border-radius:4px;"><br>
		            <label><input type="checkbox" name="deleteImg" value="true"> 기존 이미지 삭제</label>
		        </c:when>
		        <c:otherwise>
		            <img id="currentPreview" src="${pageContext.request.contextPath}/resources/images/product/no-image.png" width="100"
		                 style="border:1px solid #ccc; border-radius:4px;">
		        </c:otherwise>
		    </c:choose>
		</div>

        <div class="form-row">
            <label>새 이미지</label>
            <input type="file" name="uploadFile" accept="image/*" onchange="previewImage(event)" />
            <div class="preview-container">
                <img id="newPreview" src="#" alt="미리보기" style="display:none;" />
            </div>
        </div>

        <div class="form-row">
            <label for="productPrice">가격</label>
            <input type="number" id="productPrice" name="productPrice"
                   value="${product.productPrice}" required />
        </div>

        <div class="form-row">
            <label for="productStatus">거래방식</label>
            <select id="productStatus" name="productStatus">
				<option value="0" <c:if test="${product.productStatus == 0}">selected</c:if>>판매</option>
				<option value="1" <c:if test="${product.productStatus == 1}">selected</c:if>>나눔</option>
            </select>
        </div>

        <div class="form-row">
            <label for="productCategory">카테고리</label>
            <select id="productCategory" name="productCategory">
                <option value="book" <c:if test="${product.productCategory eq 'book'}">selected</c:if>>📚도서</option>
                <option value="electronics" <c:if test="${product.productCategory eq 'electronics'}">selected</c:if>>💻전자제품</option>
                <option value="toy" <c:if test="${product.productCategory eq 'toy'}">selected</c:if>>🧸장난감</option>
                <option value="fashion" <c:if test="${product.productCategory eq 'fashion'}">selected</c:if>>👕패션</option>
                <option value="music" <c:if test="${product.productCategory eq 'music'}">selected</c:if>>💿음반</option>
                <option value="etc" <c:if test="${product.productCategory eq 'etc'}">selected</c:if>>🎁기타</option>
            </select>
        </div>

        <div class="form-row">
            <label for="productContent">설명</label>
            <textarea id="productContent" name="productContent" rows="5" required>${product.productContent}</textarea>
        </div>

        <div class="form-buttons">
            <button type="submit" class="btn-sky">수정</button>
            <a href="${pageContext.request.contextPath}/product/list" class="btn-back">목록으로</a>
        </div>

    </form>
</section>

<script>
    function previewImage(event) {
        const input = event.target;
        const preview = document.getElementById('newPreview');
        const current = document.getElementById('currentPreview');

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
                if (current) current.style.display = 'none';
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.src = '#';
            preview.style.display = 'none';
            if (current) current.style.display = 'block';
        }
    }
</script>
