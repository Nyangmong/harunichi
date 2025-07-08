<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="${contextPath}/resources/css/board.css" rel="stylesheet"
	type="text/css">

<div class="container board main hots">
	<ul class="board-list hots-list">	
		<h3>인기글</h3>
		<c:forEach var="top100" items="${top100List}" varStatus="status">
			<li>
				<div class="item-head">
					<span class="item-number">${status.index + 1}</span>	
					<p class="item-cate">${top100.boardCate}</p>		
				</div>		
				<a href="${contextPath}/board/view?boardId=${top100.boardId}">				
					<div class="content-wrap">
						<div class="item-content">						
								${top100.boardCont}									
						</div>
						<div class="img-wrap">				
							<c:if test="${not empty top100.boardImg1}">
								<div class="img-thumb">
									<img
										src="${contextPath}/resources/images/board/${top100.boardImg1}"
										alt="게시글 이미지">
								</div>
							</c:if>
						</div>
					</div>	
					<div class="content-info">
						<p>조회 ${top100.boardCount}</p>
						<p><img width="16" height="16" src="https://img.icons8.com/material-outlined/25/like--v1.png" alt="like--v1"/> ${top100.boardLike}</p>
						<p><img width="16" height="16"
						src="https://img.icons8.com/material-outlined/25/speech-bubble-with-dots.png"
						alt="speech-bubble-with-dots" /> ${top100.boardRe}</p>
					</div>
				</a>
			</li>
		</c:forEach>
	</ul>
	<jsp:include page="side.jsp" />
</div>

<script>
$('article').has('.board').addClass('board-article');
</script>