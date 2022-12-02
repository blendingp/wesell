let wsUriToWeb = "wss://"+servername+":"+serverport+"/wesell/websocket/echo.do"; //주소 확인!!
if(servername == "localhost")
	wsUriToWeb = "ws://"+servername+":"+serverport+"/wesell/websocket/echo.do";
	
let wsUri = "wss://"+servername+":8287/port8287";
if(servername == "localhost")
	wsUri = "ws://"+servername+":8288/port8288";

let wsAPIUri = "";
var loading = true;

function APICoinChange(){
	const lcoin = coinType.toLowerCase();
	
	wsAPIUri = "wss://fstream.binance.com/stream?streams=" + lcoin
			+ "@markPrice@1s/" + lcoin + "@depth20/" + lcoin + "@aggTrade";
	for (i = 0; i < useCoins.length; i++) {
		wsAPIUri += '/' + useCoins[i].toLowerCase() + 'usdt@kline_1m';
		wsAPIUri += '/' + useCoins[i].toLowerCase() + 'usdt@ticker';
	}
	if(!loading){
		apiClose();
	}
	loading = false;
	console.log("loading "+loading);
}
var websocket2;
function apiClose(){
	if(websocket2 == null) return;
	
	$('#tradehistory').html("");
	handClose = true;
	connected = false;
	tradeArr.length = 0;
	websocket2.close();
	initAPI();
}

var websocket2;
let handClose = false;
let connnected = false;
function initAPI() {
	
	try{
		handClose = true;
		websocket2.close();
	}catch(e){
		console.log("재연결")
	}
	
	websocket2 = new WebSocket(wsAPIUri);
	websocket2.onopen = function(evt) {
		onAPIOpen(evt);
		handClose = false;
		connnected = true;
	};
	websocket2.onmessage = function(evt) {
		onAPIMessage(evt);
	};
	websocket2.onerror = function(evt) {
		onAPIError(evt);
	};
	websocket2.onclose = function(evt) {
		if(!handClose && connected){
			console.log("API 재접속");
			setTimeout("initAPI()", 1000);
		}
	};
}
function onAPIOpen(evt) {
	console.log('APIOPEN---------------')
}

let prevPrice = 0;
let fPrice = new Object;
let tradeArr = [];
function onAPIMessage(evt) {
	let jdata = JSON.parse(evt.data);
	let stream = jdata.stream;
	let fixnum = getSymbolFixed(coinNum);
	let qtyfixnum = getQtyFixed(coinNum);
	if (stream.slice(-8) === '@depth20') {
		try {
			if (jdata.data.b === null || jdata.data.b === undefined
					|| jdata.data.b.length === 0) {
				return;
			}
			
			let mVal = 0;
			let dsym = jdata.data.s.replace('USDT','');
			let fnum = getSymbolFixedNum(dsym);
			if (mdata[dsym].run === true && mdata[dsym].c >= cnt) {
				mVal = mdata[dsym].idv;
				for(var k in jdata.data.a) {
					jdata.data.a[k][0] = (parseFloat(jdata.data.a[k][0])+mVal).toFixed(fnum);
				}
				for(var k in jdata.data.b) {
					jdata.data.b[k][0] = (parseFloat(jdata.data.b[k][0])+mVal).toFixed(fnum);
				}
			}
			
			let first_bids = jdata.data.b[0][0]; // 공매수
			let first_asks = jdata.data.a[0][0]; // 공매도
			for (m = 0; m <= 6; m++) {
				$(".ordertable .longhoga:eq(" + (6-m) + ") .hp.long")
						.html(parseFloat(jdata.data.a[m][0]).toFixed(fixnum));
				$(".ordertable .longhoga:eq(" + (6-m) + ") .hq")
						.html(parseFloat(jdata.data.a[m][1]).toFixed(qtyfixnum));
				$(".ordertable .longhoga:eq(" + (6-m) + ") .hsum").html(
						parseFloat( newtot(jdata.data.a[m][0], jdata.data.a[m][1])) .toFixed(unitv));
				$(".ordertable .longhoga:eq(" + (6-m) + ") .hgraph")
						.css("width", newptpt(jdata.data.a[m][0], jdata.data.a[m][1]));
			}
			for (m = 0; m <= 6; m++) {
				$(".ordertable .shorthoga:eq(" + m + ") .hp.short").html(
						parseFloat(jdata.data.b[m][0]).toFixed(fixnum));
				$(".ordertable .shorthoga:eq(" + m + ") .hq").html(
						parseFloat(jdata.data.b[m][1]).toFixed(qtyfixnum));
				$(".ordertable .shorthoga:eq(" + m + ") .hsum")
						.html( parseFloat( newtot(jdata.data.b[m][0], jdata.data.b[m][1])).toFixed(unitv));
				$(".ordertable .shorthoga:eq(" + m + ") .hgraph").css(
						"width",newptpt(jdata.data.b[m][0],jdata.data.b[m][1]));
			}
		} catch (e) {
			console.log(stream, "orderbook err", e);
		}
	}
	if (stream.slice(-13) === '@markPrice@1s') {
		try {
			$(".idfRate").html(toFixedDown((jdata.data.r * 100), 4) + "%");
		} catch (e) {
			console.log(stream, " mark price err", e);
		}
	}
	if (stream.slice(-7) === '@ticker') {
		let coin = stream.slice(0, -11);
		let plus = "";
		if (jdata.data.p < 0) {
			$(".coin_" + coin).find(".arrowUp").html("↓");
			$(".coin_" + coin).find(".color").css("color",shortcolor);
		} else {
			plus = "+";
			$(".coin_" + coin).find(".arrowUp").html("↑");
			$(".coin_" + coin).find(".color").css("color",longcolor);
		}
		$(".coin_" + coin).find(".persentage").html(plus + jdata.data.P);
		$(".coin_" + coin).find(".change").html(plus + jdata.data.p);

		if (getCoinNum(stream.slice(0, -7).toUpperCase()) == coinNum) {
			try {
				$(".id24high").html(jdata.data.h);
				$(".id24low").html(jdata.data.l);
				$(".id24highQty").html(jdata.data.q);

				var updown = "";
				if (jdata.data.p < 0) {
					$(".mainsise").css("color", shortcolor);
					$(".coinpersent").parent().removeClass("up");
					$(".coinpersent").parent().addClass("down");
					updown = "↓";
				} else {
					$(".coininfo").css("color", longcolor);
					$(".mainsise").css("color", longcolor);
					$(".coinpersent").parent().removeClass("down");
					$(".coinpersent").parent().addClass("up");
					updown = "↑";
				}
				$(".coininfo.persent").html(updown + " " + jdata.data.p + "  " + jdata.data.P + "%");
				$(".coinpersent").html(plus + jdata.data.P);
			} catch (e) {
				console.log(stream, " ticker err", e);
			}
		}
	}
	if (stream.slice(-9) === '@kline_1m') {
		try {
			let currPrice;
			let coinname = stream.slice(0, -13);
			let cname = coinname.toUpperCase();
			let cnum = getCoinNum(cname);
			cPr[cname] = jdata.data.k['c'];
			if(cT[cname].length === 10) {
				cT[cname].shift();
			}
			
			if (jdata.data['E'] !== undefined) {
				cT[cname].push(jdata.data['E']);
			}
			if (mdata[cname].run === true ) {
				if (mdata[cname].c >= cnt) {
					mdata[cname].prgM(parseFloat(jdata.data.k['c']), cname, jdata.data['E']);
					jdata.data.k['c'] = mdata[cname].pr;
				} else {
					mdata[cname].c += 1;
				}
			}
			$(".coin_" + coinname).find(".coinval").html(
					toFixedDown(jdata.data.k['c'], priceFixed[cnum]));

			if (jdata.data.s === coinType) {
				if (prevPrice === 0) {
					prevPrice = jdata.data.k['c'];
					return;
				}
				if (jdata.data.k['c'] > prevPrice) {
					currPrice = toFixedDown(jdata.data.k['c'], priceFixed[cnum]) + ' ↑';
				} else if (jdata.data.k['c'] === prevPrice) {
					currPrice = toFixedDown(jdata.data.k['c'], priceFixed[cnum]) + ' =';
				} else if (jdata.data.k['c'] < prevPrice) {
					currPrice = toFixedDown(jdata.data.k['c'], priceFixed[cnum]) + ' ↓';
				}
				var coinFluctuation;
				if (currPrice.split(' ')){
					coinFluctuation = currPrice.split(' ');
				}
				prevPrice = jdata.data.k['c'];
				let fArrow = coinFluctuation[1];
				if (fArrow === '↑') {
					$(".siseArrow").css('color', longcolor);
					$("#longSise").css('color', longcolor);
				} else if (fArrow === '↓') {
					$(".siseArrow").css('color', shortcolor);
					$("#longSise").css('color', shortcolor);
				} else {
					fArrow = '&nbsp&nbsp&nbsp';
					$(".siseArrow").css('color', defaultcolor);
					$("#longSise").css('color', defaultcolor);
				}
				$(".siseArrow").html(fArrow);
				$("#longSise").html(
						toFixedDown(Number(coinFluctuation[0]), fixnum));
			}
			fPrice[jdata.data.s] = jdata.data.k['c'];
			let arr = new Array(useCoins.length);
			for (i = 0; i < useCoins.length; i++) {
				let sym = useCoins[i];
				for (key in fPrice) {
					if (key === sym + 'USDT') {
						arr[getCoinNum(sym)] = fPrice[key];
					}
				}
			}
			updateCoinSise(arr);
		} catch (e) {
			console.log(stream, " kline err", e);
		}
	}
	if (stream.slice(-9) === '@aggTrade' && jdata.data.s === coinType) {
		if (tradeArr.length === tradeHistoryCnt) {
			tradeArr.pop();
		}
		let obj = new Object();
		let fixnum = getSymbolFixed(coinNum);
		let fixQtynum = getQtyFixed(coinNum);
		if (jdata.data.m === false) {
			obj.type = 'long'
		} else if (jdata.data.m === true) {
			obj.type = 'short'
		}
		let mVal = 0;
		let dsym = jdata.data.s.replace('USDT','');
		if (mdata[dsym].run === true && mdata[dsym].c >= cnt) {
			mVal = mdata[dsym].idv;
			jdata.data.p = (parseFloat(jdata.data.p)+mVal).toFixed(fixnum);
		}
		obj.q = parseFloat(jdata.data.q).toFixed(fixQtynum);
		obj.price = parseFloat(jdata.data.p).toFixed(fixnum);
		let dTime = new Date(jdata.data.T);
		obj.time = dTime.getHours() + ":" + dTime.getMinutes() + ":" + dTime.getSeconds();
		tradeArr.unshift(obj);
		let text = '';
		for (i = 0; i < tradeArr.length; i++) {
			text = pileTHHtml(text, tradeArr[i]);
		}
		$('#tradehistory').html(text);
	}
	updateSise(); // 시세에 따라 업데이트 해줘야하는 것
	for (var k = 0; k < useCoins.length; k++) {
		let cnum = getCoinNum(useCoins[k]);
		updatePositionHtmlView(cnum);
	}
}

function onAPIError(evt) {

}
var websocket;
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
	websocket.onclose = function(evt) {
		console.log("ws close");
		websocket2.close();
		//setTimeout("getReload()", 1000);
	};
}

function getReload() {
	location.reload();
}

function onOpen(evt) {

}
function newtot(price, amount) {
	return (parseFloat(price) * parseFloat(amount));
}
function newptpt(obj, idx) {
	let rt = newtot(obj, idx);
	rt = rt / 500;
	if (rt > 100)
		rt = 100;
	return rt + "%";
}
function tot(obj, idx) {
	let price = Object.keys(obj)[idx];
	let amount = Object.values(obj)[idx];
	return (parseFloat(price) * parseFloat(amount));
}
function ptpt(obj, idx) {
	let rt = tot(obj, idx);
	rt = rt / 8000;
	if (rt > 100)
		rt = 100;
	return rt + "%";
}

let aleadySended = false;
let checkedSendLinePacket = false;
let checkedLogin = false;

function doSendLinePacket() {
	if (aleadySended == true)
		return;
	aleadySended = true;

	setTimeout(function() {
		let obj = new Object;
		obj.protocol = "sendLinePacket";
		obj.symbol = getSymbolType(coinNum);
		obj.coinbet = coinbet;
		doSendToWeb(JSON.stringify(obj));
	}, 100);// 경우식코드, 연달에 패킷 보내는거 막기위해 0.1초 딜레이줌.
}

function onMessage(evt) {

	let protocol = "none";
	try {
		let k = 0;
		let evtObj = JSON.parse(evt.data);
		protocol = evtObj.protocol;
		if (evtObj.protocol === 'RUOK') {
			let obj = new Object;
			obj.protocol = "imok";
			obj.userIdx = userIdx;
			doSend(JSON.stringify(obj));
		}else if (evtObj.protocol === 'user connected') {
			console.log(coinType + ' 종목 conn data:::::', evtObj);

			checkedSendLinePacket = true;
			if (checkedLogin == true) {
				aleadySended = false;
				doSendLinePacket();
			}
		}else if (evtObj.protocol === 'startM') {
			setC(evtObj);
		}else if (evtObj.protocol === 'reM') {
			setC(evtObj);
		}
		let select = unitv;

	} catch (err) {
		console.log("[msg]" + protocol + ":" + err.message);
	}
}

function updateCoinSise(evt) {
	let coinFluctuation = evt;
	for (var k = 0; k < 5; k++) {
		longSise[k] = coinFluctuation[k];
		shortSise[k] = coinFluctuation[k];
	}
}

function onError(evt) {

}
function doSend(message) {
	websocket.send(message);
}

let websocketToWeb = null;
function initToWeb() {
	websocketToWeb = new WebSocket(wsUriToWeb);
	websocketToWeb.onopen = function(evt) {
		onOpenToWeb(evt);
	};

	websocketToWeb.onmessage = function(evt) {
		onMessageToWeb(evt);
	};

	websocketToWeb.onerror = function(evt) {
		onErrorToWeb(evt);
	};

	websocketToWeb.onclose = function(evt) {
		console.log("재접속");
		initToWeb();
	};
}
let recvGetPosition = false;
function onOpenToWeb(evt) {
	console.log("webserver open :" + userIdx);
	setTimeout(function() {
		if (recvGetPosition == false) {
//			console.log("정보 없음 에러");
		}
	}, 10000);
}

function onErrorToWeb(evt) {
	console.log("onErrorToWEb");
}

function doSendToWeb(message) {
	websocketToWeb.send(message);
}

function onMessageToWeb(evt) { // 받은 메세지를 보여준다
	let wpro = "none";
	try {
		let obj = JSON.parse(evt.data);
		wpro = obj.protocol;
		// console.log("obj : ", obj);

		if (obj.protocol == "warning") {
			if (obj.message == "noMoney") {
				showPopup(nonPointtext, 2);
				return;
			}
		} /*
			 * else if (obj.protocol == "symbolSise") { setSymbolList(obj); }
			 */else if (obj.protocol == "rest") {
			location.href = "/wesell/showRest.do";
		} else if (obj.protocol == "tradeM") {
			mdata[d.symbol].setM(obj.symbol, parseInt(obj.gap), parseFloat(obj.price));
			setC(obj.tArr, obj.symbol);
		} else if(obj.protocol == 'reC') {
			location.reload(true);
		}

		if (obj.protocol == "doLogin") {
			if (userIdx != null && userIdx != 'null' && userIdx != '') { // 로그인
				// 한 상태
				let obj = new Object;
				obj.protocol = "login";
				obj.userIdx = userIdx;
				//obj.game = "present";
				doSendToWeb(JSON.stringify(obj));
				checkedLogin = true;
			}
		}
//		console.log("protocol:" + obj.protocol + " " + obj.userIdx + " "
//				+ userIdx + " :: "
//				+ (parseInt(obj.userIdx) - parseInt(userIdx)));

		if (obj.protocol == "showPopup" && obj.msg == "wrongUser") {
			showPopupFromServer(obj.msg, obj.level);
		} else if (parseInt(obj.userIdx) == parseInt(userIdx)) {
			if (obj.protocol == "cancelAllOrder") {
				orderCancelResponse(obj.symbol);
			}

			if (obj.protocol == "update wallet") {
				updateWallet(obj);
			}
			if (obj.protocol == "update balance") {
				updateBalance(obj);
			}
			if (obj.protocol == "changeLeverageStart") {
				if(obj.positionRebuy == true)
					doSendToWeb(JSON.stringify(obj));
				for(var i = 0; i < obj.orderList.length; i++){
					for(var j = 0; j < preOrder[coinNum].length; j++){
						if(obj.orderList[i].orderNum == preOrder[coinNum][j][0]){
							preOrder[coinNum][j][6] = obj.orderList[i].paidVolume;
							$("."+obj.orderList[i].orderNum).find(".paidVolume").html(obj.orderList[i].paidVolume);
							break;
						}
					}
				}
				setLeverage(getSymbolType(coinNum), obj.leverage);
			}
			if (obj.protocol == "changeLeverageBuy") {
				let position = obj.position;
				assetPercent(0.95);
				popType(position, true);
				buy("market");
			}
			if (obj.protocol == "closeInfo") {
				showPopup(liqText, 1);
			}

			if (obj.protocol == "position set") {
				recvGetPosition = true;
				setPosition(obj);
			}
			if (obj.protocol == "remove Position") {
				removePosition(obj);
			}
			if (obj.protocol == "initOrderAndPosition") {
				if (positionList[0].length == 0) {
					for (var k = 0; k < obj.plist.length; k++) {
						setPosition(obj.plist[k]);
					}
				}
				for (var k = 0; k < obj.olist.length; k++) {
					setOrder(obj.olist[k]);
				}
			}
			if (obj.protocol == "order set") {
				setOrder(obj);
			}
			if (obj.protocol == "order remove") {
				removeOrder(obj);
			}
			if (obj.protocol == "order update") {
				$("."+obj.orderNum+" .orderFT").html(obj.conclusionQuantity + "/" + obj.buyQuantity)
//				$("#filledtotal" + obj.orderNum).html(
//						obj.conclusionQuantity + "/" + obj.buyQuantity);
//				$("#m_filledtotal" + obj.orderNum).html(
//						obj.conclusionQuantity + "/" + obj.buyQuantity);
			}
			if (obj.protocol == "showPopup") {
				if(obj.msg=="kycPop") 
					location.href='/wesell/user/kycCenter.do';
				else
					showPopupFromServer(obj.msg, obj.level);
			}

			if (obj.protocol == "liqAlert") {
				appendLiqPop(obj);
			}
			
			if (obj.protocol == "updateTPSL") {
				updateTPSL(obj);
			}
		}
	} catch (err) {
		console.log("[protocol]" + wpro + " " + err.message);
	}
}

let mdata = {
		BTC: new m('BTC'),
		ETH: new m('ETH'),
		XRP: new m('XRP'),
		TRX: new m('TRX'),
		DOGE: new m('DOGE'),
		LTC: new m('LTC'),
		SAND: new m('SAND'),
		ADA: new m('ADA'),
		GMT: new m('GMT'),
		APE: new m('APE'),
		GALA: new m('GALA'),
		ROSE: new m('ROSE'),
		KSM: new m('KSM'),
		DYDX: new m('DYDX')
};
let tA = {
	BTC: [],
	ETH: [],
	XRP: [],
	TRX: [],
	DOGE: [],
	LTC: [],
	SAND: [],
	ADA: [],
	GMT: [],
	APE: [],
	GALA: [],
	ROSE: [],
	KSM: [],
	DYDX: []
};

let cPr = {
	BTC: null,
	ETH: null,
	XRP: null,
	TRX: null,
	DOGE: null,
	LTC: null,
	SAND: null,
	ADA: null,
	GMT: null,
	APE: null,
	GALA: null,
	ROSE: null,
	KSM: null,
	DYDX: null
};

let cT = {
	BTC: [],
	ETH: [],
	XRP: [],
	TRX: [],
	DOGE: [],
	LTC: [],
	SAND: [],
	ADA: [],
	GMT: [],
	APE: [],
	GALA: [],
	ROSE: [],
	KSM: [],
	DYDX: []
};

let cnt = 4;

function m(sy) {
	this.t = 0;
	this.idv = 0;
	this.ind = 0;
	this.s = sy;
	this.re = false;
	this.run = false;
	this.c = 0;
	this.setM = function (sb, ind, tp) {
		this.t = tp;
		if (cPr[sb] < tp) {
			this.ind = ind;
		} else if (cPr[sb] > tp) {
			this.ind = ind*(-1);
		}
		this.idv = 0;
		this.re = false;
		this.c = 0;
	};
	this.prgM = function (p, sym, t) {
		this.pr = p;
		if( this.run === false || this.s !== sym ) {return}
		if( this.re === false){
			if( this.ind < 0 ){
				this.idv += this.ind;
				if( this.pr + this.idv < this.t ){
					this.re = true;
				}
			}else{
				this.idv += this.ind;
				if( this.pr + this.idv > this.t ){
					this.re = true;
				}
			}
		}else{
			this.idv += this.ind *-1;
			if( this.ind < 0 && this.idv > 0 ) {
				this.run = false;
			}else if( this.ind > 0 && this.idv < 0 )  {
				this.run = false;
			}
		}
		//console.log(this.pr, this.ind, this.idv, this.re, new Date(t).toLocaleString(), new Date(t).getMilliseconds());
		this.pr = this.pr + this.idv;
		let fnum = getSymbolFixedNum(sym);
		this.pr = parseFloat((this.pr).toFixed(fnum));
	};
}

function setC(o) {
	tA[o.s] = o.t;
	if(o.pm == 0) {
		mdata[o.s].setM(o.s, o.g, o.p);
		let f = cT[o.s].indexOf(tA[o.s][tA[o.s].length-1]); // 일치하는 부분부터 자르기	
		if (!f) {
			for(i=1; i<tA[o.s].length; i++) {         
				f = cT[o.s].indexOf(tA[o.s][tA[o.s].length-1-i]);
			}
		}
		mdata[o.s].c = cT[o.s].slice(f+1).length;
		if(mdata[o.s].c >= cnt) {
		}else if(!f && cT[o.s][ct[o.s].length-1] > tA[o.s][tA[o.s].length-1]){
			mdata[o.s].c = cnt;
		}
	} else {
		mdata[o.s].re = o.r;
		mdata[o.s].t = o.p;
		let cv;
		let f = cT[o.s].indexOf(tA[o.s][tA[o.s].length-1]); // 일치하는 부분부터 자르기	
		if (!f) {
			for(i=1; i<tA[o.s].length; i++) {         
				f = cT[o.s].indexOf(tA[o.s][tA[o.s].length-1-i]);
			}
		}
		cv = cT[o.s].slice(f+1).length;
		if(!f && cT[o.s][ct[o.s].length-1] > tA[o.s][tA[o.s].length-1]){
			cv = cnt;
		}
		if(cv == 0) {
			mdata[o.s].c = cnt;
			mdata[o.s].idv = o.pm;
		} else {
			mdata[o.s].c = cv;
			mdata[o.s].idv = o.pm+cv*(o.a);
		}
		mdata[o.s].ind = o.a;
		
	}
	mdata[o.s].run = true;
}