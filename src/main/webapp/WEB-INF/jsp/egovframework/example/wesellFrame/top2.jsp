<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<style>
.not_scroll{
    overflow: hidden;
}
.button-3.w-button{
    margin-left: 20px;
    margin-right: 20px;
}
</style>
	<div class="top">
		<div class="topblock">
			<div class="mob_sidebtn" onclick="mobMenu()"><img src="/wesell/webflow/images2/menu_square_white.svg" loading="lazy" alt="" class="image-44"></div>
			<div class="logoblock" onclick="location.href='/wesell/user/main.do'">
				<img src="/wesell/webflow/images2/wesell_logo.svg" class="logo">
			</div>
			<div class="top_menubtnlist">
				<div class="topmenubtn">
					<a href="/wesell/user/chart.do" class="topbtn <c:if test="${currentP eq 'trade'}">click</c:if> w-button"><spring:message code="trade.trade"/></a>
				</div>
				<div class="topmenubtn">
					<img src="/wesell/webflow/images2/more_icon3.svg" loading="lazy" alt="" class="top_arrow">
 					<a onclick="dropToggle(this)" href="#" class="topbtn <c:if test="${currentP eq 'wallet'}">click</c:if> w-button"><spring:message code="menu.depandwith"/></a> 
					<div class="topbtn_drop">
						<a href="https://the-safe.net/" class="button-14-copy w-button"><spring:message code="wallet.deposit"/></a> 
						<a href="https://the-safe.net/" class="button-14-copy w-button"><spring:message code="wallet.withdrawal"/></a>
						<a href="https://the-safe.net/" class="button-14-copy w-button"><spring:message code="wallet.DeandWithHistory_m"/></a> 
						<a href="https://the-safe.net/" class="button-14-copy w-button"><spring:message code="wallet.menu.exchange"/></a> 
						<a href="https://the-safe.net/" class="button-14-copy w-button"><spring:message code="wallet.futuresExchange"/></a> 
						<a href="https://the-safe.net/" class="button-14-copy w-button"><spring:message code="wallet.withdrawallist"/></a> 
					</div>
				</div>
				<div class="topmenubtn tall">
					<img src="/wesell/webflow/images2/more_icon3.svg" loading="lazy" alt="" class="top_arrow">
 					<a onclick="dropToggle(this)" href="#" class="topbtn <c:if test="${currentP eq 'customer'}">click</c:if> w-button"><spring:message code="menu.support"/></a> 
					<div class="topbtn_drop tall">
						<a href="/wesell/customerService.do" class="button-14-copy w-button"><spring:message code="menu.support" /></a> 
						<a href="/wesell/notice.do" class="button-14-copy w-button"><spring:message code="menu.notice" /></a> 
						<a href="/wesell/faq.do" class="button-14-copy w-button"><spring:message code="newwave.menu.faq"/></a> 
						<a href="/wesell/user/helpCenter.do" class="button-14-copy w-button"><spring:message code="submitRequest" /></a> 
					</div>
					<%-- <a href="#" class="button-3 w-button servicep"><spring:message code="menu.support"/></a> --%>
				</div>
			</div>
			<div class="top_leftblock">
             	<c:if test="${userIdx eq null}">
					<a href="/wesell/login.do" class="loginbtn <c:if test="${currentP eq 'login'}">click</c:if> w-button"><spring:message code="menu.login"/></a>
					<a href="/wesell/join.do" class="registbtn <c:if test="${currentP eq 'join'}">click</c:if> w-button"><spring:message code="menu.register"/></a>
				</c:if>
           		<c:if test="${userIdx ne null}">
           			<a href="/wesell/user/myInfo.do" class="registbtn <c:if test="${currentP eq 'myInfo'}">click</c:if> w-button"><spring:message code="join.info"/></a> 
           			<a href="javascript:logout()" class="registbtn w-button"><spring:message code="menu.logout"/></a>
           		</c:if>
				<div class="topmenubtn2">
                	<a class="languagebtn w-button">
                		<c:if test="${lang eq null || lang eq 'EN'}">English</c:if>
                		<c:if test="${lang eq 'KO'}">한국어</c:if>
                		<c:if test="${lang eq 'JP'}">日本語</c:if>
                		<c:if test="${lang eq 'CH'}">简体中文</c:if>
                		<c:if test="${lang eq 'FC'}">Français</c:if>
                	</a><img src="/wesell/webflow/images2/more_icon3.svg" loading="lazy" alt="" class="top_arrow">
	                <div class="topbtn_drop">
	                  <a href="javascript:changeLang2('EN')" class="button-14-copy w-button">English</a>
	                  	<a href="javascript:changeLang2('KO')" class="button-14-copy w-button">한국어</a>
	                  <a href="javascript:changeLang2('JP')" class="button-14-copy w-button">日本語</a>
	                  <a href="javascript:changeLang2('CH')" class="button-14-copy w-button">简体中文</a>
	                  <a href="javascript:changeLang2('FC')" class="button-14-copy w-button"><strong>Français</strong></a>
	                </div>
	             </div> 
			</div>
		</div>
	</div>
	<div class="mob_asidepop" id="mobMenu" onclick="mobMenu()" style="z-index:99; display:none;">
		<div class="mob_asidepop_block">
			<div class="aside_profile">
				<div class="asidewarp">
					<c:if test="${userIdx ne null}">
						<img src="/wesell/webflow/images2/account_1white.svg" loading="lazy" alt="" class="image-44">
						<div class="text-block-17">
							<span class="profilename">${userName } </span><spring:message code="menu.nim"/>
						</div>
					</c:if>
					<c:if test="${userIdx eq null}">
						<div class="text-block-17" onclick="location.href='/wesell/login.do'">
							<span><spring:message code="menu.login"/></span>
						</div>
					</c:if>
				</div>
				<c:if test="${userIdx ne null}">
					<div class="text-block-21" onclick="location.href='/wesell/user/myInfo.do'"><spring:message code="join.info"/></div>
				</c:if>
			</div>
			<div class="asideblock">
				<div class="asidelist" onclick="location.href='/wesell/user/main.do'">
					<div><spring:message code="menu.main"/></div>
				</div>
				<div class="asidelist additionalbtn">
					<div><spring:message code="menu.deal"/></div>
					<img src="/wesell/webflow/images2/arrow_up.svg" loading="lazy" alt="" class="image-45 menuarrow" style="transform: rotate(0deg);">
				</div>
				<div class="asidelist" onclick="location.href='/wesell/trade.do?betMode=usdt'">
					<div><spring:message code="trade.trade"/></div>
				</div>
				<div class="asidelist additionalbtn">
					<div><spring:message code="menu.depandwith"/></div>
					<img src="/wesell/webflow/images2/arrow_up.svg" loading="lazy" alt="" class="image-45 menuarrow" style="transform: rotate(0deg);">
				</div>
				<div class="aasidedrop" style="display:none;">
					<div class="asidelist" onclick="location.href='https://the-safe.net/'"><spring:message code="wallet.deposit"/></div> 
					<div class="asidelist" onclick="location.href='https://the-safe.net/'"><spring:message code="wallet.withdrawal"/></div>
					<div class="asidelist" onclick="location.href='https://the-safe.net/'"><spring:message code="wallet.DeandWithHistory_m"/></div> 
					<div class="asidelist" onclick="location.href='https://the-safe.net/'"><spring:message code="wallet.menu.exchange"/></div> 
					<div class="asidelist" onclick="location.href='https://the-safe.net/'"><spring:message code="wallet.futuresExchange"/></div> 
					<div class="asidelist" onclick="location.href='https://the-safe.net/'"><spring:message code="wallet.withdrawallist"/></div> 
				</div>
				<div class="asidelist additionalbtn">
					<div><spring:message code="menu.support"/></div>
					<img src="/wesell/webflow/images2/arrow_up.svg" loading="lazy" alt="" class="image-45 menuarrow" style="transform: rotate(0deg);">
				</div>
				<div class="aasidedrop" style="display:none;">
					<div class="asidelist" onclick="location.href='/wesell/customerService.do'">
						<div><spring:message code="menu.support"/></div>
					</div>
					<div class="asidelist" onclick="location.href='/wesell/notice.do'">
						<div><spring:message code="menu.notice"/></div>
					</div>
					<div class="asidelist" onclick="location.href='/wesell/faq.do'">
						<div><spring:message code="menu.faq"/></div>
					</div>
					<div class="asidelist" onclick="location.href='/wesell/user/helpCenter.do'">
						<div><spring:message code="submitRequest"/></div>
					</div>
				</div>
			</div>
		</div>
	</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
	var lang = "${lang}";
	
	let exRate = 0;
	function getExchangeRate() {
		jQuery.ajax({
			type : 'get',
			url : '/wesell/getExchangeRate.do',
			async : false,
			success : function(data) {
				exRate = Number(data.exRate);
			}
		})
	}
	
	getExchangeRate();
	setInterval(getExchangeRate, 30000);
	
	function logout() {
		$.ajax({
			type : 'post',
			url : '/wesell/logoutProcess.do',
			success : function(data) {
				/* showPopup(data.msg, data.level); */
				if (data.result == 'success') {
					alert(data.msg);
					location.href = "/wesell/login.do";
				}
			}
		})

	}
	/* function changeLang() {
		var clang = "KO";
		if(lang == "KO")
			clang = "EN";
		else if(lang == "EN")
			clang = "JP";
		else if(lang == "JP")
			clang = "CH";
		else if(lang == "CH")
			clang = "FC";
		
		$.ajax({
			type : 'post',
			url : '/wesell/changeLanguage.do?lang=' + clang,
			success : function(data) {
				location.reload(true);
			}
		});
	} */
	
	function changeLang2(lang) {
		if(lang == "null")
			lang = "EN";
		
		$.ajax({
			type : 'post',
			url : '/wesell/changeLanguage.do?lang=' + lang,
			success : function(data) {
				location.reload(true);
			}
		});
	}
	

	function ready() {
		alert("<spring:message code='pop.ServiceReady_1'/>");
	}
	
	function menuShow(id){
		if($("#"+id).css("display")=="flex"){
			$("#"+id).css("display","none");
		}else{
			$("#"+id).css("display","flex");
		}
	}
	
	function toFixedDown(val,fix){
		if(isNaN(val)) return 0;
		
		var minus = false;
		if(val < 0)
			minus = true;
		
		var num = 1;
		for(var i = 0; i < parseFloat(fix); i++){
			num *= 10;
		}
		const temp1 = (Number(val) + Number.EPSILON) * num; 
		const temp2 = Math.floor(Math.abs(temp1));
		var result = temp2 / num;
		
		if( result < 1 / num)
			result = 0;
		if(minus)
			result *= -1;
		return result.toFixed(fix);
	}
	
	function datePickerLangSet(){
		if(lang == "KO"){
			$.datepicker.setDefaults({
		        dateFormat: 'yymmdd',
		        prevText: '이전 달',
		        nextText: '다음 달',
		        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		        showMonthAfterYear: true,
		        yearSuffix: '년'
		    });
		}
		$(function() {
		    $('.ui-datepicker').addClass('notranslate');
		});
	}
	
	function mobMenu(){
		if($("#mobMenu").css("display")=="none"){
			$("#mobMenu").css("display","flex");
			$("html, body").addClass("not_scroll");
		}else{
			$("#mobMenu").css("display","none");
			$("html, body").removeClass("not_scroll");
		}
	}
	$(function(){
		$(".topbtn").on("click",function(){
			if($(this).next().css("display") == "none"){
				$(".topbtn_drop").hide();
			}				
			$(this).next().slideToggle(200);
		});
		$(".topmenubtn2").click(function() {
			$(this).children(".topbtn_drop").slideToggle(200);
			$(this).children('img').toggleClass('open');
		});
		$(".mob_asidepop_block").on("click", function(e) {
			e.stopPropagation();
		});
		$(".additionalbtn").on(
				"click",
				function() {
					var upAngle = 180;
					if ($(this).next().css("display") == "none") {
						$(this).next().slideDown(200);
					} else {
						$(this).next().slideUp(200);
						upAngle = 0;
					}
					$(this).find(".menuarrow").css('transform',
							'rotate(' + upAngle + 'deg)');
				});
	});

	function dropToggle(node) {
		return;
		if ($(node).next().css("display") == "none") {
			$(".topbtn_drop").css("display", "none");
			$(node).next().css("display", "flex");
		} else {
			$(node).next().css("display", "none");
		}
	}

	function restrictAmount(a) {
		var regExp = /^\d*.?\d{0,5}$/;
		if (!regExp.test(a)) {
			return false;
		}
		return true;
	}
	function fmtNum(num) {
		if (num == null)
			return 0;
		num = String(num);
		if (num.length <= 3)
			return num;

		let
		decimalv = "";

		if (num.indexOf(".") != -1) {
			let
			numarr = num.split(".");
			num = numarr[0];
			decimalv = "." + numarr[1];
		}

		let
		len, point, str;
		let
		min = "";

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
</script>
</html>