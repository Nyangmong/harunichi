<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>  
<!-- 멤버 프로필 이미지 경로 -->
<c:set var="profileImgPath" value="/harunichi/resources/images/profile/" />
<!-- 채팅방 프로필 이미지 경로 -->
<c:set var="chatImgPath" value="/harunichi/resources/images/chat/" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="${contextPath}/resources/css/chat/chatMain.css" rel="stylesheet" >
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<form id="chatForm" action="${contextPath}/chat/createChat" method="POST">
	<input type="hidden" id="receiverId" name="receiverId"> 		
	<input type="hidden" id="chatType" name="chatType" value="personal">
</form>	
	
<div style="margin-bottom: 80px;">
	<p id="mainChatTitle">채팅 친구 추천 ✨</p>
	<div id="chatMainCon">		
		<a href="#" class="btn pre"><i class="bi bi-arrow-left"></i></a>
		<div class="chat-slider-container">
			<ul class="profile-list">
				<c:forEach var="member" items="${memberList}">						
					<li>
						<div class="profile-con">
							<a href="${contextPath}/mypage?id=${member.id}"> <!-- 클릭시 상대방 프로필 정보 -->
								<c:choose>
							    	<c:when test="${not empty member.profileImg}">
							        	<img class="profile-img" src="${profileImgPath}${member.profileImg}">
							        	<!-- <img class="profile-img" src="${member.profileImg}"> -->
							    	</c:when>
							    	<c:otherwise>
							        	<img class="profile-img" src="${contextPath}/resources/icon/basic_profile.jpg">
							    	</c:otherwise>
								</c:choose>
							</a>
							<p class="nick">${member.nick}</p>
							<p><span style="color: #a3daff; font-weight: bold; ">LIKE </span>${member.myLike}</p>
							<a href="#" class="do-chat-btn" data-id="${member.id}" onclick="chatOpen(this);">채팅하기</a>
						</div>
					</li>
				</c:forEach>						
			</ul>
		</div>	
		<a href="#" class="btn next"><i class="bi bi-arrow-right"></i></a>
	</div>
</div>

<script type="text/javascript">
	function chatOpen(btn){
		//'채팅하기'버튼이 눌린 카드의 멤버 ID를 input에 저장
		const receiverId = btn.getAttribute("data-id");
		document.getElementById("receiverId").value = receiverId;
		document.getElementById("chatForm").submit();		
	}	
	
	//추천친구 캐러셀 --------------------------------------------------------------
	let currentIndex = 0;
	
	const list = document.querySelector(".profile-list");
	const items = document.querySelectorAll(".profile-list li");
	const cardWidth = 230 + 20; // 카드 너비 + gap
	const visibleCards = 4;	
	const totalCards = items.length;
	const maxIndex = totalCards - visibleCards;
	
	document.querySelector(".btn.next").addEventListener("click", (e) => {
	  e.preventDefault();
	  if (currentIndex < maxIndex) {
	    currentIndex++;
	    updateSlide();
	  }
	});
	
	document.querySelector(".btn.pre").addEventListener("click", (e) => {
	  e.preventDefault();
	  if (currentIndex > 0) {
	    currentIndex--;
	    updateSlide();
	  }
	});
	
	function updateSlide() {
		const moveX = currentIndex * cardWidth;
		list.style.transform = "translateX(-" + moveX + "px)";
	}
</script>

</html>