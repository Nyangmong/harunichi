<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<link href="${contextPath}/resources/css/member/adminMember.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body>
	<!-- 탭 -->
	<div class="tabs">
		<a href="${contextPath}/admin/member" class="${activeTab eq 'member' ? 'active' : ''}">회원 관리</a>
		<a href="${contextPath}/admin/member/follow" class="${activeTab eq 'follow' ? 'active' : ''}">팔로우 관리</a>
	</div>

	<!-- 검색 폼 -->
	<form class="header-search-form" action="${currentUri}" method="get">
		<c:if test="${activeTab eq 'member'}">
			<select name="searchType">
				<option value="all" ${searchType == 'all' ? 'selected' : ''}>전체</option>
				<option value="id" ${searchType == 'id' ? 'selected' : ''}>아이디</option>
				<option value="nick" ${searchType == 'nick' ? 'selected' : ''}>닉네임</option>
				<option value="email" ${searchType == 'email' ? 'selected' : ''}>이메일</option>
			</select>
		</c:if>
		<input type="text" name="searchKeyword" value="${searchKeyword}" placeholder="검색어를 입력하세요" />
		<button type="submit">
			검색
		</button>
	</form>

	<!-- 회원 목록 테이블 -->
	<c:if test="${activeTab eq 'member'}">
		<form action="${contextPath}/admin/member/saveOrDelete.do" method="post">
			<table>
				<thead>
					<tr>
						<th><input type="checkbox" id="checkAll" onclick="toggleAll(this)"></th>
						<th>아이디</th>
						<th>비밀번호</th>
						<th>이름</th>
						<th>닉네임</th>
						<th>국적</th>
						<th>생년월일</th>
						<th>성별</th>
						<th>이메일</th>
						<th>전화번호</th>
						<th>주소</th>
						<th>관심사</th>
						<th>프로필 이미지</th>
						<th>가입일</th>
						<th>카카오ID</th>
						<th>네이버ID</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="member" items="${result.list}" varStatus="loop">
						<tr>
							<td><input type="checkbox" name="selectedIds" value="${member.id}" /></td>
							<td>${member.id}<input type="hidden" name="members[${loop.index}].id" value="${member.id}" /></td>
							<td><input type="text" name="members[${loop.index}].pass" value="${member.pass}" /></td>
							<td><input type="text" name="members[${loop.index}].name" value="${member.name}" /></td>
							<td><input type="text" name="members[${loop.index}].nick" value="${member.nick}" /></td>
							<td>
								<select name="members[${loop.index}].contry">
									<option value="kr" ${member.contry == 'kr' ? 'selected' : ''}>한국</option>
									<option value="jp" ${member.contry == 'jp' ? 'selected' : ''}>일본</option>
								</select>
							</td>
							<td><input type="date" name="members[${loop.index}].year" value="${member.year}" /></td>
							<td>
								<select name="members[${loop.index}].gender">
									<option value="" ${empty member.gender ? 'selected' : ''}>선택안함</option>
									<option value="M" ${member.gender == 'M' ? 'selected' : ''}>남성</option>
									<option value="F" ${member.gender == 'F' ? 'selected' : ''}>여성</option>
								</select>
							</td>
							<td><input type="text" name="members[${loop.index}].email" value="${member.email}" /></td>
							<td><input type="text" name="members[${loop.index}].tel" value="${member.tel}" /></td>
							<td><input type="text" name="members[${loop.index}].address" value="${member.address}" /></td>
							<td><input type="text" name="members[${loop.index}].myLike" value="${member.myLike}" /></td>
							<td>
								<div class="profile-cell">
									<div class="table-img">
										<c:choose>
											<c:when test="${not empty member.profileImg}">
												<img id="profileImg_${member.id}" src="${contextPath}/images/profile/${member.profileImg}" alt="프로필 이미지" />
											</c:when>
											<c:otherwise>
												<img id="profileImg_${member.id}" src="${contextPath}/resources/icon/basic_profile.jpg" alt="기본 프로필" />
								        	</c:otherwise>
										</c:choose>
									</div>
									<button type="button" onclick="resetProfileImg('${member.id}')">초기화</button>
									<input type="hidden" name="members[${loop.index}].profileImg" value="${member.profileImg}" id="profileImgInput_${member.id}" />
								</div>
							</td>
							<td>${member.joindate}</td>
							<td>${member.kakao_id}</td>
							<td>${member.naver_id}</td>
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
				<button type="submit" name="action" value="update" onclick="return confirm('변경한 사항을 저장하시겠습니까?');">저장</button>
				<button type="submit" name="action" value="delete" onclick="return confirm('선택한 회원을 삭제하시겠습니까?');">삭제</button>
			</div>
		</form>
	</c:if>

	<!-- 팔로우 목록 테이블 -->
	<c:if test="${activeTab eq 'follow'}">
		<form action="${contextPath}/admin/member/deleteFollows.do" method="post">
			<table>
				<thead>
					<tr>
						<th><input type="checkbox" id="checkAllFollow" onclick="toggleAllFollow(this)"></th>
						<th>팔로워 ID</th>
						<th>팔로잉 ID</th>
						<th>팔로우 날짜</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="follow" items="${result.list}">
						<tr>
							<td><input type="checkbox" name="selectedFollows" value="${follow.follower_id}::${follow.followee_id}" /></td>
							<td>${follow.follower_id}</td>
							<td>${follow.followee_id}</td>
							<td>${follow.follow_date}</td>
						</tr>
					</c:forEach>
					<c:if test="${empty result.list}">
						<tr>
							<td colspan="4">검색 결과가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<div class="submit-btn-class">
				<button type="submit" onclick="return confirm('팔로우 관계를 삭제하시겠습니까?');">팔로우 관계 삭제</button>
			</div>
		</form>
	</c:if>

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
		const contextPath = "${contextPath}";
		function toggleAll(source) {
		    const checkboxes = document.querySelectorAll('input[name="selectedIds"]');
		    for (const checkbox of checkboxes) {
		        checkbox.checked = source.checked;
		    }
		}
		function toggleAllFollow(source) {
		    const checkboxes = document.querySelectorAll('input[name="selectedFollows"]');
		    for (const checkbox of checkboxes) {
		        checkbox.checked = source.checked;
		    }
		}
		function resetProfileImg(memberId) {
			const imgTag = document.getElementById("profileImg_" + memberId);
		    const inputTag = document.getElementById("profileImgInput_" + memberId);
		
		    imgTag.src = "${contextPath}/resources/icon/basic_profile.jpg";
		
		    inputTag.value = "";
		}
	</script>
</body>
</html>
