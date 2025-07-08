<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 입력</title>
<!-- 스타일 및 폰트 -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" /><!-- 셀렉트 라이브러리 -->
<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSansNeo.css' rel='stylesheet' type='text/css'><!-- 폰트 -->
<link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" media="screen"><!-- 공통스타일 -->
<link href="${contextPath}/resources/css/member/addMemberWriteForm.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body class="auto-translate">
<jsp:include page="../common/lightHeader.jsp" />
<section class="add-member-write-form-wrap">
    <h2>회원정보를 입력해주세요.</h2>
    <form id="memberForm" action="addMemberProcess.do" method="post">
        <input type="hidden" id="userNationality" value="${sessionScope.memberVo.contry}" /><!-- 주소api를 위해 국가 정보를 가져오는 히든인풋 -->
        <div class="member-form-inner">
            <p>*필수입력</p>
            <div id="required-form">
                <div class="form-group">
                    <input type="text" name="id" id="id" placeholder="아이디(영문, 숫자 조합)" oninput="this.value = this.value.replace(/[^a-zA-Z0-9]/g, '');">
                    <div id="idCheckText">
                        <span class="error" id="error-id"></span>
                        <span class="error" id="id-check-result"></span>
                        <span class="info" id="id-check-required">아이디 중복확인을 해주세요</span>
                    </div>
                    <button type="button" id="checkIdBtn">중복확인</button>
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
                    <input type="text" name="name" id="name" placeholder="이름" >
                    <span class="error" id="error-name"></span>
                </div>
                <div class="form-group">
                    <input type="text" name="nick" id="nick" placeholder="닉네임">
                    <span class="error" id="error-nick"></span>
                </div>
                <div class="form-group">
                    <input type="text" name="year" id="year" maxlength="8" placeholder="생년월일 8자리">
                    <span class="error" id="error-year"></span>
                </div>
            </div>
        </div>
        <hr>
        <div class="member-form-inner">
            <p>선택입력</p>
            <div id="other-form">
                <div class="form-group gender-group">
                    <input type="radio" id="male" name="gender" value="male">
                    <label for="male">남성</label>

                    <input type="radio" id="female" name="gender" value="female">
                    <label for="female">여성</label>

                    <input type="radio" id="none" name="gender" value="">
                    <label for="none">선택안함</label>
                </div>

                <div class="form-group">
                    <input type="text" name="tel" placeholder="전화번호 ('-'를 제외한 숫자)" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" />
                    <span class="error" id="error-tel"></span>
                </div>

                <!-- 주소 입력 필드 (읽기 전용) -->
                <div class="form-group">
                    <input type="text" id="address" name="address" placeholder="주소 (주소찾기 버튼으로 설정)" readonly tabindex="-1" onfocus="this.blur();">
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
            <button type="submit" id="nextBtn" disabled>입력완료</button>
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
                location.reload(); // 페이지 새로고침
            },
            error: function(xhr, status, error) {
                console.error("국가 정보 세션 저장 실패:", status, error);
                alert("국가 정보 저장에 실패했습니다.");
            }
        });
    });

    // 주소 찾기 버튼 클릭 이벤트
    $('#searchAddressBtn').on('click', function() {
        const nationality = $('#userNationality').val()?.toLowerCase();

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

    // 아이디 입력 시 안내문 표시
    $('#id').on('input', function () {
        checkIdConfirmed = false;
        $('#id-check-result').text('');
        const id = $(this).val().trim();
        $('#id-check-required').toggle(id !== "");
        toggleNextButton();
    });
    
    // 아이디 중복 확인 문구
    $('#id-check-required').hide();
    $('#id').on('input', function () {
        checkIdConfirmed = false;
        $('#id-check-result').text('');
        const id = $(this).val().trim();
    
        // 조건: 입력은 했는데 중복확인 안 누른 경우에만 보이게
        if (id !== "") {
            $('#id-check-required').show();
        } else {
            $('#id-check-required').hide();
        }
    
        toggleNextButton();
    });
    // 아이디 중복 확인
    let checkIdConfirmed = false;
    $('#checkIdBtn').on('click', function() {
        $('#id-check-required').hide();
        const id = $('#id').val().trim();
        const $resultSpan = $('#id-check-result');
        const $errorSpan = $('#error-id');
        $('.error').text('');
        $resultSpan.text('');

        if (id === "") {
            $resultSpan.css('color', 'red').text('아이디를 입력해주세요.');
            checkIdConfirmed = false;
            toggleNextButton();
            return;
        }

        $.ajax({
            url: '${contextPath}/member/checkId.do',
            type: 'GET',
            data: { id: id },
            dataType: 'json',
            success: function(data) {
                if (data.exists) {
                    $resultSpan.css('color', 'red').text('이미 사용 중인 아이디입니다.');
                    checkIdConfirmed = false;
                } else {
                    $resultSpan.css('color', '#A3DAFF').text('사용 가능한 아이디입니다!');
                    checkIdConfirmed = true;
                }
                toggleNextButton();
            },
            error: function(xhr, status, error) {
                console.error("오류:", error);
                $resultSpan.css('color', 'red').text('아이디 중복 확인 중 오류 발생.');
                checkIdConfirmed = false;
                toggleNextButton();
            }
        });
    });
    
    // 비밀번호 입력 후 포커스 벗어났을 때 6자 이상인지 체크
    $('#pass').on('blur', function() {
        const pass = $(this).val();
        const $errorSpan = $('#error-pass');

        if (pass.length < 6) {
            $errorSpan.text('비밀번호는 6자 이상 입력해주세요.');
        } else {
            $errorSpan.text('');
        }
    });

    // 비밀번호 일치 확인
    const $passInput = $('#pass');
    const $passConfirmInput = $('#passConfirm');
    const $passwordMatchIcon = $('#password-match-icon');

    function updatePasswordMatchIcon() {
        const pass = $passInput.val();
        const passConfirm = $passConfirmInput.val();
        const $errorSpan = $('#error-passConfirm');

        $errorSpan.text('');
        $passwordMatchIcon.text('').removeClass('match mismatch');

        if (passConfirm.trim() === "") return false;
        if (pass === passConfirm) {
            $passwordMatchIcon.text('✅').addClass('match');
            return true;
        } else {
            $passwordMatchIcon.text('❌').addClass('mismatch');
            return false;
        }
    }

    $('#passConfirm').on('blur', function() {
        const pass = $passInput.val();
        const passConfirm = $passConfirmInput.val();
        const $errorSpan = $('#error-passConfirm');

        if (passConfirm.trim() === "") {
            $errorSpan.text('비밀번호 확인을 입력해주세요.');
        } else if (pass !== passConfirm) {
            $errorSpan.text('비밀번호가 일치하지 않습니다.');
        } else {
            $errorSpan.text('');
        }
    });

    // 필수 필드 체크 함수 + 다음 버튼 활성화
    const $requiredFields = $('#id, #pass, #passConfirm, #name, #nick, #year');
    const $nextBtn = $('#nextBtn');

    function areRequiredFieldsFilled() {
        let allFilled = true;
        $requiredFields.each(function() {
            if ($(this).val().trim() === "") {
                allFilled = false;
                return false;
            }
        });
        return allFilled;
    }

    function toggleNextButton() {
        if (areRequiredFieldsFilled() && checkIdConfirmed && updatePasswordMatchIcon()) {
            $nextBtn.prop('disabled', false);
        } else {
            $nextBtn.prop('disabled', true);
        }
    }

    $requiredFields.on('input change', function() {
        if ($(this).attr('id') === 'pass' || $(this).attr('id') === 'passConfirm') {
            updatePasswordMatchIcon();
        }
        toggleNextButton();
    });

    toggleNextButton(); // 초기 상태
    
    // 폼 전송 Ajax로 처리
    $('#memberForm').on('submit', function(e) {
        e.preventDefault(); // 기본 제출 막기

        const formData = $(this).serialize(); // 폼 데이터 직렬화

        $.ajax({
            url: '${contextPath}/member/addMemberProcess.do',
            type: 'POST',
            data: formData,
            success: function(response) {
                if (response === 'success') {
                    window.location.href = '${contextPath}/member/profileImgAndMyLikeSetting.do';
                } else {
                    alert("회원가입 처리 중 오류가 발생했습니다.");
                }
            },
            error: function(xhr, status, error) {
                console.error("서버 통신 오류:", error);
                alert("서버와 통신 중 문제가 발생했습니다.");
            }
        });
    });
});

</script>

<!-- 번역 -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    const selectedCountry = "${selectedCountry}";
    const translationCache = {};
    const targetLang = selectedCountry === 'jp' ? 'ja' : 'ko';

    if (selectedCountry === 'kr' || selectedCountry === 'jp') {
        const nodes = [];

        // body 전체 순회 (번역 제외 태그 설정)
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
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
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
