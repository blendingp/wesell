package egovframework.example.sample.web.admin;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/admin/account")
public class AdminVirtualAccountController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;

	@RequestMapping(value = "/showFee.do")
	public String showFee(HttpServletRequest request, ModelMap model) throws Exception {
		String coinname = request.getParameter("coinname");
		EgovMap in = new EgovMap();
		in.put("coinname", coinname);
		EgovMap ed = (EgovMap) sampleDAO.select("selectFee", in);		
		model.addAttribute("item", ed);
		model.addAttribute("coinname", coinname);
		return "admin/fee";
	}

	@RequestMapping(value = "/showDepositFee.do")
	public String showDepositFee(HttpServletRequest request, ModelMap model) throws Exception {
		String coinname = request.getParameter("coinname");
		EgovMap in = new EgovMap();
		in.put("coinname", coinname);
		EgovMap ed = (EgovMap) sampleDAO.select("selectDepositFee", in);		
		model.addAttribute("item", ed);
		model.addAttribute("coinname", coinname);
		return "admin/depositFee";
	}
	
	@RequestMapping(value = "/updateFee.do")
	public String updateFee(HttpServletRequest request, ModelMap model) throws Exception {
		String coinname = request.getParameter("coinname");
		EgovMap ed = (EgovMap) sampleDAO.select("selectFee", coinname);	
		String fee = request.getParameter("fee");
		double prevFee = Double.parseDouble(ed.get("fee").toString());
		EgovMap in = new EgovMap();
		in.put("coinname", coinname);
		in.put("fee", fee);
		sampleDAO.update("updateFee",in);		
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_WFEE, -1, coinname, 1, fee, prevFee+" -> "+fee);
		return "redirect:/admin/account/showFee.do?coinname="+coinname;
	}
	@RequestMapping(value = "/updateDepositFee.do")
	public String updateDepositFee(HttpServletRequest request, ModelMap model) throws Exception {
		String coinname = request.getParameter("coinname");
		EgovMap ed = (EgovMap) sampleDAO.select("selectFee", coinname);	
		double prevFee = Double.parseDouble(ed.get("fee").toString());
		String fee = request.getParameter("fee");
		EgovMap in = new EgovMap();
		in.put("coinname", coinname);
		in.put("fee", fee);
		sampleDAO.update("updateDepositFee",in);		
		HttpSession session = request.getSession();
		Integer aidx = Integer.parseInt(session.getAttribute("adminIdx")+"");
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_DFEE, -1, coinname, 1, fee, prevFee+" -> "+fee);
		return "redirect:/admin/account/showDepositFee.do?coinname="+coinname;
	}
	
	//real balance 로그
	@RequestMapping(value="/realBalanceLog.do")
	public String realBalanceLog(HttpServletRequest request , Model model){
		/*String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");*/
		String kind = request.getParameter("kind");
		String useridx = request.getParameter("useridx");
		model.addAttribute("kind", kind);
		model.addAttribute("useridx", useridx);
//		if(kind.compareTo("0")==0)//일반
			kind = "cointranslog";
//		else//real
//			kind = "coinrealtranslog";
		
		String coinname = request.getParameter("coinname");
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
		in.put("coinname", coinname);
		in.put("kind", kind);
		in.put("useridx", useridx);
		/*in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("search", search);*/
		pi.setTotalRecordCount((int)sampleDAO.select("selectRealBalanceLogpCnt",in));
		model.addAttribute("list", sampleDAO.list("selectRealBalanceLogp",in));
		model.addAttribute("pi", pi);
		model.addAttribute("coinname", coinname);
		
		/*model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);*/
		return "admin/realBalanceLog";
	}
	
	//balance 로그
	@RequestMapping(value="/balanceLog.do")
	public String balanceLog(HttpServletRequest request , Model model){
		/*String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");*/
		String coinname = request.getParameter("coinname");
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
		in.put("coinname", coinname);
		/*in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("search", search);*/
		pi.setTotalRecordCount((int)sampleDAO.select("selectRealBalancepCnt",in));
		model.addAttribute("list", sampleDAO.list("selectRealBalancep",in));
		model.addAttribute("pi", pi);
		model.addAttribute("coinname", coinname);
		/*model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);*/
		return "admin/realBalance";
	}
	
	//balance 로그 + point 로그
	@RequestMapping(value="/totalLog.do")
	public String totalLog(HttpServletRequest request , Model model){
		String userIdx = request.getParameter("userIdx");
		/*String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");*/
		//String coinname = request.getParameter("coinname");
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
		in.put("userIdx", userIdx);
		//in.put("coinname", coinname);
		/*in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("search", search);*/
		pi.setTotalRecordCount((int)sampleDAO.select("selectTotalBalanceCnt",in));
		model.addAttribute("list", sampleDAO.list("selectTotalBalance",in));
		model.addAttribute("pi", pi);		
		model.addAttribute("userIdx", userIdx);
		/*model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);*/
		return "admin/totaLog";
	}	
}
