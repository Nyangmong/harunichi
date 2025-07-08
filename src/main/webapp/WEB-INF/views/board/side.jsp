<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="board-side">
	<div class="search-box">
		<form action="${contextPath}/board/search" method="get" class="search-form">
			<input type="text" name="keyword" placeholder="원하는 글을 찾아보세요"
				value="${keyword}">
			<button type="submit">
				<img src="/harunichi/resources/icon/search_icon.svg" alt="검색">
			</button>
		</form>
	</div>

	<div class="side-list">
		<h3>추천 게시글</h3>
		<ul>
		<c:forEach var="top" items="${top5List}">
			<li>
				<a href="${contextPath}/board/view?boardId=${top.boardId}">
				<p class="item-cate">${top.boardCate}</p>
				<div class="item-content">${top.boardCont}</div>
				</a>			
			</li>
		</c:forEach>
		</ul>	
	</div>
	<div class="side-list cate-list">
	<h3>추천 태그</h3>		
		<div class="category-tabs">
		    <!-- <button class="category-btn active" data-cate="">전체</button> -->
		    <button class="category-btn" data-cate="생활정보">#생활정보</button>
		    <button class="category-btn" data-cate="일상">#일상</button>
		    <button class="category-btn" data-cate="맛집, 카페">#맛집_카페</button>
		    <button class="category-btn" data-cate="찾습니다">#찾습니다</button>
		    <button class="category-btn" data-cate="건강, 운동">#건강_운동</button>
		    <button class="category-btn" data-cate="육아, 교육">#육아_교육</button>
   		</div>
	</div>
</div>

<script>
$(document).ready(function() {
    // cate-list를 기본적으로 숨김
    $('.cate-list').hide();

    // .cate-list의 상위 요소 중 .main이 있으면 다시 보이게
    if ($('.cate-list').closest('.main').length > 0) {
        $('.cate-list').show();
    }
});

$(function(){
    $('.category-btn').click(function(){
        $('.category-btn').removeClass('active');
        $(this).addClass('active');

        var cate = $(this).data('cate'); // 카테고리명

        $.ajax({
            url: '${contextPath}/board/listByCategory',
            method: 'GET',
            data: { category: cate },
            dataType: 'html',
            success: function(html) {
                $('#ListContainer').html(html);
            },
            error: function() {
                alert('게시글 목록을 불러오는 데 실패했습니다.');
            }
        });
    });
});

</script>