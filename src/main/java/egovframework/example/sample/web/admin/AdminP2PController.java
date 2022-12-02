package egovframework.example.sample.web.admin;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.example.sample.classes.AdminChat;
import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.JsonUtil;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.P2PAutoCancel;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.enums.CopytraderInfo;
import egovframework.example.sample.enums.P2PType;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/p2p")
public class AdminP2PController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@RequestMapping(value="/p2pInsert.do")
	public String checkProblemIdx(HttpServletRequest request , Model model){
		return "admin/p2pInsert";
	}

	@ResponseBody
	@RequestMapping(value="/p2pInsertProcess.do" , produces = "application/json; charset=utf8")
	public String p2pInsertProcess(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		try {
			String type = request.getParameter("p2pType");
			String name = request.getParameter("name");
			String orders = request.getParameter("orders");
			String price = request.getParameter("price");
			String qty = request.getParameter("qty");
			String lowLimit = request.getParameter("lowLimit");
			String maxLimit = request.getParameter("maxLimit");
			String aveTime = request.getParameter("aveTime");
			String bank = request.getParameter("bank");
			String bankname = request.getParameter("bankname");
			String banknum = request.getParameter("banknum");
			String msg = request.getParameter("msg");
			EgovMap in = new EgovMap();
			in.put("type", type);
			in.put("name", name);
			in.put("orders", orders);
			in.put("price", price);
			in.put("qty", qty);
			in.put("lowLimit", lowLimit);
			in.put("maxLimit", maxLimit);
			in.put("aveTime", aveTime);
			in.put("bank", bank);
			in.put("bankname", bankname);
			in.put("banknum", banknum);
			in.put("msg", msg);
			sampleDAO.insert("insertP2PTrader",in);
			obj.put("result", "success");
		} catch (Exception e) {
			obj.put("msg", "등록 오류. 입력값을 확인해 주세요.");
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/p2pUpdate.do" , produces = "application/json; charset=utf8")
	public String p2pUpdate(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		try {
			String idx = request.getParameter("idx");
			String name = request.getParameter("name");
			String orders = request.getParameter("orders");
			String price = request.getParameter("price");
			String qty = request.getParameter("qty");
			String lowLimit = request.getParameter("lowLimit");
			String maxLimit = request.getParameter("maxLimit");
			String aveTime = request.getParameter("aveTime");
			String bank = request.getParameter("bank");
			String bankname = request.getParameter("bankname");
			String banknum = request.getParameter("banknum");
			String msg = request.getParameter("msg");
			EgovMap in = new EgovMap();
			in.put("idx", idx);
			in.put("name", name);
			in.put("orders", orders);
			in.put("price", price);
			in.put("qty", qty);
			in.put("lowLimit", lowLimit);
			in.put("maxLimit", maxLimit);
			in.put("aveTime", aveTime);
			in.put("bank", bank);
			in.put("bankname", bankname);
			in.put("banknum", banknum);
			in.put("msg", msg);
			sampleDAO.update("updateP2PTrader",in);
			obj.put("msg", "변경되었습니다.");
			obj.put("result", "suc");
		} catch (Exception e) {
			obj.put("msg", "오류. 입력값을 확인해 주세요.");
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/p2pDelete.do" , produces = "application/json; charset=utf8")
	public String p2pDelete(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		try {
			String idx = request.getParameter("idx");
			EgovMap in = new EgovMap();
			in.put("idx", idx);
			in.put("isDelete", 1);
			sampleDAO.update("updateP2PTrader",in);
			obj.put("msg", "삭제되었습니다.");
			obj.put("result", "suc");
		} catch (Exception e) {
			obj.put("msg", "error");
		}
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/p2pList.do")
	public String tarderList(HttpServletRequest request , Model model){
		String type = request.getParameter("type");
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
		in.put("type", type);
		List<EgovMap> p2pList = (List<EgovMap>)sampleDAO.list("selectP2PTraderList" , in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectP2PTraderListCnt",in));
		model.addAttribute("p2pList",p2pList);
		model.addAttribute("pi",pi);
		model.addAttribute("search",search);
		model.addAttribute("type",type);
		model.addAttribute("project",Project.getPropertieMap());
		return"admin/p2pList";
	}
	
	@RequestMapping(value="/p2pLog.do")
	public String p2pLog(HttpServletRequest request , Model model ,HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String mkind = request.getParameter("kind");
		String kind2 = request.getParameter("kind2");
		String searchSelect = request.getParameter("searchSelect");
		String stat = request.getParameter("stat");
		String except = request.getParameter("except");
		String test = request.getParameter("test");
		String tname = request.getParameter("tname");
		String tidx = request.getParameter("tidx");
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		
		String kind = null;
		if(mkind.equals("d")) {
			kind = "+";
		} else if(mkind.equals("w")) {
			kind = "-";
		}
		
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("stat", stat);
		in.put("kind", kind);
		in.put("search", search);
		in.put("except", except);
		in.put("kind2", kind2);
		in.put("test", test);
		in.put("tidx", tidx);
		
		if(searchSelect == null || searchSelect.compareTo("") == 0){
			searchSelect = "name";
		}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
			if(search.split("00").length != 1){
				in.put("search", search.split("00")[1]);
			}
		}
		in.put("searchSelect","m."+searchSelect);
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectKwithdrawalListP2PCnt",in));
		ArrayList<EgovMap> p2plist = (ArrayList<EgovMap>)sampleDAO.list("selectKwithdrawalListP2P", in);
		for(EgovMap p2p : p2plist){
			int pidx = Integer.parseInt(p2p.get("idx").toString());
			int userIdx = Integer.parseInt(p2p.get("useridx").toString());
			Member mem = Member.getMemberByIdx(userIdx);
			int unread = mem.getUnreadChats(true,pidx).size();
			p2p.put("unread", unread);
		}
		model.addAttribute("list", p2plist);
		EgovMap allout = (EgovMap)sampleDAO.select("depoalloutmoneysP2P",in);
		model.addAttribute("alloutmoneys",allout);
		EgovMap allin = (EgovMap)sampleDAO.select("depoallinmoneysP2P",in);
		
		model.addAttribute("allinmoneys",  allin);
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		model.addAttribute("kind", mkind);
		model.addAttribute("kind2", kind2);
		model.addAttribute("stat", stat);
		model.addAttribute("except", except);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("test", test);
		model.addAttribute("tidx", tidx);
		model.addAttribute("tname", tname);
		model.addAttribute("project", Project.getPropertieMap());
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			SimpleDateFormat dt = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.####");
			DecimalFormat df2 = new DecimalFormat("###,###");
			// header : 필드 이름 
			String[] header = {"신청시간","구분","회원명","이름(예금주)","금액","상태"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"mdate","kind","name","mname","money" , "stat"};
			in.put("limit" , "n");
			List<EgovMap> sendList = (List<EgovMap>)sampleDAO.list("selectKwithdrawalListP2P",in);
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<sendList.size(); i++){
				sendList.get(i).put("mdate", dt.format(sendList.get(i).get("mdate")));
				sendList.get(i).put("kind", sendList.get(i).get("kind").equals("+") ? "입금":"출금");
				sendList.get(i).put("name", sendList.get(i).get("name") + (Integer.parseInt(sendList.get(i).get("istest")+"") == 1 ? " (테스트계정)":""));
				sendList.get(i).put("money", df.format(Double.parseDouble(""+sendList.get(i).get("money"))));
				switch (Integer.parseInt(sendList.get(i).get("stat")+"")) {
				case -1:
					sendList.get(i).put("stat", "링크 대기");
					break;
				case 0:
					sendList.get(i).put("stat", "대기");
					break;
				case 1:
					sendList.get(i).put("stat", "완료");
					break;
				case 2:
					sendList.get(i).put("stat", "미승인");
					break;
				default:
					sendList.get(i).put("stat", "취소");
					break;
				}
			}
			String searchData = "";
			if(search != null && !search.trim().equals("")){
				String searchType = "회원명";
				switch (searchSelect) {
				case "email":
					searchType = "이메일";
					break;
				case "inviteCode":
					searchType = "InviteCode";
					break;
				case "idx":
					searchType = "UID";
					break;
				default:
					break;
				}
				searchData += "검색조건 :"+searchType+" 검색어 : "+search;
			}
			
			searchData += " 총 입금액 :"+df2.format(allout.get("sums"))+" 총 출금액: "+df2.format(allin.get("sums"));
			try {
				Validation.excelDown(response ,sendList, "입출금내역" , header , dataNm ,searchData, sdate+"~"+edate,null);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return "admin/p2pLog";
	}
	
	@ResponseBody
	@RequestMapping(value="/p2pWithdrawalProcess.do", method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String p2pWithdrawalProcess(HttpServletRequest request , Model model){
		JSONObject obj = new JSONObject();
		String userip = Member.getClientIP(request);
		Log.print("w ip:"+userip, 1, "withdraw");
		String widx = request.getParameter("widx");
		String stat = request.getParameter("stat");//-1이메일승인전 0대기(이멜승인후)  관리자  1승인 2미승인
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		in.put("stat", stat);
		EgovMap select = (EgovMap)sampleDAO.select("selectP2PWithdrawal",in);//agree
		String result = "fail";

		String wstat = select.get("stat").toString();
		int useridx = Integer.parseInt(select.get("useridx").toString());
		String kind = select.get("kind").toString();
		double price = Double.parseDouble(select.get("money").toString());
		BigDecimal money = BigDecimal.valueOf(Integer.parseInt(select.get("money").toString()));
		int tidx = Integer.parseInt(select.get("tidx").toString());
		
		in.put("tidx", tidx);
		EgovMap p2pTrader = (EgovMap)sampleDAO.select("selectP2PTrader",in);
		int rate = Integer.parseInt(p2pTrader.get("price").toString());
		double sellQty = Double.parseDouble(p2pTrader.get("qty").toString());
		double buyQty = money.divide(BigDecimal.valueOf(rate), 4, RoundingMode.HALF_DOWN).doubleValue();
		
		//대기인것만 처리가능
		if(wstat.compareTo("0")!=0){
			System.out.println("대기인 것만 처리 가능\n");
			obj.put("result", "error");
			return obj.toJSONString();
		}
		
		obj.put("result", result);
		obj.put("widx", widx);
		obj.put("stat", stat);
		
		Member mem = Member.getMemberByIdx(useridx);
		double prevWallet = mem.getWallet();
		double nextWallet = prevWallet + buyQty;
		int action = 1;
		//승인 
		if(stat.compareTo("1")==0){
			result = CointransService.kWithdrawProcessP2P(useridx,money.intValue(), stat, ""+select.get("idx"),rate,buyQty);
			if(result.compareTo("fail")==0){
				obj.put("result", "error");
				return obj.toJSONString();
			}		
			if(kind.equals("+")) {
				AdminUtil.insertAdminLog(request, sampleDAO, kind.equals("+") ? AdminLog.P2P_DEPOSIT : AdminLog.P2P_WITHDRAW, useridx, null, action, price,prevWallet+" -> "+nextWallet);
			}else{
				AdminUtil.insertAdminLog(request, sampleDAO, kind.equals("+") ? AdminLog.P2P_DEPOSIT : AdminLog.P2P_WITHDRAW, useridx, null, action, price,null);
			}
		}else if(stat.compareTo("2")==0){
			action = 0;
			EgovMap target = (EgovMap)sampleDAO.select("checkMoneyIdxP2P",in);
			if(target.get("stat").toString().compareTo("0") != 0){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			if(kind.equals("-")) {
				CointransService.kWithdrawDenyProcessP2P(widx);
				AdminUtil.insertAdminLog(request, sampleDAO, kind.equals("+") ? AdminLog.P2P_DEPOSIT : AdminLog.P2P_WITHDRAW, useridx, null, action, price,prevWallet+" -> "+nextWallet);
			} else if(kind.equals("+")){
				in.put("stat", 2);
				in.put("idx", widx);
				sampleDAO.update("updateMoneyP2P",in);
				AdminUtil.insertAdminLog(request, sampleDAO, kind.equals("+") ? AdminLog.P2P_DEPOSIT : AdminLog.P2P_WITHDRAW, useridx, null, action, null,null);
			}
			double prevQty = Double.parseDouble(select.get("exchangeValue").toString())+Double.parseDouble(p2pTrader.get("qty").toString());
			in.put("idx", tidx);
			in.put("qty", prevQty);
			in.put("orders", Integer.parseInt(p2pTrader.get("orders").toString())-1);
			sampleDAO.update("updateP2PTrader",in);
		}
		
		mem.resetP2PRun();
		AdminChat.p2pReload(mem, tidx);
		
		obj.put("result","ok");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/payConfirm.do", method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String payConfirm(HttpServletRequest request , Model model){
		JSONObject obj = new JSONObject();

		HttpSession session = request.getSession();
		if(!AdminUtil.highAdminCheck(session)){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		
		String widx = request.getParameter("widx");
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		EgovMap select = (EgovMap)sampleDAO.select("selectP2PWithdrawal",in);//agree
		
		String result = "fail";
		String wstat = select.get("stat").toString();
		
		//대기인것만 처리가능
		if(wstat.compareTo("-1")!=0){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		in.put("stat", 0);
		sampleDAO.update("updateMoneyP2PStat",in);	
		Member mem = Member.getMemberByIdx(Integer.parseInt(select.get("useridx").toString()));
		P2PAutoCancel.remove(mem.userIdx);
		mem.resetP2PRun();
		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		obj.put("result","ok");
		return obj.toJSONString();		
	}
	
	@ResponseBody
	@RequestMapping(value="/cancelDeposit.do" , produces="application/json; charset=utf8")
	public String cancelDeposit(HttpServletRequest request){
		String idx = request.getParameter("idx");
		String midx = request.getParameter("midx");
		EgovMap select = (EgovMap)sampleDAO.select("checkMoneyIdxP2P",idx);
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(select == null){
			obj.put("msg", "오류가발생했습니다. 다시시도해주세요");
			return obj.toJSONString();
		}
		Member mem = Member.getMemberByIdx(Integer.parseInt(midx));
		double before = mem.getWallet();
		double exchangeValue = Double.parseDouble(""+select.get("exchangeValue"));
		EgovMap in = new EgovMap();
		in.put("userIdx", midx);
		in.put("kind", "+");
		in.put("lkind", "depositCancel");	
		in.put("userPoint", before);
		in.put("exchangeValue", exchangeValue);
		in.put("idx", idx);
		in.put("stat", 2);
		sampleDAO.update("updateMoneyP2P",in); // 완료 -> 미승인
		
	    Wallet.updateWallet(mem, before-exchangeValue, (exchangeValue*-1), "futures", "-", "depositCancel");
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CANCLE_DEPOSIT, mem.userIdx, null, 0, -exchangeValue,before+" -> "+(before-exchangeValue));
		obj.put("result", "success");
		obj.put("msg", "입금취소되었습니다");
		
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/p2pChat.do")
	public String p2pChat(HttpServletRequest request , Model model){
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("midx", midx);
		EgovMap data = (EgovMap)sampleDAO.select("checkMoneyIdxWithP2PInfo",in);
		model.addAttribute("data",data);
		
		int userIdx = Integer.parseInt(data.get("useridx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
//		int pidx = Integer.parseInt(data.get("idx").toString());
		model.addAttribute("chats",mem.getChatData(midx));
		AdminChat.read(true, mem, midx);
		return "admin/p2pChat";
	}
	
	@ResponseBody
	@RequestMapping(value="/chatSend.do" , produces="application/json; charset=utf8")
	public String chatSend(HttpServletRequest request){
		int userIdx = Integer.parseInt(request.getParameter("midx").toString());
		int pidx = Integer.parseInt(request.getParameter("pidx").toString());
		String text = request.getParameter("text");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		Member mem = Member.getMemberByIdx(userIdx);
		
		if(!AdminChat.chat(true, mem, pidx, text)){
			return obj.toJSONString();
		}
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteChat.do" , produces="application/json; charset=utf8")
	public String deleteChat(HttpServletRequest request){
		int userIdx = Integer.parseInt(request.getParameter("midx").toString());
		int pidx = Integer.parseInt(request.getParameter("pidx").toString());
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		Member mem = Member.getMemberByIdx(userIdx);
		
		if(!AdminChat.deleteChat(mem, pidx)){
			return obj.toJSONString();
		}
		
		obj.put("result", "suc");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/moneySend.do", produces = "application/json; charset=utf8")
	public String moneySend(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result", "error");
		HttpSession session = request.getSession();
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		in.put("midx", midx);
		EgovMap select = (EgovMap)sampleDAO.select("checkMoneyIdxP2P",in);
		if(select == null){
			obj.put("msg", "잘못된 접근입니다.");
			return obj.toJSONString();
		}else if(Boolean.parseBoolean(select.get("send").toString())){
			obj.put("msg", "잘못된 접근입니다.");
			return obj.toJSONString();
		}else if(select.get("stat").toString().compareTo("-1") != 0){
			obj.put("msg", "잘못된 접근입니다.");
			return obj.toJSONString();
		}
		Member mem = Member.getMemberByIdx(Integer.parseInt(select.get("useridx").toString()));
		double mwallet = mem.getWallet();
		double withdrawUSDT = Double.parseDouble(select.get("exchangeValue").toString());
		Wallet.updateWallet(mem, mwallet-withdrawUSDT, (-1)*withdrawUSDT, "futures", "-", "withdraw");
		
		in.put("send", true);
		sampleDAO.update("updateMoneyP2PSend",in);
		obj.put("result", "suc");
		
		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/dwCalculate.do")
	public String dwCalculate(HttpServletRequest request, ModelMap model){
		EgovMap in = new EgovMap();
		
		String test = request.getParameter("test");
		String sdate = request.getParameter("sdate"); 
		String edate = request.getParameter("edate"); 
		String search = request.getParameter("search"); 
		String searchSelect = request.getParameter("searchSelect");

		in.put("test", test);
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("search", search);
		in.put("searchSelect", searchSelect);
		
		if(search == null || search.isEmpty())
			in.put("userIdx", -1);
		
		ArrayList<EgovMap> underList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_moneyp2p",in);
		ArrayList<Member> childrenChong = new ArrayList<>();
		JSONObject obj = new JSONObject();
		JSONArray array = new JSONArray();
		if(search == null || search.isEmpty()){
			for(EgovMap map : underList){
				array.add(JsonUtil.convertMapToJson(map));
			}
			childrenChong = Member.getChongList();
		}else{
			for(EgovMap map : underList){
				int userIdx = Integer.parseInt(map.get("idx").toString());
				Member mem = Member.getMemberByIdx(userIdx);
				ArrayList<Member> parents = Member.getParents(mem);
				
				if(parents.size() == 0){
					if(mem.getLevel().equals("chong")){
						if(!childrenChong.contains(mem)){
							childrenChong.add(mem);
							childrenChong.addAll(mem.getChildrenChong());
						}
					}
					array.add(JsonUtil.convertMapToJson(map));
				}
				else{
					in.put("self", true);
					in.put("search", null);
					for(Member parent : parents){
						if(parent.getParent() == null){
							in.put("userIdx", parent.userIdx);
							EgovMap topParent = (EgovMap)sampleDAO.select("selectChildByIdxGetParentName_moneyp2p",in);
							if(!childrenChong.contains(parent)){
								array.add(JsonUtil.convertMapToJson(topParent));
								childrenChong.add(parent);
								childrenChong.addAll(parent.getChildrenChong());
							}
						}
					}
					in.put("self", null);
				}
			}
		}
		if(childrenChong.size() != 0){
			in.put("search", null);
			for(Member child : childrenChong){
				in.put("userIdx", child.userIdx);
				ArrayList<EgovMap> childTradeList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_moneyp2p",in);
				if(childTradeList.size() != 0){
					for(EgovMap map : childTradeList){
						array.add(JsonUtil.convertMapToJson(map));
					}
				}
			}
		}

		obj.put("array", array);
		model.addAttribute("child", obj);
		model.addAttribute("list", underList);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("test", test);
		model.addAttribute("search", search);
		model.addAttribute("searchSelect", searchSelect);
		
		return "admin/dwCalculate";
	}
}
