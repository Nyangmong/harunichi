<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="selectedCountry" value="${sessionScope.selectedCountry}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>이메일 인증</title>
	<!-- 스타일 및 폰트 -->
	<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" /><!-- 셀렉트 라이브러리 -->
	<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSansNeo.css' rel='stylesheet' type='text/css'><!-- 폰트 -->
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" media="screen"><!-- 공통스타일 -->
	<link href="${contextPath}/resources/css/member/emailAuthForm.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body class="auto-translate">
	<jsp:include page="../common/lightHeader.jsp" />
	<!-- 선택한 국가 정보 저장용 -->
	<input type="hidden" id="userNationality" value="">
	
	<section class="email-auth-wrap">
	
		<div class="email-auth-middle">
			<h2>이메일 인증</h2>
			<p>이메일 주소를 입력하고 인증을 진행해주세요.</p>
			<img src="${contextPath}/resources/icon/sky_email_icon.png" />
		</div>
		
		<form id="emailAuthForm" action="#" method="post" novalidate>
			<div class="form-group">
				<input type="email" id="email" name="email" placeholder="이메일 주소를 입력해주세요." required>
			</div>

			<button type="button" id="sendAuthCodeBtn">인증번호 발송</button>

			<div class="form-group" id="authCodeGroup" style="display: none;">
				<input type="text" id="authCode" name="authCode" placeholder="인증번호를 입력해주세요." required>
			</div>
			<div class="buttons">
				<button type="button" id="verifyAuthCodeBtn" style="display: none;">인증번호 확인</button>
				<button class="resend" type="button" id="resendAuthCodeBtn" style="display: none;">인증번호 재발송</button>
			</div>
		</form>
		
		<!-- 스피너 표시 -->
		<div id="loading-spinner" style="display: none; text-align: center; margin-top: 15px;">
  			<img src="${contextPath}/resources/icon/loading-circle2.gif" alt="로딩 중..." style="width: 32px;" />
  			<p style="color: #888;">잠시만 기다려주세요...</p>
		</div>
		
	</section>
	

<!-- 스크립트 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
$(document).ready(function () {
	// 국가 셀렉트박스 이미지 렌더링
	function formatState(state) {
		if (!state.id) return state.text;
		return $('<span style="display:flex; align-items:center; height:33px;">' +
			'<img src="' + state.element.dataset.image + '" class="country-icon" style="width: 18px; height: auto; margin-right: 5px;" /> ' +
			state.text + '</span>');
	}

	// 셀렉트박스 초기화
	$('#country-select').select2({
		minimumResultsForSearch: -1,
		templateResult: formatState,
		templateSelection: formatState
	});

	// 셀렉트박스 변경 시 → 세션 저장 후 새로고침
	$(document).on('change', '#country-select', function () {
		const selectedCountry = $(this).val();
		console.log("선택된 국가:", selectedCountry);

		$.ajax({
			url: '${contextPath}/main/selectCountry',
			type: 'POST',
			data: { nationality: selectedCountry },
			success: function () {
				console.log("국가 정보 저장 성공");
				location.reload(); // 반드시 새로고침
			},
			error: function (xhr, status, error) {
				console.error("국가 정보 저장 실패:", error);
				alert("국가 정보를 저장하지 못했습니다.");
			}
		});
	});

	// 히든 필드에 nationality 저장
	const urlParams = new URLSearchParams(window.location.search);
	const nationality = urlParams.get('nationality');
	$('#userNationality').val(nationality);

	// 인증번호 발송
	$('#sendAuthCodeBtn').on('click', function () {
		const email = $('#email').val();
		const nationality = $('#userNationality').val();

		if (!email) {
			alert("이메일 주소를 입력해주세요!");
			return;
		}

		const $btn = $(this).hide();
		$('#loading-spinner').show();

		$.post('${contextPath}/mail/sendAuthEmail.do', { email, nationality })
			.done(function (res) {
				$('#loading-spinner').hide();
				if (res === "success") {
					alert("인증 메일이 발송되었습니다.");
					$('#authCodeGroup, #verifyAuthCodeBtn, #resendAuthCodeBtn').show();
				} else {
					alert("메일 발송 실패");
					$btn.show();
				}
			})
			.fail(function () {
				alert("메일 발송 중 오류 발생");
				$('#loading-spinner').hide();
				$btn.show();
			});
	});

	// 인증번호 재발송
	$('#resendAuthCodeBtn').on('click', function () {
		const email = $('#email').val();
		const nationality = $('#userNationality').val();

		if (!email) {
			alert("이메일 주소를 입력해주세요!");
			return;
		}

		$(this).hide();
		$('#verifyAuthCodeBtn').hide();
		$('#loading-spinner').show();

		$.post('${contextPath}/mail/sendAuthEmail.do', { email, nationality })
			.done(function (res) {
				$('#loading-spinner').hide();
				if (res === "success") {
					alert("인증 메일이 재발송되었습니다.");
				} else {
					alert("재발송 실패");
				}
				$('#resendAuthCodeBtn, #verifyAuthCodeBtn').show();
			})
			.fail(function () {
				alert("재발송 중 오류 발생");
				$('#loading-spinner').hide();
				$('#resendAuthCodeBtn, #verifyAuthCodeBtn').show();
			});
	});

	// 인증번호 확인
	$('#verifyAuthCodeBtn').on('click', function () {
		const email = $('#email').val();
		const authCode = $('#authCode').val();

		if (!authCode) {
			alert("인증번호를 입력해주세요!");
			return;
		}

		$.post('${contextPath}/mail/verifyAuthCode.do', { email, authCode })
			.done(function (res) {
				if (res === "success") {
					alert("이메일 인증 완료!");
					$('#email').prop('disabled', true);
					$('#sendAuthCodeBtn, #authCodeGroup, #verifyAuthCodeBtn').hide();
					window.location.href = "${contextPath}/member/addMemberWriteForm.do";
				} else {
					alert("인증번호 불일치");
					$('#authCode').val('').focus();
				}
			})
			.fail(function () {
				alert("인증번호 확인 중 오류 발생");
			});
	});
});
</script>

<!-- Google 번역 API 자동 번역 -->
<script>
document.addEventListener("DOMContentLoaded", function () {
	const selectedCountry = "${selectedCountry}" || "kr";
	const targetLang = selectedCountry === 'jp' ? 'ja' : 'ko';
	const cache = {};

	if (selectedCountry === 'kr' || selectedCountry === 'jp') {
		const nodes = [];

		function traverse(node) {
			if (node.nodeType === 3 && node.nodeValue.trim()) {
				nodes.push(node);
			} else if (
				node.nodeType === 1 &&
				!['SCRIPT', 'SELECT', 'OPTION', 'TEXTAREA', 'INPUT'].includes(node.tagName)
			) {
				for (let i = 0; i < node.childNodes.length; i++) {
					traverse(node.childNodes[i]);
				}
			}
		}

		traverse(document.body);

		nodes.forEach(function (node) {
			const original = node.nodeValue.trim();
			if (cache[original]) {
				node.nodeValue = cache[original];
				return;
			}

			const params = new URLSearchParams({ text: original, lang: selectedCountry });

			fetch("${contextPath}/translate", {
				method: "POST",
				headers: { "Content-Type": "application/x-www-form-urlencoded" },
				body: params
			})
				.then(res => res.json())
				.then(data => {
					if (data.translatedText) {
						cache[original] = data.translatedText;
						node.nodeValue = data.translatedText;
					}
				})
				.catch(err => console.error("번역 실패", err));
		});
	}
});
</script>




	
</body>
</html>
