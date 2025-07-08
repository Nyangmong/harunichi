<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<% request.setCharacterEncoding("utf-8"); %>
<!-- 어드민이 아닐경우엔 접근 불가 처리 -->
<c:if test="${sessionScope.member == null || sessionScope.member.id ne 'admin'}">
  <script type="text/javascript">
    alert('잘못된 접근입니다.');
    history.back();
  </script>
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>harunichi admin</title>
	<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSansNeo.css' rel='stylesheet' type='text/css'><!-- 폰트 -->
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" /><!-- 구글아이콘 연결 -->
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" media="screen"><!-- 공통스타일 -->
    <link href="${contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body>
	<div id="wrap">
		<aside>
			<tiles:insertAttribute name="side" />
		</aside>
		<article>
			<div class="article-inner">
				<div class="scroll-area">
					<tiles:insertAttribute name="body" />
				</div>
			</div>
		</article>
	</div>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script><!-- 제이쿼리 -->
	<script type="text/javascript">
		//체크박스 - 전체 체크하게하는 로직
		$('#checkAll').on('change', function() {
			var checked = $(this).is(':checked');
			$('input[name="selectedIds"]').prop('checked', checked);
		});
//		$('#checkAll') → ID가 checkAll인 요소를 선택
//		.on('change', function() { ... }) → change 이벤트 바인딩
//		$(this).is(':checked') → 체크 여부 확인
//		$('input[name="selectedIds"]') → 개별 체크박스 모두 선택
//		.prop('checked', checked) → checked 속성 일괄 적용
	</script>
</body>
</html>