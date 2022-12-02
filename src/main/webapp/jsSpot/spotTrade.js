////////////////////////////////기본세팅
$(function() {
	coinLoad();
});

function initPage(){
	poLoad(); // 초기 주문 세팅
	APICoinChange(); //바이낸스 종목 링크 가져옴 (처음에 한번 호출 or 종목변경 시)
	//init();
	initToWeb();
	initAPI();
	$("#orderLongList" + coinNum).css('display', 'block');
	$("#orderStopList" + coinNum).css('display', 'block');
	//initAPI();//tradeServerSetting.js에서 중복호출됨
	showChart(getCoinType(coinNum));
	
	$(".hogablock").on("click", function() {
		if(orderType != "market"){
			$("#dealSise").val($(this).find(".hp").html());	
			if (orderType == "stopMarket") {
				triggerPrice[coinNum] = $("#dealSise").val();
			}
		}
	});
	$(".changecoin").on("click", function() { // 코인 종류 변경
//		if (loading)
//			return;
		coinType = $(this).attr("ctype").split("_")[1];
		coinTypeChange(coinType);
	});
	$(".bottom_btn").click(function() {
		$(this).next(".bottom_box").slideToggle(200);
		$(this).children('img').toggleClass('on');
	});
}

function setAssetBlock(cnum){
	if(longSise[cnum] == undefined) return;
	
	var $assetblock = $("#spotAsset"+cnum);
	var nowBalance = Number(toFixedDown(coinBalance[cnum],5));
	var aveBuyPrice = getAveEntryPrice(cnum);
	var currentPrice = (nowBalance * longSise[cnum]);
	var buyPrice = (nowBalance * aveBuyPrice);
	var buyProfit = currentPrice - buyPrice;
	var buyProfitRate = buyProfit / buyPrice * 100;
	if(isNaN(buyProfitRate)) buyProfitRate = 0;
	
	$assetblock.find(".nowBalance").text(nowBalance);
	$assetblock.find(".currentPrice").text(toFixedDown(currentPrice,5)+" USDT");
	$assetblock.find(".buyPrice_ave").text(toFixedDown(aveBuyPrice,5)+" USDT");
	$assetblock.find(".buyPrice").text(toFixedDown(buyPrice,5)+" USDT");
	$assetblock.find(".buyProfit").text(toFixedDown(buyProfit,5)+" USDT");
	$assetblock.find(".buyProfitRate").text(buyProfitRate.toFixed(2)+"%");

	$assetblock.children(".profitcolor").removeClass("long");
	$assetblock.children(".profitcolor").removeClass("short");
	if(Number(toFixedDown(buyProfit,5)) > 0){
		$assetblock.children(".profitcolor").addClass("long");
	}else if(buyProfit < 0){
		$assetblock.children(".profitcolor").addClass("short");
	}
}

function poLoad(){
	// 처음 새로고침시 바로 뜨는 포지션 목록
	if (userIdx != "") {
		/*for (var k = 0; k < positionObj.plist.length; k++) {
			if (isShow(positionObj.plist[k].symbol)) {
				setMarginTypeCNum(positionObj.plist[k].marginType,
						getCoinNum(positionObj.plist[k].symbol));
				setPosition(positionObj.plist[k]);
			}
	
		}*/
		for (var k = 0; k < positionObj.olist.length; k++) {
			setOrder(positionObj.olist[k]);			
		}
	}
}

function coinMenu() {
	let menu = $("#coinMenu");
	$("#infoMenu").css("display","none");
	if (menu.css("display") == 'flex') {
		menu.css("display", "none");
	} else {
		menu.css("display", "flex");
	}
}
function infoMenu() {
	$("#coinMenu").css("display","none");
	let menu = $("#infoMenu");
	if (menu.css("display") == 'flex') {
		menu.css("display", "none");
	} else {
		menu.css("display", "flex");
	}
}

function getSymbolFixedNum(symbol){
	return getSymbolFixed(getCoinNum(symbol));
}

function getSymbolFixed(cnum) {
	let c = parseInt(cnum);
	return priceFixed[c];
}

function getQtyFixed(cnum) {
	let c = parseInt(cnum);
	return qtyFixed[c];
}

function orderBookTab(c,node){
	$(".ob").css("display","none");
	$(".ob."+c).css("display","flex");
	$(".orderbook_btn").removeClass("click");
	$(node).addClass("click");
}

function coinImgChange(coinname) {
	$(".coinImg").css("display", "none");
	$(".coinImg.coin" + coinname).css("display", "flex");
}
function coinTypeChange(coinType) {
	coinNum = getCoinNum(coinType);
	APICoinChange();
	coinImgChange(getCoinType(coinNum));
	let coinname = coinType.slice(0, -4);
	$(".qtycoinm").html(coinname);
	$(".changecoin").removeClass("click");
	$(".coin_"+coinname).addClass("click");
	showChart(coinname);
	
	setOrderType("market");

	$(".positionOrderList").css('display', 'none');
	$("#orderLongList" + coinNum).css('display', 'block');
	$("#orderStopList" + coinNum).css('display', 'block');
	positionTabChange("position");
	$(".bigBox.olist").css("display", "block");   
	qtyReset();
	assetPercent(0);
}

function qtyReset() {
	$("#qty").val("0");
}

function updateSise() { // 시세와 함께 업데이트
	// 자동 호가 반영
	let fixnum = getSymbolFixed(coinNum);
	if(!isNaN(shortSise[coinNum])){
		$(".mainsise").html(toFixedDown(shortSise[coinNum], fixnum));
		if (orderType == 'market') { // 자동 호가 반영이면
			$("#dealSise").val(toFixedDown(shortSise[coinNum], fixnum));
		}
	}
	if(!isNaN(longSise[coinNum]))
		$("#longSise").html(toFixedDown(longSise[coinNum], fixnum)); // 시세
	// $("#shortSise").html(parseFloat(shortSise[coinNum]).toFixedDown(fixnum));
	
	
	let withdraWallet = parseFloat(toFixedDown(walletUSDT, 5));
	let withdraCoin = parseFloat(toFixedDown(coinBalance[coinNum], 5));
	//console.log("BEFORE withdraWallet:"+withdraWallet+" withdraCoin:"+withdraCoin);
	let totalUsdt = 0;
	let totalCoin = 0;
	for (var c = 0; c < useCoins.length; c++) {
		for (var i = 0; i < preOrder.length; i++) {
			if (preOrder[c][i] == undefined){
				continue;
			}
			if (preOrder[c][i][10] == "long"){
				totalUsdt -= preOrder[c][i][6]; //진입가격x수량
			}
			if(coinNum == c && preOrder[c][i][10] == "short"){
				totalCoin -= preOrder[c][i][5]; //수량
			}
		}
	}  
	totalUsdt = parseFloat(toFixedDown(totalUsdt, 5));
	totalCoin = parseFloat(toFixedDown(totalCoin, 5));
	withdraWallet = toFixedDown(withdraWallet+totalUsdt, 5);
	withdraCoin = toFixedDown(withdraCoin+totalCoin, 5);
	//console.log("AFTER withdraWallet:"+withdraWallet+" totalUsdt:"+totalUsdt);
	$(".usdtWallet").html(withdraWallet+" USDT");
	$("#wallet1").html(withdraWallet);
	$(".spotWallet").html(withdraCoin+" "+getCoinType(coinNum));
}

////////////////// 종목 가져오기 ///////////////
function getSymbolType(cnum) {
	let sym = getCoinType(cnum)+"USD";
	/*if (isInverse())
		sym = sym.substr(0, sym.length - 1);*/
	return sym;
}

function getCoinType(cnum) {
	cnum = Number(cnum);
	switch (cnum) {
	case 0: return "BTC";
	case 1: return "ETH";
	case 2: return "XRP";
	case 3: return "TRX";
	case 4: return "DOGE";
	case 5: return "LTC";
	case 6: return "SAND";
	case 7: return "ADA";
	case 8: return "GMT";
	case 9: return "APE";
	case 10: return "GALA";
	case 11: return "ROSE";
	case 12: return "KSM";
	case 13: return "DYDX";
	default:
		break;
	}
}


////////////////////////////////패킷 받음
function setOrder(obj) { // 웹소캣에서 주문 가져오기
	let coinNum = getCoinNum(obj.symbol);
	// 주문 저장 배열 값 (주문번호 , symbol, OrderType, 가격 , 체결 , 수량 , 매수/매도, 지불 USDT)
	let arr = [ obj.orderNum, obj.symbol, obj.orderType, 
			obj.entryPrice, obj.conclusionQuantity, obj.buyQuantity,
			obj.paidVolume, obj.orderTime, obj.triggerPrice, obj.entryPriceForStop, obj.position];
	if (obj.orderType == 'stopMarket') {
		arr[2] = "Stop Market";
		// arr[3] = obj.triggerPrice;
	}
	// 배열에 저장
	preOrder[coinNum][preOrder[coinNum].length] = arr;	
	//setLeverage(obj.symbol, obj.leverage);
	// 화면에 보여주기
	showOrder(arr, obj.position);
}
function showOrder(arr, position) {
	let orderNum = arr[0];
	let coinNum = getCoinNum(arr[1]);
	let txtId = '';
	let positionText = "";
	if (position == "long") {
		txtId = 'orderLongList';
		positionText = "BUY";
	} else if (position == "short") {
		txtId = 'orderLongList';
		positionText = "SELL";
	}
	
	let symbol = arr[1];
	let orderPrice = arr[3];
	let conclusionQuantity = arr[4];
	let buyQuantity = arr[5];
	let trigger = arr[8];
	let fixnum = getSymbolFixed(coinNum);//비트코인6자리	
	let orderValue = orderPrice * buyQuantity;
	orderValue = toFixedDown(orderValue, 5);
	
	let orderType = arr[2];

	switch (orderType) {
	case 'limit':
		orderType = "LIMIT";
		break;
	case 'market':
		orderType = "MARKET";
		break;
	case 'stopLimit':
		orderType = "STOP LIMIT";
		break;
	case 'Stop Market':
		orderType = "STOP MARKET";
		//typeText[1] = "GTC";
		txtId = 'orderStopList';
		break;
	}

	let orderTime = arr[7];	
	if (orderTime.indexOf('.0' == 0)) {
		orderTime = orderTime.split('.')[0];
	}
	let txt = "<div class='in_p_list_box "+orderNum+"'> <div class='in_p_list coin'>"+symbol+"</div> <div class='in_p_list'>"+orderType
	+"</div> <div class='in_p_list "+position+"'>"+positionText
	+"</div> <div class='in_p_list'>"+orderValue+" USDT</div> <div class='in_p_list'>"
	+orderPrice+" USDT</div> <div class='in_p_list'>"+buyQuantity+" BTC</div> <div class='in_p_list'>"+conclusionQuantity
	+" BTC</div> <div class='in_p_list'>"+buyQuantity+" BTC</div> <div class='in_p_list'>"+orderTime
	+"</div> <div class='in_p_list'>"+orderNum
	+"</div> <div class='in_p_list2'> <a onclick='cancel(\""
		+ orderNum + "\")' class='in_p_action w-button'>Cancel</a> </div> </div>"
		
	if(orderType == "STOP MARKET"){
		txt = "<div class='in_p_list_box "+orderNum+"'> <div class='in_p_list coin'>"+symbol+"</div> <div class='in_p_list'>"+orderType
		+"</div> <div class='in_p_list "+position+"'>"+positionText
		+"</div> <div class='in_p_list'>"+orderValue+" USDT</div> <div class='in_p_list'>"
		+"MARKET PRICE"+"</div> <div class='in_p_list'>"+buyQuantity+" BTC</div> <div class='in_p_list'>"+orderPrice
		+" USDT</div> <div class='in_p_list'>Untriggered</div> <div class='in_p_list'>"+orderTime
		+"</div> <div class='in_p_list'>"+orderNum
		+"</div> <div class='in_p_list2'> <a onclick='cancel(\""
			+ orderNum + "\")' class='in_p_action w-button'>Cancel</a> </div> </div>"
	}  
		/*<div class="in_p_list_box"> <div class="in_p_list coin">BTC/USDT</div> <div class="in_p_list">Market</div> 
		<div class="in_p_list long">BUY</div> <div class="in_p_list">0.0753221354 USDT</div> <div class="in_p_list">
		0.0753221354 BTC</div> <div class="in_p_list">0.0753221354 USDT</div> <div class="in_p_list">≤ 0.0001 USDT</div> <div class="in_p_list">Untriggered</div> <div class="in_p_list">2022-09-28 14:49:43</div> <div class="in_p_list">80899840</div> <div class="in_p_list2"> <a href="#" class="in_p_action w-button">Cancel</a> </div> </div>*/
	$("#" + txtId + coinNum).append(txt);	
	$("#dealpop").css("display", "none");
}
//////////////주문취소/////////////////
function cancel(orderNum) {
	let obj = new Object();
	obj.protocol = "spotOrderCancel";
	obj.userIdx = userIdx;
	obj.orderNum = orderNum;
	doSendToWeb(JSON.stringify(obj))
}

let removeOrderNum = [];
function removeOrder(obj) {
	let cnum = getCoinNum(obj.symbol);
	let orderNum = obj.orderNum;
	
	for(var i = 0; i < preOrder[cnum].length; i++) {
		if (preOrder[cnum][i][0] == orderNum) {
			preOrder[cnum].splice(i, 1);
			$("." + orderNum).remove();
			break;
		}
	}
	removeOrderNum.push(orderNum);
}
orderCheckStep();
function orderCheckStep() {
	if (removeOrderNum.length > 0) {
		for (var i = 0; i < preOrder[coinNum].length; i++) {
			if (preOrder[coinNum][i][0] == removeOrderNum[0]) {
				let tmp = preOrder[coinNum][i][0];
				deleteRemoveOrderNum(tmp);
				preOrder[coinNum].splice(i, 1);
				$("." + tmp).remove();
				// showPopup("주문이 실행되었습니다.", 1);
				break;
			}
		}
	}
	setTimeout("orderCheckStep()", 1000);
}

function deleteRemoveOrderNum(orderNum) {
	for (var i = 0; i < removeOrderNum.length; i++) {
		if (removeOrderNum[i] === orderNum) {
			removeOrderNum.splice(i, 1);
			return;
		}
	}
}
////////////////////////////////아래부터 현물용 소스
function setBuyOrSell(kind){
	buyOrSell = kind;
	$(".buybtn").removeClass("_1");
	$(".sellbtn").removeClass("_2");
	
	if(kind == "long"){
		$(".buybtn").addClass("_1");
		$(".finalBuyBtn").show();
		$(".finalSellBtn").hide();
	}else if(kind == "short"){
		$(".sellbtn").addClass("_2");
		$(".finalSellBtn").show();
		$(".finalBuyBtn").hide();
	}		
}

function setOrderType(type) { // 오더 타입 바꿀 때
	$(".orderTypeBtn").removeClass("click");
	$("." + type + "_btn").addClass("click");
	orderType = type;

	if (type == "market") {
		$(".ot.market").attr("readonly", true);
		$(".ot.market").css("background-color", "transparent");
		//buyTpslShow(true);
	} else {
		$(".ot.market").attr("readonly", false);
		//buyTpslShow(false);
	}

	if (type == "stopMarket") {
		$(".ot .ptxt").html(triggerText);
		triggerPrice[coinNum] = $("#dealSise").val();
	} else {
		$(".ot .ptxt").html(priceText);
	}
}

function openDealPop(kind) {
	if(Number($("#qty").val()) <= 0) return;
	
	buyOrSell = kind;
	$("#dealpop").css("display", "flex");
	let orderTypeTxt = "";
	if(orderType == "stopMarket"){
		orderTypeTxt = "STOPMARKET";
	}else if(orderType == "limit"){
		orderTypeTxt = "LIMIT";
	}else if(orderType == "market"){
		orderTypeTxt = "MARKET";
	}
	
	$("#popOrderType").html(orderTypeTxt+" ");
	
	// buy or sell
	$("#popBuySell").removeClass("long short");
	$("#popOrderType").removeClass("long short");
	if(buyOrSell == "long"){
		$("#popBuySell").html("Buy");
		$("#popBuySell").addClass("long");		
		$("#popOrderType").addClass("long");
		
		
	}else if(buyOrSell == "short"){
		$("#popBuySell").html("Sell");
		$("#popBuySell").addClass("short");		
		$("#popOrderType").addClass("short");
	}
	
	// market or limit/trigger
	if(orderType == "market"){
		$("#popOrderPrice").html("Market Price");
	}else{
		$("#popOrderPrice").html( $("#dealSise").val()+" USDT");
	}
	
	//popBTC
	$("#popBTC").html( $("#qty").val()+" "+getCoinType(coinNum));
	//popUSDT
	$("#popUSDT").html( $("#qtyUSDT").val()+" USDT");	
}

function closeDealPop() {
	$("#dealpop").css("display", "none");
}

function buy() {
	if ($("#qtyUSDT").val() == "0" || $("#qtyUSDT").val() == "") {
		showPopup(inputQtytext, 2);
		return false;
	}

	if(isNaN($("#dealSise").val()) || $("#dealSise").val() <= 0 ){
		showPopup(inputPricetext, 2);
		return false;
	}
	
	if (userIdx == null || userIdx == '') {
		showPopup(logintext, 3);
		return false;
	}
	
	let obj = new Object();
	obj.protocol = "spotBuyBtn";
	obj.userIdx = userIdx;
	obj.symbol = getSymbolType(coinNum);//코인종목 BTCUSD
	obj.orderType = orderType;// limit or market
	obj.position = buyOrSell;//long(buy) or short(sell)
	obj.entryPrice = parseFloat($("#dealSise").val());//지정가
	obj.buyQuantity = toFixedDown($("#qty").val(), 5);//수량(BTC)
	obj.triggerPrice = triggerPrice[coinNum];
	if(orderType=="stoplimit"){
		//obj.triggerPrice = 트리거 입력값 가져오기
	}
	console.log("주문 qty = "+obj.buyQuantity);
	doSendToWeb(JSON.stringify(obj));
	assetPercent(0);
}

function updateUsdt(obj) {	
	walletUSDT = obj.newBalance;
	$(".usdtWallet").html(walletUSDT+" USDT");
}
function updateBalance(obj) {
	coinBalance[obj.cnum] = obj.newBalance;
}


$("#dealSise").on("input", function() {
	var fix = getSymbolFixed(coinNum);
	fixKeyInput("dealSise",fix);
	if (orderType == "stopMarket") {
		triggerPrice[coinNum] = $("#dealSise").val();
		if (triggerPrice[coinNum] == '')
			triggerPrice[coinNum] = 0;
	}
});
function assetPercent(percent) { //자산 비율 선택
	if(longSise[coinNum] == 0 || longSise[coinNum] == undefined) return;
	
	let usdtValue = 0;
	let tmp = 0;
	if(buyOrSell == "long"){
		tmp = $("#usdtWallet").html().split(' ');		
		tmp = parseFloat(toFixedDown(tmp[0], 5));
		usdtValue = parseFloat(toFixedDown(tmp * percent, 5));
		$("#qtyUSDT").val(usdtValue);
		qtyKeyInputUSDT();
	}else if(buyOrSell == "short"){
		tmp = $("#spotWallet").html().split(' ');		
		tmp = parseFloat(toFixedDown(tmp[0], 5));
		usdtValue = parseFloat(toFixedDown(tmp * percent, 5));		
		$("#qty").val(usdtValue);
		qtyKeyInput();
	}
}
function qtyKeyInput() {//BTC입력 시 USDT치환
	if(longSise[coinNum] == 0 || longSise[coinNum] == undefined) return;
		
	var fix = 5;//getSymbolFixed(coinNum);
	fixKeyInput("qty",fix);
	
	let fixnum = getSymbolFixed(coinNum);
	let qty = $("#qty").val();
	let usdtQty = qty * $("#dealSise").val();	
	$("#qtyUSDT").val(toFixedDown(usdtQty, 5));
}

function qtyKeyInputUSDT() {//USDT입력 시 BTC치환
	if(longSise[coinNum] == 0 || longSise[coinNum] == undefined) return;
	let node = "qtyUSDT";
	var fix = 5;//getSymbolFixed(coinNum);	
	fixKeyInput(node,fix);	
	let fixnum = getSymbolFixed(coinNum);//비트코인6자리
	//console.log("fixNum:"+fixnum);
	let qtyUSDT = $("#qtyUSDT").val();
	let qtyBTC = qtyUSDT / $("#dealSise").val();	
	$("#qty").val(toFixedDown(qtyBTC, 5));
}

function fixKeyInput(node, fix) {
	let tmp = $("#"+node).val();
	let val = tmp.split(".");
	if (val[1] != null) {
		if(fix == 0)
			$("#"+node).val(val[0]);
		else
			$("#"+node).val(val[0] + "." + val[1].substring(0, fix));
	}
}
////////////포지션박스 탭전환///////////
function positionTabChange(tab) {
	$(".tabbtn").removeClass('click');
	$(".tabbtn." + tab).addClass('click');
	console.log("tab:"+tab);
	$(".bigBox.stopMarket").css("display", "none");
	$(".bigBox.olist").css("display", "none");
	$(".bigBox."+tab).css("display", "block");   
}

function cOrdersTabChange(tab) {
	$(".cOrdertap").removeClass('click');
	$(".cOrdertap." + tab).addClass('click');
	$(".cOrderblock").css("display",'none');
	$(".cOrderblock." + tab).css("display",'block');
}

function showChart(symbol) {
	let lan;
	if (lang == 'KO' || lang == 'EN' || lang == 'CH') {
		try {
			lan = '/'.concat(lang.toLowerCase(), '/');
		} catch (e) {
			alert(lan + ":" + e.toString());
			lan = '/en/';
		}
	} else {
		lan = '/en/';
	}
	let chartUrl = '<iframe src="https://'
			+ servername
			+ ':5927/sym/'
			+ symbol + '/'
			+ "USD"
			+ ''
			+ lan
			+ userIdx+"11"
			+ '" id="tradingview_af9f1" style="display:block; width:100%; height:100%; border:none;"/>';
	$("#futuresChart").html(chartUrl);
}

function mobileBlockChange(block){
	$(".select").removeClass("select");
	$("#mov"+block).addClass("select");
	
	if(block == "order"){
		$("#orderblock").css("display","flex");
		$(".chartblock").css("display","none");
		$("#transactionsBook").css("display","flex");
		
	}else{
		$("#orderblock").css("display","none");
		$(".chartblock").css("display","flex");
		$("#transactionsBook").css("display","none");
	}
}