<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="profile-window">
	<div class="profile-window-in">
		<div class="profile-window-left">
			<!-- 프로필 이미지 -->
			<div class="profile-img-thumb">
				<c:choose>
					<c:when test="${not empty sessionScope.member.profileImg}">
						<img src="${pageContext.request.contextPath}/images/profile/${sessionScope.member.profileImg}" alt="프로필 이미지" />
					</c:when>
					<c:otherwise>
						<img src="${contextPath}/resources/icon/basic_profile.jpg" alt="기본 이미지" />
					</c:otherwise>
				</c:choose>
			</div>
			<!-- 프로필 수정 버튼 -->
			<a href="${contextPath}/member/updateMyInfoForm.do" class="adit-profile-img">
				<img src="${contextPath}/resources/icon/camera_icon.svg">
			</a>
		</div>

		<div class="profile-window-right">
			<!-- 이메일 -->
			<p class="profile-window-email">${sessionScope.member.email}</p>
			<!-- 닉네임 -->
			<p class="profile-window-nick">${sessionScope.member.nick}</p>
			<!-- 로그아웃 -->
			<a href="${contextPath}/member/logout.do" class="logout-btn">로그아웃</a>
		</div>
	</div>
	<a href="${contextPath}/member/updateMyInfoForm.do" class="adit-profile-thumb"> 프로필 수정하기 </a>
</div>