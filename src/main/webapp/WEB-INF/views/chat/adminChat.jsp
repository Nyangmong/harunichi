<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 관리</title>
<link href="${contextPath}/resources/css/member/adminMember.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body>
	<!-- 탭 -->
	<div class="tabs">
		<a href="${contextPath}/admin/chat" class="${activeTab eq 'chat' ? 'active' : ''}" >채팅방 관리</a>
		<a href="${contextPath}/admin/chat/adminMessage" class="${activeTab eq 'report' ? 'active' : ''}" onclick="alert('⚠️ 이 기능은 아직 준비 중입니다!'); return false;">⚠️ 운영자 메세지 전송</a>
		<a href="#" class="${activeTab eq 'report' ? 'active' : ''}" onclick="alert('⚠️ 이 기능은 아직 준비 중입니다!'); return false;">⚠️ 채팅방 신고 관리</a>
		<a href="#" class="${activeTab eq 'chatLog' ? 'active' : ''}" onclick="alert('⚠️ 이 기능은 아직 준비 중입니다!'); return false;">⚠️ 채팅 로그</a>	
		<a href="#" class="${activeTab eq 'ChatPolicies' ? 'active' : ''}" onclick="alert('⚠️ 이 기능은 아직 준비 중입니다!'); return false;">⚠️ 정책 설정</a>

		
	</div>

	<!-- 검색 폼 -->
	<form class="header-search-form" action="${contextPath}/admin/chat/chatRoomSearch" method="post">
		<select name="searchType">
			<option value="all" ${searchType == 'all' ? 'selected' : ''}>전체</option>
			<option value="chatType" ${searchType == 'chatType' ? 'selected' : ''}>타입</option>
			<option value="userId" ${searchType == 'userId' ? 'selected' : ''}>유저 ID</option>
			<option value="roomId" ${searchType == 'roomId' ? 'selected' : ''}>채팅방 ID</option>	
		</select>
		<input type="text" name="searchKeyword" value="${searchKeyword}" placeholder="검색어를 입력하세요" />
		<button type="submit">
			검색
		</button>
	</form>
	
	<!-- 채팅방 목록 테이블 -->
	<form id="chatForm" method="post">
		<table>
			<thead>
				<tr>
					<th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"></th>
					<th>채팅방 ID</th>
					<th>타입</th>
					<th>타이틀</th>
					<th>인원</th>
					<th>방장</th>
					<th>프로필 이미지</th>
					<th>활동일자</th>
					<th>생성일자</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="chatRoom" items="${result.list}" varStatus="loop">
					<tr>
						<td><input type="checkbox" name="selectedIds" value="${loop.index}" /></td>
						<td>${chatRoom.roomId}<input type="hidden" name="roomId_${loop.index}" value="${chatRoom.roomId}" /></td>
						<td>${chatRoom.chatType}<input type="hidden" value="${chatRoom.chatType}" /></td>
						<td>
							<c:choose>
								<c:when test="${chatRoom.chatType eq 'group'}">
									<input type="text" name="title_${loop.index}" value="${chatRoom.title}" />
								</c:when>
								<c:otherwise>
									<input type="text" value="${chatRoom.title}" disabled />
								</c:otherwise>
							</c:choose>					
						</td>
						<td>${chatRoom.userCount}<input type="hidden" value="${chatRoom.userCount}" /></td>
						<td>${chatRoom.leader}<input type="hidden" value="${chatRoom.leader}" /></td>
						<td>
							<div class="profile-cell">
								<div class="table-img">
									<c:choose>
										<c:when test="${not empty chatRoom.profileImg}">
											<img id="profileImg_${chatRoom.roomId}" src="${contextPath}/images/chat/${chatRoom.profileImg}" alt="프로필 이미지" />
										</c:when>
										<c:otherwise>
											<img id="profileImg_${chatRoom.roomId}" src="${contextPath}/resources/icon/basic_profile.jpg" alt="기본 프로필" />
							        	</c:otherwise>
									</c:choose>
								</div>
								<button type="button" onclick="resetProfileImg('${chatRoom.roomId}')">초기화</button>
								<input type="hidden" value="${chatRoom.profileImg}" name="imgReset_${loop.index}" id="profileImgInput_${chatRoom.roomId}" />
							</div>
						</td>
						<td><fmt:formatDate value="${chatRoom.lastMessageTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td><fmt:formatDate value="${chatRoom.admissionTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					</tr>
				</c:forEach>
				<c:if test="${empty result.list}">
					<tr>
						<td colspan="16">검색 결과가 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
		<div class="submit-btn-class">
			<button type="submit" onclick="saveBtn();">저장</button>
			<button type="submit" onclick="deleteBtn();">삭제</button>
		</div>
	</form>

	<!-- 페이징 -->
	<div class="pagination">
		<c:set var="startPage" value="${result.currentPage - (result.currentPage - 1) % 5}" />
		<c:set var="endPage" value="${startPage + 4}" />
		<c:set var="totalPage" value="${(result.totalCount + result.pageSize - 1) / result.pageSize}" />
		<c:if test="${startPage > 1}">
			<a href="${currentUri}?page=${startPage - 1}&searchKeyword=${searchKeyword}&searchType=${searchType}">&laquo;</a>
		</c:if>
		<c:forEach var="p" begin="${startPage}" end="${endPage}">
			<c:if test="${p <= totalPage}">
				<a href="${currentUri}?page=${p}&searchKeyword=${searchKeyword}&searchType=${searchType}" class="${p == result.currentPage ? 'active-page' : ''}">${p}</a>
			</c:if>
		</c:forEach>
		<c:if test="${endPage < totalPage}">
			<a href="${currentUri}?page=${endPage + 1}&searchKeyword=${searchKeyword}&searchType=${searchType}">&raquo;</a>
		</c:if>
	</div>

	<script>
	
		window.addEventListener("DOMContentLoaded", () => {
			  const urlParams = new URLSearchParams(window.location.search);
			  if (urlParams.get('result') === 'updateSuccess') {
			    alert("채팅방 정보 수정이 완료되었습니다.");
			  }else if(urlParams.get('result') === 'deleteSuccess'){
				 alert("채팅방이 성공적으로 삭제되었습니다.");
			  }		  
			  history.replaceState({}, '', window.location.pathname);
			});
	
		const contextPath = "${contextPath}";
		const form = document.getElementById("chatForm");
		
		function toggleAll(source) {
		    const checkboxes = document.querySelectorAll('input[name="selectedIds"]');
		    for (const checkbox of checkboxes) {
		        checkbox.checked = source.checked;
		    }
		}

		function resetProfileImg(roomId) {
			const imgTag = document.getElementById("profileImg_" + roomId);
		    const inputTag = document.getElementById("profileImgInput_" + roomId);
		
		    imgTag.src = "${contextPath}/resources/icon/basic_profile.jpg";
		
		    inputTag.value = "";
		}
		
		//채팅방 수정
		function saveBtn(){			
			if (!confirm("해당 채팅방의 정보를 수정하시겠습니까?")){ return; }

			const selected = document.querySelectorAll('input[name="selectedIds"]:checked');

			if (selected.length === 0) {
				alert("수정할 채팅방을 선택해주세요.");
				return;
			}
			form.action = contextPath + "/admin/chat/update";
			
			  selected.forEach((checkbox) => {
			    const index = checkbox.value;

			    // 선택된 roomId, title, imgReset 값 복사
			    ['roomId', 'title', 'imgReset'].forEach((key) => {
			      const original = document.querySelector("input[name=" + key + "_" + index + "]");
			      if (original) {
			        const input = document.createElement('input');
			        input.type = 'hidden';
			        input.name = key;
			        input.value = original.value;
			        form.appendChild(input);
			      }
			    });
			  });
			  document.body.appendChild(form);
			  form.submit();
		}
		
		//채팅방 삭제
		function deleteBtn(){
			if (!confirm("해당 채팅방을 삭제하시겠습니까?")){ return; }

			const selected = document.querySelectorAll('input[name="selectedIds"]:checked');

			if (selected.length === 0) {
				alert("삭제할 채팅방을 선택해주세요.");
				return;
			}
			
			form.action = contextPath + "/admin/chat/delete";
			
			  selected.forEach((checkbox) => {
				  const index = checkbox.value;
				  const roomIdInput = document.querySelector("input[name=roomId_" + index + "]");
				  if (roomIdInput) {
				    const input = document.createElement('input');
				    input.type = 'hidden';
				    input.name = 'roomId';
				    input.value = roomIdInput.value;
				    form.appendChild(input);
				  }
			  });
			  document.body.appendChild(form);
			  form.submit();
		}
		
		
	</script>
</body>
</html>
