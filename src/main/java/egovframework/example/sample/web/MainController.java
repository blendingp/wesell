package egovframework.example.sample.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Copytrade;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Order;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.spot.SpotOrder;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Send;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
public class MainController {
	
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	//@Resource(name="messageSource")
    //MessageSource messageSource;
	
	@RequestMapping(value = "/index.do")
	public String mainPage(HttpServletRequest request, ModelMap model) throws Exception {
		return "redirect:user/main.do";
//		return "imgSlider";
	}
	
	@ResponseBody
	@RequestMapping(value="/testEmail.do")
	public String testEmail(HttpServletRequest request){
		HttpSession session = request.getSession();
		String msg = request.getParameter("msg");
		Send.sendMailTest(request, "zjavbxj15913@naver.com", msg);
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping(value="/testsendtelegram.do")
	public String testsendtelegram(HttpServletRequest request){
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		String msg = request.getParameter("msg");
		Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
//		Send.sendTelegramAlarmBotMsg(msg);
		return "ok";
	}
	
	@RequestMapping(value = "/trade.do")
	public String trade2(HttpServletRequest request, ModelMap model) throws Exception {				
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "trade");
		String userIdx = ""+session.getAttribute("userIdx");
		String userPhone = ""+session.getAttribute("userPhone");
		String language = ""+session.getAttribute("lang");
		String betMode = request.getParameter("betMode");
		String coin = request.getParameter("coin");
		
		Coin Coininfo = null;
		if(coin != null) Coininfo = Coin.getCoinInfo(coin);
		
		if(betMode == null) betMode = "usdt";
		else if(!betMode.equals("inverse") && !betMode.equals("usdt")) betMode = "usdt";
		if(coin == null) coin = "BTC";
		else if(coin.length()>30) return "user/trade";
		else if(betMode.equals("inverse") && Coininfo.coinNum > 3) // 현물 인버스 신규코인 막아둠
			coin = "BTC";
		
		if( userIdx == null || userIdx.equals("null")){ // 로그인 정보가 없으면
			model.addAttribute("wallet", "0"); // null 방지 0원 넣어줌
		}else{ // 로그인 정보가 있으면
			Member user = Member.getMemberByIdx(Integer.parseInt(userIdx));
			int parentsIdx = -1;
			if(user.getParent() != null){
				parentsIdx = user.getParent().userIdx;
			}
			model.addAttribute("wallet", user.getWallet()); // 지갑 동기화
			model.addAttribute("userIdx", userIdx); // 
			model.addAttribute("userPhone", userPhone); // 
			model.addAttribute("parentsIdx", parentsIdx); // 
    		JSONObject obj = new JSONObject();
    		JSONArray j = new JSONArray();
    		JSONArray jorder = new JSONArray();
    		
    		for (Position p : SocketHandler.positionList) {
    			if (p.userIdx == Integer.parseInt(userIdx)) {
    				JSONObject item = new JSONObject();   
            		item.put("userIdx", p.userIdx);
            		item.put("symbol", p.symbol);
            		item.put("position", p.position);
            		item.put("entryPrice", p.entryPrice);
            		item.put("buyQuantity", p.buyQuantity);
            		item.put("liquidationPrice", p.liquidationPrice);
            		item.put("contractVolume", p.contractVolume);
            		item.put("leverage", p.leverage);
            		item.put("margin", 0);//유지 증거금은사라졌지만 다른 모듈과 융통성을 위해 남겨둠
            		item.put("marginType", p.marginType);
            		item.put("fee", p.fee);
            		item.put("TP", p.TP);
            		item.put("SL", p.SL);
            		//sendPositionInit(positionList.get(i));
            		j.add(item);            		
				}
			}        		
    		obj.put("plist", j);
    		
    		for (Order o : SocketHandler.orderList) {
    			if (o.userIdx == Integer.parseInt(userIdx)) {
    				JSONObject item = new JSONObject();   
            		item.put("userIdx", o.userIdx);
            		item.put("symbol", o.symbol);
            		item.put("orderNum", o.orderNum);
            		item.put("orderType", o.orderType);
            		item.put("strategy", o.strategy);
            		item.put("entryPrice", o.entryPrice);
            		item.put("conclusionQuantity", o.conclusionQuantity);
            		item.put("buyQuantity", o.buyQuantity);
            		item.put("paidVolume", PublicUtils.toFixed(o.paidVolume + o.openFee, 5));
            		item.put("mainMargin", 0);//유지 증거금은사라졌지만 다른 모듈과 융통성을 위해 남겨둠
            		item.put("orderTime", o.orderTime);
            		item.put("triggerPrice", o.triggerPrice);
            		item.put("entryPriceForStop", o.entryPriceForStop);
            		item.put("position", o.position);
            		item.put("leverage", o.leverage);
            		item.put("marginType", o.marginType);
            		item.put("isLiq", o.getIsLiq());
            		jorder.add(item);            		
				}
			}        		
    		obj.put("olist", jorder);
    		ArrayList<Copytrade> copylist = Copytrade.getCopytrades(Integer.parseInt(userIdx));
    		JSONArray jcopy = new JSONArray();
    		if(!copylist.isEmpty()){
    			for(int i = 0; i < copylist.size(); i++){
    				JSONObject item = new JSONObject(); 
    				item.put("symbol", copylist.get(i).symbol);
    				jcopy.add(item);
    			}
    		}
    		obj.put("clist", jcopy);
    		model.addAttribute("pobj", obj.toJSONString() );
		}
		model.addAttribute("nowpage", "tradep");
		model.addAttribute("language", language); // 
		model.addAttribute("betMode", betMode); // 
		model.addAttribute("coin", coin); // 
		model.addAttribute("useCoins", Project.getUseCoinNames());
		return "user/trade";
	}
	
	@RequestMapping(value = "/user/chart.do")
	public String chart(HttpServletRequest request, ModelMap model) throws Exception {
		String type = request.getParameter("type");
		if(Validation.isNull(type)){
			type = "unlisted";
		}
		
		EgovMap in = new EgovMap();
		in.put("type", type);
		in.put("limit", 50);
		
		List<?> list = (List<?>) sampleDAO.list("exchangeL", in);
		model.addAttribute("list", list);
		
		model.addAttribute("type", type);
		
		return "user/chart";
	}
	
	@RequestMapping(value = "/tradeSpot.do")
	public String tradeSpot(HttpServletRequest request, ModelMap model) throws Exception {
		//코인 종목
		String coin = request.getParameter("coin");
		if(coin == null) coin = "BTC";
		model.addAttribute("coin", coin); 
		
		//보유자산(현물)
		HttpSession session = request.getSession();		
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
		
		JSONObject obj = new JSONObject();
		JSONArray j = new JSONArray();
		JSONArray jorder = new JSONArray();
/*		
		for (Position p : SocketHandler.positionList) {
			if (p.userIdx == userIdx) {
				JSONObject item = new JSONObject();   
        		item.put("userIdx", p.userIdx);
        		item.put("symbol", p.symbol);
        		item.put("position", p.position);
        		item.put("entryPrice", p.entryPrice);
        		item.put("buyQuantity", p.buyQuantity);
        		item.put("liquidationPrice", p.liquidationPrice);
        		item.put("contractVolume", p.contractVolume);
        		item.put("leverage", p.leverage);
        		item.put("margin", 0);//유지 증거금은사라졌지만 다른 모듈과 융통성을 위해 남겨둠
        		item.put("marginType", p.marginType);
        		item.put("fee", p.fee);
        		item.put("TP", p.TP);
        		item.put("SL", p.SL);
        		//sendPositionInit(positionList.get(i));
        		j.add(item);            		
			}
		}        		
		obj.put("plist", j);*/
		
		for (SpotOrder o : SocketHandler.spotOrderList) {
			if (o.userIdx == userIdx) {
				JSONObject item = new JSONObject();   
        		item.put("userIdx", o.userIdx);
        		item.put("symbol", o.symbol);
        		item.put("orderNum", o.orderNum);
        		item.put("orderType", o.orderType);
        		item.put("entryPrice", o.entryPrice);
        		item.put("conclusionQuantity", o.conclusionQuantity);
        		item.put("buyQuantity", o.buyQuantity);
        		item.put("paidVolume", o.paidVolume);        		
        		item.put("orderTime", o.orderTime);
        		item.put("triggerPrice", o.triggerPrice);
        		item.put("entryPriceForStop", o.entryPriceForStop);
        		item.put("position", o.position);        		
        		jorder.add(item);            		
			}
		}        		
		obj.put("olist", jorder);		
		model.addAttribute("pobj", obj.toJSONString() );
		model.addAttribute("useCoins", Project.getUseCoinNames());
		return "user/tradeSpot";
	}
	
	@ResponseBody
	@RequestMapping(value="/changeLanguage.do")
	public String changeLanguage(HttpServletRequest request){
		HttpSession session = request.getSession();
		String lang = request.getParameter("lang");
		if(lang.length()>30){
			return "fail";
		}
		Locale locales = new Locale(lang);
		session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locales);
		session.setAttribute("lang", lang.toUpperCase());
		return "ok";
	}
	
	@RequestMapping(value="/showRest.do")
	public String showRest(HttpServletRequest request){		
		return "user/showrest";
	}
	
	@RequestMapping(value="/block.do")
	public String block(HttpServletRequest request){		
		return "user/block";
	}
	
	@ResponseBody
	@RequestMapping(value="/getCoinInfo.do", produces = "application/json; charset=utf8")
	public String getCoinInfo(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		JSONArray useCoinArray = new JSONArray();
		JSONArray coinWalletArray = new JSONArray();
		JSONArray rateArray = new JSONArray();
		String userIdx = request.getParameter("userIdx");
		if(!userIdx.isEmpty()){
			Member user = Member.getMemberByIdx(Integer.parseInt(userIdx));
			for(Coin coin : Project.getFullCoinList()){
				JSONObject item = new JSONObject();
				item.put("cnum", coin.coinNum);
				item.put("wallet", user.getWalletC(coin.coinName+"USD"));
				coinWalletArray.add(item);
			}
		}

		ArrayList<Coin> useCoins = Project.getUseCoinList();
		for(Coin coin : useCoins){
			JSONObject item = new JSONObject();
			item.put("cnum", coin.coinNum);
			item.put("name", coin.coinName);
			item.put("maxLeverage", coin.maxLeverage);
			item.put("qtyFixed", coin.qtyFixed);
			item.put("priceFixed", coin.priceFixed);
			item.put("contractVolume", Coin.getMaxContractVolume(coin, coin.maxLeverage));
			item.put("maxVolumeType", coin.maxVolumeType);
			useCoinArray.add(item);
		}
		
		rateArray.add(SocketHandler.sh.setting.rate[0]);
		rateArray.add(SocketHandler.sh.setting.rate[1]);
		rateArray.add(SocketHandler.sh.setting.rate[2]);
		rateArray.add(SocketHandler.sh.setting.rate[3]);
		obj.put("rateArray", rateArray);
		
		obj.put("coinWallet", coinWalletArray);
		obj.put("useCoins", useCoinArray);
		obj.put("maxCoinLength", Project.getFullCoinList().size());
		
		if(!userIdx.isEmpty() && request.getParameter("spot") != null){
			JSONArray spotLongArray = new JSONArray();
			ArrayList<EgovMap> spotList = (ArrayList<EgovMap>)sampleDAO.list("selectSpotLongEntryList",userIdx);
			for(EgovMap tradelog : spotList){
				JSONObject item = new JSONObject();
				item.put("cnum", Coin.getCoinInfo(""+tradelog.get("symbol")).coinNum);
				item.put("entryPrice", tradelog.get("entryPrice"));
				spotLongArray.add(item);
			}
			obj.put("spotLongArray", spotLongArray);
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/getExchangeRate.do", produces = "application/json; charset=utf8")
	public String getExchangeRate(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("exRate", SocketHandler.exchangeRate);
		return obj.toJSONString();
	}
}
