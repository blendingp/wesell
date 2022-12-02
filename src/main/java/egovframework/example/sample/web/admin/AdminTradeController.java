package egovframework.example.sample.web.admin;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.sise.NewSiseManager;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/trade")
public class AdminTradeController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@RequestMapping(value="/tail.do")
	public String tail(HttpServletRequest request , Model model){
		model.addAttribute("coinList",Project.getUseCoinInfoList());
		return "admin/tail";
	}
	
	@RequestMapping(value="/tradeList.do")
	public String tradeList(HttpServletRequest request , Model model, HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String searchSelect = request.getParameter("searchSelect");
		String inverse = ""+request.getParameter("inverse");
		String order = request.getParameter("order");
		String orderAD = request.getParameter("orderAD");
		String symbol = request.getParameter("symbol");
		String test = request.getParameter("test");
		String searchIdx = request.getParameter("searchIdx"); // 멤버디테일 - 전체보기 했을때 유저idx 들어옴
		String username = request.getParameter("username"); // 멤버디테일 - 전체보기 했을때 유저네임 들어옴

		if(order==null || order.compareTo("")==0){
			order = "buyDatetime";
			orderAD = "desc";
		}
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("search", search);
		in.put("searchIdx", searchIdx);
		in.put("order", "t."+order);
		in.put("orderAD", orderAD);
		in.put("symbol", symbol);
		in.put("test", test);
		in.put("inverse", CointransService.sqlIsInverseValue(inverse));

		if(searchSelect == null || searchSelect.compareTo("") == 0){
			searchSelect = "name";
		}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
			if(search.split("00").length != 1){
				in.put("search", search.split("00")[1]);
			}
		}
		if(searchSelect.equals("symbol")){
			in.put("searchSelect",searchSelect);
		}else{
			in.put("searchSelect","m."+searchSelect);
		}
		
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			in.put("nolimit", 1);
			ArrayList<EgovMap> allList = (ArrayList<EgovMap>)sampleDAO.list("selectTradeList",in);
			in.put("nolimit", null);
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"시간","회원명","소속 총판","Symbol","주문번호","주문타입","포지션","가격","수량","수수료","정산","레버리지"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"buyDatetime","name","pname","symbol","orderNum","orderType","position","entryPrice","buyQuantity","fee","result","leverage"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				if(Boolean.parseBoolean(allList.get(i).get("isOpen").toString())){
					allList.get(i).put("entryPrice", df.format(allList.get(i).get("entryPrice")));
					allList.get(i).put("position", allList.get(i).get("position").toString().toUpperCase());
				}else{
					allList.get(i).put("entryPrice", df.format(allList.get(i).get("liqPrice")));
					allList.get(i).put("position", reservePosition(allList.get(i).get("position").toString()));
				}
				allList.get(i).put("buyDatetime", dt.format(allList.get(i).get("buyDatetime")));
				allList.get(i).put("name", allList.get(i).get("name") +(Integer.parseInt(allList.get(i).get("istest")+"") == 1 ? " (테스트계정)" : ""));
				allList.get(i).put("buyQuantity", df.format(allList.get(i).get("buyQuantity")));
				allList.get(i).put("fee", df.format(allList.get(i).get("fee")));
				allList.get(i).put("result", df.format(allList.get(i).get("result")));
			}
			try {
				Validation.excelDown(response ,allList, "거래내역" , header , dataNm ,"", sdate+"~"+edate , "");
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectTradeListCnt",in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectTradeList",in);
		model.addAttribute("list", list);
		model.addAttribute("feeResultSum", sampleDAO.select("selectTradeFeeResultSum",in));
		model.addAttribute("testFeeResultSum", sampleDAO.select("selectTradeTestFeeResultSum",in));
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		model.addAttribute("searchIdx", searchIdx);
		model.addAttribute("username", username);
		model.addAttribute("inverse", inverse);
		model.addAttribute("order", order);
		model.addAttribute("orderAD", orderAD);
		model.addAttribute("symbol", symbol);
		model.addAttribute("test", test);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		return "admin/tradeList";
	}
	
	private String reservePosition(String pos){
		if(pos.toLowerCase().equals("long"))
			return "SHORT";
		else
			return "LONG";
	}
	
	@RequestMapping(value="/orderList.do")
	public String orderList(HttpServletRequest request , Model model , HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String searchSelect = request.getParameter("searchSelect");
		String inverse = ""+request.getParameter("inverse");
		String order = request.getParameter("order");
		String orderAD = request.getParameter("orderAD");
		String symbol = request.getParameter("symbol");
		String test = request.getParameter("test");
		String searchIdx = request.getParameter("searchIdx"); // 멤버디테일 - 전체보기 했을때 유저idx 들어옴
		String username = request.getParameter("username"); // 멤버디테일 - 전체보기 했을때 유저네임 들어옴

		if(order==null || order.compareTo("")==0){
			order = "orderDatetime";
			orderAD = "desc";
		}
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("search", search);
		in.put("searchIdx", searchIdx);
		in.put("order", "o."+order);
		in.put("orderAD", orderAD);
		in.put("symbol", symbol);
		in.put("test", test);
		in.put("inverse", CointransService.sqlIsInverseValue(inverse));

		if(searchSelect == null || searchSelect.compareTo("") == 0){
			searchSelect = "name";
		}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
			if(search.split("00").length != 1){
				in.put("search", search.split("00")[1]);
			}
		}
		if(searchSelect.equals("symbol")){
			in.put("searchSelect",searchSelect);
		}else{
			in.put("searchSelect","m."+searchSelect);
		}
		
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			in.put("nolimit", 1);
			ArrayList<EgovMap> allList = (ArrayList<EgovMap>)sampleDAO.list("selectOrderList",in);
			in.put("nolimit", null);
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"시간","회원명","소속 총판","Symbol","주문번호","주문타입","포지션","가격","수량","레버리지","상태"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"orderDatetime","name","pname","symbol","orderNum","orderType","position","entryPrice","buyQuantity","leverage","state"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				allList.get(i).put("orderDatetime", dt.format(allList.get(i).get("orderDatetime")));
				allList.get(i).put("name", allList.get(i).get("name") +(Integer.parseInt(allList.get(i).get("istest")+"") == 1 ? " (테스트계정)" : ""));
				allList.get(i).put("entryPrice", df.format(allList.get(i).get("entryPrice")));
				allList.get(i).put("buyQuantity", df.format(allList.get(i).get("buyQuantity")));
			}
			try {
				Validation.excelDown(response ,allList, "주문내역" , header , dataNm ,"", sdate+"~"+edate , "");
			} catch (Exception e) {
				// TODO: handle exception
			}
		}

		pi.setTotalRecordCount((int)sampleDAO.select("selectOrderListCnt",in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectOrderList",in);
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		model.addAttribute("searchIdx", searchIdx);
		model.addAttribute("username", username);
		model.addAttribute("inverse", inverse);
		model.addAttribute("order", order);
		model.addAttribute("orderAD", orderAD);
		model.addAttribute("symbol", symbol);
		model.addAttribute("test", test);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		return "admin/orderList";
	}

	@ResponseBody
	@RequestMapping(value = "/changeAlarm.do", produces = "application/json; charset=utf8")
	public String changeAlarm(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result","fail");

		String idx = request.getParameter("idx");
		String alarm = request.getParameter("alarm");
		String kind = request.getParameter("kind");

		EgovMap in = new EgovMap();
		in.put("idx", idx);
		in.put("alarm", alarm);

		if(kind.compareTo("d")==0){
			sampleDAO.update("changeAlarmD",in);
		}
		else if(kind.compareTo("w")==0){
			sampleDAO.update("changeAlarmW",in);
		}else if(kind.compareTo("kw")==0){
			sampleDAO.update("changeAlarmKW", in);
		}else if(kind.compareTo("kd")==0){
			sampleDAO.update("changeAlarmKD", in);
		}
		
		obj.put("result","suc");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/withdrawalList.do")
	public String withdrawalList(HttpServletRequest request , Model model){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String searchSelect = request.getParameter("searchSelect");
		String wstat = request.getParameter("wstat");
		String coin = request.getParameter("coin");
		String order = request.getParameter("order");
		String orderAD = request.getParameter("orderAD");
		String test = request.getParameter("test");

		if(order==null || order.compareTo("")==0){
			order = "wdate";
			orderAD = "desc";
		}
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("coin", coin);
		in.put("wstat", wstat);
		in.put("search", search);
		in.put("order", order);
		in.put("orderAD", orderAD);
		in.put("test", test);
		
		if(searchSelect == null || searchSelect.compareTo("") == 0){
			searchSelect = "name";
		}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
			if(search.split("00").length != 1){
				in.put("search", search.split("00")[1]);
			}
		}
		in.put("searchSelect","m."+searchSelect);
		
		
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectWithdrawalList",in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectWithdrawalListCnt",in));
		
		for(EgovMap t : list){
			int userIdx = (int)t.get("wuseridx");
			Member mem = Member.getMemberByIdx(userIdx);
			ArrayList<Member> parents = Member.getParents(mem);
			String parentsText = "";
			
			for(int i = parents.size()-1; i >= 0; i--){
				parentsText += parents.get(i).getName();
				if(i != 0)
					parentsText += " <- ";
			}
			t.put("parents", parentsText);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("coin", coin);
		model.addAttribute("order", order);
		model.addAttribute("orderAD", orderAD);
		model.addAttribute("test", test);
		model.addAttribute("project", Project.getPropertieMap());
		
		in.put("userIdx", 1);
		in.put("check", 1);
		sampleDAO.update("updateMemberBalanceCheck",in);
		return "admin/withdrawalList";
	}
	
	@RequestMapping(value="/kWithdrawalList.do")
	public String kWithdrawalList(HttpServletRequest request , Model model ,HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String mkind = request.getParameter("kind");
		String kind2 = request.getParameter("kind2");
		String searchSelect = request.getParameter("searchSelect");
		String stat = request.getParameter("stat");
		String except = request.getParameter("except");
		String test = request.getParameter("test");
		
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
		
		if(searchSelect == null || searchSelect.compareTo("") == 0){
			searchSelect = "name";
		}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
			if(search.split("00").length != 1){
				in.put("search", search.split("00")[1]);
			}
		}
		in.put("searchSelect","m."+searchSelect);
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectKwithdrawalListCnt",in));
		model.addAttribute("list", sampleDAO.list("selectKwithdrawalList",in));
		EgovMap allout = (EgovMap)sampleDAO.select("depoalloutmoneys",in);
		model.addAttribute("alloutmoneys",allout);
		EgovMap allin = (EgovMap)sampleDAO.select("depoallinmoneys",in);
		
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
			List<EgovMap> sendList = (List<EgovMap>)sampleDAO.list("selectKwithdrawalList",in);
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
		return "admin/kWithdrawalList";
	}
	
	@ResponseBody
	@RequestMapping(value="/cancelDeposit.do" , produces="application/json; charset=utf8")
	public String cancelDeposit(HttpServletRequest request){
		String idx = request.getParameter("idx");
		String midx = request.getParameter("midx");
		EgovMap select = (EgovMap)sampleDAO.select("checkMoneyIdx",idx);
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
		sampleDAO.update("updateMoney",in); // 완료 -> 미승인
		
		Member member = Member.getMemberByIdx(Integer.parseInt(midx));
	    Wallet.updateWallet(member, before-exchangeValue, (exchangeValue*-1), "USDT", "-", "depositCancel");
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CANCLE_DEPOSIT, mem.userIdx, null, 0, -exchangeValue,before+" -> "+(before-exchangeValue));
		obj.put("result", "success");
		obj.put("msg", "입금취소되었습니다");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/withdrawalProcess.do", method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String withdrawalProcess(HttpServletRequest request , Model model){
		JSONObject obj = new JSONObject();
		String userip = Member.getClientIP(request);
		Log.print("w ip:"+userip, 1, "withdraw");
/*		if(userip.compareTo("191.101.132.181")!=0){
			Log.print("Diff ip:"+userip, 1, "withdraw");
			obj.put("result", "WrongAccess!");
			return obj.toJSONString();		
		}*/
		String widx = request.getParameter("widx");
		String stat = request.getParameter("stat");//-1이메일승인전 0대기(이멜승인후)  관리자  1승인 2미승인
		String tx = request.getParameter("tx");
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		in.put("stat", stat);
		EgovMap select = (EgovMap)sampleDAO.select("selectWithdrawal",in);//agree
		String result = "fail";
		String wstat = select.get("wstat").toString();
		String useridx = select.get("wuseridx").toString();
		String coinname = select.get("wcoinname").toString();
		double price = Double.parseDouble(select.get("wamount").toString());
		Member mem = Member.getMemberByIdx(Integer.parseInt(useridx));
		//대기인것만 처리가능
		if(!stat.equals("0") && !wstat.equals("0")){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		
		obj.put("result", result);
		obj.put("widx", widx);
		obj.put("stat", stat);
		
		//승인 
		if(stat.compareTo("1")==0){
			//ip 체크 
/*			String ip = request.getHeader("X-Forwarded-For");
		    if (ip == null) ip = request.getRemoteAddr();
		    if(ip.compareTo("")!=0) {
				obj.put("result", "fail");
				return obj.toJSONString();		    	
		    }*/
		    
			//본사 지갑과 체크
			in.put("userIdx", "1");
			in.put("coin", select.get("wcoinname"));
/*			double adminBalance = (double)sampleDAO.select("selectRealBalance",in);
			if(Double.parseDouble(select.get("wamount").toString()) > adminBalance){
				obj.put("result", "fail");
				return obj.toJSONString();
			}
			*/
			result = CointransService.withdrawProcess(useridx,price,coinname, ""+select.get("widx"), tx);
			if(result.compareTo("fail")==0){
				obj.put("result", "error");
				return obj.toJSONString();
			}			
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.WITHDRAW, mem.userIdx, coinname, 1, price,null);
		}else if(stat.compareTo("2")==0){
			if(wstat.compareTo("0") != 0){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			in.put("stat", 2);
			double prevWallet = mem.getWalletC(coinname);
			CointransService.withdrawDenyProcess(widx);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.WITHDRAW, mem.userIdx, coinname, 0, price,prevWallet+" -> "+(prevWallet+price));
		}else if(stat.compareTo("0")==0){
			if(wstat.equals("0")){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			in.put("stat", 0);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.PENDING, mem.userIdx, coinname, 1, price,null);
		}
		
		obj.put("result","ok");
		sampleDAO.update("updateWithdrawalStat",in);
		return obj.toJSONString();		
	}
	
	@ResponseBody
	@RequestMapping(value="/kWithdrawalProcess.do", method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String kWithdrawalProcess(HttpServletRequest request , Model model){
		JSONObject obj = new JSONObject();
		String userip = Member.getClientIP(request);
		Log.print("w ip:"+userip, 1, "withdraw");
		String widx = request.getParameter("widx");
		String stat = request.getParameter("stat");//-1이메일승인전 0대기(이멜승인후)  관리자  1승인 2미승인
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		in.put("stat", stat);
		EgovMap select = (EgovMap)sampleDAO.select("selectKwithdrawal",in);//agree
		String result = "fail";
		
		String wstat = select.get("stat").toString();
		String useridx = select.get("useridx").toString();
		String kind = select.get("kind").toString();
		double price = Double.parseDouble(select.get("money").toString());
		
		//대기인것만 처리가능
		if(!stat.equals("0") && !wstat.equals("0")){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		
		obj.put("result", result);
		obj.put("widx", widx);
		obj.put("stat", stat);
		
		Member mem = Member.getMemberByIdx(Integer.parseInt(useridx));
		double prevWallet = mem.getWallet();
		double nextWallet = prevWallet + price;
		int action = 1;
		//승인 
		if(stat.compareTo("1")==0){
			result = CointransService.kWithdrawProcess(useridx,price, stat, ""+select.get("idx"));
			if(result.compareTo("fail")==0){
				obj.put("result", "error");
				return obj.toJSONString();
			}	
			AdminUtil.insertAdminLog(request, sampleDAO, kind.equals("+") ? AdminLog.P2P_DEPOSIT : AdminLog.P2P_WITHDRAW, mem.userIdx, null, action, price,prevWallet+" -> "+nextWallet);

		}else if(stat.compareTo("2")==0){
			action = 0;
			EgovMap target = (EgovMap)sampleDAO.select("checkMoneyIdx",in);
			if(target.get("stat").toString().compareTo("0") != 0){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			if(kind.equals("-")) {
				CointransService.kWithdrawDenyProcess(widx);
			} else if(kind.equals("+")){
				in.put("stat", 2);
				in.put("idx", widx);
				sampleDAO.update("updateMoney",in);
			}
			AdminUtil.insertAdminLog(request, sampleDAO, kind.equals("+") ? AdminLog.P2P_DEPOSIT : AdminLog.P2P_WITHDRAW, mem.userIdx, null, action, price,prevWallet+" -> "+nextWallet);
		}else if(stat.compareTo("0")==0){
			if(wstat.equals("0")){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			in.put("stat", 0);
			in.put("idx", widx);
			sampleDAO.update("updateMoney",in);
		}
		obj.put("result","ok");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/emailList.do")
	public String emailList(HttpServletRequest request , Model model){
		String idx = request.getParameter("idx");//userIdx 
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberDetail",idx);
		model.addAttribute("info", info);
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(50);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("idx", idx);
		pi.setTotalRecordCount((int)sampleDAO.select("selectElistCnt",in));
		model.addAttribute("list", sampleDAO.list("selectElistList",in));
		model.addAttribute("pi", pi);
		return "admin/emailList";
	}
	
	@ResponseBody
	@RequestMapping(value="/withdrawalEmailConfirm.do", method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String withdrawalEmailConfirm(HttpServletRequest request , Model model){
		JSONObject obj = new JSONObject();

		HttpSession session = request.getSession();
		if(!AdminUtil.highAdminCheck(session)){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		
		String widx = request.getParameter("widx");
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		EgovMap select = (EgovMap)sampleDAO.select("selectWithdrawal",in);//agree
		
		String result = "fail";
		String wstat = select.get("wstat").toString();
		
		//대기인것만 처리가능
		if(wstat.compareTo("-1")!=0){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		in.put("stat", 0);
		sampleDAO.update("updateWithdrawalStat",in);	
		obj.put("result","ok");
		return obj.toJSONString();		
	}
	
	@RequestMapping(value="/depositList.do")
	public String depositList(HttpServletRequest request , Model model){
		String label = request.getParameter("label"); //only t
		String sdate = request.getParameter("sdate"); //ok
		String edate = request.getParameter("edate"); //ok
		String searchSelect = request.getParameter("searchSelect"); //ok
		String search = request.getParameter("search"); //ok
		String status = request.getParameter("wstat"); // stat
		String coin = request.getParameter("coin");
		String searchIdx = request.getParameter("searchIdx"); // 멤버디테일 - 전체보기 했을때 유저idx 들어옴
		String username = request.getParameter("username"); // 멤버디테일 - 전체보기 했을때 유저네임 들어옴
		String order = request.getParameter("order");
		String orderAD = request.getParameter("orderAD");
		String test = request.getParameter("test");
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		
		in.put("label", "+");
		
		if(coin != null && coin.compareTo("") != 0){
			in.put("coin", coin);
		}
		if(sdate != null && sdate.compareTo("") != 0){
			in.put("sdate", sdate);
			in.put("edate", edate);
		}

		if(search != null && search.compareTo("") != 0){
			in.put("search", search);
			if(searchSelect == null || searchSelect.compareTo("") == 0){
				searchSelect = "name";
			}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
				if(search.split("00").length != 1){
					in.put("search", search.split("00")[1]);
				}
			}
			in.put("searchSelect","m."+searchSelect);
		}
		in.put("searchIdx",searchIdx);
		in.put("isDeposit","true");
		in.put("order", order);
		in.put("orderAD", orderAD);
		in.put("test",test);
		
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectAllTransactions",in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectAllTransactionsCnt",in));
		
		for(EgovMap t : list){
			int userIdx = (int)t.get("userIdx");
			Member mem = Member.getMemberByIdx(userIdx);
			ArrayList<Member> parents = Member.getParents(mem);
			String parentsText = "";
			
			for(int i = parents.size()-1; i >= 0; i--){
				parentsText += parents.get(i).getName();
				if(i != 0)
					parentsText += " <- ";
			}
			t.put("parents", parentsText);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("label", label);		
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("wstat", status);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		model.addAttribute("searchIdx", searchIdx);
		model.addAttribute("username", username);
		model.addAttribute("coin", coin);
		model.addAttribute("order", order);
		model.addAttribute("orderAD", orderAD);
		model.addAttribute("test", test);
		return "admin/depositList";
	}
	
	@ResponseBody
	@RequestMapping(value="/depositProcess.do", method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String depositProcess(HttpServletRequest request , Model model){
		String result = "fail";
		JSONObject obj = new JSONObject();
		String userip = Member.getClientIP(request);
		Log.print("d ip:"+userip, 1, "withdraw");
/*		if(userip.compareTo("191.101.132.181")!=0){
			Log.print("Diff ip:"+userip, 1, "withdraw");
			obj.put("result", "WrongAccess!");
			return obj.toJSONString();		
		}*/
		String widx = request.getParameter("widx");
		String stat = request.getParameter("stat");//-1이메일승인전 0대기(이멜승인후)  관리자  1승인 2미승인
		EgovMap in = new EgovMap();
		in.put("idx", widx);
		EgovMap target = (EgovMap)sampleDAO.select("selectTransactionByIdx", in);
		String status = ""+target.get("status");
		//대기인것만 처리가능
		if(!stat.equals("0") && !status.equals("0")){
			obj.put("result", "error");
			return obj.toJSONString();
		}
		
		String userIdx = target.get("userIdx").toString();
		String coin = target.get("coin").toString();
		double amount = Double.parseDouble(target.get("amount").toString());
		double fee = Double.parseDouble(target.get("fee").toString());
		
		obj.put("result", result);
		obj.put("widx", widx);
		
		Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
		int action = 0;
		double prevWallet = mem.getWalletC(coin);
		//승인 
		if(stat.compareTo("1")==0){
			action = 1;
			//ip 체크 
/*			String ip = request.getHeader("X-Forwarded-For");
		    if (ip == null) ip = request.getRemoteAddr();
		    if(ip.compareTo("")!=0) {
				obj.put("result", "fail");
				return obj.toJSONString();		    	
		    }*/
		    
			//본사 지갑과 체크
			//in.put("userIdx", "1");
			//in.put("coin", target.get("coin"));
/*			double adminBalance = (double)sampleDAO.select("selectRealBalance",in);
			if(Double.parseDouble(select.get("wamount").toString()) > adminBalance){
				obj.put("result", "fail");
				return obj.toJSONString();
			}
			*/
			result = CointransService.depositProcess(userIdx,amount,coin, ""+target.get("idx"), fee);
			if(result.compareTo("fail")==0){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			in.put("status", 1);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.DEPOSIT, mem.userIdx, coin, action, amount,prevWallet+" -> "+mem.getWalletC(coin));

		}else if(stat.compareTo("2")==0){
			if(status.compareTo("0") != 0){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			in.put("status", 2);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.WITHDRAW, mem.userIdx, coin, action, amount,null);

		}else if(stat.compareTo("0")==0){
			if(status.equals("0")){
				obj.put("result", "error");
				return obj.toJSONString();
			}
			in.put("status", 0);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.PENDING, mem.userIdx, coin, 1, amount,null);

		}
		sampleDAO.update("updateTransactionByIdx", in);
		
		obj.put("result","ok");
		return obj.toJSONString();		
	}
	
	@RequestMapping(value="/positionList.do")
	public String positionList(HttpServletRequest request  , Model model){
		HttpSession session = request.getSession();
		session.setAttribute("posSearchInfo", null);
		model.addAttribute("search",request.getParameter("search"));
		model.addAttribute("project",Project.getPropertieMap());
		model.addAttribute("useCoins",Project.getUseCoinNames());
		return "admin/positionList";
	}
	
	@RequestMapping(value="/calculList.do")
	public String calculList(HttpServletRequest request  , Model model){
		String searchSelect = request.getParameter("searchSelect");
		String search = request.getParameter("search");
		String test = request.getParameter("test");
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(5);
		
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		
		if(search != null && search.compareTo("") != 0){
			in.put("search", search);
			if(searchSelect == null || searchSelect.compareTo("") == 0){
				searchSelect = "name";
			}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
				if(search.split("00").length != 1){
					in.put("search", search.split("00")[1]);
				}
			}
			in.put("searchSelect","m."+searchSelect);
		}
		in.put("test",test);
		
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectChongCalculList",in);
		for(EgovMap data : list){
			Member m = Member.getMemberByIdx(Integer.parseInt(data.get("idx").toString()));
			if(m != null){
				Member p = m.getParent();
				String pname = "없음";
				if(p != null){
					pname = p.getName();
				}
				data.put("pname", pname);
			}else{
				Log.print(data.get("idx").toString()+"번 총판 메모리 로드 실패 err", 1, "err");
			}
		}
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectChongCalculListCnt",in));
		model.addAttribute("list", list);

		model.addAttribute("pi", pi);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		model.addAttribute("test", test);
		
		return "admin/calculList";
	}
	
	
	@RequestMapping(value="/liqList.do")
	public String liqList(HttpServletRequest request , Model model, HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String searchSelect = request.getParameter("searchSelect");
		String search = request.getParameter("search");
		String pos = request.getParameter("pos");
		String inverse = ""+request.getParameter("inverse");
		String order = request.getParameter("order");
		String orderAD = request.getParameter("orderAD");
		String symbol = request.getParameter("symbol");
		String test = request.getParameter("test");
		String searchIdx = request.getParameter("searchIdx"); // 멤버디테일 - 전체보기 했을때 유저idx 들어옴
		String username = request.getParameter("username"); // 멤버디테일 - 전체보기 했을때 유저네임 들어옴

		if(order==null || order.compareTo("")==0){
			order = "ltime";
			orderAD = "desc";
		}
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		
		if(pos != null && pos.compareTo("") != 0){
			in.put("position", pos);
		}
		if(sdate != null && sdate.compareTo("") != 0){
			in.put("sdate", sdate);
			in.put("edate", edate);
		}
		if(search != null && search.compareTo("") != 0){
			in.put("search", search);
			if(searchSelect == null || searchSelect.compareTo("") == 0){
				searchSelect = "name";
			}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
				if(search.split("00").length != 1){
					in.put("search", search.split("00")[1]);
				}
			}
			in.put("searchSelect","m."+searchSelect);
		}
		in.put("searchIdx",searchIdx);
		in.put("order", "l."+order);
		in.put("orderAD",orderAD);
		in.put("symbol",symbol);
		in.put("test",test);
		in.put("inverse", CointransService.sqlIsInverseValue(inverse));
		
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			in.put("nolimit",1);
			ArrayList<EgovMap> allList = (ArrayList<EgovMap>)sampleDAO.list("selectLiqlogList",in);
			in.put("nolimit",null);
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"청산시간","회원명","소속 총판","UID","Symbol","시장가","발동가","포지션"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"ltime","name","pname","userIdx","symbol","sise","triggerPrice","position"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				allList.get(i).put("ltime", dt.format(allList.get(i).get("ltime")));
				allList.get(i).put("name", allList.get(i).get("name") +(Integer.parseInt(allList.get(i).get("istest")+"") == 1 ? " (테스트계정)" : ""));
				allList.get(i).put("sise", df.format(allList.get(i).get("sise")));
				allList.get(i).put("triggerPrice", df.format(allList.get(i).get("triggerPrice")));
				allList.get(i).put("userIdx", "00"+allList.get(i).get("userIdx"));
			}
			try {
				Validation.excelDown(response ,allList, "청산내역" , header , dataNm ,"", sdate+"~"+edate , "");
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectLiqlogList",in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectLiqlogListCnt",in));
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		model.addAttribute("searchIdx", searchIdx);
		model.addAttribute("username", username);
		model.addAttribute("pos", pos);
		model.addAttribute("inverse", inverse);
		model.addAttribute("order", order);
		model.addAttribute("orderAD", orderAD);
		model.addAttribute("symbol", symbol);
		model.addAttribute("test", test);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		
		return "admin/liqList";
	}
	
	@RequestMapping(value="/manipulation.do")
	public String manipulation(HttpServletRequest request , Model model){
		
		model.addAttribute("mList", SocketHandler.sh.getMList());
		model.addAttribute("useCoins",Project.getUseCoinNames());
		return "admin/manipulation";
	}
	@RequestMapping(value="/tailmanipul.do")
	public String tailmanipul(HttpServletRequest request , Model model){
		model.addAttribute("mList", SocketHandler.sh.getMList());
		model.addAttribute("useCoins",Project.getUseCoinNames());
		return "admin/tailmanipul";
	}
	
	@ResponseBody
	@RequestMapping(value="/manipultailProcess.do" , produces = "application/json; charset=utf8")
	public String manipultailProcess(HttpServletRequest request){
		HttpSession session = request.getSession();
		EgovMap in=new EgovMap();
		String coinname = ""+request.getParameter("symbol");
		Coin coin = Coin.getCoinInfo(coinname);
		double price = Double.parseDouble(""+request.getParameter("price")) + coin.getSise("long");
		in.put("coin", coinname);
		in.put("price", price);
		in.put("gap", ""+request.getParameter("gap"));
		in.put("nowPrice", coin.getSise("long"));
		in.put("aidx", session.getAttribute("adminIdx"));
		sampleDAO.insert("insertBalancelog",in);
		JSONObject obj = new JSONObject();
		obj.put("symbol", request.getParameter("symbol"));
		obj.put("price", price);
		obj.put("gap", request.getParameter("gap"));
		double gap = Double.parseDouble(request.getParameter("gap"));
		String mresult = SocketHandler.sh.manipulation(obj);
		if(mresult == "true"){
			obj.put("result", "success");
			obj.put("msg", "설정 완료되었습니다.");
		}else{
			obj.put("result", "fail");
			obj.put("msg", mresult);
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/manipulProcess.do" , produces = "application/json; charset=utf8")
	public String manipulProcess(HttpServletRequest request){
		HttpSession session = request.getSession();
		EgovMap in=new EgovMap();
		String coinname = ""+request.getParameter("symbol");
		Coin coin = Coin.getCoinInfo(coinname);
		
		String symbol = ""+request.getParameter("symbol");
		double price = Double.parseDouble(""+request.getParameter("price"));
		double gap = Double.parseDouble(""+request.getParameter("gap"));
		
		in.put("coin", symbol);
		in.put("price", price);
		in.put("gap", gap);
		in.put("nowPrice", coin.getSise("long"));
		in.put("aidx", session.getAttribute("adminIdx"));
		sampleDAO.insert("insertBalancelog",in);
		JSONObject obj = new JSONObject();
		obj.put("symbol", request.getParameter("symbol"));
		obj.put("price", request.getParameter("price"));
		obj.put("gap", request.getParameter("gap"));
//		if(gap > 0.3 || gap <= 0) {
//			obj.put("result", "fail");
//			obj.put("msg", "변동가는 0.3까지 입력 가능합니다.");
//			return obj.toJSONString();
//		}
		String mresult = SocketHandler.sh.manipulation(obj);
		NewSiseManager.setStartRC(gap, price, symbol);
		if(mresult == "true"){
			obj.put("result", "success");
			obj.put("msg", "설정 완료되었습니다.");
		}else{
			obj.put("result", "fail");
			obj.put("msg", mresult);
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/resetChart.do" , produces = "application/json; charset=utf8")
	public String resetChart(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		String mresult = SocketHandler.sh.resetChart();
		obj.put("result", mresult);
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/resetMStatus.do" , produces = "application/json; charset=utf8")
	public String resetMStatus(HttpServletRequest request){
		String mresult = SocketHandler.sh.resetMStatus();
		JSONObject obj = new JSONObject();
		if(mresult == "true"){
			obj.put("result", "success");
			obj.put("msg", "조작 종목 초기화 완료되었습니다.");
		}else{
			obj.put("result", "fail");
			obj.put("msg", "오류가 발생했습니다. 다시 시도해 주세요.");
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/setSearchInfo.do" , produces = "application/json; charset=utf8")
	public String setSearchInfo(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		String search = request.getParameter("search");
		String searchSelect = request.getParameter("searchSelect");
		EgovMap searchInfo = new EgovMap();
		searchInfo.put("searchSelect", searchSelect);
		searchInfo.put("search", search);
		HttpSession session = request.getSession();
		session.setAttribute("posSearchInfo", searchInfo);
		obj.put("result", "suc");
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value="/getNowPositionData.do" , produces = "application/json; charset=utf8")
	public String getNowPositionData(HttpServletRequest request){
		
		HttpSession session = request.getSession();
		EgovMap search = (EgovMap)session.getAttribute("posSearchInfo");
		
		JSONObject obj = new JSONObject();
		JSONArray [] plist = new JSONArray[Project.getFullCoinList().size()];
		for(int i = 0; i < plist.length; i++){
			plist[i] = new JSONArray();
		}
		for(Position p : SocketHandler.positionList){
			Coin coin = Coin.getCoinInfo(p.symbol);
			
			if(!positionSearch(search,p))
				continue;
			
			JSONObject item = new JSONObject();
			item.put("userIdx",p.userIdx);
			item.put("name",p.member.getName());
			item.put("pname","없음");
			item.put("ptest","0");
			if(p.member.getParent() != null){
				item.put("pname",p.member.getParent().getName());
				item.put("ptest",p.member.getParent().getIstest());
				item.put("pidx",p.member.getParent().userIdx);
			}
			item.put("symbol", p.symbol);
    		item.put("position", p.position);
    		item.put("entryPrice", p.entryPrice);
    		item.put("buyQuantity", p.buyQuantity);
    		item.put("liquidationPrice", p.liquidationPrice);
    		item.put("fee", p.fee);
    		item.put("contractVolume", p.contractVolume);
    		item.put("leverage", p.leverage);
    		item.put("profit", p.getProfit());
    		item.put("profitRate", p.getProfitRate());
    		item.put("online", SocketHandler.sh.checkOnlineUser(String.valueOf(p.userIdx)));
    		item.put("istest", p.member.getIstest());
    		plist[coin.coinNum].add(item);
		}
		for(Coin coin : Project.getUseCoinList()){
			obj.put(coin.coinName.toLowerCase()+"list",plist[coin.coinNum]);
		}
		obj.put("online",SocketHandler.sh.getSessionSetSize());
		return obj.toJSONString();
	}
	
	boolean positionSearch(EgovMap searchInfo, Position p){
		if(searchInfo == null)
			return true;
		
		String search = searchInfo.get("search").toString();
		if(search.isEmpty())
			return true;

		switch(searchInfo.get("searchSelect").toString()){
		case "name":
			if(p.member.getName().contains(search))
				return true;
			break;
		case "inviteCode":
			if(p.member.inviteCode.equals(search))
				return true;
			break;
		case "child":
			if(p.member.getParent() != null){
				if(p.member.getParent().inviteCode.equals(search))
					return true;
			}
			break;
		case "allChild":
			Member grand = Member.getMemberByInviteCode(search);
			if(grand != null){
				ArrayList<Member> searchMember = grand.getChildrenChong();
				searchMember.add(grand);
				for(Member m : searchMember){
					if(p.member.getParent() != null){
						if(p.member.getParent().userIdx == m.userIdx)
							return true;
					}
				}
			}
			break;
		}
		
		return false;
	}
	
	@ResponseBody
	@RequestMapping(value="/getPositionData.do" , produces = "application/json; charset=utf8")
	public String getPositionData(HttpServletRequest request){
		int size = Project.getFullCoinList().size();
		
		JSONObject obj = new JSONObject();
		JSONArray [] plist = new JSONArray[size];
		EgovMap [] coinMaps = new EgovMap[size];
		
		double [] lfees = new double[size];
		double [] sfees = new double[size];
		double [] lvolumes = new double[size];
		double [] svolumes = new double[size];
		int [] lCounts = new int[size];
		int [] sCounts = new int[size];
		
		for(int i = 0; i < size; i++){
			plist[i] = new JSONArray();
			coinMaps[i] = new EgovMap();
		}
		
		for(Position p : SocketHandler.positionList){
			Coin coin = Coin.getCoinInfo(p.symbol);
			double fee = p.fee;
			if(CointransService.isInverse(p.symbol))
				fee *= p.entryPrice;
			
			if(p.position.equals("long")){
				lCounts[coin.coinNum]++;
				lfees[coin.coinNum] += fee;
				lvolumes[coin.coinNum] += p.contractVolume;
			}else{
				sCounts[coin.coinNum]++;
				sfees[coin.coinNum] += fee;
				svolumes[coin.coinNum] += p.contractVolume;
			}
			
			JSONObject item = new JSONObject();
			item.put("userIdx",p.userIdx);
			item.put("name",p.member.getName());
			item.put("symbol", p.symbol);
    		item.put("position", p.position);
    		item.put("entryPrice", p.entryPrice);
    		item.put("buyQuantity", p.buyQuantity);
    		item.put("liquidationPrice", p.liquidationPrice);
    		item.put("fee", p.fee);
    		item.put("contractVolume", p.contractVolume);
    		item.put("leverage", p.leverage);
    		item.put("profit", p.getProfit());
    		item.put("profitRate", p.getProfitRate());
    		item.put("online", SocketHandler.sh.checkOnlineUser(String.valueOf(p.userIdx)));
    		plist[coin.coinNum].add(item);
		}
		for(int i = 0; i < coinMaps.length; i++){
			coinMaps[i].put("lfee", PublicUtils.toFixed(lfees[i],2));
			coinMaps[i].put("lvolume", PublicUtils.toFixed(lvolumes[i], 2));
			coinMaps[i].put("sfee", PublicUtils.toFixed(sfees[i],2));
			coinMaps[i].put("svolume", PublicUtils.toFixed(svolumes[i], 2));
			int total = lCounts[i] + sCounts[i];
			double lRate = 0;
			double sRate = 0;
			if(total != 0){
				lRate = PublicUtils.toFixed(((double)lCounts[i] / total) * 100, 2);
				sRate = 100 - lRate;
			}
			coinMaps[i].put("lRate", lRate);
			coinMaps[i].put("sRate", sRate);
		}
		for(Coin coin : Project.getUseCoinList()){
			obj.put(coin.coinName.toLowerCase()+"list",plist[coin.coinNum]);
			obj.put(coin.coinName.toLowerCase()+"Info", coinMaps[coin.coinNum]);
		}
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/checkProblemIdx.do")
	public String checkProblemIdx(HttpServletRequest request , Model model){
		model.addAttribute("plist", sampleDAO.list("listProblemIdx") );
		
		return "admin/checkProblemidx";
	}
	@RequestMapping(value="/checkProblemTxList.do")
	public String checkProblemTxList(HttpServletRequest request , Model model){
		String uidx = request.getParameter("uidx");
		System.out.println("============================="+uidx);
		model.addAttribute("plist", sampleDAO.list("listProblemTxList",uidx) );
		return "admin/checkProblemTxList";
	}
	
	@ResponseBody
	@RequestMapping(value="/tailSet.do" , produces = "application/json; charset=utf8")
	public String tailSet(HttpServletRequest request){
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		try {
			int coinNum = Integer.parseInt(request.getParameter("coinNum").toString());
			int type = Integer.parseInt(request.getParameter("type").toString()); // 0 - 변동값 , 1 - 변동확률
			String val = request.getParameter("val").toString();
			Coin coin = Coin.getCoinInfo(coinNum);
			if(type == 0){
				coin.tailSet(sampleDAO, coin.tailRate, Double.parseDouble(val));
			}else{
				coin.tailSet(sampleDAO,Integer.parseInt(val), coin.tailPrice);
			}
		} catch (Exception e) {
			obj.put("msg", "요청을 실패했습니다.");
		}
		
		obj.put("result", "suc");
		obj.put("msg", "변경완료되었습니다.");
		return obj.toJSONString();
	}
}
