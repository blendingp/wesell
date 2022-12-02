package egovframework.example.sample.web.admin;

import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.classes.Order;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.TradeTrigger;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.sise.SiseManager;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/0nI0lMy6jAzAFRVe0DqLOw")
public class AdminDeleteListController {
	@Resource(name="sampleDAO")
	SampleDAO sampleDAO;
	
	public static String testKind = null;
	public static String testSise = null;
	
	@ResponseBody
	@RequestMapping(value = "/sendsise.do")
	public String sendsise(HttpServletRequest request, ModelMap model) throws Exception {
		String kind = ""+request.getParameter("kind");
		String sise = ""+request.getParameter("sise");
		
		testKind = kind;
		testSise = sise;
		Log.print("sendsise "+kind+":"+sise, 1, "test");
		return kind+" ok "+sise;
	}
	@ResponseBody
	@RequestMapping(value = "/changesise.do")
	public String changesise(HttpServletRequest request, ModelMap model) throws Exception {
		String kind = ""+request.getParameter("kind");
		double target =Double.parseDouble( ""+request.getParameter("target"));
		double gab =Double.parseDouble( ""+request.getParameter("gab"));
		
		SiseManager.setStartRC(gab, target, kind);
		Log.print("changesise "+kind+" target:"+target+" gab:"+gab, 1, "test");
		return kind+" ok "+target+" "+gab;
	}

	
	@RequestMapping(value = "/deleteTradeTriggerList.do")
	public String deleteTradeTriggerList(ModelMap model) throws Exception {
		ArrayList<EgovMap> list=new ArrayList<EgovMap>();
		for (int i = 0; i < SocketHandler.triggerList.size(); i++) {
			EgovMap m =new EgovMap();
			m.put("orderNum",""+ SocketHandler.triggerList.get(i).orderNum );
			m.put("userIdx",""+ SocketHandler.triggerList.get(i).userIdx );
			m.put("symbol",""+ SocketHandler.triggerList.get(i).symbol );
			m.put("triggerType",""+ SocketHandler.triggerList.get(i).triggerType );
			m.put("position",""+ SocketHandler.triggerList.get(i).position );
			m.put("triggerPrice",""+ SocketHandler.triggerList.get(i).triggerPrice );
			list.add(m);
		}
		model.addAttribute("trade",list);
		model.addAttribute("count",list.size() );

		return "admin/deleteTradeTriggerList";
	}
	
	@RequestMapping(value = "/deleteTradeTriggerListProcess.do")
	public String deleteTradeTriggerListProcess(HttpServletRequest request,ModelMap model) throws Exception {
		String ordernum = ""+request.getParameter("ordernum");
		String useridx = ""+request.getParameter("useridx");
		try{
			TradeTrigger.removeTradeTriggerByOrderNum(ordernum);
		}catch(Exception e){
			Log.print("deleteTradeTriggerListProcess err "+e.getMessage(), 1, "err");
		}
		Log.print("deleteTradeTriggerListProcess useridx "+useridx +" ordernum:"+ordernum, 0, "system");
		return "redirect:/deleteTradeTriggerList.do";
	}

	@RequestMapping(value = "/memberList.do")
	public String memberLis(ModelMap model) throws Exception {
		ArrayList<EgovMap> list=new ArrayList<EgovMap>();
		synchronized(SocketHandler.members){
			for (int i = 0; i < SocketHandler.members.size(); i++) {
				EgovMap m =new EgovMap();
				m.put("userIdx",""+ SocketHandler.members.get(i).userIdx );
				m.put("wallet",""+ SocketHandler.members.get(i).getWallet() );
				m.put("walletBTC",""+ SocketHandler.members.get(i).getWalletC("BTCUSD") );
				m.put("walletETH",""+ SocketHandler.members.get(i).getWalletC("ETHUSD") );
				m.put("walletXRP",""+ SocketHandler.members.get(i).getWalletC("XRPUSD") );
				m.put("walletTRX",""+ SocketHandler.members.get(i).getWalletC("TRXUSD") );
				m.put("walletUSDT",""+ SocketHandler.members.get(i).getWalletC("USDT"));
				m.put("info",""+ SocketHandler.members.get(i).getInfo() );
				/*
				m.put("level",""+ SocketHandler.members.get(i).level );
				m.put("parentsLevel",""+ SocketHandler.members.get(i).parentsLevel );
				m.put("parentsIdx",""+ SocketHandler.members.get(i).parentsIdx );
				m.put("gparentsIdx",""+ SocketHandler.members.get(i).gparentsIdx );
				m.put("myRate",""+ SocketHandler.members.get(i).myRate );
				m.put("parentsRate",""+ SocketHandler.members.get(i).parentsRate );
				m.put("istest",""+ SocketHandler.members.get(i).istest );
				*/
				list.add(m);
			}
		}	
		model.addAttribute("members",list);
		return "admin/memberlist";
	}	
	@RequestMapping(value = "/deletePositionList.do")
	public String deletePositionList(ModelMap model) throws Exception {
		ArrayList<EgovMap> list=new ArrayList<EgovMap>();
		synchronized(SocketHandler.positionList){
			for (int i = 0; i < SocketHandler.positionList.size(); i++) {
				EgovMap m =new EgovMap();
				m.put("userIdx",""+ SocketHandler.positionList.get(i).userIdx );
				m.put("symbol",""+ SocketHandler.positionList.get(i).symbol );
				m.put("position",""+ SocketHandler.positionList.get(i).position );
				m.put("entryPrice",""+ SocketHandler.positionList.get(i).entryPrice );
				m.put("buyQuantity",""+ SocketHandler.positionList.get(i).buyQuantity );
				m.put("liquidationPrice",""+ SocketHandler.positionList.get(i).liquidationPrice );

				m.put("contractVolume",""+ SocketHandler.positionList.get(i).contractVolume );
				m.put("mainMargin",""+ 0 );
				m.put("leverage",""+ SocketHandler.positionList.get(i).leverage );
				m.put("marginType",""+ SocketHandler.positionList.get(i).marginType );
				m.put("orderType",""+ SocketHandler.positionList.get(i).orderType );
				m.put("fee",""+ SocketHandler.positionList.get(i).fee );
				list.add(m);
			}
		}
		model.addAttribute("trade",list);
		model.addAttribute("count",list.size() );
		model.addAttribute("logTime",SocketHandler.sh.logTime);
		model.addAttribute("logNum",SocketHandler.sh.logNum);
		model.addAttribute("reInit",SocketHandler.sh.reInit);
		model.addAttribute("orderIdxTmp",SocketHandler.sh.orderIdxTmp);
		
		model.addAttribute("bidtmp",SocketHandler.sh.bidtmp);
		model.addAttribute("asktmp",SocketHandler.sh.asktmp);
		
		model.addAttribute("bidHtmp",SocketHandler.sh.bidHtmp);
		model.addAttribute("bidLtmp",SocketHandler.sh.bidLtmp);
		
		model.addAttribute("askHtmp",SocketHandler.sh.askHtmp);
		model.addAttribute("askLtmp",SocketHandler.sh.askLtmp);		
		model.addAttribute("triggerPriceTmp",SocketHandler.sh.triggerPriceTmp);
		model.addAttribute("symboltmp",SocketHandler.sh.symboltmp);
		model.addAttribute("result",SocketHandler.sh.result);
		return "admin/deletePositionList";
	}
	
	@ResponseBody
	@RequestMapping(value = "/changeInit.do")
	public String changeInit(ModelMap model) throws Exception {
		SocketHandler.sh.reInit = 1;
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping(value = "/showProblemOrder.do")
	public String showProblemOrder(ModelMap model) throws Exception {
		String result = "";
		for (int i = 0; i < SocketHandler.triggerList.size(); i++) {
			if(SocketHandler.triggerList.get(i).triggerType.compareTo("inPosition")!=0)
			{
				String orderNum = ""+SocketHandler.triggerList.get(i).orderNum;
				int idx = Order.getOrderIdxByOrderNum(orderNum);
				if (idx < 0) { 
					result += orderNum+",";
				}
			}
		}
		return "ok"+result;
	}
		
	@RequestMapping(value = "/deletePositionListProcess.do")
	public String deletePositionListProcess(HttpServletRequest request,ModelMap model) throws Exception {
		String symbol = ""+request.getParameter("symbol");
		String useridx = ""+request.getParameter("useridx");
		
		try{
	    	Position position = Position.getPosition( Integer.parseInt(useridx), symbol);
	    	if (position == null) {
				Log.print("delete , position is null", 0, "err");
				return "redirect:/deletePositionListProcess.do";
			}	    	
	    	SocketHandler.sh.removePosition(position,false);
		}catch(Exception e){
			Log.print("deletePositionListProcess err "+e.getMessage(), 1, "err");
		}
		Log.print("deletePositionListProcess useridx "+useridx +" sybol:"+symbol, 0, "system");
		return "redirect:/deletePositionList.do";
	}
	
	@RequestMapping(value = "/deleteOrderList.do")
	public String deleteOrderList(ModelMap model) throws Exception {
		ArrayList<EgovMap> list=new ArrayList<EgovMap>();
		synchronized(SocketHandler.orderList ){
			for (int i = 0; i < SocketHandler.orderList.size(); i++) {
				EgovMap m =new EgovMap();
				
				m.put("userIdx",""+ SocketHandler.orderList.get(i).userIdx );
				m.put("orderNum",""+ SocketHandler.orderList.get(i).orderNum );
				m.put("symbol",""+ SocketHandler.orderList.get(i).symbol );
				m.put("orderType",""+ SocketHandler.orderList.get(i).orderType );
				m.put("position",""+ SocketHandler.orderList.get(i).position );
				m.put("entryPrice",""+ SocketHandler.orderList.get(i).entryPrice );
				m.put("entryPriceForStop",""+ SocketHandler.orderList.get(i).entryPriceForStop );
				m.put("triggerPrice",""+ SocketHandler.orderList.get(i).triggerPrice );
				m.put("buyQuantity",""+ SocketHandler.orderList.get(i).buyQuantity );
				m.put("conclusionQuantity",""+ SocketHandler.orderList.get(i).conclusionQuantity );
				m.put("state",""+ SocketHandler.orderList.get(i).state );
				m.put("leverage",""+ SocketHandler.orderList.get(i).leverage );
				m.put("marginType",""+ SocketHandler.orderList.get(i).marginType );
				m.put("paidVolume",""+ SocketHandler.orderList.get(i).paidVolume );
				m.put("mainMargin",""+ 0 );
				m.put("postOnly",""+ SocketHandler.orderList.get(i).postOnly );
				m.put("orderTime",""+ SocketHandler.orderList.get(i).orderTime );
				m.put("auto",""+ SocketHandler.orderList.get(i).auto );
				list.add(m);
			}
		}
		model.addAttribute("trade",list);
		model.addAttribute("count",list.size() );

		return "admin/deleteOrderList";
	}
	
	@RequestMapping(value = "/deleteOrderListProcess.do")
	public String deleteOrderProcess(HttpServletRequest request,ModelMap model) throws Exception {
		String ordernum = ""+request.getParameter("ordernum");
		
		try{
			int orderIdx = Order.getOrderIdxByOrderNum(ordernum);
			if (orderIdx < 0) { return "redirect:/deleteOrderList.do"; }
			Order order = SocketHandler.sh.orderList.get(orderIdx);
			order.updateOrderState("exception");
			order.removeOrderList();
			
		}catch(Exception e){
			Log.print("deleteOrderProcess err "+e.getMessage(), 1, "err");
		}
		Log.print("deleteOrderProcess useridx "+ordernum , 0, "system");
		return "redirect:/deleteOrderList.do";
	}	
}
