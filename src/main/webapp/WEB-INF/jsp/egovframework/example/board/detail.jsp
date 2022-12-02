<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html data-wf-page="62b181be37670240d0464eb6" data-wf-site="62b1125ac4d4d60ab9c62f81">
<head>
<meta charset="utf-8">
<title>detail</title>
<meta content="detail" property="og:title">
<meta content="detail" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
</head>
<body class="body1">
	<div class="frame">
		<div class="form-block w-form">
			<form id="email-form" name="email-form" data-name="Email Form">
				<jsp:include page="../userFrame/top.jsp"></jsp:include>
				<div class="frame5">
					<jsp:include page="../userFrame/customerBanner.jsp"></jsp:include>
					
					<div class="custermer_listblock">
						<div class="custermer_titlewarp">
							<div class="title6">
								<c:if test="${type eq 'notice'}">
									<spring:message code="support.notice" />
								</c:if>
								<c:if test="${type eq 'faq'}">
									<spring:message code="menu.faq" />
								</c:if>
							</div>
						</div>
						<div class="detail_titleblock" style="word-break:break-all;">
							<div class="title3">
								${item.btitle}
							</div>
							<div class="subtitle_block">
								<div class="subtitle writer"><spring:message code="detail.writer" />:<spring:message code="root.project"/></div>
								<div class="subtitle date">${item.bdate }</div>
								<!-- <div class="subtitle">조회수: 0</div> -->
							</div>
						</div>
						<div class="detail_textblock">
							<div class="detailtextwarp">
								<div class="text-block-5" style="word-break: break-all;"> ${text}</div>
							</div>
						</div>
					<div class="detail_btnblcok">
						<a href="/global/${type}.do" class="button-17 w-button"><spring:message code="button.list"/> </a>
					</div>
					</div>
				</div>
			</form>
			<jsp:include page="../userFrame/footer.jsp"></jsp:include>
		</div>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=615fe8348801178bd89ede05" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
</html>