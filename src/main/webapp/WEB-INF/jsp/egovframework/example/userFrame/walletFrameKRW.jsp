<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<div class="deposit_warp2">
	<div class="btnarea">
		<a href="/wesell/user/kWallet.do" class="menubtn w-button refwallet">KRW <spring:message code="wallet.deposit"/></a>
		<a href="/wesell/user/kWalletWithdraw.do" class="menubtn w-button refwithdraw">KRW <spring:message code="wallet.withdrawal"/></a>
		<a href="/wesell/user/kTransactions.do" class="menubtn w-button reftransactions">KRW <spring:message code="wallet.DeandWithHistory_m"/></a>
	</div>
</div>
<script type="text/javascript">
	function init() {
		if (!$(".ref" + "${refPage}").hasClass("click")) {
			$(".ref" + "${refPage}").addClass("click");
		}
	}
	init();
</script>