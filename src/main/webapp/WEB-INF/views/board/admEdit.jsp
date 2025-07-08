<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정 - 관리자</title>
    <style>
        body {
            font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
            margin: 20px;
            background-color: #f4f7f6;
            color: #333;
        }
        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2em;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 15px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 15px;
            border: 1px solid #e0e0e0;
            text-align: left;
            vertical-align: top;
        }
        th {
            background-color: #f8f8f8;
            width: 150px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], textarea, select {
            width: calc(100% - 22px); /* 패딩 고려 */
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1em;
            box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
        }
        textarea {
            resize: vertical;
            min-height: 150px;
        }
        input[readonly] {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        .button-group {
            text-align: center;
            margin-top: 40px;
        }
        .button-group button {
            padding: 12px 25px;
            margin: 0 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.1em;
            transition: background-color 0.3s ease;
        }
        .button-group button.save {
            background-color: #28a745; /* Green */
            color: white;
        }
        .button-group button.save:hover {
            background-color: #218838;
        }
        .button-group button.cancel {
            background-color: #dc3545; /* Red */
            color: white;
        }
        .button-group button.cancel:hover {
            background-color: #c82333;
        }
        .image-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        .image-preview img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .no-image {
            color: #888;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>게시글 수정</h2>
        <form action="${contextPath}/board/admin/updateAdmin" method="post">
            <table>
                <tr>
                    <th>번호</th>
                    <td>
                        ${board.boardId}
                        <input type="hidden" name="boardId" value="${board.boardId}"/>
                    </td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td><input type="text" name="boardWriter" value="${board.boardWriter}" readonly/></td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td><textarea name="boardCont">${board.boardCont}</textarea></td>
                </tr>
                <tr>
                    <th>카테고리</th>
                    <td>
                        <select name="boardCate">
                            <option value="일상" ${board.boardCate == '일상' ? 'selected' : ''}>일상</option>
                            <option value="생활정보" ${board.boardCate == '생활정보' ? 'selected' : ''}>생활정보</option>
                            <!-- 필요한 다른 카테고리 추가 -->
                            <option value="공지" ${board.boardCate == '공지' ? 'selected' : ''}>공지</option>
                            <option value="자유" ${board.boardCate == '자유' ? 'selected' : ''}>자유</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>작성일</th>
                    <td><fmt:formatDate value="${board.boardDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>조회수</th>
                    <td>${board.boardCount}</td>
                </tr>
                <tr>
                    <th>좋아요</th>
                    <td>${board.boardLike}</td>
                </tr>
                <tr>
                    <th>댓글수</th>
                    <td>${board.boardRe}</td>
                </tr>
                <tr>
                    <th>이미지</th>
                    <td>
                        <div class="image-preview">
                            <c:set var="hasImage" value="false"/>
                            <c:if test="${not empty board.boardImg1}">
                                <img src="${contextPath}/images/board/${board.boardImg1}" alt="이미지1"/>
                                <c:set var="hasImage" value="true"/>
                            </c:if>
                            <c:if test="${not empty board.boardImg2}">
                                <img src="${contextPath}/images/board/${board.boardImg2}" alt="이미지2"/>
                                <c:set var="hasImage" value="true"/>
                            </c:if>
                            <c:if test="${not empty board.boardImg3}">
                                <img src="${contextPath}/images/board/${board.boardImg3}" alt="이미지3"/>
                                <c:set var="hasImage" value="true"/>
                            </c:if>
                            <c:if test="${not empty board.boardImg4}">
                                <img src="${contextPath}/images/board/${board.boardImg4}" alt="이미지4"/>
                                <c:set var="hasImage" value="true"/>
                            </c:if>
                            <c:if test="${!hasImage}">
                                <p class="no-image">등록된 이미지가 없습니다.</p>
                            </c:if>
                        </div>
                        <!-- 이미지 변경 기능을 추가하려면 <input type="file"> 태그를 여기에 추가해야 합니다. -->
                        <!-- 파일 업로드는 multipart/form-data 인코딩 타입과 별도의 처리가 필요합니다. -->
                        <!-- 현재는 기존 이미지를 보여주기만 합니다. -->
                    </td>
                </tr>
            </table>
            <div class="button-group">
                <button type="submit" class="save" onclick="return confirm('게시글을 수정하시겠습니까?');">저장</button>
                <button type="button" class="cancel" onclick="location.href='${contextPath}/board/admin';">취소</button>
            </div>
        </form>
    </div>
</body>
</html>
