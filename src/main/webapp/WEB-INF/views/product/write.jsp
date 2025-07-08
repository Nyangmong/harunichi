<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- 공통 스타일 적용 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product.css" />

<section class="product-form-container">
    <h2 class="form-title">상품 등록</h2>

    <form action="${pageContext.request.contextPath}/product/write" method="post" enctype="multipart/form-data" class="product-form">

        <div class="form-row">
            <label for="productTitle">상품명</label>
            <input type="text" id="productTitle" name="productTitle" required />
        </div>
        
        <div class="form-row">
		    <label for="uploadFile">이미지</label>
		    <input type="file" id="uploadFile" name="uploadFile" accept="image/*" onchange="previewImage(event)" />
		    <div class="preview-container">
		        <img id="preview" src="#" alt="미리보기" style="display:none; width:100px; border:1px solid #ccc; border-radius:4px;" />
		    </div>
		</div>

        <div class="form-row">
            <label for="productPrice">가격</label>
            <input type="number" id="productPrice" name="productPrice" required />
        </div>

        <div class="form-row">
            <label for="productStatus">거래방식</label>
            <select id="productStatus" name="productStatus">
                <option value="0">판매</option>
                <option value="1">나눔</option>
            </select>
        </div>

        <div class="form-row">
            <label for="productCategory">카테고리</label>
            <select id="productCategory" name="productCategory">
                <option value="book">📚도서</option>
                <option value="electronics">💻전자제품</option>
                <option value="toy">🧸장난감</option>
                <option value="fashion">👕패션</option>
                <option value="music">💿음반</option>
                <option value="etc">🎁기타</option>
            </select>
        </div>

        <div class="form-row">
            <label for="productContent">설명</label>
            <textarea id="productContent" name="productContent" rows="5" required></textarea>
        </div>

        <div class="form-buttons">
            <button type="submit" class="btn-sky">등록하기</button>
            <button type="reset" class="btn-gray">초기화</button>
            <a href="${pageContext.request.contextPath}/product/list" class="btn-back">목록으로</a>
        </div>

    </form>
</section>

<script>
    // 이미지 미리보기를 처리하는 함수
    function previewImage(event) {
        const input = event.target; // 파일 인풋 요소
        const preview = document.getElementById('preview'); // 미리보기 이미지 요소

        // 파일이 선택된 경우
        if (input.files && input.files[0]) {
            const reader = new FileReader(); // 파일을 읽기 위한 FileReader 객체 생성

            // 파일 읽기가 완료되었을 때 실행되는 콜백 함수
            reader.onload = function (e) {
                preview.src = e.target.result;         // 읽은 이미지 데이터를 미리보기 src에 할당
                preview.style.display = 'block';       // 이미지 보이도록 설정
            };

            reader.readAsDataURL(input.files[0]); // 파일을 base64 형태로 읽음
        } else {
            // 파일이 선택되지 않았거나 삭제된 경우
            preview.src = '#';                      // 미리보기 이미지 초기화
            preview.style.display = 'none';         // 이미지 숨기기
        }
    }
</script>

