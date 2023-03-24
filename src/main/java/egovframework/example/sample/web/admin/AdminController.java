package egovframework.example.sample.web.admin;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Copytrade;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.QueryWait;
import egovframework.example.sample.classes.ServerInfo;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.enums.CopytradeState;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.MemberControllMgr;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.CryptoUtil;
import egovframework.example.sample.web.util.Send;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Resource(name="sampleDAO")
	SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@RequestMapping(value="/login.do")
	public String login(HttpServletRequest request) throws NoSuchAlgorithmException, GeneralSecurityException{
		String key = ""+request.getParameter("key");
		return "admin/login";
	}
	
	@RequestMapping(value="/createSubAdmin.do")
	public String createSubAdmin(Model model){
		model.addAttribute("project",Project.getPropertieMap());
		return "admin/createSubAdmin";
	}
	
	@ResponseBody
	@RequestMapping(value="/subAdminInsert.do" , produces = "application/json; charset=utf8")
	public String subAdminInsert(HttpServletRequest request){
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String authkey = request.getParameter("authkey");
		String level = request.getParameter("level");
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(id == null || id.trim().equals("")){
			obj.put("msg", "아이디를 입력해주세요");
			return obj.toJSONString();
		}
		if(sampleDAO.select("checkAdminId" , id) != null){
			obj.put("msg", "아이디가 중복되었습니다.");
			return obj.toJSONString();
		}
		if(pw == null || pw.trim().equals("")){
			obj.put("msg", "비밀번호를 입력해주세요");
			return obj.toJSONString();
		}
		if(authkey == null || authkey.trim().equals("")){
			obj.put("msg", "인증키를 입력해주세요");
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("id", id);
		in.put("pw", pw);
		in.put("authkey", authkey);
		in.put("level", level);
		sampleDAO.insert("insertAdmin" ,in);
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/subAdminList.do")
	public String subAdminList(HttpServletRequest request , Model model){
		//페이징
		PaginationInfo paginationInfo = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			paginationInfo.setCurrentPageNo(1);
		} else {
			paginationInfo.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		paginationInfo.setRecordCountPerPage(15);
		paginationInfo.setPageSize(10);
		//인자생성
		EgovMap in = new EgovMap();
		in.put("first", paginationInfo.getFirstRecordIndex());
		in.put("record", paginationInfo.getRecordCountPerPage());
		model.addAttribute("list", sampleDAO.list("selectSubAdminList", in));
		paginationInfo.setTotalRecordCount((int)sampleDAO.select("selectSubAdminListCnt" , in));
		model.addAttribute("pi", paginationInfo);
		return "admin/subAdminList";
	}
	
	
	@ResponseBody
	@RequestMapping(value="/deleteSubAdmin.do" , produces = "application/json; charset=utf8")
	public String deleteSubAdmin(HttpServletRequest request){
		String idx = request.getParameter("idx");
		JSONObject obj = new JSONObject();
		sampleDAO.delete("deleteSubAdmin" , idx);
		obj.put("result", "success");
		obj.put("msg", "처리 완료되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/changeAuthkey.do" , produces = "application/json; charset=utf8")
	public String changeAuthkey(HttpServletRequest request){
		String idx = request.getParameter("idx");
		String authkey = request.getParameter("authkey");
		JSONObject obj = new JSONObject();
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		in.put("authkey", authkey);
		sampleDAO.update("updateSubAdmin" , in);
		obj.put("result", "success");
		obj.put("msg", "처리 완료되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/loginProcess.do", produces="application/json; charset=utf8")
	public String loginProcess(HttpServletRequest request) throws Exception {
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String authkey = request.getParameter("authkey");
		String userip = Member.getClientIP(request);
		Log.print("admin Login id:"+id+" ip:"+userip, 1, "logincheck");
		
		JSONObject obj = new JSONObject();
		
		if(id.length()>30 || pw.length()>50){
			return obj.toJSONString();
		}
		
		HttpSession session = request.getSession();
		String userIdx = ""+session.getAttribute("userIdx");
		
		if(id == null || id.equals("")){
			obj.put("result", "fail");
			obj.put("msg", "아이디를 입력하세요.");
			return obj.toJSONString();
		}
		if(pw == null || pw.equals("")){
			obj.put("result", "fail");
			obj.put("msg", "비밀번호를 입력하세요.");
			return obj.toJSONString();
		}	
		EgovMap in = new EgovMap();
		in.put("id", id);
		
		CryptoUtil crypto = CryptoUtil.getInstance();
//		in.put("pw", crypto.encrypt(pw));
		in.put("pw", pw);
		in.put("authkey", authkey);
		EgovMap info = (EgovMap)sampleDAO.select("selectLoginId", in);
		if(info == null){
			obj.put("result", "fail");
			obj.put("msg", "아이디 혹은 비밀번호가 틀렸습니다.");
			ServerInfo.get().insertAdminAccessLog(userip,id,pw,false,userIdx);
			return obj.toJSONString();
		}else{
			session.setAttribute("adminLogin", "1");
			session.setAttribute("adminIdx", info.get("idx"));
			session.setAttribute("adminLevel", info.get("level"));
			ServerInfo.get().insertAdminAccessLog(userip,id,pw,true,userIdx);
			Send.sendTelegramAlarmBotMsg(id+" 관리자 로그인.");
			obj.put("result", "success");
			return obj.toJSONString();
		}
	}
	
	@RequestMapping(value = "/logout.do")
	public String logout(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute("adminLogin", null);
		session.setAttribute("adminLevel",null);
		session.setAttribute("adminIdx", null);
		return "redirect:login.do";
	}
	
	@ResponseBody
	@RequestMapping(value="/getMoneySum.do"  , produces="application/json; charset=utf8")
	public String getMoneySum(){
		JSONObject obj = new JSONObject();
		double margin = 0;
		for(Position p : SocketHandler.positionList){
			if(!p.member.getIstest())
				margin += p.fee;
		}
		obj.put("margin" , margin);
		
		EgovMap today = (EgovMap)sampleDAO.select("selectProfitSumToday");
		BigDecimal marginDecimal = BigDecimal.valueOf(margin);
		BigDecimal exRate = BigDecimal.valueOf(Double.parseDouble(SocketHandler.exchangeRate));
		BigDecimal profit = BigDecimal.valueOf(Double.parseDouble(today.get("profitSum").toString()));
		BigDecimal adminProfit = BigDecimal.valueOf(Double.parseDouble(today.get("adminProfitSum").toString()));
		BigDecimal fee = BigDecimal.valueOf(Double.parseDouble(today.get("feeSum").toString()));
		BigDecimal funding = BigDecimal.valueOf(Double.parseDouble(sampleDAO.select("selectFundingSumToday").toString()));
		
		
		//BigDecimal exRate = BigDecimal.valueOf(Double.parseDouble( SocketHandler.exchangeRate.toString());
		BigDecimal netProfit = adminProfit.subtract(funding);
		if(Project.isFeeAccum()){
			netProfit = netProfit.add(fee);
		}
		if(Project.isFeeReferral()){
			netProfit = netProfit.add(profit);
		}
		BigDecimal profitExrate = profit.multiply(exRate).setScale(0, RoundingMode.HALF_EVEN);
		BigDecimal positionExrate = marginDecimal.multiply(exRate).setScale(0, RoundingMode.HALF_EVEN);
		BigDecimal netpExrate = netProfit.multiply(exRate).setScale(0, RoundingMode.HALF_EVEN);
		
		obj.put("exRate", exRate);
		obj.put("profitExrate" , profitExrate);
		obj.put("positionExrate" , positionExrate);
		obj.put("netpExrate" , netpExrate);
		//model.addAttribute("exRate", SocketHandler.exchangeRate);
		obj.put("adminProfit" , adminProfit);
		obj.put("fee" , fee);
		obj.put("profit" , profit);
		obj.put("netProfit" , netProfit);
		obj.put("funding" , funding);
		
		obj.put("allMember" , sampleDAO.select("selectAllMemberCnt"));
		obj.put("positionMember" , sampleDAO.select("selectPositionCnt"));
		return obj.toJSONString();
	}
	
	/*점검중*/
	@RequestMapping(value = "/fixstat.do")
	public String fixstat(HttpServletRequest request, ModelMap model) throws Exception {
	    model.addAttribute("fixstat", SocketHandler.fixstat);
	    return "admin/fixstat";
	}
	@RequestMapping(value = "/statchange.do")
		public String statchange(HttpServletRequest request, ModelMap model) throws Exception {
		String stat = request.getParameter("stat");
		if(stat.length()>30){
			return "redirect:/admin/fixstat.do";
		}
		SocketHandler.fixstat = Integer.parseInt(stat);
		return "redirect:/admin/fixstat.do";
	}
	
	@ResponseBody
	@RequestMapping(value = "/giveFunding.do")
	public String giveFunding(HttpServletRequest request, ModelMap model) throws Exception {
		Position.giveFunding();
		return "ok";
	}	
	@ResponseBody
	@RequestMapping(value = "/giveFundingLiquid.do")
	public String giveFundingLiquid(HttpServletRequest request, ModelMap model) throws Exception {
		String kind = ""+request.getParameter("kind");
		String sise = ""+request.getParameter("sise");
		AdminDeleteListController.testKind = kind;
		AdminDeleteListController.testSise = sise;
		Position.giveFunding();
		return "ok";
	}	
	
    @RequestMapping(value = "/adminSetting.do")
	public String adminSetting(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		if(session.getAttribute("adminLevel").toString().compareTo("1")==0){
			model.addAttribute("list",sampleDAO.list("selectAdminList"));
			return "admin/adminSetting";
		}
		else
			return "redirect:main.do";
	}
    
    @ResponseBody
    @RequestMapping(value="/setId.do"  , produces="application/json; charset=utf8")
    public String setId(HttpServletRequest request) throws UnsupportedEncodingException{
    	JSONObject obj = new JSONObject();
    	
    	HttpSession session = request.getSession();
    	if(session.getAttribute("adminLevel").toString().compareTo("1")!=0){
    		obj.put("msg" , "권한이 없습니다.");
    		return obj.toJSONString();
    	}
    	String idx = request.getParameter("idx");
    	String id = request.getParameter("id");
    	
    	EgovMap in = new EgovMap();
    	in.put("idx", idx);
    	
    	try {
    		in.put("id", id);
    		sampleDAO.update("updateAdminPw",in);
    		obj.put("msg" , "변경완료되었습니다.");
    		return obj.toJSONString();
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    		obj.put("msg" , "요청을 실패했습니다.");
    		return obj.toJSONString();
    	}
    }

    @ResponseBody
	@RequestMapping(value="/setPassword.do"  , produces="application/json; charset=utf8")
	public String setPassword(HttpServletRequest request) throws UnsupportedEncodingException{
    	JSONObject obj = new JSONObject();

    	HttpSession session = request.getSession();
		if(session.getAttribute("adminLevel").toString().compareTo("1")!=0){
			obj.put("msg" , "권한이 없습니다.");
			return obj.toJSONString();
		}
    	String idx = request.getParameter("idx");
    	String pw = request.getParameter("pw");
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		
		try {
			in.put("pw", pw);
			sampleDAO.update("updateAdminPw",in);
			obj.put("msg" , "변경완료되었습니다.");
			return obj.toJSONString();
			
		} catch (Exception e) {
			e.printStackTrace();
			obj.put("msg" , "요청을 실패했습니다.");
			return obj.toJSONString();
		}
	}
    
    @RequestMapping(value = "/dangerMsgList.do")
	public String dangerMsgList(HttpServletRequest request, ModelMap model) throws Exception {
    	model.addAttribute("list",SocketHandler.dangerMsg);
    	SocketHandler.dangerMsgRead = 0;
    	return "admin/dangerMsgList";
	}
    
    @ResponseBody
    @RequestMapping(value="/getDangerRead.do"  , produces="application/json; charset=utf8")
    public String getDangerRead(HttpServletRequest request){
    	JSONObject obj = new JSONObject();
    	obj.put("read", SocketHandler.dangerMsgRead);
    	obj.put("copy", SocketHandler.copytraderRequest);
    	return obj.toJSONString();
    }
    
    @RequestMapping(value="/dangerDelete.do")
	public String dangerDelete(HttpServletRequest request){
		String idxs = request.getParameter("idxs");
		String [] idxArray = idxs.split("\\:");
		
		Queue<String> msgs = new LinkedList<String>();
		for(int i = 0; i < idxArray.length; i++){
			msgs.add(SocketHandler.dangerMsg.get(Integer.parseInt(idxArray[i]) ));
		}
		while(msgs.size() != 0){
			SocketHandler.dangerMsg.remove(msgs.poll());
		}
		return "redirect:dangerMsgList.do";
	}
    
    @RequestMapping(value = "/adminIpList.do")
	public String adminIpList(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		if(session.getAttribute("adminLevel").toString().compareTo("1")==0){
			model.addAttribute("myip",Member.getClientIP(request));
			model.addAttribute("list",sampleDAO.list("selectAdminIp"));
			return "admin/adminIpList";
		}
		else
			return "redirect:main.do";
	}
    
    @ResponseBody
    @RequestMapping(value="/insertAdminIp.do"  , produces="application/json; charset=utf8")
    public String insertAdminIp(HttpServletRequest request){
    	JSONObject obj = new JSONObject();
    	
    	HttpSession session = request.getSession();
    	if(session.getAttribute("adminLevel").toString().compareTo("1")!=0){
    		obj.put("msg" , "권한이 없습니다.");
    		return obj.toJSONString();
    	}
    	String ip = request.getParameter("ip");
    	if(ip.length()>30){
			return "redirect:/admin/fixstat.do";
		}
    	EgovMap in = new EgovMap();
    	in.put("ip", ip);
    	
		sampleDAO.insert("insertAdminIp",in);
		SocketHandler.adminIpList = (List<EgovMap>)sampleDAO.list("selectAdminIp");
		obj.put("msg" , "등록되었습니다.");
		return obj.toJSONString();
    		
    }
    
    @ResponseBody
    @RequestMapping(value="/deleteAdminIp.do"  , produces="application/json; charset=utf8")
    public String deleteAdminIp(HttpServletRequest request){
    	JSONObject obj = new JSONObject();
    	
    	HttpSession session = request.getSession();
    	if(session.getAttribute("adminLevel").toString().compareTo("1")!=0){
    		obj.put("msg" , "권한이 없습니다.");
    		return obj.toJSONString();
    	}
    	String idx = request.getParameter("idx");
    	if(idx.length()>30){
			return "redirect:/admin/fixstat.do";
		}
    	EgovMap in = new EgovMap();
    	in.put("idx", idx);
    	
		sampleDAO.delete("deleteAdminIp",in);
		SocketHandler.adminIpList = (List<EgovMap>)sampleDAO.list("selectAdminIp");
		obj.put("msg" , "삭제완료되었습니다.");
		return obj.toJSONString();
    		
    }
    
    @ResponseBody
	@RequestMapping(value = "/testUserInsert.do" , produces="application/json; charset=utf8")
    public String testUserInsert(HttpServletRequest request){
    	String count = request.getParameter("count");
    	String wallet = request.getParameter("wallet");
    	if(count.length()>30 || wallet.length()>50){
			return "redirect:/admin/fixstat.do";
		}
    	if(count == null) return "not count";
    	if(wallet == null) wallet="0";
    	String insert = MemberControllMgr.get().insertTestMember(Integer.parseInt(count),Integer.parseInt(wallet));
    	return "테스트유저 "+count+"명 생성완료\n"+insert;
    }
    
    @ResponseBody
	@RequestMapping(value = "/waitQueryList.do" , produces="application/json; charset=utf8")
    public String waitQueryList(HttpServletRequest request){
    	String text = "";
    	int qsize = SocketHandler.queryList.size();
    	int uqsize = SocketHandler.updateQueryList.size();
    	text = "대기중 Send 개수 : "+SocketHandler.sendList.size()+"개\n";
    	text += "실행중 Send 개수 : "+SocketHandler.sendStartList.size()+"개\n\n";
    	text += "대기중 프로토콜 개수 : "+SocketHandler.msgList.size()+"개\n";
    	text += "대기중 INSERT, DELETE 쿼리 개수 : "+qsize+"개\n";
    	text += "대기중 UPDATE 쿼리 개수 : "+uqsize+"개\n";
		for(QueryWait qw:SocketHandler.queryList){
			text += "NAME = "+qw.queryName+" / TYPE = "+qw.type+" / "+qw.map+"\n";
		}
		if(uqsize != 0)
			text += "//////////////////////////////UPDATE /////////////////////////////\n";
		for(QueryWait qw:SocketHandler.updateQueryList){
			text += "NAME = "+qw.queryName+" / TYPE = "+qw.type+" / "+qw.map+"\n";
		}
    	return text+"ok";
    }
    
    @ResponseBody
	@RequestMapping(value = "/waitSendList.do" , produces="application/json; charset=utf8")
    public String waitSendList(HttpServletRequest request){
    	String text = "";
    	text = "대기중 Send 개수 : "+SocketHandler.sendList.size()+"개\n";
    	text += "실행중 Send 개수 : "+SocketHandler.sendStartList.size()+"개\n\n";
    	text += "대기중 프로토콜 개수 : "+SocketHandler.msgList.size()+"개\n";
    	return text+"ok";
    }
    
    @ResponseBody
	@RequestMapping(value = "/chongAccum.do" , produces="application/json; charset=utf8")
    public String chongAccum(HttpServletRequest request){
    	String text = "";
	    ArrayList<Member> clist = Member.getChongList();
		for(Member m : clist){
			if(m.accum == null)
				continue;
			
			text += "총판명 = "+m.getName()+" / userIdx = "+m.userIdx+" / ";
			if(m.accum == null) text += "누적 이력 없음";
			if(m.accum != null) text += "누적액 : "+m.accum;
			text += "\n";
		}
    	return text+"ok";
    }

    @ResponseBody
	@RequestMapping(value = "/copytradeRunList.do" , produces="application/json; charset=utf8")
    public String copytradeRunList(HttpServletRequest request){
    	String text = "";
    	synchronized (SocketHandler.copytradeList) {
	    	int csize = SocketHandler.copytradeList.size();
	    	text += "진행중 카피트레이드 개수 : "+csize+"개\n";
    		for(Copytrade copy:SocketHandler.copytradeList){
    			text += copy.getCopyInfo();
    		}
		}
    	return text+"ok";
    }
    
    @RequestMapping(value="/left.do")
	public String left(HttpServletRequest request , Model model){
    	model.addAttribute("useCoins",Project.getUseCoinNames());
    	model.addAttribute("project",Project.getPropertieMap());
		return "adminFrame/left";
	}
    
	@RequestMapping(value="/copysInsert.do")
	public String copysInsert(HttpServletRequest request , Model model){
		return "admin/copysInsert";
	}
	@ResponseBody
    @RequestMapping(value="/copysInsertProcess.do"  , produces="application/json; charset=utf8")
    public String copysInsertProcess(HttpServletRequest request){
    	JSONObject obj = new JSONObject();
    	obj.put("result", "fail");
    	HttpSession session = request.getSession();
    	if(!AdminUtil.highAdminCheck(session)){
    		obj.put("msg" , "권한이 없습니다.");
    		return obj.toJSONString();
    	}
    	try {
    		int tidx = Integer.parseInt(""+request.getParameter("tidx"));
    		int startIdx = Integer.parseInt(""+request.getParameter("startIdx"));
    		int count = Integer.parseInt(""+request.getParameter("count"));
    		double money = Double.parseDouble(""+request.getParameter("money"));
    		String slossCut = ""+request.getParameter("lossCut");
    		String sprofitCut = ""+request.getParameter("profitCut");
    		String smaxUSDT = ""+request.getParameter("maxUSDT");
			Double lossCut = null;
			Double profitCut = null;
			Double maxUSDT = null;
    		if(!slossCut.isEmpty())
    			lossCut = Double.parseDouble(slossCut);
    		if(!sprofitCut.isEmpty())
    			profitCut = Double.parseDouble(sprofitCut);
    		if(!smaxUSDT.isEmpty())
    			maxUSDT = Double.parseDouble(smaxUSDT);

    		Member trader = Member.getMemberByIdx(tidx);
    		trader.insertTrader();
    		
    		for(int i = 0; i < count; i++){
    			int uidx = startIdx+i;
    			for(int j = 0; j < 4; j++){
    				String symbol = Coin.getCoinInfo(j).coinName+"USDT";
    				Copytrade copy = new Copytrade(uidx, tidx, symbol, false, money, null, lossCut, profitCut, maxUSDT, CopytradeState.RUN.getValue(), null, 0, 0, Send.getTime());
    				Copytrade.pushCopytrade(copy);
    			}
    		}
    		obj.put("result", "suc");
    		obj.put("msg" , "등록되었습니다.");
		} catch (Exception e) {
			obj.put("msg" , "실패했습니다.");
		}
    	return obj.toJSONString();
    }
	@RequestMapping(value="/copysRelease.do")
	public String copysRelease(HttpServletRequest request , Model model){
		return "admin/copysRelease";
	}
	@RequestMapping(value="/wdPhoneList.do")
	public String wdPhoneList(HttpServletRequest request , Model model){
		model.addAttribute("list",sampleDAO.list("selectWdPhone"));
		return "admin/wdPhoneList";
	}
	
	@ResponseBody
	@RequestMapping(value = "/wdPhoneInsert.do" , produces="application/json; charset=utf8")
    public String wdPhoneInsert(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		String phonenum = request.getParameter("phonenum");
		EgovMap phone = new EgovMap();
		phone.put("phonenum", phonenum);

    	int idx = (int)sampleDAO.insert("insertWdPhone",phone);
    	phone.put("idx", idx);
    	Project.getWdPhoneList().add(phone);
    	AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.ADMINPHONE, -1, null, 1, phonenum, null);
    	obj.put("result", "suc");
    	return obj.toJSONString();
    }
	
	@ResponseBody
	@RequestMapping(value = "/wdPhoneDelete.do" , produces="application/json; charset=utf8")
    public String wdPhoneDelete(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		String idx = request.getParameter("idx");

    	sampleDAO.delete("deleteWdPhone",idx);
    	ArrayList<EgovMap> phonelist = Project.getWdPhoneList();
    	String deletePhone = "";
    	for(EgovMap m : phonelist){
    		if(m.get("idx").toString().equals(idx)){
				deletePhone += m.get("phonenum").toString();
    			phonelist.remove(m);
    			break;
    		}
    	}
    	AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.ADMINPHONE, -1, null, 0, deletePhone, null);
    	obj.put("result", "suc");
    	return obj.toJSONString();
    }
	
	@ResponseBody
    @RequestMapping(value="/copysReleaseProcess.do"  , produces="application/json; charset=utf8")
    public String copysReleaseProcess(HttpServletRequest request){
    	JSONObject obj = new JSONObject();
    	obj.put("result", "fail");
    	HttpSession session = request.getSession();
    	if(!AdminUtil.highAdminCheck(session)){
    		obj.put("msg" , "권한이 없습니다.");
    		return obj.toJSONString();
    	}
    	try {
    		int tidx = Integer.parseInt(""+request.getParameter("tidx"));
    		int count = Integer.parseInt(""+request.getParameter("count"));

    		for(int i = 0; i < count; i++){
    			Member trader = Member.getMemberByIdx(tidx+i);
    			if(trader != null){
    				trader.traderRelease();
    				EgovMap in = new EgovMap();
    				in.put("tuseridx", trader.userIdx);
    				sampleDAO.delete("deleteUseridxTrader",in);
    			}
    		}
    		obj.put("result", "suc");
    		obj.put("msg" , "해제되었습니다.");
		} catch (Exception e) {
			obj.put("msg" , "실패했습니다.");
		}
    	return obj.toJSONString();
    }
	
	@ResponseBody
	@RequestMapping(value = "/siseCheck.do" , produces="application/json; charset=utf8")
    public String siseCheck(HttpServletRequest request){
    	ArrayList<Coin> useCoins = Project.getUseCoinList();
    	String text = "사용중 코인 : "+useCoins.size()+"개\n";
    	text += "useCoinMap : "+Project.getUseCoinMap()+"\n";
    	for(Coin coin : useCoins){
    		text += coin.coinName+" fundingRate : "+coin.fundingRate+"\n";
    	}
    	text += "\n";
		for(Coin coin : useCoins){
			text += coin.coinName+ " long 시세 : "+ coin.getSise("long")+"\n";
			text += coin.coinName+ " short 시세 : "+ coin.getSise("short")+"\n";
		}
		
		text += "////////////////////////////////////////////\n";
		
		text += "new siseload 사용 : "+Project.isNewSiseLoad()+"\n";
		text += "copytrade 사용 : "+Project.isCopytrade()+"\n";
		text += "죽장 레퍼럴 사용 : "+Project.isFeeAccum()+"\n";
		text += "거래 수수료 레퍼럴 사용 : "+Project.isFeeReferral()+"\n";
		text += "copytrade 사용 : "+Project.isCopytrade()+"\n";
		text += "카피트레이드 팔로우 신청 여부 : "+Project.isCopyRequest()+"\n";
		text += "인버스 사용 여부 : "+Project.isInverse()+"\n";
		text += "코인 입출금 사용 여부 : "+Project.isCoinDeposit()+"\n";
		text += "한화 입출금 사용 여부 : "+Project.isKrwDeposit()+"\n";
		text += "P2P 입출금 사용 여부 : "+Project.isP2P()+"\n";
		text += "테스트계정 수수료 부모 있음 처리 : "+Project.isTuserFeeIsParent()+"\n";
		text += "입금 수수료 사용 여부 : "+Project.isDepositFee()+"\n";
		text += "거래 수수료 : "+SocketHandler.sh.setting.rate+"\n";
		text += "총판 최대 레퍼럴 퍼센테이지 : "+Project.getChongMaxRate()+"\n";
		text += "////////////////////////////////////////////\n";
		if(Project.isWdPhoneMsg()){
			text += "어드민 알람 번호 :\n";
			for(EgovMap m : Project.getWdPhoneList()){
				text += m.get("phonenum")+"\n";
			}
		}
		text += "////////////////////////////////////////////\n";
		
    	return text+"ok";
    }
	
	@ResponseBody
	@RequestMapping(value = "/memberCheck.do" , produces="application/json; charset=utf8")
    public String memberCheck(HttpServletRequest request){
    	String text = "포지션 or 오더 있는 유저(사용가능금액 != 잔액) ////////////////////////////////////////////\n\n";
    	synchronized (SocketHandler.members) {
    		for(Member m : SocketHandler.members){
    			double wallet = m.getWallet();
    			double withdrawWallet = m.getWithdrawWallet();
    			if(Math.abs(wallet-withdrawWallet) > 0.0001)
    				text += "userIdx : "+m.userIdx+" / "+m.getName()+" 회원 잔액 : "+m.getWallet()+" / 사용가능 : "+m.getWithdrawWallet()+"\n";
    		}
		}
    	text += "\n\n////////////////////////////////////////////\n\n";
    	text += "사용가능금액 -인 유저(이상) ////////////////////////////////////////////\n\n";
    	synchronized (SocketHandler.members) {
    		for(Member m : SocketHandler.members){
    			double withdrawWallet = m.getWithdrawWallet();
    			if(withdrawWallet < 0)
    				text += "userIdx : "+m.userIdx+" / "+m.getName()+" 회원 잔액 : "+m.getWallet()+" / 사용가능 : "+m.getWithdrawWallet()+"\n";
    		}
		}
    	text += "\n\n////////////////////////////////////////////\n\n";
    	text += "활성화 카피트레이드 DB 불일치 ////////////////////////////////////////////\n\n";
    	
    	ArrayList<EgovMap> copyCounts = (ArrayList<EgovMap>)sampleDAO.list("selectAllCopyCount");
    	for(EgovMap m : copyCounts){
    		int cnt = Integer.parseInt(m.get("cnt").toString());
    		int userIdx = Integer.parseInt(m.get("uidx").toString());
    		ArrayList<Copytrade> alist = Copytrade.getCopytrades(userIdx);
    		if(cnt != alist.size()){
    			Member mem = Member.getMemberByIdx(userIdx);
    			text += "userIdx : "+userIdx+" / "+mem.getName()+" 회원 카피트레이드 활성 : "+alist.size()+" / DB : "+cnt+"\n";
    		}
    	}
    	
    	return text+"ok";
    }
	
	@RequestMapping(value = "/exchangeList.do")
	public String exchangeList(HttpServletRequest request, ModelMap model) throws Exception {
		String type = request.getParameter("type");
		if(Validation.isNull(type)){
			type = "unlisted";
		}
		
		EgovMap in = new EgovMap();
		in.put("type", type);
		
		List<?> list = (List<?>) sampleDAO.list("exchangeL", in);
		model.addAttribute("list", list);
		
		model.addAttribute("type", type);
		
		return "admin/exchangeList";
	}
	
	@ResponseBody
	@RequestMapping(value = "/exchangeInsert.do" , method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String exchangeInsert(MultipartHttpServletRequest mre) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		String type = mre.getParameter("type");
		String coin = mre.getParameter("coin");
		String volume = mre.getParameter("volume");
		String changed = mre.getParameter("changed");
		String link = mre.getParameter("link");
		String updown = "";
		
		if (Validation.isNull(type)) {
			obj.put("msg", "잘못된 경로입니다. 새로고침 후 다시 이용해주세요.");
			return obj.toJSONString();
		}
		if (Validation.isNull(coin)) {
			obj.put("msg", "코인을 입력해주세요.");
			return obj.toJSONString();
		}
		if (Validation.isNull(volume)) {
			obj.put("msg", "볼륨을 입력해주세요.");
			return obj.toJSONString();
		}
		if (Validation.isNull(changed)) {
			obj.put("msg", "변동량을 입력해주세요.");
			return obj.toJSONString();
		}
		if (Validation.isNull(link)) {
			obj.put("msg", "링크를 입력해주세요.");
			return obj.toJSONString();
		}

		if(Integer.parseInt(changed)>0){
			updown = "up";
		}
		else if(Integer.parseInt(changed)<0){
			updown = "down";
		}
		
		EgovMap in = new EgovMap();
		in.put("type", type);
		in.put("coin", coin);
		in.put("volume", volume);
		in.put("changed", Math.abs(Integer.parseInt(changed)));
		in.put("link", link);
		in.put("updown", updown);
		
		MultipartFile mf = mre.getFile("symbol");
		String path = "C:/upload/wesell/exchange/";

		if(mf == null || mf.isEmpty()){
			obj.put("msg", "이미지를 선택해주세요.");
			return obj.toJSONString();
		}

		File file = new File(path);
        if(!file.exists()) {
           file.mkdirs();
        }
        if(!mf.isEmpty()){
        	String filename = mf.getOriginalFilename();
        	String saveNm = UUID.randomUUID().toString().replaceAll("-", "") + filename.substring(filename.lastIndexOf("."));
        	try {
        		mf.transferTo(new File(path+saveNm));
        		in.put("symbol", saveNm);
			} catch (Exception e) {
				e.printStackTrace();
				obj.put("msg", "이미지를 업로드 에러.");
				return obj.toJSONString();
			}
        }
        
		sampleDAO.insert("exchangeInsert", in);

		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/exchangeDelete.do" , method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String exchangeDelete(HttpServletRequest request) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		obj.put("msg", "fail");
		
		String idx = request.getParameter("idx");
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		
		sampleDAO.delete("exchangeDelete", in);
		
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	/* 뉴스 */
	@RequestMapping(value = "/newsList.do")
	public String newsList(HttpServletRequest request, ModelMap model) throws Exception {
		List<?> list = (List<?>) sampleDAO.list("newsL");
		model.addAttribute("list", list);
		
		return "admin/newsList";
	}
	
	@ResponseBody
	@RequestMapping(value = "/newsInsert.do" , method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String newsInsert(MultipartHttpServletRequest mre) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		String title = mre.getParameter("title");
		String ndate = mre.getParameter("ndate");
		String link = mre.getParameter("link");
		
		if (Validation.isNull(title)) {
			obj.put("msg", "제목을 입력해주세요.");
			return obj.toJSONString();
		}
		if (Validation.isNull(ndate)) {
			obj.put("msg", "날짜를 선택해주세요.");
			return obj.toJSONString();
		}
		if (Validation.isNull(link)) {
			obj.put("msg", "링크를 입력해주세요.");
			return obj.toJSONString();
		}
		
		EgovMap in = new EgovMap();
		in.put("title", title);
		in.put("ndate", ndate);
		in.put("link", link);
		
		/*MultipartFile mf = mre.getFile("img");
		String path = "C:/upload/wesell/news/";
		
		if(mf == null || mf.isEmpty()){
			obj.put("msg", "이미지를 선택해주세요.");
			return obj.toJSONString();
		}
		
		File file = new File(path);
		if(!file.exists()) {
			file.mkdirs();
		}
		if(!mf.isEmpty()){
			String filename = mf.getOriginalFilename();
			String saveNm = UUID.randomUUID().toString().replaceAll("-", "") + filename.substring(filename.lastIndexOf("."));
			try {
				mf.transferTo(new File(path+saveNm));
				in.put("img", saveNm);
			} catch (Exception e) {
				e.printStackTrace();
				obj.put("msg", "이미지를 업로드 에러.");
				return obj.toJSONString();
			}
		}*/
		
		sampleDAO.insert("newsInsert", in);
		
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/newsDelete.do" , method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String newsDelete(HttpServletRequest request) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		obj.put("msg", "fail");
		
		String idx = request.getParameter("idx");
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		
		sampleDAO.delete("newsDelete", in);
		
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
}