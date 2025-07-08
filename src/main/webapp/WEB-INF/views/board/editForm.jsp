<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="${contextPath}/resources/css/board.css" rel="stylesheet"
	type="text/css">


<div class="container board">

	<div class="edit-wrap">
	
		<div class="post-head">
			<button onclick="location.href='${contextPath}/board/list'">
				<img width="24" height="24"
					src="https://img.icons8.com/material-rounded/24/left.png"
					alt="left" />
			</button>
			<p>글 수정하기</p>
		</div>
	
		<form action="${contextPath}/board/update" method="post"
			enctype="multipart/form-data" class="board-form">
			<input type="hidden" name="boardId" value="${board.boardId}">
	
			<div class="form-section">
				<!-- <div class="form-row">
					<div class="form-label">게시글 번호</div>
					<div class="form-value">
						<c:out value="${board.boardId}" />
					</div>
				</div>
				<div class="form-row">
					<div class="form-label">작성자</div>
					<div class="form-value">
						<c:out value="${board.boardWriter}" />
					</div>
				</div>
				<div class="form-row">
					<div class="form-label">작성일</div>
					<div class="form-value">
						<fmt:formatDate value="${board.boardDate}"
							pattern="yyyy-MM-dd HH:mm" />
					</div>
				</div>
				<c:if test="${not empty board.boardModDate}">
					<div class="form-row">
						<div class="form-label">수정일</div>
						<div class="form-value">
							<fmt:formatDate value="${board.boardModDate}"
								pattern="yyyy-MM-dd HH:mm" />
						</div>
					</div>
				</c:if>
				<div class="form-row">
					<div class="form-label">조회수</div>
					<div class="form-value">
						<c:out value="${board.boardCount}" />
					</div>
				</div>
				<div class="form-row">
					<div class="form-label">추천수</div>
					<div class="form-value">
						<c:out value="${board.boardLike}" />
					</div>
				</div>
				<div class="form-row">
					<div class="form-label">답글수</div>
					<div class="form-value">
						<c:out value="${board.boardRe}" />
					</div>
				</div>  -->
				<div class="form-row select-wrap">			
					<div class="form-value">
						<select name="boardCate" required>
							<option value="" disabled>--카테고리 선택--</option>
							<option value="생활정보"
								<c:if test="${board.boardCate eq '생활정보'}">selected</c:if>>생활정보</option>
							<option value="맛집,카페"
								<c:if test="${board.boardCate eq '맛집,카페'}">selected</c:if>>맛집,카페</option>
							<option value="일상"
								<c:if test="${board.boardCate eq '일상'}">selected</c:if>>일상</option>
							<option value="찾습니다"
								<c:if test="${board.boardCate eq '찾습니다'}">selected</c:if>>찾습니다</option>
							<option value="건강,운동"
								<c:if test="${board.boardCate eq '건강,운동'}">selected</c:if>>건강,운동</option>
							<option value="육아,교육"
								<c:if test="${board.boardCate eq '육아,교육'}">selected</c:if>>육아,교육</option>
							<%--TODO: 카테고리가 DB에서 관리된다면, 게시글 등록 폼처럼
	                    <c:forEach var="category" items="${categoryList}">
	                        <option value="${category.categoryId}" <c:if test="${board.boardCate eq category.categoryId}">selected</c:if>>${category.categoryName}</option>
	                    </c:forEach>
	                    --%>
						</select>
					</div>
				</div>			
				<div class="form-row content-wrap">	
					<div class="form-value">
						<textarea name="boardCont" rows="10" cols="80" required><c:out
								value="${board.boardCont}" /></textarea>
					</div>				
					<div class="form-value image-upload-section">
						<%-- 기존 이미지 목록 및 삭제 체크박스 --%>
						<%--<c:if test="${board.boardImg1 != null}">
							<div class="existing-image-item">
								<img src="/resources/images/board/${board.boardImg1}"
									style="max-width: 100px;" /> <label
									class="delete-checkbox-label"> <input type="checkbox"
									name="deleteIndices" value="1"> 삭제
								</label>
							</div>
						</c:if>
						<c:if test="${board.boardImg2 != null}">
							<div class="existing-image-item">
								<img src="/resources/images/board/${board.boardImg2}"
									style="max-width: 100px;" /> <label
									class="delete-checkbox-label"> <input type="checkbox"
									name="deleteIndices" value="2"> 삭제
								</label>
							</div>
						</c:if>
						<c:if test="${board.boardImg3 != null}">
							<div class="existing-image-item">
								<img src="/resources/images/board/${board.boardImg3}"
									style="max-width: 100px;" /> <label
									class="delete-checkbox-label"> <input type="checkbox"
									name="deleteIndices" value="3"> 삭제
								</label>
							</div>
						</c:if>
						<c:if test="${board.boardImg4 != null}">
							<div class="existing-image-item">
								<img src="/resources/images/board/${board.boardImg4}"
									style="max-width: 100px;" /> <label
									class="delete-checkbox-label"> <input type="checkbox"
									name="deleteIndices" value="4"> 삭제
								</label>
							</div>
						</c:if>--%>
	
						<%-- 새로운 이미지 업로드 필드 --%>
						<div id="previewArea" style="margin-top:10px;"></div> <!-- 썸네일 영역 추가 -->
						
					 	 <div class="button-group">
						 	 <div class="form-input new-image-upload">
							    <label for="imageFiles" class="file-upload-label">
							     <img width="25" height="25" src="https://img.icons8.com/fluency-systems-regular/48/image--v1.png" alt="image--v1"/>
							    </label>
							       <input type="file" id="imageFiles" name="imageFiles" multiple="multiple" accept="image/*" class="file-input">
						 	 </div>	
							<input type="submit" value="수정하기">	
						</div>
					</div>
				</div>
			</div>
			<%-- form-section 끝 --%>	
		</form>
	</div>
</div>

<script>
$('article').has('.board').addClass('board-article');

$(document).ready(function() {
	// 파일 입력 필드의 change 이벤트에 validateFileType 함수 연결
	$('input[name="imageFiles"]').change(function() {
		validateFileType(this);
	});

	// 삭제 체크박스의 change 이벤트에도 유효성 검사 함수 연결
	$('input[name="deleteIndices"]').change(function() {
		const fileInput = $('input[name="imageFiles"]')[0];
		validateFileType(fileInput);
	});
});

function validateFileType(input) {
	const files = input.files; // 새로 선택된 파일 목록 (FileList 객체)
	const maxFiles = 4; // 허용되는 최대 파일 개수

	// 1. 현재 표시된 기존 이미지 중 삭제되지 않고 남을 이미지 개수 계산
	let remainingExistingImages = 0;

	const deleteCheckboxes = $('.form-value.image-upload-section input[name="deleteIndices"]');

	deleteCheckboxes.each(function() {
		// 각 삭제 체크박스에 대해, 체크되어 있지 않다면 남을 이미지 개수에 포함
		if (!$(this).is(':checked')) {
			remainingExistingImages++;
		}
	});

	console.log("삭제 후 남게 될 기존 이미지 개수:", remainingExistingImages);

	// 2. 새로 선택된 파일 개수
	const newFilesCount = files.length;
	console.log("새로 선택된 파일 개수:", newFilesCount);

	// 3. 수정 완료 후 총 이미지 개수 계산
	const totalImagesAfterUpdate = remainingExistingImages + newFilesCount;
	console.log("수정 후 총 이미지 개수 예상:", totalImagesAfterUpdate);

	// 4. 총 이미지 개수 제한 확인
	if (totalImagesAfterUpdate > maxFiles) {
		alert('첨부 이미지는 기존 이미지와 새로 추가할 이미지를 합쳐 최대 ' + maxFiles
				+ '개까지 가능합니다.\n현재 ' + remainingExistingImages
				+ '개의 기존 이미지가 유지되고 있으며, ' + newFilesCount
				+ '개의 새 파일을 추가하면 총 ' + totalImagesAfterUpdate + '개가 됩니다.');
		input.value = ''; // 파일 선택 필드 초기화 (선택된 모든 파일 제거)
		console.log("총 이미지 개수 초과. 파일 선택 초기화.");
		return; // 유효하지 않은 파일 개수 발견 시 즉시 함수 종료
	}

	// 5. 파일 타입 검사 (총 개수 검사 통과 후 실행)
	console.log("총 이미지 개수 유효성 검사 통과.");
	// 새로 선택된 파일이 있을 경우에만 타입 검사 실행
	if (newFilesCount > 0) {
		for (let i = 0; i < newFilesCount; i++) {
			const file = files[i];
			console.log("검사 중 파일:", file.name, "타입:", file.type);

			// 파일 타입이 'image/'로 시작하는지 확인
			if (!file.type.startsWith('image/')) {
				alert('이미지 파일만 업로드할 수 있습니다.\n잘못된 파일: ' + file.name);
				input.value = ''; // 파일 선택 필드 초기화 (선택된 모든 파일 제거)
				console.log("유효하지 않은 파일 타입 감지. 파일 선택 초기화.");
				return; // 유효하지 않은 파일 발견 시 즉시 함수 종료
			}
		}
	}

	console.log("모든 파일 유효성 검사 통과.");
}

//이미지 선택 시 썸네일 미리보기
$('#imageFiles').on('change', function() {
    validateFileType(this);  // 기존 유효성 검사
    previewImages(this);     // 썸네일 표시 함수
});

$(document).ready(function() {
    showExistingThumbnails();  // 기존 이미지 표시

    // 기존 코드 유지
    $('input[name="imageFiles"]').change(function() {
        validateFileType(this);
        previewImages(this);
    });

    $('input[name="deleteIndices"]').change(function() {
        const fileInput = $('input[name="imageFiles"]')[0];
        validateFileType(fileInput);
    });
});

// 기존 이미지 미리보기 표시 함수
function showExistingThumbnails() {
    const preview = $('#previewArea');
    preview.empty();

    const existingImages = [];

    <c:if test="${not empty board.boardImg1}">
        existingImages.push({src: '${contextPath}/resources/images/board/${board.boardImg1}', index: 1});
    </c:if>
    <c:if test="${not empty board.boardImg2}">
        existingImages.push({src: '${contextPath}/resources/images/board/${board.boardImg2}', index: 2});
    </c:if>
    <c:if test="${not empty board.boardImg3}">
        existingImages.push({src: '${contextPath}/resources/images/board/${board.boardImg3}', index: 3});
    </c:if>
    <c:if test="${not empty board.boardImg4}">
        existingImages.push({src: '${contextPath}/resources/images/board/${board.boardImg4}', index: 4});
    </c:if>

    for (const img of existingImages) {
        const container = $('<div class="img-thum">').css({ display: 'inline-block', marginRight: '10px' });
        const imageTag = $('<img>').attr('src', img.src).css({
            width: '100px',
            height: '100px',
            objectFit: 'cover',
            border: '1px solid #ddd',
            padding: '2px',
            display: 'block'
        });
        const label = $('<label>').text('삭제').prepend(
            $('<input>').attr({
                type: 'checkbox',
                name: 'deleteIndices',
                value: img.index
            })
        );
        container.append(imageTag).append(label);
        preview.append(container);
    }
}
</script>