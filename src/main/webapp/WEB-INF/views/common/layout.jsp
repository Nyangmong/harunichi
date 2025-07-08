<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
request.setCharacterEncoding("utf-8");
%>

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<title><tiles:insertAttribute name="title" /></title>
	<!-- 스타일 및 폰트 -->
	<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" /><!-- 셀렉트 라이브러리 -->
	<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSansNeo.css' rel='stylesheet' type='text/css'><!-- 폰트 -->
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" /><!-- 구글아이콘 연결 -->
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" media="screen"><!-- 공통스타일 -->
    <link href="${contextPath}/resources/css/main.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body class="auto-translate">
	<div id="wrap">
		<header>
			<tiles:insertAttribute name="header" />
		</header>
		<div id="inner-wrap">
			<aside>
				<tiles:insertAttribute name="side" />
			</aside>
			<article>
				<button id="scrollTopBtn">
			    	<span class="material-symbols-outlined">arrow_upward</span>
			  	</button>
				<tiles:insertAttribute name="body" />
			</article>
		</div>
		<footer>
			<tiles:insertAttribute name="footer" />
		</footer>
	</div>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script><!-- 제이쿼리 -->
	<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script><!-- 셀렉트 라이브러리 -->
	<script>
		//국가선택 로직
		$(document).ready(function() {
			$('#country-select').select2({
				minimumResultsForSearch: -1,
				templateResult: formatState,
				templateSelection: formatState 
			});

			
			function formatState (state) {
				if (!state.id) {
					return state.text;
				}
				var $state = $(
					'<span><img src="' + state.element.dataset.image + '" class="country-icon" style="width: 18px; height: auto; margin-right: 5px; vertical-align: middle;" /> ' + state.text + '</span>'
				);
				return $state;
			}
		
			
			//선택된 국가를 세션에 저장
			$('#country-select').on('change', function() {
				var selectedCountry = $(this).val(); // 선택된 국가 코드 (kr 또는 jp)

				console.log("선택된 국가:", selectedCountry); // 콘솔에서 확인

				// 서버로 선택된 국가 정보 보내기 (AJAX 사용)
				$.ajax({
					url: '${contextPath}/main/selectCountry', // 서버에서 국가 정보를 처리할 주소
					type: 'POST', // 또는 GET 방식
					data: { nationality: selectedCountry }, // 서버로 보낼 데이터 (키:값 형태)
					success: function(response) {
						console.log("국가 정보 세션 저장 성공!");
						// 필요하다면 세션 저장 성공 후 추가 작업 수행 (예: 페이지 새로고침, 메시지 표시 등)
						window.location.reload(); // 예: 페이지 새로고침
					},
					error: function(xhr, status, error) {
						console.error("국가 정보 세션 저장 실패:", status, error);
						// 에러 발생 시 처리
					}
				});
			});
			
			    $(".mypage-contents-tab-inner a").click(function(){
			        var url = $(this).data("url");
			
			        $.get(url, function(data){
			            $(".mypage-contents-con").html(data);
			        }).fail(function(){
			            alert("목록을 불러오는 데 실패했습니다.");
			        });
			
			        // 선택된 탭 스타일 처리 (선택)
			        $(".mypage-contents-tab-inner a").removeClass("active");
			        $(this).addClass("active");
			    });
			
			    // 페이지 로드시 기본 탭 자동 클릭 (예: 나의 게시글)
			    $(".mypage-contents-tab-inner a").first().click();
			
		});
		
		
		//헤더 프로필 클릭시 모달 이벤트
		//토글로 나타나게하기
		function toggleUserMenu(event) {
		    event.preventDefault();
		    const menu = document.getElementById("userMenuLayer");
		    menu.style.display = (menu.style.display === "none" || menu.style.display === "") ? "block" : "none";
		}
		// 바깥 클릭 시 메뉴 닫기
		document.addEventListener("click", function(e) {
		    const menu = document.getElementById("userMenuLayer");
		    const trigger = document.querySelector(".profile-area");
		
		    // menu, profile-area 둘 다 클릭 영역이 아닐 때만 닫기
		    if (menu && trigger && !menu.contains(e.target) && !trigger.contains(e.target)) {
		        menu.style.display = "none";
		    }
		});
		
		//최상단 가기 버튼
		document.getElementById("scrollTopBtn").addEventListener("click", function() {
			window.scrollTo({
				top: 0,
				behavior: 'smooth' // 부드럽게 스크롤
			});
		});
		
	</script>
	
	<!-- 구글 번역api 활용 -->
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			const selectedCountry = "${selectedCountry}"; // EL은 이 자리에서만 안전하게 사용 가능
			const translationCache = {};
			const targetLang = selectedCountry === 'jp' ? 'ja' : 'ko';
	
			if (selectedCountry === 'kr' || selectedCountry === 'jp') {
				const nodes = [];
	
				// body 전체 순회
				function traverse(node) {
					if (node.nodeType === 3 && node.nodeValue.trim()) {
						nodes.push(node);
					} else if (node.nodeType === 1 && node.tagName !== 'SCRIPT') {
						for (let i = 0; i < node.childNodes.length; i++) {
							traverse(node.childNodes[i]);
						}
					}
				}
	
				traverse(document.body);
	
				nodes.forEach(function (node) {
					const original = node.nodeValue.trim();
					if (translationCache[original]) {
						node.nodeValue = translationCache[original];
						return;
					}
	
					const params = new URLSearchParams({
						text: original,
						lang: selectedCountry
					});
	
					fetch("${contextPath}/translate", {
						method: "POST",
						headers: {
							"Content-Type": "application/x-www-form-urlencoded"
						},
						body: params
					})
					.then(res => res.json())
					.then(data => {
						if (data.translatedText) {
							translationCache[original] = data.translatedText;
							node.nodeValue = data.translatedText;
						}
					})
					.catch(err => console.error("번역 실패", err));
				});
			}
		});
	</script>



</body>
