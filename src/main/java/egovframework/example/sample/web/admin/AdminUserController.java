package egovframework.example.sample.web.admin;

import java.io.File;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.example.sample.classes.AdminUtil;
import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.JsonUtil;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.ServerInfo;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.comparator.joinDateComparator;
import egovframework.example.sample.comparator.walletComparator;
import egovframework.example.sample.enums.AdminLog;
import egovframework.example.sample.enums.MemberInfo;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Send;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw/user")
public class AdminUserController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;
	
	@Resource(name="messageSource")
    MessageSource messageSource;
	
	@ResponseBody
	@RequestMapping(value="/setKrCode.do" , produces="application/json; charset=utf8")
	public String setKrCode(HttpServletRequest request){
		String idx = request.getParameter("idx");
		JSONObject obj = new JSONObject();
		Member member = Member.getMemberByIdx(Integer.parseInt(idx));
		member.setKrCode(!member.isKrCode, sampleDAO);
		obj.put("msg", "변경완료되었습니다.");
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value="/changeJstat.do" , produces="application/json; charset=utf8")
	public String changeJstat(HttpServletRequest request){
		String idx = request.getParameter("idx");
		String jstat = request.getParameter("jstat");
		JSONObject obj = new JSONObject();
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		in.put("jstat", jstat);
		sampleDAO.update("updateUserJstat" , in);
		Member member = Member.getMemberByIdx(Integer.parseInt(idx));
		member.jstat = Integer.parseInt(jstat);
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_JSTAT, member.userIdx, null, member.jstat, null, null);
		obj.put("msg", "변경완료되었습니다.");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/createChong.do")
	public String createChong(){
		return "admin/createChong";
	}
	@ResponseBody
	@RequestMapping(value="/insertChong.do" , produces="application/json; charset=utf8")
	public String insertChong(HttpServletRequest request){
		String inviteCode = request.getParameter("code"); // 초대코드
		String country = "82"; // 국가
		String phone = request.getParameter("phone"); // 전화번호
		String id = request.getParameter("id"); // 전화번호
		String name = request.getParameter("name"); // 이름
		String pw = request.getParameter("pw"); // pw
		String level = request.getParameter("level");
		String email = request.getParameter("email");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(phone == null || phone.equals("") || phone.length() > 20){
			obj.put("msg", "연락처를 입력해주세요.");
			return obj.toJSONString();
		}
		if(email == null || email.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", "이메일을 입력해주세요");
			return obj.toJSONString();
		}
		if(!Validation.isValidEmail(email) && email.length() > 50){
			obj.put("result", "fail");
			obj.put("msg", "이메일 형식이 올바르지않습니다.");
			return obj.toJSONString();
		}
		if(name == null || name.equals("")){
			obj.put("msg", "이름을 입력해주세요.");
			return obj.toJSONString();
		}
		if(pw == null || pw.equals("") || pw.length() > 30){
			obj.put("msg", "비밀번호를 입력해주세요.");
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("country", country);
		in.put("phone", phone);
		in.put("id", id);
		in.put("jstat", "1");
		EgovMap info = (EgovMap)sampleDAO.select("selectIsMemberPhoneOrID" , in);
		if(info != null){
			if((""+info.get("phone")).equals(phone))
				obj.put("msg", "이미 가입된 전화번호입니다.");
			else
				obj.put("msg", "이미 가입된 아이디입니다.");
				
			return obj.toJSONString();
		}else{
			in.put("parentsIdx", -1);   // 추천인 -1
			if(inviteCode.equals(Project.getProjectName()) || inviteCode == null || inviteCode.equals("")){ // 관리자코드
				in.put("parentsIdx", -1);   // 추천인 -1
//				in.put("gparentsIdx", -1);   // 추천인 -1
			}else if(inviteCode != null && !inviteCode.equals("")) {
				in.put("inviteCode", inviteCode);
				//부모를 찾는다
				EgovMap parents = (EgovMap)sampleDAO.select("selectMemberByAdminInvitationCode", in);
				if (parents == null) {
					obj.put("msg", "유효하지 않은 초대코드입니다");
					return obj.toJSONString();
				}
				String plevel = ""+parents.get("level");
				in.put("parentsIdx", ""+parents.get("idx"));
				if(plevel.compareTo("chong")==0){
					//총판인 할아버지를 찾는다 
//					String gIdx = ""+parents.get("parentsIdx");
//					EgovMap ing = new EgovMap();
//					ing.put("userIdx", gIdx);
//					EgovMap gparents = (EgovMap)sampleDAO.select("getGrandParents", ing);
//					if(gparents != null){
//						String glevel = ""+parents.get("level");
//						if(glevel.compareTo("chong")==0)
//							in.put("gparentsIdx", gparents.get("idx"));
//					}
				}
			}
		}
		in.put("name", name);
		in.put("pw", pw);
		in.put("level", level);
		in.put("wallet", "0");
		in.put("istest", "0");
		in.put("email", email);
		in.put("joinKind", "setemail");
//		String invi = Validation.getTempPassword(3);
		String invi = Validation.getTempNumber(3);
		in.put("inviteCode", invi);
		Project.putDefAddress(in);
		
		//defaultAddress projectsetting 에서 불러와서 삽입
		int userIdx = (int)sampleDAO.insert("insertMemberNoWallet", in);
		invi = invi + userIdx;
		in.put("invi", invi);
		in.put("userIdx", userIdx);
		String destinationTag = Validation.getTempNumber(3)+userIdx;
		in.put("destinationTag", destinationTag);
		sampleDAO.update("updateInviteCode",in);
		
		CointransService.createBalance(""+userIdx, "USDT");
		
		AdminUtil.insertAdminLog(request,sampleDAO, AdminLog.INSERT_CHONG, userIdx,null, 1, null, null);
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/createTestUser.do")
	public String createTestUser(){
		return "admin/createTestUser";
	}
	
	@ResponseBody
	@RequestMapping(value="/insertTestUser.do" , produces="application/json; charset=utf8")
	public String insertTestUser(HttpServletRequest request){
		String inviteCode = request.getParameter("code"); // 초대코드
		String country = "82"; // 국가
		String phone = request.getParameter("phone"); // 전화번호
		String id = request.getParameter("id"); // 전화번호
		String name = request.getParameter("name"); // 이름
		String pw = request.getParameter("pw"); // pw
		String level = request.getParameter("level");
		String istest = request.getParameter("isTest");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(phone == null || phone.equals("") || phone.length() > 20){
			obj.put("msg", "연락처를 입력해주세요.");
			return obj.toJSONString();
		}
		if(name == null || name.equals("")){
			obj.put("msg", "이름을 입력해주세요.");
			return obj.toJSONString();
		}
		if(pw == null || pw.equals("") || pw.length() > 30){
			obj.put("msg", "비밀번호를 입력해주세요.");
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("country", country);
		in.put("phone", phone);
		in.put("id", id);
		in.put("jstat", "1");
		EgovMap info = (EgovMap)sampleDAO.select("selectIsMemberPhoneOrID" , in);
		if(info != null){
			if((""+info.get("phone")).equals(phone))
				obj.put("msg", "이미 가입된 전화번호입니다.");
			else
				obj.put("msg", "이미 가입된 아이디입니다.");
				
			return obj.toJSONString();
		}else{
			in.put("parentsIdx", -1);   // 추천인 -1
			if(inviteCode.equals(Project.getProjectName()) || inviteCode == null || inviteCode.equals("")){ // 관리자코드
				in.put("parentsIdx", -1);   // 추천인 -1
//				in.put("gparentsIdx", -1);   // 추천인 -1
			}else if(inviteCode != null && !inviteCode.equals("")) {
				in.put("inviteCode", inviteCode);
				//부모를 찾는다
				EgovMap parents = (EgovMap)sampleDAO.select("selectMemberByAdminInvitationCode", in);
				if (parents == null) {
					obj.put("msg", "유효하지 않은 초대코드입니다");
					return obj.toJSONString();
				}
				String plevel = ""+parents.get("level");
				in.put("parentsIdx", ""+parents.get("idx"));
				if(plevel.compareTo("chong")==0){
					//총판인 할아버지를 찾는다 
					String gIdx = ""+parents.get("parentsIdx");
					EgovMap ing = new EgovMap();
					ing.put("userIdx", gIdx);
				}
			}
		}
		in.put("name", name);
		in.put("pw", pw);
		in.put("level", level);
		in.put("wallet", "0");
		in.put("istest", istest);
//		String invi = Validation.getTempPassword(3);
		String invi = Validation.getTempNumber(3);
		in.put("inviteCode", invi);
		Project.putDefAddress(in);
		int userIdx = (int)sampleDAO.insert("insertMemberNoWallet", in);
		invi = invi + userIdx;
		in.put("invi", invi);
		in.put("userIdx", userIdx);
		String destinationTag = Validation.getTempNumber(3)+userIdx;
		in.put("destinationTag", destinationTag);
		sampleDAO.update("updateInviteCode",in);
		
		CointransService.createBalance(""+userIdx, "USDT");
		
		AdminLog kind;
		if(istest.equals("0")){
			if(level.equals("chong"))
				kind = AdminLog.INSERT_CHONG;
			else
				kind = AdminLog.INSERT_USER;
		}else{
			if(level.equals("chong"))
				kind = AdminLog.INSERT_TESTCHONG;
			else
				kind = AdminLog.INSERT_TESTUSER;
		}
		
		AdminUtil.insertAdminLog(request,sampleDAO, kind, userIdx,null, 1, null, null);
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/userList.do")
	public String userList(HttpServletRequest request , Model model, HttpServletResponse response){
		String search = request.getParameter("search");
		String level = request.getParameter("level");
		String partnerLevel = request.getParameter("partnerLevel");
		String searchSelect = request.getParameter("searchSelect");
		String searchColor = request.getParameter("searchColor");
		String order = request.getParameter("order");
		String orderAD = request.getParameter("orderAD");
		String test = request.getParameter("test");
		String out = request.getParameter("out");
		String ban = request.getParameter("ban");

		if(order==null || order.compareTo("")==0){
			order = "joinDate";
			orderAD = "desc";
		}
		
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
		in.put("level", level);
		in.put("partnerLevel", partnerLevel);
		in.put("order", "m."+order);
		in.put("orderAD", orderAD);
		in.put("test", test);
		in.put("out", out);
		in.put("searchColor", searchColor);
		in.put("ban", ban);
		
		EgovMap parentsUser = null;
		if(searchSelect == null || searchSelect.compareTo("") == 0){
			searchSelect = "name";
		}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
			if(search.startsWith("00") && search.split("00").length != 1){
				in.put("search", search.split("00")[1]);
			}
		}else if(searchSelect.compareTo("inviteMem")==0 && search.length() > 0 ||
				searchSelect.compareTo("inviteMemAll")==0 && search.length() > 0 ){
			in.put("inviteCode",search);
			parentsUser = (EgovMap)sampleDAO.select("selectMemberByInvitationCodeSearch",in);
			int pidx = -100;
			if(parentsUser!=null){
				pidx = (int)parentsUser.get("idx");
			}
			in.put("parentsIdx", pidx);
		}
		in.put("searchSelect",searchSelect);
		
		if(searchSelect.compareTo("inviteMem")==0 && search.length() > 0){
			pi.setTotalRecordCount((int)sampleDAO.select("selectParentsInMemberListCnt",in));
			model.addAttribute("list", sampleDAO.list("selectParentsInMemberList",in));
		}else if(searchSelect.compareTo("inviteMemAll")==0 && search.length() > 0){
			in.put("first", null);
			ArrayList<EgovMap> mlist = (ArrayList<EgovMap>)sampleDAO.list("selectParentsInMemberList",in);
			if(mlist.size() != 0){
				mlist = getChildren(mlist,in);
			}
			if(order.equals("joinDate")){
				if(orderAD.equals("desc"))
					sortUpJoinlist(mlist);
				else
					sortDownJoinlist(mlist);
			}else if(order.equals("wallet")){
				if(orderAD.equals("desc"))
					sortUpWalletlist(mlist);
				else
					sortDownWalletlist(mlist);
			}
			
			ArrayList<EgovMap> resultList = new ArrayList<>();
			for(int i = 0; i < pi.getRecordCountPerPage(); i++){
				int first = pi.getFirstRecordIndex()+i;
				if(first == mlist.size())
					break;
				resultList.add(mlist.get(first));
			}
			pi.setTotalRecordCount(mlist.size());
			model.addAttribute("list", resultList);
			
		}else{
			pi.setTotalRecordCount((int)sampleDAO.select("selectMemberListCnt",in));
			in.put("searchSelect","m."+searchSelect);
			model.addAttribute("list", sampleDAO.list("selectMemberList",in));
		}
		model.addAttribute("pi", pi);
		model.addAttribute("search", search);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("level", level);
		model.addAttribute("partnerLevel", partnerLevel);
		model.addAttribute("order", order);
		model.addAttribute("orderAD", orderAD);
		model.addAttribute("test", test);
		model.addAttribute("out", out);
		model.addAttribute("ban", ban);
		model.addAttribute("searchColor", searchColor);
		model.addAttribute("project", Project.getPropertieMap());
		model.addAttribute("colorList", sampleDAO.list("selectUserColorList" ,in));
		
		String fileDown = request.getParameter("fileDown");
		if(fileDown != null && !fileDown.equals("0") && !fileDown.equals("")){
			in.put("first", null);
			ArrayList<EgovMap> allList = null;
			
			if(searchSelect.compareTo("inviteMem")==0 && search.length() > 0){
				allList = (ArrayList<EgovMap>)sampleDAO.list("selectParentsInMemberList",in);
			}else if(searchSelect.compareTo("inviteMemAll")==0 && search.length() > 0){
				in.put("first", null);
				ArrayList<EgovMap> mlist = (ArrayList<EgovMap>)sampleDAO.list("selectParentsInMemberList",in);
				if(mlist.size() != 0){
					mlist = getChildren(mlist,in);
				}
				if(order.equals("joinDate")){
					if(orderAD.equals("desc"))
						sortUpJoinlist(mlist);
					else
						sortDownJoinlist(mlist);
				}else if(order.equals("wallet")){
					if(orderAD.equals("desc"))
						sortUpWalletlist(mlist);
					else
						sortDownWalletlist(mlist);
				}
				
				ArrayList<EgovMap> resultList = new ArrayList<>();
				for(int i = 0; i < pi.getRecordCountPerPage(); i++){
					int first = pi.getFirstRecordIndex()+i;
					if(first == mlist.size())
						break;
					resultList.add(mlist.get(first));
				}
				allList = resultList;
				
			}else{
				in.put("searchSelect","m."+searchSelect);
				allList = (ArrayList<EgovMap>)sampleDAO.list("selectMemberList",in);
			}
			
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat df = new DecimalFormat("###,###.########");
			// header : 필드 이름 
			String[] header = {"UID","이름(부모)","번호","등급","포인트","가입날짜","KYC인증"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"idx","name","phone","level","wallet","joinDate","isKYC"};
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			for(int i=0; i<allList.size(); i++){
				allList.get(i).put("joinDate", dt.format(allList.get(i).get("joinDate")));
				String phone = ""+allList.get(i).get("phone");
				if(phone.length() >= 11)
					allList.get(i).put("phone", phone.substring(0,3)+"****"+phone.substring(7,11));
				allList.get(i).put("name", allList.get(i).get("name")+"("+allList.get(i).get("parent")+")" +(Integer.parseInt(allList.get(i).get("istest")+"") == 1 ? " (테스트계정)" : ""));
				allList.get(i).put("wallet", df.format(allList.get(i).get("wallet")));
				allList.get(i).put("isKYC", ((allList.get(i).get("confirm")+"").equals("true") ? "승인" : "미승인")+(allList.get(i).get("fkey") == null ? "(미등록)" : "(등록)"));
			}
			try {
				Validation.excelDown(response ,allList, "회원 목록" , header , dataNm ,"", "" , "");
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		return "admin/userList";
	}
	
	@RequestMapping(value="/chongList.do")
	public String chongList(HttpServletRequest request , Model model, HttpServletResponse response){
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
		
		ArrayList<EgovMap> underList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_chong",in);
		ArrayList<EgovMap> excelList= new ArrayList<>();
		
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
							EgovMap topParent = (EgovMap)sampleDAO.select("selectChildByIdxGetParentName_chong",in);
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
				ArrayList<EgovMap> childTradeList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_chong",in);
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
		
		ArrayList<EgovMap> gChongList = (ArrayList<EgovMap>)sampleDAO.list("selectChildByIdxGetParentName_chong",in);
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
			String[] header = {"UID","총판","직속 상위","총 유저","KYC 인증완료 유저","현재자산 여부","레퍼럴 누적액"};
			// dataNm 데이터 가져올 이름 
			String[] dataNm = {"idx","name","pName","childCnt","kycCnt","walletCnt","accumSum"};
			in.put("limit" , "n");
			in.put("first" , "");
			// 이곳에서 리스트 데이터 수정할 부분 적용 
			excelList = PublicUtils.sortParentChongList(excelList, "idx");
			
			for(int i=0; i<excelList.size(); i++){
				excelList.get(i).put("accumSum", df.format(Double.parseDouble(""+excelList.get(i).get("accumSum"))));
			}
			try {
				Validation.excelDown(response ,excelList, " 총판 관리" , header , dataNm ,"",sdate+"~"+edate,null);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return "admin/chongList";
	}
	
	public ArrayList<EgovMap> getChildren(ArrayList<EgovMap> mlist ,EgovMap in){
		ArrayList<EgovMap> children = new ArrayList<>();
		for(EgovMap m : mlist){
			children.add(m);
			if(m.get("level").toString().equals("chong")){
				in.put("parentsIdx", m.get("idx"));
				ArrayList<EgovMap> childList = (ArrayList<EgovMap>)sampleDAO.list("selectParentsInMemberList",in);
				children.addAll(getChildren(childList,in));
			}
		}
		return children;
	}
	
	public void sortUpJoinlist(ArrayList<EgovMap> list){
    	Collections.sort(list, new joinDateComparator());
    }
	public void sortDownJoinlist(ArrayList<EgovMap> list){
    	Collections.sort(list,Collections.reverseOrder(new joinDateComparator()));
    }
	public void sortUpWalletlist(ArrayList<EgovMap> list){
    	Collections.sort(list, new walletComparator());
    }
	public void sortDownWalletlist(ArrayList<EgovMap> list){
		Collections.sort(list,Collections.reverseOrder(new walletComparator()));
	}
	
	@RequestMapping(value="/walletList.do")
	public String walletList(HttpServletRequest request , Model model){
		String search = request.getParameter("search");
		String searchSelect = request.getParameter("searchSelect");
		String test = request.getParameter("test");
		String level = request.getParameter("level");

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
		in.put("test", test);
		in.put("level", level);
		in.put("ignorePhone", "-1");
		
		EgovMap parentsUser = null;
		if(searchSelect == null || searchSelect.compareTo("") == 0){
			searchSelect = "name";
		}else if(searchSelect.compareTo("idx")==0 && search.length() > 2){
			if(search.split("00").length != 1){
				in.put("search", search.split("00")[1]);
			}
		}else if(searchSelect.compareTo("inviteMem")==0 || searchSelect.compareTo("inviteMemAll")==0 && search.length() > 0){
			in.put("inviteCode",search);
			parentsUser = (EgovMap)sampleDAO.select("selectMemberByInvitationCodeSearch",in);
			int pidx = -100;
			if(parentsUser!=null){
				pidx = (int)parentsUser.get("idx");
			}
			in.put("parentsIdx", pidx);
		}
		in.put("searchSelect",searchSelect);
		
		if(searchSelect.compareTo("inviteMem")==0 && search.length() > 0){
			pi.setTotalRecordCount((int)sampleDAO.select("selectParentsInMemberListCnt",in));
			model.addAttribute("list", sampleDAO.list("selectParentsInMemberList",in));
		}else if(searchSelect.compareTo("inviteMemAll")==0 && search.length() > 0){
			in.put("first", null);
			ArrayList<EgovMap> mlist = (ArrayList<EgovMap>)sampleDAO.list("selectParentsInMemberList",in);
			if(mlist.size() != 0){
				mlist = getChildren(mlist,in);
			}
			
			ArrayList<EgovMap> resultList = new ArrayList<>();
			for(int i = 0; i < pi.getRecordCountPerPage(); i++){
				int first = pi.getFirstRecordIndex()+i;
				if(first == mlist.size())
					break;
				resultList.add(mlist.get(first));
			}
			pi.setTotalRecordCount(mlist.size());
			model.addAttribute("list", resultList);
			
		}else{
			pi.setTotalRecordCount((int)sampleDAO.select("selectMemberListCnt",in));
			in.put("searchSelect","m."+searchSelect);
			model.addAttribute("list", sampleDAO.list("selectMemberList",in));
		}
		model.addAttribute("pi", pi);
		model.addAttribute("search", search);
		model.addAttribute("searchSelect", searchSelect);
		model.addAttribute("test", test);
		model.addAttribute("level", level);
		return "admin/walletList";
	}
	
	@RequestMapping(value="/userDetail.do")
	public String userDetail(HttpServletRequest request , Model model){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberDetail",idx);
		String userLevel = ""+info.get("level");
		EgovMap inlevel = new EgovMap();
		inlevel.put("userLevel", userLevel);
	
		
		EgovMap in = new EgovMap();		
		model.addAttribute("info", info);
		model.addAttribute("plus", "+");
		model.addAttribute("minus", "-");
		
		in.put("useridx", idx);
		
		in.put("label", "+");
		in.put("from", idx);
		in.put("to", idx);
//		model.addAttribute("transactionDList",sampleDAO.list("selectMem30Transactions",in));
		in.put("label", "-");
		in.put("from", 1);
		in.put("to", idx);
//		model.addAttribute("transactionWList",sampleDAO.list("selectMem30Transactions",in));
//		model.addAttribute("tradeList",sampleDAO.list("selectMem30TradeList",in));
		String pidx = ""+info.get("parentsIdx");
		EgovMap pinfo = (EgovMap) sampleDAO.select("selectMemberByIdx", pidx);
		if(pidx.equals("-1") || pidx.equals("null") || pidx.isEmpty()) {
			String gidx = ""+info.get("gparentsIdx");
			if(gidx.equals("-1") || gidx.equals("null") || gidx.isEmpty()) {
				gidx = "1";
			}
		}
		
		Member mem = Member.getMemberByIdx(idx);
		ArrayList<Member> parents = Member.getParents(mem);
		ArrayList<EgovMap> parentsMap = new ArrayList<>();
		for(int i = parents.size()-1; i >= 0; i--){
			EgovMap p = new EgovMap();
			p.put("name",parents.get(i).getName());
			p.put("level",parents.get(i).getLevel());
			p.put("userIdx",parents.get(i).userIdx);
			parentsMap.add(p);
		}
		
		EgovMap coinWallet = new EgovMap();
		coinWallet.put("USDT", mem.getWalletC("USDT"));
		for(Coin coin : Project.getUseCoinList()){
			coinWallet.put(coin.coinName, mem.getWalletC(coin.coinName));
		}//coinWallet jsp에서 잔액 뿌리기
		
		model.addAttribute("chongs",Member.getMemberListMapToLevel("chong"));
		model.addAttribute("parents", parentsMap);
		model.addAttribute("pinfo", pinfo);
		model.addAttribute("useCoin", Project.getUseCoinNames());
		model.addAttribute("coinWallet", coinWallet);
		model.addAttribute("project", Project.getPropertieMap());
		model.addAttribute("xrpAccount",sampleDAO.select("selectXrpAccount"));
		model.addAttribute("project",Project.getPropertieMap());
		return "admin/userDetail";
	}		
	
	@ResponseBody
	@RequestMapping(value="/userDanger.do" , produces = "application/json; charset=utf8")
	public String userDanger(HttpServletRequest request){
		String idx = request.getParameter("idx");
		String danger = request.getParameter("danger");
		String dmoney = request.getParameter("dmoney");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(Integer.parseInt(danger) == 1){
			if(dmoney == null || dmoney.equals("")){
				obj.put("msg", "주의 알림 금액을 입력해주세요");
				return obj.toJSONString();
			}
			if(Integer.parseInt(dmoney) <= 0){
				obj.put("msg", "주의 알림 금액은 0원이상 입력해주세요");
				return obj.toJSONString();
			}
		}else{
			dmoney = "0";
		}
		
		Member m = Member.getMemberByIdx(Integer.parseInt(idx));
		m.setDanger(Double.parseDouble(dmoney), sampleDAO);
		obj.put("result", "success");
		obj.put("msg", "완료되었습니다");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/updatePoint.do" , produces = "application/json; charset=utf8")
	public String updatePoint(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		String point = request.getParameter("point");
		String kind = request.getParameter("kind");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		HttpSession session = request.getSession();
		if(!AdminUtil.highAdminCheck(session)){
			obj.put("msg", "요청을 실패했습니다.");
			return obj.toJSONString();
		}
		
		if(point == null || point.isEmpty() || point.equals("0")){
			obj.put("msg", "포인트를 입력해주세요.");
			return obj.toJSONString();
		}
		Member member = Member.getMemberByIdx(idx);
		double bfPoint = member.getWallet();
		double afPoint = 0;
		double changeamount = Double.parseDouble(point);
		String k = "adDeposit";
		if(kind.equals("+")){
			afPoint = bfPoint + Double.parseDouble(point);
		}else{
			afPoint = bfPoint - Double.parseDouble(point);
			changeamount = changeamount*-1;
			k = "adWithdrawal";			
			if(afPoint < 0){
				obj.put("msg", "회수할 포인트가 부족합니다.");
				return obj.toJSONString();
			}
		}
		Wallet.updateWallet(member, afPoint, changeamount, "futures", kind, k);
		AdminUtil.insertAdminLog(request,sampleDAO, AdminLog.UPDATE_POINT, member.userIdx,null, 1, ""+changeamount, bfPoint+" -> "+afPoint);
		obj.put("result", "success");
		obj.put("msg", "완료되었습니다. 약 20초 후 갱신 표기됩니다. 새로고침해서 확인하세요");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/depositUSDT.do" , produces = "application/json; charset=utf8")
	public String depositUSDT(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		double usdt = Double.parseDouble(request.getParameter("usdt").toString());
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		HttpSession session = request.getSession();
		if(!AdminUtil.highAdminCheck(session)){
			obj.put("msg", "요청을 실패했습니다.");
			return obj.toJSONString();
		}
		
		if(usdt <= 0){
			obj.put("msg", "입금액을 입력해주세요.");
			return obj.toJSONString();
		}
		Member member = Member.getMemberByIdx(idx);
		double bfPoint = member.getWalletC("USDT");
		double afPoint = 0;
		String k = "adDeposit";
		afPoint = bfPoint + usdt;
		
		Wallet.updateWallet(member, afPoint, usdt, "USDT", "+", k);
		AdminUtil.insertAdminLog(request,sampleDAO, AdminLog.GIVEUSDT, member.userIdx,null, 1, ""+usdt, bfPoint+" -> "+afPoint);
		
		EgovMap in = new EgovMap();
		in.put("userIdx",idx);
		in.put("amount", usdt);
		in.put("tx", "");
		in.put("coin", "USDT");
		in.put("label", "+");
		in.put("status", "1");
		in.put("fee", 0);
		in.put("from", 1);
		in.put("to", idx);
		sampleDAO.insert("insertTransaction",in);
		member.depositUSDT = member.getDepositUSDT() + usdt;
		
		obj.put("result", "success");
		obj.put("msg", "완료되었습니다.");
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value="/updateInfo.do" , produces = "application/json; charset=utf8")
	public String updateInfo(MultipartHttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		String test = request.getParameter("test");
		String kind = request.getParameter("kind");
		String address = request.getParameter(kind);
		HttpSession session = request.getSession();
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap in = new EgovMap();
		Member m = Member.getMemberByIdx(idx);
		in.put("idx", idx);
		if(kind.compareTo("name")==0){
			String name = ""+request.getParameter("name");
			in.put("name", name);
			m.setName(name);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.NAME.getValue(), name,null);
		}else if(kind.compareTo("email")==0){
			if(!AdminUtil.highAdminCheck(session)){
				obj.put("msg", "권한이 없습니다.");
				return obj.toJSONString();
			}
			String changeEmail = request.getParameter("email");
			in.put("email", changeEmail);	
			in.put("eEmail", changeEmail);
			in.put("euserIdx", idx);
			in.put("kind", "admin");
			
			if(sampleDAO.select("selectIsMemberEmail",in) != null){
				obj.put("msg", "이미 존재하는 이메일 주소입니다.");
				return obj.toJSONString();
			}
			
			sampleDAO.insert("insertElist", in);
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.EMAIL.getValue(), request.getParameter("email"),null);
		}else if(kind.compareTo("phone")==0){
			if(!AdminUtil.highAdminCheck(session)){
				obj.put("msg", "권한이 없습니다.");
				return obj.toJSONString();
			}
			in.put("phone", request.getParameter("phone"));
			EgovMap isPhone = (EgovMap)sampleDAO.select("selectIsMemberPhone",in);
			if(isPhone != null && Integer.parseInt(isPhone.get("jstat")+"") != 2){
				obj.put("msg", "이미 가입된 휴대폰번호입니다.");
				return obj.toJSONString();
			}
			m.phone = ""+request.getParameter("phone");
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.PHONE.getValue(), request.getParameter("phone"),null);
		}else if(kind.compareTo("inviteCode")==0){
			if(!AdminUtil.highAdminCheck(session)){
				obj.put("msg", "권한이 없습니다.");
				return obj.toJSONString();
			}
			String inviteCode = request.getParameter("inviteCode").toString();
			in.put("inviteCode", inviteCode);
			EgovMap isPhone = (EgovMap)sampleDAO.select("selectMemberByInvitationCode",in);
			if(isPhone != null){
				obj.put("msg", "이미 존재하는 초대코드 입니다.");
				return obj.toJSONString();
			}
			m.inviteCode = inviteCode;
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.INVITECODE.getValue(), m.inviteCode,null);
		}else if(kind.compareTo("memo")==0){
			in.put("memo", request.getParameter("memo"));
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.MEMO.getValue(), request.getParameter("memo"),null);
		}else if(kind.compareTo("color")==0){
			in.put("color", request.getParameter("color"));
		}else if(kind.compareTo("test")==0){
			if(test.compareTo("0")==0){
				in.put("test", 1);
				if(m != null){
		    		m.setIstest(1);
		    	}
			}
			else{
				in.put("test", 0);
				if(m != null){
		    		m.setIstest(0);
		    	}
			}
		}else if(kind.endsWith("Address")) {
			in.put(kind, address);
			String coin = kind.split("Address")[0].toUpperCase();
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, coin, MemberInfo.WALLETADDRESS.getValue(), address, null);
			Send.sendAdminMsg(m, "(uid "+m.userIdx+") "+kind+" 변경. 변경주소값 = "+address);
		}else if(kind.compareTo("maccount")==0){
			if(!AdminUtil.highAdminCheck(session)){
				obj.put("msg", "권한이 없습니다.");
				return obj.toJSONString();
			}
			in.put("mbank", request.getParameter("mbank"));
			in.put("maccount", request.getParameter("maccount"));
			m.bank = ""+request.getParameter("mbank");
			m.account = ""+request.getParameter("maccount");
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.ACCOUNT.getValue(), request.getParameter("maccount"),request.getParameter("mbank"));
		}else if(kind.compareTo("vAccount")==0){
			if(!AdminUtil.highAdminCheck(session)){
				obj.put("msg", "권한이 없습니다.");
				return obj.toJSONString();
			}
			in.put("vBank", request.getParameter("vBank"));
			in.put("vAccount", request.getParameter("vAccount"));
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.VACCOUNT.getValue(), request.getParameter("vAccount"),request.getParameter("vBank"));
		}else if(kind.compareTo("mname")==0){
			in.put("mname", request.getParameter("mname"));
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.MNAME.getValue(), request.getParameter("mname"),null);
		}else if(kind.compareTo("tintro")==0){
			EgovMap tin = new EgovMap();
			tin.put("tuseridx",idx);
			tin.put("tintro", address);
			sampleDAO.update("updateTintroInfo",tin);
			
			obj.put("result", "success");
			obj.put("msg", "완료되었습니다.");
			return obj.toJSONString();
		}else if(kind.compareTo("timg")==0){
			MultipartFile file = request.getFile("timg");

	        if(file.isEmpty()){
				obj.put("msg", "이미지를 선택해주세요.");
				return obj.toJSONString();
	        }
	        
			String filePath = "C:/upload/global/photo/";
	        File fileP = new File(filePath);
	        if(!fileP.exists()) {
	        	fileP.mkdirs();
	        }

	        String originNm = file.getOriginalFilename();
			String saveNm = UUID.randomUUID().toString().replaceAll("-", "") + originNm.substring(originNm.lastIndexOf("."));
			try {
				file.transferTo(new File(filePath+saveNm));
				in.put("tuseridx", idx);
				in.put("timg",saveNm);
				sampleDAO.update("updateTimgInfo",in);
				
				obj.put("result", "success");
				obj.put("msg", "완료되었습니다.");
				return obj.toJSONString();
			} catch (Exception e) {
				obj.put("msg","파일 업로드 실패");
				return obj.toJSONString();
			}
		}else if(kind.compareTo("pw")==0){
			if(!AdminUtil.highAdminCheck(session)){
				obj.put("msg", "권한이 없습니다.");
				return obj.toJSONString();
			}
			in.put("pw", request.getParameter("pw"));
			m.pw = ""+request.getParameter("pw");
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.PW.getValue(), request.getParameter("pw"),null);
		}else if(kind.compareTo("id")==0){
			if(!AdminUtil.highAdminCheck(session)){
				obj.put("msg", "권한이 없습니다.");
				return obj.toJSONString();
			}
			in.put("id", request.getParameter("id"));
			EgovMap id = (EgovMap)sampleDAO.select("selectMemberById",in);
			if(id != null && Integer.parseInt(id.get("jstat")+"") != 2){
				obj.put("msg", "이미 가입된 아이디입니다.");
				return obj.toJSONString();
			}
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, m.userIdx, null, MemberInfo.ID.getValue(), request.getParameter("id"),null);
		}
		sampleDAO.update("updateMemberInfo",in);
		
		obj.put("result", "success");
		obj.put("msg", "완료되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/ipBan.do" , produces = "application/json; charset=utf8")
	public String ipBan(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		String ip = request.getParameter("ip");
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		if(ip == null || ip.isEmpty()){
			obj.put("msg", "대상 IP가 없습니다.");
			return obj.toJSONString();
		}
		EgovMap in = new EgovMap();
		in.put("ip", ip);
		in.put("useridx", idx);
		sampleDAO.insert("insertBanIp",in);
		SocketHandler.ipBanList = (List<EgovMap>)sampleDAO.list("selectAllBanList");
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.BLOCK_IP, -1, null, 1, ip, null);
		obj.put("result", "success");
		obj.put("msg", "차단되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/releaseBan.do" , produces = "application/json; charset=utf8")
	public String releaseBan(HttpServletRequest request){
		String ip = request.getParameter("ip");
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap in = new EgovMap();
		in.put("ip", ip);
		sampleDAO.delete("deleteBanIp",in);
		SocketHandler.ipBanList = (List<EgovMap>)sampleDAO.list("selectAllBanList");
		
		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.BLOCK_IP, -1, null, 0, ip, null);
		obj.put("result", "success");
		obj.put("msg", "해제되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/userBan.do" , produces = "application/json; charset=utf8")
	public String userBan(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		sampleDAO.insert("insertUserBan",in);
		SocketHandler.userBanList = (List<EgovMap>)sampleDAO.list("selectAllUserBanList");
		Member.getMemberByIdx(idx).block = true;
		
		AdminUtil.insertAdminLog(request,sampleDAO, AdminLog.BLOCK_USER, idx,null, 1, null, null);
		
		obj.put("result", "success");
		obj.put("msg", "차단되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteUser.do" , produces = "application/json; charset=utf8")
	public String deleteUser(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap in = new EgovMap();
		in.put("idx", idx);
		sampleDAO.update("updatePhoneZero",in);
		in.put("userIdx", idx);
		sampleDAO.insert("insertUserBan",in);
		SocketHandler.userBanList = (List<EgovMap>)sampleDAO.list("selectAllUserBanList");
		Member.getMemberByIdx(idx).block = false;
		
		AdminUtil.insertAdminLog(request,sampleDAO, AdminLog.UPDATE_USER, idx,null, MemberInfo.DELETE.getValue(), null, null);	
		
		obj.put("result", "success");
		obj.put("msg", "삭제되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/releaseUserBan.do" , produces = "application/json; charset=utf8")
	public String releaseUserBan(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		sampleDAO.delete("deleteUserBan",in);
		SocketHandler.userBanList = (List<EgovMap>)sampleDAO.list("selectAllUserBanList");
		Member.getMemberByIdx(idx).block = false;
		
		AdminUtil.insertAdminLog(request,sampleDAO, AdminLog.BLOCK_USER, idx,null, 0, null, null);		
		obj.put("result", "success");
		obj.put("msg", "해제되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/setVConfirm.do" , produces = "application/json; charset=utf8")
	public String setVConfirm(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		int vConfirm = Integer.parseInt(""+request.getParameter("vConfirm"));
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		in.put("vConfirm", vConfirm);
		sampleDAO.update("updateMemberVConfirm",in);
		
		boolean cf = false;
		if(vConfirm == 1)
			cf = true;
		Member.getMemberByIdx(idx).vConfirm = cf;
		
		AdminUtil.insertAdminLog(request,sampleDAO, AdminLog.VCONFIRM, idx ,null, vConfirm, null, null);
		obj.put("result", "success");
		obj.put("msg", "완료되었습니다.");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/balanceCheck.do" , produces = "application/json; charset=utf8")
	public String balanceCheck(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		in.put("check", 1);
		sampleDAO.update("updateMemberBalanceCheck",in);
		obj.put("result", "success");
		obj.put("msg", "갱신 요청되었습니다.");
		return obj.toJSONString();
	}
	
	@RequestMapping(value="/ipBanList.do")
	public String ipBanList(HttpServletRequest request , Model model){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
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
		pi.setTotalRecordCount((int)sampleDAO.select("selectBanListCnt",in));
		model.addAttribute("list", sampleDAO.list("selectBanList",in));
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		return "admin/ipBanList";
	}
	
	@RequestMapping(value="/userBanList.do")
	public String userBanList(HttpServletRequest request , Model model){
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String search = request.getParameter("search");
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
		pi.setTotalRecordCount((int)sampleDAO.select("selectUserBanListCnt",in));
		model.addAttribute("list", sampleDAO.list("selectUserBanList",in));
		model.addAttribute("pi", pi);
		model.addAttribute("sdate", sdate);
		model.addAttribute("edate", edate);
		model.addAttribute("search", search);
		return "admin/userBanList";
	}
	
	//수수료비율 변경
	@ResponseBody
	@RequestMapping(value="/updateCommissionRate.do" , produces = "application/json; charset=utf8", method = RequestMethod.POST)
	public String changeRate(HttpServletRequest request){
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		Double commissionRate = Double.parseDouble(""+request.getParameter("commissionRate"));
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberDetail",idx);
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		double maxRate = Project.getChongMaxRate();
		if(commissionRate > maxRate){
			obj.put("msg", "수수료는 "+maxRate+"%를 넘을 수 없습니다.");
			return obj.toJSONString();
		}else if(commissionRate < 0){
			obj.put("msg", "수수료는 0%보다 작을 수 없습니다.");
			return obj.toJSONString();
		}

		Member mem = Member.getMemberByIdx(idx);
		Member parent = mem.getParent();
		
		if(mem.getLevel().equals("user")){
			obj.put("msg", "유저의 수수료는 변경할 수 없습니다.");
			return obj.toJSONString();
		}
		if(parent != null){
			double pRate = parent.myRate;
			if(commissionRate > pRate){
				obj.put("msg", "수수료가 상위( "+parent.getName()+", "+pRate+"% ) 보다 높을 수 없습니다.");
				return obj.toJSONString();
			}
		}
		
		ArrayList<Member> children = mem.getChildrenChong();
		if(children.size() != 0){
			String underlist = "";
			for(Member c : children){
				if(commissionRate < c.myRate){
					underlist += c.getName()+"("+c.myRate+"%) ";
				}
			}
			if(!underlist.isEmpty()){
				obj.put("msg", "수수료가 하위총판 [ "+underlist+" ] 보다 낮을 수 없습니다.");
				return obj.toJSONString();
			}
		}
		
		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		in.put("commissionRate", commissionRate);
		//변경하고자하는 유저의 commissionRate 변경
		sampleDAO.update("updateCommisionRate",in);
		//서버 수수료율 변경
		double prevRate = mem.myRate;
		mem.myRate = commissionRate;

		AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, idx, null, MemberInfo.RATE.getValue(), mem.myRate, prevRate+" -> "+mem.myRate);
		obj.put("result", "success");
		obj.put("msg", "변경되었습니다.");
		return obj.toJSONString();
	}
	
	String underCommissionCheck(List<EgovMap> sublist, double commissionRate){
		String under="";
		for(int i = 0; i < sublist.size(); i++){
			double subRate = Double.parseDouble(sublist.get(i).get("commissionRate").toString());
			if(subRate > commissionRate){
				String space = " , ";
				if(under.isEmpty()) space = "";
				under= under + space + sublist.get(i).get("name").toString();
			}
		}
		return under;
	}
	
	String overCommissionCheck(EgovMap info, double commissionRate){
		String over="";
		String userLevel = info.get("level").toString();
		ArrayList<Integer> upArray = new ArrayList<Integer>();
		switch(userLevel){
		case "Mega": 
			isNotNullOver(info, upArray, "logIdx");
			break;
		case "Star":
			isNotNullOver(info, upArray, "logIdx");
			isNotNullOver(info, upArray, "megaIdx");
			break;
		case "Premium":
			isNotNullOver(info, upArray, "logIdx");
			isNotNullOver(info, upArray, "megaIdx");
			isNotNullOver(info, upArray, "starIdx");
			break;
		case "Influencer":
			isNotNullOver(info, upArray, "logIdx");
			isNotNullOver(info, upArray, "megaIdx");
			isNotNullOver(info, upArray, "starIdx");
			isNotNullOver(info, upArray, "premiumIdx");
			break;
		default:
			isNotNullOver(info, upArray, "logIdx");
			isNotNullOver(info, upArray, "megaIdx");
			isNotNullOver(info, upArray, "starIdx");
			isNotNullOver(info, upArray, "premiumIdx");
			isNotNullOver(info, upArray, "influencerIdx");
			break;
		}
		EgovMap in = new EgovMap();
		for(int i = 0; i < upArray.size(); i++){
			in.put("userIdx", upArray.get(i));
			EgovMap up = (EgovMap)sampleDAO.select("selectMemberLevelByIdx",in);
			double upRate = Double.parseDouble(up.get("commissionRate").toString());
			if(commissionRate > upRate){
				String space = " , ";
				if(over.isEmpty()) space = "";
				over= over + space + up.get("name").toString();
			}
		}
		return over;
	}
	
	void isNotNullOver(EgovMap info, ArrayList<Integer> array, String levelIdx){
		if(info.get(levelIdx) != null){
			String over = ""+info.get(levelIdx);
			array.add(Integer.parseInt(over));
		}
	}
	@ResponseBody
	@RequestMapping(value="/changeLevelOption.do" , produces = "application/json; charset=utf8")
	public String changeLevelOption(HttpServletRequest request){
		String changeIdx = request.getParameter("changeIdx");
		String type = request.getParameter("type");
		String kind = request.getParameter("kind");
		JSONObject obj = new JSONObject();
		EgovMap in = new EgovMap();
		in.put("idx", changeIdx);
		in.put("searchType", type+"Idx");
		in.put("level", kind);
		List<EgovMap> list = (List<EgovMap>)sampleDAO.list("selectSubMemberList" , in);
		JSONArray arr = new JSONArray();
		for(int i=0; i< list.size(); i++){
			JSONObject item = new JSONObject();
			item.put("idx", list.get(i).get("idx"));
			item.put("name", list.get(i).get("name"));
			item.put("level", list.get(i).get("level"));
			arr.add(item);
		}
		obj.put("list", arr);
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/updateLevel.do" , produces = "application/json; charset=utf8")
	public String updateLevel(HttpServletRequest request){
		HttpSession session = request.getSession();
		int idx = Integer.parseInt(""+request.getParameter("idx"));
		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		String level = request.getParameter("level");
		
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		if(level == null || level.isEmpty()){
			obj.put("msg", "승급불가.");
			return obj.toJSONString();
		}
		EgovMap info = (EgovMap)sampleDAO.select("selectMemberByIdxGetParent" ,in);
		String bfLevel = info.get("level").toString();
		if(bfLevel.equals(level)){
			obj.put("msg", "같은 등급으로 변경할 수 없습니다.");
			return obj.toJSONString();
		}
		String msg = "완료되었습니다.";
		if(info.get("parentLv") != null){
			String parentLv = info.get("parentLv").toString();
			if(parentLv.compareTo("user")==0){
				obj.put("msg", "user--x-->(총판) 불가능합니다.");
				return obj.toJSONString();
			}else{
				msg += "\n 커미션 수수료를 꼭 설정해주세요.";
			}
//			if(info.get("gparentLv") != null){
//				String gparentLv = info.get("gparentLv").toString();
//				if(gparentLv.compareTo("chong")==0 && parentLv.compareTo("chong")==0){
//					obj.put("msg", "총판->총판->(총판) 불가능합니다.");
//					return obj.toJSONString();
//				}
//			}
		}
		in.put("level" , level);
		in.put("adminIdx", session.getAttribute("adminIdx"));
		in.put("ip", request.getRemoteAddr());
		in.put("bf", bfLevel);
		in.put("af", level);
		in.put("kind" , 0);
		sampleDAO.update("updateMemberLevel" , in);
		sampleDAO.insert("insertLevelLog",in);
		session.setAttribute("userLevel", level);		
		Member.getMemberByIdx(idx).setLevel(level);
		
		obj.put("result", "success");
		obj.put("msg", msg);
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/parentChange.do" , produces = "application/json; charset=utf8")
	public String parentChange(HttpServletRequest request){
		int parentIdx = Integer.parseInt(request.getParameter("parentIdx").toString());
		int idx = Integer.parseInt(request.getParameter("idx").toString());
		JSONObject obj = new JSONObject();
		obj.put("result","fail");

		EgovMap in = new EgovMap();
		in.put("userIdx", idx);
		in.put("parentIdx", parentIdx);
		//총판 변경 가능한지 ( 오더, 거래내역, 입출금 내역 하나도 없는지 )
		EgovMap orderLog = (EgovMap)sampleDAO.select("isOrderLog",in);
		EgovMap isTradelog = (EgovMap)sampleDAO.select("selectIsTradeLog",in);
		EgovMap transactionLog = (EgovMap)sampleDAO.select("selectIsTransactions",in);
		if(isTradelog != null || orderLog != null || transactionLog != null){
			obj.put("msg","거래, 주문, 입출금 내역이 없는 계정만 총판 변경이 가능합니다.");
			return obj.toJSONString();
		}
		Member member = Member.getMemberByIdx(idx);
		Member prevParent = member.getParent();
		String prevChong = "없음";
		if(prevParent != null)
			prevChong = prevParent.getName();
		
		if(!member.getLevel().equals("user")){
			obj.put("msg","일반 유저 계정만 총판 변경이 가능합니다.");
			return obj.toJSONString();
		}
		Member newParent = Member.getMemberByIdx(parentIdx);
		if(newParent != null && newParent.getLevel().equals("chong")){
			member.changeParent(newParent);
			sampleDAO.update("updateMemberParent",in);
			obj.put("msg","변경되었습니다.");
			obj.put("result","suc");
			AdminUtil.insertAdminLog(request, sampleDAO, AdminLog.UPDATE_USER, member.userIdx, null, MemberInfo.PARENT.getValue(), newParent.getName(), prevChong+" -> "+newParent.getName());
		}else{
			obj.put("msg","잘못된 접근입니다.");
		}
			
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/isPendingWithdraw.do", produces = "application/json; charset=utf8")
	public String isPendingWithdraw(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		
		obj.put("dcnt", (int)sampleDAO.select("selectIsDeposit"));
		obj.put("wcnt", (int)sampleDAO.select("selectIsWithdraw"));
		
		obj.put("result","suc");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/isPendingKwithdraw.do", produces = "application/json; charset=utf8")
	public String isPendingKwithdraw(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		obj.put("wcnt", (int)sampleDAO.select("selectIsKwithdraw"));
		obj.put("dcnt", (int)sampleDAO.select("selectIsKdeposit"));
		obj.put("result","suc");
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/isAllAlarmCheck.do", produces = "application/json; charset=utf8")
	public String isAllAlarmCheck(HttpServletRequest request) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");

		if(Project.isCoinDeposit()){
			obj.put("dcnt", (int)sampleDAO.select("selectIsDeposit"));
			obj.put("wcnt", (int)sampleDAO.select("selectIsWithdraw"));
		}
		if(Project.isKrwDeposit()){
			obj.put("kdcnt", (int)sampleDAO.select("selectIsKdeposit"));
			obj.put("kwcnt", (int)sampleDAO.select("selectIsKwithdraw")); //여기서 오류남
		}
		if(Project.isP2P()){
			obj.put("p2pdcnt", (int)sampleDAO.select("selectP2PDepositCnt"));
			obj.put("p2pwcnt", (int)sampleDAO.select("selectP2PWithdrawCnt")); //여기서 오류남
		}
		
		obj.put("newMemCnt", (int)sampleDAO.select("selectNewMemberCnt"));
		//obj.put("newChongCnt", (int)sampleDAO.select("selectNewChongCnt")); //여기서 오류남	
		
		
		obj.put("askcnt", (int)sampleDAO.select("selectContactCnt"));
		/*
		EgovMap ask = (EgovMap)sampleDAO.select("selectNonReadContact");
		if(ask != null){
			obj.put("ask", "1");
		}else{
			obj.put("ask", "0");
		}
*/
		obj.put("result", "success");
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/getChildList.do" , produces = "application/json; charset=utf8")
	public String getChildList(HttpServletRequest request){
		String userIdx = request.getParameter("uidx");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		
		ArrayList<EgovMap> userList = (ArrayList<EgovMap>)sampleDAO.list("selectChongChildInfo",userIdx);
		JSONArray array = new JSONArray();
		for(EgovMap map : userList){
			array.add(JsonUtil.convertMapToJson(map));
		}
		obj.put("array", array);
		obj.put("result", "suc");
		return obj.toJSONString();
	}
}