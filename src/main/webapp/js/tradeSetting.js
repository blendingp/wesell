const longcolor = "#0ecb81";
const shortcolor = "#f6465d";
const defaultcolor = "#FFFFFF";
const profitcolor = "#0ecb81";
const losscolor = "#f6465d";
const barcolor=["#37d0d7","#e6e6e6"];
const isKrwShow = false;
const hiddenbox = true;
const tradeHistoryCnt=12;

//매수 매도 공통 변수
var longFee = 0; // 비용
var shortFee = 0; // 비용
var longSize = 0; // 크기 
var shortSize = 0; // 크기 
var coinBalance = new Array();
var coinNum = getCoinNum(coinType); // 코인 배열 번호
var orderType = 'market'; // 주문 종류 
const strategy = 'GTC'
var unitv = 2;
const postOnly = false;
var orderKind = "";
var lmType = "limit";
var assetpersent = 0;
let reBuyWallet = 0;

// 공통 변수 중 배열 필요 변수 
let qtyFixed = new Array(); // 코인별 매수 시세 
let priceFixed = new Array(); // 코인별 매수 시세 
let longSise = new Array(); // 코인별 매수 시세 
let shortSise = new Array(); // 코인별 매도 시세 
let useCoins = new Array(); // 코인 변수명 
let coinArr = new Array(); // 코인 변수명 
let leverage = new Array(); // 배당 (default - 1x)
let quantity = new Array(); // 주문 수량  (default - 0) 
let triggerPrice = new Array(); // 트리거 가격
let buyKind = new Array(); // 현재 구매 종류 : index - coinNum / value - long/short
let marginType = new Array(); // 교차 / 격리 
var profit = new Array();
var profitRate = new Array();
let maxContractVolume = new Array();
let maxLeverage = new Array(); 
let marginRateType = new Array(); 
let feeRate = new Array(); 

// 주문 저장 배열 값 (주문번호 , 유형 , 가격 , 체결 , 수량 , 매수/매도, 지불 USDT)
var preOrder = new Array();
// 포지션 저장 배열 값  : 유저idx, 포지션(매수매도) ,  진입가격 ,  수량(사이즈) ,강제 청산 가격, 계약 USDT, marginSum
var positionList = new Array();

function getCoinNum(symbol) {
	switch (symbol) {
	case "BTCUSDT": case "BTC": case "BTCUSD":
		return 0;
	case "ETHUSDT": case "ETH": case "ETHUSD":
		return 1;
	case "XRPUSDT": case "XRP": case "XRPUSD":
		return 2;
	case "TRXUSDT": case "TRX": case "TRXUSD":
		return 3;
	case "DOGEUSDT": case "DOGE": case "DOGEUSD":
		return 4;
	case "LTCUSDT": case "LTC": case "LTCUSD":
		return 5;
	case "SANDUSDT": case "SAND": case "SANDUSD":
		return 6;
	case "ADAUSDT": case "ADA": case "ADAUSD":
		return 7;
	case "GMTUSDT": case "GMT": case "GMTUSD":
		return 8;
	case "APEUSDT": case "APE": case "APEUSD":
		return 9;
	case "GALAUSDT": case "GALA": case "GALAUSD":
		return 10;
	case "ROSEUSDT": case "ROSE": case "ROSEUSD":
		return 11;
	case "KSMUSDT": case "KSM": case "KSMUSD":
		return 12;
	case "DYDXUSDT": case "DYDX": case "DYDXUSD":
		return 13;
	default:
		break;
	}
} 

function getCookie(cookie_name) {
	var x, y; 
	var val = document.cookie.split(';'); 
	for (var i = 0; i < val.length; i++) 
	{ 
		x = val[i].substr(0, val[i].indexOf('=')); 
		y = val[i].substr(val[i].indexOf('=') + 1); 
		x = x.replace(/^\s+|\s+$/g, ''); // 앞과 뒤의 공백 제거하기
		if (x == cookie_name) 
			return unescape(y); // unescape로 디코딩 후 값 리턴
	}
}

function setCookieMobile(name, value, expiredays) {
	var todayDate = new Date();
	todayDate.setDate(todayDate.getDate() + expiredays);
	document.cookie = name + "=" + encodeURI(value)
			+ "; path=/; expires=" + todayDate.toGMTString() + ";"
}
function coinLoad(){
	$.ajax({
		type:'get',
		url:'/wesell/getCoinInfo.do',
		data:{"userIdx":userIdx},
		dataType: "json",
		success:function(data){
			if(data.coinWallet != null){
				for(var i = 0; i < data.coinWallet.length; i++){
					coinBalance.push(0);
				}
				for(var i = 0; i < data.coinWallet.length; i++){
					var cnum = data.coinWallet[i].cnum;
					coinBalance[cnum] = data.coinWallet[i].wallet;
				}
			}
			
			for(var i = 0; i < data.maxCoinLength; i++){
				longSise.push(0);
				shortSise.push(0);
				quantity.push(0);
				leverage.push(0);
				triggerPrice.push(0);
				maxContractVolume.push(0);
				marginType.push('iso');
				profit.push(0);
				profitRate.push(0);
				coinArr.push(i);
				preOrder.push(new Array());
				positionList.push(new Array());
				buyKind.push(null);
				marginRateType.push(0);
			}
			
			for(var i = 0; i < data.useCoins.length; i++){
				var cnum = data.useCoins[i].cnum;
				leverage[cnum] = data.useCoins[i].maxLeverage;
				maxLeverage[cnum] = data.useCoins[i].maxLeverage;
				maxContractVolume[cnum] = data.useCoins[i].contractVolume;
				useCoins.push(data.useCoins[i].name);
				qtyFixed[cnum] = data.useCoins[i].qtyFixed;
				priceFixed[cnum] = data.useCoins[i].priceFixed;
				marginRateType[cnum] = data.useCoins[i].maxVolumeType;
			}
			
			for(var i = 0; i < data.rateArray.length; i++){
				feeRate.push(data.rateArray[i]);
			}
			initPage();
		}
	})
}

let obj = {
	userIdx : userIdx,
	ua : window.navigator.userAgent,
	pf : window.navigator.platform,
	pclick : 1,
	starttime : 10000
};

Object.defineProperty(console, '_commandLineAPI', {
	get : function() {
		throw '콘솔을 사용할 수 없습니다.'
	}
});

document.addEventListener("resume", onResume, false);
function onResume() {
	setTimeout(function() {
		// TODO: do your thing!
		location.reload();
	}, 0);
}
//var statpc = 1;
$(window).resize(function() {
	let tmpstat;
	let windowWidth = $(window).width();

	if (windowWidth < 760) {
		tmpstat = 0;// 모바일
	} else {
		tmpstat = 1;// PC
	}

	if (tmpstat != statpc)
		location.reload();

})