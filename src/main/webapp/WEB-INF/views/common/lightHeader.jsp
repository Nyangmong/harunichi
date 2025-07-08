<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
<style>
.light-header-wrap {
	width: 100%;
	border-bottom: 1px solid #eee;
}

.light-header {
	width: calc(100% - 20px);
	max-width: 768px;
	margin: 0 auto;
}

.header-area {
	padding: 20px 0;
	display: flex;
	justify-content: space-between;
	font-size: 13px;
}

.header-area a img {
	height: 20px;
	vertical-align: middle;
}

.select2-container { /*셀렉트박스스타일*/
	width: 130px !important;
	vertical-align: middle;
}

.select2-container .select2-selection--single {
	height: 33px !important;
    line-height: 33px !important;
    display: flex !important;
    align-items: center;
	border: 1px solid #ddd;
	border-radius: 20px;
	outline: none;
	background-color: #fff;
}

.select2-container .select2-selection__rendered {
	color: #333;
	line-height: normal !important;
	padding-left: 0;
}

.select2-container .select2-selection__arrow {
	display: none !important;
}

.select2-dropdown { /*드롭다운박스스타일*/
	max-height: 200px;
	overflow-y: auto;
	border: 1px solid #ddd;
	border-radius: 15px;
	box-shadow: 0 3px 5px rgba(0, 0, 0, 0.1);
}

.select2-container--default .select2-results__option--highlighted.select2-results__option--selectable
	{
	background-color: #bfe6ff;
	color: #222;
}

.select2-results__option {
	padding: 10px 15px;
	cursor: pointer;
}

img.country-icon {
	width: 20px;
	height: auto;
	margin-right: 8px;
	vertical-align: middle;
}
</style>
</head>
<body>
	<section class="light-header-wrap">
		<div class="light-header">
			<div class="header-area">
				<a href="${contextPath}"><img
					src="${contextPath}/resources/icon/logo2.svg"></a> <select
					id="country-select" name="country">
					<option value="kr"
						data-image="${contextPath}/resources/icon/south-korea_icon.png"
						${selectedCountry == 'kr' ? 'selected' : ''}>Korea</option>
					<option value="jp"
						data-image="${contextPath}/resources/icon/japan_icon.png"
						${selectedCountry == 'jp' ? 'selected' : ''}>Japan</option>
				</select>
			</div>
		</div>
	</section>
</body>
</html>