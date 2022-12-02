package egovframework.example.sample.web;


import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.AdminChat;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Copytrade;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.P2PAutoCancel;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/user")
public class p2pController {
	
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;

	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@RequestMapping(value="/p2pbuy.do")
	public String p2pbuy(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		
		String search = request.getParameter("search");
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(30);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("search", search);
		in.put("type", 0);
		List<EgovMap> p2pList = (List<EgovMap>)sampleDAO.list("selectP2PTraderList" , in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectP2PTraderListCnt",in));
		model.addAttribute("p2pList",p2pList);
		model.addAttribute("pi",pi);
		model.addAttribute("search",search);
		model.addAttribute("refPage","buy");
		return "user/p2p/p2pbuy";
	}
	
	@RequestMapping(value="/p2psell.do")
	public String p2psell(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		
		String search = request.getParameter("search");
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(30);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("search", search);
		in.put("type", 1);
		List<EgovMap> p2pList = (List<EgovMap>)sampleDAO.list("selectP2PTraderList" , in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectP2PTraderListCnt",in));
		model.addAttribute("p2pList",p2pList);
		model.addAttribute("pi",pi);
		model.addAttribute("search",search);
		model.addAttribute("refPage","buy");
		
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
		model.addAttribute("account",mem.account);
		model.addAttribute("bank",mem.bank);
		return "user/p2p/p2psell";
	}
	
	@ResponseBody
	@RequestMapping(value="/getWallet.do", produces = "application/json; charset=utf8")
	public String getCoinInfo(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
		obj.put("spot", mem.getWalletC("USDT"));
		obj.put("futures", mem.getWallet());
		obj.put("withdrawWallet", mem.getWithdrawWallet());
		return obj.toJSONString();
	}
	
	@RequestMapping(value = "/p2pOrders.do")
	public String p2pOrders(HttpServletRequest request, ModelMap model) throws Exception {
		String op = "" + request.getParameter("op");
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		String userIdx = "" + session.getAttribute("userIdx");
		String date = request.getParameter("sDate");
		String edate = request.getParameter("eDate");
		String kind = null;
		Member user = Member.getMemberByIdx(Integer.parseInt(userIdx));
		
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
		pi.setTotalRecordCount((int) sampleDAO.select("selectKtransactionsP2PCnt", in));
		ArrayList<EgovMap> p2plist = (ArrayList<EgovMap>)sampleDAO.list("selectKtransactionsP2P", in);
		for(EgovMap p2p : p2plist){
			int pidx = Integer.parseInt(p2p.get("idx").toString());
			int unread = user.getUnreadChats(false,pidx).size();
			p2p.put("unread", unread);
		}
		model.addAttribute("list", p2plist);
		model.addAttribute("op", op);
		model.addAttribute("pi", pi);
		model.addAttribute("sDate", date);
		model.addAttribute("eDate", edate);
		model.addAttribute("refPage", "order");
		return "user/p2p/p2pOrders";
	}
	
	@ResponseBody
	@RequestMapping(value = "/depositProcessP2P.do" , method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String depositProcessP2P(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		HttpSession session = request.getSession();
		String userIdx = "" + session.getAttribute("userIdx");
		BigDecimal money = BigDecimal.valueOf(Integer.parseInt(request.getParameter("depositMoney").toString()));
		int tidx = Integer.parseInt(request.getParameter("tidx").toString());

		EgovMap in = new EgovMap();
		in.put("tidx", tidx);
		EgovMap p2pTrader = (EgovMap)sampleDAO.select("selectP2PTrader",in);
		if(p2pTrader == null){
			obj.put("msg", Message.get().msg(messageSource, "fail.common.msg", request));
			return obj.toJSONString();
		}
		
		if(Member.hasAnyPositionOrder(Integer.parseInt(userIdx))){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.tradeRun", request));
			return obj.toJSONString();
		}else if(Copytrade.isCopytradeRun(Integer.parseInt(userIdx))){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.copyRun", request));
			return obj.toJSONString();
		}
		
		int lLimit = Integer.parseInt(p2pTrader.get("lowLimit").toString());
		int mLimit = Integer.parseInt(p2pTrader.get("maxLimit").toString());
		int price = Integer.parseInt(p2pTrader.get("price").toString());
		double sellQty = Double.parseDouble(p2pTrader.get("qty").toString());
		double buyQty = money.divide(BigDecimal.valueOf(price), 4, RoundingMode.HALF_DOWN).doubleValue();
		
		if(money.intValue() < lLimit){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.lLimitErr", request));
			return obj.toJSONString();
		}
		else if(money.intValue() > mLimit){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.mLimitErr", request));
			return obj.toJSONString();
		}
		else if(buyQty > sellQty){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.overQty", request));
			return obj.toJSONString();
		}
		
		in.put("userIdx", userIdx);
		in.put("money", money);
		in.put("kind", "+");
		in.put("exchangeValue", buyQty);
		in.put("exchangeRate", price);
		
		if(money.intValue()<0) {
			obj.put("msg", Message.get().msg(messageSource, "wallet.inputAmount", request));
			return obj.toJSONString();
		}
		EgovMap checkMoneyStat = (EgovMap) sampleDAO.select("checkMoneyStatP2P", in);
		if(checkMoneyStat==null){
			int insertIdx = (int)sampleDAO.insert("insertMoneyP2P",in);
			obj.put("result", "suc");
			obj.put("tidx", tidx);
			obj.put("insertIdx", insertIdx);
			obj.put("msg", Message.get().msg(messageSource, "wallet.dreqSuccess", request));
			obj.put("protocol", "dwRequest");
			SocketHandler.sh.sendAdminMessage(obj);
			
			Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
			mem.resetP2PRun();
			
			double resultQty = sellQty - buyQty;
//			if(resultQty <= 0){
//				
//			}else
			{
				in.put("idx", tidx);
				in.put("qty", resultQty);
				in.put("orders", Integer.parseInt(p2pTrader.get("orders").toString())+1);
				sampleDAO.update("updateP2PTrader",in);
			}
			P2PAutoCancel.putAutoCancelList(insertIdx, mem.userIdx, null);
			Send.sendAdminMsg(mem,"P2P 입금 신청이 들어왔습니다.");
		}
		else{
			obj.put("result", "already");
			obj.put("msg", Message.get().msg(messageSource, "wallet.waitingDreq", request));
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/withdrawProcessP2P.do", method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String withdrawProcess(HttpServletRequest request, ModelMap model) throws Exception {
		double withdrawUSDT = Double.parseDouble(request.getParameter("withdrawMoney"));
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(""+session.getAttribute("userIdx"));
		EgovMap in = new EgovMap();
		Member mem = Member.getMemberByIdx(userIdx);
		double mwallet = mem.getWallet();
		double withdrawWallet = CointransService.getWithdrawWallet(mem, "futures").doubleValue();
		JSONObject obj = new JSONObject();
		
		if(Member.hasAnyPositionOrder(mem.userIdx)){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.tradeRun", request));
			return obj.toJSONString();
		}else if(Copytrade.isCopytradeRun(mem.userIdx)){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.copyRun", request));
			return obj.toJSONString();
		}

		int tidx = Integer.parseInt(request.getParameter("tidx").toString());
		in.put("userIdx", userIdx);
		in.put("tidx", tidx);
		EgovMap p2pTrader = (EgovMap)sampleDAO.select("selectP2PTrader",in);
		if(p2pTrader == null){
			obj.put("msg", Message.get().msg(messageSource, "fail.common.msg", request));
			return obj.toJSONString();
		}
		int lLimit = Integer.parseInt(p2pTrader.get("lowLimit").toString());
		int mLimit = Integer.parseInt(p2pTrader.get("maxLimit").toString());
		int price = Integer.parseInt(p2pTrader.get("price").toString());
		double sellUSDT = Double.parseDouble(p2pTrader.get("qty").toString());
		double buyKRW = withdrawUSDT*price;
		
		in.put("money", buyKRW);
		in.put("kind", "-");
		
		if(buyKRW < lLimit){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.lLimitErr", request));
			return obj.toJSONString();
		}
		else if(buyKRW > mLimit){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.mLimitErr", request));
			return obj.toJSONString();
		}
		else if(withdrawUSDT > sellUSDT){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.overQty", request));
			return obj.toJSONString();
		}
		in.put("exchangeRate", price);
		in.put("exchangeValue", withdrawUSDT);

		if (withdrawWallet < withdrawUSDT) {
			obj.put("result", "moneyWrack");
			obj.put("msg", Message.get().msg(messageSource, "pop.notBalance", request));
		} else {
			EgovMap checkMoneyStat = (EgovMap) sampleDAO.select("checkMoneyStatP2P", in);
			if (checkMoneyStat == null) {
				
				int insertIdx = (int)sampleDAO.insert("insertMoneyP2P",in);
				in.put("exchangeValue", (-1)*withdrawUSDT);
				obj.put("insertIdx", insertIdx);
				obj.put("result", "suc");
				obj.put("msg", Message.get().msg(messageSource, "wallet.wreqSuccess", request));
				obj.put("protocol", "dwRequest");
				SocketHandler.sh.sendAdminMessage(obj);
				
				mem.resetP2PRun();
				
				double resultQty = sellUSDT - withdrawUSDT;
				
				in.put("idx", p2pTrader.get("idx"));
				in.put("qty", resultQty);
				in.put("orders", Integer.parseInt(p2pTrader.get("orders").toString())+1);
				sampleDAO.update("updateP2PTrader",in);
				
				Send.sendAdminMsg(mem,"P2P 출금 요청이 들어왔습니다.");
			} else {
				obj.put("result", "already");
				obj.put("msg", Message.get().msg(messageSource, "wallet.waitingWreq", request));
			}
		}
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/p2pDetail.do")
	public String p2pDetail(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		session.setAttribute("currentP", "wallet");
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
		int moneyIdx = Integer.parseInt(request.getParameter("midx"));
		EgovMap in = new EgovMap();
		in.put("midx", moneyIdx);
		EgovMap detail = (EgovMap)sampleDAO.select("checkMoneyIdxWithP2PInfo" , in);
		int pidx = Integer.parseInt(detail.get("idx").toString());
		AdminChat.read(false, mem, pidx);
		model.addAttribute("chats",mem.getChatData(pidx));
		//채팅 내역 불러오기?
		if(userIdx != Integer.parseInt(detail.get("useridx").toString())) {
			return "redirect:p2pbuy.do";
		}
		model.addAttribute("detail",detail);
		
		EgovMap accountInto = new EgovMap();
		accountInto.put("bank",mem.bank);
		accountInto.put("account",mem.account);
		accountInto.put("name",mem.getName());
		model.addAttribute("accountInto",accountInto);
		
		return "user/p2p/p2pDetail";
	}
	
	@ResponseBody
	@RequestMapping(value="/moneySend.do", produces = "application/json; charset=utf8")
	public String moneySend(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result", "error");
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		in.put("midx", midx);
		EgovMap select = (EgovMap)sampleDAO.select("checkMoneyIdxP2P",in);
		if(select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}else if(Boolean.parseBoolean(select.get("send").toString())){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}else if(select.get("stat").toString().compareTo("-1") != 0){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		Member mem = Member.getMemberByIdx(userIdx);
		double mwallet = mem.getWallet();
		double withdrawUSDT = Double.parseDouble(select.get("exchangeValue").toString());
		Wallet.updateWallet(mem, mwallet-withdrawUSDT, (-1)*withdrawUSDT, "futures", "-", "withdraw");
		
		in.put("send", true);
		sampleDAO.update("updateMoneyP2PSend",in);
		obj.put("result", "suc");
		
		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/payComplete.do", produces = "application/json; charset=utf8")
	public String payComplete(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		EgovMap select = (EgovMap)sampleDAO.select("checkMoneyIdxP2P",in);
		if(select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}else if(Integer.parseInt(select.get("stat").toString()) != -1){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		in.put("stat", 0);
		sampleDAO.update("updateMoneyP2PStat",in);
		obj.put("result", "suc");
		
		Member mem = Member.getMemberByIdx(userIdx);
		P2PAutoCancel.remove(mem.userIdx);
		mem.resetP2PRun();
		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/p2pCancel.do", produces = "application/json; charset=utf8")
	public String cancel(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		EgovMap select = (EgovMap)sampleDAO.select("checkMoneyIdxP2P",in);
		String kind = select.get("kind").toString();
		int stat = Integer.parseInt(select.get("stat").toString());
		if(select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}else if(kind.equals("-") && stat != -1){
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.cancelFail", request));
			return obj.toJSONString();
		}
		
		if(stat > 0){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		if(kind.equals("-") && Boolean.parseBoolean(select.get("send").toString())) {
			CointransService.kWithdrawDenyProcessP2P(String.valueOf(midx));
		}
		
		in.put("stat", 3);
		sampleDAO.update("updateMoneyP2PStat",in);
		obj.put("result", "suc");
		
		Member mem = Member.getMemberByIdx(userIdx);
		mem.resetP2PRun();
		AdminChat.p2pReload(mem, midx);
		
		P2PAutoCancel.remove(mem.userIdx);
		
		int tidx = Integer.parseInt(select.get("tidx").toString());
		in.put("tidx", tidx);
		EgovMap p2pTrader = (EgovMap)sampleDAO.select("selectP2PTrader",in);
		in.put("idx", tidx);
		double prevQty = Double.parseDouble(select.get("exchangeValue").toString())+Double.parseDouble(p2pTrader.get("qty").toString());
		in.put("qty", prevQty);
		in.put("orders", Integer.parseInt(p2pTrader.get("orders").toString())-1);
		sampleDAO.update("updateP2PTrader",in);
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/tradeComplete.do", produces = "application/json; charset=utf8")
	public String tradeComplete(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		EgovMap select = (EgovMap)sampleDAO.select("checkMoneyIdxP2P",in);
		if(select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}else if(Integer.parseInt(select.get("stat").toString()) != 0){
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		in.put("stat", 1);
		sampleDAO.update("updateMoneyP2PStat",in);
		
		Member mem = Member.getMemberByIdx(userIdx);
		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		mem.resetP2PRun();
		obj.put("result", "suc");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/chatSend.do" , produces="application/json; charset=utf8")
	public String chatSend(HttpServletRequest request){
		int userIdx = Integer.parseInt(request.getParameter("userIdx").toString());
		int pidx = Integer.parseInt(request.getParameter("pidx").toString());
		String text = request.getParameter("text");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		Member mem = Member.getMemberByIdx(userIdx);
		
		if(!AdminChat.chat(false, mem, pidx, text)){
			return obj.toJSONString();
		}
		Send.sendAdminMsg(mem,"새로운 P2P 채팅 내역이 있습니다.");
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/unreadChatCheck.do" , produces="application/json; charset=utf8")
	public String unreadChatCheck(HttpServletRequest request){
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("userIdx").toString());
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		Member mem = Member.getMemberByIdx(userIdx);
		boolean unread = mem.isUnreadChats();
		obj.put("unread", unread);
		
		obj.put("result", "suc");
		return obj.toJSONString();
	}
}

