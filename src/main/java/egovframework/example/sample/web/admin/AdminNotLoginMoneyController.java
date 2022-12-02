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
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/trade")
public class AdminNotLoginMoneyController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	// 입금신청 목록
	@RequestMapping(value="/notLoginKWithdrawalList.do")
	public String notLoginKWithdrawalList(HttpServletRequest request , Model model ,HttpServletResponse response){
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
		
		pi.setTotalRecordCount((int)sampleDAO.select("notloginSelectKwithdrawalListCnt",in));
		model.addAttribute("list", sampleDAO.list("notloginSelectKwithdrawalList",in));
		EgovMap allout = (EgovMap)sampleDAO.select("notloginDepoalloutmoneys",in);
		model.addAttribute("alloutmoneys",allout);
		EgovMap allin = (EgovMap)sampleDAO.select("notloginDepoallinmoneys",in);
		
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
			List<EgovMap> sendList = (List<EgovMap>)sampleDAO.list("notloginSelectKwithdrawalList",in);
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
		return "admin/notLoginKWithdrawalList";
	}
	//입금승인
	@ResponseBody
	@RequestMapping(value="/notLoginKWithdrawalProcess.do", method = RequestMethod.POST ,produces = "application/json; charset=utf8")
	public String notLoginKWithdrawalProcess(HttpServletRequest request , Model model){
		JSONObject obj = new JSONObject();
		String widx = request.getParameter("widx");
		String stat = request.getParameter("stat");//0대기 1승인 2거부 3취소
		EgovMap in = new EgovMap();
		in.put("widx", widx);
		in.put("stat", stat);
		
		// 데이터 갱신 
		sampleDAO.update("updateNotloginMoneyStat", in);
		obj.put("result","ok");
		return obj.toJSONString();
	}
	
}
