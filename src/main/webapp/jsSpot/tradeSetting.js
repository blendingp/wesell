const longcolor = "#0ecb81";
const shortcolor = "#f6465d";
const defaultcolor = "#FFFFFF";
const profitcolor = "#0ecb81";
const losscolor = "#f6465d";
const barcolor=["#37d0d7","#e6e6e6"];
const tradeHistoryCnt=12;
const unitv = 2;

var coinBalance = new Array();

var useCoins = new Array(); // 코인 변수명 
var qtyFixed = new Array(); // 코인별 수량의 소수점 자리수  
var priceFixed = new Array(); // 매수시세의 코인별 소수점 자리수
var coinNum = getCoinNum(coinType); // 코인 배열 번호
var orderType = 'market'; // 주문 종류 
var buyOrSell = 'long'; // 주문 종류 long(buy) short(sell) 
var assetpersent = 0;
var triggerPrice = new Array(); // 트리거 가격
var spotLongEntryPriceList = new Array(); // 스팟롱 진입가 리스트.

var longSise = new Array(); // 코인별 매수 시세 
var shortSise = new Array(); // 코인별 매도 시세 

//주문 저장 배열 값 (주문번호 , 유형 , 가격 , 체결 , 수량 , 매수/매도, 지불 USDT)
var preOrder = new Array();

function getAveEntryPrice(cnum){
	if(spotLongEntryPriceList.length == 0)
		return Number(longSise[cnum]);

	var ave = 0;
	for(var i = 0; i < spotLongEntryPriceList[cnum].length; i++){
		ave += spotLongEntryPriceList[cnum][i];
	}
	ave = Number((ave / spotLongEntryPriceList[cnum].length).toFixed(getSymbolFixed(cnum)));
	return ave;
}

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

function coinLoad(){
	$.ajax({
		type:'get',
		url:'/wesell/getCoinInfo.do',
		data:{"userIdx":userIdx,"spot":true},
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
				triggerPrice.push(0);
				preOrder.push(new Array());
				spotLongEntryPriceList.push(new Array());
			}
			
			for(var i = 0; i < data.useCoins.length; i++){
				var cnum = data.useCoins[i].cnum;				
				useCoins.push(data.useCoins[i].name);
				qtyFixed[cnum] = data.useCoins[i].qtyFixed;
				priceFixed[cnum] = data.useCoins[i].priceFixed;				
			}
			
			for(var i = 0; i < data.spotLongArray.length; i++){
				var cnum = data.spotLongArray[i].cnum;				
				spotLongEntryPriceList[cnum].push(Number(data.spotLongArray[i].entryPrice));
			}
			
			initPage();
		}
	})	  
	//차후에 디비에서 가져온다
	/*useCoins.push("BTC");
	useCoins.push("ETH");
	priceFixed.push(6);
	priceFixed.push(2);
	qtyFixed.push(6);
	qtyFixed.push(4);
	
	longSise.push(0);
	longSise.push(0);
	shortSise.push(0);
	shortSise.push(0);
	preOrder.push(new Array());*/
	
}



