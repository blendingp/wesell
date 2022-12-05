<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<div class="bottom">
	<div class="footer <c:if test="${nowpage eq 'tradep'}"> _2</c:if>">
		<div class="footer_block">
			<div class="f_wrap">
				<div class="footerlogoblock"><img src="/wesell/webflow/images2/wesell_logo.svg" loading="lazy" alt="" class="footerlogo"></div>
				<div class="footerlist_warp">
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="menu.deal" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/tradeSpot.do'"><spring:message code="newwave.menu.spotCoin"/></div>
						<%-- <div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/trade.do?betMode=inverse'"><spring:message code="menu.spotCoin"/></div> --%>
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="menu.depandwith" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/user/wallet.do'">
							<spring:message code="wallet.deposit"/>
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/user/walletWithdrwa.do'">
							<spring:message code="wallet.withdrawal"/>
						</div>
						 
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/user/transactions.do'">
							<spring:message code="wallet.DeandWithHistory_m"/> 
						</div> 
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="support.center" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/notice.do'">
							<spring:message code="menu.notice" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/faq.do'">
							<spring:message code="newwave.menu.faq"/>
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/user/helpCenter.do'">
							<spring:message code="submitRequest" />
						</div>
						
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="menu.mypage" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/user/tradeHistory.do'">
							<spring:message code="trade.tradeHistory" />
						</div>
<!-- 						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/wesell/user/fundingHistory.do'"> -->
<%-- 							<spring:message code="menu.fundingHistory"/> --%>
<!-- 						</div>						 -->
					</div>
				</div>
			</div>
          	<div class="copyright">Copyright ⓒ BITOCEAN All Rights Reserved.<a href="https://kr.freepik.com/" class="link"></a>
          	</div>
		</div>
	</div>
</div>
<!-- <script id="ze-snippet" src="https://static.zdassets.com/ekr/snippet.js?key=6a6127be-0ed3-4737-b291-ffad1cae3e54"> </script> -->
<!--End of Tawk.to Script-->
<script>
	function tradeShow() {
		if ($("#tradeSelect").css("display") == "none")
			$("#tradeSelect").css("display", "block");
		else
			$("#tradeSelect").css("display", "none");
	}
	function mypageShow() {
		if ($("#mypageSelect").css("display") == "none")
			$("#mypageSelect").css("display", "block");
		else
			$("#mypageSelect").css("display", "none");
	}
</script>
</html>