package egovframework.example.sample.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Copytrade;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Trader;
import egovframework.example.sample.enums.CopytradeState;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/user")
public class CopyTradeController {
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	//트레이더 목록
	@RequestMapping(value = "/traderList.do")
	public String traderList(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "trader");
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("search", request.getParameter("search"));
		
		int userIdx = Integer.parseInt(""+session.getAttribute("userIdx"));
		model.addAttribute("isTrader",Member.getMemberByIdx(userIdx).isTrader);
		
		pi.setTotalRecordCount((int) sampleDAO.select("copyTraderListCnt", in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("copyTraderList", in);
		model.addAttribute("list", getTradersInfo(list));
		model.addAttribute("pi", pi);
		model.addAttribute("search", request.getParameter("search"));
		return "copy/traderList";
	}
	
	@ResponseBody
	@RequestMapping(value="/traderListLoadData.do" , produces="application/json; charset=utf8")
	public String traderListLoadData(HttpServletRequest request){
		String [] tidxs = request.getParameterValues("tidxs");
		JSONObject obj = new JSONObject();
		JSONArray j = new JSONArray();
		obj.put("result", "fail");
		
		for(String tidx : tidxs){
			JSONObject item = new JSONObject();
			item.put("tidx",tidx);
			EgovMap tin = new EgovMap();
			tin.put("tuseridx", tidx);
			EgovMap info = (EgovMap)sampleDAO.select("selectTraderInfo",tin);
			EgovMap in = new EgovMap();
			in.put("tidx", tidx);
			
			if(info == null || !Boolean.parseBoolean(info.get("useOtherInfo").toString())){
				Trader trader = Member.getMemberByIdx(Integer.parseInt(tidx)).getTrader();
				for(Coin coin : Project.getFullCoinList()){
					in.put("is"+coin.coinName, trader.getCoinUseInt(coin));
				}
				in.put("traderShow", 1);
				ArrayList<EgovMap> tradelogList = (ArrayList<EgovMap>)sampleDAO.list("selectTradeLogListAll",in);
				double profitUSDT = 0; 
				double fee = 0;
				int pcount = 0;
				double sumRoi = 0;
				
				for(EgovMap log : tradelogList){
					double margin = Double.parseDouble(log.get("margin").toString());
					double result = Double.parseDouble(log.get("result").toString());
					if(result > 0)
						pcount++;
					profitUSDT += result;
					fee += margin;
					sumRoi += Coin.getRoi(result, margin);
				}
				if(Project.isCopyProfitShowSum())
					item.put("roi", PublicUtils.toFixed(sumRoi, 2)); //수익률(ROI) - ( 수익 / 증거금 ) * 100
				else
					item.put("roi", Coin.getRoi(profitUSDT,fee)); //수익률(ROI) - ( 수익 / 증거금 ) * 100
				item.put("tradeCount", tradelogList.size()); //거래 수량 - 거래 회수 DB
				item.put("profitUSDT", profitUSDT); //누적수익(USDT) - 모든 거래 profit 합
				item.put("winCount", pcount); //winCount
			}else{
				item.put("roi", info.get("profitRate")); //수익률(ROI) - ( 수익 / 증거금 ) * 100
				item.put("tradeCount", info.get("tradeCount")); //거래 수량 - 거래 회수 DB
				item.put("profitUSDT", info.get("revenue")); //누적수익(USDT) - 모든 거래 profit 합
				item.put("winRate", info.get("winRate")); //winCount
			}
			if(info == null || !Boolean.parseBoolean(info.get("useFollow").toString())){
				item.put("follower", sampleDAO.select("copyTraderAllFollower",in)); //누적 팔로워 수 - 누적 팔로워 DB
			}else{
				item.put("follower", info.get("fAccum")); //누적 팔로워 수 - 누적 팔로워 DB
			}
			j.add(item);   
		}
		obj.put("tinfo", j);
		obj.put("result", "suc");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/traderInsertProcess.do" , produces="application/json; charset=utf8")
	public String traderInsertProcess(MultipartHttpServletRequest request){
		HttpSession session = request.getSession();
		int tidx = Integer.parseInt(""+session.getAttribute("userIdx"));
		MultipartFile file = request.getFile("timg");
		String text = request.getParameter("text");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(text == null || text.trim().equals("")){
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.inputTitle", request));
			return obj.toJSONString();
		}
		if(text.length() > 150){
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.textUnder", request));
			return obj.toJSONString();
		}
        if(file.isEmpty()){
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.inputFile", request));
			return obj.toJSONString();
        }
        if(Member.getMemberByIdx(tidx).getTrader() != null){
        	obj.put("msg", Message.get().msg(messageSource, "copyNoti.alreadyTrader", request));
			return obj.toJSONString();
        }
        if(sampleDAO.select("selectIsTrader",tidx) != null){
        	obj.put("msg", Message.get().msg(messageSource, "copyNoti.confirmReady", request));
			return obj.toJSONString();
        }
        
        text = text.replaceAll("(?i)<script", "&lt;script");
        
		String filePath = "C:/upload/wesell/photo/";
		EgovMap in = new EgovMap();
        File fileP = new File(filePath);
        if(!fileP.exists()) {
        	fileP.mkdirs();
        }
        String originNm = file.getOriginalFilename();
		String saveNm = UUID.randomUUID().toString().replaceAll("-", "") + originNm.substring(originNm.lastIndexOf("."));
		try {
			file.transferTo(new File(filePath+saveNm));
			in.put("tuseridx", tidx);
			in.put("tintro", text);
			in.put("timg",saveNm);
			sampleDAO.insert("insertTrader",in);
			obj.put("msg",Message.get().msg(messageSource, "copyNoti.requestSuc", request));
			
			obj.put("protocol", "copytraderInsert");
			SocketHandler.sh.sendAdminMessage(obj);
			SocketHandler.copytraderRequest++;
			obj.put("result","success");
			return obj.toJSONString();
		} catch (Exception e) {
			obj.put("msg",Message.get().msg(messageSource, "copyNoti.fileFail", request));
			return obj.toJSONString();
		}
	}
	
	//트레이더 목록
	@RequestMapping(value = "/traderTradeLog.do")
	public String traderTradeLog(HttpServletRequest request, ModelMap model) throws Exception {	
		String tidx = ""+request.getParameter("tidx");	
		Trader trader = Member.getMemberByIdx(Integer.parseInt(tidx)).getTrader();
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("hide", 0);
		in.put("tidx", tidx);
		for(Coin coin : Project.getFullCoinList()){
			in.put("is"+coin.coinName, trader.getCoinUseInt(coin));
		}
		EgovMap traderInfo = (EgovMap)sampleDAO.select("getTraderInfo", in);
		traderInfo.put("follow", trader.getFollowCount());
		model.addAttribute("traderInfo", traderInfo);
		pi.setTotalRecordCount((int) sampleDAO.select("copyTraderTradeLogListCnt", in));
		model.addAttribute("list", sampleDAO.list("copyTraderTradeLogList", in));
		model.addAttribute("pi", pi);
		model.addAttribute("search", request.getParameter("search"));
		model.addAttribute("tidx", tidx);
		return "copy/traderTradeLog";
	}
	
	@RequestMapping(value = "/traderTlogSwitch.do")
	public String traderTlogSwitch(HttpServletRequest request, ModelMap model) throws Exception {	
		String tidx = ""+request.getParameter("tidx");	
		Trader trader = Member.getMemberByIdx(Integer.parseInt(tidx)).getTrader();
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("tidx", tidx);
		for(Coin coin : Project.getFullCoinList()){
			in.put("is"+coin.coinName, trader.getCoinUseInt(coin));
		}
		EgovMap traderInfo = (EgovMap)sampleDAO.select("getTraderInfo", in);
		traderInfo.put("follow", trader.getFollowCount());
		model.addAttribute("traderInfo", traderInfo);
		pi.setTotalRecordCount((int) sampleDAO.select("copyTraderTradeLogListCnt", in));
		model.addAttribute("list", sampleDAO.list("copyTraderTradeLogList", in));
		model.addAttribute("pi", pi);
		model.addAttribute("search", request.getParameter("search"));
		model.addAttribute("tidx", tidx);
		return "copy/traderTlogSwitch";
	}

	@RequestMapping(value = "/myCopytradeInfo.do")
	public String myCopytradeInfo(HttpServletRequest request, ModelMap model) throws Exception {	
		HttpSession session = request.getSession();
		int useridx = Integer.parseInt(""+session.getAttribute("userIdx"));
		EgovMap in = new EgovMap();
		in.put("uidx", useridx);
		
		EgovMap info = (EgovMap)sampleDAO.select("selectFollowerMoney",in);
		double profit = 0; 
		double fMoney = 0;
		
		if(info != null){
			profit += Double.parseDouble(info.get("profitSum").toString());
			fMoney += Double.parseDouble(info.get("usdtSum").toString());
		}
		
		EgovMap myCopyInfo = new EgovMap();
		myCopyInfo.put("profit", profit - fMoney); 
		myCopyInfo.put("fMoney", fMoney); 
		model.addAttribute("myCopyInfo",myCopyInfo);
		
		return "copy/myCopytradeInfo";
	}
	@RequestMapping(value = "/copyTraderInfo.do")
	public String copyTraderInfo(HttpServletRequest request, ModelMap model) throws Exception {	
		int tidx = Integer.parseInt(request.getParameter("tidx").toString());
		Trader trader = Member.getMemberByIdx(tidx).getTrader();
		EgovMap in = new EgovMap();

		in.put("tuseridx", tidx);
		EgovMap info = (EgovMap)sampleDAO.select("selectTraderInfo",in);
		EgovMap tinfo = new EgovMap();
		tinfo.put("minRegistWallet", trader.getMinRegistWallet());
		in.put("tidx", tidx);
		
		for(Coin coin : Project.getFullCoinList()){
			tinfo.put(coin.coinName.toLowerCase(), trader.getCoinUse(coin));
		}
		
		if(info == null || !Boolean.parseBoolean(info.get("useOtherInfo").toString())){
			for(Coin coin : Project.getFullCoinList()){
				in.put("is"+coin.coinName, trader.getCoinUseInt(coin));
			}
			in.put("traderShow", 1);
			ArrayList<EgovMap> tradelogList = (ArrayList<EgovMap>)sampleDAO.list("selectTradeLogListAll",in);
			double profitUSDT = 0; 
			double fee = 0;
			int pcount = 0;
			int lcount = 0;
			double sumRoi = 0;
			for(EgovMap log : tradelogList){
				double result = Double.parseDouble(log.get("result").toString());
				double margin = Double.parseDouble(log.get("margin").toString());
				if(result > 0)
					pcount++;
				else
					lcount++;
				
				profitUSDT += result;
				fee += margin;
				sumRoi += Coin.getRoi(result, margin);
			}
			
			if(Project.isCopyProfitShowSum())
				tinfo.put("roi", PublicUtils.toFixed(sumRoi, 2)); //수익률(ROI) - ( 수익 / 증거금 ) * 100
			else
				tinfo.put("roi", Coin.getRoi(profitUSDT,fee)); //수익률(ROI) - ( 수익 / 증거금 ) * 100
				
			tinfo.put("tradeCount", tradelogList.size()); //거래 수량 - 거래 회수 DB
			tinfo.put("profitUSDT", profitUSDT); //누적수익(USDT) - 모든 거래 profit 합
			tinfo.put("profitCount", pcount); //이익 - 이익거래 수
			tinfo.put("lossCount", lcount); //손실 - 손실거래 수
			
		}else{
			tinfo.put("roi", info.get("profitRate")); //수익률(ROI) - ( 수익 / 증거금 ) * 100
			tinfo.put("tradeCount", info.get("tradeCount")); //거래 수량 - 거래 회수 DB
			tinfo.put("profitUSDT", info.get("revenue")); //누적수익(USDT) - 모든 거래 profit 합
			tinfo.put("profitCount", info.get("avail")); //이익 - 이익거래 수
			tinfo.put("lossCount", info.get("loss")); //손실 - 손실거래 수
		}
		
		if(info == null || !Boolean.parseBoolean(info.get("useFollow").toString())){
			tinfo.put("follower", sampleDAO.select("copyTraderAllFollower",in)); //누적 팔로워 수 - 누적 팔로워 DB
		}else{
			tinfo.put("follower", info.get("fAccum")); //누적 팔로워 수 - 누적 팔로워 DB
			tinfo.put("follow", info.get("follow")); //누적 팔로워 수 - 누적 팔로워 DB
		}
		
		model.addAttribute("tinfo",tinfo);
		
		return "copy/copyTraderInfo";
	}
	@ResponseBody
	@RequestMapping(value="/pairSelect.do" , produces="application/json; charset=utf8")
	public String pairSelect(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int tidx = Integer.parseInt(""+request.getParameter("tidx"));
		int userIdx = Integer.parseInt(""+session.getAttribute("userIdx"));
		obj.put("result", "fail");
		
		if(userIdx != tidx){
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.noRight", request));
			return obj.toJSONString();
		}
		
		boolean isUseCoin [] = new boolean[Project.getFullCoinList().size()];
		for(int i = 0; i < isUseCoin.length; i++){
			Coin coin = Coin.getCoinInfo(i);
			String val = request.getParameter("is"+coin.coinName);
			if(val != null){
				isUseCoin[i] = Boolean.parseBoolean(val);
			}
		}
		
		if(!Trader.setTraderUse(userIdx,isUseCoin)){
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.fail", request));
			return obj.toJSONString();
		}
		obj.put("result", "suc");
		obj.put("msg", Message.get().msg(messageSource, "copyNoti.change", request));
		return obj.toJSONString();
	}
	
	//트레이더 목록 상세내역
	@RequestMapping(value = "/traderPosition.do")
	public String traderPosition(HttpServletRequest request, ModelMap model) throws Exception {	
		String tidx = ""+request.getParameter("tidx");
		JSONObject obj = new JSONObject();
		JSONArray j = new JSONArray();
		Trader trader = Member.getMemberByIdx(Integer.parseInt(tidx)).getTrader();
		for (int i = 0; i < SocketHandler.positionList.size(); i++) {
			if (SocketHandler.positionList.get(i).userIdx == Integer.parseInt(tidx)) {
				JSONObject item = new JSONObject();   
        		item.put("userIdx", SocketHandler.positionList.get(i).userIdx);
        		item.put("symbol", SocketHandler.positionList.get(i).symbol);
        		item.put("position", SocketHandler.positionList.get(i).position);
        		item.put("entryPrice", SocketHandler.positionList.get(i).entryPrice);
        		item.put("buyQuantity", SocketHandler.positionList.get(i).buyQuantity);
        		item.put("liquidationPrice", SocketHandler.positionList.get(i).liquidationPrice);
        		item.put("contractVolume", SocketHandler.positionList.get(i).contractVolume);
        		item.put("leverage", SocketHandler.positionList.get(i).leverage);
        		item.put("margin", 0);//유지 증거금은사라졌지만 다른 모듈과 융통성을 위해 남겨둠
        		item.put("marginType", SocketHandler.positionList.get(i).marginType);
        		item.put("fee", SocketHandler.positionList.get(i).fee);
        		j.add(item);            		
			}
		}
		obj.put("plist", j);
		model.addAttribute("pobj",j);
		
		EgovMap in = new EgovMap();
		in.put("search", request.getParameter("search"));
		in.put("tidx", tidx);
		EgovMap traderInfo = (EgovMap)sampleDAO.select("getTraderInfo", in);
		traderInfo.put("follow", trader.getFollowCount());
		model.addAttribute("traderInfo", traderInfo);
		model.addAttribute("list", sampleDAO.list("copyTraderPositionList", in));
		model.addAttribute("search", request.getParameter("search"));
		model.addAttribute("tidx", tidx);
		return "copy/traderPosition";
	}
	//트레이더 팔로워
	@RequestMapping(value = "/traderfollower.do")
	public String traderfollower(HttpServletRequest request, ModelMap model) throws Exception {	
		String tidx = ""+request.getParameter("tidx");				
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
		in.put("tidx", tidx);
		Trader trader = Member.getMemberByIdx(Integer.parseInt(tidx)).getTrader();

		EgovMap traderInfo = (EgovMap)sampleDAO.select("getTraderInfo", in);
		traderInfo.put("follow", trader.getFollowCount());
		model.addAttribute("traderInfo", traderInfo);
		
		pi.setTotalRecordCount(trader.getFollowCount());
		model.addAttribute("list", trader.getFollowersMap());
		model.addAttribute("pi", pi);
		model.addAttribute("tidx", tidx);
		return "copy/traderfollower";
	}
	// 현재 팔로우 트레이딩 주문
	@RequestMapping(value="/traderFollowerOrder.do")
	public String traderFollowerOrder(HttpServletRequest request , ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(""+session.getAttribute("userIdx"));
		
//		ArrayList<EgovMap> list = new ArrayList<>();
		ArrayList<EgovMap> list = Copytrade.getRunMaps(userIdx);
		model.addAttribute("list",list);
		return"copy/traderFollowerOrder";
	}
	@ResponseBody
	@RequestMapping(value="/traderDelete.do" , produces="application/json; charset=utf8")
	public String traderDelete(HttpServletRequest request){
		String useridx = request.getParameter("userIdx");
		String symbol = request.getParameter("symbol");
		JSONObject obj = new JSONObject();
		try {
			Copytrade copy = Copytrade.getCopytrade( Integer.parseInt(useridx), symbol);
			if(copy == null){
				obj.put("msg", Message.get().msg(messageSource, "copyNoti.noCancel", request));
				return obj.toJSONString();
			}else{
				copy.updateCopytrade(copy , CopytradeState.SELFSTOP );
				obj.put("msg", Message.get().msg(messageSource, "copyNoti.suc", request));
				return obj.toJSONString();
			}
		} catch (Exception e) {
			// TODO: handle exception
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.err", request));
			return obj.toJSONString();
		}
	}
	@RequestMapping("/followTradeList.do")
	public String followTradeList(HttpServletRequest request , Model model){
		HttpSession session = request.getSession();
		String coin = request.getParameter("coin");
		String uidx = ""+session.getAttribute("userIdx");
		String pageIndex = request.getParameter("pageIndex");
		PaginationInfo pi = new PaginationInfo(); // 미리 만들어진 페이징 소스 
		if(pageIndex == null || pageIndex.equals("")){
			pi.setCurrentPageNo(1);//현재페이지 번호 
		}else{
			pi.setCurrentPageNo(Integer.parseInt(pageIndex));
		}
		pi.setRecordCountPerPage(15);// 한 페이지당 보여줄 개수 
		pi.setPageSize(7); //페이지의 개수 
		
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("uidx", uidx);
		in.put("coin", coin);
		List<EgovMap> tradeList = (List<EgovMap>)sampleDAO.list("selectFollowTradeList",in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectFollowTradeListCnt",in));
		model.addAttribute("tradeList",tradeList);
		model.addAttribute("pi",pi);
		model.addAttribute("coin",coin);
		model.addAttribute("useCoins",Project.getUseCoinNames());
		return"copy/followTradeList";
	}
	@RequestMapping("/follower.do")
	public String follower(HttpServletRequest request , Model model){
		HttpSession session = request.getSession();
		String pageIndex = request.getParameter("pageIndex");
		String uidx = ""+session.getAttribute("userIdx");
		PaginationInfo pi = new PaginationInfo(); // 미리 만들어진 페이징 소스 
		if(pageIndex == null || pageIndex.equals("")){
			pi.setCurrentPageNo(1);//현재페이지 번호 
		}else{
			pi.setCurrentPageNo(Integer.parseInt(pageIndex));
		}
		pi.setRecordCountPerPage(15);// 한 페이지당 보여줄 개수 
		pi.setPageSize(7); //페이지의 개수 
		
		EgovMap in = new EgovMap();
		in.put("uidx", uidx);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		List<EgovMap> followList = (List<EgovMap>)sampleDAO.list("selectCopyFollowList",in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectCopyFollowListCnt",in));
		model.addAttribute("followList",followList);
		model.addAttribute("pi",pi);
		return"copy/follower";
	}
	@RequestMapping("/followApplication.do")
	public String followApplication(HttpServletRequest request , Model model){
		HttpSession session = request.getSession();
		session.setAttribute("currentP","trader");
		int tidx = Integer.parseInt(request.getParameter("tidx").toString());
		model.addAttribute("trader", sampleDAO.select("getTraderInfo", tidx));
		model.addAttribute("tidx",  tidx);
		
		Trader trader = Member.getMemberByIdx(tidx).getTrader();
		Project.getUseCoinNames();
		ArrayList<Coin> useCoins = Project.getUseCoinList();
		ArrayList<String> traderUseCoins = new ArrayList<>();
		JSONObject obj = new JSONObject();
		for(Coin coin : useCoins){
			obj.put(coin.coinName.toLowerCase(), trader.getCoinUse(coin)); // 업데이트 안된 다른 프로젝트 호환성
			
			if(trader.getCoinUse(coin)){
				traderUseCoins.add(coin.coinName);
			}
		}
		model.addAttribute("useCoin",obj.toJSONString());
		model.addAttribute("useCoins",traderUseCoins);
		
		return"copy/followApplication";
	}
	
	@ResponseBody
	@RequestMapping(value="/followApplicationProcess.do" , produces = "application/json; charset=utf8" )
	public String followApplicationProcess(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		
		try {
			int tidx = Integer.parseInt(request.getParameter("tidx").toString());
			HttpSession session = request.getSession();
			int userIdx = Integer.parseInt(""+session.getAttribute("userIdx"));
			Trader trader = Member.getMemberByIdx(tidx).getTrader();
			Member user = Member.getMemberByIdx(userIdx);
			if( !trader.isFollowPossible()){
				obj.put("msg", Message.get().msg(messageSource, "copyNoti.fullFollow", request));
				return obj.toJSONString();
			}else if(trader.getMinRegistWallet() > CointransService.getWithdrawWallet(user.userIdx, "USDT").doubleValue()){
				obj.put("msg", Message.get().msg(messageSource, "pop.notBalance", request));
				return obj.toJSONString();
			}
			if(userIdx == tidx){
				obj.put("msg", Message.get().msg(messageSource, "copyNoti.noSelfFollow", request));
				return obj.toJSONString();
			}
			if(user.p2pCheck()){
				obj.put("msg", Message.get().msg(messageSource, "trade.p2pStop", request));
				return obj.toJSONString();
			}
			ArrayList<String> inSymbols = new ArrayList<>();
			ArrayList<EgovMap> copydatas = new ArrayList<>();
			for(Coin coin : Project.getUseCoinList()){
				if(request.getParameter("coin"+coin.coinNum) != null){
					inSymbols.add(request.getParameter("coin"+coin.coinNum));
					copydatas.add(copytradeData(userIdx,tidx,coin.coinNum,request));
				}
			}
			
			for(String symbol : inSymbols){
				int idx = inSymbols.indexOf(symbol);
				Coin coin = Coin.getCoinInfo(symbol);
				if(copydatas.get(idx).get("result").toString().equals("fail")){
					obj.put("msg", symbol+", "+copydatas.get(idx).get("msg"));
					return obj.toJSONString();
				}else if(!trader.getCoinUse(coin)){
					obj.put("msg", symbol+", "+Message.get().msg(messageSource, "copyNoti.notPair", request));
					return obj.toJSONString();
				}
			}
			
			for(String symbol : inSymbols){
				if(Member.hasPositionOrder(userIdx, symbol)){
					obj.put("msg", symbol+", "+Message.get().msg(messageSource, "copyNoti.liqAfter", request));
					return obj.toJSONString();
				}
			}
			
			for(String symbol : inSymbols){
				if(symbol != null){
					int idx = inSymbols.indexOf(symbol);
					Copytrade copy = (Copytrade)copydatas.get(idx).get("copy");
					Copytrade.pushCopytrade(copy);
				}
			}
			obj.put("result", "success");
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.suc", request));
			
		} catch (Exception e) {
			obj.put("msg","followApplicationProcess error");
			// TODO: handle exception
		}
		return obj.toJSONString();
	}
	
	EgovMap copytradeData(int uidx, int tidx, int cnum, HttpServletRequest request){
		EgovMap map = new EgovMap();
		map.put("result","fail");
		try {
			String use = request.getParameter("coin"+cnum);
			if(use == null) return map;
			
			Coin coin = Coin.getCoinInfo(cnum);
			String symbol = coin.coinName+"USDT";
			String leverageMode = request.getParameter("leverage"+cnum);
			Integer levNum = toInteger("" + request.getParameter("levNum"+cnum)); // leverage가 1일경우 값 받아와야함
			Integer isQtyRate = toInteger("" + request.getParameter("isQtyRate"+cnum));
			Double fixQty = toDouble("" + request.getParameter("fixQty"+cnum));
			Double lossCutRate = toDouble("" + request.getParameter("lossCutRate"+cnum));
			Double profitCutRate = toDouble("" + request.getParameter("profitCutRate"+cnum));
			Double maxPositionQty = toDouble("" + request.getParameter("maxPositionQty"+cnum));

			HttpSession session = request.getSession();
			int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));

			if (Copytrade.getCopytrade(userIdx, symbol) != null) {
				map.put("msg", Message.get().msg(messageSource, "copyNoti.alreadyCopy", request));
				return map;
			}

			if (symbol == null || symbol.equals("")) {
				map.put("msg", Message.get().msg(messageSource, "copyNoti.selectCoin", request));
				return map;
			}
			if (leverageMode == null || leverageMode.equals("")
					|| (!leverageMode.equals("0") && !leverageMode.equals("1"))) {
				map.put("msg", Message.get().msg(messageSource, "copyNoti.selectLevMode", request));
				return map;
			}
			if (Integer.parseInt(leverageMode) == 1) {
				if (levNum == null || levNum == 0) {
					map.put("msg", Message.get().msg(messageSource, "copyNoti.inputLev", request));
					return map;
				} else if (levNum > coin.maxLeverage) {
					map.put("msg", Message.get().msg(messageSource, "copyNoti.overLev", request));
					return map;
				}
			}
			if (isQtyRate == null || (isQtyRate != 0 && isQtyRate != 1)) {
				map.put("msg", Message.get().msg(messageSource, "copyNoti.qtySelect", request));
				return map;
			}
			if (fixQty == null || fixQty <= 0) {
				map.put("msg", Message.get().msg(messageSource, "copyNoti.qtyInput", request));
				return map;
			}
			fixQty = PublicUtils.toFixed(fixQty, 4);

			if (leverageMode.equals("0"))
				levNum = null;
			if (lossCutRate != null && lossCutRate <= 0)
				lossCutRate = null;
			if (profitCutRate != null && profitCutRate <= 0)
				profitCutRate = null;
			if (maxPositionQty != null && maxPositionQty <= 0)
				maxPositionQty = null;
			boolean bIsQtyRate = false;
			if (isQtyRate == 1)
				bIsQtyRate = true;
			
			int state = CopytradeState.RUN.getValue();
			if(Project.isCopyRequest())
				state = CopytradeState.REQUEST.getValue();
			
			Copytrade copy = new Copytrade(userIdx, tidx, symbol, bIsQtyRate, fixQty, levNum, lossCutRate,
					profitCutRate, maxPositionQty, state, null, 0, 0, Send.getTime());
			map.put("copy", copy);
			map.put("result","suc");
		
		} catch (Exception e) {
			map.put("msg", Message.get().msg(messageSource, "pop.requestFail", request));
			map.put("result","fail");
		}
		
		return map;
	}
	
	Integer toInteger(String str){
		try {
			if(str == null || str.isEmpty())
				return null;
			return Integer.parseInt(str);
		} catch (Exception e) {
			return null;
		}
	}
	
	Double toDouble(String str){
		try {
			if(str == null || str.isEmpty())
				return null;
			return Double.parseDouble(str);
		} catch (Exception e) {
			return null;
		}
	}
	
	private ArrayList<EgovMap> getTradersInfo(ArrayList<EgovMap> list){
		try {
			if(list != null){
				for(EgovMap data : list){
					data = putFollower(data);
				}
			}
			return list;
			
		} catch (Exception e) {
			Log.print("getTradersInfo err "+e, 1, "err");
		}
		return null;
	}
	
	private EgovMap putFollower(EgovMap data){
		int tuseridx = Integer.parseInt(data.get("tuseridx").toString());
		int follower = Member.getMemberByIdx(tuseridx).getTrader().getFollowCount();
		data.put("fCount", follower);
		return data;
	}
	
	@ResponseBody
	@RequestMapping(value="/tlogShowUpdate.do" , produces = "application/json; charset=utf8" )
	public String contactDelete(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		
		Integer tidx = Integer.parseInt(request.getParameter("tidx").toString());
		
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		
		if(tidx != userIdx){
			obj.put("msg",Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		
		String checked = request.getParameter("checked");
		String unchecked = request.getParameter("unchecked");
		String [] checkArray = checked.split("\\:");
		String [] uncheckArray = unchecked.split("\\:");
		
		try {
			sampleDAO.getSqlMapClient().startBatch();
			EgovMap in = new EgovMap();
			in.put("traderShow",1);
			for(int i = 0; i < checkArray.length; i++){
				in.put("idx", checkArray[i]);
				sampleDAO.update("updateTraderShow",in);
			}
			in.put("traderShow",0);
			for(int i = 0; i < uncheckArray.length; i++){
				in.put("idx", uncheckArray[i]);
				sampleDAO.update("updateTraderShow",in);
			}
			sampleDAO.getSqlMapClient().executeBatch();
			sampleDAO.getSqlMapClient().endTransaction();
			obj.put("result", "suc");
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.change", request));
		} catch (Exception e) {
			obj.put("msg", Message.get().msg(messageSource, "copyNoti.fail", request));
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/minRegistChange.do" , produces = "application/json; charset=utf8" )
	public String minRegistChange(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		
		Integer tidx = Integer.parseInt(request.getParameter("tidx").toString());
		Double changeVal = Double.parseDouble(request.getParameter("changeVal").toString());
		
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt("" + session.getAttribute("userIdx"));
		
		if(tidx != userIdx){
			obj.put("msg",Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		
		Trader trader = Member.getMemberByIdx(tidx).getTrader();
		if(trader == null){
			obj.put("msg",Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		trader.setRegistWallet(changeVal);	
		
		obj.put("result", "suc");
		obj.put("msg", Message.get().msg(messageSource, "copyNoti.change", request));
		return obj.toJSONString();
	}
}
