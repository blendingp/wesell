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
				<div class="footerlogoblock"><img src="/global/webflow/images/sub_logo1.svg" loading="lazy" alt="" class="footerlogo"></div>
				<div class="footerlist_warp">
					<div class="footerlist_block">
						<div class="footerlist_title" style="cursor: pointer;" onclick="location.href='/global/user/main.do'">
							<spring:message code="menu.main" />
						</div>
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="menu.deal" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/trade.do?betMode=usdt'"><spring:message code="menu.futuresCoin"/></div>
						<%-- <div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/trade.do?betMode=inverse'"><spring:message code="menu.spotCoin"/></div> --%>
						
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="detail.copy" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/traderList.do'"><spring:message code="trader.follow1"/></div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/traderFollowerOrder.do'"><spring:message code="trader.myTrading"/></div>
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="menu.depandwith" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/myasset.do'">
							<spring:message code="menu.depandwith"/>
						</div>
						<%-- <div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/kmyasset.do'">
							KRW <spring:message code="menu.depandwith"/>
						</div>
						 --%>
<!-- 						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/p2pbuy.do'"> -->
<%-- 							<spring:message code="wallet.p2p.trade_1"/> --%>
<!-- 						</div> -->
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="support.center" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/customerService.do'">
							<spring:message code="support.center" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/notice.do'">
							<spring:message code="menu.notice" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/faq.do'">
							<spring:message code="menu.faq"/>
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/helpCenter.do'">
							<spring:message code="submitRequest" />
						</div>
						
					</div>
					<div class="footerlist_block">
						<div class="footerlist_title">
							<spring:message code="menu.mypage" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/tradeHistory.do'">
							<spring:message code="trade.tradeHistory" />
						</div>
						<div class="footerlist" style="cursor: pointer;" onclick="location.href='/global/user/fundingHistory.do'">
							<spring:message code="menu.fundingHistory"/>
						</div>						
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