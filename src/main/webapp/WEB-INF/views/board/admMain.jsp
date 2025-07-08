<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 게시글 관리</title>
<style>
/* 스크롤 영역 */
.scroll-area {
  display: flex;
  flex-direction: column;
  gap: 20px;
  border-radius: 0;
}

/* 탭 스타일 */
.tabs {
  display: flex;
}

.tabs a {
  padding: 15px;
  border-bottom: 3px solid transparent;
  text-decoration: none;
  color: #888;
  font-size: 16px;
}

.tabs a:hover {
  background-color: #f4f4f4;
}

.tabs a.active {
  border-bottom-color: #A3DAFF;
  font-weight: bold;
  color: #222;
}

/* 검색 폼 */
.header-search-form {
  display: flex;
  gap: 5px;
  width: 100%;
  max-width: 700px;
  min-width: 200px;
      padding: 1rem 0;
    align-items: center;
}

.header-search-form select {
  padding: 5px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #fff;
  font-size: 14px;
  flex: none;
  width: 100px;
}

.header-search-form input[type="text"] {
  padding: 6px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #fff;
  font-size: 14px;
  flex: 1;
  min-width: 50px;
}

.header-search-form button {
  padding: 5px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #f4f4f4;
  font-size: 14px;
  flex: none;
  width: auto;
  white-space: nowrap;
}

.header-search-form button:hover {
  background-color: #d9d9d9;
}

/* 테이블 영역 */
table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  border: 1px solid #ccc;
  border-radius: 6px;
  overflow: hidden;
}

thead {
  background-color: #f9f9f9; 
}

thead th {
  padding: 12px 6px;
  text-align: center;
  font-weight: bold;
  border-bottom: 1px solid #ccc;
  font-size: 14px;
  white-space: nowrap;
}

tbody td {
  padding: 6px;
  border-bottom: 1px solid #ccc;
  text-align: center;
   font-size: 14px;
}

tbody tr:last-child td {
  border-bottom: none;
}

.profile-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
  justify-content: center;
  align-items: center; /* 중앙에 모으기 */
}

tbody .table-img {
  width: 50px;
  height: 50px;
  border-radius: 4px;
  overflow: hidden;
  border: 1px solid #eee;
}

tbody .table-img img {
  width: 100%;
  object-fit: cover;
  display: block;
}

table input[type="text"], 
table input[type="date"] {
  width: 100%;
  box-sizing: border-box;
  padding: 6px;
  font-size: 12px;
  border: 0;
  border-radius: 4px;
  text-align: center;
}
/*
table select {
  width: 100%;
  min-width: 60px;
  padding: 6px;
  font-size: 12px;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
}
*/

table button {
  padding: 4px;
  font-size: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  background-color: #f4f4f4;
  cursor: pointer;
}

table button:hover {
  background-color: #d9d9d9;
}

/* 저장, 삭제 버튼 */
.submit-btn-class {
  display: flex;
  gap: 10px;
  padding-top: 15px;
}

.submit-btn-class button {
  padding: 5px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #f4f4f4;
  font-size: 14px;
  flex: none;
  width: auto;
  white-space: nowrap;
}

.submit-btn-class button:hover {
  background-color: #d9d9d9;
}

/* 페이징 버튼 */
.pagination {
  display: flex;
  justify-content: center;
  gap: 5px;
  margin-top: 20px;
  flex-wrap: wrap;
}

.pagination a {
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  text-decoration: none;
  color: #333;
  font-size: 14px;
  background-color: #fff;
  transition: background-color 0.2s;
}

.pagination a:hover {
  background-color: #d9d9d9;
}

.pagination a.active-page {
  background-color: #A3DAFF; /* 하늘색 */
  font-weight: bold;
  color: #000;
  text-decoration: none; /* 밑줄 없애기 */
  border-color: #A3DAFF;
}
</style>
</head>
<body>

<!-- 검색 폼 -->
<form action="${contextPath}/board/admin" method="get" class="header-search-form">    
     <select name="searchType" id="searchType">
         <option value="all" ${searchType == 'all' ? 'selected' : ''}>전체</option>
         <option value="writer" ${searchType == 'writer' ? 'selected' : ''}>작성자</option>
         <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
         <option value="category" ${searchType == 'category' ? 'selected' : ''}>카테고리</option>
     </select>  
     <input type="text" name="keyword" id="keyword" value="${keyword}" placeholder="검색어를 입력하세요">
    <button type="submit">검색</button>
</form>


<!-- 게시글 목록 테이블 -->
<form action="${contextPath}/board/admin/saveOrDelete" method="post">
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <thead>
      <tr>
        <th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"/></th>
        <th>번호</th>
        <th>작성자</th>
        <th>내용</th>
        <th>카테고리</th>
        <th>작성일</th>
        <th>조회수</th>
        <th>좋아요</th>
        <th>댓글수</th>
        <th>이미지1</th>
        <th>이미지2</th>
        <th>이미지3</th>
        <th>이미지4</th>
        <th>관리</th> <!-- 새로운 컬럼 추가 -->
      </tr>
    </thead>
    <tbody>
      <c:forEach var="board" items="${boardList}" varStatus="loop">
        <tr>
          <td><input type="checkbox" name="selectedIds" value="${board.boardId}"/></td>
          <td>${board.boardId}<input type="hidden" name="boards[${loop.index}].boardId" value="${board.boardId}"/></td>
          <td><input type="text" name="boards[${loop.index}].boardWriter" value="${board.boardWriter}" readonly/></td>
          <td><input type="text" name="boards[${loop.index}].boardCont" value="${board.boardCont}" readonly/></td>
          <td>
          <input type="text" name="boards[${loop.index}].boardCont" value="${board.boardCate}" readonly/>
            <!-- ><select name="boards[${loop.index}].boardCate">
              <option value="일상" ${board.boardCate=='일상'?'selected':''}>일상</option>
              <option value="생활정보" ${board.boardCate=='생활정보'?'selected':''}>생활정보</option>  
              <option value="건강, 운동" ${board.boardCate=='건강, 운동'?'selected':''}>건강, 운동</option>                
            </select>   -->
          </td>
          <td><fmt:formatDate value="${board.boardDate}" pattern="yyyy-MM-dd HH:mm"/></td>
          <td>${board.boardCount}</td>
          <td>${board.boardLike}</td>
          <td>${board.boardRe}</td>
          <td>
            <c:choose>
              <c:when test="${not empty board.boardImg1}">
                <img src="${contextPath}/resources/images/board/${board.boardImg1}" alt="이미지1" style="width:50px;"/>
              </c:when>
              <c:otherwise>없음</c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${not empty board.boardImg2}">
                <img src="${contextPath}/resources/images/board/${board.boardImg2}" alt="이미지2" style="width:50px;"/>
              </c:when>
              <c:otherwise>없음</c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${not empty board.boardImg3}">
                <img src="${contextPath}/resources/images/board/${board.boardImg3}" alt="이미지3" style="width:50px;"/>
              </c:when>
              <c:otherwise>없음</c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${not empty board.boardImg4}">
                <img src="${contextPath}/resources/images/board/${board.boardImg4}" alt="이미지4" style="width:50px;"/>
              </c:when>
              <c:otherwise>없음</c:otherwise>
            </c:choose>
          </td>
          <td>
            <!-- 수정 페이지로 이동하는 링크 추가 -->
            <a href="${contextPath}/board/admin/editAdmin/${board.boardId}">수정</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty boardList}"> <!-- result.list 대신 boardList 사용 -->
        <tr>
          <td colspan="14">검색결과가 없습니다.</td> <!-- 컬럼 수에 맞게 colspan 조정 -->
        </tr>
      </c:if>
    </tbody>
  </table>
  <div class="submit-btn-class">
    <!-- '저장' 버튼은 이제 개별 수정 페이지에서 사용되므로 여기서는 삭제하거나, 일괄 수정 기능으로 변경할 수 있습니다. -->
    <!-- 현재는 일괄 삭제만 남겨두는 것이 좋습니다. -->
    <button type="submit" name="action" value="delete" onclick="return confirm('선택한 게시글을 삭제하시겠습니까?');">선택 삭제</button>
  </div>
</form>


<!-- 페이징 -->
<div class="pagination">
	<c:set var="startPage" value="${result.currentPage - (result.currentPage - 1) % 5}" />
	<c:set var="endPage" value="${startPage + 4}" />
	<c:set var="totalPage" value="${(result.totalCount + result.pageSize - 1) / result.pageSize}" />

	<c:if test="${startPage > 1}">
		<a href="${currentUri}?page=${startPage - 1}&searchKeyword=${searchKeyword}&searchType=${searchType}">&laquo;</a>
	</c:if>

	<c:forEach var="p" begin="${startPage}" end="${endPage}">
		<c:if test="${p <= totalPage}">
			<a href="${currentUri}?page=${p}&searchKeyword=${searchKeyword}&searchType=${searchType}" class="${p == result.currentPage ? 'active-page' : ''}">${p}</a>
		</c:if>
	</c:forEach>

	<c:if test="${endPage < totalPage}">
		<a href="${currentUri}?page=${endPage + 1}&searchKeyword=${searchKeyword}&searchType=${searchType}">&raquo;</a>
	</c:if>
</div>

<script>
	function toggleAll(source) {
	    const checkboxes = document.querySelectorAll('input[name="selectedIds"]');
	    for (const checkbox of checkboxes) {
	        checkbox.checked = source.checked;
	    }
	}
</script>

</body>
</html>