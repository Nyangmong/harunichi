<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="${contextPath}/resources/css/board.css" rel="stylesheet"
	type="text/css">

<div class="container board main search-result">
	<!-- <c:if test="${not empty sessionScope.id}">
		<div class="post-btn">
			<a href="${contextPath}/board/postForm">새 게시글 작성</a>
		</div>
	</c:if> -->
	<div class="board-list">		
		<!-- 게시글 목록 영역 -->
		<div id="ListContainer" class="list-wrap">
		    <jsp:include page="items.jsp" />
		</div>	
	</div>
	<jsp:include page="side.jsp" />
</div>

<script>
$('article').has('.board').addClass('board-article');

function formatTimeAgo(timestamp) {
    const now = new Date();
    const postDate = new Date(timestamp);
    const diffSeconds = Math.floor((now - postDate) / 1000);

    if (diffSeconds >= 86400) {
        const year = postDate.getFullYear();
        const month = ('0' + (postDate.getMonth() + 1)).slice(-2);
        const day = ('0' + postDate.getDate()).slice(-2);  
        return year + '.' + month + '.' + day + '.' ;
    }

    if (diffSeconds < 60) {
        return diffSeconds + "초 전";
    } else if (diffSeconds < 3600) {
        return Math.floor(diffSeconds / 60) + "분 전";
    } else {
        return Math.floor(diffSeconds / 3600) + "시간 전";
    }
}

function updateTimeElements() {
    document.querySelectorAll('.item-date').forEach(span => {
        const dateString = span.dataset.date;
        const postDate = new Date(dateString);

        if (isNaN(postDate.getTime())) {
            console.error("Invalid date:", dateString);
            span.textContent = "Invalid Date";
            return;
        }

        const timestamp = postDate.getTime();
        span.dataset.timestamp = timestamp;
        span.textContent = formatTimeAgo(timestamp);
    });
}

document.addEventListener('DOMContentLoaded', updateTimeElements);

setInterval(() => {
    document.querySelectorAll('.item-date').forEach(span => {
        const timestamp = parseInt(span.dataset.timestamp);
        if (!isNaN(timestamp)) {
            span.textContent = formatTimeAgo(timestamp);
        }
    });
}, 60000);

// 게시글 삭제 관련 메세지
$(document).ready(function() {    
    const urlParams = new URLSearchParams(window.location.search);
    const msg = urlParams.get('msg');

    if (msg) {
        let alertMessage = '';
        if (msg === 'deleteSuccess') {
            alertMessage = '게시글이 성공적으로 삭제되었습니다.';
        } else if (msg === 'deleteFailed') {
            alertMessage = '게시글 삭제에 실패했습니다.';
        } else if (msg === 'invalidBoardId') {
            alertMessage = '잘못된 게시글 정보입니다.';
        } else if (msg === 'deleteError') {
            alertMessage = '게시글 삭제 중 시스템 오류가 발생했습니다.';
        }
        if (alertMessage) {
            alert(alertMessage);        
            history.replaceState({}, document.title, window.location.pathname); 
        }
    }
});


//좋아요 버튼 클릭 이벤트 (AJAX) - 목록 페이지 버전
$('.like').on('click', function() {
    var $likeBtn = $(this); // 클릭된 .like 요소
    var boardId = $likeBtn.data('board-id');

    // 로그인 상태 확인 (JSP EL 변수 사용)
    var isLoggedIn = ${not empty sessionScope.member};

    if (!isLoggedIn) {
        // 로그인하지 않은 경우 팝업 표시
        alert('좋아요 기능은 로그인 후 이용 가능합니다.');
        if (confirm('로그인 페이지로 이동하시겠습니까?')) {
            window.location.href = '${contextPath}/member/loginpage.do';
        }
        return; // AJAX 요청 중단
    }

    var isLiked = $likeBtn.hasClass('liked');
    var url = isLiked ? '${contextPath}/board/like/cancel' : '${contextPath}/board/like';

    $.ajax({
        url: url,
        type: 'POST',
        data: { boardId: boardId },
        success: function(response) {
            if (response === 'login') {
                // 서버에서도 로그인 체크를 하므로 이 경우에도 처리
                alert('좋아요 기능은 로그인 후 이용 가능합니다.');
                if (confirm('로그인 페이지로 이동하시겠습니까?')) {
                    window.location.href = '${contextPath}/member/loginForm';
                }
            } else if (response === 'fail') {
                // 이미 좋아요/취소 상태인 경우 등
                console.log('Action failed: ' + (isLiked ? 'Already not liked' : 'Already liked'));
                // 필요하다면 여기서 좋아요 상태를 다시 확인하여 UI를 동기화할 수 있습니다.
            } else if (response === 'error') {
                alert('처리 중 오류가 발생했습니다.');
            } else {
                // 성공 시 좋아요 수 업데이트 및 클래스 토글
                // 클릭된 .like 요소의 형제 요소 중 "좋아요" 텍스트를 포함하는 <p> 태그를 찾습니다.
                var $likeCountParagraph = $likeBtn.siblings('p:contains("좋아요")');
                // 해당 <p> 태그의 텍스트를 업데이트합니다.
                $likeCountParagraph.text('좋아요 ' + response);

                // .like 요소에 liked 클래스 토글
                $likeBtn.toggleClass('liked');
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error: " + status + error);
            alert('처리 중 오류가 발생했습니다.');
        }
    });
});
</script>