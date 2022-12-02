<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<div class="influ_top">
	<div class="mob_sidebtn" onclick="$('.influ_block2 , .mobbackdark').css('display' , 'block');">
		<img src="/global/webflow/images/Menu_icon.png" loading="lazy" alt="" class="image-52">
	</div>
	<a href="javascript:getProfitImage()" class="button-23 w-button">수익인증</a>&ensp;
	<a href="/global/infl/logout.do" class="button-23 w-button">로그아웃</a>
</div>
<div class="settle-complete" id="settlePop" style="display: none; z-index: 15; letter-spacing: -0.5px; font-family:'Nanumsquareotf ac', sans-serif;">
	<div class="body-2 settle-complete__box">
		<div class="div-block-84">
			<div class="pop_yieldtxt up">
				<span id="pop_profit">52.26%</span><span class="text-span-12">Profit Rate</span>
			</div>
			<img src="/global/webflow/images/sub_logo1.svg" loading="lazy" alt=""
				class="image-68">
		</div>
		<div class="div-block-124">
			<div class="div-block-85">
				<div class="qet">Coin</div>
				<div class="dqr">
					<span id="pop_sym">BTCUSDT</span> <span class="position_color long"><span id="pop_pos">LONG</span></span>
				</div>
			</div>
			<div class="div-block-85">
				<div class="qet">Leverage</div>
				<div class="dqr"><span id="pop_mtype">ISO</span> <span id="pop_lev">34</span>x</div>
			</div>
			<div class="div-block-85">
				<div class="qet">Entry Price</div>
				<div class="dqr">
					<span id="pop_entry"></span><span class="wr"> USDT</span>
				</div>
			</div>
			<div class="div-block-85">
				<div class="qet">Liquidation Price</div>
				<div class="dqr">
					<span id="pop_liq"></span><span class="wr"> USDT</span>
				</div>
			</div>
		</div>
		<a href="#" onclick="$('#settlePop').css('display','none');"
			class="popx w-inline-block"><img
			src="/global/webflow/images/wx.png" loading="lazy" sizes="100vw"
			alt="" class="popximg"></a>
	</div>
	<br>
	<div style="margin-left:100px; width:min-content; color:black;">
		<input class="popupInput" conid="pop_profit" type="text" placeholder="수익률" style="margin-top:10px;">
		<input class="popupInput" conid="pop_sym" type="text" placeholder="코인" style="margin-top:10px;">
		<input class="popupInput" conid="pop_pos" type="text" placeholder="포지션" style="margin-top:10px;">
		<input class="popupInput" conid="pop_mtype" type="text" placeholder="격리" style="margin-top:10px;">
		<input class="popupInput" conid="pop_lev" type="text" placeholder="레버리지" style="margin-top:10px;">
		<input class="popupInput" conid="pop_entry" type="text" placeholder="진입가" style="margin-top:10px;">
		<input class="popupInput" conid="pop_liq" type="text" placeholder="청산가" style="margin-top:10px;">
	</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	function getProfitImage(){
		$("#settlePop").css("display","flex");
	}
	$(".popupInput").on("input", function() { // 주문 수량 입력 체크
		var conid = $(this).attr("conid");
		$("#"+conid).text($(this).val());
		
		if(conid=="pop_pos" && $(this).val() == "SHORT"){
			$(".position_color").removeClass("long");
			$(".position_color").addClass("short");
		}else if(conid=="pop_pos" && $(this).val() == "LONG"){
			$(".position_color").removeClass("short");
			$(".position_color").addClass("long");
		}
	});
</script>
</html>