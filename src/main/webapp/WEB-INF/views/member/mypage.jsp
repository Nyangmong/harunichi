<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- 스타일 css -->
<link href="${contextPath}/resources/css/member/mypage.css" rel="stylesheet" type="text/css" media="screen">
<body>
	<section class="mypage-wrap">
		<div class="mypage-inner-header">
			<!-- 왼쪽: 뒤로가기 -->
			<a href="javascript:void(0);" onclick="history.back();">
				<img src="${contextPath}/resources/icon/back_icon.svg" alt="뒤로가기버튼">
			</a>
		</div>
		<div class="mypage-profile-area">
			<div class="profile-area-left">
				<c:choose>
				    <c:when test="${not empty pageOwner.profileImg}">
				        <img src="${contextPath}/images/profile/${pageOwner.profileImg}" alt="프로필 이미지">
				    </c:when>
				    <c:otherwise>
				        <img src="${contextPath}/resources/icon/basic_profile.jpg" alt="기본 이미지">
				    </c:otherwise>
				</c:choose>
			</div>
			<div class="profile-area-middle">
				<div class="nick-and-email">
					<span>${pageOwner.nick}</span>
					<span>${pageOwner.email}</span>
				</div>
				<div class="join-date">
					<img src="${contextPath}/resources/icon/calendar_icon.svg"><p>가입일: <fmt:formatDate value="${pageOwner.joindate}" pattern="yyyy년 M월 d일" /></p>
				</div>
				<div class="follow-area">
					<a href="${contextPath}/follow/mypageFollow?id=${pageOwner.id}&type=following">
					  <span id="followingCountNum">${followingCount}</span> 팔로우중
					</a>
					
					<a href="${contextPath}/follow/mypageFollow?id=${pageOwner.id}&type=follower">
					  <span id="followerCountNum">${followerCount}</span> 팔로워
					</a>
				</div>
				<div class="chat-edit-follow">
					<!-- 나의 마이페이지면 수정 버튼 표시 -->
					<c:if test="${isMyPage}">
					    <a href="${contextPath}/member/updateMyInfoForm.do" class="edit-btn">프로필 수정</a>
					</c:if>
					<!-- 타인 프로필이면 팔로우 버튼과 채팅아이콘 표시 -->
					<c:if test="${not isMyPage}">
					    <button id="followBtn" class="follow-btn follow" onclick="follow('${contextPath}', '${pageOwner.id}')">팔로우</button>
					    <!-- 채팅 폼 -->
						<form id="chatForm" action="${contextPath}/chat/createChat" method="POST" style="display:none;">
						    <input type="hidden" name="receiverId" value="${pageOwner.id}">
						    <input type="hidden" name="chatType" value="personal">
						</form>
						<!-- 채팅 버튼 -->
						<a href="javascript:void(0);" class="chat-btn" onclick="chatOpen();">
						    <img src="${contextPath}/resources/icon/chat_line_icon.svg" class="on-icons">
						</a>
					</c:if>
				</div>
			</div>
		</div>
		<div class="mypage-contents-area">
			<div class="mypage-contents-tab">
			    <div class="mypage-contents-tab-inner">
			    	<a href="javascript:void(0);" data-url="${contextPath}/member/myBoardList?id=${pageOwner.id}">
				        <c:choose>
				            <c:when test="${isMyPage}">나의 게시글</c:when>
				            <c:otherwise>${pageOwner.nick}님의 게시글</c:otherwise>
				        </c:choose>
				    </a>
				    <a href="javascript:void(0);" data-url="${contextPath}/member/myLikeBoardList?id=${pageOwner.id}">좋아요한 게시글</a>
				        <a href="javascript:void(0);" data-url="${contextPath}/product/myList?id=${pageOwner.id}">
					        <c:choose>
					            <c:when test="${isMyPage}">나의 거래글</c:when>
					            <c:otherwise>${pageOwner.nick}님의 거래글</c:otherwise>
					        </c:choose>
					    </a>
				    <a href="javascript:void(0);" data-url="${contextPath}/like/myLike?id=${pageOwner.id}">좋아요한 거래글</a>
				    <c:if test="${isMyPage}">
					    <a href="javascript:void(0);" data-url="${contextPath}/payment/orderList">나의 주문 내역</a>
					</c:if>
				</div>
			</div>
			
			<div class="mypage-contents-con">
			    <!-- AJAX로 내용이 이 영역에 렌더링됨 -->
			</div>
		</div>
	</section>
	
	<script type="text/javascript">
	
	    //페이지 로드 시 
	    document.addEventListener("DOMContentLoaded", function() {
	    	
	    	console.log("pageOwner.id: ${pageOwner.id}");
	    	console.log("session member id: ${sessionScope.member.id}");

	    	// board-side 강제 숨기기 추가
	        const boardSideEls = document.querySelectorAll('.board-side');
	        boardSideEls.forEach(function(el) {
	            el.style.display = 'none';
	        });
	        
	     	// 팔로우 상태를 확인하고 버튼을 초기화
	        const contextPath = '${contextPath}';
	        const followeeId = '${pageOwner.id}';
	        const myId = '${sessionScope.member != null ? sessionScope.member.id : ""}';
	
	        const btn = document.getElementById("followBtn");
	        if (btn) {
	            // 서버에 팔로우 여부를 요청하여 버튼 상태 설정
	            fetch(contextPath + "/follow/isFollowing?followeeId=" + encodeURIComponent(followeeId))
	                .then(response => response.json())
	                .then(isFollowing => {
	                    if (isFollowing) {
	                        setFollowingButton(contextPath, followeeId, myId);
	                    }
	                });
	        }
	        
	        
	        // 탭 이벤트 등록
	        const tabs = document.querySelectorAll('.mypage-contents-tab-inner a');
	        const contentCon = document.querySelector('.mypage-contents-con');

	        tabs.forEach(tab => {
	            tab.addEventListener('click', function() {
	                const url = this.getAttribute('data-url');
	                if (url) {
	                    fetch(url)
	                        .then(response => response.text())
	                        .then(html => {
	                            contentCon.innerHTML = html;
	                         	// DOM 완전히 반영된 후 번역 적용
	                            requestAnimationFrame(() => {
	                                translateAJAXContent();
	                            });
	                        })
	                        .catch(() => {
	                            contentCon.innerHTML = '<p>불러오기 실패</p>';
	                        });
	                }
	                
	             	// 활성화 클래스 처리
	                tabs.forEach(t => t.classList.remove('active-tab'));
	                this.classList.add('active-tab');
	            });
	        });

	        // 첫 탭 자동 클릭
	        const firstTab = document.querySelector('.mypage-contents-tab-inner a[data-url]');
	        if (firstTab) {
	            firstTab.click();
	        }
	        
	    });
		
	    // 팔로잉 상태 버튼으로 설정하고 언팔로우 관련 이벤트를 등록
	    function setFollowingButton(contextPath, followeeId, myId) {
	        const btn = document.getElementById("followBtn");
	        btn.textContent = "팔로잉";
	        btn.classList.remove("follow", "unfollow");
	        btn.classList.add("following");
	
	        // 마우스 올리면 '언팔로우' 표시
	        btn.onmouseenter = function() {
	            btn.textContent = "언팔로우";
	            btn.classList.remove("following");
	            btn.classList.add("unfollow");
	        };
	
	        // 마우스 내리면 다시 '팔로잉' 표시
	        btn.onmouseleave = function() {
	            btn.textContent = "팔로잉";
	            btn.classList.remove("unfollow");
	            btn.classList.add("following");
	        };
	
	        // 클릭 시 언팔로우 동작 실행
	        btn.onclick = function() {
	            unfollow(contextPath, followeeId, myId);
	        };
	    }
	
	    // 팔로우 상태 버튼으로 설정하고 팔로우 관련 이벤트를 등록
	    function setFollowButton(contextPath, followeeId, myId) {
	        const btn = document.getElementById("followBtn");
	        btn.textContent = "팔로우";
	        btn.classList.remove("following", "unfollow");
	        btn.classList.add("follow");
	
	        // 이벤트 초기화
	        btn.onmouseenter = null;
	        btn.onmouseleave = null;
	
	        // 클릭 시 팔로우 동작 실행
	        btn.onclick = function() {
	            follow(contextPath, followeeId, myId);
	        };
	    }
	
	    // 팔로우 요청을 서버로 보내고 성공 시 버튼 및 팔로워/팔로잉 수 갱신
	    function follow(contextPath, followeeId, myId) {
	        fetch(contextPath + "/follow/add", {
	            method: "POST",
	            headers: { "Content-Type": "application/x-www-form-urlencoded" },
	            body: "followeeId=" + encodeURIComponent(followeeId)
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data === "success") {
	                setFollowingButton(contextPath, followeeId, myId);
	                updateFollowerCount(contextPath, followeeId); // 상대 팔로워 수 갱신
	                if (followeeId === myId) {
	                    updateFollowingCount(contextPath, myId); // 내 팔로잉 수 갱신 (내 프로필일 때만)
	                }
	            } else {
	                alert("팔로우 실패");
	            }
	        })
	        .catch(() => alert("서버 오류"));
	    }
	
	    // 언팔로우 요청을 서버로 보내고 성공 시 버튼 및 팔로워/팔로잉 수 갱신
	    function unfollow(contextPath, followeeId, myId) {
	        if (confirm("언팔로우하시겠습니까?")) {
	            fetch(contextPath + "/follow/remove", {
	                method: "POST",
	                headers: { "Content-Type": "application/x-www-form-urlencoded" },
	                body: "followeeId=" + encodeURIComponent(followeeId)
	            })
	            .then(response => response.text())
	            .then(data => {
	                if (data === "success") {
	                    setFollowButton(contextPath, followeeId, myId);
	                    updateFollowerCount(contextPath, followeeId); // 상대 팔로워 수 갱신
	                    if (followeeId === myId) {
	                        updateFollowingCount(contextPath, myId); // 내 팔로잉 수 갱신 (내 프로필일 때만)
	                    }
	                } else {
	                    alert("언팔로우 실패");
	                }
	            })
	            .catch(() => alert("서버 오류"));
	        }
	    }
	
	    // 상대방 팔로워 수를 서버에서 가져와 화면에 갱신
	    function updateFollowerCount(contextPath, followeeId) {
	        fetch(contextPath + "/follow/followerCount?followeeId=" + encodeURIComponent(followeeId))
	        .then(response => response.text())
	        .then(count => {
	            document.getElementById("followerCountNum").textContent = count;
	        });
	    }
	
	    // 내 팔로잉 수를 서버에서 가져와 화면에 갱신
	    function updateFollowingCount(contextPath, followerId) {
	        fetch(contextPath + "/follow/followingCount?followerId=" + encodeURIComponent(followerId))
	        .then(response => response.text())
	        .then(count => {
	            document.getElementById("followingCountNum").textContent = count;
	        });
	    }
	    
	    //채팅 아이콘 클릭시
	    function chatOpen(){
		    document.getElementById("chatForm").submit();
		}
	    
	    
	    //ajax요소도 번역
	    let translationCache = {};  // 번역 캐시 초기화

	    function translatePageContent() {
	        const selectedCountry = "${selectedCountry}"; // 페이지 로딩 시 선택된 국가

	        if (selectedCountry === 'kr' || selectedCountry === 'jp') {
	            const nodes = [];

	            // 페이지 내용 순회
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
	    }

	    function translateAJAXContent() {
	        // 페이지 내용이 로드된 후에 번역을 적용
	        translatePageContent();
	    }

	    const observer = new MutationObserver(function(mutations) {
	        mutations.forEach(function(mutation) {
	            if (mutation.type === 'childList' && mutation.target.classList.contains('mypage-contents-con')) {
	                translateAJAXContent(); // .mypage-contents-con 영역에 콘텐츠가 추가될 때만 번역
	            }
	        });
	    });

	    const contentArea = document.querySelector('.mypage-contents-con');
	    if (contentArea) {
	        observer.observe(contentArea, { childList: true, subtree: true });
	    }
	</script>

</body>