package egovframework.example.sample.web.p2psite;

import java.io.File;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;
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

import egovframework.example.sample.classes.AdminChat;
import egovframework.example.sample.classes.CointransService;
import egovframework.example.sample.classes.Copytrade;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Message;
import egovframework.example.sample.classes.P2PAutoCancel;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping("/easy")
public class P2PSiteController {

	@Resource(name = "sampleDAO")
	private SampleDAO sampleDAO;

	@Resource(name = "messageSource")
	MessageSource messageSource;

	@Resource(name = "fileProperties")
	private Properties fileProperties;
	
	@RequestMapping(value = "/login.do")
	public String login(HttpServletRequest request, Model model) throws Exception {
		return "user/p2pSite/p2pLogin";
	}

	@RequestMapping(value = "/contactWrite.do")
	public String contactWrite(HttpServletRequest request, Model model) throws Exception {
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		
		return "user/p2pSite/contactWrite";
	}
	
	@ResponseBody
	@RequestMapping(value="/contactInsert.do" , produces = "application/json; charset=utf8")
	public String contactInsert(MultipartHttpServletRequest request){
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		List<MultipartFile> files = request.getFiles("uploadFiles");
		JSONObject obj = new JSONObject();
		if(title == null || title.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", "제목을 입력해주세요.");
			return obj.toJSONString();
		}
		if(content == null || content.isEmpty()){
			obj.put("result", "fail");
			obj.put("msg", "문의 내용을 입력해주세요.");
			return obj.toJSONString();
		}
		
		title = title.replaceAll("(?i)<script", "&lt;script");
		content = content.replaceAll("(?i)<script", "&lt;script");
		
		HttpSession session = request.getSession();
		String uidx = session.getAttribute("p2pUserIdx").toString();

		EgovMap in = new EgovMap();
		in.put("isp2p", true);
		in.put("uidx", uidx);
		in.put("title", title);
		in.put("content", content);
		if(files.size() > 0){
			String fkey = UUID.randomUUID().toString().replaceAll("-", "");
			in.put("fkey", fkey);
			String path = fileProperties.getProperty("file.photo.upload");
			File file = new File(path);
			if(!file.exists()){
				file.mkdirs();
			}
			for(int i=0; i<files.size(); i++){
				if(!files.get(i).isEmpty()){
					String fileNm = files.get(i).getOriginalFilename();
					String saveNm = UUID.randomUUID().toString().replaceAll("-", "") + fileNm.substring(fileNm.lastIndexOf("."));
					try {
						files.get(i).transferTo(new File(path+saveNm));
						in.put("originNm", fileNm);
						in.put("saveNm" ,saveNm);
						sampleDAO.insert("insertFile",in);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		sampleDAO.insert("insertContact" , in);
		
		obj.put("protocol", "submitRequest");
		SocketHandler.sh.sendAdminMessage(obj);
		
		Member mem = Member.getMemberByIdx(Integer.parseInt(uidx));
		Send.sendAdminMsg(mem,"새로운 P2P 문의 사항이 있습니다.");
		
		in.put("result", "success");
		return obj.toJSONString();
	}
	
	@RequestMapping(value = "/contactDetail.do")
	public String contactDetail(HttpServletRequest request, Model model) throws Exception {
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		
		int idx = Integer.parseInt(""+request.getParameter("bidx"));
		EgovMap info = (EgovMap)sampleDAO.select("selectContactDetail",idx);
		if(!info.get("readYn").equals("Y")){
			sampleDAO.update("updateContactReadYn",idx);
		}
		if(info.get("fkey") != null && !info.get("fkey").toString().isEmpty()){
			model.addAttribute("fileList", sampleDAO.list("selectFileList" , info.get("fkey")));
		}
		model.addAttribute("info", info);
		List<EgovMap> list = (List<EgovMap>)sampleDAO.list("selectBoardSystemList");
		for(int i=0; i<list.size(); i++){
			list.get(i).put("bcontent", StringEscapeUtils.unescapeHtml4(list.get(i).get("bcontent").toString()));
		}
		model.addAttribute("systemlist", list);
		
		return "user/p2pSite/contactDetail";
	}

	@RequestMapping(value = "/contactList.do")
	public String contactList(HttpServletRequest request, Model model) throws Exception {
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		
		String userIdx = ""+session.getAttribute("p2pUserIdx");
		
		PaginationInfo pi = new PaginationInfo();
		if(request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")){
			pi.setCurrentPageNo(1);
		}else{
			pi.setCurrentPageNo(Integer.parseInt(""+request.getParameter("pageIndex")));
		}
		
		pi.setPageSize(5);
		pi.setRecordCountPerPage(10);
		EgovMap in = new EgovMap();
		in.put("first" , pi.getFirstRecordIndex());
		in.put("record" , pi.getRecordCountPerPage());
		in.put("userIdx", userIdx);
		in.put("isp2p", true);
		pi.setTotalRecordCount((int)sampleDAO.select("selectContatListCnt" , in));
		List<?> cList = (List<?>) sampleDAO.list("selectContatListP", in);
		model.addAttribute("cList", cList);
		model.addAttribute("pi", pi);
		model.addAttribute("search", request.getParameter("search"));
		
		return "user/p2pSite/contactList";
	}

	@RequestMapping(value = "/p2pCustomer.do")
	public String p2pCustomer(HttpServletRequest request, Model model) throws Exception {
		return "user/p2pSite/p2pCustomer";
	}

	@RequestMapping(value = "/p2pmain.do")
	public String p2pmain(HttpServletRequest request, Model model) throws Exception {
		EgovMap in = new EgovMap();
		in.put("type",0);
		model.addAttribute("lowBuy",sampleDAO.select("selectP2PLowPrice",in));
		in.put("type",1);
		model.addAttribute("lowSell",sampleDAO.select("selectP2PLowPrice",in));
		return "user/p2pSite/p2pmain";
	}
	
	@ResponseBody
	@RequestMapping(value = "/loginProcess.do", produces = "application/json; charset=utf8")
	public String loginProcess(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result","fail");
		HttpSession session = request.getSession();
		try {
			String uid = request.getParameter("uid").toString();
			String pw = request.getParameter("pw").toString();
			if(uid.length() < 6 || !uid.startsWith("14301"))
				return obj.toJSONString();

			int userIdx = Integer.parseInt(uid.toString().replaceFirst("14301", ""));
			Member mem = Member.getMemberByIdx(userIdx,true);
			
			if(mem == null || !mem.pw.equals(pw))
				return obj.toJSONString();
			
			obj.put("result","suc");
			session.setAttribute("p2pUserIdx", mem.userIdx);
			
		} catch (Exception e) {
		}
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/logoutProcess.do", produces = "application/json; charset=utf8")
	public String logout(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute("p2pUserIdx", null);
		JSONObject obj = new JSONObject();
		obj.put("result", "suc");
		return obj.toJSONString();
	}
	
	@RequestMapping(value = "/p2pbuy.do")
	public String p2pbuy(HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		
		String search = request.getParameter("search");
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(30);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("search", search);
		in.put("type", 0);
		List<EgovMap> p2pList = (List<EgovMap>) sampleDAO.list("selectP2PTraderList", in);
		pi.setTotalRecordCount((int) sampleDAO.select("selectP2PTraderListCnt", in));
		model.addAttribute("p2pList", p2pList);
		model.addAttribute("pi", pi);
		model.addAttribute("search", search);
		return "user/p2pSite/p2pbuy";
	}

	@RequestMapping(value = "/p2psell.do")
	public String p2psell(HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";

		String search = request.getParameter("search");
		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").equals("")) {
			pi.setCurrentPageNo(1);
		} else {
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));
		}
		pi.setPageSize(10);
		pi.setRecordCountPerPage(30);
		EgovMap in = new EgovMap();
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("search", search);
		in.put("type", 1);
		List<EgovMap> p2pList = (List<EgovMap>) sampleDAO.list("selectP2PTraderList", in);
		pi.setTotalRecordCount((int) sampleDAO.select("selectP2PTraderListCnt", in));
		model.addAttribute("p2pList", p2pList);
		model.addAttribute("pi", pi);
		model.addAttribute("search", search);

		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
		model.addAttribute("account", mem.account);
		model.addAttribute("bank", mem.bank);
		return "user/p2pSite/p2psell";
	}

	@ResponseBody
	@RequestMapping(value = "/getWallet.do", produces = "application/json; charset=utf8")
	public String getCoinInfo(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
		obj.put("spot", mem.getWalletC("USDT"));
		obj.put("futures", mem.getWallet());
		obj.put("withdrawWallet", mem.getWithdrawWallet());
		return obj.toJSONString();
	}

	@RequestMapping(value = "/p2pOrders.do")
	public String p2pOrders(HttpServletRequest request, ModelMap model) throws Exception {
		String op = "" + request.getParameter("op");
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		String userIdx = "" + session.getAttribute("p2pUserIdx");
		String date = request.getParameter("sDate");
		String edate = request.getParameter("eDate");
		String kind = null;
		Member user = Member.getMemberByIdx(Integer.parseInt(userIdx));

		if (op.equals("Deposit")) {
			kind = "+";
		} else if (op.equals("Withdrawl")) {
			kind = "-";
		}

		PaginationInfo pi = new PaginationInfo();
		if (request.getParameter("pageIndex") == null || request.getParameter("pageIndex").isEmpty())
			pi.setCurrentPageNo(1);
		else
			pi.setCurrentPageNo(Integer.parseInt("" + request.getParameter("pageIndex")));

		pi.setPageSize(5);
		pi.setRecordCountPerPage(15);
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("kind", kind);
		in.put("first", pi.getFirstRecordIndex());
		in.put("record", pi.getRecordCountPerPage());
		in.put("sdate", date);
		in.put("edate", edate);
		pi.setTotalRecordCount((int) sampleDAO.select("selectKtransactionsP2PCnt", in));
		ArrayList<EgovMap> p2plist = (ArrayList<EgovMap>) sampleDAO.list("selectKtransactionsP2P", in);
		for (EgovMap p2p : p2plist) {
			int pidx = Integer.parseInt(p2p.get("idx").toString());
			int unread = user.getUnreadChats(false, pidx).size();
			p2p.put("unread", unread);
		}
		model.addAttribute("list", p2plist);
		model.addAttribute("op", op);
		model.addAttribute("pi", pi);
		model.addAttribute("sDate", date);
		model.addAttribute("eDate", edate);
		return "user/p2pSite/p2pOrders";
	}

	@ResponseBody
	@RequestMapping(value = "/depositProcessP2P.do", method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String depositProcessP2P(HttpServletRequest request, ModelMap model) throws Exception {
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		
		String userIdx = "" + session.getAttribute("p2pUserIdx");
		BigDecimal money = BigDecimal.valueOf(Integer.parseInt(request.getParameter("depositMoney").toString()));
		int tidx = Integer.parseInt(request.getParameter("tidx").toString());

		EgovMap in = new EgovMap();
		in.put("tidx", tidx);
		EgovMap p2pTrader = (EgovMap) sampleDAO.select("selectP2PTrader", in);
		if (p2pTrader == null) {
			obj.put("msg", "에러가 발생했습니다!");
//			obj.put("msg", Message.get().msg(messageSource, "fail.common.msg", request));
			return obj.toJSONString();
		}

		if (Member.hasAnyPositionOrder(Integer.parseInt(userIdx))) {
			obj.put("msg", "작동중인 포지션 혹은 주문 종료 뒤에 이용가능합니다.");
			return obj.toJSONString();
		} else if (Copytrade.isCopytradeRun(Integer.parseInt(userIdx))) {
			obj.put("msg", "작동중인 카피트레이딩 종료 뒤에 이용가능합니다.");
			return obj.toJSONString();
		}

		int lLimit = Integer.parseInt(p2pTrader.get("lowLimit").toString());
		int mLimit = Integer.parseInt(p2pTrader.get("maxLimit").toString());
		int price = Integer.parseInt(p2pTrader.get("price").toString());
		double sellQty = Double.parseDouble(p2pTrader.get("qty").toString());
		double buyQty = money.divide(BigDecimal.valueOf(price), 4, RoundingMode.HALF_DOWN).doubleValue();

		if (money.intValue() < lLimit) {
			obj.put("msg", "선택 금액이 최소 금액보다 작습니다.");
			return obj.toJSONString();
		} else if (money.intValue() > mLimit) {
			obj.put("msg", "선택 금액이 최대 금액보다 많습니다.");
			return obj.toJSONString();
		} else if (buyQty > sellQty) {
			obj.put("msg", "구매하고자 하는 수량이 판매 수량보다 많습니다.");
			return obj.toJSONString();
		}

		in.put("userIdx", userIdx);
		in.put("money", money);
		in.put("kind", "+");
		in.put("exchangeValue", buyQty);
		in.put("exchangeRate", price);

		if (money.intValue() < 0) {
			obj.put("msg", "금액을 입력해주세요.");
			return obj.toJSONString();
		}
		EgovMap checkMoneyStat = (EgovMap) sampleDAO.select("checkMoneyStatP2P", in);
		if (checkMoneyStat == null) {
			int insertIdx = (int) sampleDAO.insert("insertMoneyP2P", in);
			obj.put("result", "suc");
			obj.put("tidx", tidx);
			obj.put("insertIdx", insertIdx);
			obj.put("msg", "입금신청이 완료되었습니다.");
			obj.put("protocol", "dwRequest");
			SocketHandler.sh.sendAdminMessage(obj);

			Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
			mem.resetP2PRun();

			double resultQty = sellQty - buyQty;
			// if(resultQty <= 0){
			//
			// }else
			{
				in.put("idx", tidx);
				in.put("qty", resultQty);
				in.put("orders", Integer.parseInt(p2pTrader.get("orders").toString()) + 1);
				sampleDAO.update("updateP2PTrader", in);
			}
			P2PAutoCancel.putAutoCancelList(insertIdx, mem.userIdx, null);
			Send.sendAdminMsg(mem, "P2P 입금 신청이 들어왔습니다.");
		} else {
			obj.put("result", "already");
			obj.put("msg", "입금 대기 목록이 존재합니다.");
		}
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/withdrawProcessP2P.do", method = RequestMethod.POST, produces = "application/json; charset=utf8")
	public String withdrawProcess(HttpServletRequest request, ModelMap model) throws Exception {
		double withdrawUSDT = Double.parseDouble(request.getParameter("withdrawMoney"));
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		
		int userIdx = Integer.parseInt("" + session.getAttribute("p2pUserIdx"));
		EgovMap in = new EgovMap();
		Member mem = Member.getMemberByIdx(userIdx);
		double mwallet = mem.getWallet();
		double withdrawWallet = CointransService.getWithdrawWallet(mem, "futures").doubleValue();
		JSONObject obj = new JSONObject();

		if (Member.hasAnyPositionOrder(mem.userIdx)) {
			obj.put("msg", "작동중인 포지션 혹은 주문 종료 뒤에 이용가능합니다.");
			return obj.toJSONString();
		} else if (Copytrade.isCopytradeRun(mem.userIdx)) {
			obj.put("msg", "작동중인 카피트레이딩 종료 뒤에 이용가능합니다.");
			return obj.toJSONString();
		}

		int tidx = Integer.parseInt(request.getParameter("tidx").toString());
		in.put("userIdx", userIdx);
		in.put("tidx", tidx);
		EgovMap p2pTrader = (EgovMap) sampleDAO.select("selectP2PTrader", in);
		if (p2pTrader == null) {
			obj.put("msg", "오류가 발생했습니다!");
			return obj.toJSONString();
		}
		int lLimit = Integer.parseInt(p2pTrader.get("lowLimit").toString());
		int mLimit = Integer.parseInt(p2pTrader.get("maxLimit").toString());
		int price = Integer.parseInt(p2pTrader.get("price").toString());
		double sellUSDT = Double.parseDouble(p2pTrader.get("qty").toString());
		double buyKRW = withdrawUSDT * price;

		in.put("money", buyKRW);
		in.put("kind", "-");

		if (buyKRW < lLimit) {
			obj.put("msg", "선택 금액이 최소 금액보다 작습니다.");
			return obj.toJSONString();
		} else if (buyKRW > mLimit) {
			obj.put("msg", "선택 금액이 최대 금액보다 많습니다.");
			return obj.toJSONString();
		} else if (withdrawUSDT > sellUSDT) {
			obj.put("msg", "구매하고자 하는 수량이 판매 수량보다 많습니다.");
			return obj.toJSONString();
		}
		in.put("exchangeRate", price);
		in.put("exchangeValue", withdrawUSDT);

		if (withdrawWallet < withdrawUSDT) {
			obj.put("result", "moneyWrack");
			obj.put("msg", "잔액이 부족합니다");
		} else {
			EgovMap checkMoneyStat = (EgovMap) sampleDAO.select("checkMoneyStatP2P", in);
			if (checkMoneyStat == null) {

				int insertIdx = (int) sampleDAO.insert("insertMoneyP2P", in);
				in.put("exchangeValue", (-1) * withdrawUSDT);
				obj.put("insertIdx", insertIdx);
				obj.put("result", "suc");
				obj.put("msg", "출금신청이 완료되었습니다.");
				obj.put("protocol", "dwRequest");
				SocketHandler.sh.sendAdminMessage(obj);

				mem.resetP2PRun();

				double resultQty = sellUSDT - withdrawUSDT;

				in.put("idx", p2pTrader.get("idx"));
				in.put("qty", resultQty);
				in.put("orders", Integer.parseInt(p2pTrader.get("orders").toString()) + 1);
				sampleDAO.update("updateP2PTrader", in);

				Send.sendAdminMsg(mem, "P2P 출금 요청이 들어왔습니다.");
			} else {
				obj.put("result", "already");
				obj.put("msg", "출금 대기 목록이 존재합니다.");
			}
		}
		return obj.toJSONString();
	}

	@RequestMapping(value = "/p2pDetail.do")
	public String p2pDetail(HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		if(!loginCheck(session)) return "redirect:login.do";
		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		Member mem = Member.getMemberByIdx(userIdx);
		int moneyIdx = Integer.parseInt(request.getParameter("midx"));
		EgovMap in = new EgovMap();
		in.put("midx", moneyIdx);
		EgovMap detail = (EgovMap) sampleDAO.select("checkMoneyIdxWithP2PInfo", in);
		int pidx = Integer.parseInt(detail.get("idx").toString());
		AdminChat.read(false, mem, pidx);
		model.addAttribute("chats", mem.getChatData(pidx));
		// 채팅 내역 불러오기?
		if (userIdx != Integer.parseInt(detail.get("useridx").toString())) {
			return "redirect:p2pbuy.do";
		}
		model.addAttribute("detail", detail);

		EgovMap accountInto = new EgovMap();
		accountInto.put("bank", mem.bank);
		accountInto.put("account", mem.account);
		accountInto.put("name", mem.getName());
		model.addAttribute("accountInto", accountInto);

		return "user/p2pSite/p2pDetail";
	}

	@ResponseBody
	@RequestMapping(value = "/moneySend.do", produces = "application/json; charset=utf8")
	public String moneySend(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		obj.put("result", "error");
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		in.put("midx", midx);
		EgovMap select = (EgovMap) sampleDAO.select("checkMoneyIdxP2P", in);
		if (select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		} else if (Boolean.parseBoolean(select.get("send").toString())) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		} else if (select.get("stat").toString().compareTo("-1") != 0) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		Member mem = Member.getMemberByIdx(userIdx);
		double mwallet = mem.getWallet();
		double withdrawUSDT = Double.parseDouble(select.get("exchangeValue").toString());
		Wallet.updateWallet(mem, mwallet - withdrawUSDT, (-1) * withdrawUSDT, "futures", "-", "withdraw");

		in.put("send", true);
		sampleDAO.update("updateMoneyP2PSend", in);
		obj.put("result", "suc");

		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/payComplete.do", produces = "application/json; charset=utf8")
	public String payComplete(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		EgovMap select = (EgovMap) sampleDAO.select("checkMoneyIdxP2P", in);
		if (select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		} else if (Integer.parseInt(select.get("stat").toString()) != -1) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		in.put("stat", 0);
		sampleDAO.update("updateMoneyP2PStat", in);
		obj.put("result", "suc");

		Member mem = Member.getMemberByIdx(userIdx);
		P2PAutoCancel.remove(mem.userIdx);
		mem.resetP2PRun();
		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/p2pCancel.do", produces = "application/json; charset=utf8")
	public String cancel(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		EgovMap select = (EgovMap) sampleDAO.select("checkMoneyIdxP2P", in);
		String kind = select.get("kind").toString();
		int stat = Integer.parseInt(select.get("stat").toString());
		if (select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		} else if (kind.equals("-") && stat != -1) {
			obj.put("msg", Message.get().msg(messageSource, "wallet.p2p.cancelFail", request));
			return obj.toJSONString();
		}

		if (stat > 0) {
			obj.put("result", "error");
			return obj.toJSONString();
		}
		if (kind.equals("-") && Boolean.parseBoolean(select.get("send").toString())) {
			CointransService.kWithdrawDenyProcessP2P(String.valueOf(midx));
		}

		in.put("stat", 3);
		sampleDAO.update("updateMoneyP2PStat", in);
		obj.put("result", "suc");

		Member mem = Member.getMemberByIdx(userIdx);
		mem.resetP2PRun();
		AdminChat.p2pReload(mem, midx);

		P2PAutoCancel.remove(mem.userIdx);

		int tidx = Integer.parseInt(select.get("tidx").toString());
		in.put("tidx", tidx);
		EgovMap p2pTrader = (EgovMap) sampleDAO.select("selectP2PTrader", in);
		in.put("idx", tidx);
		double prevQty = Double.parseDouble(select.get("exchangeValue").toString())
				+ Double.parseDouble(p2pTrader.get("qty").toString());
		in.put("qty", prevQty);
		in.put("orders", Integer.parseInt(p2pTrader.get("orders").toString()) - 1);
		sampleDAO.update("updateP2PTrader", in);
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/tradeComplete.do", produces = "application/json; charset=utf8")
	public String tradeComplete(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		int midx = Integer.parseInt(request.getParameter("midx").toString());
		EgovMap in = new EgovMap();
		in.put("widx", midx);
		EgovMap select = (EgovMap) sampleDAO.select("checkMoneyIdxP2P", in);
		if (select == null || Integer.parseInt(select.get("useridx").toString()) != userIdx) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		} else if (Integer.parseInt(select.get("stat").toString()) != 0) {
			obj.put("msg", Message.get().msg(messageSource, "pop.wrongAccess", request));
			return obj.toJSONString();
		}
		in.put("stat", 1);
		sampleDAO.update("updateMoneyP2PStat", in);

		Member mem = Member.getMemberByIdx(userIdx);
		AdminChat.p2pReload(mem, Integer.parseInt(select.get("tidx").toString()));
		mem.resetP2PRun();
		obj.put("result", "suc");
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/chatSend.do", produces = "application/json; charset=utf8")
	public String chatSend(HttpServletRequest request) {
		int userIdx = Integer.parseInt(request.getParameter("userIdx").toString());
		int pidx = Integer.parseInt(request.getParameter("pidx").toString());
		String text = request.getParameter("text");
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");

		Member mem = Member.getMemberByIdx(userIdx);

		if (!AdminChat.chat(false, mem, pidx, text)) {
			return obj.toJSONString();
		}
		Send.sendAdminMsg(mem, "새로운 P2P 채팅 내역이 있습니다.");
		obj.put("result", "success");
		return obj.toJSONString();
	}

	@ResponseBody
	@RequestMapping(value = "/unreadChatCheck.do", produces = "application/json; charset=utf8")
	public String unreadChatCheck(HttpServletRequest request) {
		HttpSession session = request.getSession();
		int userIdx = Integer.parseInt(session.getAttribute("p2pUserIdx").toString());
		JSONObject obj = new JSONObject();
		obj.put("result", "fail");

		Member mem = Member.getMemberByIdx(userIdx);
		boolean unread = mem.isUnreadChats();
		obj.put("unread", unread);

		obj.put("result", "suc");
		return obj.toJSONString();
	}
	
	private boolean loginCheck(HttpSession session){
		if(session.getAttribute("p2pUserIdx") == null){
			return false;
		}
		return true;
	}
}
