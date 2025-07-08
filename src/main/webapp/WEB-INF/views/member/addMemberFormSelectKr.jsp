<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- 한국인 회원가입 폼 --%>
<section class="register-options">
    <%-- 이메일 인증 버튼 --%>
    <button type="button" id="email-auth-btn">
		<img src="${contextPath}/resources/icon/email_icon.svg" alt="이메일 아이콘">
        <span>이메일로 인증받기</span>
    </button>

    <%-- 카카오로 가입 버튼 --%>
    <button type="button" id="kakao-register-btn">
        <img src="${contextPath}/resources/icon/kakao_icon.png" alt="카카오 아이콘">
        <span>카카오로 회원가입</span>
    </button>

    <%-- 네이버로 가입 버튼 --%>
    <button type="button" id="naver-register-btn">
        <img src="${contextPath}/resources/icon/naver_icon.svg" alt="네이버 아이콘">
        <span>네이버아이디로 가입</span>
    </button>
    
</section>


<script>
	// 이메일 인증 버튼 클릭시
	$(document).on('click', '#email-auth-btn', function () {
		const selectedNationality = $('#nationality-select').val(); // 국적 셀렉트박스가 상단에 있다면
		window.location.href = '<c:url value="/member/emailAuthForm.do"/>?nationality=' + selectedNationality;
	});

	// 카카오로 회원가입 버튼 클릭시
    $(document).on('click', '#kakao-register-btn', function () {
        console.log('[카카오로 회원가입] 클릭됨');
        
        if (typeof Kakao === 'undefined' || !Kakao.isInitialized()) {
            alert('Kakao SDK 초기화되지 않았습니다.');
            return;
        }

        Kakao.Auth.authorize({
            redirectUri: 'http://localhost:8090/harunichi/member/KakaoCallback.do',
            state: 'join',
            scope: 'profile_nickname,account_email,name,gender,birthday,birthyear,phone_number,shipping_address'
        });
    });

	// 네이버로 회원가입 클릭시
    $(document).on('click', '#naver-register-btn', function () {
    	const clientId = 'v80rEgQ4aPt_g050ZNtj';
        const redirectUri = 'http://localhost:8090/harunichi/member/NaverCallback.do';
        const state = 'join'; // 회원가입 요청
		
        const encodedRedirectUri = encodeURIComponent(redirectUri);
		const naverJoinUrl = "https://nid.naver.com/oauth2.0/authorize"
			+ "?response_type=code"
			+ "&client_id=" + clientId
			+ "&redirect_uri=" + encodedRedirectUri
			+ "&state=" + state;
		
        window.location.href = naverJoinUrl;
    });
</script>
