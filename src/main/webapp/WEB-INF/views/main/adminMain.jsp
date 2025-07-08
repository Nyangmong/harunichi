<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 대시보드</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
h1 {
	text-align: center;
	margin-bottom: 30px;
}

.stats-container {
	display: flex;
	justify-content: center;
	gap: 30px;
	flex-wrap: wrap;
	margin-bottom: 40px;
}

.stats-item {
	background: #fff;
	padding: 20px 30px;
	border: 1px solid #ddd;
	border-radius: 10px;
	min-width: 200px;
	text-align: center;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.stats-item strong {
	display: block;
	font-size: 16px;
	margin-bottom: 10px;
	color: #555;
}

.stats-item div {
	font-size: 22px;
	font-weight: bold;
	color: #333;
}

.charts-container {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	gap: 40px;
}

.chart-box {
	background: #fff;
	padding: 20px;
	border: 1px solid #ddd;
	border-radius: 10px;
	width: 400px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
.chart-box p {
	width: 100%;
	text-align: center; 
	margin-bottom: 15px;
	font-weight: bold;
}
canvas {
	display: block;
	width: 100% !important;
	height: auto !important;
}
</style>
</head>
<body>

	<h1>관리자 대시보드</h1>

	<div class="stats-container">
		<div class="stats-item">
			<strong>오늘 방문자 수</strong>
			<div>${todayVisit}</div>
		</div>
		<div class="stats-item">
			<strong>전체 누적 방문자 수</strong>
			<div>${totalVisit}</div>
		</div>
	</div>

	<div class="charts-container">
		<div class="chart-box">
			<p>7일 방문자수 현황</p>
			<canvas id="visitTrendChart"></canvas>
		</div>
		<div class="chart-box">
			<p>회원 성별 분포</p>
			<canvas id="genderChart"></canvas>
		</div>
		<div class="chart-box">
			<p>회원 국적 분포</p>
			<canvas id="countryChart"></canvas>
		</div>
	</div>

	<script>
		const visitTrendData = ${visitTrendJson};
		const genderData = ${genderDistJson};
		const countryData = ${countryDistJson};
		
		// 방문자 추이 그래프
		new Chart(document.getElementById('visitTrendChart'), {
		    type: 'line',
		    data: {
		        labels: visitTrendData.map(item => item.date),
		        datasets: [{
		            label: '방문자 수',
		            data: visitTrendData.map(item => item.cnt),
		            borderColor: '#4eaaff',
		            backgroundColor: 'rgba(78,170,255,0.2)',
		            fill: true
		        }]
		    },
		    options: {
		        responsive: true,
		        plugins: {
		            legend: { display: false }
		        }
		    }
		});
		
		// 성별 분포 도넛 그래프
		const genderColors = {
		  '남성': '#99ccff',      // 하늘색
		  '여성': '#ff9999',      // 분홍
		  '선택안함': '#cccccc'    // 회색
		};
		
		new Chart(document.getElementById('genderChart'), {
		    type: 'doughnut',
		    data: {
		        labels: genderData.map(item => item.label),
		        datasets: [{
		            data: genderData.map(item => item.value),
		            backgroundColor: genderData.map(item => genderColors[item.label])
		        }]
		    }
		});
		
		// 국적 분포 도넛 그래프
		const countryLabelsMap = {
		  'kr': '한국',
		  'jp': '일본',
		  '기타': '기타'
		};
		
		new Chart(document.getElementById('countryChart'), {
		    type: 'doughnut',
		    data: {
		        labels: countryData.map(item => countryLabelsMap[item.label] || item.label),
		        datasets: [{
		            data: countryData.map(item => item.value),
		            backgroundColor: ['#ffd966', '#93c47d', '#6fa8dc']
		        }]
		    }
		});
</script>

</body>
</html>
