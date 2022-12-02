package egovframework.example.sample.web.admin;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
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
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.JsonUtil;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.Referral;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.comparator.tradelogComparator;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/referral")
public class AdminReferralController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@RequestMapping(value = "/feeSetting.do")
	public String feeSetting(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		if(!AdminUtil.highAdminCheck(session)){
			return "redirect:/0nI0lMy6jAzAFRVe0DqLOw/main.do";
		}
		
		List<?> list = (List<?>) sampleDAO.list("selectRateRange");
		model.addAttribute("resultList", list);
		return "admin/feeSetting";
	}
	
	@RequestMapping(value = "/giveReferral.do")
	public String giveReferral(HttpServletRequest request, ModelMap model,HttpServletResponse response) throws Exception {
		String search = request.getParameter("search");
		String searchSelect = request.getParameter("searchSelect");

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
		in.put("search", search);

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
		
		pi.setTotalRecordCount((int)sampleDAO.select("selectAcReferralListCnt",in));
		model.addAttribute("list", sampleDAO.list("selectAcReferralList",in));
		model.addAttribute("pi", pi);
		model.addAttribute("project", Project.getPropertieMap());
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("search", search);
		
		EgovMap feeResultSum = (EgovMap)sampleDAO.select("selectAcFeeResultSum",in);
		double accumSum = (double)sampleDAO.select("selectAccumSum",in);
		model.addAttribute("frSum", feeResultSum);
		model.addAttribute("accumSum", accumSum);
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			SimpleDateFormat dt = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.####");
			DecimalFormat df2 = new DecimalFormat("###,###");
			// header : 필드 이름 
			String[] header = {"회원","누적액","받은 금액","마지막 지급일자"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"name","accum","receive","givedate"};
			in.put("limit" , "n");
			in.put("first" , "");
			ArrayList<EgovMap> downList = (ArrayList<EgovMap>)sampleDAO.list("selectAcReferralList",in);
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<downList.size(); i++){
				if(downList.get(i).get("givedate").equals("2000-01-01 00:00:00.0")){
					downList.get(i).put("givedate","지급 기록 없음");
				}
				else{
					downList.get(i).put("givedate", dt.format(downList.get(i).get("givedate")));
				}
				downList.get(i).put("accum", df.format(Double.parseDouble(""+downList.get(i).get("accum"))));
				downList.get(i).put("receive", df.format(Double.parseDouble(""+downList.get(i).get("receive"))));
			}
			double accum = 0;
			double ref = 0;
			String accumt = "";
			String reft = "";
			if(Project.isFeeAccum()){
				accum = Double.parseDouble(feeResultSum.get("resultSum").toString());
				accumt = " 정산 ";
			}
			if(Project.isFeeReferral()){
				ref = Double.parseDouble(feeResultSum.get("feeSum").toString());
				reft = " 수수료 ";
			}
			
			String searchData = "발생된 총 "+accumt+reft+" ( "+accum+ref+" ) "+ "지급해야하는 레퍼럴 누적액 ("+accumSum+") = 거래소 지급 전 "+accumt+reft+"수익금 ("+(accum+ref-accumSum)+")";
			try {
				Validation.excelDown(response ,downList, " 레퍼럴 지급대상 유저 리스트" , header , dataNm ,searchData, "~",null);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return "admin/giveReferral";
	}
	
	@RequestMapping(value = "/giveReferralList.do")
	public String giveReferralList(HttpServletRequest request, ModelMap model,HttpServletResponse response) throws Exception {
		EgovMap in = new EgovMap();
		
		String sdate = request.getParameter("sdate"); 
		String edate = request.getParameter("edate"); 
		String search = request.getParameter("search"); 
		String searchSelect = request.getParameter("searchSelect");
		String gChongs = request.getParameter("gChongs");

		in.put("sdate", sdate);
		in.put("edate", edate);
		in.put("search", search);
		in.put("searchSelect", searchSelect);
		if(search == null || search.isEmpty())
			in.put("userIdx", -1);
		
		ArrayList<EgovMap> underList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_ref",in);
		ArrayList<EgovMap> excelList = new ArrayList<>();
		
		ArrayList<Member> childrenChong = new ArrayList<>();
		JSONObject obj = new JSONObject();
		JSONArray array = new JSONArray();
		if(search == null || search.isEmpty()){
			for(EgovMap map : underList){
				array.add(JsonUtil.convertMapToJson(map));
				excelList.add(map);
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
					excelList.add(map);
				}
				else{
					in.put("self", true);
					in.put("search", null);
					for(Member parent : parents){
						if(parent.getParent() == null){
							in.put("userIdx", parent.userIdx);
							EgovMap topParent = (EgovMap)sampleDAO.select("selectChildByIdxGetParentName_ref",in);
							if(!childrenChong.contains(parent)){
								array.add(JsonUtil.convertMapToJson(topParent));
								excelList.add(topParent);
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
				ArrayList<EgovMap> childTradeList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_ref",in);
				if(childTradeList.size() != 0){
					for(EgovMap map : childTradeList){
						array.add(JsonUtil.convertMapToJson(map));
						excelList.add(map);
					}
				}
			}
		}

		obj.put("array", array);
		
		in.put("search", null);
		in.put("searchSelect", null);
		in.put("userIdx", -1);
		
		EgovMap feeResultSum = (EgovMap)sampleDAO.select("selectAcFeeResultSum",in);
		double accumSum = (double)sampleDAO.select("selectAccumSum",in);
		model.addAttribute("frSum", feeResultSum);
		model.addAttribute("accumSum", accumSum);
		
		ArrayList<EgovMap> gChongList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_ref",in);
		model.addAttribute("gChongs", gChongList);
		model.addAttribute("selectChong", gChongs);
		model.addAttribute("child", obj);
		model.addAttribute("list", underList);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		model.addAttribute("searchSelect", searchSelect);
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			SimpleDateFormat dt = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.####");
			DecimalFormat df2 = new DecimalFormat("###,###");
			// header : 필드 이름 
			String[] header = {"UID","이름","직속 상위","누적액","받은 금액","마지막 지급일자"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"idx","name","pName","accumSum","receiveSum","givedate"};
			in.put("limit" , "n");
			in.put("first" , "");
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			excelList = PublicUtils.sortParentChongList(excelList, "idx");
					
			for(int i=0; i<excelList.size(); i++){
				if(excelList.get(i).get("givedate").equals("2000-01-01 00:00:00.0")){
					excelList.get(i).put("givedate","지급 기록 없음");
				}
				else{
					excelList.get(i).put("givedate", dt.format(excelList.get(i).get("givedate")));
				}
				excelList.get(i).put("accumSum", df.format(Double.parseDouble(""+excelList.get(i).get("accumSum"))));
				excelList.get(i).put("receiveSum", df.format(Double.parseDouble(""+excelList.get(i).get("receiveSum"))));
			}
			double accum = 0;
			double ref = 0;
			String accumt = "";
			String reft = "";
			if(Project.isFeeAccum()){
				accum = Double.parseDouble(feeResultSum.get("resultSum").toString());
				accumt = " 정산 ";
			}
			if(Project.isFeeReferral()){
				ref = Double.parseDouble(feeResultSum.get("feeSum").toString());
				reft = " 수수료 ";
			}
			
			String searchData = "발생된 총 "+accumt+reft+" ( "+(accum+ref)+" ) "+ "지급해야하는 레퍼럴 누적액 ("+accumSum+") = 거래소 지급 전 "+accumt+reft+"수익금 ("+(accum+ref-accumSum)+")";
			try {
				Validation.excelDown(response ,excelList, " 레퍼럴 지급대상 유저 리스트" , header , dataNm ,searchData, "~",null);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return "admin/giveReferralList";
	}
	
	@RequestMapping(value="/accumTradeLog.do")
	public String tradeList(HttpServletRequest request , Model model, HttpServletResponse response){
		String uidx = request.getParameter("uidx");
		String username = request.getParameter("username"); // 멤버디테일 - 전체보기 했을때 유저네임 들어옴
		
		EgovMap in = new EgovMap();
		in.put("uidx", uidx);
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(20);
		
		EgovMap accumInfo = (EgovMap)sampleDAO.select("selectAccumRef",in);
		in.put("all", 1);
		in.put("givedate", accumInfo.get("givedate"));
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		
		ArrayList<EgovMap> tradeList = (ArrayList<EgovMap>)sampleDAO.list("selectAccumTradeLogList",in);
		pi.setTotalRecordCount((int)sampleDAO.select("selectAccumTradeLogListCnt",in));
		model.addAttribute("accumInfo", accumInfo);
		model.addAttribute("list", tradeList);
		model.addAttribute("pi", pi);
		model.addAttribute("uidx", uidx);
		model.addAttribute("username", username);
		model.addAttribute("Project",Project.getPropertieMap());
		
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			SimpleDateFormat dt = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.####");
			DecimalFormat df2 = new DecimalFormat("###,###");
			// header : 필드 이름 
			String[] header = {"시간","회원명","SYMBOL","주문번호","주문타입","포지션","가격","수량","레버리지","수수료","정산액","유저 누적","관리자 누적","지급여부"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"buyDatetime","name","symbol","orderNum","orderType","position","entryPrice","buyQuantity","leverage","fee", "result", "allot", "adminProfit","isGive"};
			in.put("limit" , "n");
			in.put("first" , "");
			ArrayList<EgovMap> downList = (ArrayList<EgovMap>)sampleDAO.list("selectAccumTradeLogList",in);
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<downList.size(); i++){
				downList.get(i).put("buyDatetime", dt.format(downList.get(i).get("buyDatetime")));
				downList.get(i).put("isGive", (""+downList.get(i).get("isGive")).equals("1") ? "지급":"미지급");
				downList.get(i).put("entryPrice", df.format(Double.parseDouble(""+downList.get(i).get("entryPrice"))));
				downList.get(i).put("buyQuantity", df.format(Double.parseDouble(""+downList.get(i).get("buyQuantity"))));
				downList.get(i).put("fee", df.format(Double.parseDouble(""+downList.get(i).get("fee"))));
				downList.get(i).put("result", df.format(Double.parseDouble(""+downList.get(i).get("result"))));
				downList.get(i).put("allot", df.format(Double.parseDouble(""+downList.get(i).get("allot"))));
				downList.get(i).put("adminProfit", df.format(Double.parseDouble(""+downList.get(i).get("adminProfit"))));
				try {
					if(!Boolean.parseBoolean(downList.get(i).get("isOpen").toString())){
						if((""+downList.get(i).get("position")).equals("long"))
							downList.get(i).put("position", "short");
						else
							downList.get(i).put("position", "long");
					}else{
						downList.get(i).put("result", "오픈");
					}
					
				} catch (Exception e) {
					System.out.println(downList.get(i));
				}
			}
			String searchData = "지급 정산액 :"+df2.format(accumInfo.get("accum"))+" 지급누적액: "+df2.format(accumInfo.get("receive"));
			try {
				Validation.excelDown(response ,downList, username+" 하위 누적 거래내역" , header , dataNm ,searchData, "~",null);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return "admin/accumTradeLog";
	}
	
	
	
	public void sortUpTimeTradelist(ArrayList<EgovMap> list){
    	Collections.sort(list, new tradelogComparator());
    }
    
	@ResponseBody
	@RequestMapping(value="/accumReferralGift.do" , produces="application/json; charset=utf8")
	public String accumReferralGift(HttpServletRequest request){
		int uidx = Integer.parseInt(request.getParameter("uidx"));
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		Referral ref = new Referral();
		if(!ref.giveAccum(sampleDAO, request, uidx)){
			obj.put("msg", "지급할 누적액이 없습니다.");
			return obj.toJSONString();
		}
		
		EgovMap accumRef = (EgovMap)sampleDAO.select("selectAccumRef",uidx);
		obj.put("givedate", ""+accumRef.get("givedate"));
		obj.put("accumSum", ""+accumRef.get("accumSum"));
		obj.put("receiveSum", ""+accumRef.get("receiveSum"));
		
		obj.put("result", "suc");
		obj.put("msg", "지급완료되었습니다. 최대 10초 뒤 새로고침 이후 확인해 주세요.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/accumReferralGift_top.do" , produces="application/json; charset=utf8")
	public String accumReferralGift_top(HttpServletRequest request){
		int uidx = Integer.parseInt(request.getParameter("uidx"));
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		Referral ref = new Referral();
		Member gMem = ref.giveAccum_top(sampleDAO, request, uidx);
		if(gMem == null){
			obj.put("msg", "지급할 누적액이 없습니다.");
			return obj.toJSONString();
		}
		
		EgovMap accumRef = (EgovMap)sampleDAO.select("selectAccumRef",uidx);
		obj.put("givedate", ""+accumRef.get("givedate"));
		obj.put("accumSum", ""+accumRef.get("accumSum"));
		obj.put("receiveSum", ""+accumRef.get("receiveSum"));
		
		
		obj.put("result", "suc");
		obj.put("msg", "지급완료되었습니다. 최대 10초 뒤 새로고침 이후 확인해 주세요.");
		return obj.toJSONString();
	}
}
