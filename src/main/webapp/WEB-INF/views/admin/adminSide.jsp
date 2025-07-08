<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%-- 현재 요청 URI를 JSP에서 직접 가져오기 (원래 요청 URI를 속성에서 가져옴) --%>
<c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri']}" />

<c:set var="uriWithoutCtx" value="${fn:substringAfter(uri, contextPath)}" />

<!-- 홈 메뉴 active -->
<c:set var="homeClass" value="" />
<c:if test="${uriWithoutCtx eq '/admin' || uriWithoutCtx eq '/admin/'}">
  <c:set var="homeClass" value="active" />
</c:if>

<!-- 게시글 메뉴 active -->
<c:set var="boardClass" value="" />
<c:if test="${fn:contains(uriWithoutCtx, '/board')}">
  <c:set var="memberClass" value="active" />
</c:if>

<!-- 회원 관리 메뉴 active -->
<c:set var="memberClass" value="" />
<c:if test="${fn:contains(uriWithoutCtx, '/member')}">
  <c:set var="memberClass" value="active" />
</c:if>

<!-- 채팅 메뉴 active 처리 -->
<c:set var="chatClass" value="" />
<c:if test="${fn:contains(uriWithoutCtx, '/chat')}">
  <c:set var="chatClass" value="active" />
</c:if>

<section class="side-wrap">
	<div class="logo-area">
		<img src="${contextPath}/resources/icon/admin_logo.png">
	</div>
	<div class="menu-area">
		<nav>
			<ul>

				<li>
					<a href="${contextPath}/admin" class="${homeClass}">
						<span>홈</span>
					</a>
				</li>
				<li>
					<a href="${contextPath}/board/admin" class="${boardClass}">
						<span>게시글 관리</span>
					</a>
				</li>
				<li>
					<a href="${contextPath}/admin/member" class="${memberClass}">
						<span>회원 관리</span>
					</a>
				</li>
				<li>
					<a href="${contextPath}/admin/chat" class="${chatClass}">
						<span>채팅 관리</span>
					</a>
				</li>
			</ul>
		</nav>
	</div>
	<div class="back-home">
		<a href="${contextPath}">홈페이지로 돌아가기</a>
	</div>
</section>

	
