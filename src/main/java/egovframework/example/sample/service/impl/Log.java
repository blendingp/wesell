package egovframework.example.sample.service.impl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.web.util.Send;

@Controller
public class Log {
	static public String projectName = "wesell";

	static public int DEBUGLEVEL = 6;
	static public boolean DEBUGTIME = true;
	static public String[] DEBUGFILTERALL = { "middleware", "24sise_detail", "test",
			"call", /* call 함수 흐름 로그 */
			"call_send", /* call 함수 흐름 로그 */
			"err", /* 에러 로그 */
			"err_notsend", /* 에러 로그 */
			"log", "evt", /* 가끔 나타나서 확인해줘야햐는 이벤트 관련 로그 */
			"logSise", /* 시세 업데이트마다 찍히는 로그 */
			"sise", "buyMarket", /* 시장가 구매 */
			"buyLimit", /* 지정가 구매 */
			"buyStopMarket", /* 스탑 시장가 구매 */
			"buyStopLimit", /* 스탑 지정가 구매 */
			"buyPositionCheck", /* 재구매 체크 */
			"buyProcess", /* 구매 프로세스 */
			"registerOrder", /* 주문 등록 - 지정가, 스탑 시장가, 스탑 지정가 */
			"updateBuyPosition", /* 포지션 추가 구매 */
			"updateSellPosition", /* 포지션 부분 청산 */
			"FundingFee", /* 펀딩비 */
			"liquidation", /* 강제 청산 */
			"sellMarket", /* 시장가 청산 */
			"sellLimit", /* 지정가 청산 */
			"sellProcess", /* 청산 프로세스 */
			"sellPartProcess", /* 부분 청산 프로세스 */
			"referells", /* 수수료 레퍼럴 */
			"qabuy", //구매를 QA하기 편하게 디버깅 로그 남긴것
			"changeLeverage", /* 레버리지변경 */
			"insertPosition",//포지션 추가 쿼리
			"withdrawCheck", /* 출금가능 잔액 체크 */
			"wallet", /* 입출금 로그 */
			"timecheck",
			"error3",
			"member",
			"inmoney",
			"system",
			"sendcheck", // sms, 메일 등 보낼때 내용과 연락처 로깅.
			"delaycheck",
			"interceptor",
			"positionList",
			"checkMoney",
			"logincheck",
			"withdraw",//송금 api 호출
			"siseCheck",
			"test",
			"copytrade",
			"query"
	};

//출금시 withdrawCheck
//지정가 구매 테스트시 buyLimit + buyProcess + sellProcess 같이 열기
//시장가 구매 테스트시 buyMarket , sellMarket buyProcess + sellProcess     
//강제청산 로직 liquid
//레버리지변경 changeLeverage
//err FundingFee  buyLimit 지정가구매  buyProcess 구매로직  sellProcess판매로직
//없앨것 sellLimit call updateBuyPosition test registerOrder  buyStopMarket updateBuyPosition
	static public String []DEBUGFILTERS= {
			"call", /* call 함수 흐름 로그 */
//			"call_send", /* call 함수 흐름 로그 */
			"err", /* 에러 로그 */
			"err_notsend", /* 에러 로그 */
//			"log", "evt", /* 가끔 나타나서 확인해줘야햐는 이벤트 관련 로그 */
//			"logSise", /* 시세 업데이트마다 찍히는 로그 */
//			"sise", "buyMarket", /* 시장가 구매 */
//			"buyLimit", /* 지정가 구매 */
//			"buyStopMarket", /* 스탑 시장가 구매 */
//			"buyStopLimit", /* 스탑 지정가 구매 */
//			"buyPositionCheck", /* 재구매 체크 */
//			"buyProcess", /* 구매 프로세스 */
//			"registerOrder", /* 주문 등록 - 지정가, 스탑 시장가, 스탑 지정가 */
//			"updateBuyPosition", /* 포지션 추가 구매 */
//			"updateSellPosition", /* 포지션 부분 청산 */
//			"FundingFee", /* 펀딩비 */
//			"liquidation", /* 강제 청산 */
//			"sellMarket", /* 시장가 청산 */
//			"sellLimit", /* 지정가 청산 */
//			"sellProcess", /* 청산 프로세스 */
//			"sellPartProcess", /* 부분 청산 프로세스 */
//			"referells", /* 수수료 레퍼럴 */
//			"qabuy", //구매를 QA하기 편하게 디버깅 로그 남긴것
//			"changeLeverage", /* 레버리지변경 */
//			"insertPosition",//포지션 추가 쿼리
//			"withdrawCheck", /* 출금가능 잔액 체크 */
//			"wallet", /* 입출금 로그 */
//			"timecheck",
//			"error3",
//			"member",
//			"inmoney",
//			"system",
//			"sendcheck", // sms, 메일 등 보낼때 내용과 연락처 로깅.
//			"delaycheck",
//			"interceptor",
//			"positionList",
//			"checkMoney",
//			"changeLeverage",
//			"logincheck",
//			"withdraw",//송금 api 호출
//			"siseCheck",
//			"test",
//			"copytrade",
//			"query"
			} ;
	static public void log(String arg){
		print(arg, 0, "all");
	}

	static public void write(String arg, boolean allLog) {
		String min = "" + 5 * ((int) (Calendar.getInstance().getTime().getMinutes() / 5));
		String filetimestamp = (Calendar.getInstance().getTime().getYear() + 1900) + "_"
				+ (Calendar.getInstance().getTime().getMonth() + 1) + "_" + Calendar.getInstance().getTime().getDate()
				+ "_" + Calendar.getInstance().getTime().getHours() + "_" + min;
		try {
			String fname = "bldlog";
			if (allLog == false) fname = "bldlog_filter";
			File file = new File("./logs/");
			if (!file.exists()) {
				file.mkdirs();
			}
			BufferedWriter bw = new BufferedWriter(new FileWriter("./logs/" + fname + filetimestamp + ".txt", true));
			PrintWriter pw = new PrintWriter(bw, true);
			// pw.write(arg+"\n");
			pw.println(arg);
			pw.flush();
			pw.close();
		} catch (Exception E) {
			System.out.println("로그 기록 에러, 폴더 없거나 권한 오류일듯 : " + E.getMessage());
		}
	}

	static public void print(String arg, int level, String filter) {
		String time = "";
		if (DEBUGTIME)
			time = Calendar.getInstance().getTime().toLocaleString();
		String out = time + ",[" + filter + "]," + arg;
		if ((Arrays.asList(DEBUGFILTERS).contains("all") || Arrays.asList(DEBUGFILTERS).contains(filter))&& DEBUGLEVEL >= level) {
			System.out.println(out);
			Log.write(out, false);
		}
		Log.write(out, true);
		switch(filter){
		case "err":
		case "call_send":
			Send.sendTelegramAlarmBotMsg(arg);
		}
	}

	@ResponseBody
	@RequestMapping(value = "/admin/logread.do", produces = "text/html; charset=utf8")
	public String logread(HttpServletRequest request, ModelMap model) throws Exception {
		String min = "" + 5 * ((int) (Calendar.getInstance().getTime().getMinutes() / 5));
		String filetimestamp = (Calendar.getInstance().getTime().getYear() + 1900) + "_"
				+ (Calendar.getInstance().getTime().getMonth() + 1) + "_" + Calendar.getInstance().getTime().getDate()
				+ "_" + Calendar.getInstance().getTime().getHours() + "_" + min;
		String rt = "";
		try {
			// 파일 객체 생성
			File file = new File("./logs/bldlog_filter" + filetimestamp + ".txt");
			BufferedReader inFile = new BufferedReader(new FileReader(file));
			String sLine;
			int line = 0;
			while ((sLine = inFile.readLine()) != null) {
				rt = sLine + "<br/>" + rt;
				line++;
				if (line > 3000) {
					rt = "3천줄이 넘은 로그는 logs 폴더의 파일을 직접 열어서 보세요.<br/>" + rt;
					break;
				}

			}
			inFile.close();
		} catch (FileNotFoundException e) {
			// TODO: handle exception
		} catch (IOException e) {
			System.out.println(e);
		}

		return rt;
	}

	@ResponseBody
	@RequestMapping(value = "/admin/bldlog.do", produces = "text/html; charset=utf8")
	public String bldlog(HttpServletRequest request, ModelMap model) throws Exception {
		String f = "";
		for (int i = 0; i < DEBUGFILTERALL.length; i++) {
			f += "<div class='fbtn' onclick='setFilter(\"" + DEBUGFILTERALL[i] + "\")' name='" + DEBUGFILTERALL[i]
					+ "'>" + DEBUGFILTERALL[i] + "</div>";
		}

		String rt = "<html>" + "<head>"
				+ "<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>" + "<style>"
				+ ".menu{background:#e0e0f0;margin:1px;}" + ".filter{background:#d0d0e0;margin:1px;}"
				+ ".log{background:#f0f0f0;margin:1px;}" + ".select{border:1px solid #ff7a7a !important}"
				+ ".fbtn{border: 1px solid #acbcff;display:inline-block;margin:1px;padding:1px;}" + "</style>"
				+ "</head>" + "<body>" + "<div class='menu'>"
				+ "<label><input type='radio' name='playpause' value='play' checked >play</input></label><label><input type='radio' name='playpause' value='stop' >stop</input></label>"
				+ "</div>" + "<div class='filter'>" + f + "</div>" + "<div class='log'>" + "logs" + "</div>" + "</body>"
				+ "<script>" + "function setFilter(f){" + "jQuery.ajax({" + "type:'POST'," + "url :'/" + projectName
				+ "/setfilter.do?f='+f, " + "dataType:'json'," + "success : function(data) {"
				+ "	console.log('data:',data);" + "	$('.fbtn').removeClass('select');"
				+ "	for(let i=0; i< data.select.length; i++){"
				+ "		$('.fbtn[name='+data.select[i]+']').addClass('select');" + "	}" + "},"
				+ " complete : function(data) { },"
				+ " error : function(xhr, status , error){console.log('ajax ERROR!!! : ' );}" + "});" + "}"
				+ "setFilter('none');" + "function step(){" + "if( $('input[name=playpause]:checked').val() == 'play' )"
				+ "jQuery.ajax({" + "type:'POST'," + "url :'/" + projectName + "/admin/logread.do', " + "dataType:'text',"
				+ "success : function(data) {" + "	$('.log').html(data);" + "}," + " complete : function(data) { },"
				+ " error : function(xhr, status , error){console.log('ajax ERROR!!! : ' );}" + "});"
				+ "setTimeout(step,1000);" + "}" + "setTimeout(step,1000);" + "</script>" + "</html>";

		return "" + rt;
	}

	@ResponseBody
	@RequestMapping(value = "/getfilters.do", produces = "application/json; charset=utf8")
	public String joinProcess(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		JSONArray ja = new JSONArray();
		for (int i = 0; i < DEBUGFILTERALL.length; i++) {
			ja.add(DEBUGFILTERALL[i]);
		}
		obj.put("selects", ja);
		JSONArray js = new JSONArray();
		for (int i = 0; i < DEBUGFILTERS.length; i++) {
			js.add(DEBUGFILTERS[i]);
		}
		obj.put("select", js);
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/setfilter.do", produces = "application/json; charset=utf8")
	public String setfilter(HttpServletRequest request) {
		String set = request.getParameter("f");
		ArrayList<String> tm = new ArrayList<>(Arrays.asList(DEBUGFILTERS));
		if (tm.contains(set) == true)
			tm.remove(set);
		else
			tm.add(set);
		String[] itemsArray = new String[tm.size()];
		DEBUGFILTERS = tm.toArray(itemsArray);
		JSONObject obj = new JSONObject();
		obj.put("object", "json");
		JSONArray ja = new JSONArray();
		for (int i = 0; i < DEBUGFILTERALL.length; i++) {
			ja.add(DEBUGFILTERALL[i]);
		}
		obj.put("selects", ja);
		JSONArray js = new JSONArray();
		for (int i = 0; i < DEBUGFILTERS.length; i++) {
			js.add(DEBUGFILTERS[i]);
		}
		obj.put("select", js);
		return obj.toJSONString();
	}

}