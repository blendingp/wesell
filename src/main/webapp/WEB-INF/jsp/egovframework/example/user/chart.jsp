<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<!--  This site was created in Webflow. https://www.webflow.com  -->
<!--  Last Published: Fri Mar 10 2023 05:40:03 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="636de9ea5f522693ef1606f7" data-wf-site="636de9ea5f52266a6d1606f1">
<head>
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
		<div class="c_section">
			<div class="c_list_block">
				<h1 class="c_title">Tokken Info</h1>
				<div class="mlist_block">
					<div class="list_top">
						<div class="list_box">
							<div><spring:message code="trade.symbol"/></div>
						</div>
						<div class="list_box">
							<div><spring:message code="trade.coin"/></div>
						</div>
						<div class="list_box _3">
							<div><spring:message code="trade.volume"/></div>
						</div>
						<div class="list_box _2">
							<div><spring:message code="wallet.p2p.detail"/></div>
						</div>
					</div>
					<c:forEach var="item" items="${list}">
						<div class="list">
							<div class="list_box">
								<div class="m_list_imgbox">
									<img src="/filePath/wesell/exchange/${item.symbol}" loading="lazy" alt="" class="list_img">
								</div>
							</div>
							<div class="list_box">
								<div>${item.coin}</div>
							</div>
							<div class="list_box _3">
								<div><fmt:formatNumber value="${item.volume}"/></div>
							</div>
							<div class="list_box _2">
								<a href="${item.link}" target="_blank" class="m_list_link">Go Detail</a>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
		<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=636de9ea5f52266a6d1606f1" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="/wesell/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
	<style>
	.list_frame::-webkit-scrollbar {
		display: none;
	}
	
	.list_frame {
		-ms-overflow-style: none;
	}
	
	.position_listblock1::-webkit-scrollbar {
		display: none;
	}
	
	.position_listblock1 {
		-ms-overflow-style: none;
	}
	
	.position_warp2::-webkit-scrollbar {
		display: none;
	}
	
	.position_warp2 {
		-ms-overflow-style: none;
	}
	
	.position_warp1::-webkit-scrollbar {
		display: none;
	}
	
	.position_warp1 {
		-ms-overflow-style: none;
	}
	</style>
</body>
</html>