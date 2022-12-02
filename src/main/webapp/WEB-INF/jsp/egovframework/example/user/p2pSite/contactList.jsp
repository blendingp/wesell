<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<jsp:include page="../../p2pSiteFrame/header.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../../p2pSiteFrame/top.jsp"></jsp:include>

		<div class="general_section wf-section">
			<div class="banner">
				<div class="banner_warp">
					<img src="/global/webflow/p2pImages/header_art1.png" loading="lazy"
						srcset="/global/webflow/p2pImages/header_art1-p-500.png 500w, /global/webflow/p2pImages/header_art1.png 547w"
						sizes="(max-width: 479px) 100vw, 300px" alt="" class="banner_img">
					<div class="m_head_box">
						<h1 class="m_head">문의하기</h1>
						<h2 class="m_head _3">
							운영시간: 09:00~18:00<br>
						</h2>
						<h4 class="m_head _2">문의사항을 남겨주시면 친절하게 답변해드리겠습니다.</h4>
					</div>
				</div>
			</div>
			<div class="general_block">
				<div class="deco"></div>
				<h1 class="general_title">문의내역</h1>
				<div class="scroll_warp">
					<div class="list_block">
						<div class="list_top">
							<div class="list _3 t">번호</div>
							<div class="list t">제목</div>
							<div class="list _2 t">내용</div>
							<div class="list _2 t">작성일</div>
						</div>
						<c:forEach var="item" items="${cList}">
							<div class="list_warp" style="cursor:pointer;" onclick="location.href='/global/easy/contactDetail.do?bidx=${item.idx}'">
								<div class="list _3">
									<div>${item.idx}</div>
								</div>
								<div class="list">
									<div>${item.title}</div>
								</div>
								<div class="list _2">
									<div>${item.content}</div>
								</div>
								<div class="list _2">
									<div><fmt:formatDate value="${item.cdate}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
				<div class="list_bottom">
					<div class="page_warp">
						<ui:pagination paginationInfo="${pi}" type="P2PPageUser" jsFunction="fn_egov_link_page" />
					</div>
					<div class="list_btn_warp">
						<a href="/global/easy/p2pCustomer.do" class="btn w-button">뒤로가기</a> 
						<a href="/global/easy/contactWrite.do" class="write w-inline-block"><img src="/global/webflow/p2pImages/icon_1.svg" loading="lazy" alt="" class="write_icon"> 문의작성</a>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../../p2pSiteFrame/footer.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="../js/webflow.js" type="text/javascript"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
	<script>
		function fn_egov_link_page(page){
			$("#pageIndex").val(page);
			$("#listform").submit();
		}
	</script>
</body>
</html>