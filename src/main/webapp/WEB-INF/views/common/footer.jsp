<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"    
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<section class="footer-inner">
		<img src="${contextPath}/resources/icon/logo1.svg" class="footer-logo">
		<ul class="footer-sns-ink">
			<li><a href="#"><img src="${contextPath}/resources/icon/instagram-icon.svg" alt="인스타그램"></a></li>
			<li><a href="#"><img src="${contextPath}/resources/icon/youtube-icon.svg" alt="유튜브"></a></li>
			<li><a href="#"><img src="${contextPath}/resources/icon/facebook-icon.svg" alt="페이스북"></a></li>
			<li><a href="#"><img src="${contextPath}/resources/icon/twitter-icon.svg" alt="트위터"></a></li>
		</ul>
		<ul class="footer-info">
			<li><a href="#">회사소개</a></li>
			<li><a href="#">인재채용</a></li>
			<li><a href="#">제휴제안</a></li>
			<li><a href="#">이용약관</a></li>
			<li><a href="#">개인정보처리방침</a></li>
			<li><a href="#">청소년보호정책</a></li>
			<li><a href="#">고객센터</a></li>
			<li><a href="#">ⓒ HARUNICHI Corp.</a></li>
		</ul>

</section>
