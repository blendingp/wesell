$(function() {
	coinLoad();

	let windowWidth = $(window).width();
	let statpc = 1; // 모바일에선 초기값이 0 pc에선 초기값이 1
	if (windowWidth < 760) {
		statpc = 0; // 모바일
		mobileInit();
	}
});

function mobileInit(){
	console.log("mobileInit");
	$(".tradeblock2").css("display","none");
	$("#transactionsBook").css("display","none");
	mobileBlockChange("order");
}

function positionblockSort(){
	var tmpblock = [];
	var posblock = $("#position_block");
	for(var i = 0; i < positionList.length; i++){
		tmpblock.push($(".positionOrderList.positionsBottom"+i).wrap("<div/>").parent().html());
	}
	posblock.empty();
	for(var i = 0; i < positionList.length; i++){
		if(coinNum != i)
			posblock.append(tmpblock[i])
	}
	posblock.prepend(tmpblock[coinNum])
}

//마진 팝업 있을시에 사용
function marginPick(node){
	$(".marginSelect").removeClass("click");
	$(node).addClass("click");
}
function marginChangeBtn(){
	var type = $(".marginSelect.click").attr("type");
	setMarginType(type);
}
//
function marginSelect(iso) {
	$(".mtype").removeClass("click");
	$(".mtype" + iso).addClass("click");
	switch(iso){
	case "iso"	: $("#marginType").text(isotext); break;
	case "cross": $("#marginType").text(crosstext); break;
	}
}

function isEmpty(str){
    if(typeof str == "undefined" || str == null || str == "")
        return true;
    else
        return false ;
}

// /////////////////쿠키//////
function InitPageOnCookie() {
	InitLeverageCookie();
	InitMarginTypeCookie();
}

function InitLeverageCookie() {
	let cl = "";
	if (isInverse()) {
		cl = getCookie("iLeverageC");
	} else {
		cl = getCookie("leverageC");
	}
	if (isEmpty(cl)) {
		for (var i = 0; i < leverage.length; i++) {
			setLeverage(getSymbolType(i), leverage[i]);
		}
		return;
	}

	let clIdxArr = cl.split(",");
	for (var i = 0; i < clIdxArr.length; i++) {
		setLeverage(getSymbolType(i), clIdxArr[i]);
	}
	setMaxLeverage(coinNum);
}

function InitMarginTypeCookie() {
	let cm = getCookie("marginTypeC");
	if (isInverse())
		cm = getCookie("iMarginTypeC");
	
	if (isEmpty(cm)){
		setMarginType("");
		return;
	}
	let cmIdxArr = cm.split(",");
		
	setMarginType(cmIdxArr[coinNum]);
	marginType = cmIdxArr;
}

let checkGetLinePacket = false;
let checkGetLinePacektTime = 0;

function fixKeyInput(node, fix) {
	let val = $(node).val().split(".");
	if (val[1] != null) {
		if(fix == 0)
			$(node).val(val[0]);
		else
			$(node).val(val[0] + "." + val[1].substring(0, fix));
	}
}

function priceKeyInput(node) {
	var fix = getSymbolFixed(coinNum);
	fixKeyInput(node,fix)
}

function qtyKeyInput(node) {
	var fix = getQtyFixed(coinNum);
	fixKeyInput(node,fix)
}

function getQtyFixedNum(symbol){
	return getQtyFixed(getCoinNum(symbol));
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

function getProfit(position,sise,qty,volume){
	sise = Number(sise);
	qty = Number(qty);
	volume = Number(volume);
	
	let profit = 0;
	if(position == "long"){
		profit = (sise * qty) - volume;
	}else if(position == "short"){
		profit = volume - (sise * qty);
	}
	if(isInverse())profit=profit/sise;
	return profit;
}
function getProfitRate(profit,margin){
	profit = Number(profit);
	margin = Number(margin);
	let rate = profit / margin * 100;
	if(isNaN(rate))
		rate = 0;
	return rate;
}
function getLossRate(lossPrice,cnum){
	let fullLoss = Number(positionList[cnum][2]) - Number(positionList[cnum][4]);
	if(positionList[cnum][1] == "short")
		fullLoss = Number(positionList[cnum][4]) - Number(positionList[cnum][2]);
	
	let loss = Number(positionList[cnum][2]) - Number(lossPrice);
	if(positionList[cnum][1] == "short")
		loss = Number(lossPrice) - Number(positionList[cnum][2]);
	
	return loss / fullLoss;
}

function getProfitSise(cnum, type ,rate){
	if(positionList[cnum][1] == "short")
		rate = -Number(rate);

	if(type=="tp" || positionList[cnum][10] == "cross" ||(type=="sl" && Number(positionList[cnum][4]) == 0) ){
		let profit = Number(positionList[cnum][7])*(Number(rate)*0.01);
		if(positionList[cnum][10] == "cross" && type=="sl")
			profit = -profit;
		
		let profitVolume = Number(positionList[cnum][5])+profit;
		let profitSise = profitVolume / Number(positionList[cnum][3]);
		return profitSise;
	}
	else{
		let onePersent = Number(positionList[cnum][2]) - Number(positionList[cnum][4]);
		if(positionList[cnum][1] == "short")
			onePersent = Number(positionList[cnum][4]) - Number(positionList[cnum][2]);
		
		onePersent = onePersent*0.01;
		return Number(positionList[cnum][2]) - (onePersent * rate);
	}
}
// ////////////////시세변동////////////////
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
	changeAmount(); // 값 변동에 따른 양 변화

	// 지갑
	let futureWallet = toFixedDown(wallet, 5);// available withdraw
	let orderWallet = toFixedDown(wallet, 5);
	let withdraWallet = toFixedDown(wallet, 5);

	if (isInverse()) {
		futureWallet = toFixedDown(coinBalance[coinNum], 5);
		orderWallet = toFixedDown(coinBalance[coinNum], 5);
		withdraWallet = toFixedDown(coinBalance[coinNum], 5);
	}
	
	setVolumeText();
	
	if (userIdx == null || userIdx == '')
		return;

	let marginBalance = 0;
	let marginRisk = 0;
	// 코인 타입별 for문
	for (var i = 0; i < coinArr.length; i++) {
		if (isInverse() && i != coinNum) // 현물일때는 선택된 코인만 계산하게
			continue;

		// 증거금 합계
		// 포지션 예상수익 USDT 계산
		// 포지션 저장 배열 값 : 유저idx, 포지션(매수매도) , 진입가격 , 수량(사이즈) ,강제 청산 가격, 계약
		// USDT(수량x평균진입가격 시세), 7fee
		if (positionList[i][0] != null) {
			let position = positionList[i][1];
			let volume = parseFloat(positionList[i][5]);
			if(!isNaN(longSise[i]) && longSise[i] != 0){
				
//				if((position == "long" && positionList[i][2] < longSise[i]) || 
//						(position == "short" && positionList[i][2] > longSise[i]) || 
//						positionList[i][10] == "cross"){
					profit[i] = toFixedDown(getProfit(positionList[i][1], longSise[i], positionList[i][3], positionList[i][5]),5);  
					profitRate[i] = toFixedDown(getProfitRate(profit[i],positionList[i][7]),2);  
//				}else{
//					profitRate[i] = toFixedDown(-getLossRate(longSise[i],i),4);           
//					profit[i] = toFixedDown( Number(positionList[i][7])*profitRate[i],5); 
//					profitRate[i] = toFixedDown(Number(profitRate[i])*100,2);
//				}
			}
			// 주문가능한비용
			orderWallet = parseFloat(orderWallet) + parseFloat(profit[i]);

			// 주문가능한 잔고 : 지갑 - fee
			withdraWallet = withdraWallet - toFixedDown(parseFloat(positionList[i][7]),5);// 지갑에서
			// 뺸 것
			// 주문가능한 잔고 : 지갑+이윤
//			withdraWallet = parseFloat(withdraWallet); // +
			// parseFloat(profit[i]);
			marginBalance = toFixedDown((parseFloat(marginBalance)), 4);
			
			if(positionList[i][10] == "cross"){
				var margin = parseFloat(toFixedDown(parseFloat(positionList[i][7]),5));
				if(profit[i] < 0 && Math.abs(profit[i]) > margin){
					var overMargin = profit[i] + margin;
					withdraWallet += overMargin;
				}
			}
		}

		if (preOrder[i][0] != null) {
			for (var j = 0; j < preOrder[i].length; j++) {
				if (preOrder[i][j][12] != 1)
					withdraWallet = withdraWallet - parseFloat(preOrder[i][j][6]);// 지갑에서
			}
		}

		if (withdraWallet < 0)
			withdraWallet = 0;
	}
	if (marginBalance != 0) {
		marginRisk = toFixedDown((parseFloat(marginBalance)
				/ parseFloat(orderWallet) * 100), 2);
	}

	// wallet balance
	$("#wallet1").html(futureWallet);
	// $(".TopWallet").html(futureWallet);
	// 출금가능한 잔고
	$(".ableWithdrawWallet").html(toFixedDown(withdraWallet, 5));
	$("#margin").html(toFixedDown(getPositionMargin(), 5));
	$("#liqtxt").html(marginRisk);
	let total = totalUnrealizedUpdate();
	krwShow(futureWallet,withdraWallet,total);
}

function krwShow(futureWallet,withdraWallet,total){
	if(isKrwShow){
		$("#wallet1").parent().next().find(".krw").text(exchangeKrwInverse(futureWallet));
		$(".ableWithdrawWallet").parent().next().find(".krw").text(exchangeKrwInverse(withdraWallet));
		$("#margin").parent().next().find(".krw").text(exchangeKrwInverse(getPositionMargin()));
		$("#totalUnrealized").parent().next().find(".krw").text(exchangeKrwInverse(total));
	}
}

function getPositionMargin(){
	var marginTemp = 0;
	if(isInverse()){
		if(positionList[coinNum].length != 0)
			marginTemp += parseFloat(toFixedDown(positionList[coinNum][7],5));
		for(var i = 0; i < preOrder[coinNum].length; i++){
			if(preOrder[coinNum][i][12] != 1)
				marginTemp += preOrder[coinNum][i][6];
		}
	}else{
		for(var i = 0; i < positionList.length; i++){
			if(positionList[i].length != 0)
				marginTemp += parseFloat(toFixedDown(positionList[i][7],5));
		}
		for(var i = 0; i < preOrder.length; i++){
			for(var j = 0; j < preOrder[i].length; j++){
				if(preOrder[i][j][12] != 1)
					marginTemp += preOrder[i][j][6];
			}
		}
	}
	return marginTemp;
}

function totalUnrealizedUpdate() {
	let total = 0;

	if (isInverse()) {
		if(!isNaN(profit[coinNum]))
			total += Number(profit[coinNum]);
	} else {
		for (var i = 0; i < profit.length; i++) {
			if(!isNaN(profit[i]))
				total += Number(profit[i]);
		}
	}
	if (total > 0) {
		$(".totalUnrealized").css("color", profitcolor);
	} else if (total < 0) {
		$(".totalUnrealized").css("color", losscolor);
	} else {
		$(".totalUnrealized").css("color", "");
	}
	$(".totalUnrealized").html(toFixedDown(total, 5));
	return total;
}

// ///////////////공식///////////////////
function liquidationIso(entryPriceB, qunatity, isLongPositon) {
	// entryPriceB평균진입가격
	// qunatity수량
	if (qunatity <= 0)
		return 0;

	let
	symbol = coinNum; // 종목 BTC 0 or ETH 1
	let
	_leverage = leverage[coinNum];
	let
	volume = qunatity * entryPriceB;// 볼륨

	if (isLongPositon) {
		let
		tmprate = entryPriceB * (1 - 1 / _leverage + getMainMarginRate(volume));
		return tmprate;
	} else {
		let
		tmprate = entryPriceB * (1 + 1 / _leverage - getMainMarginRate(volume));
		return tmprate;
	}
}

function liquidationCross(entryPriceB, wallet, qunatity, isLongPositon) {
	// walletB사용 가능 잔고
	// entryPriceB평균진입가격
	// qunatity수량
	let volume = parseFloat(qunatity) * parseFloat(entryPriceB);// 볼륨

	if (isLongPositon)
		liqresult = parseFloat(entryPriceB)
				- (parseFloat(wallet) + volume
						* (1 / parseFloat(leverage[coinNum]) - parseFloat(getMainMarginRate(volume))))
				/ parseFloat(qunatity);
	else
		liqresult = parseFloat(entryPriceB)
				+ (parseFloat(wallet) + volume
						* (1 / parseFloat(leverage[coinNum]) - parseFloat(getMainMarginRate(volume))))
				/ parseFloat(qunatity);
	return liqresult;
}

function getMainMarginRate(volume) {
	let rate = 0.01;
	switch(marginRateType[coinNum]){
	case 1:
		if (volume <= 1000000) rate = 0.005;
		else if (volume <= 2000000) rate = 0.01;
		else if (volume <= 3000000) rate = 0.015;
		else if (volume <= 4000000) rate = 0.02;
		else if (volume <= 5000000) rate = 0.025;
		else if (volume <= 6000000) rate = 0.03;
		else if (volume <= 7000000) rate = 0.035;
		else if (volume <= 8000000) rate = 0.04;
		else if (volume <= 9000000) rate = 0.045;
		else rate = 0.05;
		break;
	case 2:
		if (volume <= 800000) rate = 0.0083;
		else if (volume <= 1600000) rate = 0.015;
		else if (volume <= 2400000) rate = 0.02;
		else if (volume <= 3200000) rate = 0.025;
		else if (volume <= 4000000) rate = 0.03;
		else if (volume <= 4800000) rate = 0.035;
		else if (volume <= 5600000) rate = 0.04;
		else if (volume <= 6400000) rate = 0.045;
		else if (volume <= 7200000) rate = 0.05;
		else rate = 0.055;
		break;
	case 3:
		if (volume <= 200000) rate = 0.0083;
		else if (volume <= 400000) rate = 0.015;
		else if (volume <= 600000) rate = 0.02;
		else if (volume <= 800000) rate = 0.025;
		else if (volume <= 1000000) rate = 0.03;
		else if (volume <= 1200000) rate = 0.035;
		else if (volume <= 1400000) rate = 0.04;
		else if (volume <= 1600000) rate = 0.045;
		else if (volume <= 1800000) rate = 0.05;
		else if (volume <= 2000000) rate = 0.055;
		else if (volume <= 2200000) rate = 0.06;
		else if (volume <= 2400000) rate = 0.065;
		else if (volume <= 2600000) rate = 0.07;
		else if (volume <= 2800000) rate = 0.075;
		else rate = 0.08;
		break;
	case 4:
		if (volume <= 200000) rate = 0.02;
		else if (volume <= 400000) rate = 0.025;
		else if (volume <= 600000) rate = 0.03;
		else if (volume <= 800000) rate = 0.035;
		else if (volume <= 1000000) rate = 0.04;
		else if (volume <= 1200000) rate = 0.045;
		else if (volume <= 1400000) rate = 0.05;
		else if (volume <= 1600000) rate = 0.055;
		else if (volume <= 1800000) rate = 0.06;
		else if (volume <= 2000000) rate = 0.065;
		else if (volume <= 2200000) rate = 0.07;
		else if (volume <= 2400000) rate = 0.075;
		else if (volume <= 2600000) rate = 0.08;
		else if (volume <= 2800000) rate = 0.085;
		else rate = 0.09;
		break;
	case 5:
		if (volume <= 25000) rate = 0.04; 
		else if (volume <= 50000) rate = 0.05;
		else if (volume <= 75000) rate = 0.06; 
		else if (volume <= 100000) rate = 0.07; 
		else if (volume <= 125000) rate = 0.08;
		else if (volume <= 150000) rate = 0.09;
		else if (volume <= 175000) rate = 0.1; 
		else if (volume <= 200000) rate = 0.11;
		else if (volume <= 225000) rate = 0.12;
		else if (volume <= 250000) rate = 0.13;
		else if (volume <= 275000) rate = 0.14;
		else if (volume <= 300000) rate = 0.15;
		else if (volume <= 325000) rate = 0.16;
		else if (volume <= 350000) rate = 0.17;
		else rate = 0.18;
		break;
	} 
	return rate/50;
}

function getFeeRate(oType) {
	if (oType == 'stopLimit')
		oType = 'limit';
	if (oType == 'stopMarket')
		oType = 'market';

	if (parentsIdx != '-1' && parentsIdx != 'null' ) {
		if (oType == "market") {
			return feeRate[0];
		} else if (oType == "limit") {
			return feeRate[2];
		}
	} else {
		if (oType == "market") {
			return feeRate[1];
		} else if (oType == "limit") {
			return feeRate[3];
		}
	}
	console.log("feeRate err!");
	return feeRate[1];
}

// 교차 강제청산 공식에서 쓰이는 개시증거금률
function getInitMarginRate(volume) {
	// volume
	// return parseFloat(100/leverage[coinNum]/100).toFixedDown(4);
	return 0.01;
}
// ///////////////초기화//////////////////
let nowTime = new Date();
let nowYear = nowTime.getFullYear();
let nowMonth = nowTime.getMonth();
let nowDate = nowTime.getDate();
let timerTime = null;
let tid = null;

function setTimer() {
	if (Number(nowTime.getHours()) < 1) { // 현재 시간이 만약 1 전이라면
		timerTime = new Date(nowYear, nowMonth, nowDate, 1, 0, 0);
	} else if (Number(nowTime.getHours()) < 9) { // 현재 시간이 만약 9 전이라면
		timerTime = new Date(nowYear, nowMonth, nowDate, 9, 0, 0);
	} else if (Number(nowTime.getHours()) < 17) { // 현재 시간이 만약 17 전이라면
		timerTime = new Date(nowYear, nowMonth, nowDate, 17, 0, 0);
	} else {
		timerTime = new Date(nowYear, nowMonth, nowDate + 1, 1, 0, 0);
	}
	timer();
}

function timer() {
	nowTime = new Date();
	let RemainDate = timerTime - nowTime;
	let hours = Math.floor((RemainDate % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	let miniutes = Math.floor((RemainDate % (1000 * 60 * 60)) / (1000 * 60));
	let seconds = Math.floor((RemainDate % (1000 * 60)) / 1000);
	// 남은 시간 text형태로 변경
	if (Number(miniutes) < 10) {
		miniutes = "0" + miniutes;
	}
	if (Number(seconds) < 10) {
		seconds = "0" + seconds;
	}
	let txt = "0" + hours + ":" + miniutes + ":" + seconds;
	$(".idtimer").html(txt); // 보여주기

	if (RemainDate < 0) {
		setTimer();
	} else {
		RemainDate = RemainDate - 1000; // 남은시간 -1초
		setTimeout(timer, 1000);
	}
}

function exchangeKrwInverse(val) {
	let krw = val * exRate;
	if(isInverse()){
		krw *= longSise[coinNum];
	}
	return krw.toFixed(0);
}

function estimatedKrw(val) {
	let krw = val * exRate;
	return krw.toFixed(0);
}

function initPage(){
	setTimer();
	poLoad();
	InitPageOnCookie();
	APICoinChange();
	init();
	initToWeb();
	initAPI();
	$("#orderLongList" + coinNum).css('display', 'block');
	$("#orderStopList" + coinNum).css('display', 'block');
	
	$(".minQty").text(getMinQty(coinNum));
	
	$(".hogablock").on("click", function() {
		if(orderType != "market"){
			$("#dealSise").val($(this).find(".hp").html());	
			if (orderType == "stopMarket") {
				triggerPrice[coinNum] = $("#dealSise").val();
			}
		}
	});

	$("#buyTpsl_cb").on("click", function() {
		var checked = $(this).is(":checked");
		if(checked)
			$("#buyTpsl_div").css("display","flex");
		else
			$("#buyTpsl_div").css("display","none");
	});

	$("#quantity").on("input", function() { // 주문 수량 입력 체크
		qtyKeyInput(this);
		quantity[coinNum] = parseFloat($("#quantity").val());
		if (quantity[coinNum] == '')
			quantity[coinNum] = 0;
		changeAmount();
	});
	
	$("#tpsl_tpInput, #tpsl_slInput").on("input", function() { // 주문 수량 입력 체크
		let classname = "tp";
		if(!$(this).hasClass("tp"))
			classname = "sl";
		$(".tpsl_btn."+classname).removeClass("click");
		
		let val = Number($(this).val());
		if(isNaN(val)) return;
		let cnum = Number($("#popTPSL").attr("cnum"))
		if(isNaN(cnum)) return;
		let $textblock = $("#tpsl_"+classname+"Text");
		if(val == 0){
			$textblock.css("display","none");
		}else{
			$textblock.css("display","flex");
			
			let text = [TPtext_1,TPtext_2,TPtext_3];
			if(classname == "sl"){
				text = [SLtext_1,SLtext_2,SLtext_3];
			}
			if(positionList[cnum][1] == "short"){
				text[1] = TPtext_2_s;
				if(classname == "sl"){
					text[1] = SLtext_2_s;
				}
			}

			let _profit = 0;
			let _profitRate = 0;
			if(classname == "tp" || positionList[cnum][10] == "cross"){
				_profit = toFixedDown(getProfit(positionList[cnum][1], val, positionList[cnum][3], positionList[cnum][5]),5);  
				_profitRate = toFixedDown(getProfitRate(_profit,positionList[cnum][7]),2);                                     
			}
			else if(classname == "sl"){
				_profitRate = toFixedDown(getLossRate(val,cnum),4);           
				_profit = toFixedDown( Number(positionList[cnum][7])*_profitRate,5); 
				_profitRate = toFixedDown(-Number(_profitRate)*100,2);
			}
			let coinname = getCoinTypeOrUSDT(cnum);

			$textblock.text(text[0]+" "+val+" "+text[1]+" "+_profit+" "+coinname+text[2]+" ROI: "+_profitRate+"%");
		}
	});

	$("#sattlePrice").on("input", function() { // 청산 입력
		var cnum = $("#popLM").attr("cnum");
		fixKeyInput(this,getSymbolFixed(cnum));
		sattleNotiText(cnum);
	});

	$("#sattleQty").on("input", function() { // 청산 입력
		var cnum = $("#popLM").attr("cnum");
		fixKeyInput(this,getQtyFixed(cnum));
		sattleNotiText(cnum);
	});

	$("#dealSise").on("input", function() {
		priceKeyInput(this);
		if (orderType == "stopMarket") {
			triggerPrice[coinNum] = $("#dealSise").val();
			if (triggerPrice[coinNum] == '')
				triggerPrice[coinNum] = 0;
		}
	});

	$(".changecoin").on("click", function() { // 코인 종류 변경
		if (loading)
			return;
		coinType = $(this).attr("ctype").split("_")[1];
		coinTypeChange(coinType);
	});

	$('#rangeValue').on('input',function() {
		let val = $(this).val();
		let persent = ($(this).val() / maxLeverage[coinNum]) * 100;
		let max = $(this).attr("max");
		$(this).css(
				'background',
				'linear-gradient(to right, '+barcolor[0]+' 0%, '+barcolor[0]+' '
						+ (persent) + '%, '+barcolor[1]+' '
						+ (persent) + '%, '+barcolor[1]+' 100%)');
		$(".rangeLev .quantitybar_circle").removeClass("on");
		for(var i = 25; i < persent.toFixed(0); i++){
			$(".rangeLev ._"+i).addClass("on");
		}
		$("#levInput").val(val);
	});
	
	$('#levInput').on('change',function() {
		let val = Number($(this).val());
		if(val > maxLeverage[coinNum]){
			val = maxLeverage[coinNum];
			$(this).val(val);
		}
		$("#rangeValue").val(val);
		$("#rangeValue").trigger("input");
	});

	$('#rangeQtyValue').on('input',function() {
		let val = $(this).val();
		let max = $(this).attr("max");
		let persent = (val / max) * 100;
		$(this).css(
				'background',
				'linear-gradient(to right, '+barcolor[0]+' 0%, '+barcolor[0]+' ' + persent
						+ '%, '+barcolor[1]+' ' + persent + '%, '+barcolor[1]+' 100%)');
		$(".rangeQty .quantitybar_circle").removeClass("on");
		let onePersent = 1 / max;
		for(var i = 0; i < val; i++){
			var per = i*onePersent * 100;
			$(".rangeQty ._"+per).addClass("on");
		}
		howQtyPersentUpdate(val);
	});
	
	$('#rangeQtyValue').on('mousedown touchstart',function() {
		$("#howQtyPersent").css("display","flex");
	});
	$('#rangeQtyValue').on('mouseup touchend',function() {
		$("#howQtyPersent").css("display","none");
	});
	showChart(getCoinType(coinNum));
	positionblockSort();
}

function howQtyPersentUpdate(persent){
	let pst = Number(persent);
	$("#howQtyPersent").css("left",pst+"%");
	$("#howQtyPersentBlock").css("left",-15-(pst/5));
	$("#howQtyPersentBlock").text(pst+"%");
	
}

function sendMySelection(tcoin) {
	let obj = {
		protocol : 'changeCoin',
		coin : tcoin
	};
	doSend(JSON.stringify(obj));
}

function orderBookTab(c,node){
	$(".ob").css("display","none");
	$(".ob."+c).css("display","flex");
	$(".orderbook_btn").removeClass("click");
	$(node).addClass("click");
}

function coinTypeChange(coinType) {
	coinNum = getCoinNum(coinType);
	APICoinChange();
	coinImgChange(getCoinType(coinNum));
//	$(".titlename").html(getCoinTextFull(coinNum));
	let coinname = coinType.slice(0, -4);
	$(".qtycoinm").html(coinname);
	$(".changecoin").removeClass("click");
	$(".coin_"+coinname).addClass("click");
	showChart(coinname);
	
	sendMySelection(coinType.trim());

	setMaxLeverage(coinNum);
	setOrderType("market");

	$(".positionOrderList").css('display', 'none');
	$("#orderLongList" + coinNum).css('display', 'block');
	$("#orderStopList" + coinNum).css('display', 'block');
	positionTabChange("position");
	$(".idleverage").html(leverage[coinNum]);
	$("#leverage").html(leverage[coinNum]);
	$(".minQty").text(getMinQty(coinNum));

	qtyReset();
	marginViewReset();
	positionSetting();
	setMarginType(marginType[coinNum]);
	marginSelect(marginType[coinNum]);
	assetPercent(0);
	changeLeverageHtml(leverage[coinNum]);
	positionblockSort();
}

function setVolumeText(){
	let maxQty = getMaxQty();
	$(".maxVolume").text(maxContractVolume[coinNum]+" ("+maxQty);
}

function getMaxQty(){
	let dealSise = Number($("#dealSise").val());
	let maxQty = 0;
	if(dealSise != 0)
		maxQty = toFixedDown(maxContractVolume[coinNum] / dealSise,qtyFixed[coinNum]);
	return maxQty;
}

function getMinQty(cnum){
	var fix = qtyFixed[cnum];
	var qty = 1;
	for(var i = 0; i < fix; i++){
		qty *= 0.1;
	}
	return qty.toFixed(fix);
}

function coinImgChange(coinname) {
	$(".coinImg").css("display", "none");
	$(".coinImg.coin" + coinname).css("display", "flex");
}

function qtyReset() {
	$("#quantity").val("0");
	quantity[coinNum] = 0;
}

function marginViewReset() {
	$(".mtype").removeClass("click");
	$(".mtype." + marginType[coinNum]).addClass("click");
}

function positionSetting() {
	if (!isInverse()) {
		for (var i = 0; i < coinArr.length; i++) {
			if (i == coinNum) {
				$(".positionsBottom" + i).css('display', 'none');
			} else if (positionList[i].length == 0) {
				$(".positionsBottom" + i).css('display', 'none');
			} else {
				hiddenHtmlView(i);
			}
		}
	}

	if (buyKind[coinNum] == 'long' || buyKind[coinNum] == 'short') {
		positionHtmlView(coinNum);
	} else {
		positionHtmlInit(coinNum);
	}
}

function setMaxLeverage(_coinNum) {
	$(".maxLeverage").html(maxLeverage[_coinNum]);
	$("#rangeValue").attr("max", maxLeverage[_coinNum]);
	$("#movLeverRange").attr("max", maxLeverage[_coinNum]);
	$(".levTextbox .ordertxt").removeClass("right");

	switch (_coinNum) {
	case 0:
		$(".leverageBtn100").css("display", "flex");
		$(".leverageBtn75").css("display", "flex");
		$(".leverageBtn50").css("display", "flex");
		$(".leverageBtn25").css("display", "flex");
		break;
	case 1:
		$(".leverageBtn100").css("display", "none");
		$(".leverageBtn75").css("display", "none");
		$(".leverageBtn50").css("display", "flex");
		$(".leverageBtn25").css("display", "flex");
		break;
	case 2:
		$(".leverageBtn100").css("display", "none");
		$(".leverageBtn75").css("display", "none");
		$(".leverageBtn50").css("display", "flex");
		$(".leverageBtn25").css("display", "flex");
		break;
	case 3:
		$(".leverageBtn100").css("display", "none");
		$(".leverageBtn75").css("display", "none");
		$(".leverageBtn50").css("display", "flex");
		$(".leverageBtn25").css("display", "flex");
		break;
	case 4:
		$(".leverageBtn100").css("display", "none");
		$(".leverageBtn75").css("display", "none");
		$(".leverageBtn50").css("display", "none");
		$(".leverageBtn25").css("display", "flex");
		break;
	}
}

function levBtnClick(val){
	$("#levInput").val(val);
	$("#levInput").trigger("input");
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
			+ "USDT"
			+ ''
			+ lan
			+ userIdx
			+ '" id="tradingview_af9f1" style="display:block; width:100%; height:100%; border:none;"/>';
	$("#futuresChart").html(chartUrl);
}

function mobileBlockChange(block){
	$(".select").removeClass("select");
	$("#mov"+block).addClass("select");
	
	if(block == "order"){
		$(".tradeblock2").css("display","flex");
		$(".chartblock").css("display","none");
		$("#transactionsBook").css("display","flex");
		
	}else{
		$(".tradeblock2").css("display","none");
		$(".chartblock").css("display","flex");
		$("#transactionsBook").css("display","none");
	}
}

// ///////////////상단탭//////////////////
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

function setMarginType(type) { // 교차 격리 바꿀 때
	if (type == "")
		type = "iso";
	
	if (positionList[coinNum].length == 0 && preOrder[coinNum].length == 0) {		
		marginType[coinNum] = type;

		if (isInverse())
			setCookieMobile("iMarginTypeC", marginType, 30);
		else
			setCookieMobile("marginTypeC", marginType, 30);
		
		marginSelect(type);
		popDisplay("modepop","none");
	} else if(type != marginType[coinNum]) {
		showPopup(marginchangeXtext, 2);
	}else{
		popDisplay("modepop","none");
	}
}

function setMarginTypeCNum(type, _coinNum) { // 교차 격리 바꿀 때
	if (type == "")
		type = "iso";
	
	marginType[_coinNum] = type;

	if (isInverse())
		setCookieMobile("iMarginTypeC", marginType, 30);
	else
		setCookieMobile("marginTypeC", marginType, 30);
	
	if(coinNum == _coinNum)
		marginSelect(type);
}

function orderAllCancel() {
	if (preOrder[coinNum][0] == null) {
		showPopup(nothingOrdertext, 2);
	} else {
		preOrder[coinNum] = new Array();
		$("#orderLongList" + coinNum).empty();
		$("#orderStopList" + coinNum).empty();
		showPopup(allCanceltext, 1);
		let
		obj = new Object();
		obj.protocol = "orderAllCancel";
		obj.userIdx = userIdx;
		obj.symbol = getSymbolType(coinNum);
		doSendToWeb(JSON.stringify(obj));
		showPopup(orderCanceltext, 1);
	}
}

function orderCancelResponse(symbol) {
	let cnum = getCoinNum(symbol)
	preOrder[cnum] = new Array();
	$("#orderLongList" + cnum).empty();
	$("#orderStopList" + cnum).empty();
}

// /////////////// 자산 비율 선택 ///////////////////
function assetPercent(percent) {
	assetpersent = percent * 0.98;
	assetPercentQty();

	$("#rangeQtyValue").val(percent * 100);
	$("#rangeQtyValue").trigger("input");
}

// ////////QTY 구하는 공식 (바꾼버전)
function assetPercentQty() {

	let sise = $("#dealSise").val();

	let wallet = $("#ableWithdrawWallet").html();
	if (reBuyWallet != 0) {
		if (reBuyWallet > wallet)
			reBuyWallet = wallet;
		wallet = reBuyWallet;
		reBuyWallet = 0;
	}

	if (isInverse()) {
		wallet = wallet * longSise[coinNum];
	}

	let qty = 0;

	let max = maxContractVolume[coinNum];
	let lever = leverage[coinNum];

	qty = getQtyMargin(sise, wallet, 1, lever);
	let maxQty = getMaxQty();
	
	if(qty > maxQty){
		let prevPosQty = 0;
		if(positionList[coinNum].length != 0) prevPosQty = positionList[coinNum][3];
		qty = ((maxQty-prevPosQty) * assetpersent) * 0.98;
		if(qty < 0) qty = 0;
	}else{
		qty = getQtyMargin(sise, wallet, assetpersent, lever);
	}
	$("#quantity").val(toFixedDown(qty, 4));
	$("#quantity").trigger('input');
}

function getQtyMargin(sise, wallet, persent, leverage) {
	let calWallet = (wallet * persent);
	let price = calWallet * leverage;
	let qty = price / sise;

	qty = toFixedDown(qty, 4);

	let resultFee = getLongFee(sise, qty, leverage);
	let minus = qtyWhileMinus(coinNum, leverage, qty);

	let ct = 0;
	while (resultFee > calWallet) {
		qty -= minus;
		resultFee = getLongFee(sise, qty, leverage);
		ct++;
	}

	if (qty < 0) {
		qty = 0;
	}

	return qty;
}

function qtyWhileMinus(_coinNum, lever, qty) {
	let minus = 1;
	minus = (qty * 0.0001) * (0.01 + (1 - (1 / lever)));
	if (minus < 0.0001)
		minus = 0.0001;
	return minus;
}

function getLongFee(price, qty, lever) {
	let volume = price * qty;
	let init = parseFloat(volume) / parseFloat(lever); // 개시증거금
	let fee2 = volume * (1 - (1 / parseFloat(leverage[coinNum])))
			* getFeeRate('market'); // 파산가격수수료
	let fee = init + volume * getFeeRate(orderType); // 거래수수료
	fee = fee + fee2;
	return fee;
}

function getQtyVolume(sise, wallet, persent, leverage) {
	let money = wallet;
	let price = (money * persent) * leverage;
	let qty = price / sise;
	return qty;
}

function maxLengthCheck(object) {
	if (object.value.length > object.maxLength) {
		object.value = object.value.slice(0, object.maxLength);
	}
}

function copyCheck(){
	if(isEmpty(userIdx))
		return false;
	if(positionObj.clist.length != 0){
		for(var i = 0; i < positionObj.clist.length; i++){
			if(getCoinNum(positionObj.clist[i].symbol) == coinNum)
				return true;
		}
	}
	return false;
}

// ///////////////배당 변경//////////////////
function changeLeverage(num) { // 배당 변경
	if(isNaN(num)){
		showPopup(wrongtext,2);
		return;
	}
	if(copyCheck()){
		showPopup(copyLevFailtext,2);
		return;
	}
	
	num = parseInt(num);
	if (num < 1)
		num = 1;
	// 격리면서 거래중이면 더 낮게는 못하게
	if (!userIdx) {
		showPopup(logintext, 3);
	} else if (positionList[coinNum][0] != null && marginType[coinNum] == "iso"
			&& Number(num) < leverage[coinNum]) {
		showPopup(isochangeXtext, 2);
	} else if (maxLeverage[coinNum] < num) {
		showPopup(levChangeFailtext, 2);
	} else if (num == leverage[coinNum]) {
		popDisplay("leveragePopup","none");
		return;
	} else if (positionList[coinNum][0] != null || preOrder[coinNum][0] != null) {
		if(positionList[coinNum].length != 0 && !confirm(leverchangeConfirmText)){
			return;
		}
		tmpnum = num;
		let obj = new Object();
		obj.protocol = "changeLeverage";
		obj.userIdx = userIdx;
		obj.symbol = getSymbolType(coinNum);
		obj.leverage = num;
		obj.prevLeverage = leverage[coinNum];
		doSendToWeb(JSON.stringify(obj));
		popDisplay("leveragePopup","none");
	} else {
		setLeverage(getSymbolType(coinNum), num);
		popDisplay("leveragePopup","none");
		assetPercentQty();
	}
}

function SetNum(obj) {
	val = obj.value;
	if (val.length == 1)
		return;
	re = /[^0-9]/gi;
	let temp = val.substr(1, val.length - 1).replace(re, "");
	obj.value = val.charAt(0) + temp;
}

function changeLeverageHtml(num) { // 배당 변경
	$(".popupLeverage").val(num);
	$("#rangeValue").val(num);
	$("#rangeValue").trigger("input");
}

function changeLeverageInput(num) { // 배당 변경
	$(".popupLeverage").val(num);
	if (num == "")
		num = 1;
	$("#rangeValue").val(num);
	$("#rangeValue").trigger("input");
	
}

function setMaxContractVolume(cnum, lever){
	switch(marginRateType[cnum]){
	case 1:
		if(lever <= 18.18) 		maxContractVolume[cnum] = 10000000;
		else if(lever<= 20) 	maxContractVolume[cnum] = 9000000;
		else if(lever<= 22.22) 	maxContractVolume[cnum] = 8000000;
		else if(lever<= 25) 	maxContractVolume[cnum] = 7000000;
		else if(lever<= 28.57) 	maxContractVolume[cnum] = 6000000;
		else if(lever<= 33.33) 	maxContractVolume[cnum] = 5000000;
		else if(lever<= 40) 	maxContractVolume[cnum] = 4000000;
		else if(lever<= 50) 	maxContractVolume[cnum] = 3000000;
		else if(lever<= 66.67) 	maxContractVolume[cnum] = 2000000;
		else if(lever<= 100) 	maxContractVolume[cnum] = 1000000;
		break;
	case 2:
		if(lever <= 9.09) 		maxContractVolume[cnum] = 8000000;
		else if(lever<= 10) 	maxContractVolume[cnum] = 7200000;
		else if(lever<= 11.11) 	maxContractVolume[cnum] = 6400000;
		else if(lever<= 12.50) 	maxContractVolume[cnum] = 5600000;
		else if(lever<= 14.29) 	maxContractVolume[cnum] = 4800000;
		else if(lever<= 16.67) 	maxContractVolume[cnum] = 4000000;
		else if(lever<= 20) 	maxContractVolume[cnum] = 3200000;
		else if(lever<= 25) 	maxContractVolume[cnum] = 2400000;
		else if(lever<= 33.33) 	maxContractVolume[cnum] = 1600000;
		else if(lever<= 50) 	maxContractVolume[cnum] = 800000;
		break;
	case 3:
		if(lever <= 6.25) 		maxContractVolume[cnum] = 3000000;
		else if(lever<= 6.67) 	maxContractVolume[cnum] = 2800000;
		else if(lever<= 7.14) 	maxContractVolume[cnum] = 2600000;
		else if(lever<= 7.69) 	maxContractVolume[cnum] = 2400000;
		else if(lever<= 8.33) 	maxContractVolume[cnum] = 2200000;
		else if(lever<= 9.09) 	maxContractVolume[cnum] = 2000000;
		else if(lever<= 10.00) 	maxContractVolume[cnum] = 1800000;
		else if(lever<= 11.11) 	maxContractVolume[cnum] = 1600000;
		else if(lever<= 12.50) 	maxContractVolume[cnum] = 1400000;
		else if(lever<= 14.29) 	maxContractVolume[cnum] = 1200000;
		else if(lever<= 16.67) 	maxContractVolume[cnum] = 1000000;
		else if(lever<= 20) 	maxContractVolume[cnum] = 800000;
		else if(lever<= 25) 	maxContractVolume[cnum] = 600000;
		else if(lever<= 33.33) 	maxContractVolume[cnum] = 400000;
		else if(lever<= 50) 	maxContractVolume[cnum] = 200000;
		break;
	case 4:
		if(lever <= 5.56) 		maxContractVolume[cnum] = 3000000;
		else if(lever<= 5.88) 	maxContractVolume[cnum] = 2800000;
		else if(lever<= 6.25) 	maxContractVolume[cnum] = 2600000;
		else if(lever<= 6.67) 	maxContractVolume[cnum] = 2400000;
		else if(lever<= 7.14) 	maxContractVolume[cnum] = 2200000;
		else if(lever<= 7.69) 	maxContractVolume[cnum] = 2000000;
		else if(lever<= 8.33) 	maxContractVolume[cnum] = 1800000;
		else if(lever<= 9.09) 	maxContractVolume[cnum] = 1600000;
		else if(lever<= 10.00) 	maxContractVolume[cnum] = 1400000;
		else if(lever<= 11.11) 	maxContractVolume[cnum] = 1200000;
		else if(lever<= 12.50) 	maxContractVolume[cnum] = 1000000;
		else if(lever<= 14.29) 	maxContractVolume[cnum] = 800000;
		else if(lever<= 16.67) 	maxContractVolume[cnum] = 600000;
		else if(lever<= 20) 	maxContractVolume[cnum] = 400000;
		else if(lever<= 25) 	maxContractVolume[cnum] = 200000;
		break;
	case 5:
		if(lever <= 2.78) 		maxContractVolume[cnum] = 375000;
		else if(lever<= 2.94) 	maxContractVolume[cnum] = 350000;
		else if(lever<= 3.13) 	maxContractVolume[cnum] = 325000;
		else if(lever<= 3.33) 	maxContractVolume[cnum] = 300000;
		else if(lever<= 4.17) 	maxContractVolume[cnum] = 225000;
		else if(lever<= 5.00) 	maxContractVolume[cnum] = 175000;
		else if(lever<= 6.25) 	maxContractVolume[cnum] = 125000;
		else if(lever<= 7.14) 	maxContractVolume[cnum] = 100000;
		else if(lever<= 8.33) 	maxContractVolume[cnum] = 75000;
		else if(lever<= 10) 	maxContractVolume[cnum] = 50000;
		else if(lever<= 12) 	maxContractVolume[cnum] = 25000;
		break;
	}
}

function setLeverage(symbol, _leverage) {
	if(isNaN(_leverage)){
		showPopup(wrongtext,2);
		return;
	}
	_leverage = parseInt(_leverage);
	let _coinNum = getCoinNum(symbol);
	if (_leverage == "") {
		_leverage = _coinNum;
	}
	leverage[_coinNum] = Number(_leverage);
	if (coinNum == _coinNum) {
		$("#leverage").html(leverage[_coinNum]);
		changeLeverageInput(leverage[_coinNum]);
		setTimeout('changeLeverageInput(' + leverage[_coinNum] + ')', 10);
	}

	if (isInverse()) {
		setCookieMobile("iLeverageC", leverage, 30);
	} else {
		setCookieMobile("leverageC", leverage, 30);
	}
	setMaxContractVolume(_coinNum,_leverage);
	
 	if (Number(coinNum) == Number(_coinNum)){
		$("#rangeValue").trigger("input");
	}
}
function removePosition(obj) { // 웹소캣에서 포지션 가져오기
	if(!isShow(obj.symbol)) return;
	
	let coinNum = getCoinNum(obj.symbol);
	if (obj.leverChange) {
		reBuyWallet = positionList[coinNum][7];
	}
	positionList[coinNum] = new Array();
	// 배당
	buyKind[coinNum] = null;
	positionHtmlInit(coinNum);
	profit[coinNum] = 0;
	updateSise();
}

function getCloseOrderPosition(position) {
	if (position == "long")
		return closeText + "/" + ls_sText;
	return closeText + "/" + ls_lText;
}

function setOrder(obj) { // 웹소캣에서 주문 가져오기
	if(!isShow(obj.symbol)) return;
	
	if ($("." + obj.orderNum).length != 0)
		return;

	let coinNum = getCoinNum(obj.symbol);
	// 주문 저장 배열 값 (주문번호 , 유형 , 가격 , 체결 , 수량 , 매수/매도, 지불 USDT)
	let arr = [ obj.orderNum, obj.symbol, obj.orderType + " - " + obj.strategy,
			obj.entryPrice, obj.conclusionQuantity, obj.buyQuantity,
			obj.paidVolume, obj.mainMargin, obj.orderTime, obj.triggerPrice,
			obj.orderType, obj.entryPriceForStop, obj.isLiq ];
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
	// 주문 저장 배열 값 (주문번호 , 심볼, 유형 , 가격 , 체결 , 수량 , 매수/매도, 지불 USDT, 오더타임)
	let orderNum = arr[0];
	let coinNum = getCoinNum(arr[1]);
	let txt = "";
	let txtId = '';
	let positionText = "";
	if (position == "long") {
		txtId = 'orderLongList';
		positionText = longtext;
	} else if (position == "short") {
		txtId = 'orderLongList';
		positionText = shorttext;
	}

	let marginText = arr[6];
	if (arr[12] == 1) {
		positionText = getCloseOrderPosition(position);
		marginText = "-";
	}

	let symbol = arr[1];
	let orderPrice = arr[3];
	let filledtotal = arr[4] + "/" + arr[5];
	let orderType = arr[2];

	let typeText = orderType.split(" - ");
	switch (typeText[0]) {
	case 'limit':
		typeText[0] = limittext;
		break;
	case 'market':
		typeText[0] = markettext;
		break;
	case 'stopLimit':
		typeText[0] = stoptext + limittext;
		break;
	case 'Stop Market':
		typeText[0] = stoptext + markettext;
		typeText[1] = "GTC";
		txtId = 'orderStopList';
		break;
	}

	let orderTime = arr[8];
	let trigger = arr[9];
	let triggerResult;
	if (arr[9] <= arr[11]) {
		triggerResult = "<=" + trigger;
	} else {
		triggerResult = ">=" + trigger;
	}

	if (orderTime.indexOf('.0' == 0)) {
		orderTime = orderTime.split('.')[0];
	}
	if (arr[10] != "stopLimit")
		triggerResult = "-";

	appendOrder(orderNum,symbol,position,positionText,filledtotal,marginText,orderPrice,orderTime,txtId);
}

// ////////////주문취소/////////////////
function cancel(orderNum) {
	let obj = new Object();
	obj.protocol = "orderCancel";
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

function showLeveragePopup() { // 배당 변경
	$("#rangeValue").val(leverage[coinNum]);
	$("#rangeValue").trigger("input");
	popDisplay("leveragePopup","flex");
}

function comingSoon() {
	showPopup(commingSoontext, 3);
}

// //////////////// 종목 가져오기 ///////////////
function getSymbolType(cnum) {
	let sym = getCoinType(cnum)+"USDT";
	if (isInverse())
		sym = sym.substr(0, sym.length - 1);
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

function getCoinTypeOrUSDT(cnum) {
	if(!isInverse())return "USDT";
	
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

function validation(kind, coinNum) {
	let walletVal = $("#ableWithdrawWallet").html();

	if ($("#quantity").val() == "0" || $("#quantity").val() == "") {
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

	if (Number(quantity[coinNum]) <= 0) {
		showPopup(inputQtytext, 2);
		return false;
	}
	if (longSize > maxContractVolume[coinNum]) { // 
		let prevqty = 0;
		if(positionList[coinNum].length != 0) prevqty = positionList[coinNum][3];
		let maxQty = toFixedDown(getMaxQty() - prevqty,qtyFixed[coinNum]);
		showPopup(maxSizetext+" ("+avaqtyText+" : "+maxQty+" "+getCoinType(coinNum)+")", 2);
		return false;
	}
	if (positionList[coinNum].length == 0) { // 포지션이 없는 경우
		if (kind == 'long') {
			if (walletVal < longFee) {
				showPopup(nonPointtext, 2);
				return false;
			}
		} else if (kind == 'short') {
			if (walletVal < shortFee) {
				showPopup(nonPointtext, 2);
				return false;
			}
		}
	} else if (positionList[coinNum][1] == kind) { // 같은 포지션을 사는 경우
		if (kind == 'long') {
			if (walletVal < longFee) {
				showPopup(nonPointtext, 2);
				return false;
			}
		} else if (kind == 'short') {
			if (walletVal < shortFee) {
				showPopup(nonPointtext, 2);
				return false;
			}
		}
	}
	return true;
}

// /////////////// 탭선택 ///////////////////
function setOrderType(type) { // 오더 타입 바꿀 때
	$(".orderbtn").removeClass("click");
	$("." + type + "_btn").addClass("click");
	orderType = type;

	if (type == "market") {
		$(".ot.market").attr("readonly", true);
		$(".ot.market").css("background-color", "transparent");
		buyTpslShow(true);
	} else {
		$(".ot.market").attr("readonly", false);
		buyTpslShow(false);
	}

	if (type == "stopMarket") {
		$(".ot .ptxt").html(triggerText);
		triggerPrice[coinNum] = $("#dealSise").val();
	} else {
		$(".ot .ptxt").html(priceText);
	}
}

// 주문수량 변경//////
function changeAmount() { // 수량 변경 시 같이 업데이트 해줘야 할 부분
	let entryPriceLong = parseFloat($("#dealSise").val());
	// let entryPriceShort = parseFloat(shortSise[coinNum]);

	if (entryPriceLong == "" || entryPriceLong == 0) {
		longSize = 0;
		longFee = 0;
		shortFee = 0;
		$(".idlongFee").html("0");
		return;
	}
	longSize = entryPriceLong * parseFloat(quantity[coinNum]);
	// shortSize = entryPriceShort * parseFloat(quantity[coinNum]);
	// $(".idlongSize").html(toFixedDown(longSize, 2));
	// $(".idshortSize").html(toFixedDown(shortSize, 2));
	// 비용 : 수량 * 시세 / 배당

	// ===================

	let walletB = parseFloat($("#orderWallet").html());// 총잔고 wallet balance
	let qunatity = parseFloat(quantity[coinNum]);

	let fixnum = getSymbolFixed(coinNum);

	// 개시증거금
	let longinit = parseFloat(longSize) / parseFloat(leverage[coinNum]);
	let shortinit = parseFloat(shortSize) / parseFloat(leverage[coinNum]);
	// 진입수수료 longSize * getFeeRate(orderType)
	longFee = longinit + longSize * getFeeRate(orderType);
	shortFee = shortinit + shortSize * getFeeRate(orderType);
	let fee2 = longSize * (1 - (1 / parseFloat(leverage[coinNum])))
			* getFeeRate('market');
	// 강제청산 수수료(시장가)
	longFee = longFee + fee2;
	shortFee = shortFee + fee2;

	if (isInverse()) {
		longFee = longFee / longSise[coinNum];
		shortFee = shortFee / shortSise[coinNum];
	}
	$(".idlongFee").html(toFixedDown(longFee, 5));
	if(isNaN($(".idlongFee").text())) $(".idlongFee").text("0");
	// $(".idshortFee").html((shortFee).toFixedDown(getQtyFixed(coinNum)));
}

// //////////포지션박스 탭전환///////////
function positionTabChange(tab) {
	$(".tabbtn").removeClass('click');
	$(".tabbtn." + tab).addClass('click');
	let posbox = $("#tabbox_pos");
	posbox.children(".position").css("display", "none");
	posbox.children(".olist").css("display", "none");
	posbox.children(".stopMarket").css("display", "none");
	posbox.children("." + tab).css("display", "flex");
}

function getCoinTextInverse(coinNum) {
	if (!isInverse())
		return "USDT";
	return getCoinType(coinNum);
}

function popDisplay(name, value) {
	$(".popup").css("display", value);
	$(".tradepop").css("display", value);
	$("." + name).css("display", value);
}

function popMovLeverage(value) {
	$(".popup").css("display", value);
	$(".mob_pop_leverage").css("display", value);
	
	if(value == 'flex'){
		movLeverRangeSet(leverage[coinNum]);
	}
}

function movLeverRangeSet(lever){
	
	var rangeVal = parseFloat((lever / maxLeverage[coinNum])*100).toFixed(0);
	$("#movLeverRange").val(lever);
	$("#mobLevInput").val(lever);
	$("#movLeverRange").css(
			'background',
			'linear-gradient(to right, '+barcolor[0]+' 0%, '+barcolor[0]+' ' + rangeVal
					+ '%, '+barcolor[1]+' ' + rangeVal + '%, '+barcolor[1]+' 100%)');
}
// //////////////결제팝업//////////////
function popType(kind, hide) {
	if (validation(kind, coinNum)) {

		let coinText = getCoinType(coinNum);
		let inverseCoinText = getCoinTextInverse(coinNum);
		let symbolText = getSymbolType(coinNum);

		orderKind = kind;
		if (hide == undefined)
			hide = false;
		if (hide == false) {
			popDisplay("pop_trade", "flex");
		}
		$(".tpop_symbol").html(symbolText);

		if (orderKind == 'long') {
			$(".tpop_position").removeClass("short");
			$(".tpop_position").addClass("long");
			$(".tpop_position").html(longtext);
		} else {
			$(".tpop_position").removeClass("long");
			$(".tpop_position").addClass("short");
			$(".tpop_position").html(shorttext);
		}

		let text = "";
		let space = " ";

		if (orderType == 'stopLimit' || orderType == 'stopMarket') {
			text += stoptext;
			text += space;
		}
		if (orderType == 'limit' || orderType == 'stopLimit') {
			text += limittext;
		} else {
			text += markettext;
		}
		text += space;

		$(".tpop_orderType").html(text);

		if (orderType == "market") {
			$(".tpop_price").html(autopricetext + " " + "");
		} else {
			$(".tpop_price").html(parseFloat($("#dealSise").val()) + " " + inverseCoinText);
		}

		let marginTypeText = "";
		switch (marginType[coinNum]) {
		case 'cross':
			marginTypeText = crosstext;
			break;
		case 'iso':
			marginTypeText = isotext;
			break;
		}

		$(".tpop_coin").html(coinText);
		$(".tpop_coin_i").html(inverseCoinText);
		$(".tpop_qty").html(quantity[coinNum]);

		let volume = (quantity[coinNum] * $("#dealSise").val()); // 거래볼륨
		let feetmp = 1 - (1 / leverage[getCoinNum(coinType)]);
		let fee = volume * feetmp * getFeeRate('market');// 파산가격수수료
		fee += volume * getFeeRate(orderType);// 거래진입수수료
		fee += volume / leverage[getCoinNum(coinType)];// 개시증거금
		if (isInverse())
			fee = fee / $("#dealSise").val();

		$(".tpop_leverage").html("X" + leverage[getCoinNum(coinType)]);
		$(".tpop_margin").html(toFixedDown(fee, 5));
		$(".tpop_marginType").html(marginTypeText);
		
		if($("#buyTpsl_cb").is(":checked")){
			$(".tpop_tpsl_warp").css("display","flex");
			var tpslPrice = Number($("#buySLPrice").val());
			if(tpslPrice == 0) tpslPrice = "-";
			$(".tpop_sl").text(tpslPrice);
			
			tpslPrice = Number($("#buyTPPrice").val());
			if(tpslPrice == 0) tpslPrice = "-";
			$(".tpop_tp").text(tpslPrice);
			
		}else{
			$(".tpop_tpsl_warp").css("display","none");
		}
	}
}

function isInverse() {
	if (coinbet == "inverse")
		return true;
	else
		return false;
}

function isSymbolInverse(symbol) {
	if (symbol.charAt(symbol.length - 1) == 'T')
		return false;
	return true;
}

function isShow(symbol) {
	if (isSymbolInverse(symbol) == isInverse())
		return true;
	return false;
}

// ////////////////청산팝업/////////////////
function funclongshort(position) {
	if (position == "long")
		return "short";
	else
		return "long"
}
function funcbuylongshort(_coinNum) {
	return positionList[_coinNum][1];
}
let limitTempSise = 0;
function sattleNoti(cnum, lm) {
	let longshort = funcbuylongshort(cnum);

	if (lm == 'limit') {
		$("#sattlePrice").val(longSise[cnum]);
	}
	$("#sattleQty").val(positionList[cnum][3]);
	sattleNotiText(cnum);
}

function sattleNotiText(cnum) {
	// (진입가x 수량) - (판매가x수량)
	let longshort = funcbuylongshort(cnum);
	let inpos = parseFloat(positionList[cnum][2]);
	let lm = lmType;
	let price = parseFloat($("#sattlePrice").val());
	if (lm == 'limit') {
		let
		profit = (inpos - price) * $("#sattleQty").val();

		if (longshort == "long")
			profit = -profit;

		let profitloss = "";

		if (profit >= 0) {
			profitloss += profittext;
		} else {
			profitloss += losstext;
		}

		let coinname = "USDT";
		if (isInverse()) {
			coinname = getCoinType(cnum);
			profit = toFixedDown((profit / longSise[cnum]), 5);
		} else {
			profit = toFixedDown(profit, 5);
		}
		let
		text = "";
		if (lang == "KO") {
			text = $("#sattleQty").val() + " " + settlenoti_1 + " " + price
					+ settlenoti_2 + "<br>" + settlenoti_3 + " " + profitloss
					+ " " + profit + coinname + " " + settlenoti_4;
			$("#sattlenoti").html(text);
		} else {
			text = settlenoti_1 + " " + $("#sattleQty").val() + " "
					+ settlenoti_2 + price + ". " + settlenoti_3 + " "
					+ profitloss + " " + profit + " " + coinname + ".";
			$("#sattlenoti").html(text);
		}
		$("#sattlenoti").html(text);
	} else {
		let sise = 0;
		if (funcbuylongshort(cnum) == 'long') {
			sise = shortSise[cnum];
		} else {
			sise = longSise[cnum];
		}
		let profit = (inpos - sise) * $("#sattleQty").val();

		if (longshort == "long")
			profit = -profit;

		let profitloss = "";

		if (profit >= 0) {
			profitloss += profittext;
		} else {
			profitloss += losstext;
		}
		// 0.00 의 보유 포지션이 0.000 의 가격에 청산됩니다.
		let coinname = "USDT";
		if (isInverse()) {
			coinname = getCoinType(cnum);
			profit = toFixedDown((profit / longSise[cnum]), 5);
		} else {
			profit = toFixedDown(profit, 5);
		}

		let text = "";
		if (lang == "EN") {
			text = settlenoti_1 + " " + $("#sattleQty").val() + " "
					+ settlenoti_2 + marketsattletext + " " + settlenoti_3
					+ " " + profitloss + " " + profit + coinname + ".";
			$("#sattlenoti").html(text);
		} else {
			text = $("#sattleQty").val() + " " + settlenoti_1 + " "
					+ marketsattletext + settlenoti_2 + "<br>" + settlenoti_3
					+ " " + profitloss + " " + profit + coinname + settlenoti_4;
			$("#sattlenoti").html(text);
		}

		$("#sattlenoti").html(text);
	}
}

function fixedToNum(fixed) {
	let num = 1;
	for (var i = 0; i < fixed; i++) {
		num *= 0.1;
	}
	return num.toFixed(fixed);
}

function sattlePricePlus(up) {
	let cnum = $("#popLM").attr("cnum");
	let val = parseFloat($("#sattlePrice").val());

	var fix = getSymbolFixed($("#popLM").attr("cnum"));
	let plus = parseFloat(fixedToNum(fix));

	if (up == "up")
		val += plus;
	else
		val -= plus;

	val = maxValueCheck(parseFloat(1000000), val);
	val = parseFloat(val).toFixed(fix);

	$("#sattlePrice").val(val);
	sattleNotiText(cnum);
}

function sattleQtyPlus(up) {
	let cnum = $("#popLM").attr("cnum");
	let val = parseFloat($("#sattleQty").val());

	var fix = getQtyFixed(cnum);

	let plus = parseFloat(fixedToNum(fix));
	if (up == "up") {
		val += plus;
	} else
		val -= plus;

	val = maxValueCheck(positionList[cnum][3], val);
	val = parseFloat(val).toFixed(fix);

	$("#sattleQty").val(val);
	sattleNotiText(cnum);
}

function maxValueCheck(originVal, changeVal) {
	if (changeVal < 0)
		return 0;
	if (changeVal > originVal)
		return originVal;
	return changeVal;
}

function inputValClear(id) {
	$("#" + id).val("0");
	$("#" + id).trigger("input");
}
function sattleQuick(cnum) { // 공매수 눌렀을 때 - kind - long/short
	let _coinNum = Number($("#popLM").attr("cnum"));
	if(isNaN(_coinNum)) return;
	else if(positionList[_coinNum].length == 0) return;
	
	let position = positionList[_coinNum][1];
	if(position == "long") position = "short";
	else position = "long";
	
	let obj = new Object();
	obj.protocol = "buyBtn";
	obj.isLiqBuy = "1";// 청산 시도 팝업창에서 보낸건지 주문창에서 보낸건지 구분하기 위함.
	obj.userIdx = userIdx;
	obj.symbol = getSymbolType(_coinNum);
	obj.orderType = "market";
	obj.position = position;
	obj.triggerPrice = triggerPrice[_coinNum];
	obj.marginType = positionList[_coinNum][10];
	obj.postOnly = postOnly;
	obj.auto = $("#auto").is(":checked");
	obj.strategy = 'GTC';
	obj.buyQuantity = positionList[_coinNum][3];
	obj.entryPrice = longSise[_coinNum];
	obj.leverage = positionList[_coinNum][9];
	
	console.log("sattleQuick");
	console.log(obj);
	
	doSendToWeb(JSON.stringify(obj));
	popDisplay("pop_trade_end", "none");
}

function sattlebuy() { // 공매수 눌렀을 때 - kind - long/short
	if (isNaN($("#sattleQty").val()) || $("#sattleQty").val() <= 0) {
		showPopup(inputQtytext, 2);
		return;
	}else if(lmType == "limit" && (isNaN($("#sattlePrice").val()) || $("#sattlePrice").val() <= 0 )){
		showPopup(inputPricetext, 2);
		return;
	}else if(lmType == "market" && (isNaN($("#dealSise").val()) || $("#dealSise").val() <= 0 )){
		showPopup(inputPricetext, 2);
		return;
	}
	let _coinNum = $("#popLM").attr("cnum");
	let lm = lmType;
	// if(lmType == "limit")
	// lm = "stopMarket";

	let order = funclongshort(positionList[_coinNum][1]);
	let _coinType = getSymbolType(_coinNum);

	let obj = new Object();
	obj.protocol = "buyBtn";
	obj.isLiqBuy = "1";// 청산 시도 팝업창에서 보낸건지 주문창에서 보낸건지 구분하기 위함.
	obj.userIdx = userIdx;
	obj.symbol = _coinType;
	obj.orderType = lm;

	obj.position = order;
	obj.triggerPrice = triggerPrice[_coinNum];
	obj.marginType = marginType[_coinNum];
	obj.postOnly = postOnly;
	obj.auto = $("#auto").is(":checked");
	obj.strategy = 'GTC';

	let pr = $("#sattleQty").val();
	pr = toFixedDown(pr, 4);
	obj.buyQuantity = pr;
	if (lm == 'limit') {
		obj.entryPrice = parseFloat($("#sattlePrice").val());
	} else {
		obj.entryPrice = parseFloat($("#dealSise").val());
	}
	obj.leverage = leverage[_coinNum];
	
	doSendToWeb(JSON.stringify(obj));
	popDisplay("clearing_pop", "none");
}

// /////////////// 구매 ///////////////////
function buy() { // 공매수 눌렀을 때 - kind - long/short
	let coinNum = getCoinNum(coinType);
	if (validation(orderKind, coinNum)) {

		let obj = new Object();
		obj.protocol = "buyBtn";
		obj.userIdx = userIdx;
		obj.symbol = getSymbolType(coinNum);
		obj.orderType = orderType;
		obj.position = orderKind;
		obj.triggerPrice = triggerPrice[coinNum];
		obj.marginType = marginType[coinNum];
		obj.postOnly = postOnly;
		obj.auto = $("#auto").is(":checked");
		obj.entryPrice = parseFloat($("#dealSise").val());
		obj.strategy = strategy;
		obj.buyQuantity = toFixedDown(quantity[coinNum], 4);
		obj.leverage = leverage[coinNum];
		obj.addTPSL = $("#buyTpsl_cb").is(":checked");
		obj.slPrice = Number($("#buySLPrice").val());
		obj.tpPrice = Number($("#buyTPPrice").val());
		
		doSendToWeb(JSON.stringify(obj));
		popDisplay("tradingpop", "none");
		$("#quantity").val("0");
		$("#quantity").trigger('input');
		assetPercent(0);
		$("#buySLPrice").val("");
		$("#buyTPPrice").val("");
	}
}

function updateWallet(obj) {
	wallet = obj.newWallet;
}
function updateBalance(obj) {
	coinBalance[obj.cnum] = obj.newBalance;
	updateSise();
}

function setPosition(obj) { // 웹소캣에서 포지션 가져오기
	if (!isShow(obj.symbol))
		return;

	let _coinNum = getCoinNum(obj.symbol);
	try {
		// 포지션 저장 배열 값 : 유저idx, 포지션(매수매도) , 진입가격 , 수량(사이즈) ,강제 청산 가격, 계약 USDT,
		positionList[_coinNum][0] = obj.userIdx;
		positionList[_coinNum][1] = obj.position;
		positionList[_coinNum][2] = obj.entryPrice;
		positionList[_coinNum][3] = obj.buyQuantity;
		positionList[_coinNum][4] = obj.liquidationPrice;
		positionList[_coinNum][5] = obj.contractVolume;
		positionList[_coinNum][6] = obj.margin; // 해당포지션의 유지증거금 <== 안쓰는 첨자
		positionList[_coinNum][7] = obj.fee; // 해당포지션의 fee
		positionList[_coinNum][8] = 0; // obj.todaySum 삭제
		positionList[_coinNum][9] = obj.leverage;
		positionList[_coinNum][10] = obj.marginType;
		positionList[_coinNum][11] = obj.TP;
		positionList[_coinNum][12] = obj.SL;
	} catch (err) {
		console.log("position err:" + err.message);
	}
	try {
		// 배당
		setLeverage(obj.symbol, obj.leverage);
		buyKind[_coinNum] = obj.position;
		positionHtmlView(_coinNum);
	} catch (err) {
		console.log("position err mul:" + err.message);
	}

	if (_coinNum != coinNum) {
		hiddenHtmlView(_coinNum);
	}
}
function poLoad(){
	// 처음 새로고침시 바로 뜨는 포지션 목록
	if (userIdx != "") {
		for (var k = 0; k < positionObj.plist.length; k++) {
			if (isShow(positionObj.plist[k].symbol)) {
				setMarginTypeCNum(positionObj.plist[k].marginType,
						getCoinNum(positionObj.plist[k].symbol));
				setPosition(positionObj.plist[k]);
			}
	
		}
		for (var k = 0; k < positionObj.olist.length; k++) {
			if (isShow(positionObj.olist[k].symbol)) {
				setMarginTypeCNum(positionObj.olist[k].marginType,
						getCoinNum(positionObj.olist[k].symbol));
				setOrder(positionObj.olist[k]);
			}
		}
	}
}

function hiddenHtmlView(_coinNum) {
	let positionTxt = '';
	let box = $(".positionsBottom" + _coinNum);
	try {
		if (!isInverse())
			box.css('display', 'flex');
		if (positionList[_coinNum][1] == "long") {
			positionTxt = "LONG";
		} else if (positionList[_coinNum][1] == "short") {
			positionTxt = "SHORT";
		}
	} catch (err) {
		console.log("hiddenHtmlView err:" + err.message);
	}

	try {
		let fixnum = getSymbolFixed(_coinNum);
		let qtyfix = getQtyFixed(_coinNum);
		let marginText = getMarginText(marginType[_coinNum]);
		
		box.find(".positionbox_coin").html(
				getSymbolType(_coinNum) + "\n" + marginText + " "
						+ positionList[_coinNum][9] + "X"); // 코인종류
		
		box.find(".position_entryprice").html(
				toFixedDown(positionList[_coinNum][2], fixnum)); // 진입가격
		box.find(".position_liquidation").html(
				toFixedDown(positionList[_coinNum][4], fixnum)); // 강제 청산 가격
		box.find(".position_quantity").html(
				toFixedDown(positionList[_coinNum][3], qtyfix)); // 계약수량
		box.find(".positionbox_margin").html(
				toFixedDown(positionList[_coinNum][7], 5)); // 증거금
		if (positionTxt == "LONG") {
			box.find(".polongshort").addClass("d_position_long");
			box.find(".polongshort").html(longtext);
		} else {
			box.find(".polongshort").addClass("d_position_short");
			box.find(".polongshort").html(shorttext);
		}
	} catch (err) {
		console.log("hiddenHtmlView2 err:" + err.message);
	}

}

function positionHtmlInit(_coinNum) { // 포지션 창 공백
	try {
		let box = $(".positionsBottom" + _coinNum);
		box.find(".po_sym").html("");
		box.find(".po_lev").html("");
		box.find(".positionbox_coin").html(""); 
		box.find(".position_entryprice").html(""); 
		box.find(".position_entryprice_KRW").html(""); 
		box.find(".position_quantity").html(""); 
		box.find(".position_leverage").html(""); 
		box.find(".positionbox_margin").html(""); 
		box.find(".positionbox_margin_KRW").html(""); 
		box.find(".position_liquidation").html(""); 
		box.find(".position_liquidation_KRW").html(""); 
		box.find(".position_revenue").html(""); 
		box.find(".position_revenue_KRW").html(""); 
		box.find(".position_revenue_rate").html(""); 
		box.find(".position_pocolor").removeClass("red");
		box.find(".polongshort").removeClass("d_position_long"); // LS표기
		box.find(".polongshort").removeClass("d_position_short"); // LS표기
	} catch (err) {
		console.log("positionHtmlInit err:" + err.message);
	}

}
function getMarginText(marginType) {
	switch (marginType) {
	case 'cross':
		return crosstext;
	case 'iso':
		return isotext;
	}
	return false;
}
function positionHtmlView(_coinNum) {
	try {
		// 포지션 저장 배열 값 : 유저idx, 포지션(매수매도) , 진입가격 , 수량(사이즈) ,강제 청산 가격, 계약 USDT,
		// marginSum
		if (buyKind[_coinNum] != null && buyKind[_coinNum] != '') {
			// $(".positionsBottom"+_coinNum).css("display", "flex");
			let box = $(".positionsBottom" + _coinNum);

			let positionTxt = '';
			let marginText = getMarginText(marginType[_coinNum]);
			box.find(".po_lev").text(positionList[_coinNum][9]);
			box.find(".po_sym").text(getSymbolType(_coinNum));
			box.find(".po_sta").text(marginText);

			if (positionList[_coinNum][1] == "long") {
				positionTxt = "LONG";
			} else if (positionList[_coinNum][1] == "short") {
				positionTxt = "SHORT";
			}
			let fixnum = getSymbolFixed(_coinNum);
			let qtyfix = getQtyFixed(_coinNum);
			
			box.find(".position_entryprice").text(toFixedDown(positionList[_coinNum][2], fixnum)); // 진입가격
			box.find(".position_entryprice_KRW").text(fmtNum(estimatedKrw(positionList[_coinNum][2]))); // 진입가격
			box.find(".position_quantity").text(toFixedDown(positionList[_coinNum][3], qtyfix)+" "+getCoinType(_coinNum)); // 계약수량
			box.find(".positionbox_margin").text(toFixedDown(positionList[_coinNum][7], 5)); // 증거금

			if (positionTxt == "LONG") {
				box.find(".polongshort").addClass("d_position_long");
				box.find(".polongshort").removeClass("d_position_short");
				box.find(".polongshort").html(longtext);
				box.find(".position_pocolor").parent().removeClass("red");

			} else {
				box.find(".polongshort").addClass("d_position_short");
				box.find(".polongshort").removeClass("d_position_long");
				box.find(".polongshort").html(shorttext);
				box.find(".position_pocolor").parent().addClass("red");
			}

			if (parseFloat(positionList[_coinNum][4]) <= 0) {
				box.find(".position_liquidation").text((0).toFixed(fixnum));
				box.find(".position_liquidation_KRW").text(0);
			} else {
				box.find(".position_liquidation").text(toFixedDown(positionList[_coinNum][4], fixnum));
				box.find(".position_liquidation_KRW").text(fmtNum(estimatedKrw(positionList[_coinNum][4])));
			}
			tpslSetting(_coinNum);
		}
	} catch (err) {
		console.log(_coinNum + " positionHtmlView err:" + err.message);
	}

}

function updatePositionHtmlView(_coinNum) {
	if (isInverse() && _coinNum != coinNum) {
		$(".positionsBottom" + _coinNum).css("display", "none");
		return;
	}

	if (buyKind[_coinNum] != null) {

		$(".positionsBottom" + _coinNum).css("display", "flex");
		// 포지션 저장 배열 값 : 유저idx, 포지션(매수매도) , 진입가격 , 수량(사이즈) ,강제 청산 가격, 계약 USDT,
		// 7fee = 개시증거금 +파산가격수수료
		let ave = (parseFloat(longSise[_coinNum]) + parseFloat(shortSise[_coinNum])) / 2;
		if(isNaN(ave)) return;
		
		// 예상 수익 : (평균 시세 - 진입 시세) * 수량 * 배당
		let _profit = profit[_coinNum];
		let _leverage = leverage[_coinNum];
		// 수익률 : (예상 수익 수익 USDT / 계약USDT) * 100

		if (buyKind[_coinNum] != null && buyKind[_coinNum] != '') {
			let box = $(".positionsBottom" + _coinNum);

			if(!isNaN(_profit)){
				box.find(".position_revenue").text( toFixedDown(_profit, 5)+" "+getCoinTypeOrUSDT(_coinNum));
				box.find(".position_revenue_KRW").text( fmtNum(exchangeKrwInverse(_profit)));
				box.find(".position_revenue_rate").text( toFixedDown(profitRate[_coinNum], 2) + "%");
				
				if (parseFloat(_profit) > 0) {
					box.find(".position_revenue").parent().addClass("blue");
					box.find(".position_revenue_rate").addClass("blue");
					box.find(".position_revenue_KRW").addClass("blue");
					box.find(".position_revenue").parent().removeClass("red");
					box.find(".position_revenue_rate").removeClass("red");
					box.find(".position_revenue_KRW").removeClass("red");
				} else {
					box.find(".position_revenue").parent().addClass("red");
					box.find(".position_revenue_rate").addClass("red");
					box.find(".position_revenue_KRW").addClass("red");
					box.find(".position_revenue").parent().removeClass("blue");
					box.find(".position_revenue_rate").removeClass("blue");
					box.find(".position_revenue_KRW").removeClass("blue");
				}
			}
			box.find(".positionbox_margin_KRW").text(fmtNum(exchangeKrwInverse(positionList[_coinNum][7]))); // 증거금
		}
	} else {
		$(".positionsBottom" + _coinNum).css("display", "none");
	}
}

function sattleQtyRangeSet(value) {
	$("#sattleQtyRange").val(value);
	sattleQtyRangeInput();
}

function sattleQtyRangeInput() {
	var val = $("#sattleQtyRange").val();
	var persent = val * 0.01;
	var cnum = $("#popLM").attr("cnum");
	
	var qtyfix = getQtyFixed(cnum);
	$("#sattleQty").val(toFixedDown(positionList[cnum][3] * persent, qtyfix));

	$("#sattleQtyRange").css(
			'background',
			'linear-gradient(to right, '+barcolor[0]+' 0%, '+barcolor[0]+' ' + val
					+ '%, '+barcolor[1]+' ' + val + '%, '+barcolor[1]+' 100%)');

	sattleNotiText(cnum);
}

// ///////////팝업/////////////
function popLM(cnum, lm) {
	if (cnum == -1) {
		cnum = $("#popLM").attr("cnum");
	}
	lmType = lm;
	if (positionList[cnum].length == 0) {
		return;
	}

	if (lm == "limit") {
		$("#sattlePriceBox").css("display", "block");
		$(".cpopType").html(limittext + " " + closeText);
	} else {
		$("#sattlePriceBox").css("display", "none");
		$(".cpopType").html(markettext + " " + closeText);
	}

	popDisplay("clearing_pop", "flex");
	$("#popLM").attr("cnum", cnum);

	$(".cpoptitle").html(getSymbolType(cnum));

	$(".coinType").html(getCoinType(cnum));
	sattleNoti(cnum, lm);

	$("#sattleQtyRange").val(100);
	sattleQtyRangeInput();
}

function popQuickLiq(cnum) {
	if (cnum == -1) {
		cnum = $("#popLM").attr("cnum");
	}
	lmType = "market";
	if (positionList[cnum].length == 0) {
		return;
	}

	popDisplay("pop_trade_end", "flex");
	$("#popLM").attr("cnum", cnum);
	$(".coinSymbol").html(getSymbolType(cnum));
}

//////////////////////tpsl

function tpslSetting(cnum){
	let TP = positionList[cnum][11];
	let SL = positionList[cnum][12];
	let $box = $("#tpslBox"+cnum);
	
	$box.css("display","flex");
	
	if(TP == null)
		TP = "--";
	else
		TP = fmtNum(TP);
	
	if(SL == null)
		SL = "--";
	else
		SL = fmtNum(SL);
	$box.find(".tp").text(TP);
	$box.find(".sl").text(SL);
}

function popTPSL(cnum) {
	if (cnum == -1) {
		cnum = $("#popTPSL").attr("cnum");
	}
	if (positionList[cnum].length == 0) {
		return;
	}

	popDisplay("tpsl_pop", "flex");
	$("#popTPSL").attr("cnum", cnum);

	$(".cpoptitle").html(getSymbolType(cnum));
	$(".coinType").html(getCoinType(cnum));
	$(".tpsl_btn").removeClass("click");
	
	let fixnum = getSymbolFixed(cnum);
	$("#tpsl_entry").text(fmtNum(toFixedDown(positionList[cnum][2],fixnum)));
	$("#tpsl_liq").text(fmtNum(toFixedDown(positionList[cnum][4],fixnum)));
	$("#tpsl_tpInput").val(positionList[cnum][11]);
	$("#tpsl_slInput").val(positionList[cnum][12]);
	$("#tpsl_tpInput").trigger("input");
	$("#tpsl_slInput").trigger("input");
}

function setTPSLPersent(type,persent) {
	let cnum = Number($("#popTPSL").attr("cnum"));
	let pos = positionList[cnum];
	if(pos == undefined){
		console.log("setTPSLPersent not position err");
		return;
	}
	let $inputBlock = $("#tpsl_"+type+"Input");
	let fixed = getSymbolFixed(cnum);
	
	$inputBlock.val(toFixedDown( getProfitSise(cnum,type,persent) ,fixed));
	$inputBlock.trigger("input");
	
	$(".tpsl_btn."+type).removeClass("click");
	$(".tpsl_btn"+persent+"."+type).addClass("click");
}

function resetTPSLInput(type){
	$("#tpsl_"+type+"Input").val("");
	$("#tpsl_"+type+"Input").trigger("input");
}

function setTPSL() { // 공매수 눌렀을 때 - kind - long/short
	let cnum = $("#popTPSL").attr("cnum");
	if(cnum == undefined){
		return;
	}else if(positionList[cnum].length == 0){
		return;
	}
	let prevTP = Number(positionList[cnum][11]);
	let prevSL = Number(positionList[cnum][12]);
	
	let tpInput = Number($("#tpsl_tpInput").val());
	let slInput = Number($("#tpsl_slInput").val());
	let sise = Number(longSise[cnum]);
	
	if(isNaN(tpInput) || isNaN(slInput))
		return;
	else if(prevTP == tpInput && prevSL == slInput){
		return;
	}
	
	if(positionList[cnum][1] == "long"){
		if(tpInput != 0 && tpInput <= sise){
			showPopup(TPErrText_more,2);
			return;
		}else if(slInput != 0 && slInput >= sise){
			showPopup(SLErrText_less,2);
			return;
		}
	}else{
		if(tpInput != 0 && tpInput >= sise){
			showPopup(TPErrText_less,2);
			return;
		}else if(slInput != 0 && slInput <= sise){
			showPopup(SLErrText_more,2);
			return;
		}
	}
	
	let obj = new Object();
	obj.protocol = "setTPSL";
	obj.userIdx = userIdx;
	obj.symbol = getSymbolType(cnum);
	obj.tpPrice = tpInput;
	obj.slPrice = slInput;
	
	doSendToWeb(JSON.stringify(obj));
}

function updateTPSL(obj){
	let cnum = Number(getCoinNum(obj.symbol));
	if(positionList[cnum] == undefined || positionList[cnum].length == 0){
		console.log("updateTPSL err! position is empty");
	}
	positionList[cnum][11] = obj.tpPrice;
	positionList[cnum][12] = obj.slPrice;
	tpslSetting(cnum);
	popDisplay('tpsl_pop','none');
}

function buyTpslShow(on){
	if(on){
		$(".buyTpsl").css("display","flex");
		$("#buyTpsl_cb").prop("checked", true);
		$("#buyTpsl_cb").trigger("click");
	}else{
		$(".buyTpsl").css("display","none")
		$("#buyTpsl_cb").prop("checked", false);
	}
}
