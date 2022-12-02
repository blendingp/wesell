<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<body>
	<%-- <div class="assettitle">
		<spring:message code="wallet.property" />
	</div>
	<div class="deposit_warp1">
		<div class="asset_value" style="width:max-content;">
			<div class="assettxt1">
				<spring:message code="wallet.assetValue" />
			</div>
			<div class="assettxt2">
				SPOT <span id="wallet_spot"></span> 
				/ FUTURES <span id="wallet_futures"></span>
			</div>
		</div>
	</div> --%>
	<div class="deposit_warp2">
		<div class="btnarea">
			<a href="/global/user/p2pbuy.do" class="menubtn w-button refbuy">P2P <spring:message code="trade.trade"/></a>
			<a href="/global/user/p2pOrders.do" class="menubtn w-button reforder"><spring:message code="wallet.p2p.myOrder"/></a>
		</div>
	</div>
</body>
<script>
	var futures = "${futures}";
	var spot = "${spot}";
	var withdrawWallet = "${withdrawWallet}";
	var $wallet_spot = $("#wallet_spot");
	var $wallet_futures = $("#wallet_futures");
	function init() {
		if (!$(".ref" + "${refPage}").hasClass("click")) {
			$(".ref" + "${refPage}").addClass("click");
		}
	}
	$(function(){
		init();
		getWallet();
		setInterval(function() {
			getWallet()
		}, 5000);
	
		function getWallet() {
			$.ajax({
				type : 'post',
				dataType : 'json',
				url : '/global/user/getWallet.do',
				success : function(data) {
					futures = data.futures;
					spot = data.spot;
					withdrawWallet = data.withdrawWallet;
					$wallet_spot.text(toFixedDown(spot,5));
					$wallet_futures.text(toFixedDown(futures,5));
				},
				error : function(e) {
					console.log('ajax error ' + JSON.stringify(e));
				}
			})
		}
	});
</script>
