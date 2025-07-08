<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="${contextPath}/resources/css/board.css" rel="stylesheet"
	type="text/css">


<div class="container board">

<div class="post-wrap">

		<div class="post-head">
			<button onclick="location.href='${contextPath}/board/list'">
				<img width="24" height="24"
					src="https://img.icons8.com/material-rounded/24/left.png"
					alt="left" />
			</button>
			<p>게시물</p>
		</div>
		<div class="post-info">
			<div class="item-cate">
				<span>${board.boardCate}</span>
			</div>
			<div class="user-profile">
				<div class="user-info-wrap">
					<div class="user-pic">
						<%-- member 프로필 사진 가져오기 --%>
						<c:if test="${empty board.boardWriterImg}">
							<img
								src="https://ca-fe.pstatic.net/web-mobile/static/default-image/user/profile-80-x-80.svg">
						</c:if>
						<c:if test="${not empty board.boardWriterImg}">
							<img id="profileImage" src="${pageContext.request.contextPath}/images/profile/${board.boardWriterImg}"
								alt="선택한 프로필 이미지">
						</c:if>
					</div>
					<div class="user-name">${board.boardWriter}</div>
				</div>
				
				<div class="item-more">
					<div class="btn-more">
						<img width="20" height="20"
							src="https://img.icons8.com/ios-glyphs/20/more.png" alt="more" />
					</div>
					<ul class="popup">
						<li><a>링크 복사</a></li>
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
		</div>

		<div class="post-content">
			<p>${board.boardCont}</p>
		</div>

		<div class="post-images">
			<c:forEach var="imageFileName" items="${board.imageFiles}">
				<c:if test="${not empty imageFileName}">
					<div class="post-img-thumb">
						<img src="${contextPath}/resources/images/board/${imageFileName}"
							alt="게시글 이미지">
					</div>
				</c:if>
			</c:forEach>
		</div>
		<div class="post-meta">
			<p class="item-date" data-date="${board.boardDate}"></p>
			<p>·</p>
			<p>
				<span>${board.boardCount}</span> 조회수
			</p>
		</div>

		<div class="post-actions">
			<p class="comment-count">
				댓글 <span>${board.boardRe}</span>
			</p>
			<div class="like  ${isLiked ? 'liked' : ''}"
				data-board-id="${board.boardId}">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
							    <path
						d="M12 20a1 1 0 0 1-.437-.1C11.214 19.73 3 15.671 3 9a5 5 0 0 1 8.535-3.536l.465.465.465-.465A5 5 0 0 1 21 9c0 6.646-8.212 10.728-8.562 10.9A1 1 0 0 1 12 20z" />
							  </svg>
				<p class="like-count">${board.boardLike}</p>
			</div>

		</div>

		<div class="comment-section">
			<c:if test="${not empty sessionScope.id}">
				<%-- 댓글 작성 폼 추가 --%>
				<div class="comment-form">	
					<div class="comment-input-area user-profile">
						<div class="comment-profile user-pic">
							<c:choose>
						    	<c:when test="${not empty sessionScope.member.profileImg}">
						        	<img class="profile-image" src="${pageContext.request.contextPath}/images/profile/${sessionScope.member.profileImg}">
						    	</c:when>
						    	<c:otherwise>
						        	<img class="profile-image" src="${contextPath}/resources/icon/basic_profile.jpg">
						    	</c:otherwise>
							</c:choose>
						</div>
						<form action="${contextPath}/board/reply/write" method="post">
							<input type="hidden" name="replyWriter"
								value="${sessionScope.member.nick}"> <input type="hidden"
								name="boardId" value="${board.boardId}">
							<textarea name="replyCont" placeholder="댓글을 남겨주세요" required></textarea>
							<button type="submit">등록</button>
						</form>
					</div>	
				</div>
			</c:if>			
			<c:if test="${empty sessionScope.id}">
				<div class="comment-info comment-info-empty">
					<img width="50" height="50" src="https://img.icons8.com/ios/50/speech-bubble-with-dots--v1.png" alt="speech-bubble-with-dots--v1"/>
					<p class="comment-info">로그인 후 댓글 작성이 가능합니다</p>
				</div>
			</c:if>
			
			<div class="comment-list">
	        <c:forEach var="reply" items="${replyList}">
	            <c:if test="${reply.parentId == 0}">
	                <div class="comment" id="reply-${reply.replyId}" style="margin-left: 0;">
	                    <!-- 댓글 기본 내용 -->
	                    
	                    <div class="comment-author">
	                   		<div class="comment-author-wrap">
		                    	<div class="comment-author-img">
			                        <c:choose>
			                            <c:when test="${empty reply.replyWriterImg}">
			                                <img src="https://ca-fe.pstatic.net/web-mobile/static/default-image/user/profile-80-x-80.svg"
			                                    alt="기본 프로필 이미지" width="30" height="30" />
			                            </c:when>
			                            <c:otherwise>
			                                <img src="${pageContext.request.contextPath}/images/profile/${reply.replyWriterImg}" alt="프로필 이미지" width="30" height="30" />
			                            </c:otherwise>
			                        </c:choose>
		                         </div>
		                        <div class="comment-writer-info">
			                        <div class="comment-writer"> ${reply.replyWriter}</div>	                       
			                        <div class="comment-date item-date" data-date="${reply.replyDate}">${reply.replyDate}</div>
		                        </div>
	                        </div>	                        
	                        <div class="item-more">
								<div class="btn-more">
									<img width="20" height="20"
										src="https://img.icons8.com/ios-glyphs/20/more.png" alt="more" />
								</div>
								<div class="popup">
								 	<div class="comment-actions">
								 	 <c:if test="${ empty sessionScope.id}">
					                     	<button onclick="alert('로그인이 필요한 서비스입니다.');">답글쓰기</button>
					                     </c:if>		
					                      <c:if test="${not empty sessionScope.id}">
				   							<button class="reply-reply-btn" data-parent-id="${reply.replyId}" data-board-id="${board.boardId}">답글쓰기</button>
					                     </c:if>  
										 <c:if test="${not empty sessionScope.member and sessionScope.member.nick eq reply.replyWriter}">										 					                       
				                            <button class="modify-btn" data-reply-id="${reply.replyId}">수정하기</button>
				                            <button class="delete-btn" data-reply-id="${reply.replyId}" data-board-id="${board.boardId}" style="color:red;">삭제하기</button>	
					                    </c:if>				                
					                                    
				                     </div>
								</div>
							</div>	
	                    </div>
	                    <div class="comment-content-wrap">
		                    <div class="comment-content">${reply.replyCont}</div>   
		                    <!-- 댓글 수정 폼 -->
		                    <div class="modify-form" style="display: none;">
		                        <textarea class="modify-textarea">${reply.replyCont}</textarea>
		                        <div class="btn-wrap">
			                        <button class="cancel-modify-btn">취소</button>
			                        <button class="save-modify-btn" data-reply-id="${reply.replyId}">수정</button>
		                        </div>
		                    </div>
	                    </div>
	
	                    <!-- 대댓글 리스트 (부모 댓글 ID가 현재 댓글 ID와 같은 것만 출력) -->
	                    <c:forEach var="childReply" items="${replyList}">
	                        <c:if test="${childReply.parentId == reply.replyId}">
	                            <div class="comment reply" id="reply-${childReply.replyId}" style="margin-left: 20px;">
	                                <div class="comment-author">
		                                <div class="comment-author-wrap">
			                                <div class="comment-author-img">
			                                    <c:choose>
			                                        <c:when test="${empty childReply.replyWriterImg}">
			                                            <img src="https://ca-fe.pstatic.net/web-mobile/static/default-image/user/profile-80-x-80.svg"
			                                                alt="기본 프로필 이미지" width="25" height="25" />
			                                        </c:when>
			                                        <c:otherwise>
			                                            <img src="${pageContext.request.contextPath}/images/profile/${childReply.replyWriterImg}" alt="프로필 이미지" width="25" height="25" />
			                                        </c:otherwise>
			                                    </c:choose>
		                                    </div>
		                                    <div class="comment-writer-info">
						                        <div class="comment-writer">   ${childReply.replyWriter}</div>	                       
						                        <div class="comment-date item-date" data-date="${childReply.replyDate}">${childReply.replyDate}</div>
					                        </div>	                                    
	                                  </div>	
	                                  <div class="item-more">
											<div class="btn-more">
												<img width="20" height="20"
													src="https://img.icons8.com/ios-glyphs/20/more.png" alt="more" />
											</div>
											<div class="popup">
											 	<div class="comment-actions">
													 <c:if test="${not empty sessionScope.member and sessionScope.member.nick eq childReply.replyWriter}">	                                 
				                                        <button class="modify-btn" data-reply-id="${childReply.replyId}">수정하기</button>
				                                        <button class="delete-btn" data-reply-id="${childReply.replyId}" data-board-id="${board.boardId}" style="color:red;">삭제하기</button>					                                   
					                                </c:if>			                
								                    <c:if test="${ empty sessionScope.id}">
								                     	<button onclick="alert('로그인이 필요한 서비스입니다.');">답글쓰기</button>
								                     </c:if>				                     
							                     </div>
											</div>
										</div>	
	                                </div>
	                                 <div class="comment-content-wrap reply">
	                                	<div class="comment-content">${childReply.replyCont}</div>	         
	                                	 <div class="modify-form" style="display: none;">
		                                    <textarea class="modify-textarea">${childReply.replyCont}</textarea>
		                                     <div class="btn-wrap">
			                                    <button class="save-modify-btn" data-reply-id="${childReply.replyId}">저장</button>
			                                    <button class="cancel-modify-btn">취소</button>
		                                      </div>   
		                                </div>                       
									</div>	
	                            </div>
	                        </c:if>
	                    </c:forEach>
	
	                    <!-- 대댓글 작성 버튼 -->
	                    <c:if test="${not empty sessionScope.id}">
	                       
	                        <!-- 대댓글 작성 폼 (숨김) -->
	                        <div class="reply-reply-form" data-parent-id="${reply.replyId}" style="display:none; margin-left: 20px; margin-top: 1rem;">
	                            <form action="${contextPath}/board/reply/write" method="post" class="reply-reply-post-form">
	                                <input type="hidden" name="boardId" value="${board.boardId}" />
	                                <input type="hidden" name="parentId" value="${reply.replyId}" />
	                                <input type="hidden" name="replyWriter" value="${sessionScope.member.nick}" />
	                                <textarea name="replyCont" placeholder="답글을 입력하세요." required></textarea>
	                                <div class="btn-wrap">
		                                <button type="submit">등록</button>
		                                <button type="button" class="cancel-reply-reply-btn">취소</button>
	                                </div>   
	                            </form>
	                        </div>
	                    </c:if>
	                </div>
	            </c:if>
	        </c:forEach>
	    </div>		
	</div>
</div>

<jsp:include page="side.jsp" />
</div>

<script>
$('article').has('.board').addClass('board-article');

// item-date 클래스를 가진 요소들을 찾아서 날짜 포맷을 보기 좋게 바꿔주는 스크립트
// 예: 2023-08-22T10:30:00 -> 2023.08.22 10:30
document.querySelectorAll('.item-date').forEach(
	function(element) {
		var rawDate = element.getAttribute('data-date');
		if (rawDate) {
			var date = new Date(rawDate);
			var year = date.getFullYear();
			var month = ('0' + (date.getMonth() + 1)).slice(-2);
			var day = ('0' + date.getDate()).slice(-2);
			var hours = ('0' + date.getHours()).slice(-2);
			var minutes = ('0' + date.getMinutes()).slice(-2);
			element.textContent = year + '.' + month + '.' + day + '. '
					+ hours + ':' + minutes;
		}
	}
);
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
</script>
<script>
    // 임시 member_id 설정 (JSP 변수와 동일하게)
    var currentUserId = "admin"; // <<<<<<< 임시 member_id 설정

    // 삭제 버튼 클릭 이벤트
    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', function() {
            var replyId = this.getAttribute('data-reply-id');
            var boardId = this.getAttribute('data-board-id');

            if (confirm('정말 이 댓글을 삭제하시겠습니까?')) {
                // 삭제 요청을 보낼 폼 생성 (POST 방식으로)
                var form = document.createElement('form');
                form.setAttribute('method', 'post');
                form.setAttribute('action', '${pageContext.request.contextPath}/board/deleteReply');

                var replyIdField = document.createElement('input');
                replyIdField.setAttribute('type', 'hidden');
                replyIdField.setAttribute('name', 'replyId');
                replyIdField.setAttribute('value', replyId);
                form.appendChild(replyIdField);

                var boardIdField = document.createElement('input'); 
                boardIdField.setAttribute('type', 'hidden');
                boardIdField.setAttribute('name', 'boardId');
                boardIdField.setAttribute('value', boardId);
                form.appendChild(boardIdField);
             
                document.body.appendChild(form);
                form.submit();
            }
        });
    });

    // 수정 버튼 클릭 이벤트
    document.querySelectorAll('.modify-btn').forEach(button => {
        button.addEventListener('click', function() {
            var replyId = this.getAttribute('data-reply-id');
            var commentDiv = document.getElementById('reply-' + replyId);
            var contentDiv = commentDiv.querySelector('.comment-content');
            var actionsDiv = commentDiv.querySelector('.comment-actions');
            var modifyFormDiv = commentDiv.querySelector('.modify-form');
            var modifyTextarea = modifyFormDiv.querySelector('.modify-textarea');

            // 현재 내용을 textarea에 설정하고 수정 폼을 보이게 함
            modifyTextarea.value = contentDiv.innerText.trim();
            //contentDiv.style.display = 'none'; 
            //actionsDiv.style.display = 'none'; 
            modifyFormDiv.style.display = 'block';
            
            var $popup = $(this).siblings('.popup');
        	$('.popup').hide(); // 다른 popup은 닫기
        	
        });
    });

    // 수정 저장 버튼 클릭 이벤트 (AJAX 사용)
    document.querySelectorAll('.save-modify-btn').forEach(button => {
        button.addEventListener('click', function() {
            var replyId = this.getAttribute('data-reply-id');
            var commentDiv = document.getElementById('reply-' + replyId);
            var modifyFormDiv = commentDiv.querySelector('.modify-form');
            var modifyTextarea = modifyFormDiv.querySelector('.modify-textarea');
            var newReplyCont = modifyTextarea.value;

            // AJAX 요청 보내기
            fetch('${pageContext.request.contextPath}/board/updateReply', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded', // 또는 'application/json'
                },
                body: 'replyId=' + encodeURIComponent(replyId) + '&replyCont=' + encodeURIComponent(newReplyCont)
                // JSON 형식으로 보내려면 body: JSON.stringify({ replyId: replyId, replyCont: newReplyCont })
                // 그리고 Controller에서 @RequestBody 사용
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    // 성공 시 댓글 내용 업데이트 및 폼 숨김
                    var contentDiv = commentDiv.querySelector('.comment-content');
                    var actionsDiv = commentDiv.querySelector('.comment-actions');
                    contentDiv.innerText = newReplyCont; 
                    contentDiv.style.display = 'block';
                    actionsDiv.style.display = 'block'; 
                    modifyFormDiv.style.display = 'none';
                    alert(data.message);
                } else {
                    alert(data.message); 
                    // 실패 시에도 폼을 숨기고 원래 내용 표시
                    var contentDiv = commentDiv.querySelector('.comment-content');
                    var actionsDiv = commentDiv.querySelector('.comment-actions');
                    contentDiv.style.display = 'block';
                    actionsDiv.style.display = 'block';
                   	modifyFormDiv.style.display = 'none';
                }
            })
            .catch((error) => {
                console.error('Error:', error);
                alert('댓글 수정 중 오류가 발생했습니다.');
                // 오류 시에도 폼을 숨기고 원래 내용 표시 
                var contentDiv = commentDiv.querySelector('.comment-content');
                var actionsDiv = commentDiv.querySelector('.comment-actions');
                contentDiv.style.display = 'block';
                actionsDiv.style.display = 'block';
                modifyFormDiv.style.display = 'none';
            });
        });
    });

    // 수정 취소 버튼 클릭 이벤트
    document.querySelectorAll('.cancel-modify-btn').forEach(button => {
        button.addEventListener('click', function() {
            var commentDiv = this.closest('.comment'); // 가장 가까운 .comment 부모 찾기
            var contentDiv = commentDiv.querySelector('.comment-content');
            var actionsDiv = commentDiv.querySelector('.comment-actions');
            var modifyFormDiv = commentDiv.querySelector('.modify-form');

            // 폼 숨기고 원래 내용과 액션 버튼 다시 보임
            contentDiv.style.display = 'block';
            actionsDiv.style.display = 'block';
            modifyFormDiv.style.display = 'none';
        });
    });
    
    // 답글쓰기 버튼 클릭 시 해당 부모 댓글 밑에 폼 표시 
    $('.reply-reply-btn').click(function() {
        var parentId = $(this).data('parent-id');
        var formDiv = $('.reply-reply-form[data-parent-id="' + parentId + '"]');
        formDiv.toggle();  // 토글로 보여주기/숨기기
    });

    // 답글쓰기 취소 버튼 클릭 시 폼 숨기기
    $('.cancel-reply-reply-btn').click(function() {
        $(this).closest('.reply-reply-form').hide();
    });
    
    // 좋아요 버튼 클릭 이벤트 (AJAX) 
    $('.like').on('click', function() {
        var $likeBtn = $(this);
        var boardId = $likeBtn.data('board-id');
         
        // 로그인 상태 확인
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
    })

</script>