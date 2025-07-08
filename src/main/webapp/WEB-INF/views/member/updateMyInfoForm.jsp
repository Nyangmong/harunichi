<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
	<!-- 스타일 및 폰트 -->
	<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" /><!-- 셀렉트 라이브러리 -->
	<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSansNeo.css' rel='stylesheet' type='text/css'><!-- 폰트 -->
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" media="screen"><!-- 공통스타일 -->
    <link href="${contextPath}/resources/css/member/updateMyInfoForm.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body class="auto-translate">
<jsp:include page="../common/lightHeader.jsp" />
<section class="member-info-modification-wrap">
    <h2>회원정보 수정</h2>
    <form action="${contextPath}/member/updateMyInfoProcess.do" method="post" enctype="multipart/form-data">
        	<!-- 프로필 이미지 설정 -->
        	<div class="profile-image-area">
			    <c:choose>
			        <c:when test="${not empty member.profileImg}">
			            <img id="profileImage" src="${pageContext.request.contextPath}/images/profile/${sessionScope.member.profileImg}" alt="프로필 이미지">
			            <!-- [기본이미지] 버튼 : 현재 이미지가 기본 이미지 아닐 때만 표시 -->
            			<button type="button" id="resetProfileBtn">기본 이미지 적용</button>
            			<input type="hidden" name="resetProfile" id="resetProfile" value="false"><!-- 이미지를 기본이미지로 설정했을때 데이터보낼 히든인풋 -->
			        </c:when>
			        <c:otherwise>
			            <img id="profileImage" src="${contextPath}/resources/icon/basic_profile.jpg" alt="기본 프로필 이미지">
			        </c:otherwise>
			    </c:choose>
			
			    <div class="profile-img-upload">
			        <label for="profileImg" class="custom-file-label">프로필 이미지 선택</label>
			        <input type="file" id="profileImg" name="profileImg" accept="image/*" onchange="previewImage(this)">
			    </div>
			</div>
	        <!-- 관심사 설정 (체크박스) -->
			<div>
			    <div class="interest-buttons">
			        <label>
			            <input type="checkbox" name="myLike" value="여행" <c:if test="${fn:contains(member.myLike, '여행')}">checked</c:if>> 
			            <span>✈️ 여행</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="맛집" <c:if test="${fn:contains(member.myLike, '맛집')}">checked</c:if>> 
			            <span>🍽️ 맛집</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="코딩" <c:if test="${fn:contains(member.myLike, '코딩')}">checked</c:if>>
			            <span>💻 코딩</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="음악" <c:if test="${fn:contains(member.myLike, '음악')}">checked</c:if>>
			            <span>🎵 음악</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="영화" <c:if test="${fn:contains(member.myLike, '영화')}">checked</c:if>>
			            <span>🎬 영화</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="스포츠" <c:if test="${fn:contains(member.myLike, '스포츠')}">checked</c:if>>
			            <span>🏀 스포츠</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="패션" <c:if test="${fn:contains(member.myLike, '패션')}">checked</c:if>>
			            <span>👗 패션</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="게임" <c:if test="${fn:contains(member.myLike, '게임')}">checked</c:if>>
			            <span>🎮 게임</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="반려동물" <c:if test="${fn:contains(member.myLike, '반려동물')}">checked</c:if>>
			            <span>🐶 반려동물</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="요리" <c:if test="${fn:contains(member.myLike, '요리')}">checked</c:if>>
			            <span>🍳 요리</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="운동" <c:if test="${fn:contains(member.myLike, '운동')}">checked</c:if>>
			            <span>💪 운동</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="독서" <c:if test="${fn:contains(member.myLike, '독서')}">checked</c:if>>
			            <span>📚 독서</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="드라마" <c:if test="${fn:contains(member.myLike, '드라마')}">checked</c:if>>
			            <span>📺 드라마</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="웹툰" <c:if test="${fn:contains(member.myLike, '웹툰')}">checked</c:if>>
			            <span>🖌️ 웹툰</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="커피" <c:if test="${fn:contains(member.myLike, '커피')}">checked</c:if>>
			            <span>☕ 커피</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="차" <c:if test="${fn:contains(member.myLike, '차')}">checked</c:if>>
			            <span>🍵 차</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="사진" <c:if test="${fn:contains(member.myLike, '사진')}">checked</c:if>>
			            <span>📷 사진</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="DIY" <c:if test="${fn:contains(member.myLike, 'DIY')}">checked</c:if>>
			            <span>🛠️ DIY</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="영화감상" <c:if test="${fn:contains(member.myLike, '영화감상')}">checked</c:if>>
			            <span>🎥 영화감상</span>
			        </label>
			        <label>
			            <input type="checkbox" name="myLike" value="음악감상" <c:if test="${fn:contains(member.myLike, '음악감상')}">checked</c:if>>
			            <span>🎧 음악감상</span>
			        </label>
			    </div>
			</div>			
			<div class="member-form-inner">
				<div id="required-form">
					<div class="form-group id-area">
						<p>아이디</p>
					    <span>${member.id}</span> <!-- 그냥 출력만 -->
					    <input type="hidden" name="id" value="${member.id}" /> <!-- 서버 전송 필요 시 hidden -->
					</div>
					<div class="form-group">
						<input type="password" name="pass" id="pass" placeholder="비밀번호(6자 이상)" >
						<span class="error" id="error-pass"></span>
					</div>
					<div class="form-group">
						<input type="password" id="passConfirm" placeholder="비밀번호 확인" >
						<span class="password-match-icon" id="password-match-icon"></span>
						<span class="error" id="error-passConfirm"></span>
					</div>
					<div class="form-group">
					    <input type="text" name="name" id="name" value="${member.name}" placeholder="이름">
					</div>
					<div class="form-group">
					    <input type="text" name="nick" id="nick" value="${member.nick}" placeholder="닉네임">
					</div>
					<div class="form-group">
					    <input type="text" name="email" id="email" value="${member.email}" placeholder="이메일">
					</div>
					<div class="form-group">
					    <input type="text" name="year" id="year" maxlength="8" value="${member.year}" placeholder="생년월일 8자리">
					    <span class="error" id="error-year"></span>
					</div>
					<div class="select-country-area">
					    <label for="nationality-select" style="margin: 10px;">국적 선택</label>
					    <select id="nationality-select" name="contry">
					        <option value="kr" data-image="${contextPath}/resources/icon/south-korea_icon.png" <c:if test="${member.contry == 'kr'}">selected</c:if>>대한민국</option>
					        <option value="jp" data-image="${contextPath}/resources/icon/japan_icon.png" <c:if test="${member.contry == 'jp'}">selected</c:if>>일본</option>
					    </select>
					    
					</div>
				</div>
			</div>
			<hr>
			<div class="member-form-inner">
				<div id="other-form">
					<div class="form-group gender-group">
					    <input type="radio" id="male" name="gender" value="male" <c:if test="${member.gender == 'M'}">checked</c:if>>
					    <label for="male">남성</label>
					
					    <input type="radio" id="female" name="gender" value="female" <c:if test="${member.gender == 'F'}">checked</c:if>>
					    <label for="female">여성</label>
					
					    <input type="radio" id="none" name="gender" value="" <c:if test="${empty member.gender}">checked</c:if>>
					    <label for="none">선택안함</label>
					</div>
					
					<div class="form-group">
						<input type="text" name="tel" value="<c:out value='${fn:replace(member.tel, "+82", "0")}'/>" placeholder="전화번호 ('-'를 제외한 숫자)" oninput="this.value = this.value.replace(/[^0-9]/g, '');">						
  						<span class="error" id="error-tel"></span>
					</div>
					
					<!-- 주소 입력 필드 (읽기 전용) -->
					<div class="form-group">
					    <input type="text" id="address" name="address" value="<c:out value='${member.address}'/>" placeholder="주소 (주소찾기 버튼으로 설정)" readonly tabindex="-1" onfocus="this.blur();">
					    <button type="button" id="searchAddressBtn">주소 찾기</button>
					    <span class="error" id="error-address"></span>
					</div>
					<!-- 상세주소 입력란 (초기에는 비활성화) -->
					<div class="form-group">
						<input type="text" id="detailAddress" name="detailAddress" placeholder="상세 주소" disabled>
					</div>
				</div>
			</div>
			<div class="form-group">
				<button type="submit" id="nextBtn">수정완료</button>
			</div>
    </form>
</section>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script><!-- 제이쿼리 -->
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script><!-- 카카오주소api -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script><!-- 셀렉트 라이브러리 -->
<script type="text/javascript">
$(document).ready(function() {
	
	// Select2 국가 셀렉트 초기화
    function formatState(state) {
        if (!state.id) return state.text;
        return $('<span style="display:flex; align-items:center; height:33px; line-height:33px;">' +
                '<img src="' + state.element.dataset.image + '" class="country-icon" style="width: 18px; height: auto; margin-right: 5px;" /> ' +
                state.text + '</span>');
    }
    $('#country-select').select2({
        minimumResultsForSearch: -1,
        templateResult: formatState,
        templateSelection: formatState
    }).on('change', function() {
        const selectedCountry = $(this).val();
        console.log("선택된 국가:", selectedCountry);

        $.ajax({
            url: '${contextPath}/main/selectCountry',
            type: 'POST',
            data: { nationality: selectedCountry },
            success: function() {
                console.log("국가 정보 세션 저장 성공!");
                window.location.reload();
            },
            error: function(xhr, status, error) {
                console.error("국가 정보 세션 저장 실패:", status, error);
                alert("국가 정보 저장에 실패했습니다.");
            }
        });
    });
    
 	// 하단 국적 select2 초기화
    $('#nationality-select').select2({
        minimumResultsForSearch: -1,
        templateResult: formatState,
        templateSelection: formatState
    });
 
	// 주소 입력폼
	 // 주소 찾기 버튼 클릭 이벤트
	    $('#searchAddressBtn').on('click', function() {
	    	const nationality = $('#nationality-select').val()?.toLowerCase();

	        if (nationality === 'kr') {
	            searchKoreanAddress();
	        } else if (nationality === 'jp') {
	            searchJapaneseAddress();
	        } else {
	            alert('지원되지 않는 국가입니다.');
	        }
	    });

	    function searchKoreanAddress() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                const fullAddr = data.address;
	                $('#address').val(fullAddr);
	                $('#detailAddress').prop('disabled', false);
	                $('#detailAddress').focus();
	            }
	        }).open();
	    }

	    function searchJapaneseAddress() {
	        const zip = prompt("郵便番号を入力してください（例：1000001）");

	        if (!zip) return;

	        fetch("https://zipcloud.ibsnet.co.jp/api/search?zipcode=" + zip)
	            .then(response => response.json())
	            .then(data => {
	                if (data.results) {
	                    const result = data.results[0];
	                    const address = result.address1 + " " + result.address2 + " " + result.address3;
	                    $('#address').val(address);
	                    $('#detailAddress').prop('disabled', false);
	                    $('#detailAddress').focus();
	                } else {
	                    alert("住所が見つかりませんでした。郵便番号を確認してください。");
	                }
	            })
	            .catch(error => {
	                console.error('住所検索エラー:', error);
	                alert("住所検索中にエラーが発生しました。");
	            });
	    }
	    
	    $('#editAddressBtn').on('click', function() {
	        $('#addressEditSection').show();
	    });

	// 생년월일 입력 처리
	$('#year').on('input', function () {
	    let raw = $(this).val().replace(/\D/g, '');
	    if (raw.length > 8) raw = raw.substring(0, 8);

	    if (raw.length === 8) {
	        const year = parseInt(raw.substring(0, 4), 10);
	        const month = parseInt(raw.substring(4, 6), 10);
	        const day = parseInt(raw.substring(6, 8), 10);

	        let isValid = true;
	        if (month < 1 || month > 12) {
	            isValid = false;
	        } else {
	            const lastDay = new Date(year, month, 0).getDate();
	            if (day < 1 || day > lastDay) {
	                isValid = false;
	            }
	        }

	        if (!isValid) {
	            $('#error-year').text('올바른 생년월일을 입력해주세요.');
	            $(this).val(raw.substring(0, 6)); // 잘못된 날은 잘라서 보여줌
	        } else {
	            $('#error-year').text('');
	            const formatted = raw.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
	            $(this).val(formatted);
	        }
	    } else {
	        $('#error-year').text('');
	        $(this).val(raw);
	    }
	});
	
	
	
	//비밀번호 처리
	const $passInput = $('#pass');
    const $passConfirmInput = $('#passConfirm');
    const $passwordMatchIcon = $('#password-match-icon');
    const $errorPass = $('#error-pass');
    const $errorPassConfirm = $('#error-passConfirm');
    const $nextBtn = $('#nextBtn');
    function checkPasswordState() {
        const pass = $passInput.val();
        const passConfirm = $passConfirmInput.val();

        // 초기화
        $passwordMatchIcon.text('').removeClass('match mismatch');
        $errorPass.text('');
        $errorPassConfirm.text('');

        if (pass.trim() === "") {
            // 공백이면 버튼 활성화
            $nextBtn.prop('disabled', false);
            return;
        }

        if (pass.length < 6) {
            $errorPass.text('비밀번호는 6자 이상 입력해주세요.');
            $nextBtn.prop('disabled', true);
            return;
        }

        if (passConfirm.trim() === "") {
            // 비밀번호 확인 공백
            $errorPassConfirm.text('비밀번호 확인을 입력해주세요.');
            $nextBtn.prop('disabled', true);
            return;
        }

        if (pass === passConfirm) {
            $passwordMatchIcon.text('✅').addClass('match');
            $nextBtn.prop('disabled', false);
        } else {
            $passwordMatchIcon.text('❌').addClass('mismatch');
            $errorPassConfirm.text('비밀번호가 일치하지 않습니다.');
            $nextBtn.prop('disabled', true);
        }
    }
    $passInput.on('input', checkPasswordState);
    $passConfirmInput.on('input', checkPasswordState);
	
	
});


//이미지 업로드
function previewImage(input) {
    const file = input.files[0];
    if (!file) return;

    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (!allowedTypes.includes(file.type)) {
        alert("이미지 파일만 업로드 가능합니다 (JPG, PNG, GIF)");
        input.value = "";
        return;
    }

    const reader = new FileReader();
    reader.onload = function (e) {
        document.getElementById('profileImage').src = e.target.result;
    }
    reader.readAsDataURL(file);
}
//비밀번호 입력 후 포커스 벗어났을 때 6자 이상인지 체크
$('#pass').on('blur', function() {
    const pass = $(this).val();
    const $errorSpan = $('#error-pass');

    if (pass.length < 6) {
        $errorSpan.text('비밀번호는 6자 이상 입력해주세요.');
    } else {
        $errorSpan.text('');
    }
});

	//기본이미지 버튼 클릭시 프로필이미지 기본이미지로 변경
    $('#resetProfileBtn').on('click', function() {
        // 기본 이미지로 src 변경
        $('#profileImage').attr('src', '${contextPath}/resources/icon/basic_profile.jpg');
        // 파일 업로드 input 비움
        $('#profileImg').val('');
     // 버튼 숨김
        $(this).hide();
     // resetProfile hidden input 값을 true로 설정
        $('#resetProfile').val('true');
    });
    //다시 프로필이미지를 업로드했을때 기본이미지버튼 나타남
    $('#profileImg').on('change', function() {
    	$('#resetProfile').val('false'); // 파일 업로드 시 기본이미지 초기화 플래그 해제
        $('#resetProfileBtn').show();
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
</html>
