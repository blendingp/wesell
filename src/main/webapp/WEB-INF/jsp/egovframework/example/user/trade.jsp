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
<jsp:include page="../userFrame/header.jsp"></jsp:include>
</head>
<style>
input[type="number"]::-webkit-outer-spin-button, input[type="number"]::-webkit-inner-spin-button
	{
	-webkit-appearance: none;
	margin: 0;
}

.hogablock{
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
.tradebtn1-1{
	font-size:12px;
}
.graphred{
	width:0%;
}
</style>

<body class="body-2">
	<div class="frame">
		<jsp:include page="../userFrame/top.jsp"></jsp:include>
		<div class="trade_frame">
			<div class="trade_topblock">
				<div class="tradetop_coin" onclick="coinMenu()" style="cursor:pointer; z-index:5;">
					<img src="/global/webflow/images/BTCicon_img_1.png" loading="lazy" alt="" class="image coinImg coinBTC">
					<img src="/global/webflow/images/XRPicon45.png" loading="lazy" alt="" class="image coinImg coinXRP" style="display:none;">
					<img src="/global/webflow/images/ETHicon45.png" loading="lazy" alt="" class="image coinImg coinETH" style="display:none;">
					<img src="/global/webflow/images/TRXicon45.png" loading="lazy" alt="" class="image coinImg coinTRX" style="display:none;">
					<div class="coinsub"><span class="qtycoinm">${coin}</span>USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
					<img src="/global/webflow/images/arrow_up_white.svg" loading="lazy" alt="" class="image-41">
					<div class="trade_coinsub" id="coinMenu" style="display:none; padding-top:0; top:100%;">
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
										<c:when test="${item eq 'BTC'}"><img src="/global/webflow/images/BTCicon_img_2BTCicon_img.png" loading="lazy" alt="" class="image-42"></c:when>
										<c:when test="${item eq 'ETH'}"><img src="/global/webflow/images/ETHicon45.png" loading="lazy" alt="" class="image-42"></c:when>
										<c:when test="${item eq 'TRX'}"><img src="/global/webflow/images/TRXicon45.png" loading="lazy" alt="" class="image-42"></c:when>
										<c:when test="${item eq 'XRP'}"><img src="/global/webflow/images/XRPicon45.png" loading="lazy" alt="" class="image-42"></c:when>
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
					<img src="/global/webflow/images/arrow_up_white.svg" loading="lazy" alt=""
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
								<div class="_24hinfolist">
									<div class="_24hsub"><spring:message code="trade.funding"/> / <spring:message code="trade.countdown"/></div>
									<div class="_24hblock1">
										<div class="funding_ratetxt up idfRate">0.0000%</div>
										<div class="slash">/</div>
										<div class="_24hinfo_txt idtimer">00:00:00</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="_24h_box">
					<div class="div-block-115">
						<div class="top_runtimequote down coinpri-n mainsise"></div>
						<div class="topblock_quotebox up"><span class="coinpersent"></span>%</div>
					</div>
					<div class="_24hinfo">
						<div class="_24hinfolist">
							<div class="_24hsub"><spring:message code="trade.24change"/></div>
							<div class="_24hinfo_txt low coininfo persent"></div>
						</div>
						<div id="w-node-_38b0f3ae-fc30-412c-401a-8ad61844a47b-c00b95be" class="_24hinfolist">
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
						<div class="_24hinfolist">
							<div class="_24hsub"><spring:message code="trade.funding"/> / <spring:message code="trade.countdown"/></div>
							<div class="_24hblock1">
								<div class="funding_ratetxt up idfRate">0.0000%</div>
								<div class="slash">/</div>
								<div class="_24hinfo_txt idtimer">00:00:00</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="mob_tradingbtn">
				<a href="javascript:mobileBlockChange('chart')" id="movchart" class="button-12 select chart w-button"><spring:message code="trade.chart"/></a> 
				<a href="javascript:mobileBlockChange('order')" id="movorder" class="button-12 transaction w-button"><spring:message code="main.Margin_1"/></a>
			</div>
			<div class="trade_mainframe">
				<div class="trade_block">
					<div class="trade_block3">
						<div class="chartblock chart all" style="display:flex;">
							<div class="chart" style="width:100%;">
								<div class="chartcontents">
									<div class="chartmain-n" style="height: auto;">
										<div class="graphbox" style="width:100%; height: 100%; position: relative;">
	<!-- 										TradingView Widget BEGIN -->
											<div id="futuresChart" class="futuresChart" style="width: 100%; height: 100%; position: relative;">
											</div>
	<!-- 										TradingView Widget END -->
										</div>
						            </div>
					            </div>
							</div>
						</div>
						<div class="orderbox1" id="transactionsBook">
							<div class="orderbook_block">
								<div class="orderbook_top">
									<div onclick="orderBookTab('orderbook',this)" class="orderbook_btn click w-inline-block">
										<div class="title1"><spring:message code="trade.orderbook2"/></div>
									</div> 
									<div onclick="orderBookTab('tradehistory',this)" class="orderbook_btn w-inline-block">
										<div class="title1"><spring:message code="trade.tradeHistory"/></div>
									</div>
								</div>
								<div class="d_listwrap orderbook orderbook ob">
									<div class="orderlist ordertable">
										<div class="orderobox _2">
											<div class="text">
												Price(USD<c:if test="${betMode eq 'usdt'}">T</c:if>)
											</div>
											<div class="text _2">
												Size (<span class="qtycoinm">BTC</span>)
											</div>
											<div class="text _3">
												Sum (USD<c:if test="${betMode eq 'usdt'}">T</c:if>)
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
								<div class="markettrade tradehistory all ob">
									<div class="tradehistory_top">
										<div class="trademarket_txtbox"><spring:message code="th.price"/> (USD)</div>
										<div class="trademarket_txtbox"><spring:message code="th.size"/> (<span class="qtycoinm">BTC</span>)</div>
										<div class="trademarket_txtbox time"><spring:message code="th.time"/></div>
									</div>
									<div id="tradehistory"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="order_block" id="tabbox_pos">
						<div class="order_topbtnlist">
							<a href="javascript:positionTabChange('position')" class="order_topbtn click w-button tabbtn position"><spring:message code="trade.conclusion"/></a>
							<a href="javascript:positionTabChange('olist')" class="order_topbtn w-button tabbtn olist"><spring:message code="trade.outstanding"/></a> 
							<a href="javascript:positionTabChange('stopMarket')" class="order_topbtn w-button tabbtn stopMarket"><spring:message code="trade.stop2"/></a>
							<a href="/global/user/tradeHistory.do" class="p_historybtn w-inline-block"><img src="/global/webflow/images/8666682_external_link_icon_18666682_external_link_icon.png" loading="lazy" alt="" class="p_history_img"></a>
						</div>
						<div class="position_box order olist" style="display:none;">
							<div class="order_top1">
								<div class="order_toplisttxt1"><spring:message code="trade.symbol"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.position"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.filledtotal"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.margin"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.tp"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.time"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.cancel"/></div>
							</div>
							<div class="position_warp1">
								<div class="position_listblock1" style="display:block;">
									<c:forEach begin="0" end="3" varStatus="status">
										<div class="positionblock1 positionOrderList" id="orderLongList${status.index}" style="display:none; width:100%;"></div>
									</c:forEach>
								</div>
							</div>
						</div>
						<div class="position_box order stopMarket" style="display:none;"> 
							<div class="order_top1">
								<div class="order_toplisttxt1"><spring:message code="trade.symbol"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.position"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.filledtotal"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.margin"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.tp"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.time"/></div>
								<div class="order_toplisttxt1"><spring:message code="trade.cancel"/></div>
							</div>
							<div class="position_warp1">
								<div class="position_listblock1">
									<c:forEach begin="0" end="3" varStatus="status">
										<div class="positionblock1 positionOrderList" id="orderStopList${status.index}" style="display:none; width:100%;"></div>
									</c:forEach>
								</div>
							</div>
						</div>
						
						<div class="d_listframe position" style="display:flex;">
							<c:if test="${userIdx eq null}">
								<div class="list_frame position">
									<div class="position_notlogin" style="display: flex;">
										<c:if test="${lang eq 'KO'}">
											<span class="position_login" style="cursor:pointer;" onclick="location.href='/global/login.do'"><spring:message code="trade.loginOrSign_login"/></span> <spring:message code="trade.loginOrSign_or"/> <span class="position_login" style="cursor:pointer;" onclick="location.href='/global/join.do'"><spring:message code="trade.loginOrSign_sign"/></span><spring:message code="trade.loginOrSign_start"/>
										</c:if>
										<c:if test="${lang ne 'KO'}">
											<spring:message code="trade.loginOrSign_start"/> <span class="position_login" style="cursor:pointer;" onclick="location.href='/global/login.do'"><spring:message code="trade.loginOrSign_login"/></span> <spring:message code="trade.loginOrSign_or"/> <span class="position_login" style="cursor:pointer;" onclick="location.href='/global/join.do'"><spring:message code="trade.loginOrSign_sign"/></span>
										</c:if>
									</div>
								</div>
							</c:if>
							<c:if test="${userIdx ne null}">
								<div class="list_frame position" id="position_block">
									<c:forEach begin="0" end="3" varStatus="status">
										<div class="d_box positionsBottom${status.index} positionOrderList" style="display:none;">
											<div class="d_box_position">
												<div class="polongshort" style="width:auto; padding:5px;"></div>
												<div class="dtxt3">
													<span class="position_pocolor"><span class="po_lev"></span>X · </span><span class="po_sym"></span>
												</div>
												<div class="category po_sta" style="display:flex;"></div>
											</div>
											<div class="div-block-142">
												<div class="deal_infobox">
													<div class="mydeal_box">
														<div class="dtxt"><spring:message code="trade.entryPrice"/></div>
														<div class="dtxt4"><span class="position_entryprice"></span> USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
													</div>
													<div class="mydeal_box">
														<div class="dtxt"><spring:message code="trade.amount"/></div>
														<div class="dtxt4 position_quantity"></div>
													</div>
													<div class="mydeal_box _4">
														<div class="dtxt"><spring:message code="trade.profit_1"/></div>
														<div class="dtxt4 ">
														<span class="position_revenue"></span> 
													</div>
													</div>
<!-- 													<div class="mydeal_box"> -->
<%-- 														<div class="dtxt _2"><spring:message code="trade.entryPrice"/>(KRW)</div> --%>
<!-- 														<div class="dtxt4 position_entryprice_KRW"></div> -->
<!-- 													</div> -->
													<div class="mydeal_box">
														<div class="dtxt"><spring:message code="trade.margin"/></div>
														<div class="dtxt4"><span class="positionbox_margin"></span> USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
													</div>
<!-- 													<div class="mydeal_box _4"> -->
<%-- 														<div class="dtxt _2"><spring:message code="trade.profit_1"/>(KRW)</div> --%>
<!-- 														<div class="dtxt4 position_revenue_KRW"></div> -->
<!-- 													</div> -->
													<div class="mydeal_box">
														<div class="dtxt _2"><spring:message code="trade.liqPrice"/></div>
														<div class="dtxt4"><span class="position_liquidation"></span> USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
													</div>
<!-- 													<div class="mydeal_box _4"> -->
<!-- 														<div class="dtxt"></div> -->
<!-- 													</div> -->
<!-- 													<div class="mydeal_box _4"> -->
<%-- 														<div class="dtxt _2"><spring:message code="trade.margin"/>(KRW)</div> --%>
<!-- 														<div class="dtxt4 positionbox_margin_KRW"></div> -->
<!-- 													</div> -->
													<div class="mydeal_box _4">
														<div class="dtxt"><spring:message code="trade.yield"/></div>
														<div class="dtxt4 position_revenue_rate green"></div>
													</div>
												</div>
												<div class="deal_infobox _2">
													<div class="p_tpslblock" id="tpslBox${status.index}">
														<a href="javascript:popTPSL(${status.index})" id="tpslAdd${status.index}" class="button-63 w-button"><spring:message code="trade.SL"/>/<spring:message code="trade.TP"/></a>
														<div class="dtxt"><spring:message code="trade.SL"/>/<spring:message code="trade.TP"/></div>
														<div class="tpsl_txt">
															<span class="tpsl_txt sl"></span>&ensp;/&ensp;
															<span class="tpsl_txt tp"></span>
														</div>
													</div>
<%-- 													<div class="dtxt"><spring:message code="trade.liqPrice"/></div> --%>
<%-- 													<div class="dtxt2"><span class="position_liquidation"></span> USD<c:if test="${betMode eq 'usdt'}">T</c:if></div> --%>
<!-- 													<div class="dtxt2"><span class="position_liquidation_KRW"></span> KRW</div> -->
													<div class="orderbtnwrap">
														<a href="javascript:popLM(${status.index}, 'limit')" class="dealbtn w-button"><span class="d_btntxt"><spring:message code="trade.limit"/></span></a> 
														<a href="javascript:popLM(${status.index}, 'market')" class="dealbtn w-button"><span class="d_btntxt"><spring:message code="trade.market"/></span></a> 
														<a href="javascript:popQuickLiq(${status.index})" class="dealbtn _2 w-button"><span class="d_btntxt"><spring:message code="trade.quickLiq"/></span></a>
													</div>
												</div>
											</div>
										</div>
									</c:forEach>
								</div>
							</c:if>
						</div>
					</div>
				</div>
				<div class="tradeblock1">
					<div class="tradeblock2 transaction">
						<div id="w-node-_561d8bcc-97d1-00ff-b4d3-979ba0e7a7be-603c6803"
							class="orderbox2">
							<div class="transaction_block open">
								<div class="transactionwarp limit">
									<div class="tabbg">
										<div class="selectbox-2 _4" onclick="popDisplay('modepop','flex')">
											<div class="s_txt-2">
												<span id="marginType"></span><span class="text-span-6">▼</span>
											</div>
										</div>
										<div class="selectbox-2 _4" onclick="showLeveragePopup()">
											<div class="s_txt-2">
												<spring:message code="trade.leverage"/><span id="leverage"></span>X<span class="text-span-6">▼</span>
											</div>
										</div>
									</div>
									<div class="tradesub_btnlist">
										<a href="javascript:setOrderType('limit')" class="tradesub_btn _1 w-button orderbtn limit_btn"><spring:message code="trade.limit"/></a> 
										<a href="javascript:setOrderType('market')" class="tradesub_btn click w-button orderbtn market_btn"><spring:message code="trade.market"/></a> 
										<a href="javascript:setOrderType('stopMarket')" class="tradesub_btn _2 w-button orderbtn stopMarket_btn"><spring:message code="trade.stop2"/></a>
									</div>
									<div class="form-block w-form">
										<div class="trade_inputbox">
											<div class="s_txt"><spring:message code="trade.price"/></div>
											<input type="number" class="text-field w-input ot market" id="dealSise" min="0" maxlength="15" style="background-color:transparent;" readonly>
											<div class="s_txt">USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
										</div>
										<div class="trade_inputbox">
											<div class="s_txt"><spring:message code="trade.amount"/></div>
											<input type="number" class="text-field w-input" onInput="qtyKeyInput(this)" value="0.0000" id="quantity" min="0" maxlength="15">
											<div class="s_txt qtycoinm">${coin}</div>
										</div>
									</div>
									
									<div class="trade_p_btnblock">
					                   <a href="javascript:assetPercent(0.1)" class="tpsl_btn left w-button">10 %</a>
					                   <a href="javascript:assetPercent(0.25)" class="tpsl_btn w-button">25 %</a>
					                   <a href="javascript:assetPercent(0.5)" class="tpsl_btn w-button">50 %</a>
					                   <a href="javascript:assetPercent(0.75)" class="tpsl_btn w-button">75%</a>
					                   <a href="javascript:assetPercent(0.99)" class="tpsl_btn right w-button">100 %</a>
					                </div>
									
									<!-- <div class="quantitybar_block">
										<div class="quantitybar rangeQty">
											<div class="quantitybar_circle _100" style="left:98%;"></div>
											<div class="quantitybar_circle _75" style="left:73%;"></div>
											<div class="quantitybar_circle _50" style="left:49%;"></div>
											<div class="quantitybar_circle _25"></div>
											<div class="quantitybar_circle _0"></div>
											<input type="range" id="rangeQtyValue" onchange="assetPercent(this.value*0.01)" value="0" min="0" max="100" style="appearance: none; background:#e6e6e6; width:100%;" class="quantitybar_percentbar">
											<div style="position:absolute; display:none;" id="howQtyPersent">
												<div class="quantitybar_box" id="howQtyPersentBlock" style="left:-15px; bottom:20px;">0%</div>
											</div>
										</div>
									</div> -->
									<div class="checkbox-2 buyTpsl">
										<div class="form-block-27 w-form">
											<label class="w-checkbox checkbox-field-3">
												<input type="checkbox" id="buyTpsl_cb" class="w-checkbox-input checkbox-4">
												<span class="checkbox-label-3 w-form-label" for="checkbox"><spring:message code="trade.SL"/>/<spring:message code="trade.TP"/></span>
											</label>
										</div>
<!-- 										<img src="/global/webflow/images/icon4.svg" loading="lazy" alt="" class="exicon"> -->
									</div>
									<div class="order_tpslarea buyTpsl" id="buyTpsl_div" style="display:none;">
										<div class="form-block w-form">
											<div class="trade_inputbox">
												<div class="s_txt"><spring:message code="trade.SL"/></div>
												<input type="number" class="text-field w-input" onInput="priceKeyInput(this);" placeholder="0" id="buySLPrice">
												<div class="s_txt">USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
											</div>
											<div class="trade_inputbox">
												<div class="s_txt"><spring:message code="trade.TP"/></div>
												<input type="number" class="text-field w-input" onInput="priceKeyInput(this);" placeholder="0" id="buyTPPrice">
												<div class="s_txt">USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
											</div>
										</div>
									</div>
									<div class="assetlist">
										<div class="ordertxt4"><spring:message code="wallet.available_1"/></div>
										<div class="ordertxt3">
											<span class="ableWithdrawWallet">0</span>
											<c:if test="${betMode eq 'usdt'}">
												<span>USDT</span>
											</c:if>
											<c:if test="${betMode ne 'usdt'}">
												<span class="qtycoinm">${coin}</span>
											</c:if>
										</div>
									</div>
									<div class="assetlist">
										<div class="ordertxt4"><spring:message code="trade.margin"/></div>
											<div class="ordertxt3">
												<span class="idlongFee">0</span>
												<c:if test="${betMode eq 'usdt'}">
													<span>USDT</span>
												</c:if>
												<c:if test="${betMode ne 'usdt'}">
													<span class="qtycoinm">${coin}</span>
												</c:if>
											</div>
									</div>
									<div class="tradebtn_block">
										<a href="javascript:popType('long')" class="tradebtn1 w-button"><spring:message code="trade.longtext"/><span class="trade_btntxt qtycoinm">${coin}</span></a> 
										<a href="javascript:popType('short')" class="tradebtn2 w-button"><spring:message code="trade.shorttext"/><span class="trade_btntxt qtycoinm">${coin}</span></a>
									</div>
								</div>
								<div class="usdt-asset">
									<div class="order_title">
										USD<c:if test="${betMode eq 'usdt'}">T</c:if> <spring:message code="trade.asset"/><a href="/global/user/wallet.do" class="deposit"><spring:message code="wallet.deposit"/></a>
									</div>
									<div class="tradelistbox2">
										<div class="assetlist">
											<div class="ordertxt4"><spring:message code="wallet.assetsHeld"/></div>
											<div class="ordertxt3">
												<span class="wallet1" id="wallet1">0</span>
												<c:if test="${betMode eq 'usdt'}">
													<span>USDT</span>
												</c:if>
												<c:if test="${betMode ne 'usdt'}">
													<span class="qtycoinm">${coin}</span>
												</c:if>
											</div>
										</div>
										<div class="assetlist">
											<div class="ordertxt4"><spring:message code="wallet.available"/></div>
											<div class="ordertxt3">
												<span class="ableWithdrawWallet" id="ableWithdrawWallet">0</span>
												<c:if test="${betMode eq 'usdt'}">
													<span>USDT</span>
												</c:if>
												<c:if test="${betMode ne 'usdt'}">
													<span class="qtycoinm">${coin}</span>
												</c:if>
											</div>
										</div>
										<div class="assetlist">
											<div class="ordertxt4"><spring:message code="trade.margin"/></div>
											<div class="ordertxt3">
												<span class="margin" id="margin">0</span>
												<c:if test="${betMode eq 'usdt'}">
													<span>USDT</span>
												</c:if>
												<c:if test="${betMode ne 'usdt'}">
													<span class="qtycoinm">${coin}</span>
												</c:if>
											</div>
										</div>
										<div class="assetlist">
											<div class="ordertxt4"><spring:message code="trade.unRealizedPL"/></div>
											<div class="ordertxt3">
												<span class="totalUnrealized">0</span>
												<c:if test="${betMode eq 'usdt'}">
													<span>USDT</span>
												</c:if>
												<c:if test="${betMode ne 'usdt'}">
													<span class="qtycoinm">${coin}</span>
												</c:if>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="assetblock">
						<div class="order_title"><spring:message code="trade.order_title"/></div>
						<div class="assetlistbox">
							<div class="assetlist">
								<div class="ordertxt4"><spring:message code="trade.ordertxt_2"/></div>
								<div class="ordertxt3 "><span class="maxLeverage"></span>X</div>
							</div>
							<div class="assetlist">
								<div class="ordertxt4"><spring:message code="trade.ordertxt_3"/></div>
								<div class="ordertxt3"><span class="minQty">0.0001</span><span class="qtycoinm">&ensp;BTC</span></div>
							</div>
							<div class="assetlist">
								<div class="ordertxt4"><spring:message code="trade.ordertxt_4"/></div>
								<div class="ordertxt3"><span class="maxVolume">0.0001</span><span class="qtycoinm">&ensp;BTC</span>)</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="chart_bottom">
			<div class="bottom_btn w-inline-block">
				<spring:message code="trade.order_title"/>
				<img src="/global/webflow/images/arrow_up_white.svg" loading="lazy" alt="" class="bottom_btnimg on">
			</div>
			<div class="bottom_box" style="display: none;">
				<div class="usdt-asset b">
					<div class="order_title">
						USD<c:if test="${betMode eq 'usdt'}">T</c:if> <spring:message code="trade.asset"/><a href="/global/user/wallet.do" class="deposit"><spring:message code="wallet.deposit"/></a>
					</div>
					<div class="tradelistbox2">
						<div class="assetlist">
							<div class="ordertxt4"><spring:message code="wallet.assetsHeld"/></div>
							<div class="ordertxt3">
								<span class="wallet1" id="wallet1">0</span>
								<c:if test="${betMode eq 'usdt'}">
									<span>USDT</span>
								</c:if>
								<c:if test="${betMode ne 'usdt'}">
									<span class="qtycoinm">${coin}</span>
								</c:if>
							</div>
						</div>
						<div class="assetlist">
							<div class="ordertxt4"><spring:message code="wallet.available"/></div>
							<div class="ordertxt3">
								<span class="ableWithdrawWallet" id="ableWithdrawWallet">0</span>
								<c:if test="${betMode eq 'usdt'}">
									<span>USDT</span>
								</c:if>
								<c:if test="${betMode ne 'usdt'}">
									<span class="qtycoinm">${coin}</span>
								</c:if>
							</div>
						</div>
						<div class="assetlist">
							<div class="ordertxt4"><spring:message code="trade.margin"/></div>
							<div class="ordertxt3">
								<span class="margin" id="margin">0</span>
								<c:if test="${betMode eq 'usdt'}">
									<span>USDT</span>
								</c:if>
								<c:if test="${betMode ne 'usdt'}">
									<span class="qtycoinm">${coin}</span>
								</c:if>
							</div>
						</div>
						<div class="assetlist">
							<div class="ordertxt4"><spring:message code="trade.unRealizedPL"/></div>
							<div class="ordertxt3">
								<span class="totalUnrealized">0</span>
								<c:if test="${betMode eq 'usdt'}">
									<span>USDT</span>
								</c:if>
								<c:if test="${betMode ne 'usdt'}">
									<span class="qtycoinm">${coin}</span>
								</c:if>
							</div>
						</div>
					</div>
				</div>
				<div class="assetblock b">
					<div class="order_title">Futures Information</div>
					<div class="assetlistbox">
						<div class="assetlist">
							<div class="ordertxt4"><spring:message code="trade.ordertxt_2"/></div>
							<div class="ordertxt3 "><span class="maxLeverage"></span>X</div>
						</div>
						<div class="assetlist">
							<div class="ordertxt4"><spring:message code="trade.ordertxt_3"/></div>
							<div class="ordertxt3"><span class="minQty">0.0001</span><span class="qtycoinm">&ensp;BTC</span></div>
						</div>
						<div class="assetlist">
							<div class="ordertxt4"><spring:message code="trade.ordertxt_4"/></div>
							<div class="ordertxt3"><span class="maxVolume">0.0001</span><span class="qtycoinm">&ensp;BTC</span>)</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="utillitypop" style="position:fixed; z-index:100000; display: none; pointer-events:none; justify-content:flex-start; flex-direction:column; margin-top:5%;"></div>
		<div id="settlePop" style="z-index:15;"></div>
		<div class="popup" style="display:none;">
			<div class="tradepop" style="display: none;">
				<div class="tradingpop quick pop_trade_end" style="display: none;">
					<div class="poptitle">
						<div class="title6"><span class="coinSymbol"></span> - <spring:message code="trade.quickLiq"/></div>
					</div>
					<div class="quikpoptxt"><spring:message code="trade.quickLiq_confirm"/></div>
					<div class="pop_btn">
						<a href="javascript:popDisplay('pop_trade_end','none')" class="button-15-copy w-button"><spring:message code="trade.cancel"/></a>
						<a href="javascript:sattleQuick()" class="button-15 w-button"><spring:message code="trade.apply_2"/></a> 
					</div>
				</div>
				<div class="tradingpop pop_trade" style="display: none;">
					<div class="poptitle">
						<div class="title6 tpop_symbol"></div>
					</div>
					<div class="text-block-8 tpop_orderType"></div>
					<div class="text-block-9">
						<spring:message code="trade.position"/> : <span class="tpop_position short"></span>
					</div>
					<div class="tradepop_warp">
						<div class="text-block-10"><spring:message code="trade.entryPrice"/></div>
						<div><span class="tpop_price"></span></div>
					</div>
					<div class="tradepop_warp">
						<div class="text-block-10"><spring:message code="trade.qty"/></div>
						<div><span class="tpop_qty"></span>&ensp;<span class="tpop_coin"></span></div>
					</div>
					<div class="tradepop_warp">
						<div class="text-block-10"><spring:message code="trade.leverage"/></div>
						<div class="tpop_leverage"></div>
					</div>
					<div class="tradepop_warp">
						<div class="text-block-10"><spring:message code="trade.marginMode"/></div>
						<div class="tpop_marginType"></div>
					</div>
					<div class="tradepop_warp">
						<div class="text-block-10"><spring:message code="trade.margin"/></div>
						<div><span class="tpop_margin"></span>&ensp;<span class="tpop_coin_i"></span></div>
					</div>
					<div class="tradepop_warp tpop_tpsl_warp">
						<div class="text-block-10"><spring:message code="trade.SL_full"/></div>
						<div><span class="tpop_sl"></span>&ensp;USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
					</div>
					<div class="tradepop_warp tpop_tpsl_warp">
						<div class="text-block-10"><spring:message code="trade.TP_full"/></div>
						<div><span class="tpop_tp"></span>&ensp;USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
					</div>
					<div class="pop_btn">
						<a href="javascript:popDisplay('tradingpop','none')" class="button-15-copy w-button"><spring:message code="trade.cancel"/></a> 
						<a href="javascript:buy()" class="button-15 w-button"><spring:message code="wallet.confirm"/></a>
					</div>
				</div>
				<div class="clearing_pop" id="popLM" style="display: none;">
					<div class="tradingpop_block">
						<div class="tradepop_block" style="margin-right:10px;">
							<div class="poptitle">
								<div class="title6 cpoptitle"></div>
							</div>
							<div class="text-block-8 cpopType"></div>
							<div class="ordertxt4">
								<div class="text-block-12" id="sattlenoti"></div>
							</div>
						</div>
						<div class="form-block-7 w-form">
							<div id="sattlePriceBox">
								<div class="title3"><spring:message code="trade.price"/></div>
								<input type="number" class="text-field-13-copy w-input"
									maxlength="20" id="sattlePrice">
							</div>
								
							<div class="title3"><spring:message code="trade.qty"/></div>
							<input type="number" class="text-field-13-copy w-input"
								maxlength="20" id="sattleQty">
							<div class="quantitybar_block">
								<div class="quantitybar">
									<input type="range" id="sattleQtyRange" oninput="sattleQtyRangeInput()" value="0" min="0" max="100" style="width:100%; appearance:none; color:ffffff;" class="quantitybar_percentbar">
								</div>
							</div>
							<div class="order_txt1">
								<div class="ordertxt" onclick="sattleQtyRangeSet(10)" style="cursor: pointer;">10%</div>
								<div class="ordertxt" onclick="sattleQtyRangeSet(25)" style="cursor: pointer;">25%</div>
								<div class="ordertxt" onclick="sattleQtyRangeSet(50)" style="cursor: pointer;">50%</div>
								<div class="ordertxt" onclick="sattleQtyRangeSet(75)" style="cursor: pointer;">75%</div>
								<div class="ordertxt" onclick="sattleQtyRangeSet(100)" style="cursor: pointer;">100%</div>
							</div>
						</div>
					</div>
					<div class="pop_btn">
						<a href="javascript:popDisplay('clearing_pop', 'none')" class="button-15-copy w-button"><spring:message code="trade.cancel"/></a>
						<a href="javascript:sattlebuy()" class="button-15 w-button"><spring:message code="trade.close"/></a>
					</div>
				</div>
				<div class="tpsl_pop" id="popTPSL" style="display:none;">
					<div class="div-block-127">
						<div class="poptitle"><spring:message code="trade.SL"/>/<spring:message code="trade.TP"/></div>
						<div class="pop_scroll" style="height:auto;">
							<div class="div-block-128">
								<div class="tpsl_poptxt">
									<spring:message code="trade.entryPrice"/> <span class="tpsl_price" id="tpsl_entry"></span>
								</div>
								<div class="tpsl_poptxt">
									<spring:message code="trade.liquidPrice"/> <span class="tpsl_price2" id="tpsl_liq"></span>
								</div>
								<div class="form-block-21 w-form">
									<div class="tpsl_poptitle"><spring:message code="trade.SL_full"/></div>
									<div class="tpslpop_inputarea">
										<div class="trade_inputbox2">
											<div class="s_txt"><spring:message code="trade.price"/></div>
											<input type="text" class="tpsl_popinput w-input sl" id="tpsl_slInput" autocomplete="off">
											<div class="s_txt">USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
										</div>
										<a href="javascript:resetTPSLInput('sl')" class="button-64 w-button"><spring:message code="trade.cancel"/></a>
									</div>
									<div class="tpsl_btnblock">
										<a href="javascript:setTPSLPersent('sl',5)"  class="tpsl_btn tpsl_btn5 sl left w-button">5 %</a> 
										<a href="javascript:setTPSLPersent('sl',10)" class="tpsl_btn tpsl_btn10 sl w-button">10 %</a> 
										<a href="javascript:setTPSLPersent('sl',25)" class="tpsl_btn tpsl_btn25 sl w-button">25 %</a> 
										<a href="javascript:setTPSLPersent('sl',50)" class="tpsl_btn tpsl_btn50 sl w-button">50 %</a> 
										<a href="javascript:setTPSLPersent('sl',75)" class="tpsl_btn tpsl_btn75 sl right w-button">75 %</a>
									</div>
								</div>
								<div class="pop_warn" id="tpsl_slText" style="display: none;"></div>
							</div>
							<div class="div-block-131">
								<div class="form-block-21 w-form">
									<div class="tpsl_poptitle"><spring:message code="trade.TP_full"/></div>
									<div class="tpslpop_inputarea">
										<div class="trade_inputbox2">
											<div class="s_txt"><spring:message code="trade.price"/></div>
											<input type="text" class="tpsl_popinput w-input tp" id="tpsl_tpInput" autocomplete="off">
											<div class="s_txt">USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
										</div>
										<a href="javascript:resetTPSLInput('tp')" class="button-64 w-button"><spring:message code="trade.cancel"/></a>
									</div>
									<div class="tpsl_btnblock">
										<a href="javascript:setTPSLPersent('tp',10)"  class="tpsl_btn tpsl_btn10 tp left w-button">10 %</a> 
										<a href="javascript:setTPSLPersent('tp',25)" class="tpsl_btn tpsl_btn25 tp w-button">25 %</a> 
										<a href="javascript:setTPSLPersent('tp',50)" class="tpsl_btn tpsl_btn50 tp w-button">50 %</a> 
										<a href="javascript:setTPSLPersent('tp',100)" class="tpsl_btn tpsl_btn100 tp w-button">100 %</a> 
										<a href="javascript:setTPSLPersent('tp',150)" class="tpsl_btn tpsl_btn150 tp right w-button">150 %</a>
									</div> 
								</div>
								<div class="pop_warn" id="tpsl_tpText" style="display: none;"></div>
							</div>
						</div>
						<div class="pop_btn">
							<a href="javascript:popDisplay('tpsl_pop','none')" class="button-15-copy w-button"><spring:message code="trade.cancel"/></a>
							<a href="javascript:setTPSL()" class="button-15 w-button"><spring:message code="trade.apply_2"/></a> 
						</div>
					</div>
				</div>
				<div class="modepop">
					<div class="modepop_box">
						<div class="pop_exist" onclick="popDisplay('modepop','none')" style="cursor: pointer;"><img src="/global/webflow/images/wx_black.png" loading="lazy" sizes="100vw" srcset="/global/webflow/images/wx_black-p-800.png 800w, /global/webflow/images/wx_black-p-1080.png 1080w, /global/webflow/images/wx_black.png 1600w" alt="" class="image-38"></div>
						<div class="poptitle">
							<div class="title6"><span class="qtycoinm">${coin}</span>USD<c:if test="${betMode eq 'usdt'}">T</c:if></div>
						</div>
						<div class="modepop_btnarea">
							<div onclick="marginPick(this)" class="modepop_btn mtypeiso marginSelect w-button cross" type="iso"><spring:message code="trade.iso"/></div>
							<div onclick="marginPick(this)" class="modepop_btn mtypecross marginSelect w-button" type="cross"><spring:message code="trade.cross"/></div>
						</div>
						<div class="pop_warn"><spring:message code="trade.crossText"/></div>
						<a href="javascript:marginChangeBtn()" class="pop_btn2 w-button"><spring:message code="trade.apply_2"/></a>
					</div>
				</div>
				<div class="mob_leveragepop leveragePopup" style="display:none;">
					<div class="leverage_block mob">
						<div class="poptitle"><spring:message code="trade.leverage"/></div>
						<div class="leverage_warp">
							<div class="quantitybar_block">
								<div class="quantitybar">
									<input type="range" id="rangeValue" oninput="movLeverRangeSet(this.value)" value="1" min="1" max="100" style="width:100%; appearance: none; background:#37d0d7;" class="quantitybar_percentbar">
								</div>
							</div>
							<div class="order_txt1">
								<div class="ordertxt leverageBtn1" onclick="levBtnClick(1)" style="cursor: pointer;">x1</div>
								<div class="ordertxt leverageBtn25" onclick="levBtnClick(25)" style="cursor: pointer;">x25</div>
								<div class="ordertxt leverageBtn50" onclick="levBtnClick(50)" style="cursor: pointer;">x50</div>
								<div class="ordertxt leverageBtn75" onclick="levBtnClick(75)" style="cursor: pointer;">x75</div>
								<div class="ordertxt leverageBtn100" onclick="levBtnClick(100)" style="cursor: pointer;">x100</div>
							</div>
							<div class="form-block-26 w-form">
								<form class="form-15">
									<input type="text" class="text-field-13 w-input" maxlength="3" id="levInput" style="width:100%;text-align:center; padding:0;">
								</form>
							</div>
						</div>
						<div class="pop_btn">
							<a href="javascript:popDisplay('leveragePopup','none')" class="button-15-copy w-button"><spring:message code="trade.cancel"/></a> 
							<a href="javascript:changeLeverage($('#rangeValue').val())" class="button-15 w-button"><spring:message code="trade.apply_2"/></a>
						</div>
					</div>
				</div>
			</div>
		</div>

		<jsp:include page="../userFrame/footer.jsp"></jsp:include>
	</div>
	<div style="display: none">
		<div class="notBalance"><spring:message code='pop.transfer.notBalance' /></div>
		<div class="nonBalanceCancel"><spring:message code='pop.show.nonBalanceCancel' /></div>
		<div class="orderRun"><spring:message code='pop.show.orderRun' /></div>
		<div class="orderQuantitiesRun"><spring:message code='pop.show.orderQuantitiesRun' /></div>
		<div class="orderFailCancel"><spring:message code='pop.show.orderFailCancel' /></div>
		<div class="nonBalanceNotOrderRun"><spring:message code='pop.show.nonBalanceNotOrderRun' /></div>
		<div class="orderRegister"><spring:message code='pop.show.orderRegister' /></div>
		<div class="changeLev"><spring:message code='pop.show.changeLev' />p</div>
		<div class="wrongApproach"><spring:message code='pop.show.wrongApproach' /></div>
		<div class="liqPos"><spring:message code='pop.show.liqPos' /></div>
		<div class="buyPos"><spring:message code='pop.show.buyPos' /></div>
		<div class="maxDividend"><spring:message code='pop.show.maxDividend' /></div>
		<div class="maxSize"><spring:message code='pop.trade.maxSize' /></div>
		<div class="wrongUser">잘못된 접속입니다. 재접속</div>
		<div class="wrongSymbol">잘못된 종목 선택</div>
		<div class="wrongQuantity">수량이 너무 작습니다.</div>
		<div class="wrongQuantity"><spring:message code='pop.wallet.lowQty'/></div>
		<div class="wrongEntryPrice"><spring:message code='pop.wallet.lowPrice'/></div>
		<div class="crossLevFail"><spring:message code='pop.trade.crossLevChangeFail' /></div>
		<div class="copyLevFail"><spring:message code='trade.copyLevFail' /></div>
		<div class="copyBuyFail"><spring:message code='trade.copyBuyFail' /></div>
		<div class="orderCancel"><spring:message code='pop.show.orderCancel' /></div>
		<div class="p2pStop"><spring:message code='trade.p2pStop' /></div>
		<div class="TPErr_more"><spring:message code="trade.TP_full"/><spring:message code='trade.TPSLErr_more' /></div>
		<div class="TPErr_less"><spring:message code="trade.TP_full"/><spring:message code='trade.TPSLErr_less' /></div>
		<div class="SLErr_more"><spring:message code="trade.SL_full"/><spring:message code='trade.TPSLErr_more' /></div>
		<div class="SLErr_less"><spring:message code="trade.SL_full"/><spring:message code='trade.TPSLErr_less' /></div>
		<div class="registComplete"><spring:message code='trade.registComplete' /></div>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=62b1125ac4d4d60ab9c62f81" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script>
	//유저정보	
	let userIdx = '${userIdx}';
	const parentsIdx = '${parentsIdx}';
	let wallet = '${wallet}'; // "${wallet}"; user - 선물지갑잔고
	const coinbet = '${betMode}'; // inverse
	var coinType = '${coin}'+"USDT"; // 코인 종류 
	
	let positionObj = "";
	if(userIdx != "")
		positionObj = JSON.parse('${pobj}');

  	//주문 텍스트
  	const stoptext	= '<spring:message code="trade.stop2"></spring:message>';
  	const limittext	= '<spring:message code="trade.limit"></spring:message>';
  	const markettext	= '<spring:message code="trade.market"></spring:message>';
	const autopricetext	= '<spring:message code="trade.autoPrice"></spring:message>';
	const crosstext 	= '<spring:message code="trade.cross"></spring:message>';
	const isotext 	= '<spring:message code="newwave.trade.iso"></spring:message>';
	const gtctext		= '<spring:message code="trade.gtc"></spring:message>';
	const foktext		= '<spring:message code="trade.fok"></spring:message>';
	const ioctext		= '<spring:message code="trade.ioc"></spring:message>';
	const canceltext	= '<spring:message code="trade.cancel"></spring:message>';
	const longtext	= '<spring:message code="trade.longtext"></spring:message>';
	const shorttext	= '<spring:message code="trade.shorttext"></spring:message>';
	const settlenoti_1	= ' <spring:message code="trade.settlenoti_1"></spring:message> ';
	const settlenoti_2	= ' <spring:message code="trade.settlenoti_2"></spring:message> '; 
	const settlenoti_3	= '<spring:message code="trade.settlenoti_3"></spring:message> ';
	const settlenoti_4	= '<spring:message code="trade.settlenoti_4"></spring:message> ';
	const marketsattletext= '<spring:message code="trade.market_1"></spring:message> ';
	const profittext		= '<spring:message code="trade.profit"></spring:message> ';
	const losstext		= '<spring:message code="trade.loss"></spring:message> ';
	const wrongtext		= '<spring:message code="pop.show.wrongApproach"></spring:message> ';
	const copyLevFailtext	= '<spring:message code="trade.copyLevFail"></spring:message> ';
	const orderPricetext	= '<spring:message code="trade.order"/> <spring:message code="trade.price"/>';
	const tptext			= '<spring:message code="trade.tp"/>';
	const fttext			= '<spring:message code="trade.filledtotal"/>';
	const tTypetext		= '<spring:message code="trade.trade"/><spring:message code="trade.type"/>';
	const oTypetext		= '<spring:message code="trade.ordertype"/>';
	const oNumtext		= '<spring:message code="trade.ordernum"/>';
	const oTimetext		= '<spring:message code="trade.order"/> <spring:message code="trade.time"/>';
	const actiontext		= '<spring:message code="trade.action"/>';
	const postautotext	= '<spring:message code="pop.trade.postAuto"/>';
	const inputQtytext	= '<spring:message code="pop.trade.inputQty"/>';
	const inputPricetext	= '<spring:message code="pop.trade.inputPrice"/>';
	const maxSizetext		= '<spring:message code="pop.trade.maxSize"/>';
	const nonPointtext	= '<spring:message code="pop.trade.nonPoint"/>';
	const levChangeFailtext	= '<spring:message code="pop.trade.levChangeFail"/>';
	const levChangeSuctext	= '<spring:message code="pop.trade.levChangeSuc"/>';
	const nothingOrdertext	= '<spring:message code="pop.show.nothingOrder"/>';
	const allCanceltext	= '<spring:message code="pop.show.allCancel"/>';
	const orderCanceltext	= '<spring:message code="pop.show.orderCancel"/>';
	const isochangeXtext	= '<spring:message code="pop.show.isochangeX"/>';
	const marginchangeXtext	= '<spring:message code="pop.show.marginchangeX"/>';
	const commingSoontext	= '<spring:message code="pop.show.commingSoon"/>';
	const logintext		= '<spring:message code="pop.show.login"/>';
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
	const cointext	= "<spring:message code='trade.coin'/>";
	const lPricetext	= "<spring:message code='trade.liquidPrice'/>";
	const yieldtext	= "<spring:message code='trade.yield'/>";
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
	
	const serverport = '<%=request.getServerPort()%>';
	let servername = '<%=request.getServerName()%>';
	
	$(".bottom_btn").click(function() {
		$(this).next(".bottom_box").slideToggle(200);
		$(this).children('img').toggleClass('on');
	});
	</script>
	<script src="js/tradeServerSetting.js?v=7" type="text/javascript"></script>
	<script src="js/tradeSetting.js?v=6" type="text/javascript"></script>
	<script src="js/htmlAppend.js?v=7" type="text/javascript"></script>
	<script src="js/trade.js?v=37" type="text/javascript"></script>
</body>
</html>