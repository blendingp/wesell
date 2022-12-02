function pileTHHtml(text, trade){
	text += "<div class='markettrade_box'> <div class='markettradelist'> <div class='trademarket_txtbox " +
	trade.type + "'>" +
	trade.price + "</div> <div class='trademarket_txtbox'>" +
	trade.q +"</div> <div class='trademarket_txtbox time'>" +
	trade.time +"</div> </div> </div>";
	return text;
}

function showPopup(msg, level) { // msg:팝업 메세지 , level: 1-완료 2-미완료 3-아이콘 없음
	$("#dealpop").css("display", "none");
	
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
	$("#alertpop").css("display", "flex");	
	$(".utillitypop").append(txt);

	setTimeout('$("#' + id + '").animate({opacity: "0"}, 1000)', 1000);
	setTimeout('$("#' + id + '").remove()', 2000);
	setTimeout('$("#alertpop").css("display", "none");	', 2000);
}

function showPopupFromServer(msgp, level) { // msg:팝업 메세지 , 1-완료 2-미완료 3-아이콘 없음

	let msg = $("." + msgp).html();
	if (typeof msg == "undefined")
		msg = msgp;

	showPopup(msg, level);
}

//주문등록
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
