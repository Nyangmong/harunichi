<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅창</title>
<link href="${contextPath}/resources/css/chat/chatWindow.css" rel="stylesheet" >
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<!-- 프로필 이미지 경로 -->
<c:set var="profileImgPath" value="/harunichi/resources/images/profile/" />

	<div class="chat-center-wrapper">
		<div id="chatContainer">
			<!-- 채팅방 상단 영역 -->
			<div id="chatTop">
				<div class="chat-top-left">
					<c:choose>
						<c:when test="${empty profileImg}">
							<img class="profile-img" src="../resources/icon/basic_profile.jpg" alt="기본 프로필사진">												
						</c:when>
						<c:when test="${chatType eq 'personal'}">
							<img class="profile-img" src="${profileImgPath}${profileImg}" alt="개인채팅방 프로필사진">
						</c:when>
						<c:otherwise>
							<img class="profile-img" src="${contextPath}/images/chat/${profileImg}" alt="오픈채팅방 프로필사진">												
						</c:otherwise>
					</c:choose>						
					<div class="room-info">
						<span class="room-title" id="receiverId">${title}<span class="user-count">(${count})</span></span>
					</div>		
				</div>
				<!-- 채팅방 상단 우측 아이콘 -->
				<div class="chat-top-right">
					<a href="#" id="searchIcon" class="chat-setting" onclick="chatSearch();"><i class="bi bi-search"></i></a>
					<form action="#" id="searchBar" class="hidden">
						<input type="text" name="chatKeyword" placeholder="대화내용 입력" >
						<button id="searchBtn" onclick="searchSubmit(event);">검색</button>
					</form>
					<a href="#" id="chatSettingBtn" class="chat-setting" onclick="chatSetting();"><i class="bi bi-list"></i></a>
				    <button class="disconnect-btn" onclick="disconnect();"><i class="bi bi-x-lg"></i></button>
				</div>					
				<!-- 채팅방 설정 드롭다운 -->
				<div id="chatSettingMenu" class="chat-setting-menu hidden">	  
				  <ul>
				    <li onclick="showChatInfo()" class="chat-setting-list"><span><i class="bi bi-info-circle"></i></span>채팅방 정보</li>
				    <li onclick="leaveChatRoom()" class="chat-setting-list"><span><i class="bi bi-box-arrow-right"></i></span>채팅방 나가기</li>
				  </ul>
				</div>				
			</div>

			<!-- 검색 결과 -->
			<div id="searchNavigation" class="hidden">
				<button onclick="goToPrev()"><i class="bi bi-arrow-up-short"></i></button>
				<span id="searchIndex">0 / 0</span>
				<button onclick="goToNext()"><i class="bi bi-arrow-down-short"></i></button>
			</div>
			<p id="noResultMsg" class="hidden">검색된 결과가 없습니다.</p>
			
			<!-- 중고거래에서 요청온 채팅일 경우 상품 정보 보여주는 영역 -->
			<c:if test="${!empty productVo}">
				<div id="productWrap">
					<div id="productImg">			
						<c:if test="${productVo.productStatus eq -1}"> <!-- 거래완료 상품은 이미지 흑백으로 처리 -->
							<a href="${contextPath}/product/view?productId=${productVo.productId}">
								<img class="product-img sold-out" src="${contextPath}/images/product/${productVo.productImg}" alt="상품 이미지">
							</a>					
						</c:if>	
						<c:if test="${productVo.productStatus != -1}">			
							<a href="${contextPath}/product/view?productId=${productVo.productId}">
								<img class="product-img" src="${contextPath}/images/product/${productVo.productImg}" alt="상품 이미지">
							</a>	
						</c:if>
					</div>
					<div id="productInfo">
						<p>
							<span class="product-status bold">
								<c:if test="${productVo.productStatus eq 1}">나눔</c:if>
								<c:if test="${productVo.productStatus eq 0}">판매</c:if>
								<c:if test="${productVo.productStatus eq -1}">거래완료</c:if>
							</span>
							<span>${productVo.productTitle}</span>
						</p>
						<p class="bold">${productVo.productPrice} 원</p>
					</div>	
					<div class="product-btn-wrap">
						<c:if test="${productVo.productStatus != -1}">
							<a href="#" class="product-btn pay" onclick="doPay()" >결제하기</a>	
						</c:if>		
						<a href="#" class="product-btn" onclick="closeProduct()" >닫기</a>		
					</div>	
				</div>	
			</c:if>		
			<!-- 대화창, 수신된 메세지와 전송한 메세지가 표시 되는 영역 -->	
			<div id="messageContainer"></div>	
			<div id="inputContainer">			
				<!-- 메세지 입력창,  키보드 이벤트 발생시 enterKey() 함수 호출 -->
				<input type="text" id="chatMessage" onkeyup="enterKey();">		
				<!-- 메세지 전송 버튼 , 클릭시 sendMessage() 함수 호출 -->
				<button id="sendBtn" onclick="sendMessage();">전송</button>
			</div>
		</div>
	</div>
	<!-- 모달창 영역 -->
	<div id="chatInfoModal" class="chat-info-modal">
	  <div class="modal-content">
	    <span class="close" onclick="closeModal()">&times;</span>
	    <h2>채팅방 정보</h2>
	    <form action="${contextPath}/chat/updateOpenChat" id="updateChatForm" method="POST" enctype="multipart/form-data">
		    <div class="chat-img-wrap">	
				<c:choose>
					<c:when test="${empty profileImg}">
						<img class="chat-profile-img" src="../resources/icon/basic_profile.jpg" alt="기본 프로필사진">												
					</c:when>
					<c:when test="${chatType eq 'personal'}">
						<img class="chat-profile-img" src="${profileImgPath}${profileImg}" alt="개인채팅방 프로필사진">
					</c:when>
					<c:otherwise>
						<img id="openChatImg" class="chat-profile-img" src="${contextPath}/images/chat/${profileImg}" alt="오픈채팅방 프로필사진">												
					</c:otherwise>
				</c:choose>	
				<input type="hidden" id="openchatProfileImg" value="${contextPath}/images/chat/${profileImg}">							
				<input type="hidden" id="originalImg" name="chatProfileImg" value="${profileImg}"><!-- 사진 변경 안 할 경우 -->
				<c:if test="${sessionScope.member.id eq leader}">
					<label for="imgUpload" class="adit-profile-img hidden" id="aditProfileImg">
						<img src="${contextPath}/resources/icon/camera_icon.svg" alt="사진 업로드 아이콘">
					</label>
					<input type="file" id="imgUpload" name="imgUpload" accept="image/*" onchange="uploadImg(this)" style="display: none;">
				</c:if>
		    </div>
		    <div id="chatInfoWrap" class="chat-info-wrap">  
			    <label class="chat-title">${title}</label>
			    <input id="chatTitle" name="title" class="chat-form hidden" type="text" maxlength="20" onkeyup="validateTitle()">
			    <p class="modal-input-msg hidden"></p>	    
			    <label class="chat-persons"><i class="bi bi-person-fill"></i> ${count} / ${persons}</label>		    
			    <input id="chatPersons" name="persons" class="chat-form hidden" type="number" min="${count}" max="8" onkeyup="validatePersons()">
			    <p class="modal-input-msg hidden"></p>
		    </div>	 
		    <!-- 참여자 정보 -->
			<ul class="user-list">
				<c:forEach var="user" items="${userList}" >
					<li>
						<c:if test="${user.id ne leader}">
							<input type="radio" class="selected-user-id hidden" name="selectedUserId" data-user-nick = "${user.nick}" value="${user.id}">
						</c:if>
						<a href="${contextPath}/mypage?id=${user.id}">
							<img class="user-profile-img" src="${profileImgPath}${user.profileImg}" alt="채팅 참여자 프로필 사진">
						</a>
						<span>${user.nick}</span>
				        <c:if test="${user.id eq leader}">
				        	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star-fill" viewBox="0 0 16 16">
							  <path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/>
							</svg>
				        </c:if>	        
					</li>
				</c:forEach>
			</ul>
			<c:if test="${sessionScope.id eq leader}">
			    <div class="modal-btn-wrap">
				    <button class="modal-btn" id="editBtn" onclick="chatRoomUpdate(event)">채팅방 수정</button>
				    <button class="modal-btn" id="chatMemberBtn" type="button" onclick="memberManagement()">참여자 관리</button>		           
		            <button class="modal-btn" id="editSubmitBtn" onclick="submitEdit(event)">수정</button>		            
		            <button type="button" class="modal-btn hidden" id="changeRoomLeader" onclick="changeLeader()">방장위임</button>
		            <button type="button" class="modal-btn hidden" id="kickMemberFromRoom" onclick="kickMember()">강퇴</button>
           			<button type="button" class="modal-btn" id="editCancelBtn" onclick="cancelEdit()">취소</button>
			    </div>
		    </c:if>
		    <input type="hidden" name="chatType" value="group">
		    <input type="hidden" name="roomId" value="${roomId}">
	    </form>
	  </div>
	</div>	
</body>
<script type="text/javascript">
	/*
		상태 유지
	   - 웹소켓은 브라우저와 서버 간의 연결 상태를 readyState 속성으로 유지하여, 현재 연결 상태를 확인하고 조작할 수 있습니다.
	   - 연결 상태는 CONNECTING, OPEN, CLOSING, CLOSED의 네 가지 상태로 표현됩니다.
	*/	
								
	var chatWindow, chatMessage;
	var webSocket, receiverId, lastDate, userNick;
	var roomId = "${roomId}";	
	var senderId = "${sessionScope.id}";
	var chatType = "${chatType}";
	var count = "${count}";
	var leader = "${leader}";
	
	//채팅방 로딩시 실행되는 함수 --------------------------------------------------------------------
	window.onload = function() {
		chatWindow = document.getElementById("messageContainer");	//대화 내용이 표시될 대화창 영역
		chatMessage = document.getElementById("chatMessage");		//메세지 입력창	
		receiverId = document.getElementById("receiverId").value;	//받는 사람 ID 저장								

		//과거 메세지 불러오기
		fetch("${pageContext.request.contextPath}/chat/history?roomId=" + roomId)
			.then(response => response.json())
			.then(messages => {
				messages.forEach(msg => {
					const sentDate = new Date(msg.sentTime);
					
				    // 로컬 날짜 기준으로 YYYY-MM-DD 만들기
				    const year = sentDate.getFullYear();
				    const month = (sentDate.getMonth() + 1).toString().padStart(2, '0');
				    const day = sentDate.getDate().toString().padStart(2, '0');
				    const currentDateStr = year + "-" + month + "-" + day;
							
					//메세지 보낸 날짜 표시
					if(lastDate !== currentDateStr){
						const dateDisplay = new Date(sentDate).toLocaleDateString('ko-KR', {year:'numeric', month:'long', day:'numeric'});
						chatWindow.innerHTML += "<div class='date-text'>" + dateDisplay + "</div>";
						lastDate = currentDateStr;
					}
					
					const sender = msg.senderId;
					const nickname = msg.nickname;
					const message = msg.message;
					const time = formatTime(sentDate);
					const isGroupChat = chatType === "group";
					
					chatWindow.innerHTML += (isGroupChat && sender !== senderId ? "<div class='nickname'>" + nickname + "</div>" : "") 
										  + "<div class='" + (sender === senderId ? "my-msg" : "other-msg") + "'>" 
										  + "<div class='message'>" 
										  + message + "</div>"
										  + "<span class='time'>" + time + "</span>" + "</div>";
				});
				chatWindow.scrollTop = chatWindow.scrollHeight;				
				//과거 메세지 출력 후 웹소켓 연결
				connectWebSocket();				
			});
	}
	
	
	//보낸 시간 포맷팅 ---------------------------------------------------------------------------
	function formatTime(date) {
		const d = date ? new Date(date) : new Date(); // 인자 없으면 지금 시간
		const hours = d.getHours();
		const minutes = d.getMinutes().toString().padStart(2, '0');
		const ampm = hours >= 12 ? "오후" : "오전";
		const displayHour = hours % 12 === 0 ? 12 : hours % 12;
		return ampm + " " + displayHour + ":" + minutes;
	}
	
		
	//웹소켓 연결 ------------------------------------------------------------------------------
	function connectWebSocket(){
		//웹 소켓 객체 생성 : JSP의 application내장객체를 통해 요청할 채팅 서버페이지 주소로 웹소켓을 만들어 연결 
		webSocket = new WebSocket("<%=application.getInitParameter("CHAT_ADDR")%>/ChattingServer?roomId=" + roomId);

		//서버에 웹소켓 통로 연결이 성공적으로 이루어진 이벤트가 발생했을때 호출되는 이벤트 핸들러 함수 설정
		//대화창에 연결 성공 메세지를 보여주기 위해 출력
		webSocket.onopen = function(event) {			
			//개인채팅방인데 상대방이 채팅방을 나간 경우
			if (chatType == 'personal' && count < 2) {
				chatWindow.innerHTML += "<p class='server-mag'>대화 상대가 없습니다.</p><br/>";
				chatWindow.scrollTop = chatWindow.scrollHeight;			
				document.getElementById("chatMessage").disabled = true;
				document.getElementById("sendBtn").disabled = true;
				// 바로 연결 끊기
				webSocket.close();
				return;
			}else {
				chatWindow.innerHTML += "<p class='server-mag'>채팅방에 입장하였습니다.</p><br/>";
				chatWindow.scrollTop = chatWindow.scrollHeight;					
			}
		};

		//웹소켓 통로와 연결된 서버페이지와의 연결이 종료될때의 이벤트가 발생하면 호출되는 이벤트 핸들러 함수 설정
		//대화창에 연결 종료 메세지를 출력
		webSocket.onclose = function(event) {
			chatWindow.innerHTML += "<p class='server-mag'>채팅방 연결이 종료되었습니다.</p><br/>";
			chatWindow.scrollTop = chatWindow.scrollHeight;
		};

		//웹소켓 통로와 통신중 오류가 발생하는 이벤트가 일어나면 호출되는 이벤트 핸들러 함수 설정
		//오류 발생시 알림창에 오류메시지 표시하고 대화창에 에러 메세지 출력
		webSocket.onerror = function(event) {
			alert(event.data);
			chatWindow.innerHTML += "<p class='server-mag'>채팅 중에 에러가 발생하였습니다.</p><br/>";
			chatWindow.scrollTop = chatWindow.scrollHeight;
		};

		//서버페이지에서 웹소켓 통로를 통해 클라이언트가 보낸 메세지를 보내어서 여기로 수신했을때(메아리)
		webSocket.onmessage = function(event) {
			
			console.log(event.data);
			//수신된 데이터 '대화명 | 메세지'를 '|'기준으로 분리하여 배열로 저장
			var message = event.data.split("|");
			//대화명을 sender 변수에저장
			var sender = message[0];
			//닉네임을 nickname 변수에 저장
			var nickname = message[1];
			//메세지 내용을 content 변수에 저장
			var content = message[2];			
			var time = formatTime();

			//개인 채팅방에서 상대방이 나갔을 경우 알림 메세지 출력
			if (sender === "SYSTEM") {
				chatWindow.innerHTML += "<p class='server-mag'>" + message[1] + "</p><br/>";
				
				if(chatType === "personal"){
					document.getElementById("chatMessage").disabled = true;
					document.getElementById("sendBtn").disabled = true;	
				}

				chatWindow.scrollTop = chatWindow.scrollHeight;
				return;
			}
			
			if (content != "") {
				
				const isGroupChat = chatType === "group";
				
				//대화창에 '대화명 : 메세지' 형식으로 표시
				chatWindow.innerHTML += (isGroupChat ? "<div class='nickname'>" + nickname + "</div>" : "") 	
					  + "<div class='other-msg'>"
					  + "<div class='message'>" + content +  "</div>"
					  + "<span class='time'>" + time + "</span>"
					  + "</div>";		
			}

			//새메세지가 대화창에 추가되면 대화창의 스크롤막대바를 가장 아래로 이동시켜 
			//사용자가 새 메세지를 볼수 있도록 설정
			chatWindow.scrollTop = chatWindow.scrollHeight;
		};
		
	}
	
	
	//1000바이트까지 입력 가능하도록 하는 함수 ---------------------------------------------------------
	function getByteLength(str) {
		return new Blob([str]).size;
	}
	document.getElementById("chatMessage").addEventListener("input", function () {
		let msg = this.value;
		let maxByte = 1000;
		
		//입력한 메세지가 1000바이트를 넘는다면 뒤에 입력한 내용을 잘라냄
		while (getByteLength(msg) > maxByte) {
		  msg = msg.slice(0, -1); // 뒤에서부터 잘라냄
		}		
		this.value = msg;
	});
	
	
	//메세지 전송 함수 : 채팅 사용자가 메세지 전송 버튼을 클릭하거나 엔터 키를 눌렀을때 호출 ---------------------
	function sendMessage() {	
		//아무것도 적지 않고 전송할 경우
		if (chatMessage.value == "") { return; }	
		
		//새로운 채팅!
		const chatData = {
					roomId : "${roomId}",
					chatType : "${chatType != null ? chatType : param.chatType}", //개인채팅인지, 단체채팅인지		
					senderId : senderId, 			//보낸 사람
					nickname : "${nickname}",		//보낸 사람 닉네임
					receiverId : "${receiverId != null ? receiverId : param.receiverId}",
					message : chatMessage.value //메세지	
		};
		
		//사용자가 입력한 메세지를 대화창에서 얻어 오른쪽 정렬로 디자인 추가
		chatWindow.innerHTML += "<div class='my-msg'>"
							  + "<div class='message'>" + chatMessage.value + "</div>"
							  + "<span class='time'>" + formatTime() + "</span>"
							  + "</div>";

		//웹 소켓 통로를 통해 메세지를 서버페이지로 전송
		webSocket.send(JSON.stringify(chatData));

		//메세지 입력 창 내용 초기화
		chatMessage.value = "";

		//대화창 스크롤 막대바를 맨 아래로 이동하여 새로운 메세지가 나타나면 보이게 설정
		chatWindow.scrollTop = chatWindow.scrollHeight;
	}

	
	//메세지 입력창에서 Enter키를 누르고 땠을 경우 ----------------------------------------------------
	//자동으로 sendMessage함수를 호출하도록처리
	function enterKey() {
		//Enter키의 키코드값 = 13
		if (window.event.keyCode == 13) {
			sendMessage();
		}
	}
	
	
	//서버와 웹 소켓 통로 연결을 종료하는 함수 : 채팅방 우측 상단 X 버튼 클릭시 호출 -----------------------------
	function disconnect() {
		webSocket.close(); //웹 소켓 통로연결 끊기 ( 웹브라우저, 서버페이지 연결 끊김 )
		window.location.href="<%=request.getContextPath()%>/chat/main";
	}
	
	
	//채팅 상단의 상품 정보 닫기 (완전히 닫힘) --------------------------------------------------------
	function closeProduct(){
		const chatTop = document.getElementById("productWrap");
		if (chatTop) {
		  chatTop.remove();
		  location.href = "${contextPath}/chat/deleteProductId?roomId=${roomId}&productId=${productVo.productId}";
		}	
	}
	
	
	//상품 결제창으로 이동 -----------------------------------------------------------------------
	function doPay() {
		const productId = "${productVo.productId}";
		 location.href = "${contextPath}/payment/form?productId=${productVo.productId}";
	}
	
	

	//채팅방 검색 바 노출 ------------------------------------------------------------------------
	function chatSearch(){
		const search = document.getElementById("searchBar");
		search.classList.toggle("hidden");		
		const searchIcon = document.getElementById("searchIcon");
		searchIcon.classList.toggle("search-icon");		
		
		if(search.classList.contains("hidden")){
			document.getElementById("noResultMsg").classList.add("hidden");
			document.getElementById("searchNavigation").classList.add("hidden");
			document.getElementById("searchNavigation").style.display = "";		
			document.querySelector("input[name='chatKeyword']").value = "";
			document.querySelectorAll(".highlight").forEach(el => {
				el.classList.remove("highlight");
			});
		}
	}
		
	//채팅 검색 ------------------------------------------------------------------------------
	let matchedMessages = [];
	let currentIndex = -1;
	
	
	function searchSubmit(event){
		event.preventDefault();		
		const keyword = document.querySelector("input[name='chatKeyword']").value.trim();
		matchedMessages = [];
		currentIndex = -1;
		
		//도큐먼트 초기화
		document.getElementById("noResultMsg").classList.add("hidden");
		document.getElementById("searchNavigation").classList.add("hidden");
		document.getElementById("searchNavigation").style.display = "";
		
		if (!keyword) return;
		
		// 이전 하이라이팅 제거
		document.querySelectorAll(".highlight").forEach(el => {
			el.classList.remove("highlight");
		});

		// 채팅 메시지 목록에서 검색
		const messages = document.querySelectorAll(".message");
		messages.forEach((msg, index) => {
			if (msg.textContent.includes(keyword)) {
				matchedMessages.push(msg);
			}
		});	
		
		// 결과 표시
		if (matchedMessages.length > 0) {
			document.getElementById("noResultMsg").classList.add("hidden");
			document.getElementById("searchNavigation").classList.remove("hidden");
			document.getElementById("searchNavigation").style.display = "flex";
			currentIndex = 0;
			scrollToMessage(currentIndex);
			updateSearchIndex();
		} else {
		    document.getElementById("noResultMsg").classList.remove("hidden");
		    document.getElementById("searchNavigation").classList.add("hidden");
		  }
	}
	
	function scrollToMessage(index) {
		  matchedMessages.forEach(msg => msg.classList.remove("highlight"));
		  const target = matchedMessages[index];
		  target.scrollIntoView({ behavior: "smooth", block: "center" });
		  target.classList.add("highlight");
		}

		function updateSearchIndex() {
		  document.getElementById("searchIndex").textContent = currentIndex + 1 + "/" + matchedMessages.length;
		}

		function goToPrev() {
		  if (matchedMessages.length === 0) return;
		  currentIndex = (currentIndex - 1 + matchedMessages.length) % matchedMessages.length;
		  scrollToMessage(currentIndex);
		  updateSearchIndex();
		}

		function goToNext() {
		  if (matchedMessages.length === 0) return;
		  currentIndex = (currentIndex + 1) % matchedMessages.length;
		  scrollToMessage(currentIndex);
		  updateSearchIndex();
		}
	
	//채팅방 설정 드롭다운 -----------------------------------------------------------------------
	function chatSetting(){
		const menu = document.getElementById("chatSettingMenu");
		menu.classList.toggle("hidden");	
	}
	
	//다른 곳 클릭하면 드롭다운 닫기
	document.addEventListener("click", function(event) {
		const menu = document.getElementById("chatSettingMenu");
		const button = document.getElementById("chatSettingBtn"); 
		if (!menu.contains(event.target) && !button.contains(event.target)) {
			menu.classList.add("hidden");
		}
	});
	
	
	//채팅방 나가기 ----------------------------------------------------------------------------
	function leaveChatRoom() {

		//방장은 채팅방 못 나가게 설정		
		if(senderId === leader && count > 1){
			alert("방장은 채팅방을 나갈 수 없습니다. 권한을 다른 멤버에게 위임해주세요.");			
			return;
		}	

		if (confirm("정말 채팅방을 나가시겠습니까?")) {					
			//상대방에게 채팅 상대가 나갔다는 메세지 전송
			if (webSocket && webSocket.readyState === WebSocket.OPEN) {
				webSocket.send(JSON.stringify({
					senderId : senderId,
					nickname : (chatType === 'group') ? "${nickname}" : "",
					message : "SYSTEM|LEAVE",
					chatType : chatType
				}));
			}				
			//0.3초 기다렸다가 웹소켓 종료
			setTimeout(() => {
				if (webSocket && webSocket.readyState === WebSocket.OPEN) {
					webSocket.close();
				}	
				// 3. 서버로 DB 업데이트 요청
				location.href = "${contextPath}/chat/leaveChatRoom?roomId=${roomId}";
			}, 300);	
		}
	}

	//모달창 -------------------------------------------------------------------------------	
	//모달창 열기
	const isLeader = "${sessionScope.member.id eq leader}";
	function showChatInfo() {
		event.preventDefault();		
		//로그인 체크
		const userId = '<%= session.getAttribute("id") == null ? "" : session.getAttribute("id") %>';
		if (!userId) {
		  location.href = "<%= request.getContextPath() %>/chat/loginChek";
		  return;
		}
		
		if(isLeader === 'true'){
			toggleDisplay(["editSubmitBtn", "editCancelBtn"], "none");
			toggleElements(["#editBtn", "#chatMemberBtn"], ["#aditProfileImg"]);
		}
		
		toggleDisplay(["chatInfoModal"], "block");
	}

	//모달창 닫기
	function closeModal() { 		
		if(isLeader === 'true'){
			//수정 폼 초기화 및 숨김 설정
			document.getElementById("updateChatForm").reset();
			
			toggleElements([".chat-title", ".chat-persons"],
						   ["#chatTitle", "#chatPersons", ".modal-input-msg", 
							".selected-user-id", "#changeRoomLeader", "#kickMemberFromRoom"]);
			
			toggleDisplay(["editBtn", "chatMemberBtn"], "");
			document.querySelector('.chat-profile-img').src =  "${contextPath}/images/chat/${profileImg}";
		}	
		toggleDisplay(["chatInfoModal"], "none");	
	}

	//채팅방 수정 버튼 클릭시 호출
	function chatRoomUpdate(event) {	
		event.preventDefault();	
		
		document.getElementById('chatTitle').value = "${title}";
		document.getElementById('chatPersons').value = "${persons}";
		
		toggleElements(["#chatTitle", "#chatPersons", ".modal-input-msg", "#aditProfileImg"],
				  	   [".chat-title", ".chat-persons", "#editBtn", "#chatMemberBtn"]);
		
		toggleDisplay(["editSubmitBtn", "editCancelBtn"], "");	
	}	
	
	//오픈 채팅방 정보 수정 취소
	function cancelEdit(){

		document.getElementById("updateChatForm").reset();
		
		document.querySelector('.chat-profile-img').src =  "${contextPath}/images/chat/${profileImg}";
		
		toggleElements([".chat-title", ".chat-persons", "#editBtn", "#chatMemberBtn"],
			  	       ["#chatTitle", "#chatPersons", ".modal-input-msg", "#aditProfileImg", "#changeRoomLeader",
			  	    	"#kickMemberFromRoom", ".selected-user-id"]);
		
		toggleDisplay(["editCancelBtn", "editSubmitBtn"], "none");
		
		showChatInfo(); 
	}
	
	//오픈 채팅방 정보 수정 처리 ---------------------------------------------------------------
	function submitEdit(event){
		event.preventDefault();	
		//유효성 검사
		const isValid = validate();
		if (isValid) { document.getElementById("updateChatForm").submit(); }		
	}
	
	//유효성 검사 결과 리턴
	function validate() {
		const isTitleValid = validateTitle();
		const isPersonsValid = validatePersons();
		return isTitleValid && isPersonsValid;
	}
	
	//채팅방 이름 유효성 검사
	function validateTitle() {
		const titleInput = document.getElementById("chatTitle");
		const msgTag = titleInput.nextElementSibling;
		const title = titleInput.value.trim();

		if (title.length === 0) {
			msgTag.textContent = "채팅방 이름을 입력해주세요. 최대 20자까지 입력 가능합니다.";
			msgTag.classList.add("err");
			return false;
		} else {
			msgTag.textContent = "";
			return true;
		}
	}

	//채팅방 인원 유효성 검사
	function validatePersons() {
		const personInput = document.getElementById("chatPersons");
		const msgTag = personInput.nextElementSibling;
		const value = Number(personInput.value);
		const count = "${count}";

		if (isNaN(value) || value < count || value > 8) {
			msgTag.textContent = "현재 채팅방에 참여한 인원 이상 8명 이하로 입력해주세요.";
			msgTag.classList.add("err");
			return false;
		} else {
			msgTag.textContent = "";
			return true;
		}
	}
	
	//채팅방 프로필 이미지 업로드 
	function uploadImg(input) {
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
	        document.querySelector('.chat-profile-img').src = e.target.result;
	        document.getElementById('openchatProfileImg').value = file.name;
	    }
	    reader.readAsDataURL(file);
	}
	
	
	//채팅방 참여자 관리 --------------------------------------------------------------------------
	function memberManagement(){
		
		toggleElements(["#changeRoomLeader", "#kickMemberFromRoom", ".selected-user-id"],
		  	           ["#editBtn", "#chatMemberBtn"]);
	
		toggleDisplay(["editCancelBtn"], "");
				
	}
	
	
	//방장 위임 ---------------------------------------------------------------------------------
	function changeLeader(){
		
		const selected = document.querySelector('input[name="selectedUserId"]:checked');
		
		if (!selected) {
			alert("방장 권한을 위임할 멤버를 선택해주세요.");
			return;
		}
		
		const selectedUserId = selected.value;
		const userNick = selected.dataset.userNick;
		
		if (!confirm( userNick + "에게 방장 권한을 위임하시겠습니까?")) return;
	
		fetch("${contextPath}/chat/changeLeader", {
			method: "POST",
			headers: {
				"Content-Type": "application/json"
			},
			body: JSON.stringify({
				userId: selectedUserId,
				roomId: roomId
			})
		})
		.then(response => {
			if (!response.ok) {
				throw new Error("서버 오류 발생");
			}
			return response.json();
		})
		.then(data => {
			if (data.success) {
				alert("방장 권한이 성공적으로 위임되었습니다!");
				location.reload(); 
			} else {
				alert("방장 위임 실패: " + data.message);
			}
		})
		.catch(error => {
			console.error("에러:", error);
			alert("방장 위임 중 오류가 발생했습니다.");
		});
	}
	
	
	//멤버 강퇴
	function kickMember(){
		const selected = document.querySelector('input[name="selectedUserId"]:checked');
		
		if (!selected) {
			alert("강퇴할 멤버를 선택해주세요.");
			return;
		}
		
		const selectedUserId = selected.value;
		const userNick = selected.dataset.userNick;
		
		if (!confirm("정말 " + userNick + "님을 강퇴하시겠습니까?")) return;
		
		fetch("${contextPath}/chat/kickMember", {
			method: "POST",
			headers: {
				"Content-Type": "application/json"
			},
			body: JSON.stringify({
				userId: selectedUserId,
				roomId: roomId
			})
		})
		.then(response => {
			if (!response.ok) {
				throw new Error("서버 오류 발생");
			}
			return response.json();
		})
		.then(data => {
			if (data.success) {
				alert(userNick + "님을 강퇴하였습니다.");
				location.reload(); 
			} else {
				alert("멤버 강퇴 실패: " + data.message);
			}
		})
		.catch(error => {
			console.error("에러:", error);
			alert("멤버 강퇴 중 오류가 발생했습니다.");
		});
			
	}
	
	
	//hidden 클래스 토글 -------------------------------------------------------------------------
	function toggleElements(showSelectors = [], hideSelectors = []) {	
		showSelectors.forEach(sel => {
			document.querySelectorAll(sel).forEach(el => el.classList.remove('hidden'));
		});
		hideSelectors.forEach(sel => {
			document.querySelectorAll(sel).forEach(el => el.classList.add('hidden'));
		});
	}
	
	function toggleDisplay(ids = [], displayValue = "") {
		ids.forEach(id => {
			const el = document.getElementById(id);
			if (el) el.style.display = displayValue;
		});
	}

</script>
</html>