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
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body class="body">
  <div class="frame">
    <jsp:include page="../wesellFrame/top2.jsp"></jsp:include>
    <div class="main_warp">
      <div class="m_section1 wf-section">
        <div class="m_sc_block1">
          <div class="m_sc_box1">
            <div class="m_sc_title"><spring:message code="wesell.main.ment1"/> <br><spring:message code="wesell.main.ment2"/></div>
            <div class="m_sc_stitle"><spring:message code="wesell.main.ment3"/> <br><spring:message code="wesell.main.ment4"/></div>
            <div class="m_sc_btn_area">
             <c:if test="${userIdx eq null}">
					<a href="/wesell/login.do" class="loginbtn <c:if test="${currentP eq 'login'}">click</c:if> w-button"><spring:message code="menu.login"/></a>
					<a href="/wesell/join.do" class="registbtn <c:if test="${currentP eq 'join'}">click</c:if> w-button"><spring:message code="menu.register"/></a>
				</c:if>
            </div>
          </div>
          <div class="m_sc_box2"><img src="/wesell/webflow/images2/wesell_logo.png" loading="lazy" srcset="/wesell/webflow/images2/wesell_logo-p-500.png 500w, /wesell/webflow/images2/wesell_logo-p-800.png 800w, /wesell/webflow/images2/wesell_logo-p-2000.png 2000w, /wesell/webflow/images2/wesell_logo.png 2000w" sizes="(max-width: 767px) 45vw, 200px" alt="" class="m_sc1_img">
            <div class="n_sc_chart">
              <div class="n_sc_chart_box"></div>
            </div>
          </div>
        </div>
        <div class="m_rolling">
          <div class="rolling_area">
            <div><spring:message code="wesell.main.ment7"/></div>
          </div>
        </div>
      </div>
      <div class="m_section2 wf-section">
        <div class="m_sc_block2">
          <div class="m_sc_title2"><spring:message code="wesell.main.ment8"/></div>
          <div class="m_sc_stitle"><spring:message code="wesell.main.ment9"/></div>
          <div class="m_sc2_box">
            <div class="form-block w-form">
              <form id="email-form-2" name="email-form-2" data-name="Email Form 2" method="get">
                <div class="m_sc2_item">
                  <div class="m_c_box">
                    <div>USDT</div><input type="text" class="m_c_input w-input" maxlength="256" name="field-2" data-name="Field 2" placeholder="Example Text" id="field-2" required="">
                  </div>
                  <div class="m_c_box2"><img src="/wesell/webflow/images2/1608681_exchange_icon_11608681_exchange_icon.png" loading="lazy" alt="" class="m_c_icon"></div>
                  <div class="m_c_box">
                    <div>Coin Select</div><select id="field-3" name="field-3" data-name="Field 3" class="m_coin_select w-select">
                      <option value="">Select one...</option>
                      <option value="First">First choice</option>
                      <option value="Second">Second choice</option>
                      <option value="Third">Third choice</option>
                    </select>
                  </div>
                </div>
                <div class="m_c_result">
                  <div>1,000,000,000 Coin</div>
                </div>
              </form>
              <div class="w-form-done">
                <div>Thank you! Your submission has been received!</div>
              </div>
              <div class="w-form-fail">
                <div>Oops! Something went wrong while submitting the form.</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="m_section3 wf-section">
        <div class="m_sc_block3">
          <div class="m_sc_title2"><spring:message code="wesell.main.ment10"/></div>
          <div class="m_sc_stitle"><spring:message code="wesell.main.ment11"/></div>
          <div class="m_sc_itemblock">
            <div id="w-node-_9e3126ee-a5bb-a243-52af-c9c612938c27-d31606f3" class="m_sc_item"><img src="/wesell/webflow/images2/chart.png" loading="lazy" srcset="/wesell/webflow/images2/chart-p-500.png 500w, /wesell/webflow/images2/chart-p-800.png 800w, /wesell/webflow/images2/chart-p-2000.png 2000w, /wesell/webflow/images2/chart.png 2000w" sizes="(max-width: 767px) 18vw, 119.828125px" alt="" class="m_sc_item_img">
              <div class="m_item_title"><spring:message code="wesell.main.ment12"/></div>
              <div><spring:message code="wesell.main.ment13"/></div>
            </div>
            <div id="w-node-cc896c90-49b8-1127-0cbd-60b9d1aa82d8-d31606f3" class="m_sc_item"><img src="/wesell/webflow/images2/trophy.svg" loading="lazy" alt="" class="m_sc_item_img">
              <div class="m_item_title"><spring:message code="wesell.main.ment14"/></div>
              <div><spring:message code="wesell.main.ment15"/></div>
            </div>
            <div id="w-node-_7b33e635-8304-82b5-e245-f9828f15f995-d31606f3" class="m_sc_item"><img src="/wesell/webflow/images2/rocket.svg" loading="lazy" alt="" class="m_sc_item_img">
              <div class="m_item_title"><spring:message code="wesell.main.ment16"/></div>
              <div><spring:message code="wesell.main.ment17"/></div>
            </div>
            <div id="w-node-_99f0a873-fe84-57f9-abf3-57f13cb5adc7-d31606f3" class="m_sc_item"><img src="/wesell/webflow/images2/fix.svg" loading="lazy" alt="" class="m_sc_item_img">
              <div class="m_item_title"><spring:message code="wesell.main.ment18"/></div>
              <div><spring:message code="wesell.main.ment19"/></div>
            </div>
            <div id="w-node-a908d69f-1c49-7dda-efc8-82e6e22adbbf-d31606f3" class="m_sc_item"><img src="/wesell/webflow/images2/puzzle.png" loading="lazy" srcset="/wesell/webflow/images2/puzzle-p-500.png 500w, /wesell/webflow/images2/puzzle-p-800.png 800w, /wesell/webflow/images2/puzzle-p-2000.png 2000w, /wesell/webflow/images2/puzzle.png 2000w" sizes="(max-width: 767px) 18vw, 83.28125px" alt="" class="m_sc_item_img">
              <div class="m_item_title"><spring:message code="wesell.main.ment20"/></div>
              <div><spring:message code="wesell.main.ment21"/></div>
            </div>
            <div id="w-node-ca8a5e45-d795-05dc-2d10-1d2f3d010553-d31606f3" class="m_sc_item"><img src="/wesell/webflow/images2/partner.png" loading="lazy" srcset="/wesell/webflow/images2/partner-p-500.png 500w, /wesell/webflow/images2/partner-p-800.png 800w, /wesell/webflow/images2/partner-p-2000.png 2000w, /wesell/webflow/images2/partner.png 2000w" sizes="(max-width: 767px) 18vw, 131.09375px" alt="" class="m_sc_item_img">
              <div class="m_item_title"><spring:message code="wesell.main.ment22"/></div>
              <div><spring:message code="wesell.main.ment23"/></div>
            </div>
          </div>
        </div>
      </div>
      <div class="m_section_store wf-section">
        <div class="m_sc_store">
          <div class="m_store_block">
            <div class="m_store_txt">
              <div class="m_sc_title2"><spring:message code="wesell.main.ment24"/><br><spring:message code="wesell.main.ment25"/></div>
              <div class="m_sc_stitle"><spring:message code="wesell.main.ment26"/></div>
              <div> <spring:message code="wesell.main.ment27"/></div>
              <div class="m_sc_btn_area">
                <a href="#" class="m_store_btn w-inline-block"><img src="/wesell/webflow/images2/google_play.svg" loading="lazy" alt="" class="m_sc_store_icon">
                  <div>GET IT ON<br><span class="storetxt">Google Play</span></div>
                </a>
                <a href="#" class="m_store_btn w-inline-block"><img src="/wesell/webflow/images2/appstore.svg" loading="lazy" alt="" class="m_sc_store_icon">
                  <div>Download on the<br><span class="storetxt">App Store</span></div>
                </a>
              </div>
            </div>
            <div class="m_store_box">
              <div class="m_sotre_back"></div><img src="/wesell/webflow/images2/wesell_logo.svg" loading="lazy" alt="" class="mlogo_store_deco _2"><img src="/wesell/webflow/images2/favicon256.png" loading="lazy" alt="" class="mlogo_store_deco">
            </div>
          </div>
        </div>
      </div>
    </div>
		<div class="popup" id="popDiv">
			<c:forEach var="item" items="${notilist}">
				<div class="main_noticepop" id="popupn${item.bidx}"
					style="display: none;">
					<div class="mainpop_block">
						<div class="main_popfeild"
							style="word-break: break-all; line-height: normal;">${item.text}</div>
						<div class="warp2">
							<a href="#" onclick="closepopupn(${item.bidx})"
								class="mainpopbtn w-button"><spring:message
									code="pop.withdrawRequest_5" /></a>
							<div class="form-block-15 w-form">
								<label class="w-checkbox checkbox-field"> <input
									type="checkbox" id="popupnc${item.bidx}"
									class="w-checkbox-input checkbox-3"> <span
									class="checkbox-label w-form-label" for="checkbox"> <spring:message
											code="menu.24nonshow" />
								</span>
								</label>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	<jsp:include page="../wesellFrame/footer2.jsp"></jsp:include>
  <a data-w-id="0331a75b-f75e-124e-d24c-9bad6e3bde93" style="opacity:0" href="#" class="ask w-inline-block"><img src="/wesell/webflow/images2/9042680_multi_bubble_icon_19042680_multi_bubble_icon.png" loading="lazy" alt="" class="askicon"></a>
  <script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=636de9ea5f52266a6d1606f1" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
  <script src="js/webflow2.js" type="text/javascript"></script>
  <!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
  <script>
//메뉴

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
</html>