<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--  Last Published: Tue Jun 29 2021 05:48:49 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="60790fc3c99a1ad29273c803" data-wf-site="6073d35203881b197a7cdb93">
<head>
<meta charset="utf-8">
<title><spring:message code="menu.message"/></title>
<meta content="account setting" property="og:title">
<meta content="account setting" property="twitter:title">
<jsp:include page="../userFrame/header.jsp"></jsp:include>
<style>
.message-pop__content::-webkit-scrollbar {
width:7px;
}
.message-pop__content::-webkit-scrollbar-thumb {
border-radius: 50px;
background-color: transparent;
}
.message-pop__content::-webkit-scrollbar-track {
border-radius: 50px;
background-color: transparent;
}
.message-pop__content::-webkit-scrollbar-button {
width: 0;
height: 0;
}
</style>
</head>
<body style="height:100%">
  <div class="all" style="height:100%">
    <jsp:include page="../userFrame/top.jsp"></jsp:include>
    <div class="body3" style="min-height: calc(100% - 297px);">
	  <div class="refer1">
        <div class="refermenu">
          <div class="rewardmlist click" onClick="location.href='/global/user/message.do'">
			<div class="rewardmlisttext"><spring:message code="menu.message"/></div>
			<img src="webflow/images/right_icon.png" loading="lazy" alt="" class="cusarrow" style="display:none;">
		  </div>
        </div>
      </div>
      <div class="refer2">
        <div class="custitle"><spring:message code="menu.message"/></div>
        <div class="notimainbox2">
          <div class="notibody">
            <div class="notimain2">
              <div class="notilistbox2">
              	<c:forEach  var="item" items="${list}" varStatus="i">
              		<c:if test="${item.mread eq 0}">
		                <div class="searlistbox2-copy" id="msg${item.idx}" onclick="readMessage(${item.idx}, '${item.content}')" style="background-color:lemonchiffon; cursor: pointer;">
		                  <div class="div-block-62">
		                    <div class="text-block-48 midx">0</div>
		                    <div class="searlisttitle-copy" id="msgtitle${item.idx}">${item.title}</div>
		                    <div class="support-copy" id="msgdate${item.idx}"><fmt:formatDate value="${item.mdate}" pattern="yyyy-MM-dd HH:mm"/></div>
		                  </div>
		                </div>
              		</c:if>
              		<c:if test="${item.mread ne 0}">
						<div class="searlistbox2-copy" id="msg${item.idx}" onclick="readMessage(${item.idx}, '${item.content}')" style="cursor: pointer;">
		                  <div class="div-block-62">
		                    <div class="text-block-48 midx">0</div>
		                    <div class="searlisttitle-copy" id="msgtitle${item.idx}">${item.title}</div>
		                    <div class="support-copy" id="msgdate${item.idx}"><fmt:formatDate value="${item.mdate}" pattern="yyyy-MM-dd HH:mm"/></div>
		                  </div>
		                </div>
              		</c:if>
              	</c:forEach>
              </div>
            </div>
          </div>
          <div class="listpagebox2">
            <ui:pagination paginationInfo="${pi}" type="customPageUser" jsFunction="fn_egov_link_page"/>
          </div>
          <form name="listForm" id="listForm" action = "/global/user/message.do">
			<input type="hidden" name="pageIndex" />
		  </form>
        </div>
      </div>
    </div>
    <jsp:include page="../userFrame/footer.jsp"></jsp:include>
    <div class="message-pop" id="messagepop" style="display:none;">
      <div class="message-pop__box">
        <div class="message-pop__xbox">
          <a href="javascript:readPopClose()" class="message-pop__a w-inline-block"><img src="../images/x.png" loading="lazy" srcset="../images/x-p-500.png 500w, ../images/x-p-800.png 800w, ../images/x-p-1080.png 1080w, ../images/x.png 1600w" sizes="(max-width: 767px) 4vw, (max-width: 991px) 2vw, 16px" alt="" class="message-pop__img"></a>
        </div>
        <div class="message-pop__a__cbox">
          <div class="message-pop__titlebox">
            <div class="message-pop__title" style="line-break:anywhere;">Lorem ipsum dolor sit amet,Lorem ipsum dolor sit amet,</div>
            <div class="message-pop__date">may 20, 2020</div>
          </div>
          <div class="message-pop__content" style="line-break:anywhere;">This is some text inside of a div block. This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a divblock.This is some text inside of a div block.This is some text inside of a div block. This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a div block.This is some text inside of a div block.This is some text is some text inside of a div block.This is some text inside of a div block.This is some text is some text inside of a div block.This is some text inside of a div block.This is some text is some text inside of a div block.This is some text inside of a div block.This is some text is some text inside of a div block.This is some text inside of a div block.This is some text is some text inside of a div block.This is some text inside of a div block.This is some text is some text inside of a div block.This is some text inside of a div block.This is some text is some text inside of a div block.This is some text inside of a div block.This is some text </div>
        </div>
        <div class="message-pop__btnbox">
          <a href="javascript:readPopClose()" class="message-pop__btn w-button"><spring:message code="pop.withdrawRequest_5"/></a>
        </div>
      </div>
    </div>
	</div>
	<script
		src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.5.1.min.dc5e7f18c8.js?site=6073d35203881b197a7cdb93"
		type="text/javascript"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<script src="/global/webflow/js/webflow.js" type="text/javascript"></script>
	<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
</body>
<script>
function fn_egov_link_page(page){
	document.listForm.pageIndex.value = page;
	document.listForm.submit();
}

function setRecordIndex(){
	var count = "${pi.totalRecordCount}";
	var page = "${(pi.currentPageNo-1)* 10}";
	var idx = Number(count)-Number(page);
	$.each($(".midx"),function(index,item){
		$(".midx").eq(index).html(idx--);
	});
}
setRecordIndex();

var reading = false;
function readMessage(idx,content){
	if(reading) return;
	reading = true;
	var url = "/global/user/readMessage.do";
	$.ajax({
		type:'post',
		url : url,
		data: {"idx":idx},
		success:function(data){
			isUnreadMessage();
			reading = false;
			if(data.result == 'success'){
				$("#msg"+idx).css("background-color","");
				readPop(idx,content);
			}
		},
		error:function(e){
			console.log('ajaxError' + e);
		}
	});
}

function readPop(idx,content){
	$("#messagepop").css("display","flex");
	$(".message-pop__title").html($("#msgtitle"+idx).html());
	$(".message-pop__date").html($("#msgdate"+idx).html());
	$(".message-pop__content").html(content);
}

function readPopClose(){
	$("#messagepop").css("display","none");
}
</script>
</html>