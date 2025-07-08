<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:forEach var="board" items="${boardList}">
	<div class="list-item">
		<div class="item">
			<div class="item-cate">
				<span>${board.boardCate}</span>
			</div>
			<div class="item-head">
				<div class="user-profile">
					<div class="user-pic">
						<%-- member 프로필 사진 가져오기 --%>
						<c:if test="${empty board.boardWriterImg}">
							<img
								src="https://ca-fe.pstatic.net/web-mobile/static/default-image/user/profile-80-x-80.svg">
						</c:if>
						<c:if test="${not empty board.boardWriterImg}">
							<img id="profileImage" src="${pageContext.request.contextPath}/images/profile/${board.boardWriterImg}" alt="선택한 프로필 이미지">
						</c:if>
					</div>
					<div class="user-name">${board.boardWriter} </div>
					<div class="item-date" data-date="${board.boardDate}"></div>
				</div>
				<div class="item-more">
					<div class="btn-more">
						<img width="20" height="20"
							src="https://img.icons8.com/ios-glyphs/20/more.png" alt="more" />
					</div>
					<ul class="popup">
						<li><a href="javascript:void(0);" class="copyLinkBtn"
							data-url="${contextPath}/board/view?boardId=${board.boardId}">
								링크 복사 </a></li>
						<c:if
							test="${not empty sessionScope.member and sessionScope.member.nick eq board.boardWriter}">
							<li><a
								href="${contextPath}/board/editForm?boardId=${board.boardId}">수정하기</a>
							</li>
							<li>
								<form action="${contextPath}/board/delete" method="post"
									style="display: inline;">
									<input type="hidden" name="boardId" value="${board.boardId}">
									<button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');">삭제하기</button>
								</form>
							</li>
						</c:if>
					</ul>
				</div>
			</div>
			<a href="${contextPath}/board/view?boardId=${board.boardId}"
				class="item-content">
				<p>
					<c:out value="${board.boardCont}" escapeXml="false" />
				</p>
				<div class="img-wrap">
					<c:forEach var="imageFileName" items="${board.imageFiles}">
						<c:if test="${not empty imageFileName}">
							<div class="img-thumb">
								<img
									src="${contextPath}/resources/images/board/${imageFileName}"
									alt="게시글 이미지">
							</div>
						</c:if>
					</c:forEach>
				</div>
			</a>
			<div class="item-info">
				<div class="like  ${likedPosts[board.boardId] ? 'liked' : ''}"
					data-board-id="${board.boardId}">
					<svg xmlns="http://www.w3.org/2000/svg"
						class="${isLiked ? 'liked' : ''}">
							    <path
							d="M12 20a1 1 0 0 1-.437-.1C11.214 19.73 3 15.671 3 9a5 5 0 0 1 8.535-3.536l.465.465.465-.465A5 5 0 0 1 21 9c0 6.646-8.212 10.728-8.562 10.9A1 1 0 0 1 12 20z" />
							  </svg>
					<p class="like-count">${board.boardLike}</p>
				</div>
				<div class="reply-icon">
					<img width="25" height="25"
						src="https://img.icons8.com/material-outlined/25/speech-bubble-with-dots.png"
						alt="speech-bubble-with-dots" />
					<p>${board.boardRe}</p>
				</div>
			</div>
		</div>
	</div>
</c:forEach>
<c:if test="${empty boardList}">
	<div class="empty">
		<p>게시글이 없습니다.</p>
	</div>
</c:if>

<script>
$('.btn-more').on('click', function(e) {
	e.stopPropagation(); // 이벤트 버블링 방지
	var $popup = $(this).siblings('.popup');
	$('.popup').not($popup).hide(); // 다른 popup은 닫기
	$popup.toggle(); // 현재 popup toggle
});

$('.popup').on('click', function(e) {
	e.stopPropagation();
});

$(document).on('click', function() {
	$('.popup').hide();
});

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

$('.item-content .img-wrap').each(function () {
	var count = $(this).find('.img-thumb').length;

	// 최대 4개까지만 처리 (그 이상도 필요시 else if 추가 가능)
	if (count === 1) {
		$(this).addClass('img-count-1');
	} else if (count === 2) {
		$(this).addClass('img-count-2');
	} else if (count === 3) {
		$(this).addClass('img-count-3');
	} else {
		$(this).addClass('img-count-4');
	}
});

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
                    window.location.href = '${contextPath}/member/loginpage.do';
                }
            } else if (response === 'fail') {
                // 이미 좋아요/취소 상태인 경우 등
                console.log('Action failed: ' + (isLiked ? 'Already not liked' : 'Already liked'));
                // 필요하다면 여기서 좋아요 상태를 다시 확인하여 UI를 동기화할 수 있습니다.
            } else if (response === 'error') {
                alert('처리 중 오류가 발생했습니다.');
            } else {
            	// 성공 시 좋아요 수 업데이트 및 클래스 토글
                var $likeCountElement = $likeBtn.find('.like-count');
                // 해당 요소의 텍스트를 업데이트합니다.
                $likeCountElement.text(response);

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