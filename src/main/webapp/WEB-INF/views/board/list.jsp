<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="${contextPath}/resources/css/board.css" rel="stylesheet"
	type="text/css">

<!-- 글 작성 모달 -->
<div id="postModal" style="display:none; position:fixed; top:0; left:0; 
    width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000;">
    <div class="post-form-wrap">
        <button id="closePostModal"><img width="24" height="24" src="https://img.icons8.com/material-rounded/24/delete-sign.png" alt="delete-sign"/></button>        
        <jsp:include page="postForm.jsp" />
    </div>
</div>

<div class="container board main">
	<c:if test="${not empty sessionScope.id}">
		<div class="post-btn">
		    <a href="javascript:void(0);" id="openPostModal">
		    <img width="20" height="20" src="https://img.icons8.com/material-rounded/24/pencil--v2.png" alt="pencil--v2"/>
		    <p>게시글 쓰기</p>		    	
			</a>
		</div>
	</c:if>
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


$(function() {
    // 모달 열기
    $('#openPostModal').click(function() {
        $('#postModal').fadeIn();
    });

    // 모달 닫기 버튼 클릭 시
    $('#closePostModal').click(function() {
        $('#postModal').fadeOut();
    });

    // 모달 바깥 영역 클릭 시 닫기
    $('#postModal').click(function(e) {
        if (e.target === this) {
            $(this).fadeOut();
        }
    });
});

</script>