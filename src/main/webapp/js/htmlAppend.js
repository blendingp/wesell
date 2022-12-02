//////////////////////////html 생성 함수///////////////////////////////
function appendOrder(orderNum,symbol,position,positionText,filledtotal,marginText,orderPrice,orderTime,txtId){
	let cnum = getCoinNum(symbol);
	let txt = "<div class='positionlistblock "
		+ orderNum
		+ "' style='justify-content:space-between;'> <div class='positiononfo'>"
		+ symbol
		+ "</div> <div class='positiononfo "
		+ position
		+ "'>"
		+ positionText
		+ "</div> <div class='positiononfo orderFT'>"
		+ filledtotal
		+ "</div> <div class='positiononfo paidVolume'>"
		+ marginText
		+ "</div> <div class='positiononfo'>"
		+ orderPrice
		+ "</div> <div class='positiononfo' style='text-align:center;'>"
		+ orderTime
		+ "</div> <div class='p_cancle' style='cursor:pointer;' onclick='cancel(\""
		+ orderNum + "\")'> <div class='positiononfo_cancle'>" + canceltext
		+ "</div> </div> </div>";
	$("#" + txtId + cnum).append(txt);
}
function showPopup(msg, level) { // msg:팝업 메세지 , level: 1-완료 2-미완료 3-아이콘 없음
	let txt = "";
	let id = "binancenoti-n" + Date.now();
	let image = "";
	if (level == 1) {
		image = "<img src=\"/global/webflow/images/check.png\" loading=\"lazy\" class=\"image-39\">";
	} else if (level == 2) {
		image = "<img src=\"/global/webflow/images/error.png\" loading=\"lazy\" class=\"image-39\">";
	}
	txt += "<div class=\"order_warn\" id=\"" + id
			+ "\" style=\"margin-bottom:20px;\"><div class=\"order_success\" style=\"display:flex;\">";
	txt += image;
	txt += "<div class=\"text-block-72\">" + msg + "</div>";
	txt += "</div></div>";
	$(".utillitypop").css("display", "flex");
	$(".utillitypop").append(txt);

	setTimeout('$("#' + id + '").animate({opacity: "0"}, 1000)', 1000);
	setTimeout('$("#' + id + '").remove()', 2000);
}

function showPopupFromServer(msgp, level) { // msg:팝업 메세지 , 1-완료 2-미완료 3-아이콘 없음

	let msg = $("." + msgp).html();
	if (typeof msg == "undefined")
		msg = msgp;

	showPopup(msg, level);
}
function appendLiqPop(obj){
	var position = obj.position;
	var symbol = obj.symbol;
	var prate = toFixedDown(obj.profit / obj.margin * 100,2);
	var prateClass = "down";
	var plus = "";
	var lever = obj.leverage;
	var back = "";
	
	if($(".settle-complete").length != 0){
		back = "background-color:rgba(0, 0, 0, 0)";
	}
	
	if(prate >= 0){
		prateClass = "up";
		plus="+";
	}
	var marginText = crosstext;
	if(obj.marginType == "iso")
		marginText = isotext;
	
	var entry = obj.entryPrice;
	var liq = obj.liqPrice;
	
	var text = "<div class='settle-complete' id='settlePop' style='display:flex; z-index:15; "+back+"'> <div class='settle-complete__box'> <div class='div-block-84'> <div class='pop_yieldtxt " +
		prateClass+"'>" +
		plus+prate+"%<br> <span class='text-span-12'>" +
		yieldtext+"</span> </div> <img src='/global/webflow/images/sub_logo1.svg' sizes='100vw' class='image-68'> </div> <div class='div-block-124'> <div class='div-block-85'> <div class='qet'>" +
		cointext+"</div> <div class='dqr'>" +
		symbol+" <span class='position_color " +
		position+"'>" +
		position.toUpperCase()+"</span> </div> </div> <div class='div-block-85'> <div class='qet'>" +
		levText+"</div> <div class='dqr'>" +
		marginText+" "+lever+"x</div> </div> <div class='div-block-85'> <div class='qet'>" +
		entryPriceText+"</div> <div class='dqr'> " +
		fmtNum(entry)+"<span class='wr'> USDT</span> </div> </div> <div class='div-block-85'> <div class='qet'>" +
		lPricetext+"</div> <div class='dqr'> " +
		fmtNum(liq)+"<span class='wr'> USDT</span> </div> </div> </div> <a href='#' onclick='$(this).parent().parent().remove();' class='popx w-inline-block'><img src='images/wx.png' loading='lazy' srcset='/global/webflow/images/wx.png' sizes='100vw' class='popximg'></a> </div> </div>";
	$("#settlePop").append(text);
}
function pileTHHtml(text, trade){
	text += "<div class='markettrade_box'> <div class='markettradelist'> <div class='trademarket_txtbox " +
	trade.type + "'>" +
	trade.price + "</div> <div class='trademarket_txtbox'>" +
	trade.q +"</div> <div class='trademarket_txtbox time'>" +
	trade.time +"</div> </div> </div>";
	return text;
}