<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="../adminFrame/header.jsp"></jsp:include>
</head>
<body id="page-top">
	<div id="wrapper">
		<c:import url="/0nI0lMy6jAzAFRVe0DqLOw/left.do"/>
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<jsp:include page="../adminFrame/top.jsp"></jsp:include>
				<div class="container-fluid">
					<h1 class="h3 mb-2 text-gray-800">
	                	Dashboard
		            </h1>			
					<div class="row" style="font-size:larger; font-weight:bold;">
						<div class="col-lg-4 col-md-6">          
							<div class="card bg-primary text-white shadow">
	                        	<div class="card-body">
		                        	<div class="huge usdt">일별 유저수 : ${todayMemCnt.userCnt+todayMemCnt.chongCnt}명</div>
		                        	<div class="small">일반 : ${todayMemCnt.userCnt}명 / 총판 : ${todayMemCnt.chongCnt}명</div>
	                    	    </div>
		                    </div>
						</div>
						<div class="col-lg-4 col-md-6">
							<div class="card bg-success text-white shadow">
                            	<div class="card-body">
                                	<div class="huge usdt">누적 유저수 : ${memCnt.userCnt+memCnt.chongCnt}명</div>
		                        	<div class="small">일반 : ${memCnt.userCnt}명 / 총판 : ${memCnt.chongCnt}명</div>
                           		</div>
                           </div>
						</div>
					</div>
					<br>
					<div class="table-responsive">
						<table class="table table-bordered table-hover table-striped"
							style="max-width: auto; float: left;">
							<thead>
								<tr>
									<!-- (balance) -->
									<th style="width: 200px">총 유저 지갑(balance)</th>
									<th style="width: 200px">Futures</th>
									<th style="width: 200px">BTC</th>
									<th style="width: 200px">ETH</th>
									<th style="width: 200px">USDT</th>
									<th style="width: 200px">XRP</th>
									<th style="width: 200px">TRX</th>
								</tr>
							</thead>
							<tbody>
								<tr id="userWallet"></tr>
								<!-- <tr id="partnerWallet"></tr> -->
							</tbody>
						</table>								
						<div>
							<br> 총 유저 잔액(원) : <span id="userKrw">0</span>
						</div>
					</div>
							
					<br>
					<div class="form-group">
						<label>입출금 기간 검색</label>
						<div>
							<input type="date" name="sdate" id="sdate" value="" class="form-control" style="width: 15%; display: inline-block;" autocomplete="off"> ~ <input type="date" name="edate" id="edate" value="" class="form-control" style="width: 15%; display: inline-block;" autocomplete="off">
							<button class="btn btn-default" style="padding: 6px 12px; margin-left: 5px" onclick="dashBoardDateSearch()" type="button">
								<i class="fa fa-search"></i>
							</button>
						</div>
					</div>
					<div class="table-responsive">
						<table class="table table-bordered table-hover table-striped" style="max-width: auto;">
							<thead>
								<tr>
									<th style="width: 200px">코인 입출금액(transaction)</th>
									<th style="width: 200px">BTC</th>
									<th style="width: 200px">ETH</th>
									<th style="width: 200px">USDT</th>
									<th style="width: 200px">XRP</th>
									<th style="width: 200px">TRX</th>
									<th style="width: 200px">총 합계(USDT)</th>
								</tr>
							</thead>
							<tbody>
								<tr id="userDeposit"></tr>
								<!-- 		                   <tr id="adminDeposit"></tr> -->
								<tr id="withdraw"></tr>
								<tr id="result"></tr>
								<!-- 		                   <tr id="adminCollect"></tr> -->
							</tbody>
						</table>
						<div></div>
						<div>
							<br>
							<br>
							<br>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../adminFrame/footer.jsp"></jsp:include>
</body>
<script>
var dashboardData;
function dashBoardDateSearch() {
	var sdate = $("#sdate").val();
	var edate = $("#edate").val();

	if (sdate == '' || edate == '') {
		alert("조회시작기간과 조회종료기간을 설정해주세요.");
		return;
	}
	if (edate < sdate) {
		alert("조회종료기간이 조회시작기간보다 작을 수 없습니다.");
		return;
	}
	getMoneySum(sdate, edate);
}

getMoneySum("", "");

var userDepoarray;
var witharray;
function getMoneySum(sdate, edate) {
	$.ajax({
		type : 'post',
		data : {
			"sdate" : sdate,
			"edate" : edate
		},
		url : '/global/0nI0lMy6jAzAFRVe0DqLOw/getDashboard.do',
		dataType : "json",
		success : function(data) {
			console.log("getDashboard ajax:", data);
			dashboardData = data;
			witharray = new Array(data.withdrawBTC,
					data.withdrawUSDT, data.withdrawXRP,
					data.withdrawTRX, data.withdrawETH);
			userDepoarray = new Array(data.depositBTC,
					data.depositUSDT, data.depositXRP,
					data.depositTRX, data.depositETH);
			for (var i = 0; i < userDepoarray.length; i++) {
				if ("" + userDepoarray[i] == "undefined") {
					userDepoarray[i] = 0;
				}
			}
			for (var i = 0; i < witharray.length; i++) {
				if ("" + witharray[i] == "undefined") {
					witharray[i] = 0;
				}
			}
			$("#userWallet").html("<td>보유잔고</td> "
									+ "<td><span class='onkrw futures'>"
									+ parseFloat(data.wallet)
											.toFixed(6)
									+ "</span><span class='krwCoin'> Futures</span></td>"
									+ " <td><span class='onkrw btc'>"
									+ parseFloat(data.userBTC)
											.toFixed(6)
									+ "</span><span class='krwCoin'> BTC</span></td>"
									+ " <td><span class='onkrw btc'>"
									+ parseFloat(data.userETH)
											.toFixed(6)
									+ "</span><span class='krwCoin'> ETH</span></td>"
									+ " <td><span class='onkrw usdt'>"
									+ parseFloat(data.userUSDT)
											.toFixed(6)
									+ "</span><span class='krwCoin'> USDT</span></td>"
									+ " <td><span class='onkrw xrp'>"
									+ parseFloat(data.userXRP)
											.toFixed(6)
									+ "</span><span class='krwCoin'> XRP</span></td>"
									+ " <td><span class='onkrw trx'>"
									+ parseFloat(data.userTRX)
											.toFixed(6)
									+ "</span><span class='krwCoin'> TRX</span></td>");
			/* $("#partnerWallet").html("<td>파트너장 보유잔고</td> <td><span class='onkrw futures'>"+data.pWallet+"</span></td> <td><span class='onkrw btc'>"+partnerWallet[0]+"</span></td> <td><span class='onkrw usdt'>"+partnerWallet[1]+"</span></td> <td><span class='onkrw xrp'>"+partnerWallet[2]+"</span></td> <td><span class='onkrw trx'>"+partnerWallet[3]+"</span></td>"); */
			//$("#deposit").html("<td>입금 총액</td> <td><span class='onkrw btc'>"+depoarray[0]+"</span></td> <td><span class='onkrw usdt'>"+depoarray[1]+"</span></td> <td><span class='onkrw xrp'>"+depoarray[2]+"</span></td> <td><span class='onkrw trx'>"+depoarray[3]+"</span></td>");
			$("#userDeposit").html("<td>유저 입금 총액</td>"
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=%2B&coin=BTC&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw btc'>"
									+ userDepoarray[0]
									+ "</a><span class='krwCoin'> BTC</span></td>"
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=%2B&coin=ETH&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw eth'>"
									+ userDepoarray[4]
									+ "</a><span class='krwCoin'> ETH</span></td>"
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=%2B&coin=USDT&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw usdt'>"
									+ userDepoarray[1]
									+ "</a><span class='krwCoin'> USDT</span></td>"
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=%2B&coin=XRP&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw xrp'>"
									+ userDepoarray[2]
									+ "</a><span class='krwCoin'> XRP</span></td> "
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=%2B&coin=TRX&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw trx'>"
									+ userDepoarray[3]
									+ "</a><span class='krwCoin'> TRX</span></td>"
									+ "<td><span id='tot_d' class='onkrw usdt'></span><span class='krwCoin'> USDT</span></td>");

			$("#withdraw").html("<td>출금 총액</td> "
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=-&coin=BTC&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw btc'>"
									+ witharray[0]
									+ "</a><span class='krwCoin'> BTC</span></td> "
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=-&coin=ETH&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw eth'>"
									+ witharray[4]
									+ "</a><span class='krwCoin'> ETH</span></td> "
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=-&coin=USDT&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw usdt'>"
									+ witharray[1]
									+ "</a><span class='krwCoin'> USDT</span></td> "
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=-&coin=XRP&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw xrp'>"
									+ witharray[2]
									+ "</a><span class='krwCoin'> XRP</span></td> "
									+ "<td><a href='/global/0nI0lMy6jAzAFRVe0DqLOw/transactions.do?label=-&coin=TRX&wstat=1&test=test&sdate="
									+ sdate
									+ "&edate="
									+ edate
									+ "' class='onkrw trx'>"
									+ witharray[3]
									+ "</a><span class='krwCoin'> TRX</span></td>"
									+ "<td><span id='tot_w' class='onkrw usdt'></span><span class='krwCoin'> USDT</span></td>")
			$("#result").html("<td>입금 - 출금</td> "
									+ "<td><span class='onkrw btc'>"
									+ (parseFloat(userDepoarray[0] - witharray[0]).toFixed(8))
									+ "</span><span class='krwCoin'> BTC</span></td>"
									+ "<td><span class='onkrw eth'>"
									+ (parseFloat(userDepoarray[4] - witharray[4]).toFixed(8))
									+ "</span><span class='krwCoin'> ETH</span></td>"
									+ "<td><span class='onkrw usdt'>"
									+ parseFloat(userDepoarray[1] - witharray[1]).toFixed(8)
									+ "</span><span class='krwCoin'> USDT</span></td> "
									+ "<td><span class='onkrw xrp'>"
									+ parseFloat(userDepoarray[2] - witharray[2]).toFixed(8)
									+ "</span><span class='krwCoin'> XRP</span></td> "
									+ "<td><span class='onkrw trx'>"
									+ parseFloat(userDepoarray[3] - witharray[3]).toFixed(8)
									+ "</span><span class='krwCoin'> TRX</span></td>"
									+ "<td><span id='tot_dw' class='onkrw usdt'></span><span class='krwCoin'> USDT</span></td>");
			initPage();
		}
	})
}

function totalUSDTUpdate(){
	if(!$("#tot_d").hasClass("krwState"))
		$("#tot_d").text(totalUSDT(userDepoarray[0],userDepoarray[4],userDepoarray[1],userDepoarray[2],userDepoarray[3]));
	if(!$("#tot_w").hasClass("krwState"))
		$("#tot_w").text(totalUSDT(witharray[0],witharray[4],witharray[1],witharray[2],witharray[3]));
	if(!$("#tot_dw").hasClass("krwState"))
		$("#tot_dw").text(totalUSDT(userDepoarray[0]-witharray[0],userDepoarray[4]-witharray[4],userDepoarray[1]-witharray[1],userDepoarray[2]-witharray[2],userDepoarray[3]-witharray[3]));
	
}
function totalUSDT(btc,eth,usdt,xrp,trx){
	return ((Number(btc)*btcPrice) + (Number(eth)*ethPrice) + (Number(xrp)*xrpPrice) + (Number(trx)*trxPrice) + Number(usdt)).toFixed(4);
}
setInterval(totalUSDTUpdate,1000);

var servername = '<%=request.getServerName()%>';
//var wsUri = "ws://<%=request.getServerName()%>:8287";
var wsUri = "wss://<%=request.getServerName()%>:8287/port8287";
if(servername == "localhost")
	wsUri = "ws://<%=request.getServerName()%>:8288/port8288";
function init() {
	websocket = new WebSocket(wsUri);
	websocket.onopen = function(evt) {
		onOpen(evt);
	};
	websocket.onmessage = function(evt) {
		onMessage(evt);
	};
	websocket.onerror = function(evt) {
		onError(evt);
	};
}
function onOpen(evt) {	
    var obj = new Object;    
    obj.protocol = "imok";
    obj.userIdx = "1";
    obj.locate = "wallet";
    doSend(JSON.stringify(obj));
}

function onError(evt) {	
}

function doSend(message) {    websocket.send(message);}


var tempRate = 0;
var btcPrice = 0;
var ethPrice = 0;
var futureBtcPrice = 0;
var xrpPrice = 0;
var trxPrice = 0;
var exchangeRate = 0;
var tempVal = 0;
function onMessage(evt) {
	var evtObj = JSON.parse(evt.data);
	
	let kind = evtObj.symbol;
	if (kind === 'BTCUSDT') {
		var num = notNanSub(parseFloat(evtObj['sprice']));
		if(num != 0) btcPrice = num;
		
		num = notNanSub(parseFloat(evtObj['price']));
		if(num != 0) futureBtcPrice = num;
		
	}
	else if(kind === 'ETHUSDT'){
		var num = notNanSub(parseFloat(evtObj['sprice']));
		if(num != 0) ethPrice = num;
	}
	else if(kind === 'XRPUSDT'){
		var num = notNanSub(parseFloat(evtObj['sprice']));
		if(num != 0) xrpPrice = num;
	}
	else if(kind === 'TRXUSDT'){
		var num = notNanSub(parseFloat(evtObj['sprice']));
		if(num != 0) trxPrice = num;
	}
	tempRate = notNanSub(parseFloat(evtObj['exchangeRate']));
	if(tempRate != exchangeRate)
		exchangeRate = tempRate;
}
init();

function notNanSub(num){
	if(!isNaN(num)){
		return num;
	}
	return 0;
}
function krw(node){
	tempVal = $(node).html();
	$(node).addClass("krwState");
	if($(node).hasClass("eth")){
		$(node).html(changekrw(tempVal,"eth"));
	}else if($(node).hasClass("btc")){
		$(node).html(changekrw(tempVal,"btc"));
	}else if($(node).hasClass("eth")){
		$(node).html(changekrw(tempVal,"eth"));
	}else if($(node).hasClass("usdt")){
		$(node).html(changekrw(tempVal,"usdt"));
	}else if($(node).hasClass("xrp")){
		$(node).html(changekrw(tempVal,"xrp"));
	}else if($(node).hasClass("trx")){
		$(node).html(changekrw(tempVal,"trx"));
	}else if($(node).hasClass("futures")){
		$(node).html(changekrw(tempVal,"usdt"));
	}
	$(node).next().css("display","none");
}

function exchangeKrw(val, coin){
	val = parseFloat(val);
	switch(coin){
		case "eth": return parseFloat(((val*ethPrice)*exchangeRate).toFixed(0));
		case "btc": return parseFloat(((val*btcPrice)*exchangeRate).toFixed(0));
		case "usdt": return parseFloat(((val*exchangeRate)).toFixed(0));
		case "xrp": return parseFloat(((val*xrpPrice)*exchangeRate).toFixed(0));
		case "trx": return parseFloat(((val*trxPrice)*exchangeRate).toFixed(0));
	}	
}

function krwClose(node){
	if($(node).hasClass("krwState")){
		$(node).html(tempVal);
		$(node).removeClass("krwState");	
		$(node).next().css("display","inline-block");
	}
}

function initPage(){
	if(btcPrice != 0 && ethPrice != 0 && exchangeRate != 0 && xrpPrice != 0 && trxPrice != 0){ //시세가 빠짐없이 들어왔다면
		krwSetting();
		$(".onkrw").css("line-break","anywhere");
		$(".onkrw").on("mouseover", function() {
			krw(this);
		});
		$(".onkrw").on("mouseout", function() {
			krwClose(this);
		});
	}else{
		setTimeout(initPage,100);
	}
}


function changekrw(val, coin){
	switch(coin){
		case "eth": return "krw = "+fmtNum(((val*ethPrice)*exchangeRate).toFixed(0))+"원";
		case "btc": return "krw = "+fmtNum(((val*btcPrice)*exchangeRate).toFixed(0))+"원";
		case "usdt": return "krw = "+fmtNum(((val*exchangeRate)).toFixed(0))+"원";
		case "xrp": return "krw = "+fmtNum(((val*xrpPrice)*exchangeRate).toFixed(0))+"원";
		case "trx": return "krw = "+fmtNum(((val*trxPrice)*exchangeRate).toFixed(0))+"원";
	}	
}

function fmtNum(num) {
	if (num == null)
		return 0;
	if (num.length <= 3)
		return num;

	let decimalv = "";

	if (num.indexOf(".") != -1) {
		let
		numarr = num.split(".");
		num = numarr[0];
		decimalv = "." + numarr[1];
	}

	let len, point, str;
	let min = "";

	num = num + "";
	if (num.charAt(0) == '-') {
		num = num.substr(1);
		min = "-";
	}

	point = num.length % 3;
	str = num.substring(0, point);
	len = num.length;

	while (point < len) {
		if (str != "")
			str += ",";
		str += num.substring(point, point + 3);
		point += 3;
	}
	return min + str + decimalv;
}

function krwSetting(){
	var companyK = exchangeKrw(dashboardData.adminBTC,'btc')+
	exchangeKrw(dashboardData.adminETH,'eth')+
	exchangeKrw(dashboardData.adminUSDT,'usdt')+
	exchangeKrw(dashboardData.adminXRP,'xrp')+
	exchangeKrw(dashboardData.adminTRX,'trx')+
	exchangeKrw(dashboardData.unpaidBTC,'btc')+
	exchangeKrw(dashboardData.unpaidUSDT,'usdt')+
	exchangeKrw(dashboardData.unpaidTRX,'trx');

	var usersK = exchangeKrw(dashboardData.wallet,'usdt')+
		exchangeKrw(dashboardData.userBTC,'btc')+
		exchangeKrw(dashboardData.userUSDT,'usdt')+
		exchangeKrw(dashboardData.userXRP,'xrp')+
		exchangeKrw(dashboardData.userTRX,'trx');
	
	$("#companyKrw").html(fmtNum(""+companyK));
	$("#userKrw").html(fmtNum(""+usersK));
}
</script>
</html>