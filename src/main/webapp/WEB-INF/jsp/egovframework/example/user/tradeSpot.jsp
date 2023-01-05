<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.*"%>
<!DOCTYPE>
<html data-wf-page="6073d35203881b27b97cdb95"
	data-wf-site="6073d35203881b197a7cdb93">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<style>
input[type="number"]::-webkit-outer-spin-button, input[type="number"]::-webkit-inner-spin-button
	{
	-webkit-appearance: none;
	margin: 0;
}

.hogablock {
	cursor: pointer;
}

input[type=range]::-webkit-slider-thumb {
	-webkit-appearance: none;
	background: #37d0d7;
	cursor: pointer;
	height: 20px;
	width: 20px;
	border-radius: 10px;
	background-color: #37d0d7;
}

.tradebtn1-1 {
	font-size: 12px;
}

.graphred {
	width: 0%;
}
</style>

<body class="body-2">
	<div class="frame">
		<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
		<div class="trade_frame">
			<div class="trade_topblock">
				<div class="tradetop_coin in" onclick="coinMenu()">
					<img src="/wesell/webflow/images/BTCicon_img_1.png" loading="lazy" alt="" class="image coinImg coinBTC">
					<img src="/wesell/webflow/images/XRPicon45.png" loading="lazy" alt="" class="image coinImg coinXRP" style="display:none;">
					<img src="/wesell/webflow/images/ETHicon45.png" loading="lazy" alt="" class="image coinImg coinETH" style="display:none;">
					<img src="/wesell/webflow/images/TRXicon45.png" loading="lazy" alt="" class="image coinImg coinTRX" style="display:none;">
					<div class="coinsub"><span class="qtycoinm">BTC</span>/USD</div>
					<img src="/wesell/webflow/images/arrow_up_white.svg" loading="lazy" alt="" class="image-41">
					<div class="trade_coinsub _1" id="coinMenu" style="display:none; padding-top:0; top:100%;">
						<div class="trade_coiningo_warp">
							<div class="div-block-116">
								<div class="coinsub_toptxt"><spring:message code="trade.coin"/></div>
								<div class="coinsub_toptxt"><spring:message code="trade.price"/></div>
								<div class="coinsub_toptxt" style="width:25%;"><spring:message code="trade.changeRate"/></div>
								<div class="coinsub_toptxt"></div>
							</div>
							<c:forEach var="item" items="${useCoins}">
								<c:set var="lowCoin" value="${fn:toLowerCase(item)}"/>
								<div class="trade_coinsublist coin_${lowCoin} changecoin" ctype="coin_${item}USDT">
									<c:choose>
										<c:when test="${item eq 'BTC'}"><img src="/wesell/webflow/images/BTCicon_img_2BTCicon_img.png" loading="lazy" alt="" class="image-42"></c:when>
										<c:when test="${item eq 'ETH'}"><img src="/wesell/webflow/images/ETHicon45.png" loading="lazy" alt="" class="image-42"></c:when>
										<c:when test="${item eq 'TRX'}"><img src="/wesell/webflow/images/TRXicon45.png" loading="lazy" alt="" class="image-42"></c:when>
										<c:when test="${item eq 'XRP'}"><img src="/wesell/webflow/images/XRPicon45.png" loading="lazy" alt="" class="image-42"></c:when>
									</c:choose>
									<div class="text-block-15">${item}</div>
									<div class="runtimequote-copy up"><span class="coinval color"></span></div>
									<div class="coinsub_info">
										<div class="coininfo1">
											<div class="coinsub_infotxt right color"><span class="persentage">0</span>%</div>
										</div>
										<div class="coininfo2">
											<div class="coinsub_infotxt right color"><span class="arrowUp"></span>&ensp;<span class="change"></span></div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
				<div class="tradetop_coin _2" onclick="infoMenu()">
					<div class="coinsub">24h info</div>
					<img src="/wesell/webflow/images/arrow_up_white.svg" loading="lazy" alt=""
						class="image-41">
					<div class="trade_coinsub _2" id="infoMenu">
						<div class="_24h_box mobile">
							<div class="div-block-115">
								<div class="top_runtimequote down mainsise"></div>
								<div class="topblock_quotebox up"><span class="coinpersent">0.000</span>%</div>
							</div>
							<div class="_24hinfo">
								<div class="_24hinfolist">
									<div class="_24hsub"><spring:message code="trade.24change"/></div>
									<div class="_24hinfo_txt low coininfo persent" style="font-size:larger;"></div>
								</div>
								<div id="w-node-_5848ec9d-4164-b3c0-27aa-ed73a5b2926b-2f80ef7e" class="_24hinfolist">
									<div class="_24hsub"><spring:message code="trade.24high"/></div>
									<div class="_24hinfo_txt high id24high"></div>
								</div>
								<div class="_24hinfolist">
									<div class="_24hsub"><spring:message code="trade.24low"/></div>
									<div class="_24hinfo_txt low id24low"></div>
								</div>
								<div class="_24hinfolist">
									<div class="_24hsub"><spring:message code="trade.24turnover"/>(USD<c:if test="${betMode eq 'usdt'}">T</c:if>)</div>
									<div class="_24hinfo_txt id24highQty"></div>
								</div>
<!-- 								<div class="_24hinfolist"> -->
<%-- 									<div class="_24hsub"><spring:message code="trade.funding"/> / <spring:message code="trade.countdown"/></div> --%>
<!-- 									<div class="_24hblock1"> -->
<!-- 										<div class="funding_ratetxt up idfRate">0.0000%</div> -->
<!-- 										<div class="slash">/</div> -->
<!-- 										<div class="_24hinfo_txt idtimer">00:00:00</div> -->
<!-- 									</div> -->
<!-- 								</div> -->
							</div>
						</div>
					</div>
				</div>
				<div class="inverse_sub">
					<img src="/wesell/webflow/images/BTCicon_img_1.png" loading="lazy" alt="" class="image coinImg coinBTC">
					<img src="/wesell/webflow/images/XRPicon45.png" loading="lazy" alt="" class="image coinImg coinXRP" style="display:none;">
					<img src="/wesell/webflow/images/ETHicon45.png" loading="lazy" alt="" class="image coinImg coinETH" style="display:none;">
					<img src="/wesell/webflow/images/TRXicon45.png" loading="lazy" alt="" class="image coinImg coinTRX" style="display:none;">
					<div class="coinsub"><span class="qtycoinm">BTC</span>/USD</div>
				</div>
				<div class="_24h_box">
					<div class="div-block-115">
						<div class="top_runtimequote down coinpri-n mainsise"></div>
						<div class="topblock_quotebox up">
							<span class="coinpersent"></span>%
						</div>
					</div>
					<div class="_24hinfo">
						<div class="_24hinfolist">
							<div class="_24hsub">
								<spring:message code="trade.24change" />
							</div>
							<div class="_24hinfo_txt low coininfo persent"></div>
						</div>
						<div id="w-node-_38b0f3ae-fc30-412c-401a-8ad61844a47b-c00b95be"
							class="_24hinfolist">
							<div class="_24hsub">
								<spring:message code="trade.24high" />
							</div>
							<div class="_24hinfo_txt high id24high"></div>
						</div>
						<div class="_24hinfolist">
							<div class="_24hsub">
								<spring:message code="trade.24low" />
							</div>
							<div class="_24hinfo_txt low id24low"></div>
						</div>
						<div class="_24hinfolist">
							<div class="_24hsub">
								<spring:message code="trade.24turnover" />
								(USD)
							</div>
							<div class="_24hinfo_txt id24highQty"></div>
						</div>
<!-- 						<div class="_24hinfolist"> -->
<!-- 							<div class="_24hsub"> -->
<%-- 								<spring:message code="trade.funding" /> --%>
<!-- 								/ -->
<%-- 								<spring:message code="trade.countdown" /> --%>
<!-- 							</div> -->
<!-- 							<div class="_24hblock1"> -->
<!-- 								<div class="funding_ratetxt up idfRate">0.0000%</div> -->
<!-- 								<div class="slash">/</div> -->
<!-- 								<div class="_24hinfo_txt idtimer">00:00:00</div> -->
<!-- 							</div> -->
<!-- 						</div> -->
					</div>
				</div>
			</div>
			<div class="mob_tradingbtn">
				<a href="javascript:mobileBlockChange('chart')" id="movchart"
					class="button-12 transaction w-button"><spring:message
						code="trade.chart" /></a> <a
					href="javascript:mobileBlockChange('order')" id="movorder"
					class="button-12 chart select w-button"><spring:message
						code="main.Margin_1" /></a>
			</div>
			<div class="trade_mainframe _2">
				<div class="trade_block _2">
					<div class="trade_block3">
						<div class="inverse_coin">
<%-- 							<h3 class="in_head"><spring:message code="trade.coin"/></h3> --%>
							<div class="in_coin_sub_t">
								<div class="in_list"><spring:message code="trade.coin"/></div>
								<div class="in_list _2">
									<div><spring:message code="trade.price"/></div>
								</div>
								<div class="in_list _2">
									<div><spring:message code="trade.changeRate"/></div>
								</div>
							</div>
							<div class="scroll">
								<c:forEach var="item" items="${useCoins}" varStatus="status">
									<c:set var="lowCoin" value="${fn:toLowerCase(item)}" />
									<c:if test="${status.index < 4}">
										<a href="#"
											class="in_coin_sub w-inline-block coin_${lowCoin} changecoin"
											ctype="coin_${item}USDT">
											<div class="in_list">
												<c:choose>
													<c:when test="${item eq 'BTC'}">
														<img src="/wesell/webflow/images/BTCicon_img_2BTCicon_img.png" loading="lazy" alt="" class="coin_img">
													</c:when>
													<c:when test="${item eq 'ETH'}">
														<img src="/wesell/webflow/images/ETHicon45.png" loading="lazy" alt="" class="coin_img">
													</c:when>
													<c:when test="${item eq 'TRX'}">
														<img src="/wesell/webflow/images/TRXicon45.png" loading="lazy" alt="" class="coin_img">
													</c:when>
													<c:when test="${item eq 'XRP'}">
														<img src="/wesell/webflow/images/XRPicon45.png" loading="lazy" alt="" class="coin_img">
													</c:when>
												</c:choose>
												<div>${item}</div>
											</div>
											<div class="in_list _2">
												<div class="coinval color"></div>
											</div>
											<div class="in_list _2 long">
												<div class="color">
													<span class="persentage">0</span>%
												</div>
											</div>
										</a>
									</c:if>
								</c:forEach>
							</div>
						</div>
						<div class="chartblock chart all">
							<div class="chart" style="width: 100%;">
								<div class="chartcontents">
									<div class="chartmain-n" style="height: auto;">
										<div class="graphbox"
											style="width: 100%; height: 100%; position: relative;">
											<!-- 										TradingView Widget BEGIN -->
											<div id="futuresChart" class="futuresChart"
												style="width: 100%; height: 100%; position: relative;">
											</div>
											<!-- 										TradingView Widget END -->
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="orderbox1 _2" id="transactionsBook">
							<div class="orderbook_block">
								<div class="orderbook_top pc">
									<%-- <a onclick="orderBookTab('orderbook',this)"
										class="orderbook_btn click w-inline-block">
										<div class="title1">
											<spring:message code="trade.orderbook2" />
										</div>
									</a>  --%>
									<a onclick="orderBookTab('tradehistory',this)"
										class="orderbook_btn click w-inline-block">
										<div class="title1">
											<spring:message code="trade.recentTrade"/>
										</div>
									</a>
								</div>
								<div class="d_listwrap orderbook all ob">
									<div class="orderlist ordertable">
										<div class="orderobox _2">
											<div class="text">
												<spring:message code="trade.price"/>(USDT)<br>
											</div>
											<div class="text _2">
												<spring:message code="trade.quantity"/>(<span class="qtycoinm">BTC</span>)<br>
											</div>
											<div class="text _3">
												<spring:message code="trade.total"/>(<span class="qtycoinm">BTC</span>)<br>
											</div>
										</div>
										<c:forEach begin="0" end="6" step="1">
											<div class="orderobox longhoga hogablock">
												<div class="usdt-2 green hp long"></div>
												<div class="hgraph graphred green"></div>
												<div class="highlight">
													<div class="amount hq"></div>
												</div>
												<div class="highlight _2">
													<div class="amount hsum"></div>
												</div>
											</div>
										</c:forEach>
									</div>
									<div class="div-block-22">
										<div class="present_price sise" id="longSise"></div>
										<div class="present_price siseArrow"></div>
									</div>
									<div class="orderlist ordertable">
										<c:forEach begin="0" end="6" step="1">
											<div class="orderobox shorthoga hogablock">
												<div class="usdt-2 red hp short"></div>
												<div class="hgraph graphred red"></div>
												<div class="highlight">
													<div class="amount hq"></div>
												</div>
												<div class="highlight _2">
													<div class="amount hsum"></div>
												</div>
											</div>
										</c:forEach>
									</div>
								</div>
								<div class="markettrade tradehistory ob">
									<div class="tradehistory_top">
										<div class="trademarket_txtbox">
											<spring:message code="th.price" />
											(USD)
										</div>
										<div class="trademarket_txtbox">
											<spring:message code="trade.quantity"/>
											(<span class="qtycoinm">BTC</span>)
										</div>
										<div class="trademarket_txtbox time">
											<spring:message code="th.time" />
										</div>
									</div>
									<div id="tradehistory"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="order_block" id="tabbox_pos">
						<div class="order_topbtnlist">
							<a href="javascript:cOrdersTabChange('cOrders')" class="order_topbtn w-button cOrdertap cOrders click"><spring:message code="trade.cOrders"/></a> 
							<a href="javascript:cOrdersTabChange('cAssets')" class="order_topbtn w-button cOrdertap cAssets"><spring:message code="trade.asset"/></a>
			            </div>
			            <div class="cOrderblock cOrders">
							<!-- <div class="order_topbtnlist">
								<a href="javascript:positionTabChange('olist')" class="type_btn click w-button tabbtn olist">Limit&amp;Market Orders</a>
								<a href="javascript:positionTabChange('stopMarket')" class="type_btn w-button tabbtn stopMarket">TP/SL Orders</a>
								<a href="#" class="type_btn w-button">Conditional Orders</a>
							</div> -->
							<!-- ORDER -->
							<div class="inverse_p c1 olist bigBox">
								<div class="in_p_top">
									<div class="in_p_list coin"><spring:message code="trade.spotPairs"/></div>
									<div class="in_p_list"><spring:message code="trade.ordertype"/></div>
									<div class="in_p_list"><spring:message code="trade.direction"/></div>
									<div class="in_p_list"><spring:message code="trade.order"/> <spring:message code="trade.value"/></div>
									<div class="in_p_list"><spring:message code="trade.order"/> <spring:message code="trade.price"/></div>
									<div class="in_p_list"><spring:message code="trade.qty"/></div>
									<div class="in_p_list"><spring:message code="trade.filled"/></div>
									<div class="in_p_list"><spring:message code="trade.unfilled"/>	</div>
									<div class="in_p_list"><spring:message code="trade.time"/></div>
									<div class="in_p_list"><spring:message code="th.order"/></div>
									<div class="in_p_list _2"><spring:message code="trade.cancel"/></div>
								</div>
								<c:forEach begin="0" end="3" varStatus="status">
									<div class="in_p_scroll positionOrderList" id="orderLongList${status.index}" style="display: none;" style="display:block;"></div>
								</c:forEach>
							</div>
	
							<!-- STOP MARKET -->
							<div class="inverse_p c2 stopMarket bigBox" style="display: none">
								<div class="in_p_top">
									<div class="in_p_list coin"><spring:message code="trade.spotPairs"/></div>
									<div class="in_p_list"><spring:message code="trade.ordertype"/></div>
									<div class="in_p_list"><spring:message code="trade.direction"/></div>
									<div class="in_p_list"><spring:message code="trade.order"/> <spring:message code="trade.value"/></div>
									<div class="in_p_list"><spring:message code="trade.order"/> <spring:message code="trade.price"/></div>
									<div class="in_p_list"><spring:message code="trade.qty"/></div>
									<div class="in_p_list"><spring:message code="trade.filled"/></div>
									<div class="in_p_list"><spring:message code="trade.unfilled"/>	</div>
									<div class="in_p_list"><spring:message code="trade.time"/></div>
									<div class="in_p_list"><spring:message code="th.order"/></div>
									<div class="in_p_list _2"><spring:message code="trade.cancel"/></div>
								</div>
								<div class="in_p_scroll stopMarket">
									<c:forEach begin="0" end="3" varStatus="status">
										<div class="in_p_list_block positionOrderList" id="orderStopList${status.index}" style="display: none;"></div>
									</c:forEach>
								</div>
							</div>
			            
			            </div>


						<div class="inverse_p h cOrderblock cAssets" style="display:none;">
							<div class="in_p_top">
								<div class="in_p_list coin"><spring:message code="trade.coin"/></div>
								<div class="in_p_list"><spring:message code="wallet.property"/></div>
								<div class="in_p_list"><spring:message code="trade.valAmount"/></div>
								<div class="in_p_list"><spring:message code="trade.avebuy"/></div>
								<div class="in_p_list"><spring:message code="trade.buyPrice"/></div>
								<div class="in_p_list"><spring:message code="trade.pnl"/></div>
								<div class="in_p_list"><spring:message code="trade.yield"/></div>
							</div>
							<div class="in_p_scroll">
								<div class="in_p_list_block">
									<c:forEach var="coin" items="${useCoins}">
										<c:choose>
											<c:when test="${coin eq 'BTC'}"><c:set var="cnum" value="0"/></c:when>										
											<c:when test="${coin eq 'ETH'}"><c:set var="cnum" value="1"/></c:when>										
											<c:when test="${coin eq 'XRP'}"><c:set var="cnum" value="2"/></c:when>										
											<c:when test="${coin eq 'TRX'}"><c:set var="cnum" value="3"/></c:when>										
										</c:choose>
										<div class="in_p_list_box" id="spotAsset${cnum}">
											<div class="in_p_list coin">${coin}</div>
											<div class="in_p_list"><span class="nowBalance"></span>&ensp;${coin}</div>
											<div class="in_p_list"><span class="currentPrice"></span></div>
											<div class="in_p_list"><span class="buyPrice_ave"></span></div>
											<div class="in_p_list"><span class="buyPrice"></span></div>
											<div class="in_p_list profitcolor"><span class="buyProfit"></span></div>
											<div class="in_p_list profitcolor"><span class="buyProfitRate"></span></div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>

					</div>
				</div>
				<div class="tradeblock1 _2" id="orderblock">
					<div class="in_t_btnarea">
						<a href="javascript:setBuyOrSell('long')"
							class="in_p_btn _1 w-button buybtn"><spring:message code="wallet.p2p.buy"/></a> <a
							href="javascript:setBuyOrSell('short')"
							class="in_p_btn w-button sellbtn"><spring:message code="wallet.p2p.sell"/></a>
					</div>
					<div class="in_t_sub_area">
						<a href="javascript:setOrderType('limit')" class="in_t_sub w-button limit_btn orderTypeBtn"><spring:message code="trade.limit"/></a>
						<a href="javascript:setOrderType('market')" class="in_t_sub click w-button market_btn orderTypeBtn"><spring:message code="trade.market"/></a>
					</div>
					<div class="in_t_block limit">
						<div class="in_warp">
							<div class="in_title"><spring:message code="wallet.available"/></div>
							<div>
								<span class="wallet1" id="wallet1">${walletUSDT}</span> USDT
							</div>
						</div>
						<div class="form-block w-form">
							<form class="form">
								<div class="trade_inputbox">
									<div class="s_txt"><spring:message code="trade.order"/> <spring:message code="trade.price"/></div>
									<input type="text" class="text-field w-input" id="dealSise"
										min="0" maxlength="15" style="background-color: transparent;">
									<div class="s_txt">USDT</div>
								</div>
								<div class="trade_inputbox">
									<div class="s_txt"><spring:message code="trade.qty"/></div>
									<input type="text" class="text-field w-input" value="0.00000" id="qty" min="0" maxlength="15" onInput="qtyKeyInput()">
									<div class="s_txt"><span class="qtycoinm">BTC</span></div>
								</div>
								<div class="trade_p_btnblock">
									<a href="javascript:assetPercent(0.1)" class="tpsl_btn left w-button">10 %</a>
									<a href="javascript:assetPercent(0.25)" class="tpsl_btn w-button">25 %</a>
									<a href="javascript:assetPercent(0.5)" class="tpsl_btn w-button">50 %</a>
									<a href="javascript:assetPercent(0.75)" class="tpsl_btn w-button">75%</a>
									<a href="javascript:assetPercent(1)" class="tpsl_btn right w-button">100 %</a>
								</div>
								<div class="trade_inputbox">
									<div class="s_txt"><spring:message code="trade.order"/> <spring:message code="trade.value"/></div>
									<input type="text" class="text-field w-input" value="0.00000" id="qtyUSDT" min="0" maxlength="15" onInput="qtyKeyInputUSDT()">
									<div class="s_txt">USDT</div>
								</div>
							</form>

						</div>
						<a href="javascript:openDealPop('long')" class="in_t_btn buy w-button finalBuyBtn"><spring:message code="trade.buy"/> / <span class="qtycoinm">BTC</span>USD</a>
						<a href="javascript:openDealPop('short')" class="in_t_btn sell w-button finalSellBtn" style="display: none"><spring:message code="trade.sell"/> / <span class="qtycoinm">BTC</span>USD</a>
					</div>


					<div class="usdt-asset">
						<div class="order_title">
							<spring:message code="trade.asset"/><a href="//user/wallet.do" class="deposit"><spring:message code="trade.buy"/> <spring:message code="trade.coin"/> ▶</a>
						</div>
						<div class="tradelistbox2">
							<div class="assetlist">
								<div class="ordertxt4">USDT <spring:message code="wallet.available"/></div>
								<div class="ordertxt3 usdtWallet" id="usdtWallet">${walletUSDT}USDT</div>
							</div>
						</div>
						<div class="assetlist">
							<div class="ordertxt4"><span class="qtycoinm">BTC</span> <spring:message code="wallet.available"/></div>
							<div class="ordertxt3 spotWallet" id="spotWallet">${walletBTC}BTC</div>
						</div>
						<div class="in_asset_btnarea">
							<a href="//user/wallet.do" class="in_asset_btn w-button"><spring:message code="wallet.deposit"/></a> 
							<a href="//user/transfer.do" class="in_asset_btn w-button"><spring:message code="wallet.transfer"/></a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="chart_bottom">
			<div class="bottom_btn">
				<div><spring:message code="trade.asset"/></div>
				<img src="/wesell/webflow/images/arrow_up_white.svg" loading="lazy" alt="" class="bottom_btnimg">
			</div>
			<div class="bottom_box">
				<div class="usdt-asset b">
					<div class="order_title">
						USDT Asset<a href="//user/wallet.do" class="deposit"><spring:message code="trade.buy"/> <spring:message code="trade.coin"/> ▶</a>
					</div>
					<div class="tradelistbox2">
						<div class="assetlist">
							<div class="ordertxt4">USDT <spring:message code="wallet.available"/></div>
							<div class="ordertxt3"><span class="usdtWallet"></span></div>
						</div>
					</div>
					<div class="assetlist">
						<div class="ordertxt4"><span class="qtycoinm">BTC</span> <spring:message code="wallet.available"/></div>
						<div class="ordertxt3 spotWallet">0 BTC</div>
					</div>
					<div class="in_asset_btnarea">
						<a href="//user/wallet.do" class="in_asset_btn w-button"><spring:message code="wallet.deposit"/></a> 
						<a href="//user/transfer.do" class="in_asset_btn w-button"><spring:message code="wallet.transfer"/></a>
					</div>
				</div>
			</div>
		</div>

		<!-- ..............................팝업............................. -->
		<!-- 거래팝업 -->
		<div class="popup" id="dealpop">
			<div class="tradepop">
				<div class="tradingpop_in" style="display: flex">
					<div class="in_trade_tbox">
						<div>
							<span class="position_span long" id="popOrderType">Limit </span><span class="position_span long" id="popBuySell"> </span> BTC
						</div>
						<div class="pop_exsit_2" onClick="javascript:closeDealPop();" style="cursor: pointer">
							<img src="/wesell/webflow/images/wx_black.png" loading="lazy" sizes="100vw" srcset="/wesell/webflow/images/wx_black-p-500.png 500w, /wesell/webflow/images/wx_black-p-800.png 800w, /wesell/webflow/images/wx_black-p-1080.png 1080w, /wesell/webflow/images/wx_black.png 1600w" alt="" class="image-38">
						</div>
					</div>
					<div class="in_trade_block">
						<!-- <div class="tradepop_warp">
	              <div class="text-block-10">Trigger Price</div>
	              <div>1000000.000000 USDT</div>
	            </div> -->
						<div class="tradepop_warp">
							<div class="text-block-10"><spring:message code="trade.order"/> <spring:message code="trade.price"/></div>
							<div id="popOrderPrice">1000000.000000 USDT</div>
						</div>
						<div class="tradepop_warp">
							<div class="text-block-10"><spring:message code="trade.qty"/></div>
							<div id="popBTC">1000000.000000 BTC</div>
						</div>
						<div class="tradepop_warp">
							<div class="text-block-10">><spring:message code="trade.order"/> <spring:message code="trade.value"/></div>
							<div id="popUSDT">
								1000000.000000 USDT<br>&zwj;<span class="o_value">≈0.75 USD</span>
							</div>
						</div>
						<div class="pop_btn">
							<a href="javascript:closeDealPop();" class="button-15-copy w-button"><spring:message code="trade.cancel"/></a>
							<a href="javascript:buy()" class="button-15 w-button"><spring:message code="trade.apply_2"/></a>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- 경고팝업 -->
		<div class="utillitypop" id="alertpop"
			style="position: fixed; z-index: 100000; display: flex; pointer-events: none; justify-content: flex-start; flex-direction: column; margin-top: 5%;"></div>


		<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
	</div>
	<div style="display: none">
		<div class="notBalance">
			<spring:message code='pop.transfer.notBalance' />
		</div>
		<div class="nonBalanceCancel">
			<spring:message code='pop.show.nonBalanceCancel' />
		</div>
		<div class="orderRun">
			<spring:message code='pop.show.orderRun' />
		</div>
		<div class="orderQuantitiesRun">
			<spring:message code='pop.show.orderQuantitiesRun' />
		</div>
		<div class="orderFailCancel">
			<spring:message code='pop.show.orderFailCancel' />
		</div>
		<div class="nonBalanceNotOrderRun">
			<spring:message code='pop.show.nonBalanceNotOrderRun' />
		</div>
		<div class="orderRegister">
			<spring:message code='pop.show.orderRegister' />
		</div>
		<div class="changeLev">
			<spring:message code='pop.show.changeLev' />
			p
		</div>
		<div class="wrongApproach">
			<spring:message code='pop.show.wrongApproach' />
		</div>
		<div class="liqPos">
			<spring:message code='pop.show.liqPos' />
		</div>
		<div class="buyPos">
			<spring:message code='pop.show.buyPosSpot' />
		</div>
		<div class="maxDividend">
			<spring:message code='pop.show.maxDividend' />
		</div>
		<div class="maxSize">
			<spring:message code='pop.trade.maxSize' />
		</div>
		<div class="wrongUser">잘못된 접속입니다. 재접속</div>
		<div class="wrongSymbol">잘못된 종목 선택</div>
		<div class="wrongQuantity">수량이 너무 작습니다.</div>
		<div class="wrongQuantity">
			<spring:message code='pop.wallet.lowQty' />
		</div>
		<div class="wrongEntryPrice">
			<spring:message code='pop.wallet.lowPrice' />
		</div>
		<div class="crossLevFail">
			<spring:message code='pop.trade.crossLevChangeFail' />
		</div>
		<div class="copyLevFail">
			<spring:message code='trade.copyLevFail' />
		</div>
		<div class="copyBuyFail">
			<spring:message code='trade.copyBuyFail' />
		</div>
		<div class="orderCancel">
			<spring:message code='pop.show.orderCancel' />
		</div>
		<div class="p2pStop">
			<spring:message code='trade.p2pStop' />
		</div>
		<div class="TPErr_more">
			<spring:message code="trade.TP_full" />
			<spring:message code='trade.TPSLErr_more' />
		</div>
		<div class="TPErr_less">
			<spring:message code="trade.TP_full" />
			<spring:message code='trade.TPSLErr_less' />
		</div>
		<div class="SLErr_more">
			<spring:message code="trade.SL_full" />
			<spring:message code='trade.TPSLErr_more' />
		</div>
		<div class="SLErr_less">
			<spring:message code="trade.SL_full" />
			<spring:message code='trade.TPSLErr_less' />
		</div>
		<div class="registComplete">
			<spring:message code='trade.registComplete' />
		</div>
	</div> <script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=62b1125ac4d4d60ab9c62f81" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script>
		const serverport = '<%=request.getServerPort()%>';
		var servername = '<%=request.getServerName()%>';
		var coinType = '${coin}' + "USDT"; // 코인 종류	
		var userIdx = '${userIdx}';
		var walletUSDT = '${walletUSDT}'; // "${wallet}"; user - 선물지갑잔고
		//경고문구
		const inputQtytext = '<spring:message code="pop.trade.inputQty"/>';
		const inputPricetext = '<spring:message code="pop.trade.inputPrice"/>';
		const logintext = '<spring:message code="pop.show.login"/>';

		//초기 포지션 정보
		let positionObj = "";
		if (userIdx != "")
			positionObj = JSON.parse('${pobj}');

		//유저정보	

		const parentsIdx = '${parentsIdx}';
		let wallet = '${wallet}'; // "${wallet}"; user - 선물지갑잔고
		const coinbet = '${betMode}'; // inverse

		//주문 텍스트
		const stoptext = '<spring:message code="trade.stop2"></spring:message>';
		const limittext = '<spring:message code="trade.limit"></spring:message>';
		const markettext = '<spring:message code="trade.market"></spring:message>';
		const autopricetext = '<spring:message code="trade.autoPrice"></spring:message>';
		const crosstext = '<spring:message code="trade.cross"></spring:message>';
		const isotext = '<spring:message code="newwave.trade.iso"></spring:message>';
		const gtctext = '<spring:message code="trade.gtc"></spring:message>';
		const foktext = '<spring:message code="trade.fok"></spring:message>';
		const ioctext = '<spring:message code="trade.ioc"></spring:message>';
		const canceltext = '<spring:message code="trade.cancel"></spring:message>';
		const longtext = '<spring:message code="trade.longtext"></spring:message>';
		const shorttext = '<spring:message code="trade.shorttext"></spring:message>';
		const settlenoti_1 = ' <spring:message code="trade.settlenoti_1"></spring:message> ';
		const settlenoti_2 = ' <spring:message code="trade.settlenoti_2"></spring:message> ';
		const settlenoti_3 = '<spring:message code="trade.settlenoti_3"></spring:message> ';
		const settlenoti_4 = '<spring:message code="trade.settlenoti_4"></spring:message> ';
		const marketsattletext = '<spring:message code="trade.market_1"></spring:message> ';
		const profittext = '<spring:message code="trade.profit"></spring:message> ';
		const losstext = '<spring:message code="trade.loss"></spring:message> ';
		const wrongtext = '<spring:message code="pop.show.wrongApproach"></spring:message> ';
		const copyLevFailtext = '<spring:message code="trade.copyLevFail"></spring:message> ';
		const orderPricetext = '<spring:message code="trade.order"/> <spring:message code="trade.price"/>';
		const tptext = '<spring:message code="trade.tp"/>';
		const fttext = '<spring:message code="trade.filledtotal"/>';
		const tTypetext = '<spring:message code="trade.trade"/><spring:message code="trade.type"/>';
		const oTypetext = '<spring:message code="trade.ordertype"/>';
		const oNumtext = '<spring:message code="trade.ordernum"/>';
		const oTimetext = '<spring:message code="trade.order"/> <spring:message code="trade.time"/>';
		const actiontext = '<spring:message code="trade.action"/>';
		const postautotext = '<spring:message code="pop.trade.postAuto"/>';
		const maxSizetext = '<spring:message code="pop.trade.maxSize"/>';
		const nonPointtext = '<spring:message code="pop.trade.nonPoint"/>';
		const levChangeFailtext = '<spring:message code="pop.trade.levChangeFail"/>';
		const levChangeSuctext = '<spring:message code="pop.trade.levChangeSuc"/>';
		const nothingOrdertext = '<spring:message code="pop.show.nothingOrder"/>';
		const allCanceltext = '<spring:message code="pop.show.allCancel"/>';
		const orderCanceltext = '<spring:message code="pop.show.orderCancel"/>';
		const isochangeXtext = '<spring:message code="pop.show.isochangeX"/>';
		const marginchangeXtext = '<spring:message code="pop.show.marginchangeX"/>';
		const commingSoontext = '<spring:message code="pop.show.commingSoon"/>';
		const nonBalanceCancel = "<spring:message code='pop.show.nonBalanceCancel'/>";
		const cointext_BTC = "<spring:message code='trade.coin.btc'/>";
		const cointext_ETH = "<spring:message code='trade.coin.eth'/>";
		const cointext_XRP = "<spring:message code='trade.coin.xrp'/>";
		const cointext_TRX = "<spring:message code='trade.coin.trx'/>";
		const triggerText = "<spring:message code='trade.triggerPrice'/>";
		const priceText = "<spring:message code='trade.price'/>";
		const liqText = "<spring:message code='pop.show.liqPos'/>";
		const closeText = "<spring:message code='trade.closeby'/>";
		const ls_lText = "<spring:message code='trade.ls_l'/>";
		const ls_sText = "<spring:message code='trade.ls_s'/>";
		const levText = "<spring:message code='trade.leverage'/>";
		const entryPriceText = "<spring:message code='trade.entryPrice'/>";
		const cointext = "<spring:message code='trade.coin'/>";
		const lPricetext = "<spring:message code='trade.liquidPrice'/>";
		const yieldtext = "<spring:message code='trade.yield'/>";
		const TPErrText_more = "<spring:message code='trade.TP_full'/><spring:message code='trade.TPSLErr_more'/>";
		const TPErrText_less = "<spring:message code='trade.TP_full'/><spring:message code='trade.TPSLErr_less'/>";
		const SLErrText_more = "<spring:message code='trade.SL_full'/><spring:message code='trade.TPSLErr_more'/>";
		const SLErrText_less = "<spring:message code='trade.SL_full'/><spring:message code='trade.TPSLErr_less'/>";
		const TPtext_1 = "<spring:message code='trade.TPText_1'/>";
		const TPtext_2 = "<spring:message code='trade.TPText_2'/>";
		const TPtext_2_s = "<spring:message code='trade.TPText_2_s'/>";
		const TPtext_3 = "<spring:message code='trade.TPText_3'/>";
		const SLtext_1 = "<spring:message code='trade.SLText_1'/>";
		const SLtext_2 = "<spring:message code='trade.SLText_2'/>";
		const SLtext_2_s = "<spring:message code='trade.SLText_2_s'/>";
		const SLtext_3 = "<spring:message code='trade.SLText_3'/>";
		const leverchangeConfirmText = "<spring:message code='trade.leverchangeConfirm'/>";
		const avaqtyText = "<spring:message code='trade.avaqty'/>";
	</script>
	<script src="jsSpot/tradeSetting.js?v=8" type="text/javascript"></script>
	<script src="jsSpot/tradeServerSetting.js?v=8" type="text/javascript"></script>
	<script src="jsSpot/htmlAppend.js?v=8" type="text/javascript"></script>
	<script src="jsSpot/spotTrade.js?v=3" type="text/javascript"></script>
</body>
</html>