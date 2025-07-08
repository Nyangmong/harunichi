<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<!-- 스타일 css -->
<link href="${contextPath}/resources/css/member/followList.css" rel="stylesheet" type="text/css" media="screen">

<body>
	<section class="follow-wrap">
	
	    <div class="follow-inner-header">
			<a href="javascript:void(0);" onclick="history.back();">
	    		<img src="${contextPath}/resources/icon/back_icon.svg" alt="뒤로가기버튼">
			</a>
			<a class="follow-inner-header-user-info" href="${contextPath}/mypage?id=${pageOwner.id}">
				<p>${pageOwner.nick}</p>
				<span>${pageOwner.email}</span>
			</a>
		</div>
		
		<!-- 팔로우/팔로워 탭 -->
	    <div class="follow-tabs">
	    	<div>
	    	<a href="${contextPath}/follow/mypageFollow?id=${pageOwner.id}&type=following" class="${activeTab == 'following' ? 'active' : ''}">
			  <span>${followingCount}</span> 팔로우중
			</a>
			<a href="${contextPath}/follow/mypageFollow?id=${pageOwner.id}&type=follower" class="${activeTab == 'follower' ? 'active' : ''}">
			  <span>${followerCount}</span> 팔로워
			</a>
	    	</div>
		</div>
		
		<!-- 팔로우/팔로워 리스트 출력 -->
	    <div class="follow-list">
	        <c:forEach var="follow" items="${followList}">
	            <div class="follow-item">
	            	<div class="follow-item-inner">
		            	<a href="${contextPath}/mypage?id=${follow.id}">
		            		<div class="follow-item-img">
		            			<img src="${contextPath}/images/profile/${follow.profileImg != null ? follow.profileImg : 'basic_profile.jpg'}" alt="프로필">
		            		</div>
		                	<div class="follow-info">
		                    	<span>${follow.nick}</span>
		                    	<span>${follow.email}</span>
		                	</div>
		            	</a>
			        	<!-- 본인이 아닌 경우만 팔로우 버튼 표시 -->
		                <c:if test="${sessionScope.member.id ne follow.id}">
			            <button class="follow-btn" data-user-id="${follow.id}">로딩중...</button>
			            </c:if>
		            </div>
	            </div>
	           
	        </c:forEach>
	    </div>
	</section>
	
	<script type="text/javascript">
		document.addEventListener("DOMContentLoaded", function() {
		    const contextPath = '${contextPath}';
		    const myId = '${sessionScope.member.id}';
		
		    // 모든 follow-btn에 대해 초기 팔로우 상태를 확인
		    document.querySelectorAll(".follow-btn").forEach(btn => {
		        const followeeId = btn.getAttribute("data-user-id");
		
		        fetch(contextPath + "/follow/isFollowing?followeeId=" + encodeURIComponent(followeeId))
		            .then(response => response.json())
		            .then(isFollowing => {
		                if (isFollowing) {
		                    setFollowingButton(contextPath, followeeId, myId, btn);
		                } else {
		                    setFollowButton(contextPath, followeeId, myId, btn);
		                }
		            });
		    });
		});
		
		// 팔로잉 상태 버튼 설정 함수
		function setFollowingButton(contextPath, followeeId, myId, btn) {
		    btn.textContent = "팔로잉";
		    btn.classList.remove("follow", "unfollow");
		    btn.classList.add("following");
		
		    btn.onmouseenter = function() {
		        btn.textContent = "언팔로우";
		        btn.classList.remove("following");
		        btn.classList.add("unfollow");
		    };
		    btn.onmouseleave = function() {
		        btn.textContent = "팔로잉";
		        btn.classList.remove("unfollow");
		        btn.classList.add("following");
		    };
		    btn.onclick = function() {
		        unfollow(contextPath, followeeId, myId, btn);
		    };
		}
		
		// 팔로우 상태 버튼 설정 함수
		function setFollowButton(contextPath, followeeId, myId, btn) {
		    btn.textContent = "팔로우";
		    btn.classList.remove("following", "unfollow");
		    btn.classList.add("follow");
		
		    btn.onmouseenter = null;
		    btn.onmouseleave = null;
		    btn.onclick = function() {
		        follow(contextPath, followeeId, myId, btn);
		    };
		}
		
		// 팔로우 요청 함수
		function follow(contextPath, followeeId, myId, btn) {
		    fetch(contextPath + "/follow/add", {
		        method: "POST",
		        headers: { "Content-Type": "application/x-www-form-urlencoded" },
		        body: "followeeId=" + encodeURIComponent(followeeId)
		    })
		    .then(response => response.text())
		    .then(data => {
		        if (data === "success") {
		            setFollowingButton(contextPath, followeeId, myId, btn);
		        } else {
		            alert("팔로우 실패");
		        }
		    })
		    .catch(() => alert("서버 오류"));
		}
		
		// 언팔로우 요청 함수
		function unfollow(contextPath, followeeId, myId, btn) {
		    if (confirm("언팔로우하시겠습니까?")) {
		        fetch(contextPath + "/follow/remove", {
		            method: "POST",
		            headers: { "Content-Type": "application/x-www-form-urlencoded" },
		            body: "followeeId=" + encodeURIComponent(followeeId)
		        })
		        .then(response => response.text())
		        .then(data => {
		            if (data === "success") {
		                setFollowButton(contextPath, followeeId, myId, btn);
		            } else {
		                alert("언팔로우 실패");
		            }
		        })
		        .catch(() => alert("서버 오류"));
		    }
		}
	</script>


</body>