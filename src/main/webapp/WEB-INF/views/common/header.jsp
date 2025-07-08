<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />



<section class="header-inner">

    <a href="${contextPath}" class="header-logo"><img src="${contextPath}/resources/icon/logo2.svg"></a>
    
    <div class="header-main-content">
    	<div> </div>
	    <nav class="header-menu">
	        <ul>
	            <li>
	                <select id="country-select" name="country">
	                    <option value="kr" data-image="${contextPath}/resources/icon/south-korea_icon.png"${selectedCountry == 'kr' ? 'selected' : ''}>korea</option>
	                    <option value="jp" data-image="${contextPath}/resources/icon/japan_icon.png"${selectedCountry == 'jp' ? 'selected' : ''}>Japan</option>
	                </select>
	            </li>
	            <li>
	            	<c:if test="${sessionScope.id == 'admin'}">
					    <a href="${contextPath}/admin" class="go-to-admin-page-btn">어드민 페이지</a>
					</c:if>
	            </li>
	            <li>
	            	<%-- 세션에 id 값이 있을 경우 --> 로그인, 채팅, 알림 아이콘 노출 --%>
	            	<c:if test="${not empty sessionScope.id}">
	            		<div class="login-status">
		            		<div class="profile-area-wrap">
		            			<a class="profile-area" onclick="toggleUserMenu(event)" style="cursor: pointer;">
									<%-- 세션에 profileImg 값이 있을 경우 이미지 경로 사용, 없으면 기본 이미지 --%>
									<c:choose>
								    	<c:when test="${not empty sessionScope.member.profileImg}">
								        	<img class="profile-image" src="${pageContext.request.contextPath}/images/profile/${sessionScope.member.profileImg}" alt="프로필 이미지">
								    	</c:when>
								    	<c:otherwise>
								        	<img class="profile-image" src="${contextPath}/resources/icon/basic_profile.jpg">
								    	</c:otherwise>
									</c:choose>
		                        	<!-- <span>${sessionScope.member.nick}</span>  -->
				            	</a>
				            	<!-- 프로필클릭시 모달창 -->
				            	<div id="userMenuLayer"><jsp:include page="../member/profileWindow.jsp" /></div>
		            		</div>
				            <!-- 나머지 아이콘들 -->
			            	<a href="#"><img src="${contextPath}/resources/icon/chat_icon.svg" class="on-icons"></a>
			            	<a href="#"><img src="${contextPath}/resources/icon/bell_icon.svg" class="on-icons"></a>
	            		</div>
	            	</c:if>
	            <%-- 세션에 id 값이 없을 경우 (비회원 상태) --> 로그인 링크 노출 --%>
	            	<c:if test="${empty sessionScope.id}">
                        <a href="${contextPath}/member/loginpage.do">
                            <span>로그인</span>
                        </a>
                    </c:if>
	            </li>
	            <li><a href="#"><img src="${contextPath}/resources/icon/grid_icon.svg" class="on-icons"></a></li>
	        </ul>
	    </nav>
    </div>
    
</section>