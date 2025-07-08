<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<div class="form-head">게시물 작성</div>
<form action="${contextPath}/board/post" method="post" enctype="multipart/form-data" id="postForm" class="post-form">
  <div class="form-container"> 
     <div class="form-group select-area">     
      <div class="form-input">
        <select name="boardCate" class="category-select">
          <option value="" disabled selected>주제를 선택해주세요</option>
          <option value="생활정보">생활정보</option>
          <option value="맛집, 카페">맛집, 카페</option>
          <option value="일상">일상</option>
          <option value="찾습니다">찾습니다</option>
          <option value="건강, 운동">건강, 운동</option>
          <option value="육아, 교육">육아, 교육</option>
        </select>        
        <!--
        디비에서 가져올 때
        <select name="boardCate" class="category-select">
          <c:forEach var="category" items="${categoryList}">
            <option value="${category.categoryId}">${category.categoryName}</option>
          </c:forEach>
        </select>
        -->
      </div>
    </div>
    <div class="form-group text-area">    
      <div class="form-input">
        <textarea name="boardCont" class="content-textarea"></textarea>
      </div>
    </div> 
    <div id="previewArea" class="image-preview-area"></div>  
     
   <div class="form-group">      
	  <div class="form-input">
	    <label for="imageInput" class="file-upload-label">
	     <img width="25" height="25" src="https://img.icons8.com/fluency-systems-regular/48/image--v1.png" alt="image--v1"/>
	    </label>
	    <input type="file" name="imageFiles" accept="image/*" multiple id="imageInput" class="file-input">
	  </div>
	    <div class="submit-btn">
	      <button type="submit" class="submit-button">게시하기</button>
	    </div>
	</div>  
  </div>
</form>


<script>
$(document).ready(function() {
    // 파일 선택 시 유효성 검사
    $('input[name="imageFiles"]').change(function() {
        validateFileType(this);
    });
    
    // 폼 제출 시 유효성 검사
    $('#postForm').submit(function(event) {
        console.log("폼 제출 이벤트 발생");
        if(!validateForm()) {
            console.log("validateForm 실패. 폼 제출 막기.");
            event.preventDefault();
        } else {
            console.log("validateForm 통과. 폼 제출 진행.");
        }
    });
});

// 파일 타입 및 개수 유효성 검사 함수
function validateFileType(input) {
    const files = input.files; // 선택된 파일 목록 가져오기
    const maxFiles = 4; // 허용되는 최대 파일 개수
    
    if(files.length === 0) {
        console.log("선택된 파일 없음");
        return true; // 파일 선택이 안된 경우는 유효성 통과로 간주
    }
    
    console.log("파일 유효성 검사 시작");
    
    // 1. 파일 개수 확인
    if(files.length > maxFiles) {
        alert('이미지는 최대 ' + maxFiles + '개까지 업로드할 수 있습니다.');
        input.value = '';
        console.log("파일 개수 초과. 파일 선택 초기화.");
        return false; // 유효성 검사 실패
    }
    
    // 2. 파일 타입 검사 (파일 개수 검사 통과 후 실행)
    console.log("파일 개수 유효성 검사 통과.");
    for(let i = 0; i < files.length; i++) {
        const file = files[i];
        console.log("검사 중 파일:", file.name, "타입:", file.type);
        
        // 파일 타입이 'image/'로 시작하는지 확인
        if(!file.type.startsWith('image/')) {
            alert('이미지 파일만 업로드할 수 있습니다.\n잘못된 파일: ' + file.name);
            input.value = ''; // 파일 선택 필드 초기화 (선택된 모든 파일 제거)
            console.log("유효하지 않은 파일 타입 감지. 파일 선택 초기화.");
            return false; // 유효성 검사 실패
        }
    }
    
    console.log("모든 파일 유효성 검사 통과.");
    return true; // 모든 유효성 검사 통과
}

// 필수 필드 유효성 검사 함수
function validateForm() {
    // 작성자는 세션에서 가져오므로 검사하지 않음
    const content = $('textarea[name="boardCont"]').val().trim(); // 내용 값 가져오기 및 공백 제거
    const category = $('select[name="boardCate"]').val(); // 카테고리 선택 값 가져오기
    
    if(content === '') {
        alert('내용을 입력해주세요.'); // <-- 경고 알림
        $('textarea[name="boardCont"]').focus(); // 해당 필드로 포커스 이동
        return false; // 유효성 검사 실패
    }
    
    if(category === '' || category === null) {
        alert('카테고리를 선택해주세요.'); // <-- 경고 알림
        $('select[name="boardCate"]').focus(); // 해당 필드로 포커스 이동
        return false; // 유효성 검사 실패
    }
    
    console.log("필수 필드 유효성 검사 통과.");
    return true; // 모든 필수 필드 유효성 검사 통과
}

//파일 선택 시 썸네일 미리보기 함수 호출하도록 수정
$('#imageInput').on('change', function() {
    validateFileType(this); // 기존 유효성 검사
    previewImages(this);    // 썸네일 미리보기
});

// 썸네일 미리보기 함수
function previewImages(input) {
    const preview = $('#previewArea');
    preview.empty(); // 이전 미리보기 초기화

    const files = input.files;
    if (files.length === 0) {
        return; // 선택된 파일 없으면 종료
    }

    const maxFiles = 4;
    const fileCount = Math.min(files.length, maxFiles);

    for(let i = 0; i < fileCount; i++) {
        const file = files[i];

        // 이미지 파일만 처리
        if(!file.type.startsWith('image/')) continue;

        const reader = new FileReader();

        reader.onload = function(e) {
            // 이미지 태그 생성 후 미리보기 영역에 추가
            const img = $('<img>').attr('src', e.target.result)
                                  .css({
                                    width: '100px',
                                    height: '100px',
                                    objectFit: 'cover',
                                    marginRight: '10px',
                                    border: '1px solid #ddd',
                                    padding: '2px'
                                  });
            preview.append(img);
        };

        reader.readAsDataURL(file);
    }
}
</script>