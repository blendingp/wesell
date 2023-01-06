package egovframework.example.sample.web.admin;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/admin")
public class DashBoardController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;

	@RequestMapping(value = "/main.do")
	public String main(HttpServletRequest request, ModelMap model) throws Exception {
		model.addAttribute("todayMemCnt",sampleDAO.select("selectTodayMemberCnt"));
		model.addAttribute("memCnt",sampleDAO.select("selectMemberCnt"));
		return "admin/main";
	}
	
	@ResponseBody
	@RequestMapping(value="/getDashboard.do"  , produces="application/json; charset=utf8")
	public String getDashboard(HttpServletRequest request){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		JSONObject obj = new JSONObject();
		//회원 ( 유저 + 파트너) 관리자1번 제외   보유잔고 futures
		obj.put("wallet" , sampleDAO.select("selectMemberAllWallet"));
		//obj.put("pWallet" , sampleDAO.select("selectPartnerWallet"));
		
		//회원 ( 유저 + 파트너) 관리자1번 제외   보유잔고 BTC USDT XRP TRX
		List<EgovMap> userBalance = (List<EgovMap>)sampleDAO.list("selectUserBalance");
		for(int i = 0; i < userBalance.size(); i++){
			String coin = userBalance.get(i).get("coinname").toString();
			obj.put("user"+coin,userBalance.get(i).get("bal"));
		}
		
		//유저 입금 총액
		EgovMap in = new EgovMap();
		in.put("sdate", sdate);
		in.put("edate", edate);
		
		in.put("label", "+");
		List<EgovMap> depo = (List<EgovMap>)sampleDAO.list("selectTransSumDate",in);
		for(int i = 0; i < depo.size(); i++){
			String coin = depo.get(i).get("coin").toString();
			obj.put("deposit"+coin,depo.get(i).get("amountsum"));
		}

		//출금 총액
		in.put("label", "-");
		List<EgovMap> with = (List<EgovMap>)sampleDAO.list("selectWithdrawSumDate", in);
		for(int i = 0; i < with.size(); i++){
			String coin = with.get(i).get("coin").toString();
			obj.put("withdraw"+coin,with.get(i).get("amountsum"));
		}
		return obj.toJSONString();
	}
	
	//입금내역
	@RequestMapping(value="/transactions.do")
	public String transactions(HttpServletRequest request , Model model , HttpServletResponse response){
		String label = request.getParameter("label");
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String searchSelect = request.getParameter("searchSelect");
		String search = request.getParameter("search");
		String status = request.getParameter("wstat");
		String coin = request.getParameter("coin");
		String order = request.getParameter("order");
		String orderAD = request.getParameter("orderAD");
		String test = request.getParameter("test");
		String searchIdx = request.getParameter("searchIdx"); // 멤버디테일 - 전체보기 했을때 유저idx 들어옴
		String username = request.getParameter("username"); // 멤버디테일 - 전체보기 했을때 유저네임 들어옴
		
		if(order==null || order.compareTo("")==0){
			order = "completionTime";
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
		
		if(label != null && label.compareTo("") != 0){
			in.put("label", label);
		}
		
		if(coin != null && coin.compareTo("") != 0){
			in.put("coin", coin);
		}
		if(sdate != null && sdate.compareTo("") != 0){
			in.put("sdate", sdate);
			in.put("edate", edate);
		}
		if(status != null && status.compareTo("") != 0){
			in.put("status", status);
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
		in.put("order", order);
		in.put("orderAD", orderAD);
		in.put("test",test);
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectAllTransactionsCnt",in));
		model.addAttribute("list", sampleDAO.list("selectAllTransactions",in));
		in.put("limit" , "n");
		List<EgovMap> sendList = (List<EgovMap>)sampleDAO.list("selectAllTransactions",in);

		in.put("label", "+");
		List<EgovMap> dlist = (List<EgovMap>)sampleDAO.list("selectWDSum",in);
		in.put("label", "-");
		List<EgovMap> wlist = (List<EgovMap>)sampleDAO.list("selectWDSum",in);
		if(dlist.size() == 0) dlist = null;
		if(wlist.size() == 0) wlist = null;
		
		model.addAttribute("dlist", dlist);
		model.addAttribute("wlist", wlist);
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
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"송금시간","회원명","보낸 회원","받은 회원","코인명","수량","tx","상태","입/출금"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"completionTime","name","fromname","toname","coin","amount","tx","status","label"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<sendList.size(); i++){
				sendList.get(i).put("completionTime", dt.format(sendList.get(i).get("completionTime")));
				String sendlabel = ""+sendList.get(i).get("label");
				if(sendlabel.equals("+")){
					sendList.get(i).put("name", sendList.get(i).get("fromname") == null ? "확인불가": sendList.get(i).get("fromname") +(Integer.parseInt(sendList.get(i).get("istest")+"") == 1 ? " (테스트계정)" : ""));
				}else{
					sendList.get(i).put("name", sendList.get(i).get("toname") == null ? "확인불가": sendList.get(i).get("toname"));
				}
				sendList.get(i).put("amount", df.format(sendList.get(i).get("amount")));
				sendList.get(i).put("tx", sendList.get(i).get("tx") + (sendList.get(i).get("dtag") == null ? "" : " (D Tag:"+sendList.get(i).get("dtag")+")"));
				int stat = Integer.parseInt(""+sendList.get(i).get("status"));
				if(stat == 0) sendList.get(i).put("status", "pending"); 
				if(stat == 1) sendList.get(i).put("status", "complete"); 
				if(stat == 2) sendList.get(i).put("status", "unapproved"); 
				if(sendList.get(i).get("label").equals("+")){
					sendList.get(i).put("label", "입금");
				}else{
					sendList.get(i).put("label", "출금");
				}
						
			}
			String searchData = "";
			String searchData2 = "";
			if(search != null && !search.trim().equals("")){
				String searchType = "회원명";
				if(searchSelect.equals("UID"))searchType = "UID";
				searchData += "검색조건 :"+searchType+" 검색어 : "+search;
			}
			String coinSearch = "전체";
			if(coin != null && !coin.equals(""))coinSearch = coin;
			searchData += " 코인:"+coinSearch;
			searchData2 += " 총액계산 (대기/미승인/테스트계정제외) - 입금총액  ";
			if(dlist == null)searchData2 +="없음";
			else{
				for(int i=0; i< dlist.size(); i++){
					searchData2 += dlist.get(i).get("coinname")+":"+df.format(dlist.get(i).get("sumamount"))+" ";
				}
			}
			searchData2 += " / 출금총액  ";
			if(wlist == null)searchData2 +="없음";
			else{
				for(int i=0; i< wlist.size(); i++){
					System.out.println(wlist.get(i));
					searchData2 += wlist.get(i).get("coinname")+":"+df.format(wlist.get(i).get("sumamount"))+" ";
				}
			}
			try {
				Validation.excelDown(response ,sendList, "입출금내역" , header , dataNm ,searchData, sdate+"~"+edate , searchData2);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return "admin/transactions";
	}
	//출금내역
	
	@ResponseBody
	@RequestMapping(value="/cancelDeposit.do" , produces="application/json; charset=utf8")
	public String cancelDeposit(HttpServletRequest request){
		String idx = request.getParameter("idx");
		String useridx = request.getParameter("midx");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		EgovMap tlog = (EgovMap)sampleDAO.select("selectTransactionByIdx",idx);
		Member member = Member.getMemberByIdx(Integer.parseInt(useridx));
		double before = member.getWalletC(tlog.get("coin")+"");
		double amount = Double.parseDouble(""+tlog.get("amount"));
		//DB+메모리 잔액 갱신
		Wallet.updateWallet(member, before-amount , (amount*-1), tlog.get("coin")+"", "-", "depositCancel");
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		in.put("status", 2);
		sampleDAO.update("updateTransactionByIdx",in);
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.CANCLE_DEPOSIT, member.userIdx, tlog.get("coin")+"", 1, -amount,before+" -> "+(before-amount));
		obj.put("result", "success");
		obj.put("msg", "입금취소되었습니다");
		return obj.toJSONString();
	}

	@RequestMapping(value="/chongPerfomance.do")
	public String chongPerfomance(HttpServletRequest request , Model model , HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
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
			in.put("searchSelect",searchSelect);
		}
		in.put("test",test);
		
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectChongPerfomances",in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectChongPerfomancesCnt",in));
		model.addAttribute("list", list);

		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		model.addAttribute("test", test);
		
		return "admin/chongPerfomance";
	}
}
