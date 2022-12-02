package egovframework.example.sample.web;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Collections;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Copytrade;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.Order;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.comparator.joinDateComparator;
import egovframework.example.sample.comparator.tradelogComparator;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/infl")
public class InfluencerController {
	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	int loginCount = 0;
	//login
	@RequestMapping(value = "/login.do")
	public String login() throws Exception {
		System.out.println(loginCount++);
		return "infl/inflLogin";
	}
	
	@RequestMapping(value = "/logout.do")
	public String logout(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute("userIdx", null);
		session.setAttribute("userName",null);
		session.setAttribute("userPhone",null);
		session.setAttribute("userLevel",null);
		session.setAttribute("inflLogin",null);
		return "redirect:login.do";
	}
	
	@ResponseBody
	@RequestMapping(value="/loginProcess.do" , produces="application/json; charset=utf8")
	public String loginProcess(HttpServletRequest request) throws UnknownHostException{
		HttpSession session = request.getSession();
		String country = request.getParameter("country"); // 국가
		String phone = request.getParameter("phone"); // 전화번호
		String code = request.getParameter("code"); // 인증 코드
		String pw = request.getParameter("pw"); // 비밀번호
		String checkPhone = request.getParameter("checkPhone"); // 인증여부 
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		if(country == null || country.equals("") || country.equals("00")){
			obj.put("msg", Message.get().msg(messageSource, "pop.selectCountry", request));
			return obj.toJSONString();
		}
		if(phone == null || phone.equals("")){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhone", request));
			return obj.toJSONString();
		}else if(phone.equals("-1")){
			obj.put("msg", Message.get().msg(messageSource, "pop.inputPhone", request));
			return obj.toJSONString();
		}
		phone = phone.trim();
		if(pw == null || pw.equals("")){
			obj.put("msg", Message.get().msg(messageSource, "join.pWrong", request));
			return obj.toJSONString();
		}
		
		EgovMap in = new EgovMap();
		in.put("country", country);
		in.put("phone", phone);
		in.put("pw", pw);
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberForLogin" , in);
		if(info == null){
			info = (EgovMap)sampleDAO.select("selectMemberForLoginByEmail" , in);
			
			if(info == null){
				obj.put("msg", Message.get().msg(messageSource, "pop.notUser", request));
				return obj.toJSONString();
			}
		}
		
		if(info.get("level").toString().compareTo("user")==0){
			obj.put("msg", Message.get().msg(messageSource, "pop.notInfluencer", request));
			return obj.toJSONString();
		}else{
			Member mem = Member.getMemberByIdx(Integer.parseInt(""+info.get("idx")));
			session.setAttribute("userIdx", info.get("idx"));
			session.setAttribute("userName", info.get("name"));
			session.setAttribute("userPhone", info.get("phone"));
			session.setAttribute("userLevel", info.get("level"));
			session.setAttribute("inflLogin", "1");
			session.setAttribute("phoneCode", null);
			mem.lastLoginWebSession = session;
			
			in.put("userIdx", info.get("idx"));
			
			InetAddress Address = InetAddress.getLocalHost();
			String userip = Address.getHostAddress();
			in.put("userIp",userip);
			
			sampleDAO.update("updateLastLogin",in);
			obj.put("result", "success");
			obj.put("msg", Message.get().msg(messageSource, "pop.loggedin", request));
			obj.put("name", info.get("name"));
			Log.print("Chong Login suc userIdx = "+ info.get("idx")+"phone = "+request.getParameter("phone")+" IP = "+userip, 1, "logincheck");
			return obj.toJSONString();
		}
//		if(info != null && Integer.parseInt(info.get("istest")+"") == 1){
//			if(info.get("level").toString().compareTo("user")==0){
//				obj.put("msg", Message.get().msg(messageSource, "pop.notInfluencer", request));
//				return obj.toJSONString();
//			}else{
//				session.setAttribute("userIdx", info.get("idx"));
//				session.setAttribute("userName", info.get("name"));
//				session.setAttribute("userPhone", info.get("phone"));
//				session.setAttribute("userLevel", info.get("level"));
//				session.setAttribute("inflLogin", "1");
//				session.setAttribute("phoneCode", null);
//				in.put("userIdx", info.get("idx"));
//				
//				InetAddress Address = InetAddress.getLocalHost();
//				String userip = Address.getHostAddress();
//				in.put("userIp",userip);
//				
//				sampleDAO.update("updateLastLogin",in);
//				obj.put("result", "success");
//				obj.put("msg", Message.get().msg(messageSource, "pop.loggedin", request));
//				obj.put("name", info.get("name"));
//				Log.print("Chong Login suc userIdx = "+ info.get("idx")+"phone = "+request.getParameter("phone")+" IP = "+userip, 1, "logincheck");
//				return obj.toJSONString();
//			}
//		}else{
//			if(checkPhone.equals("false")){
//				obj.put("msg", Message.get().msg(messageSource, "join.phoneconfirm", request));
//				return obj.toJSONString();
//			}
//			if(code == null || code.equals("")){
//				obj.put("msg", Message.get().msg(messageSource, "join.phoneconfirm", request));
//				return obj.toJSONString();
//			}		
//			
//			if(country.length()>10 || phone.length()>20
//					 || code.length()>10 || pw.length()>30){			
//				obj.put("result", "fail");
//				return obj.toJSONString();
//			}
//			if(!code.equals("bmaktm1")){
//				if(session.getAttribute("phoneCode") == null){
//					obj.put("msg", Message.get().msg(messageSource, "join.phoneconfirm", request));
//					return obj.toJSONString();
//				}
//				if(!session.getAttribute("phoneCode").toString().equals(code) ){
//					obj.put("msg", Message.get().msg(messageSource, "pop.wrongPhoneCode", request));
//					return obj.toJSONString();
//				}
//			}
//			
//			info = (EgovMap)sampleDAO.select("selectMemberForLogin" , in);
//			if(info != null){
//				if(info.get("level").toString().compareTo("user")==0){
//					obj.put("msg", Message.get().msg(messageSource, "pop.notInfluencer", request));
//					return obj.toJSONString();
//				}
//				
//				session.setAttribute("userIdx", info.get("idx"));
//				session.setAttribute("userName", info.get("name"));
//				session.setAttribute("userPhone", info.get("phone"));
//				session.setAttribute("userLevel", info.get("level"));
//				session.setAttribute("inflLogin", "1");
//				session.setAttribute("phoneCode", null);
//				in.put("userIdx", info.get("idx"));
//				
//				InetAddress Address = InetAddress.getLocalHost();
//				String userip = Address.getHostAddress();
//				in.put("userIp",userip);
//				
//				sampleDAO.update("updateLastLogin",in);
//				obj.put("result", "success");
//				obj.put("msg", Message.get().msg(messageSource, "pop.loggedin", request));
//				obj.put("name", info.get("name"));
//				Log.print("Chong Login suc userIdx = "+ info.get("idx")+"phone = "+request.getParameter("phone")+" IP = "+userip, 1, "logincheck");
//				return obj.toJSONString();
//				
//			}else{
//				obj.put("msg", Message.get().msg(messageSource, "pop.notUser", request));
//				return obj.toJSONString();
//			}
//		}
	}

	//회원관리
	@RequestMapping(value = "/memberlist.do")
	public String memberlist(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("gidx", userIdx);
		String uid = request.getParameter("uid"); 
		String sdate = request.getParameter("sdate"); 
		String edate = request.getParameter("edate"); 
		String asdate = request.getParameter("asdate"); 
		String aedate = request.getParameter("aedate"); 
		String phone = request.getParameter("searchPhone"); 
		
		if((""+phone).length()>30 || (""+sdate).length()>30 || (""+uid).length()>30 || (""+edate).length()>30){
			return "infl/memberlist";
		}
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		in.put("phone", phone);
		in.put("uid", uid);
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("asdate", asdate);
		in.put("aedate", aedate);
		
		in.put("uidx", userIdx);
		EgovMap accumRef = (EgovMap)sampleDAO.select("selectAccumRef" , in);
		if(accumRef != null)
			in.put("givedate",accumRef.get("givedate"));
		ArrayList<EgovMap> underList = (ArrayList<EgovMap>)sampleDAO.list("selectUserByIdxGetParentName",in);
		
		Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
		ArrayList<Member> childrenChong = mem.getChildrenChong();
		
		if(childrenChong.size() != 0){
			for(Member child : childrenChong){
				in.put("userIdx", child.userIdx);
				ArrayList<EgovMap> childTradeList = (ArrayList<EgovMap>)sampleDAO.list("selectUserByIdxGetParentName",in);
				underList.addAll(childTradeList);
			}
		}
		
		sortUpMemberlist(underList);
		ArrayList<EgovMap> resultList = new ArrayList<>();
		for(int i = 0; i < pi.getRecordCountPerPage(); i++){
			int first = pi.getFirstRecordIndex()+i;
			if(first == underList.size())
				break;
			resultList.add(underList.get(first));
		}
		pi.setTotalRecordCount(underList.size());
		model.addAttribute("list", resultList);
		model.addAttribute("pi", pi);
		model.addAttribute("searchPhone", phone);
		model.addAttribute("uid", uid);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("asdate", asdate);
		model.addAttribute("aedate", aedate);
		model.addAttribute("refPage","memberlist");
		return "infl/memberlist";
	}
	
	//총판관리
	@RequestMapping(value = "/chonglist.do")
	public String chonglist(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("gidx", userIdx);
		String uid = request.getParameter("uid"); 
		String sdate = request.getParameter("sdate"); 
		String edate = request.getParameter("edate"); 
		String asdate = request.getParameter("asdate"); 
		String aedate = request.getParameter("aedate"); 
		String phone = request.getParameter("searchPhone"); 
		
		if((""+phone).length()>30 || (""+sdate).length()>30 || (""+uid).length()>30 || (""+edate).length()>30){
			return "infl/memberlist";
		}
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		in.put("phone", phone);
		in.put("uid", uid);
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("asdate", asdate);
		in.put("aedate", aedate);
		
		in.put("uidx", userIdx);
		EgovMap accumRef = (EgovMap)sampleDAO.select("selectAccumRef" , in);
		if(accumRef != null)
			in.put("givedate",accumRef.get("givedate"));

//		in.put("self",1);
		ArrayList<EgovMap> underList = (ArrayList<EgovMap>)sampleDAO.list("selectMemberByIdxGetParentName",in);
		in.put("self",null);
		
		Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
		ArrayList<Member> childrenChong = mem.getChildrenChong();
		
		if(childrenChong.size() != 0){
			for(Member child : childrenChong){
				in.put("userIdx", child.userIdx);
				EgovMap childTradeList = (EgovMap)sampleDAO.select("selectMemberByIdxGetParentName",in);
				if(childTradeList != null)underList.add(childTradeList);
			}
		}
		
		sortUpMemberlist(underList);
		ArrayList<EgovMap> resultList = new ArrayList<>();
		for(int i = 0; i < pi.getRecordCountPerPage(); i++){
			int first = pi.getFirstRecordIndex()+i;
			if(first == underList.size())
				break;
			resultList.add(underList.get(first));
		}
		pi.setTotalRecordCount(underList.size());
		model.addAttribute("list", resultList);
		model.addAttribute("pi", pi);
		model.addAttribute("searchPhone", phone);
		model.addAttribute("uid", uid);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("asdate", asdate);
		model.addAttribute("aedate", aedate);
		model.addAttribute("refPage","chonglist");
		return "infl/chonglist";
	}
	
	@RequestMapping(value = "/transactionHistory.do")
	public String transactionHistory(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");		
		String uid = request.getParameter("uid"); 
		String phone = request.getParameter("searchPhone"); 
		String symbol = request.getParameter("symbol");
		
		
		if((""+phone).length()>30 || (""+uid).length()>30 || (""+symbol).length()>30){
			return "board/notice";
		}
		
		EgovMap in = new EgovMap();
		in.put("uidx", userIdx);
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(50);
		
		in.put("phone", phone);
		in.put("uid", uid);
		in.put("symbol", symbol);
		
		ArrayList<EgovMap> tradeList = (ArrayList<EgovMap>)sampleDAO.list("selectAccumTradeListSelf",in);
		Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
		ArrayList<Member> childrenChong = mem.getChildrenChong();
		
		if(childrenChong.size() != 0){
			for(Member child : childrenChong){
				in.put("uidx", child.userIdx);
				ArrayList<EgovMap> childTradeList = (ArrayList<EgovMap>)sampleDAO.list("selectAccumTradeList",in);
				tradeList.addAll(childTradeList);
			}
		}
		
		sortUpTimeTradelist(tradeList);
		ArrayList<EgovMap> resultList = new ArrayList<>();
		for(int i = 0; i < pi.getRecordCountPerPage(); i++){
			int first = pi.getFirstRecordIndex()+i;
			if(first == tradeList.size())
				break;
			resultList.add(tradeList.get(first));
		}
		pi.setTotalRecordCount(tradeList.size());
		model.addAttribute("list", resultList);
		model.addAttribute("pi", pi);
		model.addAttribute("refPage","transactions");
		model.addAttribute("searchPhone", phone);
		model.addAttribute("uid", uid);
		model.addAttribute("symbol", symbol);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		
		return "infl/transactionHistory";
	}
	
	@RequestMapping(value = "/memberDetail.do")
	public String memberDetail(HttpServletRequest request, ModelMap model) throws Exception {
		int userIdx = Integer.parseInt(request.getParameter("idx").toString());
		Member m = Member.getMemberByIdx(userIdx);
		
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		EgovMap dwInfo = (EgovMap)sampleDAO.select("selectMemberDW",in);
		model.addAttribute("dwInfo",dwInfo);
		
		EgovMap userInfo = new EgovMap();
		userInfo.put("idx",m.userIdx);
		userInfo.put("name",m.getName());
		userInfo.put("futures",m.getWallet());
		userInfo.put("btc",m.getWalletC("BTC"));
		userInfo.put("eth",m.getWalletC("ETH"));
		userInfo.put("usdt",m.getWalletC("USDT"));
		userInfo.put("xrp",m.getWalletC("XRP"));
		userInfo.put("trx",m.getWalletC("TRX"));
		
		in.put("tidx", userIdx);
		ArrayList<EgovMap> tradelogList = (ArrayList<EgovMap>)sampleDAO.list("selectTradeLogListAll",in);
		double profitUSDT = 0; 
		double fee = 0;
		
		for(EgovMap log : tradelogList){
			double result = Double.parseDouble(log.get("result").toString());
			double margin = Double.parseDouble(log.get("margin").toString());
			
			profitUSDT += result;
			fee += margin;
		}
		userInfo.put("roi", Coin.getRoi(profitUSDT,fee)); //수익률(ROI) - ( 수익 / 증거금 ) * 100
		userInfo.put("tradeCount", tradelogList.size()); //거래 수량 - 거래 회수 DB
		model.addAttribute("info",userInfo);
		
		////
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(15);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("searchSelect","m.idx");
		in.put("search",userIdx);
		in.put("order","completionTime");
		in.put("orderAD","desc");
		if(sdate != null && sdate.compareTo("") != 0){
			in.put("sdate", sdate);
			in.put("edate", edate);
		}
		in.put("status", 1);
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectAllTransactionsOnlyFromCnt",in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectAllTransactionsOnlyFrom",in);
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		
		/////////////
		String ksdate = request.getParameter("ksdate");
		String kedate = request.getParameter("kedate");
		
		PaginationInfo kpi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("kpageIndex").equals("")){
			kpi.setCurrentPageNo(1);
		}else{
			kpi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("kpageIndex")));
		}
		kpi.setPageSize(10);
		kpi.setRecordCountPerPage(15);
		in.put("first", kpi.getFirstRecordIndex());
		in.put("record", kpi.getRecordCountPerPage());
		in.put("sdate", ksdate);
		in.put("edate", kedate);
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectCompleteMoneyListP2PCnt",in));
		ArrayList<EgovMap> klist = (ArrayList<EgovMap>)sampleDAO.list("selectCompleteMoneyListP2P",in);
		model.addAttribute("klist", klist);
		model.addAttribute("kpi", kpi);
		model.addAttribute("ksdate", ksdate);
		model.addAttribute("kedate", kedate);
		model.addAttribute("refPage","memberlist");
		return "infl/memberDetail";
	}	
	
	@ResponseBody
	@RequestMapping(value="/getUserPositionData.do" , produces = "application/json; charset=utf8")
	public String getUserPositionData(HttpServletRequest request){
		
		JSONObject obj = new JSONObject();
		int userIdx = Integer.parseInt(request.getParameter("userIdx"));
		JSONArray j = new JSONArray();
		
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
        		item.put("margin", 0);
        		item.put("marginType", p.marginType);
        		item.put("fee", p.fee);
        		item.put("profit", p.getProfit());
        		item.put("profitRate", p.getProfitRate());
        		j.add(item);            		
			}
		}        		
		obj.put("plist", j);
		return obj.toJSONString();
	}
	
	
	@RequestMapping(value = "/accum.do")
	public String accum(HttpServletRequest request, ModelMap model) throws Exception {		
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		String searchSelect = request.getParameter("searchSelect");
		String search = request.getParameter("search");
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String symbol = request.getParameter("symbol"); 
		
		EgovMap in = new EgovMap();
		in.put("uidx", userIdx);
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		if((""+search).length()>50 || (""+sdate).length()>30 || (""+edate).length()>30){
			return "infl/accum";
		}
		pi.setPageSize(5);
		pi.setRecordCountPerPage(20);
		in.put("searchSelect", "m."+searchSelect);
		in.put("psearchSelect", "p."+searchSelect);
		in.put("search", search);
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("symbol", symbol);
		in.put("feeAccum", SocketHandler.sh.setting.feeAccum);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		EgovMap accumRef = (EgovMap)sampleDAO.select("selectAccumRef" , in);
		if(accumRef != null){
			accumRef.put("myrate", Member.getMemberByIdx(Integer.parseInt(userIdx)).myRate);
			in.put("givedate", accumRef.get("givedate"));
			in.put("all", 1);
			ArrayList<EgovMap> tradeList = (ArrayList<EgovMap>)sampleDAO.list("selectAccumTradeLogList",in);
			pi.setTotalRecordCount((int)sampleDAO.select("selectAccumTradeLogListCnt",in));
			
			model.addAttribute("list", tradeList);
			model.addAttribute("accumInfo", accumRef);
		}
		
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		model.addAttribute("refPage","accum");
		model.addAttribute("symbol", symbol);
		return "infl/accum";
	}
	
	public void sortUpTimeTradelist(ArrayList<EgovMap> list){
    	Collections.sort(list, new tradelogComparator());
    }
	public void sortUpMemberlist(ArrayList<EgovMap> list){
    	Collections.sort(list, new joinDateComparator());
    }
	
	@ResponseBody
	@RequestMapping(value="/getInviteCode.do"  , produces="application/json; charset=utf8")
	public String getInviteCode(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		JSONObject obj = new JSONObject();
		if(userIdx.length()>30){
			return obj.toJSONString();
		}		
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		EgovMap me = (EgovMap)sampleDAO.select("selectMemberByIdx",in);
		obj.put("invite", me.get("inviteCode"));
		return obj.toJSONString();
	}
	
}
