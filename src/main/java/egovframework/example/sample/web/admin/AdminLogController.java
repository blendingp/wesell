package egovframework.example.sample.web.admin;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/admin/log")
public class AdminLogController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@RequestMapping(value="/accessLog.do")
	public String followerList(HttpServletRequest request , Model model){
		String pass = request.getParameter("pass");
		EgovMap in = new EgovMap();
		in.put("pass", pass);
		List<EgovMap> accessList = (List<EgovMap>)sampleDAO.list("selectAdminAccessLog" , in);
		
		model.addAttribute("list",accessList);
		model.addAttribute("pass", pass);
		return"admin/accessLog";
	}
	
	@RequestMapping(value="/pointLog.do")
	public String pointLog(HttpServletRequest request , Model model, HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String ltype = request.getParameter("ltype");
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
		in.put("ltype", ltype);
		pi.setTotalRecordCount((int)sampleDAO.select("selectPointLogCnt",in));
		model.addAttribute("list", sampleDAO.list("selectPointLog",in));
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		model.addAttribute("ltype", ltype);
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			in.put("first", null);
			ArrayList<EgovMap> allList = (ArrayList<EgovMap>)sampleDAO.list("selectPointLog",in);
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"UID","이름","등급","보유 Futures","변경 전 Futures","변경 Futures","변경 후 Futures","Symbol","기타","날짜"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"midx","name","level","wallet","bfPoint","point","afPoint","coinType","kind","pdate"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				allList.get(i).put("pdate", dt.format(allList.get(i).get("pdate")));
				allList.get(i).put("wallet", df.format(allList.get(i).get("wallet")));
				allList.get(i).put("bfPoint", df.format(allList.get(i).get("bfPoint")));
				allList.get(i).put("point", df.format(allList.get(i).get("point")));
				allList.get(i).put("afPoint", df.format(allList.get(i).get("afPoint")));
				
				String kind = (""+allList.get(i).get("kind"));
				if(kind.equals("adDeposit")) allList.get(i).put("kind", "Admin 입금");
				else if(kind.equals("adWithdrawal")) allList.get(i).put("kind", "Admin 출금");
			}
			try {
				Validation.excelDown(response ,allList, "USDT(FUTURES) 로그" , header , dataNm ,"", sdate+"~"+edate , "");
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		return "admin/pointLog";
	}
	
	@RequestMapping(value="/coinLog.do")
	public String coinLog(HttpServletRequest request , Model model, HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String coinname = request.getParameter("coin");
		String ltype = request.getParameter("ltype");
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
		in.put("coinname", coinname);
		in.put("ltype", ltype);
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectCoinTransLogCnt",in));
		model.addAttribute("list", sampleDAO.list("selectCoinTransLog",in));
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		model.addAttribute("coinname", coinname);
		model.addAttribute("ltype", ltype);
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			in.put("first", null);
			ArrayList<EgovMap> allList = (ArrayList<EgovMap>)sampleDAO.list("selectCoinTransLog",in);
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"UID","이름","등급","보유 "+coinname,"변경 전 "+coinname,"변경 "+coinname,"변경 후 "+coinname,"Coin","기타","날짜"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"useridx","name","level","balance","before","price","after","coinname","desc","createdate"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				allList.get(i).put("createdate", dt.format(allList.get(i).get("createdate")));
				allList.get(i).put("balance", df.format(allList.get(i).get("balance")));
				allList.get(i).put("before", df.format(allList.get(i).get("before")));
				allList.get(i).put("price", df.format(allList.get(i).get("price")));
				allList.get(i).put("after", df.format(allList.get(i).get("after")));
				
			}
			try {
				Validation.excelDown(response ,allList, coinname+" 로그" , header , dataNm ,"", sdate+"~"+edate , "");
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		return "admin/coinLog";
	}
	
	@RequestMapping(value="/fundingLog.do")
	public String fundingLog(HttpServletRequest request , Model model){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
		String coin = request.getParameter("coin");
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
		if(coin.equals("FUTURES"))
			in.put("coin", coin);
		else
			in.put("coin", coin+"USD");
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectFundingLogCnt",in));
		model.addAttribute("list", sampleDAO.list("selectFundingLog",in));
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		model.addAttribute("fundingFeeSum", sampleDAO.select("selectFundingFeeSum",in));
		model.addAttribute("coin", coin);
		return "admin/fundingLog";
	}
	

	@RequestMapping(value="/log.do")
	public String log(HttpServletRequest request , Model model){
		String search = request.getParameter("search");
		String kind = request.getParameter("kind");
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
		in.put("kind", kind);
		in.put("search", search);
		model.addAttribute("list", sampleDAO.list("selectAdminLogList", in));
		paginationInfo.setTotalRecordCount((int)sampleDAO.select("selectAdminLogListCnt" , in));
		model.addAttribute("pi", paginationInfo);
		model.addAttribute("kind", kind);
		model.addAttribute("search", search);
		return "admin/adminLog";
	}
	
	@RequestMapping(value="/manipullog.do")
	public String tradeList(HttpServletRequest request , Model model, HttpServletResponse response){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String coin = request.getParameter("coin");

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

		pi.setTotalRecordCount((int)sampleDAO.select("selectBalanceListCnt",in));
		ArrayList<EgovMap> list = (ArrayList<EgovMap>)sampleDAO.list("selectBalanceList",in);
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("coin", coin);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		model.addAttribute("project", Project.getPropertieMap());
		return "admin/manipullog";
	}
}
