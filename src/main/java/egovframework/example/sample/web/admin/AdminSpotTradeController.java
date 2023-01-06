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
@RequestMapping("/admin/spottrade")
public class AdminSpotTradeController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
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
			ArrayList<EgovMap> allList = (ArrayList<EgovMap>)sampleDAO.list("selectSpotTradeList",in);
			in.put("nolimit", null);
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"시간","회원명","소속 총판","Symbol","주문번호","주문타입","포지션","가격","수량","수수료"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"buyDatetime","name","pname","symbol","orderNum","orderType","position","entryPrice","buyQuantity","fee"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				/*if(Boolean.parseBoolean(allList.get(i).get("isOpen").toString())){
					allList.get(i).put("entryPrice", df.format(allList.get(i).get("entryPrice")));
					allList.get(i).put("position", allList.get(i).get("position").toString().toUpperCase());
				}else{
					allList.get(i).put("entryPrice", df.format(allList.get(i).get("liqPrice")));
					allList.get(i).put("position", reservePosition(allList.get(i).get("position").toString()));
				}*/
				if((""+allList.get(i).get("position")).compareTo("long")==0){
					allList.get(i).put("position", "BUY"); 
				}else if((""+allList.get(i).get("position")).compareTo("short")==0){
					allList.get(i).put("position", "SELL");
				}
				allList.get(i).put("buyDatetime", dt.format(allList.get(i).get("buyDatetime")));
				allList.get(i).put("name", allList.get(i).get("name") +(Integer.parseInt(allList.get(i).get("istest")+"") == 1 ? " (테스트계정)" : ""));
				allList.get(i).put("buyQuantity", df.format(allList.get(i).get("buyQuantity")));
				allList.get(i).put("fee", df.format(allList.get(i).get("fee")));
				//allList.get(i).put("result", df.format(allList.get(i).get("result")));
			}
			try {
				Validation.excelDown(response ,allList, "거래내역" , header , dataNm ,"", sdate+"~"+edate , "");
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectSpotTradeListCnt",in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectSpotTradeList",in);
		model.addAttribute("list", list);
		//model.addAttribute("feeResultSum", sampleDAO.select("selectTradeFeeResultSum",in));
		//model.addAttribute("testFeeResultSum", sampleDAO.select("selectTradeTestFeeResultSum",in));
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
		return "admin/spotTradeList";
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
		//in.put("inverse", CointransService.sqlIsInverseValue(inverse));

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
			ArrayList<EgovMap> allList = (ArrayList<EgovMap>)sampleDAO.list("selectSpotOrderList",in);
			in.put("nolimit", null);
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"시간","회원명","소속 총판","Symbol","주문번호","주문타입","포지션","가격","수량","상태"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"orderDatetime","name","pname","symbol","orderNum","orderType","position","entryPrice","buyQuantity","state"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				if((""+allList.get(i).get("position")).compareTo("long")==0){
					allList.get(i).put("position", "BUY"); 
				}else if((""+allList.get(i).get("position")).compareTo("short")==0){
					allList.get(i).put("position", "SELL");
				}
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

		pi.setTotalRecordCount((int)sampleDAO.select("selectSpotTradeListCnt",in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectSpotOrderList",in);
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
		return "admin/spotOrderList";
	}
}
