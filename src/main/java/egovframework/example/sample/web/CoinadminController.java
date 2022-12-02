package egovframework.example.sample.web;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.Calendar;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.spot.SpotOrder;
import egovframework.example.sample.web.util.CryptoUtil;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
public class CoinadminController {
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@RequestMapping(value="/user/exchange.do")
	public String exchange3(HttpServletRequest request , ModelMap model){
		long starttime = Calendar.getInstance().getTime().getTime();

		String result = ""+request.getParameter("result");
		if(result.length()>50){
			return "user/exchange";
		}
		model.addAttribute("result", result);
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(""+session.getAttribute("userIdx"));
		model.addAttribute("user", sampleDAO.select("selectMemberByIdx",userIdx));
		model.addAttribute("walletBTC", Member.getWalletC(userIdx, "BTC"));
		model.addAttribute("walletUSDT",Member.getWalletC(userIdx, "USDT"));
		model.addAttribute("walletXRP", Member.getWalletC(userIdx, "XRP"));
		model.addAttribute("walletTRX",Member.getWalletC(userIdx, "TRX"));
		model.addAttribute("walletETH",Member.getWalletC(userIdx, "ETH"));
		model.addAttribute("refPage","exchange");
		
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
        		item.put("marginType", SocketHandler.positionList.get(i).marginType);
        		j.add(item);            		
			}
		}  
		obj.put("plist", j);
		for (int i = 0; i < SocketHandler.orderList.size(); i++) {
			if (SocketHandler.orderList.get(i).userIdx == userIdx) {
				if(SocketHandler.orderList.get(i).getIsLiq() == 1)
					continue;
				
				Log.print(i+" 오더 리스트 ", 5, "call");
				JSONObject item = new JSONObject();   
        		item.put("symbol", SocketHandler.orderList.get(i).symbol);
        		item.put("paidVolume", SocketHandler.orderList.get(i).paidVolume);
        		jorder.add(item);            		
			}
		}        		
		obj.put("olist", jorder);
		model.addAttribute("pobj", obj.toJSONString() );
		
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("exchange2.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("exchange2.do delay delaycheck "+endtime, 2, "delaycheck");
		return "user/exchange";
	}

	@RequestMapping(value="/user/transfer.do")
	public String transfer(HttpServletRequest request , ModelMap model){
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		String result = ""+request.getParameter("result");
		if(result.length()>50){
			return "user/exchange";
		}
		
		model.addAttribute("result", result);
		model.addAttribute("walletBTC",Member.getWalletC(userIdx, "BTC"));
		model.addAttribute("walletXRP",Member.getWalletC(userIdx, "XRP"));
		model.addAttribute("walletTRX",Member.getWalletC(userIdx, "TRX"));
		model.addAttribute("walletUSDT",Member.getWalletC(userIdx, "USDT"));
		model.addAttribute("wallet", Member.getWallet(userIdx));
		double withdrawWallet = CointransService.getWithdrawWallet(userIdx, "futures").doubleValue();
		double withdrawUSDT = CointransService.getWithdrawWallet(userIdx, "USDT").doubleValue();
		model.addAttribute("withdrawWallet", withdrawWallet);
		model.addAttribute("withdrawUSDT", withdrawUSDT);
		model.addAttribute("refPage","transfer");
		
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
		return "user/transfer";
	}	

	@ResponseBody
	@RequestMapping(value="/user/getWithdrawFutures.do", produces = "application/json; charset=utf8")
	public String getWithdrawFutures(HttpServletRequest request , ModelMap model){
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		JSONObject obj = new JSONObject();
		obj.put("withdrawWallet",CointransService.getWithdrawWallet(Integer.parseInt(userIdx),"futures"));
		obj.put("withdrawUSDT",CointransService.getWithdrawWallet(Integer.parseInt(userIdx),"USDT"));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/user/exchangeProcess.do", produces = "application/json; charset=utf8")
	public String exchangeProcess(HttpServletRequest request , ModelMap model){
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		String samount = request.getParameter("conversion");
		String direction = request.getParameter("direction");
		
		double amount=0;
		String result = "";
		JSONObject obj = new JSONObject();		
		obj.put("result", "fail");
		if(samount.length()>100 || direction.length()>5){
			return obj.toJSONString();
		}
		try{
			amount = Double.parseDouble(samount);
		}catch(Exception e){Log.print("비트코인 교환시 파싱 에러", 2, "err");}
		if( direction.compareTo("0") == 0 ){ //usdt -> btc
			result = CointransService.exchangeUSDTToCoin(userIdx, amount,"BTC");
		}else if( direction.compareTo("1") == 0){ //btc -> usdt
			result = CointransService.exchangeCoinToUSDT(userIdx, amount,"BTC");
		}
		else if( direction.compareTo("2") == 0){ //usdt -> xrp
			result = CointransService.exchangeUSDTToCoin(userIdx, amount,"XRP");
		}else if( direction.compareTo("3") == 0){ //xrp -> usdt
			result = CointransService.exchangeCoinToUSDT(userIdx, amount,"XRP");
		}else if( direction.compareTo("4") == 0){ //usdt -> trx
			result = CointransService.exchangeUSDTToCoin(userIdx, amount,"TRX");
		}else if( direction.compareTo("5") == 0){ //trx -> usdt
			result = CointransService.exchangeCoinToUSDT(userIdx, amount,"TRX");
		}else if( direction.compareTo("6") == 0){ //usdt -> Eth 
			result = CointransService.exchangeUSDTToCoin(userIdx, amount,"ETH");
		}else if( direction.compareTo("7") == 0){ //Eth -> usdt
			result = CointransService.exchangeCoinToUSDT(userIdx, amount,"ETH");
		}
		
		if(result.compareTo("fail")==0){
			obj.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
			return obj.toJSONString();
		}
		obj.put("walletBTC", Member.getWalletC(userIdx, "BTC"));
		obj.put("walletUSDT",Member.getWalletC(userIdx, "USDT"));
		obj.put("walletXRP", Member.getWalletC(userIdx, "XRP"));
		obj.put("walletTRX",Member.getWalletC(userIdx, "TRX"));
		obj.put("walletETH",Member.getWalletC(userIdx, "ETH"));
		
		obj.put("result", "success");
		obj.put("msg", Message.get().msg(messageSource, "pop.requestSuccess", request));
		return obj.toJSONString();
	}
	
	//transfer	
	@RequestMapping(value="/user/transferProcess.do")
	public String transferProcess(HttpServletRequest request , ModelMap model){
		HttpSession session = request.getSession();
		String samount = request.getParameter("conversion");
		String direction = request.getParameter("direction");
		String max = request.getParameter("max");
		
		String result = "";
		if(samount.length()>100 || direction.length()>5){
			return "redirect:/user/transfer.do?result="+result;
		}
		
		double amount=0;		
		try{
			amount = Double.parseDouble(samount);
		}catch(Exception e){
			Log.print("포인트 교환시 파싱 에러", 2, "err_notsend");
			return "fail";
		}
		boolean isMax = false;
		if(max.equals("1"))
			isMax = true;
		if( direction.compareTo("1") == 0 ){ //usdt -> point
			result = CointransService.transUsdtToPoint(""+session.getAttribute("userIdx"), amount, isMax);
		}else{//point ->usdt
			result = CointransService.transPointToUsdt(""+session.getAttribute("userIdx"), amount, isMax);
		}
		return "redirect:/user/transfer.do?result="+result;
	}

	//입금
	@ResponseBody
	@RequestMapping(value = "/depositProcess.do")
	public String depositProcess(HttpServletRequest request, ModelMap model) throws Exception {
		long starttime = Calendar.getInstance().getTime().getTime();
		Log.print("입금 처리 시작", 1, "inmoney");
		String useridx = ""+request.getParameter("useridx");
		
		if(useridx.length()>100){
			return "fail";
		}
		double price = Double.parseDouble(""+request.getParameter("price"));
		if(price < 0) return "fail";
		String coinname = ""+request.getParameter("coinname");		
		Log.print("입금 처리 uidx:"+useridx+" price:"+price+" coinname:"+coinname , 1, "inmoney");
		CointransService.depositProcess(useridx,  price, coinname);
		long endtime = Calendar.getInstance().getTime().getTime() - starttime;
		Log.print("depositProcess.do processtime "+endtime, 2, "timecheck");
		if( endtime > 400) Log.print("depositProcess.do delay delaycheck "+endtime, 2, "delaycheck");	
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping(value = "/createXRPWallet.do", produces = "application/json; charset=utf8")
	public String createXRPWallet(HttpServletRequest request , ModelMap model) throws UnsupportedEncodingException, ParseException, NoSuchAlgorithmException, GeneralSecurityException{
		JSONObject obj = new JSONObject();
		CryptoUtil crypto = CryptoUtil.getInstance();
		String xrpWallet = JoinController.createWallet("POST", "http://"+request.getServerName()+":5000/v1/xrp/addresses/generate", null );
		Log.print("xrp:"+xrpWallet, 0, "test" );
		if(xrpWallet == null || xrpWallet.equals("")){
			obj.put("result", "fail");
			obj.put("msg", "xrp wallet error");
			return obj.toJSONString();
		}
		JSONParser xrpp = new JSONParser();
		JSONObject xrpObj = (JSONObject) xrpp.parse(xrpWallet);
		String xrpAddress = (String) xrpObj.get("address");
		String xrpPassword = crypto.encrypt((String) xrpObj.get("secret"));
		String xrpResult = (String) "xrp address: "+xrpObj.get("address")+"  password: "+xrpObj.get("secret");
		Log.print("xrp result:"+xrpResult, 0, "test" );
		EgovMap in=new EgovMap();	
		in.put("xrpAddress", xrpAddress);
		in.put("xrpPassword", xrpPassword);
		sampleDAO.update("updateXRPWallet",in);
		obj.put("msg", xrpResult);
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/createWallet.do")
	public String createWallet(HttpServletRequest request , ModelMap model) throws UnsupportedEncodingException, ParseException, NoSuchAlgorithmException, GeneralSecurityException{
		return "admin/createWallet";
	}

}
