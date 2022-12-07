<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE>
<html>


<html data-wf-page="6344e745b7a4c973ecbe683f"
	data-wf-site="6344e745b7a4c962c3be683c">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../wesellFrame/header2.jsp"></jsp:include>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<style>
	.w-slider-dot { width:4px; height:4px; !important;}
  .w-slider-dot.w-active { 
  width:30px; height:4px; background-color: #ffffff; !important;
  }
  .w-slider-nav.w-round>div { border-radius: 2.5px; !important;}
  .main_listarea::-webkit-scrollbar {
  width: 3px;
  height:3px;
  !important;
  }
  .main_listarea::-webkit-scrollbar-thumb {
  background: #191921;
  border-radius:20px;
  opacity:50%;
  !important;
  }
</style>
<body class="body">
	<div class="frame-2">
		<div class="form-block-25 w-form">
			<form id="email-form-2" name="email-form-2" data-name="Email Form 2" method="get" class="form-16">
				<jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
				<div class="main_banner_block">
					<div data-delay="4000" data-animation="cross" class="slider w-slider" data-autoplay="false" data-easing="ease" data-hide-arrows="false" data-disable-swipe="false" data-autoplay-limit="0" data-nav-spacing="5" data-duration="500" data-infinite="true">
						<div class="mask w-slider-mask">
							<div class="slide-8 w-slide">
				               <div class="bannertxtwrap">
				                 <h1 class="heading-3 web"><spring:message code="main.heading3"/></h1>
				                 <h3 class="heading-4 web"><spring:message code="main.heading4"/></h3>
				                 <h1 class="heading-3 mobile"><spring:message code="main.heading3"/></h1>
				                 <h3 class="heading-4 mobile"><spring:message code="main.heading4"/></h3>
				               </div>
				             </div>
							<div class="slide w-slide">
								<div class="banner_box">
									<div data-w-id="a7d60f71-f6aa-37b6-ae7d-ee2d3535c7a2" class="bannertxtwrap">
										<h1 class="heading-3 web">
											<spring:message code="main.heading1"/><br>
											<strong class="bold-text-3"><spring:message code="menu.title"/></strong>
										</h1>
										<h3 class="heading-4 web">
											<spring:message code="main.heading2"/>
										</h3>
										<a href="/wesell/trade.do?betMode=usdt" class="main_b_btn web w-button"><spring:message code="main.start_trading"/></a>
										<h1 class="heading-3 mobile">
											<spring:message code="main.heading1"/><br>
											<strong><spring:message code="menu.title"/></strong>
										</h1>
										<h3 class="heading-4 mobile">
											<spring:message code="main.heading_4"/>
										</h3>
										<a href="/wesell/trade.do?betMode=usdt" class="main_b_btn mobile w-button"><spring:message code="main.start_trading"/></a>
									</div>
								</div>
							</div>
							<div class="slide-2 w-slide">
								<div class="banner_box">
									<div data-w-id="200fbbdc-cfe6-223a-6787-b004679f2506" class="bannertxtwrap">
										<h1 class="heading-3 web">
											<spring:message code="main.heading1"/><br>
											<strong class="bold-text-3"><spring:message code="menu.title"/></strong>
										</h1>
										<h3 class="heading-4 web">
											<spring:message code="main.heading2"/>
										</h3>
										<a href="/wesell/trade.do?betMode=usdt" class="main_b_btn web w-button"><spring:message code="main.start_trading"/></a>
										<h1 class="heading-3 mobile">
											<spring:message code="main.heading1"/><br>
											<strong><spring:message code="menu.title"/></strong>
										</h1>
										<h3 class="heading-4 mobile">
											<spring:message code="main.heading_4"/>
										</h3>
										<a href="/wesell/trade.do?betMode=usdt" class="main_b_btn mobile w-button"><spring:message code="main.start_trading"/></a>
									</div>
								</div>
							</div>
							<div class="slide-7 w-slide">
								<div class="banner_box">
									<div data-w-id="f28dbe31-2983-f9fb-a648-3bfe1c6dc397" class="bannertxtwrap">
										<h1 class="heading-3 web">
											<spring:message code="main.heading1"/><br>
											<strong class="bold-text-3"><spring:message code="menu.title"/></strong>
										</h1>
										<h3 class="heading-4 web">
											<spring:message code="main.heading2"/>
										</h3>
										<a href="/wesell/trade.do?betMode=usdt" class="main_b_btn web w-button"><spring:message code="main.start_trading"/></a>
										<h1 class="heading-3 mobile">
											<spring:message code="main.heading1"/><br>
											<strong><spring:message code="menu.title"/></strong>
										</h1>
										<h3 class="heading-4 mobile">
											<spring:message code="main.heading_4"/>
										</h3>
										<a href="/wesell/trade.do?betMode=usdt" class="main_b_btn mobile w-button"><spring:message code="main.start_trading"/></a>
									</div>
								</div>
							</div>
						</div>
						<div class="left-arrow w-slider-arrow-left">
							<div class="w-icon-slider-left"></div>
						</div>
						<div class="right-arrow w-slider-arrow-right">
							<div class="w-icon-slider-right"></div>
						</div>
						<div class="slide-nav w-slider-nav"></div>
					</div>

					<div class="m_b_itemblock">
						<div class="m_b_item_warp">
							<div class="m_b_item">
								<div class="m_b_item_t">
									<div class="m_b_item_title"><spring:message code="main.btxt1"/></div>
									<a href="/wesell/trade.do?betMode=usdt" class="m_b_link"><spring:message code="main.btxt1go"/></a>
								</div>
								<img src="/wesell/webflow/images2/main-icon2.png" loading="lazy" alt="" class="m_b_item_img">
							</div>
							<div class="m_b_item">
								<div class="m_b_item_t">
									<div class="m_b_item_title"><spring:message code="main.btxt2"/></div>
									<a href="/wesell/user/myasset.do" class="m_b_link"><spring:message code="main.btxt2go"/></a>
								</div>
								<img src="/wesell/webflow/images2/main-icon6.png" loading="lazy" alt="" class="m_b_item_img">
							</div>
							<div class="m_b_item">
								<div class="m_b_item_t">
									<div class="m_b_item_title"><spring:message code="main.btxt3"/></div>
									<a href="/wesell/user/p2pbuy.do" class="m_b_link"><spring:message code="main.btxt3go"/></a>
								</div>
								<img src="/wesell/webflow/images2/main-icon8.png" loading="lazy" alt=""
									class="m_b_item_img">
							</div>
							<div class="m_b_item _2">
								<div class="m_b_item_t">
									<div class="m_b_item_title"><spring:message code="main.btxt4"/></div>
									<a href="/wesell/customerService.do" class="m_b_link"><spring:message code="main.btxt4go"/></a>
								</div>
								<img src="/wesell/webflow/images2/main-icon4.png" loading="lazy" alt="" class="m_b_item_img">
							</div>
						</div>
					</div>

				</div>
				<div class="main_warp">
					<div class="main_section _2">
						<div data-w-id="a7d60f71-f6aa-37b6-ae7d-ee2d3535c7fc" class="main_listarea">
							<div class="main_listtop">
								<div class="div-block-114">
									<div class="main_listtoptxt coin">Mark</div>
									<div class="main_listtoptxt">Current Price</div>
									<div class="main_listtoptxt">24h change</div>
									<div class="main_listtoptxt">24h volume</div>
								</div>
							</div>
							<div class="main_list maincoin0  _2">
								<div class="main_coinsub">
									<img src="/wesell/webflow/images2/BTCicon_img_1.png" loading="lazy" alt="" class="image-36">
									<div class="asset_coininfo_name">BTC</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 cnow">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-4-copy up chigh">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 align down clow">0</div>
								</div>
								<a href="#" class="link-block-2 w-inline-block">
									<div class="text-block-44">〉</div>
								</a>
							</div>
							<div class="main_list maincoin1">
								<div class="main_coinsub">
									<img src="https://uploads-ssl.webflow.com/62a83346d5d8207305f370e2/62a83346d5d82064a9f37146_ETHicon45.png" loading="lazy" alt="" class="image-36">
									<div class="asset_coininfo_name">ETH</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 cnow">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-4-copy up chigh">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 align down clow">0</div>
								</div>
								<a href="#" class="link-block-2 w-inline-block">
									<div class="text-block-44">〉</div>
								</a>
							</div>
							<div class="main_list maincoin2  _2">
								<div class="main_coinsub">
									<img src="/wesell/webflow/images2/XRPicon45.svg" loading="lazy" alt="" class="image-36">
									<div class="asset_coininfo_name">XRP</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 cnow">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-4-copy up chigh">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 align down clow">0</div>
								</div>
								<a href="#" class="link-block-2 w-inline-block">
									<div class="text-block-44">〉</div>
								</a>
							</div>
							<div class="main_list maincoin3 ">
								<div class="main_coinsub">
									<img src="https://uploads-ssl.webflow.com/62a83346d5d8207305f370e2/62a83346d5d8204436f37147_TRXicon45.png" loading="lazy" alt="" class="image-36">
									<div class="asset_coininfo_name">TRX</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 cnow">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-4-copy up chigh">0</div>
								</div>
								<div class="main_listbox">
									<div class="text-block-33 align down clow">0</div>
								</div>
								<a href="#" class="link-block-2 w-inline-block">
									<div class="text-block-44">〉</div>
								</a>
							</div>
							<div class="main_list_b">
                				<a href="/wesell/trade.do" class="link-5"><spring:message code="main.viewmore"/><span class="main_list_arrow">▶</span></a>
              				</div>
						</div>
					</div>
					<div data-w-id="a7d60f71-f6aa-37b6-ae7d-ee2d3535c8a9" style="opacity: 0" class="main_section _3">
						<!-- <div class="m_subtitle">Experience a secure and comfortable transaction</div> -->
						<h1 class="heading"><spring:message code="main.brand"/></h1>
						<div class="main_box1">
			            	<div class="slide_warp"><img src="/wesell/webflow/images2/maingrp-1.svg" loading="lazy" alt="" class="operations_icon-2">
				                <h4 class="m_item2_title"><spring:message code="main.topper"/></h4>
				                <h5 class="heading-6"><spring:message code="main.text_2"/></h5>
			              	</div>
			              	<div class="slide_warp"><img src="/wesell/webflow/images2/maingrp-2.svg" loading="lazy" alt="" class="operations_icon-2 _2">
			                	<h4 class="m_item2_title"><spring:message code="main.use"/></h4>
			                	<h5 class="heading-6"><spring:message code="main.use_t"/></h5>
			              	</div>
			              	<div class="slide_warp"><img src="/wesell/webflow/images2/maingrp-3.svg" loading="lazy" alt="" class="operations_icon-2">
				                <h4 class="m_item2_title"><spring:message code="main.deep"/></h4>
				                <h5 class="heading-6"><spring:message code="main.deep_t"/></h5>
			              </div>
			            </div>
					</div>
					<div data-w-id="a7d60f71-f6aa-37b6-ae7d-ee2d3535c8cd" style="opacity:0" class="main_section _4">
            			<h1 class="main_white_head"><spring:message code="main.bitoceanchoice"/></h1>
            			<div class="main_imgbanner">
              				<div id="w-node-e8186ad0-50bf-cf3c-71f6-11edd22d4f7e-ecbe683f" class="main_img_b_box">
                				<div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon5.png" loading="lazy" alt="" class="main_img_b_img"></div>
                				<h4 class="m_item1_title"><spring:message code="main.Inplatform"/></h4>
                				<h5 class="heading-6"><spring:message code="main.Inplatform_1"/></h5>
              				</div>
              				<div id="w-node-_499abc9d-b1a7-e3d8-52c1-9c2044c2a729-ecbe683f" class="main_img_b_box">
				                <div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon1.png" loading="lazy" alt="" class="main_img_b_img"></div>
				                <h4 class="m_item1_title"><spring:message code="main.specialorder"/></h4>
				                <h5 class="heading-6"><spring:message code="main.specialorder_1"/> </h5>
              				</div>
			              	<div id="w-node-_822afc73-e203-3d7d-43db-561cd7d10c90-ecbe683f" class="main_img_b_box">
			              		<div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon7.png" loading="lazy" alt="" class="main_img_b_img"></div>
				                <h4 class="m_item1_title"><spring:message code="main.Cybersecurity"/></h4>
				                <h5 class="heading-6"><spring:message code="main.Cybersecurity_1"/></h5>
			              	</div>
			              	<div id="w-node-_0c66bbb6-8d68-25d7-3f9b-c6ead5b31ab5-ecbe683f" class="main_img_b_box">
				                <div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon3.png" loading="lazy" alt="" class="main_img_b_img"></div>
				                <h4 class="m_item1_title"><spring:message code="main.Trade24"/></h4>
				                <h5 class="heading-6"><spring:message code="main.Trade24_1"/></h5>
			              	</div>
			              	<div id="w-node-_1e394669-6728-ddbf-6bfb-91316b3ba1fc-ecbe683f" class="main_img_b_box">
				                <div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon9.png" loading="lazy" alt="" class="main_img_b_img"></div>
				                <h4 class="m_item1_title"><spring:message code="main.creditLine"/></h4>
				                <h5 class="heading-6"><spring:message code="main.creditLine_1"/></h5>
			              	</div>
		              		<div id="w-node-_4db1c82b-d2fe-fcdc-4372-351221417693-ecbe683f" class="main_img_b_box">
				                <div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon10.png" loading="lazy" alt="" class="main_img_b_img"></div>
				                <h4 class="m_item1_title"><spring:message code="main.fiattrading"/></h4>
				                <h5 class="heading-6"><spring:message code="main.fiattrading_1"/></h5>
		              		</div>
		              		<div id="w-node-_853368e3-d3d9-0017-7488-049f358d481c-ecbe683f" class="main_img_b_box">
				                <div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon11.png" loading="lazy" alt="" class="main_img_b_img"></div>
				                <h4 class="m_item1_title"><spring:message code="main.competfee"/></h4>
				                <h5 class="heading-6"><spring:message code="main.competfee_1"/></h5>
		              		</div>
		              		<div id="w-node-e7950f67-6be1-1021-f516-8f0de113e54e-ecbe683f" class="main_img_b_box">
				                <div class="main_img_circle"><img src="/wesell/webflow/images2/main-icon12.png" loading="lazy" alt="" class="main_img_b_img"></div>
				                <h4 class="m_item1_title"><spring:message code="main.Margin_1"/></h4>
				                <h5 class="heading-6"><spring:message code="main.coingeta"/></h5>
		              		</div>
            			</div>
          			</div>
					<div class="m_store_section">
		            <div class="m_store">
		              <div class="store_box">
		                <h1 class="heading-17"><spring:message code="main.feelfree"/></h1>
		                <div class="store_btnarea">
		                  <a href="https://play.google.com/store/apps/details?id=com.app.wesell" target="_blank" class="appstore_btn w-inline-block"><img src="/wesell/webflow/images2/white_googleplay.svg" loading="lazy" alt="" class="store_icon">
		                    <div>GET IT ON<br><span class="app_title">Google Play</span></div>
		                  </a>
		                  <a href="javascript:alert('<spring:message code="main.preparing"/>');" class="appstore_btn w-inline-block"><img src="/wesell/webflow/images2/appstore_white.svg" loading="lazy" alt="" class="store_icon">
		                    <div>Download on the<br><span class="app_title">App Store</span></div>
		                  </a>
		                </div>
		              </div><img src="/wesell/webflow/images2/main_dlogo-.png" loading="lazy" srcset="/wesell/webflow/images2/main_dlogo--p-500.png 500w, /wesell/webflow/images2/main_dlogo--p-800.png 800w, /wesell/webflow/images2/main_dlogo--p-1080.png 1080w, /wesell/webflow/images2/main_dlogo-.png 1208w" sizes="(max-width: 767px) 70vw, 500px" alt="" class="store_img">
		            </div>
		          </div>
				</div>
			</form>
		</div>
		<div class="popup" id="popDiv">
			<c:forEach var="item" items="${notilist}">
				<div class="main_noticepop" id="popupn${item.bidx}"
					style="display: none;">
					<div class="mainpop_block">
						<div class="main_popfeild" style="word-break: break-all; line-height: normal;">${item.text}</div>
						<div class="warp2">
							<a href="#" onclick="closepopupn(${item.bidx})" class="mainpopbtn w-button"><spring:message code="pop.withdrawRequest_5" /></a>
							<div class="form-block-15 w-form">
								<label class="w-checkbox checkbox-field"> 
								<input type="checkbox" id="popupnc${item.bidx}" class="w-checkbox-input checkbox-3"> 
								<span class="checkbox-label w-form-label" for="checkbox"> 
									<spring:message code="menu.24nonshow" />
								</span>
								</label>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
	<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=62b1125ac4d4d60ab9c62f81" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script src="/wesell/webflow/js/webflow2.js" type="text/javascript"></script>
</body>
</html>
<script>

function ready(){
	alert("<spring:message code='pop.ServiceReady_1'/>");
}

function notiCloseCheck(){
	var allClose = true;
	$.each($(".main_noticepop"), function(index, item){
 		if($(item).css("display") == 'flex') allClose = false;
	})
	if(allClose){
		$("#popDiv").css("display","none");
	}
}

getCookieMobile ();
function getCookieMobile () {
    var cookiedata = document.cookie;
    let lang = 1;
    <c:forEach var="result" items="${notilist}">
        if ( cookiedata.indexOf("popupn${result.bidx}=done") < 0){    
        	$("#popDiv").css('display','flex');
            $("#popupn${result.bidx}").css('display' ,'flex');    
        }else {
            $("#popupn${result.bidx}").css('display' ,'none');
        }            
                
    </c:forEach>
    notiCloseCheck();
}
function closepopupn(pidx){
    var ck = $("#popupnc"+pidx).is(":checked");    
    if(ck){
        setCookieMobile( "popupn"+pidx , "done" , 1);
    }
    $("#popupn"+pidx).hide();
    notiCloseCheck();
}

function setCookieMobile ( name, value, expiredays ) {    
    var todayDate = new Date();
    todayDate.setDate( todayDate.getDate() + expiredays );
    document.cookie = name + "=" + encodeURI(value)  + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

function fmtNum(num){
	if(num == null)
		return 0;
	if(num.length<=3)
		return num;
	
	var decimalv = "";
	
	if(num.indexOf(".") != -1)
	{
	 	var numarr = num.split(".");	
	 	num = numarr[0];
		decimalv = "."+numarr[1]; 
	}
		
    var len, point, str; 
    let min = "";
       
    num = num + ""; 
    if(num.charAt(0) == '-'){
    	num = num.substr(1);
    	min = "-";
    }
   
    point = num.length % 3 ;
   	str = num.substring(0, point);
   	len = num.length; 
    
    while (point < len) {
        if (str != "") str += ","; 
        str += num.substring(point, point + 3); 
        point += 3; 
    }        
    return min+str+decimalv;
}

function getSymbol(symbol) {
	switch (symbol) {
	case "BTCUSDT":
	case "BTC":
	case "BTCUSD":
		return 0;
	case "ETHUSDT":
	case "ETH":
	case "ETHUSD":
		return 1;
	case "XRPUSDT":
	case "XRP":
	case "XRPUSD":
		return 2;
	case "TRXUSDT":
	case "TRX":
	case "TRXUSD":
		return 3;
	case "DOGEUSDT":
	case "DOGE":
	case "DOGEUSD":
		return 4;
	default:
		break;
	}
}

var coinArr = new Array('BTCUSDT', 'ETHUSDT', 'XRPUSDT', 'TRXUSDT'); // 코인 변수명 
var fPrice = new Object;

var wsAPIUri = "wss://fstream.binance.com/stream?streams=";
for (i = 0; i < coinArr.length; i++) {
	if(i==0){
		wsAPIUri += coinArr[i].toLowerCase() + '@kline_1m';
	}else{
		wsAPIUri += '/' + coinArr[i].toLowerCase() + '@kline_1m';
	}
	wsAPIUri += '/' + coinArr[i].toLowerCase() + '@ticker';
}

var websocket2;

function initAPI() {
	websocket2 = new WebSocket(wsAPIUri);
	websocket2.onopen = function(evt) {
		console.log("connect OK");
		onAPIOpen(evt);
	};
	websocket2.onmessage = function(evt) {
		onAPIMessage(evt);
	};
	websocket2.onerror = function(evt) {
		onAPIError(evt);
	};
	websocket2.onclose = function(evt) {
		console.log("API 재접속");
		setTimeout("initAPI()", 1000);
	};
}
function onAPIOpen(evt) {
	console.log('APIOPEN---------------')
}
function onAPIMessage(evt) {
	let jdata = JSON.parse(evt.data);
	let stream = jdata.stream;

	if (stream.slice(-7) === '@ticker') {
		var symbol = stream.slice(0,-7).toUpperCase();
		var cnum = getSymbol(jdata.data.s);
		$(".mainCoin"+cnum).find(".chigh").html(jdata.data.h);
		$(".mainCoin"+cnum).find(".clow").html(jdata.data.l);
	}
	if (stream.slice(-9) === '@kline_1m') {
		try{
			fPrice[jdata.data.s] = jdata.data.k['c'];
			let arr = new Array(5);
			let coin = ['BTC','ETH','XRP','TRX','DOGE'];
			for(i=0; i<coin.length; i++) {
			  let sym = coin[i];
			  let type;
			  sym === 'BTC' ? type = 0 : sym === 'ETH' ? type = 1 : sym === 'XRP' ? type = 2 : sym === 'TRX' ? type = 3 : sym === 'DOGE' ? type = 4 : '';
			  for (key in fPrice) {
			    if (key === sym+'USDT') {
			      arr[type] = fPrice[key];
			    }
			  }
			}
			for(var k =0 ; k<5; k++){
				$(".mainCoin"+k).find(".cnow").html(arr[k]);
				
			}
		}catch(e) {
			console.log(stream, " kline err",e);
		}
	}
}
window.addEventListener("load", initAPI, false);
</script>