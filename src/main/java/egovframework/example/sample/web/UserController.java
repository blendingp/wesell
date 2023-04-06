package egovframework.example.sample.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.fasterxml.jackson.core.JsonProcessingException;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.ServerInfo;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.spot.SpotOrder;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Send;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/user")
public class UserController {
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;

	@RequestMapping(value = "/main.do")
	public String main(HttpServletRequest request, ModelMap model) throws Exception {
		EgovMap in = new EgovMap();
		in.put("type", "unlisted");
		in.put("limit", 50);
		
		List<?> list = (List<?>) sampleDAO.list("exchangeL", in);
		model.addAttribute("list", list);
		
		HttpSession session = request.getSession();
		int lang = 0;
		if(session.getAttribute("lang") == null || session.getAttribute("lang").equals("EN")) lang = 1;
		else if(session.getAttribute("lang").equals("JP")) lang =2;
		else if(session.getAttribute("lang").equals("CH")) lang = 3;
		else if(session.getAttribute("lang").equals("FC")) lang = 4;
		
		in.put("bcategory", "event");
		in.put("bwhere", 1);
		in.put("blang", lang);
		ArrayList<EgovMap> event = (ArrayList<EgovMap>)sampleDAO.list("selectAllBoard", in);
		for(int i = 0; i < event.size(); i++){
			String text = StringEscapeUtils.unescapeHtml3(event.get(i).get("bcontent").toString());
			event.get(i).put("text", text);
		}
		model.addAttribute("notilist", event);
		
		return "wesell/wesellMain";
	}
	@RequestMapping(value = "/wesellMain.do")
	public String wesellMain(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "main");
		
		int lang = 0;
		if(session.getAttribute("lang") == null || session.getAttribute("lang").equals("EN")) lang = 1;
		else if(session.getAttribute("lang").equals("JP")) lang =2;
		else if(session.getAttribute("lang").equals("CH")) lang = 3;
		else if(session.getAttribute("lang").equals("FC")) lang = 4;
		
		EgovMap in = new EgovMap();
		in.put("bcategory", "event");
		in.put("bwhere", 1);
		in.put("blang", lang);
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectAllBoard", in);
		for(int i = 0; i < list.size(); i++){
			String text = StringEscapeUtils.unescapeHtml3(list.get(i).get("bcontent").toString());
			list.get(i).put("text", text);
		}
		model.addAttribute("notilist", list);
		in.put("limit", 3);
		in.put("bcategory", "notice");
		model.addAttribute("nlist", sampleDAO.list("selectAllBoard", in));
		model.addAttribute("nowpage", "mainp");
		return "user/wesellMain";
	}
	@RequestMapping(value="/message.do")
	public String message(HttpServletRequest request, ModelMap model){
		
		HttpSession session = request.getSession();
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(10);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("useridx", session.getAttribute("userIdx"));
		pi.setTotalRecordCount((int) sampleDAO.select("selectMessageListCnt", in));
		model.addAttribute("list", sampleDAO.list("selectMessageList", in));
		model.addAttribute("pi", pi);
		model.addAttribute("refPage", "message");
		return "user/message";
	}
	
	@ResponseBody
	@RequestMapping(value = "/isUnreadMessage.do", produces = "application/json; charset=utf8")
	public String isUnreadMessage(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String useridx = ""+session.getAttribute("userIdx");
		JSONObject obj = new JSONObject();
		EgovMap isUnread = (EgovMap)sampleDAO.select("selectUnreadMessage",useridx);
		
		if(isUnread != null) 
			obj.put("message","o");
		else 
			obj.put("message","x");
		
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/readMessage.do", produces = "application/json; charset=utf8")
	public String readMessage(HttpServletRequest request) {
		String idx = request.getParameter("idx");
		
		JSONObject obj = new JSONObject();
		if(idx.length()>30){			
			return obj.toJSONString();
		}
		sampleDAO.update("updateMessageRead",idx);
		obj.put("result", "success");
		return obj.toJSONString();
	}

	@RequestMapping(value = "/myInfo.do")
	public String myInfo(HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
		model.addAttribute("info", sampleDAO.select("selectMemberByIdx", userIdx));
		model.addAttribute("feeRate", Project.getFeeRate(mem, "market"));
		session.setAttribute("emailCode", null);
		return "user/myInfo";
	}
	
	@ResponseBody
	@RequestMapping(value = "/verificationPhone.do", produces = "application/json; charset=utf8")
	public String verificationPhone(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String country = "82";
		String phone = request.getParameter("phone");
		
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		if(phone.length()>30){			
			return obj.toJSONString();
		}
		
		if (country.equals("00")) {
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhone", request));
			return obj.toJSONString();
		}
		if (!Validation.isValidPhone(phone)) {
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
			return obj.toJSONString();
		}
		
		// 코드 만들고 문자 발송 후에 세션저장
		String code = Validation.getTempNumber(6);
		if (!Send.sendMexVerificationCode(country, phone, code)) {
			obj.put("msg", Message.get().msg(messageSource, "pop.sendError", request));
			return obj.toJSONString();
		}
		session.setAttribute("phoneCode", code);
		obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
		obj.put("result","success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/verificationPhoneConfirm.do", produces = "application/json; charset=utf8")
	public String verificationPhoneConfirm(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String code = request.getParameter("code");
		String requestCode = ""+session.getAttribute("phoneCode");
		
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		if(code.length()>30){			
			return obj.toJSONString();
		}
		
		if(requestCode.compareTo(code)!=0){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhoneCode", request));
			return obj.toJSONString();
		}

		obj.put("msg", Message.get().msg(messageSource, "pop.requestSuccess", request));
		obj.put("result","success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/verificationEmailConfirm.do", produces = "application/json; charset=utf8")
	public String verificationEmailConfirm(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String code = request.getParameter("emailCode");
		String requestCode = ""+session.getAttribute("emailCode");
		String userIdx = ""+session.getAttribute("userIdx");
		
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		if((""+code).length()>30){			
			return obj.toJSONString();
		}
		if(requestCode.compareTo(code)!=0){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongEmailCode", request));
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("idx", userIdx);
		sampleDAO.update("updateMyEmail", in);
		session.setAttribute("emailCode", "-1"); //이메일인증 성공
		obj.put("msg", Message.get().msg(messageSource, "pop.requestSuccess", request));
		obj.put("result","success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/verificationEmail.do", produces = "application/json; charset=utf8")
	public String verificationEmail(HttpServletRequest request) {
		HttpSession session = request.getSession();		
		String userIdx = ""+session.getAttribute("userIdx");		
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		EgovMap ed = (EgovMap)sampleDAO.select("selectEmailFromMemberByIdx", in);
		String email = ""+ed.get("email");
		
		//String email = request.getParameter("email");
		JSONObject obj = new JSONObject();
		
		// 코드 만들고 문자 발송 후에 세션저장
		String code = Validation.getTempNumber(6);
		String message = Message.get().msg(messageSource, "pop.codeMail_1", request)
				+ Message.get().msg(messageSource, "pop.codeMail_2", request) + code +
				"\n"+ Message.get().msg(messageSource, "pop.codeMail_3", request);
		if (!Send.sendMailVerificationCode(request, email, message)) {
			obj.put("msg", Message.get().msg(messageSource, "pop.mailSendFail", request));
			return obj.toJSONString();
		}
		session.setAttribute("emailCode", code);
		obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/verificationEmailUpdate.do", produces = "application/json; charset=utf8")
	public String verificationEmailUpdate(HttpServletRequest request) {
		HttpSession session = request.getSession();		
		String email = request.getParameter("email");
		JSONObject obj = new JSONObject();
		if(email == null || email.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", Message.get().msg(messageSource, "pop.inputEmail", request));
			return obj.toJSONString();
		}
		if(!Validation.isValidEmail(email) || email.length() > 50){
			obj.put("result", "fail");
			obj.put("msg", Message.get().msg(messageSource, "pop.checkEmail", request));
			return obj.toJSONString();
		}
		EgovMap info = (EgovMap)sampleDAO.select("selectIsMemberEmail" , email);
		if(info == null && Integer.parseInt(info.get("jstat")+"") != 2){
			//등록된 이메일이 아닙니다. 로 문구 변경
			obj.put("msg", Message.get().msg(messageSource, "pop.noRegisterEmail", request));
			return obj.toJSONString();
		}
		// 코드 만들고 문자 발송 후에 세션저장
		String code = Validation.getTempNumber(6);
		String message = Message.get().msg(messageSource, "pop.codeMail_1", request)
				+ Message.get().msg(messageSource, "pop.codeMail_2", request) + code +
				"\n"+ Message.get().msg(messageSource, "pop.codeMail_3", request);
		if (!Send.sendMailVerificationCode(request, email, message)) {
			obj.put("msg", Message.get().msg(messageSource, "pop.mailSendFail", request));
			return obj.toJSONString();
		}
		session.setAttribute("emailCode", code);
		obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/withdrawNonEmail.do", produces = "application/json; charset=utf8")
	public String withdrawNonEmail(HttpServletRequest request) {
		String returnvalue="err";
		
		try{
			HttpSession session = request.getSession();
			String userIdx = ""+session.getAttribute("userIdx");
			String address = request.getParameter("address");
			String amount = request.getParameter("amount");
			String coin = request.getParameter("coin");
			String xrpTag = request.getParameter("xrpTag");
			JSONObject obj = new JSONObject();
			
			//길이 처리를 안해주니까 balance만 갱신되고 withdraw에는 안들어가서 돈이 날라감 
			if((""+address).length() > 100 || (""+amount).length() > 100 || (""+coin).length() > 100){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
				return obj.toJSONString();
			}
			if(xrpTag.length() > 20 ){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.tagOver", request));
				return obj.toJSONString();
			}
			
			if(address.length() > 100 ){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
				return obj.toJSONString();
			}
			if(xrpTag.length() > 20 ){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.tagOver", request));
				return obj.toJSONString();
			}
			
			EgovMap in = new EgovMap();
			in.put("userIdx", userIdx);
			in.put("wallet", address);
			in.put("amount", amount);
			in.put("coin", coin);
			in.put("coinname", coin);
			in.put("xrptag", xrpTag);		
			EgovMap fee = (EgovMap)sampleDAO.select("selectFee",in);
			in.put("wfee", Double.parseDouble(fee.get("fee").toString()));
			
			obj.put("coinMinus", Double.parseDouble(amount)+Double.parseDouble(fee.get("fee").toString()));
			
			if(coin.compareTo("XRP")==0){
				if(xrpTag.isEmpty()){
					obj.put("msg", Message.get().msg(messageSource, "pop.inputXRPTAG", request));
					return obj.toJSONString();
				}
			}
			
			EgovMap user = (EgovMap)sampleDAO.select("selectEmailFromMemberByIdx",in);
			String email = ""+user.get("email");
			if(email == null || email.compareTo("")==0 || email.compareTo("null")==0){
				obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
				return obj.toJSONString();
			}
			
			String result = CointransService.withdrawRequestProcess(userIdx, Double.parseDouble(""+amount), coin, Double.parseDouble(""+fee.get("fee")));
			if(result.compareTo("fail")==0){
				obj.put("msg", Message.get().msg(messageSource, "pop.notBalance", request));
				return obj.toJSONString();
			}						
			

			in.put("email", email);
			in.put("wstat", 0);
			int widx = (int)sampleDAO.insert("insertRequsetWithdraw",in);
			in.put("widx", widx);
			obj.put("msg", Message.get().msg(messageSource, "pop.applycationComplete", request));
			returnvalue = obj.toJSONString();
		}catch(Exception e){
			
		}
		return returnvalue;
				
	}
	
	@ResponseBody
	@RequestMapping(value = "/withdrawEmail.do", produces = "application/json; charset=utf8")
	public String withdrawEmail(HttpServletRequest request) {
		String returnvalue="err";
		try{
			HttpSession session = request.getSession();
			String userIdx = ""+session.getAttribute("userIdx");
			String address = request.getParameter("address");
			String amount = request.getParameter("amount");
			String coin = request.getParameter("coin");
			String xrpTag = request.getParameter("xrpTag");
			JSONObject obj = new JSONObject();
			
			//길이 처리를 안해주니까 balance만 갱신되고 withdraw에는 안들어가서 돈이 날라감 
			if((""+address).length() > 100 || (""+amount).length() > 100 || (""+coin).length() > 100){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
				return obj.toJSONString();
			}
			if(xrpTag.length() > 20 ){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.tagOver", request));
				return obj.toJSONString();
			}
			
			EgovMap in = new EgovMap();
			in.put("userIdx", userIdx);
			in.put("wallet", address);
			in.put("amount", amount);
			in.put("coin", coin);
			in.put("coinname", coin);
			in.put("xrptag", xrpTag);		
			EgovMap fee = (EgovMap)sampleDAO.select("selectFee",in);
			in.put("wfee", Double.parseDouble(fee.get("fee").toString()));
			
			obj.put("coinMinus", Double.parseDouble(amount)+Double.parseDouble(fee.get("fee").toString()));
			
			if(coin.compareTo("XRP")==0){
				if(xrpTag.isEmpty()){
					obj.put("msg", Message.get().msg(messageSource, "pop.inputXRPTAG", request));
					return obj.toJSONString();
				}
			}
			
			EgovMap user = (EgovMap)sampleDAO.select("selectEmailFromMemberByIdx",in);
			String email = user.get("email").toString();
			if(email.compareTo("")==0){
				obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
				return obj.toJSONString();
			}
			String emailconfirm = ""+user.get("emailconfirm");			
			if(emailconfirm.compareTo("0")==0){
				obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
				return obj.toJSONString();
			}
			String result = CointransService.withdrawRequestProcess(userIdx, Double.parseDouble(""+amount), coin, Double.parseDouble(""+fee.get("fee")));
			if(result.compareTo("fail")==0){
				obj.put("msg", Message.get().msg(messageSource, "pop.notBalance", request));
				return obj.toJSONString();
			}						
						
			in.put("email", email);
			int widx = (int)sampleDAO.insert("insertRequsetWithdraw",in);
			in.put("widx", widx);

			String code = Validation.getTempNumber(6);
			String name = user.get("name").toString();
			String addressm = address;
			String coinm = coin;
			String feem = fee.get("fee").toString();
			String codem = code;
			String xr = xrpTag;
			String html = getWithdrawEmailHtml(code);
			
			if (!Send.sendMailWithdraw(request, email, html)) {
				/*in.put("widx", widx);
				sampleDAO.delete("deleteWithdraw",in);
				obj.put("msg", Message.get().msg(messageSource, "pop.mailSendFail", request));
				return obj.toJSONString();*/
			}
			session.setAttribute("emailCode", code);
			obj.put("widx", widx);
			obj.put("msg", Message.get().msg(messageSource, "pop.sendConfirmEmail", request));
			returnvalue = obj.toJSONString();
		}catch(Exception e){
			
		}
		return returnvalue;
	}
	
	@ResponseBody
	@RequestMapping(value = "/withdrawPhone.do", produces = "application/json; charset=utf8")
	public String withdrawPhone(HttpServletRequest request) {
		String returnvalue="err";
		try{
			HttpSession session = request.getSession();
			String userIdx = ""+session.getAttribute("userIdx");
			String address = request.getParameter("address");
			String amount = request.getParameter("amount");
			String coin = request.getParameter("coin");
			String xrpTag = request.getParameter("xrpTag");
			String stock = request.getParameter("stock");
			JSONObject obj = new JSONObject();
			obj.put("result","fail");
			
			//길이 처리를 안해주니까 balance만 갱신되고 withdraw에는 안들어가서 돈이 날라감 
			if((""+address).length() > 100 || (""+amount).length() > 100 || (""+coin).length() > 100 || (""+stock).length() > 100){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
				return obj.toJSONString();
			}
			if(xrpTag.length() > 20 ){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.tagOver", request));
				return obj.toJSONString();
			}
			
			EgovMap in = new EgovMap();
			in.put("userIdx", userIdx);
			in.put("wallet", address);
			in.put("amount", amount);
			in.put("coin", coin);
			in.put("coinname", coin);
			in.put("stock", stock);
			in.put("xrptag", xrpTag);		
			EgovMap fee = (EgovMap)sampleDAO.select("selectFee",in);
			in.put("wfee", Double.parseDouble(fee.get("fee").toString()));
			
			obj.put("coinMinus", Double.parseDouble(amount)+Double.parseDouble(fee.get("fee").toString()));
			
			if(coin.compareTo("XRP")==0){
				if(xrpTag.isEmpty()){
					obj.put("msg", Message.get().msg(messageSource, "pop.inputXRPTAG", request));
					return obj.toJSONString();
				}
			}
			
			EgovMap user = (EgovMap)sampleDAO.select("selectMemberByIdx",in);
			String phone = user.get("phone").toString();
			String email = ""+user.get("email");
			boolean phoneMsg = true;
			if(phone.length() < 10 || phone.length() > 11){
				if(email.isEmpty()){
					obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
					return obj.toJSONString();
				}
				phoneMsg = false;
			}
			String result = CointransService.withdrawRequestProcess(userIdx, Double.parseDouble(""+amount), coin, Double.parseDouble(""+fee.get("fee")));
			Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
			if(result.compareTo("fail")==0){
				obj.put("msg", Message.get().msg(messageSource, "pop.notBalance", request));
				return obj.toJSONString();
			}else if(result.compareTo("wdfail")==0){
				
				double sise = 0;
				if(coin.equals("USDT"))
					sise = 1;
				else
					sise = Coin.getCoinInfo(coin).getSise("long");
				
				double accumWdUsdt = Double.parseDouble(amount) * sise;
				obj.put("msg", Message.get().msg(messageSource, "pop.wdOver", request)+" "+mem.accumWd+"/"+Project.getLimitWd()+" USDT , "+
						Message.get().msg(messageSource, "wallet.withdraw", request)+" : "+accumWdUsdt+" USDT");
				return obj.toJSONString();
			}
			in.put("email", phone);
			int widx = (int)sampleDAO.insert("insertRequsetWithdraw",in);
			in.put("widx", widx);

			String code = Validation.getTempNumber(6);
			
			if(phoneMsg){
				if (!Send.sendMexVerificationCode("82", phone, code)) {
				}
			}else{
				String html = getWithdrawEmailHtml(code);
				if (!Send.sendMailWithdraw(request, email, html)) {}
			}
			session.setAttribute("emailCode", code);
			obj.put("widx", widx);
			obj.put("result","suc");
			obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
			returnvalue = obj.toJSONString();
			
			Send.sendAdminMsg(mem,"출금 신청이 들어왔습니다.");
		}catch(Exception e){
			
		}
		return returnvalue;
	}
	
	@ResponseBody
	@RequestMapping(value = "/withdrawRePhone.do", produces = "application/json; charset=utf8")
	public String withdrawRePhone(HttpServletRequest request) {
		String returnvalue="err";
		try{
			HttpSession session = request.getSession();
			JSONObject obj = new JSONObject();
			
			obj.put("result", "fail");
			String idx = request.getParameter("idx");
			if((""+idx).length() > 30){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
				return obj.toJSONString();
			}
			EgovMap in = new EgovMap();
			in.put("widx",idx);
			EgovMap wd = (EgovMap)sampleDAO.select("selectWithdraw",in);
			
			String coin = wd.get("wcoinname").toString();
			String tag = "";
			if(coin.compareTo("XRP")==0){
				tag = wd.get("xrptag").toString();
			}
			
			in.put("userIdx",wd.get("wuseridx"));
			EgovMap user = (EgovMap)sampleDAO.select("selectMemberByIdx",in);
			String phone = user.get("phone").toString();
			String email = ""+user.get("email");
			boolean phoneMsg = true;
			
			if(phone.length() < 10 || phone.length() > 11){
				if(email.isEmpty() || email.equals("null")){
					obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
					return obj.toJSONString();
				}
				phoneMsg = false;
			}
			
			String code = Validation.getTempNumber(6);
			
			if(phoneMsg){
				if (!Send.sendMexVerificationCode("82", phone, code)) { }
			}
			else{
				String html = getWithdrawEmailHtml(code);
				if (!Send.sendMailWithdraw(request, email, html)) {}
			}
			session.setAttribute("emailCode", code);
			obj.put("msg", Message.get().msg(messageSource, "pop.sendCode", request));
			obj.put("result", "success");
			obj.put("widx", wd.get("widx"));
			returnvalue = obj.toJSONString();
		}catch(Exception e){
			
		}
		return returnvalue;
	}
	
	@ResponseBody
	@RequestMapping(value = "/withdrawReEmail.do", produces = "application/json; charset=utf8")
	public String withdrawReEmail(HttpServletRequest request) {
		String returnvalue="err";
		try{
			HttpSession session = request.getSession();
			JSONObject obj = new JSONObject();
			
			obj.put("result", "fail");
			String idx = request.getParameter("idx");
			if((""+idx).length() > 30){
				obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
				return obj.toJSONString();
			}
			EgovMap in = new EgovMap();
			in.put("widx",idx);
			EgovMap wd = (EgovMap)sampleDAO.select("selectWithdraw",in);
			
			String coin = wd.get("wcoinname").toString();
			String tag = "";
			if(coin.compareTo("XRP")==0){
				tag = wd.get("xrptag").toString();
			}
			
			in.put("userIdx",wd.get("wuseridx"));
			EgovMap user = (EgovMap)sampleDAO.select("selectMemberByIdx",in);
			String email = user.get("email").toString();
			if(email.compareTo("")==0){
				obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
				return obj.toJSONString();
			}
			
			String code = Validation.getTempNumber(6);
			String html = getWithdrawEmailHtml(code);
			
			if (!Send.sendMailWithdraw(request, email, html)) {
				/*in.put("widx", widx);
				sampleDAO.delete("deleteWithdraw",in);
				obj.put("msg", Message.get().msg(messageSource, "pop.mailSendFail", request));
				return obj.toJSONString();*/
			}
			session.setAttribute("emailCode", code);
			obj.put("msg", Message.get().msg(messageSource, "pop.sendConfirmEmail", request));
			obj.put("result", "success");
			obj.put("widx", wd.get("widx"));
			returnvalue = obj.toJSONString();
		}catch(Exception e){
			
		}
		return returnvalue;
	}

	@ResponseBody
	@RequestMapping(value = "/updateMyInfo.do", produces = "application/json; charset=utf8")
	public String updateMyInfo(HttpServletRequest request) {
		HttpSession session = request.getSession();		
		String idx = ""+session.getAttribute("userIdx");
//		String name = request.getParameter("name");
		String changePhone = request.getParameter("changePhone");
		String changeEmail = request.getParameter("changeEmail");
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if((""+idx).length() > 30 || (""+changePhone).length() > 30 || (""+changeEmail).length() > 100){
			obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		Member member = Member.getMemberByIdx(Integer.parseInt(idx));
		in.put("name", member.getName());
		
//		if (name == null || name.isEmpty()) {
//			obj.put("msg", Message.get().msg(messageSource, "pop.inputNickname", request));
//			return obj.toJSONString();
//		}
		if (changePhone.equals("true")) {
			String country = "82";
			String phone = request.getParameter("phone");
			String code = request.getParameter("code");
			if (country.equals("00")) {
				obj.put("msg", Message.get().msg(messageSource, "pop.selectCountry", request));
				return obj.toJSONString();
			}
			if (!Validation.isValidPhone(phone)) {
				obj.put("msg", Message.get().msg(messageSource, "pop.inputPhoneNum", request));
				return obj.toJSONString();
			}
			EgovMap phoneCheck = new EgovMap();
			phoneCheck.put("phone",phone);
			if(sampleDAO.select("selectPhone",phoneCheck) != null){
				obj.put("msg", Message.get().msg(messageSource, "pop.alreadyPhone", request));
				return obj.toJSONString();
			}
			in.put("country", country);
			in.put("phone", phone);
		}
		if (changeEmail.equals("true")) {
			String email = ""+request.getParameter("email");
			String emailCode = ""+session.getAttribute("emailCode");
			if(emailCode.compareTo("-1")!=0){//이메일 인증을 정상 적으로 안한건데 해커일 가능성 다분..
				obj.put("msg", Message.get().msg(messageSource, "pop.alreadyPhone", request));
				return obj.toJSONString();
			}
			in.put("email", email);
			in.put("eEmail", email);
			in.put("euserIdx", idx);
			in.put("kind", "user");
			sampleDAO.insert("insertElist", in);
		}
		sampleDAO.update("updateMyInfo", in);
		
//		member.setName(name);
		
		session.setAttribute("phoneCode", null);
		session.setAttribute("emailCode", null);
		obj.put("result", "success");
		obj.put("msg", Message.get().msg(messageSource, "pop.change", request));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/changePW.do", produces = "application/json; charset=utf8")
	public String changePW(HttpServletRequest request) {
		HttpSession session = request.getSession();		
		String idx = ""+session.getAttribute("userIdx");
		String phoneCode = ""+session.getAttribute("phoneCode");
		String code = request.getParameter("code");
		String pw = request.getParameter("pw");
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");

		if(pw.length() > 30){
			return obj.toJSONString();
		}else if(!phoneCode.equals(code)){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhoneCode", request));
			return obj.toJSONString();
		}
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		Member member = Member.getMemberByIdx(Integer.parseInt(idx));
		in.put("name", member.getName());
		in.put("pw", pw);
		
		sampleDAO.update("updateMyInfo", in);
		
		session.setAttribute("phoneCode", null);
		obj.put("result", "success");
		obj.put("msg", Message.get().msg(messageSource, "pop.change", request));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateMuteToggle.do", produces = "application/json; charset=utf8")
	public String updateMuteToggle(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String idx = ""+session.getAttribute("userIdx");
		String mute = ""+session.getAttribute("mute");
		JSONObject obj = new JSONObject();
		if(idx.length() > 30 || mute.length() > 50){
			obj.put("msg",  Message.get().msg(messageSource, "wallet.addressOver", request));
			return obj.toJSONString();
		}
		
		String toggled = "";
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		if(mute.equals("0"))
			toggled = "1";
		else
			toggled = "0";
			
		in.put("mute", toggled);
		
		sampleDAO.update("updateToggleMute", in);
		session.setAttribute("mute", toggled);
		return obj.toJSONString();
	}
	@RequestMapping(value = "/fundingHistory.do")
	public String fundingHistory(HttpServletRequest request, ModelMap model) throws Exception {
		long starttime = Calendar.getInstance().getTime().getTime();
		
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "mypage");
		String symbol = request.getParameter("symbol");
		String date = request.getParameter("date");
		String edate = request.getParameter("edate");
		
		if (symbol == null || symbol.isEmpty())
			symbol = "BTCUSDT";
		if (date == null || date.isEmpty()) {
			Date today = new Date();
			date = new SimpleDateFormat("yyyy-MM-dd").format(today);
			edate = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		if(symbol.length()>30 || date.length()>30 || edate.length()>30
				 || (""+request.getParameter("pageIndex")).length() > 30){			
			return "user/fundingHistory";
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("date", date);
		in.put("edate", edate);
		in.put("symbol", symbol);
		in.put("userIdx", session.getAttribute("userIdx"));
		pi.setTotalRecordCount((int) sampleDAO.select("selectMyFundingHistoryCnt", in));
		model.addAttribute("list", sampleDAO.list("selectMyFundingHistory", in));
		model.addAttribute("pi", pi);
		model.addAttribute("date", date);
		model.addAttribute("edate", edate);
		model.addAttribute("symbol", symbol);
		model.addAttribute("useCoin", Project.getUseCoinNames());

		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("fundingHistory.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("fundingHistory.do delay delaycheck "+endtime, 2, "delaycheck");			
		return "user/fundingHistory";
	}
	@RequestMapping(value = "/fundingHistory2.do")
	public String fundingHistory2(HttpServletRequest request, ModelMap model) throws Exception {
		long starttime = Calendar.getInstance().getTime().getTime();
		
		HttpSession session = request.getSession();
		String coin = request.getParameter("coin");
		String date = request.getParameter("date");
		String edate = request.getParameter("edate");
		
		if (coin == null || coin.isEmpty())
			coin = "BTCUSDT";
		if (date == null || date.isEmpty()) {
			Date today = new Date();
			date = new SimpleDateFormat("yyyy-MM-dd").format(today);
			edate = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		if(coin.length()>30 || date.length()>30 || edate.length()>30
				|| (""+request.getParameter("pageIndex")).length() > 30){			
			return "user/fundingHistory2";
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("date", date);
		in.put("edate", edate);
		in.put("coin", coin);
		in.put("userIdx", session.getAttribute("userIdx"));
		pi.setTotalRecordCount((int) sampleDAO.select("selectMyFundingHistoryCnt", in));
		model.addAttribute("list", sampleDAO.list("selectMyFundingHistory", in));
		model.addAttribute("pi", pi);
		model.addAttribute("date", date);
		model.addAttribute("edate", edate);
		model.addAttribute("coin", coin);
		
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("fundingHistory.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("fundingHistory.do delay delaycheck "+endtime, 2, "delaycheck");			
		return "user/fundingHistory2";
	}

	@RequestMapping(value = "/referells.do")
	public String referells(HttpServletRequest request, ModelMap model) throws Exception {
		long starttime = Calendar.getInstance().getTime().getTime();
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "mypage");
		String coin = request.getParameter("coin");
		String date = request.getParameter("date");
		String edate = request.getParameter("edate");
		
		
		
		if (coin == null || coin.isEmpty())
			coin = "BTCUSDT";
		if (date == null || date.isEmpty()) {
			Date today = new Date();
			date = new SimpleDateFormat("yyyy-MM-dd").format(today);
			edate = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		
		if(coin.length()>30 || date.length()>30 || edate.length()>30
				 || (""+request.getParameter("pageIndex")).length() > 30){			
			return "user/referells";
		}
		
		pi.setPageSize(10);
		pi.setRecordCountPerPage(10);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("date", date);
		in.put("edate", edate);
		in.put("coin", coin);
		in.put("getIdx", session.getAttribute("userIdx"));
		String level = "" + session.getAttribute("userLevel");
		in.put("level", level);
		pi.setTotalRecordCount((int) sampleDAO.select("selectMyReferralListCnt", in));
		model.addAttribute("list", sampleDAO.list("selectMyReferralList", in));
		model.addAttribute("membername", sampleDAO.select("selectMemberName", in));
		model.addAttribute("pi", pi);
		model.addAttribute("date", date);
		model.addAttribute("edate", edate);
		model.addAttribute("coin", coin);
		
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("wallet.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("exchange2.do delay delaycheck "+endtime, 2, "delaycheck");		
		return "user/referells";
	}

	@RequestMapping(value = "/tradeHistory.do")
	public String tradeHistory(HttpServletRequest request, ModelMap model) throws Exception {
		long starttime = Calendar.getInstance().getTime().getTime();
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "mypage");
		String userIdx = "" + session.getAttribute("userIdx");
		String symbol = request.getParameter("symbol");
		String date = request.getParameter("date");
		String endDate = request.getParameter("endDate");
		
		
		if (date == null || date.isEmpty()) {
			Date today = new Date();
			date = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		if (endDate == null || endDate.isEmpty()) {
			Date today = new Date();
			endDate = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		if (symbol == null || symbol.isEmpty())
			symbol = "BTCUSDT";
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").isEmpty())
			pi.setCurrentPageNo(1);
		else
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		
		if((""+symbol).length()>30 || (""+date).length()>30 || (""+endDate).length()>30
				 || (""+request.getParameter("pageIndex")).length() > 30){			
			return "user/referells";
		}
		
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("symbol", symbol);
		in.put("date", date);
		in.put("endDate", endDate);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		pi.setTotalRecordCount((int) sampleDAO.select("selectEndtimeMyTradeListCnt", in));
		model.addAttribute("list", sampleDAO.list("selectEndtimeMyTradeList", in));
		/*
		model.addAttribute("sum", sampleDAO.select("selectEndtimeMyTradeListSum", in));
		model.addAttribute("funding", sampleDAO.select("getEndtimeFunding", in));*/
		model.addAttribute("pi", pi);
		model.addAttribute("date", date);
		model.addAttribute("endDate", endDate);
		model.addAttribute("symbol", symbol);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("tradeHistory.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("tradeHistory.do delay delaycheck "+endtime, 2, "delaycheck");
		
		return "user/tradeHistory";
	}
	@RequestMapping(value = "/tradeSpotHistory.do")
	public String tradeSpotHistory(HttpServletRequest request, ModelMap model) throws Exception {
		long starttime = Calendar.getInstance().getTime().getTime();
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "mypage");
		String userIdx = "" + session.getAttribute("userIdx");
		String symbol = request.getParameter("symbol");
		String date = request.getParameter("date");
		String endDate = request.getParameter("endDate");
		
		
		if (date == null || date.isEmpty()) {
			Date today = new Date();
			date = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		if (endDate == null || endDate.isEmpty()) {
			Date today = new Date();
			endDate = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		if (symbol == null || symbol.isEmpty())
			symbol = "BTCUSD";
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").isEmpty())
			pi.setCurrentPageNo(1);
		else
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		
		if((""+symbol).length()>30 || (""+date).length()>30 || (""+endDate).length()>30
				 || (""+request.getParameter("pageIndex")).length() > 30){			
			return "user/referells";
		}
		
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("symbol", symbol);
		in.put("date", date);
		in.put("endDate", endDate);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		pi.setTotalRecordCount((int) sampleDAO.select("selectEndtimeMySpotTradeListCnt", in));
		model.addAttribute("list", sampleDAO.list("selectEndtimeMySpotTradeList", in));
		/*
		model.addAttribute("sum", sampleDAO.select("selectEndtimeMyTradeListSum", in));
		model.addAttribute("funding", sampleDAO.select("getEndtimeFunding", in));*/
		model.addAttribute("pi", pi);
		model.addAttribute("date", date);
		model.addAttribute("endDate", endDate);
		model.addAttribute("symbol", symbol);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("tradeHistory.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("tradeHistory.do delay delaycheck "+endtime, 2, "delaycheck");
		
		return "user/tradeSpotHistory";
	}
	
	@RequestMapping(value = "/transactions.do")
	public String transactions(HttpServletRequest request, ModelMap model) throws Exception {
		String label = "" + request.getParameter("label");
		HttpSession session = request.getSession();
		String userIdx = "" + session.getAttribute("userIdx");
		String date = request.getParameter("date");
		String edate = request.getParameter("edate");
		String coinname = request.getParameter("coinname");
		
		
		if (date == null || date.isEmpty()) {
			if(edate != null) {
				date = edate;
			} else {date = null;}
		} else if (edate == null || edate.isEmpty()) {
			Date today = new Date();
			edate = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").isEmpty())
			pi.setCurrentPageNo(1);
		else
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		
		if((""+coinname).length()>30 || (""+date).length()>30 || (""+edate).length()>30
				 || (""+request.getParameter("pageIndex")).length() > 30){			
			return "user/transactions";
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("label", null);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("sdate", date);
		in.put("edate", edate);
		in.put("coin", coinname);
		pi.setTotalRecordCount((int) sampleDAO.select("selectTransactionsCnt", in));
		model.addAttribute("list", sampleDAO.list("selectTransactions", in));
		model.addAttribute("refPage", "transactions");
		model.addAttribute("pi", pi);
		model.addAttribute("date", date);
		model.addAttribute("edate", edate);
		model.addAttribute("coinname", coinname);
		model.addAttribute("user", sampleDAO.select("selectMemberByIdxToWallet", session.getAttribute("userIdx")));
		model.addAttribute("walletBTC", CointransService.getBalanceCoin(userIdx, "BTC"));
		model.addAttribute("walletXRP", CointransService.getBalanceCoin(userIdx, "XRP"));
		model.addAttribute("walletTRX",CointransService.getBalanceCoin(userIdx, "TRX"));
		model.addAttribute("walletETH",CointransService.getBalanceCoin(userIdx, "ETH"));
		model.addAttribute("walletUSDT",CointransService.getBalanceCoin(userIdx, "USDT"));
		return "user/transactions";
	}	
	//입출금 내역
	@RequestMapping(value = "/kTransactions.do")
	public String kTransactions(HttpServletRequest request, ModelMap model) throws Exception {
		String op = "" + request.getParameter("op");
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		String userIdx = "" + session.getAttribute("userIdx");
		String date = request.getParameter("sDate");
		String edate = request.getParameter("eDate");
		String kind = null;
		
		if(op.equals("Deposit")){
			kind = "+";
		} else if (op.equals("Withdrawl")) {
			kind = "-";
		}

		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").isEmpty())
			pi.setCurrentPageNo(1);
		else
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));

		pi.setPageSize(5);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("kind", kind);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("sdate", date);
		in.put("edate", edate);
		pi.setTotalRecordCount((int) sampleDAO.select("selectKtransactionsCnt", in));
		model.addAttribute("list", sampleDAO.list("selectKtransactions", in));
		model.addAttribute("op", op);
		model.addAttribute("pi", pi);
		model.addAttribute("sDate", date);
		model.addAttribute("eDate", edate);
		model.addAttribute("refPage", "transactions");
		return "user/transactionsKRW";
	}
	@ResponseBody
	@RequestMapping(value = "/requestListConfirm.do", produces = "application/json; charset=utf8")
	public String requestListConfirm(HttpServletRequest request, ModelMap model) throws Exception {		
		String widx = request.getParameter("widx");	
		String code = request.getParameter("code");
		HttpSession session = request.getSession();
		String emailCode = ""+session.getAttribute("emailCode");
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		if((""+widx).length()>30 || (""+code).length()>30 || (""+emailCode).length()>30){			
			return obj.toJSONString();
		}
		if(!code.equals(emailCode)){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongEmailCode", request));
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		EgovMap withdraw = (EgovMap)sampleDAO.select("selectWithdraw",in);
		
		int msg = -1; // -1  잘못된 접근. 0 확인 1 이미 확인됨
		if(withdraw != null){
			String withdrawUseridx = ""+withdraw.get("wuseridx");
			String userIdx = "" + session.getAttribute("userIdx");
			if(userIdx.compareTo(withdrawUseridx) != 0){
				msg = -1;
			}
			else{
				if((int)withdraw.get("wstat") == -1){								
					in.put("stat", 0);
					msg = 0;
					sampleDAO.update("updateWithdrawalStat",in);
				}else{
					msg = 1;
				}
			}
		}
		obj.put("result", "success");
		obj.put("msg", Message.get().msg(messageSource, "pop.requestSuccess", request));
		return obj.toJSONString();
	}
	
	@RequestMapping(value = "/requestList.do")
	public String requestList(HttpServletRequest request, ModelMap model) throws Exception {
		long starttime = Calendar.getInstance().getTime().getTime();
		
		HttpSession session = request.getSession();
		String userIdx = "" + session.getAttribute("userIdx");
		String msg = request.getParameter("msg");
		String date = request.getParameter("date");
		String edate = request.getParameter("edate");
		String coinname = request.getParameter("coinname");
		
		
		
		if (date == null || date.isEmpty()) {
			if(edate != null) {
				date = edate;
			} else {date = null;}
		} else if (edate == null || edate.isEmpty()) {
			Date today = new Date();
			edate = new SimpleDateFormat("yyyy-MM-dd").format(today);
		}
		
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").isEmpty())
			pi.setCurrentPageNo(1);
		else
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		
		if((""+msg).length()>50 || (""+date).length()>30 || (""+edate).length()>30
				 || (""+coinname).length()>30 || (""+request.getParameter("pageIndex")).length() > 30){			
			return "user/requestList";
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		//in.put("except", 3); // 취소된 리스트 조회X
		//in.put("islist", "true");
		in.put("sdate", date);
		in.put("edate", edate);
		in.put("coin", coinname);
		pi.setTotalRecordCount((int) sampleDAO.select("selectMyWithdrawalListCnt", in));
		model.addAttribute("list", sampleDAO.list("selectMyWithdrawalList", in));
		model.addAttribute("refPage", "requestList");
		model.addAttribute("pi", pi);
		model.addAttribute("msg",msg);
		model.addAttribute("date", date);
		model.addAttribute("edate", edate);
		model.addAttribute("coinname", coinname);
		model.addAttribute("user", sampleDAO.select("selectMemberByIdxToWallet", session.getAttribute("userIdx")));
		model.addAttribute("walletBTC", CointransService.getBalanceCoin(userIdx, "BTC"));
		model.addAttribute("walletUSDT", CointransService.getBalanceCoin(userIdx, "USDT"));
		model.addAttribute("walletXRP", CointransService.getBalanceCoin(userIdx, "XRP"));
		model.addAttribute("walletTRX", CointransService.getBalanceCoin(userIdx, "TRX"));	
		model.addAttribute("walletETH", CointransService.getBalanceCoin(userIdx, "ETH"));	
		
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("requestList.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("requestList.do delay delaycheck "+endtime, 2, "delaycheck");		
		return "user/requestList";
	}
	
	//입금
	@RequestMapping(value = "/wallet.do")
	public String wallet(HttpServletRequest request, ModelMap model) throws JsonProcessingException {
		long starttime = Calendar.getInstance().getTime().getTime();
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		EgovMap uinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", userIdx);
		EgovMap pinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", ""+uinfo.get("parentsIdx"));
		if(pinfo == null) {
//			String gidx = ""+uinfo.get("gparentsIdx");
//			if(gidx.equals("-1")) {
				pinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", "1");
//			} else {
//				pinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", ""+uinfo.get("gparentsIdx"));
//			}
		}
		Member member = Member.getMemberByIdx(userIdx);
		String pidx = ""+pinfo.get("idx");
		EgovMap xinfo = (EgovMap) sampleDAO.select("selectXrpAccount");
		model.addAttribute("user", sampleDAO.select("selectMemberByIdxToWallet", session.getAttribute("userIdx")));
		model.addAttribute("wallet", member.getWallet());
		model.addAttribute("walletBTC", member.getWalletC("BTC"));
		model.addAttribute("walletUSDT", member.getWalletC("USDT"));
		model.addAttribute("walletXRP", member.getWalletC("XRP"));
		model.addAttribute("walletTRX", member.getWalletC("TRX"));	
		model.addAttribute("walletETH", member.getWalletC("ETH"));	
		model.addAttribute("btcAddress", ""+pinfo.get("btcAddress"));
		model.addAttribute("ethAddress", ""+pinfo.get("ercAddress"));
		model.addAttribute("trxAddress", ""+pinfo.get("trxAddress"));
//		model.addAttribute("btcAddress", ""+uinfo.get("btcAddress"));
//		model.addAttribute("ethAddress", ""+uinfo.get("ercAddress"));
//		model.addAttribute("trxAddress", ""+uinfo.get("trxAddress"));
		model.addAttribute("xrpAddress", ""+xinfo.get("xrpAddress"));
		//model.addAttribute("xrpAccount",SocketHandler.ripple.getAddress());
		model.addAttribute("pidx", pidx);
		model.addAttribute("refPage", "wallet");
		model.addAttribute("feeList", sampleDAO.list("selectFeeList"));
		
		JSONObject obj = new JSONObject();
		JSONArray j = new JSONArray();		
		for (int i = 0; i < SocketHandler.positionList.size(); i++) {
			if (SocketHandler.positionList.get(i).userIdx == userIdx) {
				Log.print(i+" 포지션 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.positionList.get(i).symbol);
        		item.put("position", SocketHandler.positionList.get(i).position);
        		item.put("buyQuantity", SocketHandler.positionList.get(i).buyQuantity);
        		item.put("contractVolume", SocketHandler.positionList.get(i).contractVolume);
        		item.put("margin", 0);
        		item.put("fee", SocketHandler.positionList.get(i).fee);
        		j.add(item);            		
			}
		}  
		obj.put("plist", j);
		
		JSONArray jorder = new JSONArray();
		for (int i = 0; i < SocketHandler.orderList.size(); i++) {
			if (SocketHandler.orderList.get(i).userIdx == userIdx){
				Log.print(i+" 오더 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.orderList.get(i).symbol);
        		item.put("paidVolume", PublicUtils.toFixed(SocketHandler.orderList.get(i).paidVolume + SocketHandler.orderList.get(i).openFee, 5));
        		jorder.add(item);            		
			}
		}        		
		obj.put("olist", jorder);
		
		JSONArray jspotorder = new JSONArray();
		for (SpotOrder o : SocketHandler.spotOrderList) {
			if (o.userIdx == userIdx) {
				JSONObject item = new JSONObject();   
        		item.put("symbol", o.symbol);
        		item.put("paidVolume", o.paidVolume);
        		item.put("buyQuantity", o.buyQuantity);
        		item.put("position", o.position); 
        		jspotorder.add(item);            		
			}
		}        		
		obj.put("spotolist", jspotorder);
		model.addAttribute("pobj", obj.toJSONString() );
		
//		List<EgovMap> pos = (List<EgovMap>)sampleDAO.list("selectPositionByIdx",in);
//		for(int i = 0; i < pos.size(); i++){
//			model.addAttribute(pos.get(i).get("symbol")+"Pos", pos.get(i));
//		}
//		in.put("state","wait");
//		List<EgovMap> order = (List<EgovMap>)sampleDAO.list("selectOrderByIdxPaidSum",in);
//		for(int i = 0; i < order.size(); i++){
//			model.addAttribute(order.get(i).get("symbol")+"OrderPaid", order.get(i));
//		}
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("wallet2.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("wallet2.do delay delaycheck "+endtime, 2, "delaycheck");				
		return "user/wallet";
	}
	
	@RequestMapping(value = "/myasset.do")
	public String myasset(HttpServletRequest request, ModelMap model) throws JsonProcessingException {
		long starttime = Calendar.getInstance().getTime().getTime();
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		Member member = Member.getMemberByIdx(userIdx);
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		model.addAttribute("wallet", member.getWallet());
		model.addAttribute("walletBTC", member.getWalletC("BTC"));
		model.addAttribute("walletUSDT", member.getWalletC("USDT"));
		model.addAttribute("walletXRP", member.getWalletC("XRP"));
		model.addAttribute("walletTRX", member.getWalletC("TRX"));	
		model.addAttribute("walletETH", member.getWalletC("ETH"));	
		model.addAttribute("refPage", "myasset");
		
		JSONObject obj = new JSONObject();
		JSONArray j = new JSONArray();		
		for (int i = 0; i < SocketHandler.positionList.size(); i++) {
			if (SocketHandler.positionList.get(i).userIdx == userIdx) {
				Log.print(i+" 포지션 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.positionList.get(i).symbol);
        		item.put("position", SocketHandler.positionList.get(i).position);
        		item.put("buyQuantity", SocketHandler.positionList.get(i).buyQuantity);
        		item.put("contractVolume", SocketHandler.positionList.get(i).contractVolume);
        		item.put("margin", 0);
        		item.put("fee", SocketHandler.positionList.get(i).fee);
        		j.add(item);            		
			}
		}  
		obj.put("plist", j);
		
		JSONArray jorder = new JSONArray();
		for (int i = 0; i < SocketHandler.orderList.size(); i++) {
			if (SocketHandler.orderList.get(i).userIdx == userIdx){
				Log.print(i+" 오더 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.orderList.get(i).symbol);
        		item.put("paidVolume", PublicUtils.toFixed(SocketHandler.orderList.get(i).paidVolume + SocketHandler.orderList.get(i).openFee, 5));
        		jorder.add(item);            		
			}
		}        		
		obj.put("olist", jorder);
		
		JSONArray jspotorder = new JSONArray();
		for (SpotOrder o : SocketHandler.spotOrderList) {
			if (o.userIdx == userIdx) {
				JSONObject item = new JSONObject();   
        		item.put("symbol", o.symbol);
        		item.put("paidVolume", o.paidVolume);
        		item.put("buyQuantity", o.buyQuantity);
        		item.put("position", o.position); 
        		jspotorder.add(item);            		
			}
		}        		
		obj.put("spotolist", jspotorder);	
		model.addAttribute("pobj", obj.toJSONString() );
		return "user/myasset";
	}
	
	@RequestMapping(value = "/kWallet.do")
	public String kWallet(HttpServletRequest request, ModelMap model) throws JsonProcessingException {
		long starttime = Calendar.getInstance().getTime().getTime();
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		EgovMap uinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", userIdx);
		EgovMap pinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", ""+uinfo.get("parentsIdx"));
		if(pinfo == null) {
//			String gidx = ""+uinfo.get("gparentsIdx");
//			if(gidx.equals("-1")) {
				pinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", "1");
//			} else {
//				pinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", ""+uinfo.get("gparentsIdx"));
//			}
		}
		Member member = Member.getMemberByIdx(userIdx);
		String pidx = ""+pinfo.get("idx");
		EgovMap xinfo = (EgovMap) sampleDAO.select("selectXrpAccount");
		model.addAttribute("user", sampleDAO.select("selectMemberByIdxToWallet", session.getAttribute("userIdx")));
		model.addAttribute("wallet", member.getWallet());
		model.addAttribute("walletBTC", member.getWalletC("BTC"));
		model.addAttribute("walletUSDT", member.getWalletC("USDT"));
		model.addAttribute("walletXRP", member.getWalletC("XRP"));
		model.addAttribute("walletTRX", member.getWalletC("TRX"));	
		model.addAttribute("walletETH", member.getWalletC("ETH"));	
		model.addAttribute("btcAddress", ""+pinfo.get("btcAddress"));
		model.addAttribute("ethAddress", ""+pinfo.get("ercAddress"));
		model.addAttribute("trxAddress", ""+pinfo.get("trxAddress"));
//		model.addAttribute("btcAddress", ""+uinfo.get("btcAddress"));
//		model.addAttribute("ethAddress", ""+uinfo.get("ercAddress"));
//		model.addAttribute("trxAddress", ""+uinfo.get("trxAddress"));
		model.addAttribute("xrpAddress", ""+xinfo.get("xrpAddress"));
		//model.addAttribute("xrpAccount",SocketHandler.ripple.getAddress());
		model.addAttribute("pidx", pidx);
		model.addAttribute("refPage", "wallet");
		model.addAttribute("feeList", sampleDAO.list("selectFeeList"));
		
		JSONObject obj = new JSONObject();
		JSONArray j = new JSONArray();
		JSONArray jorder = new JSONArray();
		for (int i = 0; i < SocketHandler.positionList.size(); i++) {
			if (SocketHandler.positionList.get(i).userIdx == userIdx) {
				Log.print(i+" 포지션 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.positionList.get(i).symbol);
        		item.put("position", SocketHandler.positionList.get(i).position);
        		item.put("buyQuantity", SocketHandler.positionList.get(i).buyQuantity);
        		item.put("contractVolume", SocketHandler.positionList.get(i).contractVolume);
        		item.put("margin", 0);
        		item.put("fee", SocketHandler.positionList.get(i).fee);
        		j.add(item);            		
			}
		}  
		obj.put("plist", j);
		for (int i = 0; i < SocketHandler.orderList.size(); i++) {
			if (SocketHandler.orderList.get(i).userIdx == userIdx){
				Log.print(i+" 오더 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.orderList.get(i).symbol);
        		item.put("paidVolume", PublicUtils.toFixed(SocketHandler.orderList.get(i).paidVolume + SocketHandler.orderList.get(i).openFee, 5));
        		jorder.add(item);            		
			}
		}        		
		obj.put("olist", jorder);
		model.addAttribute("pobj", obj.toJSONString() );
		
//		List<EgovMap> pos = (List<EgovMap>)sampleDAO.list("selectPositionByIdx",in);
//		for(int i = 0; i < pos.size(); i++){
//			model.addAttribute(pos.get(i).get("symbol")+"Pos", pos.get(i));
//		}
//		in.put("state","wait");
//		List<EgovMap> order = (List<EgovMap>)sampleDAO.list("selectOrderByIdxPaidSum",in);
//		for(int i = 0; i < order.size(); i++){
//			model.addAttribute(order.get(i).get("symbol")+"OrderPaid", order.get(i));
//		}
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("kwallet2.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("kwallet.do delay delaycheck "+endtime, 2, "delaycheck");				
		return "user/walletKRW";
	}
	
	@ResponseBody
	@RequestMapping(value = "/requestDeposit.do", produces = "application/json; charset=utf8")
	public String requestDeposit(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		String amount = request.getParameter("amount");
		String pidx = request.getParameter("pidx");
		String tx = request.getParameter("tx");
		String coinname = request.getParameter("coinname");
		
		String dtag = "null";
		if(!coinname.equals("XRP")) {
			EgovMap uinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", userIdx);
			dtag = ""+uinfo.get("destinationTag");
		}
		
		double fee = 0;
		if(Project.isDepositFee())
			fee = CointransService.getDepositFee(coinname);
		EgovMap in = new EgovMap();
		in.put("userIdx",userIdx);
		in.put("amount", amount);
		in.put("tx", tx);
		in.put("coin", coinname);
		in.put("label", "+");
		in.put("dtag", dtag);
		in.put("status", "0");
		in.put("fee", fee);
		in.put("from", userIdx);
		in.put("to", pidx);
		sampleDAO.insert("insertTransaction",in);
		obj.put("result", "success");
		
		Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
		Send.sendAdminMsg(mem,"입금 신청이 들어왔습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/depositProcess.do" , method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String depositProcess(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		HttpSession session = request.getSession();
		String userIdx = "" + session.getAttribute("userIdx");
		String money = ""+request.getParameter("depositMoney");
		
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("money", money);
		in.put("kind", "+");
		
		if(money.equals("") || Double.parseDouble(money)<0) {
			obj.put("msg", Message.get().msg(messageSource, "wallet.inputAmount", request));
			return obj.toJSONString();
		}
		/*if(Double.parseDouble(money)>3000000) {
			obj.put("msg", "1회 최대 300입금.");
			return obj.toJSONString();
		}*/
		EgovMap checkMoneyStat = (EgovMap) sampleDAO.select("checkMoneyStat", in);
		if(checkMoneyStat==null){
			sampleDAO.insert("insertMoney",in);
			
			/*EgovMap myInfo = (EgovMap) sampleDAO.select("selectMemberByIdx", userIdx);
			HashMap<String, Object> resultMap = new HashMap();
			resultMap.put("agencyurl", "bm778899.epaycent.com");    //파라미터 설정
			resultMap.put("agencyname", "bm778899");
			resultMap.put("agencypassword", "77889900");
			resultMap.put("username", ""+myInfo.get("email"));
			resultMap.put("amount", money);
			ObjectMapper mapper = new ObjectMapper();
			String json = mapper.writeValueAsString(resultMap);
			String rt = Epaycent.callAPI("POST", "https://epaycent.com/checkout/charge", json);
			JSONParser p = new JSONParser();
			JSONObject rto = (JSONObject) p.parse(rt);
			System.out.println("deposit rto:"+rto+"\n");
			if(rto.get("type").equals("success")) {*/
				obj.put("result", "suc");
				obj.put("msg", Message.get().msg(messageSource, "wallet.dreqSuccess", request));
				obj.put("protocol", "dwRequest");
				SocketHandler.sh.sendAdminMessage(obj);
			/*} else {
				obj.put("msg", "fail");
			}*/
//			obj.put("protocol", "AlarmResult");
//			obj.put("kind", "deposit");
//			SocketHandler.sn.sendAlarm(obj);
		}
		else{
			obj.put("result", "already");
			obj.put("msg", Message.get().msg(messageSource, "wallet.waitingDreq", request));
		}
		return obj.toJSONString();
	}
	
	//출금
	@RequestMapping(value = "/walletWithdraw.do")
	public String walletWithdraw(HttpServletRequest request, ModelMap model) throws JsonProcessingException {
		long starttime = Calendar.getInstance().getTime().getTime();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		Member member = Member.getMemberByIdx(userIdx);
		model.addAttribute("user", sampleDAO.select("selectMemberByIdx", userIdx));
		model.addAttribute("walletBTC", member.getWalletC("BTC"));
		model.addAttribute("walletUSDT", member.getWalletC("USDT"));
		model.addAttribute("walletXRP", member.getWalletC("XRP"));
		model.addAttribute("walletTRX", member.getWalletC("TRX"));	
		model.addAttribute("walletETH", member.getWalletC("ETH"));
		
		//model.addAttribute("xrpAccount",sampleDAO.select("selectXrpAccount"));
		//model.addAttribute("xrpAccount",SocketHandler.ripple.getAddress());
		model.addAttribute("refPage", "withdraw");
		model.addAttribute("feeList", sampleDAO.list("selectFeeList"));
		
		JSONObject obj = new JSONObject();
		JSONArray j = new JSONArray();		
		for (int i = 0; i < SocketHandler.positionList.size(); i++) {
			if (SocketHandler.positionList.get(i).userIdx == userIdx) {
				Log.print(i+" 포지션 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.positionList.get(i).symbol);
        		item.put("position", SocketHandler.positionList.get(i).position);
        		item.put("buyQuantity", SocketHandler.positionList.get(i).buyQuantity);
        		item.put("contractVolume", SocketHandler.positionList.get(i).contractVolume);
        		item.put("margin", 0);
        		item.put("fee", SocketHandler.positionList.get(i).fee);
        		item.put("marginType", SocketHandler.positionList.get(i).marginType);
        		j.add(item);            		
			}
		}  
		
		JSONArray jorder = new JSONArray();
		obj.put("plist", j);
		for (int i = 0; i < SocketHandler.orderList.size(); i++) {
			if (SocketHandler.orderList.get(i).userIdx == userIdx) {
				Log.print(i+" 오더 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.orderList.get(i).symbol);
        		item.put("paidVolume", PublicUtils.toFixed(SocketHandler.orderList.get(i).paidVolume + SocketHandler.orderList.get(i).openFee, 5));
        		jorder.add(item);            		
			}
		}        		
		obj.put("olist", jorder);
		
		JSONArray jspotorder = new JSONArray();
		for (SpotOrder o : SocketHandler.spotOrderList) {
			if (o.userIdx == userIdx) {
				JSONObject item = new JSONObject();   
        		item.put("symbol", o.symbol);
        		item.put("paidVolume", o.paidVolume);
        		item.put("buyQuantity", o.buyQuantity);
        		item.put("position", o.position); 
        		jspotorder.add(item);            		
			}
		}        		
		obj.put("spotolist", jspotorder);
		model.addAttribute("pobj", obj.toJSONString() );
		
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("wallet2.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("wallet2.do delay delaycheck "+endtime, 2, "delaycheck");				
		return "user/walletWithdraw";
	}
	
	//출금
	@RequestMapping(value = "/kWalletWithdraw.do")
	public String kWalletWithdraw(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		String userIdx = "" + session.getAttribute("userIdx");
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		double withdrawWallet = CointransService.getWithdrawWallet(Integer.parseInt(userIdx), "USDT").doubleValue();
		model.addAttribute("user", sampleDAO.select("selectMemberByIdx", session.getAttribute("userIdx")));
		model.addAttribute("withdrawWallet", withdrawWallet);
		model.addAttribute("refPage", "withdraw");
		return "user/walletWithdrawKRW";
	}

	@RequestMapping(value = "/withdrawal.do")
	public String withdrawal(HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		model.addAttribute("user", sampleDAO.select("selectMemberByIdx", userIdx));
		model.addAttribute("walletBTC", Member.getWalletC(userIdx, "BTC"));
		model.addAttribute("walletUSDT", Member.getWalletC(userIdx, "USDT"));
		model.addAttribute("userIdx", userIdx);
		return "user/withdrawal";
	}
	
	@ResponseBody
	@RequestMapping(value = "/kWithdrawProcess.do", method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String withdrawProcess(HttpServletRequest request, ModelMap model) throws Exception {
		double money = Double.parseDouble(request.getParameter("withdrawMoney"));
		//double fee = Double.parseDouble(request.getParameter("withdrawMoney")) * 2 / 100;
		HttpSession session = request.getSession();
		String userIdx = "" + session.getAttribute("userIdx");
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		EgovMap myInfo = (EgovMap) sampleDAO.select("selectMemberByIdx", in);
		double mwallet = Double.parseDouble(""+myInfo.get("wallet"));
		double withdrawWallet = CointransService.getWithdrawWallet(Integer.parseInt(userIdx), "USDT").doubleValue();
		in.put("money", money);
		in.put("kind", "-");
		/*
		EgovMap withdrawApplyCnt = (EgovMap) sampleDAO.select("withdrawApplyCnt", in);
		String withdrawCnt = "" + withdrawApplyCnt.get("num");
		*/

		JSONObject obj = new JSONObject();
/*		if (Integer.parseInt(withdrawCnt) > 3) {
			obj.put("result", "overapply");
			obj.put("msg", "1일 출금가능 횟수를 초과하였습니다.");
			return obj.toJSONString();
		}*/
		if (money < 0) {
			obj.put("result", "nomoney");
			obj.put("msg", "금액을 입력해주세요.");
			return obj.toJSONString();
		}
		Double eRate = Double.parseDouble(SocketHandler.exchangeRate);
		in.put("exchangeRate", eRate);
		Double eVal = Math.round(money/eRate*100)/100.0;
		in.put("exchangeValue", eVal);

		if (withdrawWallet < eVal) {
			obj.put("result", "moneyWrack");
			obj.put("msg", Message.get().msg(messageSource, "pop.notBalance", request));
		} else {
			EgovMap checkMoneyStat = (EgovMap) sampleDAO.select("checkMoneyStat", in);
			if (checkMoneyStat == null) {
				int idx = (int) sampleDAO.insert("insertMoney", in);
				Member member = Member.getMemberByIdx(Integer.parseInt(userIdx));
			    Wallet.updateWallet(member, mwallet-eVal, (-1)*eVal, "futures", "-", "withdraw");
				in.put("exchangeValue", (-1)*eVal);
				obj.put("result", "suc");
				obj.put("msg", Message.get().msg(messageSource, "wallet.wreqSuccess", request));
				obj.put("protocol", "dwRequest");
				SocketHandler.sh.sendAdminMessage(obj);
			} else {
				obj.put("result", "already");
				obj.put("msg", Message.get().msg(messageSource, "wallet.waitingWreq", request));
			}
		}
		return obj.toJSONString();
	}

	
	@ResponseBody
	@RequestMapping(value = "/userBalanceCheck.do", produces = "application/json; charset=utf8")
	public String userBalanceCheck(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");

		HttpSession session = request.getSession();
		String idx = ""+session.getAttribute("userIdx");
		EgovMap in = new EgovMap();
		in.put("check",1);
		in.put("userIdx",idx);
		sampleDAO.update("updateMemberBalanceCheck",in);
		obj.put("msg", Message.get().msg(messageSource, "wallet.balanceCheckSuc", request));
		obj.put("result", "success");
		return obj.toJSONString();
	}

	public static String stream(String method, String surl, String parameter) throws IllegalStateException {
		String inputLine = null;
		StringBuffer outResult = new StringBuffer();
		String jsonValue = parameter;
		try {
			URL url = new URL(surl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			if (parameter != null)
				conn.setDoOutput(true);
			else
				conn.setDoOutput(false);
			conn.setDoInput(true);// ???
			conn.setRequestMethod(method);
			conn.setRequestProperty("User-Agent", "Mozilla/5.0");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Accept-Charset", "UTF-8");
			// conn.setRequestProperty("sessionkey",
			// "api:fxvare:51692dad8ff84718864f88499806a5b5:1614852187316:HP7e1F+rHr1Rr0cgn0kPt/KZfF8=:yEfMvy");
			conn.setConnectTimeout(10000);
			conn.setReadTimeout(30000);
			if (parameter != null) {
				OutputStream os = conn.getOutputStream();
				os.write(jsonValue.getBytes("UTF-8"));
				os.flush();
			}
			System.out.println("response code:" + conn.getResponseCode());
			// 리턴된 결과 읽기
			BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			while ((inputLine = in.readLine()) != null) {
				outResult.append(inputLine);
			}
			conn.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return outResult.toString();
	}
	
	public String getWithdrawEmailHtml(String code){
		
		String project = Project.getProjectName().toUpperCase();
		String html= "<div style='margin-bottom: 50px;'>안녕하세요, "+project+"입니다.</div><div style='margin-bottom: 20px;'>인증번호 :<span style='margin-left: 5px; color: #5207f6; font-size: 17px; font-weight: 500; letter-spacing: 0.5px; text-decoration: underline;'>"+code+"</span></div><div style='margin-bottom: 50px;'>이 출금 요청을 하지 않으신 경우, 요청을 취소하고 계정 비밀번호를 변경하십시오.</div>";
		
		
		return html;
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateBankInfo.do", produces = "application/json; charset=utf8")
	public String updateBankInfo(HttpServletRequest request) {
		HttpSession session = request.getSession();		
		String userIdx = ""+session.getAttribute("userIdx");
		String kind = request.getParameter("kind");
		String value = request.getParameter("value");
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
		if(kind.equals("bank")){
			in.put("bank", value);
			mem.bank = value;
		}else if(kind.equals("account")){
			in.put("account", value);
			mem.account = value;
		}
		sampleDAO.update("updateMemberBankInfo",in);
		obj.put("msg", Message.get().msg(messageSource, "pop.requestSuccess", request));
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/getTelegramCode.do", produces = "application/json; charset=utf8")
	public String getTelegramCode(HttpServletRequest request){
		HttpSession session = request.getSession();
		Member mem = Member.getMemberByIdx(Integer.parseInt(session.getAttribute("userIdx").toString()));
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		String code = Validation.getTempNumber(6);
		Send.sendTelegramAlarmBot_TempData(mem.phone, mem.pw, code);
		obj.put("code", code);
		obj.put("result", "suc");
		return obj.toJSONString();
	}
}
