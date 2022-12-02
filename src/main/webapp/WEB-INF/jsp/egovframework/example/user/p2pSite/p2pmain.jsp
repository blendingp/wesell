<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html data-wf-page="618388aa32debe327ad0f06c"
	data-wf-site="6180a71858466749aa0b95bc">
<head>
<meta charset="utf-8">
<jsp:include page="../../p2pSiteFrame/header.jsp"></jsp:include>
</head>
<body class="body">
	<div class="frame">
		<jsp:include page="../../p2pSiteFrame/top.jsp"></jsp:include>

		<div class="banner m"
			style="background-image: url(/global/webflow/p2pImages/header01.png);">
			<div class="banner_warp">
				<div class="m_head_box">
					<img src="/global/webflow/p2pImages/LOGO_white1.svg" loading="lazy" alt="" class="banner_logo">
					<h1 class="m_head">빠르고 쉽게 테더 거래를 진행하세요</h1>
					<h2 class="m_head _3"> 글로벌 거래소 비트오션 공식 파트인<br> </h2>
					<h4 class="m_head _2">
						Easy Exchange에서 별도의 회원가입 없이 바로 거래가가능합니다.<br>거래 시 비트오션의 UID,
						전화번호, 성함을 입력하시면 구매 즉시 비트오션 계좌로 <br>테더가 입금됩니다.
					</h4>
				</div>
				<div class="m_c_box">
					<div class="m_c_btn_warp">
						<a href="#" onclick="typeChange(0)" class="m_c_btn p2pon p2pon0 w-button">구매</a> 
						<a href="#" onclick="typeChange(1)" class="m_c_btn p2pon p2pon1 w-button">판매</a>
					</div>
					<div class="form-block w-form">
						<div class="m_c_block">
							<div class="m_c_select">
								<img src="/global/webflow/images/USDTicon.png" loading="lazy" alt="" class="m_c_icon">
								<div>USDT</div>
							</div>
						</div>
						<div class="m_c_cointxt"> 1 USDT = <span class="point_txt"><span id="lowPrice"></span> KRW </div>
						<div class="m_c_title">구매금액 : <span id="inPriceText">0</span> <span class="coinUnit">KRW</span></div>
						<div class="m_c_block">
							<input type="text" class="text-field w-input" maxlength="20" placeholder="금액을 입력해주십시오" id="inPrice">
							<a href="#" class="m_c_sub_btn w-button"><span class="coinUnit">KRW</span></a>
						</div>
						<div class="m_c_title">예상 수령 <span class="coinUnit_2">USDT</span></div>
						<div class="m_c_block">
							<input type="text" class="text-field w-input" placeholder="금액 작성시 자동 계산됩니다" id="resultCal" style="background-color:transparent;" readonly>
						</div>
						<a href="javascript:p2pLinkMove()" class="m_banner_btn w-button">오퍼찾기</a>
					</div>
				</div>
			</div>
		</div>
		<div class="m_section1 wf-section">
			<h1 class="m_section_title">나의 비트코인. 나의 경험.</h1>
			<h4 class="m_section_title _2">전 세계 사람들과 나만의 가격, 내 마음에 드는 결제수단으로 거래하세요.</h4>
			<div class="m_s1_itembox">
				<div class="m_s1_item">
					<img src="/global/webflow/p2pImages/qe_art.png" loading="lazy" class="m_s1_img">
					<div>다양한 오더 제공</div>
				</div>
				<div class="m_s1_item">
					<img src="/global/webflow/p2pImages/icon02.png" loading="lazy" class="m_s1_img">
					<div> 엄격한 심사를 통과한<br>인증된 판매자 </div>
				</div>
				<div class="m_s1_item">
					<img src="/global/webflow/p2pImages/icon03.png" loading="lazy" class="m_s1_img">
					<div> 판매자 지불능력 검증을 위한<br>사전 예치금 제도 실시 </div>
				</div>
			</div>
		</div>
		<div class="m_section2 wf-section">
			<h1 class="m_section_title"> 100%를 위한 금융 시스템에 오신 것을<br>환영합니다. </h1>
			<div class="m_s2_itembox">
				<div id="w-node-b713a475-f0e1-07d5-b0eb-7e21fa05bd02-9f8afc74" class="m_s2_item">
					<img src="/global/webflow/p2pImages/icon04.png" loading="lazy" alt="" class="m_s2_img">
					<div class="m_s2_title">비트코인 구매</div>
					<div> P2P거래 중계를 통한<br>확실하고 빠른 거래 진행 </div>
				</div>
				<div id="w-node-_892a94d7-8450-ab2d-caaa-9ac729df5dd0-9f8afc74" class="m_s2_item">
					<img src="/global/webflow/p2pImages/icon05.png" loading="lazy" alt="" class="m_s2_img">
					<div class="m_s2_title">비트코인 판매</div>
					<div> 판매자 지불 능력 검증 시스템을<br>통한 매칭 서비스 </div>
				</div>
				<div id="w-node-_93b59d6a-1eb1-32f3-ed66-318fec8ef3b2-9f8afc74" class="m_s2_item">
					<img src="/global/webflow/p2pImages/icon06.png" loading="lazy" alt="" class="m_s2_img">
					<div class="m_s2_title">안전한 거래</div>
					<div> 암호 화폐는 거래가 완전히 끝날 때까지<br>안전 에스크로에 보관됩니다. </div>
				</div>
				<div id="w-node-a5302fc3-1494-06d1-67c2-b9ae8d7c898e-9f8afc74" class="m_s2_item">
					<img src="/global/webflow/p2pImages/icon07.png" loading="lazy" alt="" class="m_s2_img">
					<div class="m_s2_title">귀중한 피드백</div>
					<div>
						Easy-Exchange피드백 시스템은 믿을 수 있으며 <br>경험 많은 사용자를 강조하여, 원활하게 거래하실
						수 있도록 돕습니다.
					</div>
				</div>
				<div id="w-node-_5513494b-9fb3-e1ea-85dc-911e1d8b5c4f-9f8afc74" class="m_s2_item">
					<img src="/global/webflow/p2pImages/icon08.png" loading="lazy" alt="" class="m_s2_img">
					<div class="m_s2_title">파트너사 직접 전송</div>
					<div>파트너사 회원분들의 편의성을 위해 별도의 가입 없이 이용중이신 거래소 정보만으로고 빠르고 안전하게 거래가 가능합니다.</div>
				</div>
				<div id="w-node-b7156a1d-e35e-72b7-5591-32178fec4461-9f8afc74" class="m_s2_item">
					<img src="/global/webflow/p2pImages/icon09.png" loading="lazy" alt="" class="m_s2_img">
					<div class="m_s2_title">친구 초대</div>
					<div>
						친구와 가족이 <br>Easy-Exchange에 <a href="https://bitocean-global.com/global/join.do" target="_blank" class="link_color">가입</a>하도록
						도와주세요.
					</div>
				</div>
			</div>
		</div>
		<div class="m_section3 wf-section">
			<div class="m_head_box">
				<h1 class="m_head"> 시작할 준비가 되셨나요?<br> </h1>
				<h4 class="m_head _2">수 천 개의 비트코인 구매/판매 오퍼를 살펴보면서 트레이딩 여행을 시작하세요.</h4>
				<a href="#" class="m_btn w-button">오퍼찾기</a>
			</div>
			<img src="/global/webflow/p2pImages/backbox_art.png" loading="lazy" srcset="/global/webflow/p2pImages/backbox_art-p-500.png 500w, /global/webflow/p2pImages/backbox_art.png 549w" sizes="(max-width: 479px) 100vw, 400.0000305175781px" alt="" class="m_s3_img">
		</div>
		<div class="m_section4 wf-section">
			<img src="/global/webflow/p2pImages/qe_art.png" loading="lazy" alt=""
				class="m_s4_img">
			<div class="m_head_box2">
				<h1 class="m_head"> 궁금한 게 있으신가요?<br> </h1>
				<h4 class="m_head _2">문의사항을 남겨 주시면 자세한 답변을 드리겠습니다.</h4>
				<a href="/global/easy/p2pCustomer.do" class="m_btn w-button">FAQ 및 고객센터</a>
			</div>
		</div>
		<jsp:include page="../../p2pSiteFrame/footer.jsp"></jsp:include>
	</div>
	<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6180a71858466749aa0b95bc" type="text/javascript" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script>
		let typeSelect;
		let inPrice=0;
		const lowPrice = new Array(Number("${lowBuy}"),Number("${lowSell}"));
		$(function(){
			$("#inPrice").on("input", function() {
				if(typeSelect == 0)
					SetNum(this);
				else
					setDouble(this,2);
				
				let val = Number($(this).val());
				if(!isNaN(val)){
					inPrice = val;
				}
				$("#inPriceText").text(fmtNum(inPrice));
				
				if(val == 0){
					$("#resultCal").val("");
				}else{
					if(typeSelect == 0)
						$("#resultCal").val(fmtNum((val/lowPrice[typeSelect]).toFixed(2)));
					else
						$("#resultCal").val(fmtNum((val*lowPrice[typeSelect]).toFixed(0)));
				}
				
			});
			typeChange(0);
		});
		
		function typeChange(type){
			if(type == typeSelect) return;
			
			$(".p2pon").removeClass("on");
			$(".p2pon"+type).addClass("on");
			
			typeSelect = type;
			$("#lowPrice").text(fmtNum(lowPrice[typeSelect]));
			if(type == 0){
				$(".coinUnit").text("KRW");
				$(".coinUnit_2").text("USDT");
			}else{
				$(".coinUnit").text("USDT");
				$(".coinUnit_2").text("KRW");
			}
			$("#inPrice").val("");
			$("#inPrice").trigger("input");
		}
		
		function p2pLinkMove(){
			if(typeSelect == 0)
				location.href="/global/easy/p2pbuy.do";
			else
				location.href="/global/easy/p2psell.do";
		}
	</script>
</body>
</html>