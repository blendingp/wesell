package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Queue;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.MessageSource;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import egovframework.example.sample.enums.CopytradeKind;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.enums.TPSLType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.service.impl.SampleDAO;
import egovframework.example.sample.sise.Hoga;
import egovframework.example.sample.sise.SiseManager;
import egovframework.example.sample.web.ZLogController;
import egovframework.example.sample.web.spot.SpotManager;
import egovframework.example.sample.web.spot.SpotOrder;
import egovframework.example.sample.web.spot.SpotTradeTrigger;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SocketHandler extends TextWebSocketHandler implements InitializingBean {
		public ZLogController zlog=new ZLogController(); 
		
        @Resource(name = "sampleDAO")
        private SampleDAO sampleDAO;
        
        @Resource(name="messageSource")
        MessageSource messageSource;
        
    	@Resource(name = "fileProperties")
    	private Properties fileProperties;

        public Properties getProperties(){
        	return fileProperties;
        }        
        
        public static SiseManager sise = null;
        public static ArrayList<Member> members = new ArrayList<>();
        
        public static ArrayList<P2PAutoCancel> p2pAutoCancelList = new ArrayList<>();
        public static ArrayList<TradeTrigger> triggerList = new ArrayList<>();
        public static ArrayList<Position> positionList = new ArrayList<>(); 
        public static ArrayList<Position> tpList = new ArrayList<>(); 
        public static ArrayList<Position> slList = new ArrayList<>(); 
        public static ArrayList<Order> orderList = new ArrayList<>(); 
        public static List<EgovMap> ipBanList = null;
        public static List<EgovMap> userBanList = null;
        public static List<EgovMap> adminIpList = null;
        public static LinkedList<QueryWait> queryList = new LinkedList<>();
        public static LinkedList<QueryWait> updateQueryList = new LinkedList<>();
        public static Queue<UserMsg> msgList = new LinkedList<>();
        public static Queue<SendMsg> sendList = new LinkedList<>();
        public static Queue<SendMsg> sendStartList = new LinkedList<>();
        public static ArrayList<Copytrade> copytradeList = new ArrayList<>(); 
        public static ArrayList<String> dangerMsg = new ArrayList<>();
        public static int dangerMsgRead = 0;
        public static int copytraderRequest = 0;
        public static String exchangeRate = "";
        private final Logger logger = LogManager.getLogger(getClass());
        public Set<WebSocketSession> sessionSet = new HashSet<WebSocketSession>();
        
        public static SpotManager spotManager=new SpotManager();
        public static ArrayList<SpotOrder> spotOrderList = new ArrayList<>();
        public static ArrayList<SpotTradeTrigger> spotTriggerList = new ArrayList<>();
        public static ArrayList<SpotTradeTrigger> spotTmpTriggerList = new ArrayList<>();
        public static SocketHandler sh;        
        public static int fixstat = 0;//0일떄 정상 1일떄 점검
        public SocketHandler() {  
        	super(); sh = this; 
        	Log.print("SocketHandler 생성", 1, "log");
        }
        
        public int getSessionSetSize(){
        	return this.sessionSet.size();
        }
        
        public Project setting = null;
        
        public SampleDAO getSampleDAO(){
        	return sampleDAO;
        }
        @Override
        public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
            super.afterConnectionClosed(session, status);
            this.sessionSet.remove(session);
            Log.print("client disconnected ID closed:"+session.getId(), 0, "call");
        }

        @Override
        public void afterConnectionEstablished(WebSocketSession session) throws Exception {
            super.afterConnectionEstablished(session);
            sessionSet.add(session);
            Log.print("접속 추가 세션ID - " +sessionSet.size()+":" + session.getId(), 1 , "log");
            JSONObject obj=new JSONObject();
            obj.put("protocol", "doLogin");
            this.sendMessageToMe(session, obj);
            try {
			} catch (Exception e) {
				Log.print("afterConnectionEstablished err! "+e, 0, "err");
			}
        }
        
        @Override
        public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
            super.handleMessage(session, message);
            String msg = "" + message.getPayload();
            synchronized(msgList) {
            	msgList.add(new UserMsg(session,msg));
            }
        }
        
        public void rest(){
        	JSONObject obj = new JSONObject();
        	obj.put("protocol", "rest");
        	sendMessageAll(obj);
        }
        
        public void changeLeverage(WebSocketSession session, JSONObject obj){
        	Log.print("call changeLeverage", 5, "call");
        	int userIdx = Integer.parseInt(obj.get("userIdx").toString());
        	String symbol = obj.get("symbol").toString();
        	int newLeverage = Integer.parseInt(obj.get("leverage").toString());
        	int prevLeverage = Integer.parseInt(obj.get("prevLeverage").toString());
        	Position position = Position.getPosition(userIdx,symbol);
        	if(Copytrade.getCopytrade(userIdx, symbol) != null){
        		showPopup(userIdx, "copyLevFail", 2);
        		return;
        	}
        	
        	if(position != null){
        		if(position.marginType.equals("cross")){
            		showPopup(userIdx, "crossLevFail", 2);
            		return;
            	}
        	}
        	
        	/////오더 처리
        	JSONArray orderlist = new JSONArray();
        	ArrayList<Order> updateOrders = new ArrayList<>();
        	for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
        		Order order = iter.next();
    			if (order.userIdx == userIdx && order.symbol.compareTo(symbol) == 0) {
    				
    				if(order.marginType.equals("cross")){
    					showPopup(userIdx, "crossLevFail", 2);
    	        		return;
    				}
    				Order newOrder = new Order(String.valueOf(order.userIdx),
    						String.valueOf(order.symbol),
    						String.valueOf(order.orderType),
    						String.valueOf(order.position),
    						order.entryPrice,
    						order.buyQuantity,
    						String.valueOf(order.strategy),
    						String.valueOf(newLeverage),
    						String.valueOf(order.marginType),
    						String.valueOf(order.postOnly),
    						String.valueOf(order.auto),
    						String.valueOf(order.orderTime),
    						order.triggerPrice);
    				JSONObject tempOrder = new JSONObject();
    				tempOrder.put("orderNum", order.orderNum);
    				tempOrder.put("prevPaidVolume", order.paidVolume);
    				tempOrder.put("paidVolume", newOrder.paidVolume);
    				order.paidVolume = newOrder.paidVolume;
    				order.leverage = newLeverage;
    				orderlist.add(tempOrder);
    				updateOrders.add(order);
    			}
    		}
    		if(CointransService.getWithdrawWallet(userIdx, symbol).doubleValue() <= 0){
    			for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
            		Order order = iter.next();
        			if (order.userIdx == userIdx && order.symbol.compareTo(symbol) == 0) {
        				
        				Order newOrder = new Order(String.valueOf(order.userIdx),
    							String.valueOf(order.symbol),
    							String.valueOf(order.orderType),
    							String.valueOf(order.position),
    							order.entryPrice,
    							order.buyQuantity,
    							String.valueOf(order.strategy),
    							String.valueOf(prevLeverage),
    							String.valueOf(order.marginType),
    							String.valueOf(order.postOnly),
    							String.valueOf(order.auto),
    							String.valueOf(order.orderTime),
    							order.triggerPrice);
        				order.paidVolume = newOrder.paidVolume;
        				order.leverage = prevLeverage;
        			}
        		}
    			showPopup(userIdx, "notBalance", 2);
    			return;
    		}
        	for(Order o : updateOrders){
        		updateOrderDB(o);
        	}
        	
        	//////포지션 처리
        	boolean positionRebuy = false;
        	if(position != null){
            	String sposition = "long";
            	if(position.position.compareTo("long")==0)
            		sposition = "short";
            	Log.print("call changeLeverage c", 5, "call");

            	Coin coin = Coin.getCoinInfo(position.symbol);
            	double price = coin.getSise(sposition);
            	//판매
            	Trade trade = new Trade(position.member, symbol, "market" , sposition, position.buyQuantity, position.leverage, position.marginType);
            	buyMarket(position.member, trade, price, true, null);
            	Position.updateLiquidationPriceByUser(trade.userIdx, trade.symbol);
            	positionRebuy = true;
        	}
        	
        	JSONObject robj = new JSONObject();
    		robj.put("protocol", "changeLeverageStart");        				
    		robj.put("userIdx", userIdx);
    		if(positionRebuy) robj.put("position", position.position);
    		robj.put("leverage", newLeverage);
    		robj.put("positionRebuy", positionRebuy);
    		robj.put("orderList", orderlist);
    		sendMessageToMe(session, robj);
        }
        
        public void changeLeverageStart(WebSocketSession session, JSONObject obj){        
        	obj.put("protocol", "changeLeverageBuy");			
			sendMessageToMe(session, obj);
        }

		public void changeLeverage2(WebSocketSession session, JSONObject obj) {
			Log.print("call changeLeverage", 5, "call");
			int userIdx = Integer.parseInt(obj.get("userIdx").toString());
			String symbol = obj.get("symbol").toString();
			int newLeverage = Integer.parseInt(obj.get("leverage").toString());
			double Walletheck = 0;
			Position position = Position.getPosition(userIdx, symbol);
	
			if (position.leverage == newLeverage)
				return;
	
			// contractVolume 새레버리지로 규모 체크
			if (!Trade.maxContractVolumeCheck(userIdx, newLeverage, position.symbol, position.contractVolume, "leverage",
					position.position)) {
				return;
			}
	
			Position newPosition = null;
			if (position != null) {
				newPosition = new Position(position.symbol, position.position, position.entryPrice,
						position.buyQuantity, position.contractVolume, newLeverage, position.member, position.marginType,
						position.orderType, position.openFee);
				// Walletheck = Walletheck + newPosition.mainMargin +
				// newPosition.fee;//btc 포지션의 유지증거금+fee 만큼
				Walletheck = Walletheck + newPosition.fee;// btc 포지션의 유지증거금+fee 만큼
			}
			
			for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
        		Order order = iter.next();
				if (order.userIdx == userIdx && order.symbol.compareTo(symbol) == 0) {
					Order newOrder = new Order(String.valueOf(order.userIdx), String.valueOf(order.symbol),
							String.valueOf(order.orderType), String.valueOf(order.position),
							order.entryPrice, order.buyQuantity,
							String.valueOf(order.strategy), String.valueOf(newLeverage),
							String.valueOf(order.marginType), String.valueOf(order.postOnly),
							String.valueOf(order.auto), String.valueOf(order.orderTime), order.triggerPrice);
					BigDecimal newOrderPaidVolume = BigDecimal.valueOf(newOrder.paidVolume);
					Walletheck += newOrderPaidVolume.doubleValue();
				}
			}
			// 포지션 진입할돈도 없으면 레버리지 변경 못함, 레버리지를 줄이면 돈을 더 내야하니까 이때만 잔액을 체크 한다
			if (position.leverage > newLeverage
					&& Wallet.walletValidation(position.member, Walletheck, null, position.symbol) < 0) {
				Log.print("changeLeverage fail", 0, "changeLeverage");
				JSONObject robj = new JSONObject();
				robj.put("protocol", "changeLeverage");
				robj.put("userIdx", userIdx);
				robj.put("changeLeverage", "fail");
				sendMessageToMe(session, robj);
				return;
			}
	
			newPosition.updatePosition();// 포지션 레버리지 갱신
	
			for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
        		Order order = iter.next();
				if (order.userIdx == userIdx && order.symbol.compareTo(symbol) == 0) {
					Order newOrder = new Order(String.valueOf(order.userIdx), String.valueOf(order.symbol),
							String.valueOf(order.orderType), String.valueOf(order.position),
							order.entryPrice, order.buyQuantity,
							String.valueOf(order.strategy), String.valueOf(newLeverage),
							String.valueOf(order.marginType), String.valueOf(order.postOnly),
							String.valueOf(order.auto), String.valueOf(order.orderTime), order.triggerPrice);
					newOrder.orderNum = order.orderNum;
					
					
					orderList.set(SocketHandler.orderList.indexOf(order), newOrder);
					updateOrder(newOrder);
					Log.print(SocketHandler.orderList.indexOf(order) + "rd order's leverage changed", 0, "changeLeverage");

				}
			}
			Position.updateLiquidationPriceByUser(userIdx, symbol);
			Log.print("changeLeverage success", 0, "changeLeverage");
			JSONObject robj = new JSONObject();
			robj.put("protocol", "changeLeverage");
			robj.put("userIdx", userIdx);
			robj.put("changeLeverage", "success");
			sendMessageToMe(session, robj);
			// showPopup(userIdx, "<spring:message code='pop.show.changeLev'/>", 1);
			showPopup(userIdx, "changeLev", 1);
		}
        
        public void submitRequest(JSONObject obj){
        	JSONObject robj = new JSONObject();
        	robj.put("protocol", "InsertRequest");
        	sendMessageAll(robj);
        }
        public void newMember(JSONObject obj){
        	JSONObject robj = new JSONObject();
        	robj.put("protocol", "newMember");
        	sendMessageAll(robj);
        }
        
        public static Member getMemberByIdx(int userIdx, boolean nullReturn){
        	Member returnMember = null;
        	
        	synchronized (members) {
        		for (Iterator<Member> iter = members.iterator(); iter.hasNext(); ) {
        			Member mem = iter.next();
					if (mem.userIdx == userIdx) {
						returnMember = mem;
					}
				}
        	}
			
			if (returnMember == null && !nullReturn) {
				Log.print("getMemberByIdx is null! userIdx : "+userIdx, 0, "evt" );
				returnMember = Member.addMembers(String.valueOf(userIdx),null);
			}
			if (returnMember == null && !nullReturn) {
				Log.print("getMemberByIdx is null again! userIdx : "+userIdx, 0, "err" );
			}
			return returnMember;
		}
        
        public static double getMinValue(int fix){
        	double val = 1;
        	for(int i = 0; i < fix; i++){
        		val *= 0.1;
        	}
        	return val;
        }
        
		private void OnBuyBtn(WebSocketSession session, JSONObject obj){
			
        	try {
        		Log.print("---------------call OnBuyBtn---------------", 5, "call" );
        		Log.print("최종값 :"+obj.toJSONString(), 5, "qabuy");
        		Log.print("구매시작  구매타입:"+obj.get("orderType") +" 구매자index:"+obj.get("userIdx")+" position:"+obj.get("position") +" 코인:"+obj.get("symbol")+ " 구매수량:"+ obj.get("buyQuantity") +" 레버리지:"+ obj.get("leverage") +" 마진타입:"+ obj.get("marginType") , 5, "qabuy" );        		
        		
        		String symbol = obj.get("symbol").toString();
        		//코인제한
       		
        		if (symbol == null || symbol.compareTo("") == 0 || symbol.compareTo("null") == 0) {
        			Log.print("OnBuyBtn wrong try symbol : "+symbol, 0, "err" );
        			showPopup(Integer.parseInt(session.getAttributes().get("userIdx").toString()), "wrongSymbol", 2);
        			return;
        		}
        		        		
        		String userIdx = ""+obj.get("userIdx");
        		Map<String, Object> m = session.getAttributes();
        		String socketUserIdx = ""+m.get("userIdx");        		
        		if(userIdx.compareTo(socketUserIdx)!=0)	{
        			showPopup(Integer.parseInt(session.getAttributes().get("userIdx").toString()), "wrongUser", 2);
        			Log.print("잘못된 접속:"+userIdx+" "+socketUserIdx, 5, "qabuy" );
        			return;
        		}

        		Member user = Member.getMemberByIdx(Integer.parseInt(userIdx));
        		Log.print("userName = "+user.name, 1, "qabuy");
        		if(Member.isBanded(userIdx)) return; // 밴유저일경우
        		
        		if(Copytrade.getCopytrade(user.userIdx, symbol) != null){
            		showPopup(user.userIdx, "copyBuyFail", 2);
            		return;
            	}
        		
        		if(Project.isKyc() && !user.isKyc){
        			showPopup(user.userIdx, "kycPop", 2);
            		return;
        		}
        		
        		
        		String isLiqBuy = ""+obj.get("isLiqBuy");
        		if(obj.get("isLiqBuy") != null && isLiqBuy.compareTo("1")!=0){
        			showPopup(user.userIdx, "wrongOrderType", 2);
        			Log.print("isLiqBuy 없음:"+isLiqBuy, 5, "qabuy" );
        			return;        		
        		}
        			
        		Coin coin = Coin.getCoinInfo(symbol);
        		Log.print("코인 시세 :"+coin.getSise("long"), 5, "qabuy" );
        		double buyQuantity = PublicUtils.toFixed(Double.parseDouble(obj.get("buyQuantity").toString()), 5);
        		double min = PublicUtils.toFixed(getMinValue(coin.qtyFixed),coin.qtyFixed);
        		if(buyQuantity < min){
        			showPopup(user.userIdx, "wrongQuantity", 2);
        			Log.print("buyQuantity 없음 :"+buyQuantity, 5, "qabuy" );
        			return;
        		}

        		String orderType = ""+obj.get("orderType");
        		if(orderType.compareTo("market")!=0 && orderType.compareTo("limit")!=0
        				&& orderType.compareTo("stopMarket")!=0 && orderType.compareTo("stopLimit")!=0){
        			showPopup(user.userIdx, "wrongOrderType", 2);
        			Log.print("orderType 없음 :"+orderType, 5, "qabuy" );
        			return;
        		}
        		
        		if(orderType.compareTo("stopLimit") == 0){
        			Log.print("stopLimit 배팅불가", 5, "qabuy" );
        			return;
        		}
        		
        		String position = ""+obj.get("position");        		
        		if(position.compareTo("long")!=0 && position.compareTo("short")!=0)	{
        			showPopup(user.userIdx, "wrongPosition", 2);
        			Log.print("position 없음 :"+position, 5, "qabuy" );
        			return;
        		}

        		String leverage = ""+obj.get("leverage");
        		if(leverage.compareTo("")==0)	{
        			showPopup(user.userIdx, "wrongLeverage", 2);
        			Log.print("leverage 없음 :"+leverage, 5, "qabuy" );
        			return;
        		}        		
        		
        		String auto = ""+obj.get("auto");
        		if(auto.compareTo("")==0)	{
        			showPopup(user.userIdx, "wrongAuto", 2);
        			Log.print("auto 없음 :"+auto, 5, "qabuy" );
        			return;
        		}
        		
        		String postOnly = ""+obj.get("postOnly");
        		if(postOnly.compareTo("")==0)	{
        			showPopup(user.userIdx, "wrongPostOnly", 2);
        			Log.print("postOnly 없음 :"+postOnly, 5, "qabuy" );
        			return;
        		}
        		
        		double entryPrice = PublicUtils.toFixed(Double.parseDouble(obj.get("entryPrice").toString()), coin.priceFixed);
        		if(entryPrice < 0 || entryPrice < getMinValue(coin.priceFixed))	{
        			showPopup(user.userIdx, "wrongEntryPrice", 2);
        			Log.print("entryPrice 없음 :"+entryPrice, 5, "qabuy" );
        			return;
        		}
        		
        		String triggerPrice = ""+obj.get("triggerPrice");
        		if(triggerPrice.compareTo("")==0)	{
        			showPopup(Integer.parseInt(session.getAttributes().get("userIdx").toString()), "wrongTriggerPrice", 2);
        			Log.print("triggerPrice 없음 :"+triggerPrice, 5, "qabuy" );
        			return;
        		}
        		
        		String marginType = ""+obj.get("marginType");
        		if(marginType.compareTo("cross")!=0 && marginType.compareTo("iso")!=0)	{
        			showPopup(user.userIdx, "wrongMarginType", 2);
        			Log.print("marginType 없음 :"+marginType, 5, "qabuy" );
        			return;
        		}  
        		if(user.p2pCheck()){
        			showPopup(user.userIdx, "p2pStop", 2);
        			Log.print("진행중 P2P 있음", 5, "qabuy" );
        			return;
        		}
        		String isLiq = ""+obj.get("isLiqBuy");
        		if( obj.get("isLiqBuy") == null)
        			isLiq = null;
    				
        		if(orderType.compareTo("market") == 0){        			
        			// 시장가 일 때
        			Trade trade = new Trade(user, obj.get("symbol").toString(), orderType, obj.get("position").toString(), buyQuantity, obj.get("leverage").toString(), obj.get("marginType").toString());
        			buyMarket(user, trade, 0.0, false, isLiq);
        			if(obj.get("addTPSL") != null && Boolean.parseBoolean(obj.get("addTPSL").toString())){
        				obj.put("protocol", "setTPSL");
        				setTPSL(session,obj);
        			}
        		}else if(orderType.compareTo("limit") == 0 || orderType.compareTo("stopLimit") == 0 || orderType.compareTo("stopMarket") == 0){        			
        			// 지정가, 스탑 일 때
        			registerOrder(session, user, obj);
        		}else{
        			Log.print("protocol orderType err! orderType : "+orderType, 0, "err" );
        		}
			} catch (Exception e) {
				Log.print("OnBuyBtn err! "+e, 0, "err" );
			}
        }
		
		private void setTPSL(WebSocketSession session, JSONObject obj){
        	try {
        		Log.print("---------------call setTPSL---------------", 5, "call" );
        		Log.print("유저 :"+obj.get("userIdx")+" 심볼:"+obj.get("symbol")+ " TP Price :"+ obj.get("tpPrice")+ " SL Price :"+ obj.get("slPrice"), 5, "qabuy" );        		
        		String symbol = obj.get("symbol").toString();
        		//코인제한

        		String userIdx = ""+obj.get("userIdx");
        		Map<String, Object> m = session.getAttributes();
        		String socketUserIdx = ""+m.get("userIdx");        		
        		if(userIdx.compareTo(socketUserIdx)!=0)	{
        			showPopup(Integer.parseInt(session.getAttributes().get("userIdx").toString()), "wrongUser", 2);
        			Log.print("잘못된 접속:"+userIdx+" "+socketUserIdx, 5, "qabuy" );
        			return;
        		}
        		Member user = Member.getMemberByIdx(Integer.parseInt(userIdx));
        		if(Member.isBanded(userIdx)) return; // 밴유저일경우
        		Position pos = Position.getPosition(user.userIdx, symbol);
        		
        		if(pos == null){
        			return;
        		}
        		Coin coin = Coin.getCoinInfo(symbol);
        		double sise = coin.getSise(pos.position);
        		if(sise == -1)
        			return;
        		
        		Double tpPrice = Double.parseDouble(""+obj.get("tpPrice"));
        		Double slPrice = Double.parseDouble(""+obj.get("slPrice"));
        		if(tpPrice == 0) tpPrice = null;
        		if(slPrice == 0) slPrice = null;
        		
        		if(pos.position.equals("long")){
        			if(tpPrice != null && tpPrice <= sise){
        				showPopup(user.userIdx, "TPErr_more", 2);
        				return;
        			}
        			if(slPrice != null && slPrice >= sise){
        				showPopup(user.userIdx, "SLErr_less", 2);
        				return;
        			}
        		}else{
        			if(tpPrice != null && tpPrice >= sise){
        				showPopup(user.userIdx, "TPErr_less", 2);
        				return;
        			}
        			if(slPrice != null && slPrice <= sise){
        				showPopup(user.userIdx, "SLErr_more", 2);
        				return;
        			}
        		}
        		
        		pos.useTPSL(TPSLType.TP, tpPrice);
        		pos.useTPSL(TPSLType.SL, slPrice);
        		
        		JSONObject sobj = new JSONObject();
        		sobj.put("protocol", "updateTPSL");
        		sobj.put("userIdx", user.userIdx);
        		sobj.put("tpPrice", tpPrice);
        		sobj.put("slPrice", slPrice);
        		sobj.put("symbol", symbol);
        		sendMessageToMeAllBrowser(sobj);
        		
        		showPopup(user.userIdx, "registComplete", 1);
        		
			} catch (Exception e) {
				Log.print("setTPSL err! "+e, 0, "err" );
			}
        }
        
        private void OnLogin(WebSocketSession session, JSONObject obj){
        	Log.print("call login", 5, "call" );
        	try {
        		String userIdx = obj.get("userIdx").toString();
        		String game = "futures";//""+obj.get("game");        		
        		Map<String, Object> m = session.getAttributes();
        		m.put("userIdx", userIdx);
        		m.put("game", game);
    			Log.print("login success userIdx = "+m.get("userIdx"), 0, "log" );
    			Log.print("로그인 세션ID - " + session.getId(), 1 , "log");
    			
    			Member mem = Member.getMemberByIdx(Integer.parseInt(userIdx));
    			if(mem == null){
    				Log.print("DB, 메모리 정보 없는 유저 로그인시도. userIdx = "+userIdx, 1, "err");
    				return;
    			}
    			this.logger.info("add session!");
        			
			} catch (Exception e) {
				Log.print("login msg err! - "+e, 0, "err" );
			}
        }
        
        public String manipulation(JSONObject obj){
        	Log.print("call manipulateValue"+obj.get("price"), 5, "call" );
    		Coin coin = Coin.getCoinInfo(""+obj.get("symbol"));
    		double gap = Double.parseDouble(""+obj.get("gap"));
    		if (coin.mStatus != "-1") {
    			return "진행 중인 코인은 중복 실행이 불가능합니다.";
    		}
//    		if(gap > 0.3 || gap <= 0) {
//    			return "변동가는 0.3까지 입력 가능합니다.";
//    		}
        	try {
    			obj.put("protocol", "manipulateValue");
    			sise.sendSiseServer(obj);
    			coin.mStatus = "0";
    			coin.mGap = ""+obj.get("gap");
    			coin.mPrice = ""+obj.get("price");
    			return "true";
    		} catch (Exception e) {
    			Log.print("manipulation msg err! - "+e, 0, "err" );
    			return "오류가 발생했습니다. 다시 시도해 주세요.";
    		}
        }
        
        public void endManipulation(JSONObject obj){
        	Log.print("call endManipulateValue"+obj.get("symbol"), 5, "call" );
        	Coin coin = Coin.getCoinInfo(""+obj.get("symbol"));
    		if (coin.mStatus == "-1") {
    			return;
    		}
        	try {
        		coin.mStatus = "-1";
        		coin.mGap = "";
    			coin.mPrice = "";
    		} catch (Exception e) {
    			Log.print("endManipulation msg err! - "+e, 0, "err" );
    		}
        }
        
        public String resetChart() {
        	Log.print("call resetChart", 5, "call" );
        	JSONObject obj = new JSONObject();
    		obj.put("protocol", "reC");
        	try{
        		sendMessageAll(obj);
        		return "차트 초기화 완료되었습니다.";
        	}catch (Exception e) {
        		Log.print("resetChart msg err! - "+e, 0, "err" );
        		return "오류가 발생했습니다. 다시 시도해 주세요.";
        	}
        }
        
        public String resetMStatus() {
        	for(Coin coin : Project.getUseCoinList()){
        		coin.mStatus = "-1";
        	}
        	Log.print("call resetMStatus", 5, "call" );
        	return "true";
        }
        
        public String getMList() {
        	String mList = "";
        	
        	for(Coin coin : Project.getUseCoinList()){
        		if ( coin.mStatus != "-1" ) {
        			mList += coin.coinName+" (목표:"+coin.mPrice+" 변동:"+coin.mGap+")　";
        		}
        	}
        	return mList;
        }
        
        private void OnAdminLogin(WebSocketSession session, JSONObject obj){
        	Log.print("call adminLogin", 5, "call" );
    		Map<String, Object> m = session.getAttributes();
    		m.put("adminLogin", 1);
			this.logger.info("add session!");
        }
        
        private void sendLinePacket(WebSocketSession session, JSONObject obj){
        	Log.print("call sendLinePacket", 5, "call" );
        	try {
				initToUser(session, obj);
				this.logger.info("add session!");        		
			} catch (Exception e) {
				Log.print("login msg err! - "+e, 0, "err" );
			}
        }

        public void cancelAllOrder(JSONObject obj){
        	Log.print("call cancelAllOrder", 5, "call" );
        	try {
        		int userIdx = Integer.parseInt(obj.get("userIdx").toString());
        		
        		JSONObject objServer = new JSONObject();
        		objServer.put("protocol", "cancelAllOrder");
        		objServer.put("userIdx", userIdx );
        		JSONArray j = new JSONArray();
        		
        		String symbol = obj.get("symbol").toString();
        		objServer.put("symbol", symbol );
        		for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
    				Order order = iter.next();
    				if (order.symbol.compareTo(symbol) == 0 && order.userIdx == userIdx) {   
    					Coin coin = Coin.getCoinInfo(order.symbol);
//    					Hoga hoga = new Hoga(order.buyQuantity, order.entryPrice, coin, order.position);
//    					hoga.removeHoga();
    					order.updateOrderState("cancel");  
    					JSONObject item = new JSONObject();  
    					item.put("userIdx", order.userIdx);
    					item.put("orderNum", order.orderNum);
                		j.add(item);  
                		iter.remove();
    				}
    			}
        		Position.updateLiquidationPriceByUser(userIdx, symbol);
        		objServer.put("glist", j);
        	
        		removeTradeTriggerForOrderAllCancel(userIdx, symbol); // 트리거 목록에서 제거        		
        		sise.sendSiseServer(objServer);
        		
        		sendMessageToMeAllBrowser(objServer);
			} catch (Exception e) {
				Log.print("cancelAllOrder err! "+e+" / "+obj, 0, "err" );
			}
        }

        public void cancelOrder(JSONObject obj) {
        	Log.print("call cancelOrder", 5, "call" );
        	try {
        		int userIdx = Integer.parseInt(obj.get("userIdx").toString());
        		String orderNum = obj.get("orderNum").toString();
        		int idx = Order.getOrderIdxByOrderNum(orderNum);
				if (idx < 0) { return; }
				Order order = orderList.get(idx);
								
				Coin coin = Coin.getCoinInfo(order.symbol);
//				Hoga hoga = new Hoga(order.buyQuantity, order.entryPrice, coin, order.position);
//				hoga.removeHoga();
								
				showPopup(userIdx, "orderCancel", 3);
				order.updateOrderState("cancel");
				order.sendRemoveOrder();
        		TradeTrigger.removeTradeTriggerByOrderNum(orderNum); // 트리거 목록에서 제거
        		orderList.remove(idx);
        		Position.updateLiquidationPriceByUser(userIdx, order.symbol);
			} catch (Exception e) {
				Log.print("cancelOrder err! "+e+" / "+obj, 0, "err" );
			}
		}
        
        // 0 : 기존 포지션 없음,  2 : 호출한 오더가 수량이 남는 경우, tradetrigger 남는 경우  
        public int buyPositionCheck(Member user, Trade trade, boolean leverChange){
        	try {        		
        		Log.print("call buyPositionCheck trade", 5, "call");
        		Position oldPosition = Position.getPosition(trade.userIdx, trade.symbol);

        		
        		if(oldPosition != null && oldPosition.buyQuantity > 0){         			
        			
        			// 반대 포지션일 때
        			if(oldPosition.position.compareTo(trade.position) != 0){
        				Log.print("반대 포지션", 5, "qabuy");
        				//카피트레이딩 전체 청산
        				Copytrade.followLiq(trade.userIdx, trade.symbol);
        				if (oldPosition.buyQuantity < trade.buyQuantity ) {
        					Log.print("새로운 반대 포지션이 더 많음 = 청산 후 추가 구매", 5, "qabuy");
        					// 반대 포지션의 양이 더 많을 때
        					// 포지션 전부 청산 후 반대 포지션 새 구매
        					sellMarket(oldPosition, trade.orderType, leverChange, null);

        					//전체 주문 취소 
        					JSONObject obj = new JSONObject();
        					obj.put("userIdx", trade.userIdx);
        					obj.put("symbol", trade.symbol);
        					cancelAllOrder(obj);
        					
//        					새 구매 수량 = 구매 수량 -기존 구매 수량
        					double newBuyQuantity = BigDecimal.valueOf(trade.buyQuantity).subtract(BigDecimal.valueOf(oldPosition.buyQuantity)).doubleValue();
        					Trade newTrade = new Trade(trade.orderNum, trade.userIdx, trade.symbol, trade.orderType, trade.position, newBuyQuantity, trade.leverage, trade.marginType);
        					buyMarket(user, newTrade, 0.0, false, null);
        					Log.print("buyPositionCheck is false", 0, "buyPositionCheck");
        					return 1;
        				}else if (oldPosition.buyQuantity == trade.buyQuantity ) {
        					Log.print("새로운 반대 포지션과 양 같음 = 포지션 청산", 0, "buyPositionCheck");
        					// 포지션 양이 같을 때
        					// 포지션 전부 청산
        					sellMarket(oldPosition, trade.orderType, leverChange, null);// 청산수수료 안내고 새거래의 진입 수수료내야함
        					
        					
        					liqOrderAllCancel(trade.userIdx, trade.symbol,"");	// 모든 청산 주문 취소		
        					Log.print("buyPositionCheck is false", 0, "buyPositionCheck");
        					return 1;
        				}else if (oldPosition.buyQuantity > trade.buyQuantity ) {
        					Log.print("새로운 반대 포지션이 더 적음 = 포지션 부분 청산", 0, "buyPositionCheck");
        					// 반대 포지션의 양이 더 적을 때
        					// 포지션 부분 청산
        					Coin coin = Coin.getCoinInfo(trade.symbol);
        					sellMarketPart(trade, PublicUtils.toFixed(trade.buyQuantity, coin.qtyFixed), trade.orderType);// 청산수수료 안내고 새거래의 진입 수수료내야함
        					liqOrderSync(trade.userIdx, trade.symbol, oldPosition.buyQuantity, trade.buyQuantity, trade.position);
        					Log.print("buyPositionCheck is false", 0, "buyPositionCheck");
        					return 2;
        				}
        			}else{
        				Log.print("same position", 0, "buyPositionCheck");
        			}
        		}else{
        			Log.print("oldPosition is null", 0, "buyPositionCheck" );
        			return 0;
        		}
        		return 0;
			} catch (Exception e) {
				Log.print("buyPositionCheck trade 있어서는 안되는 err! "+e, 0, "err" );
				return 3;//예외상황
			}
        }
        public boolean buyPositionCheckLimit(WebSocketSession session, Order order){
        	try {
        		Position oldPosition = Position.getPosition(order.userIdx, order.symbol);
        		if(oldPosition != null && oldPosition.buyQuantity > 0){         		
        			// 반대 포지션일 때
        			if(oldPosition.position.compareTo(order.position) != 0){
        				//트레이더 주문실행시 청산되었을때 팔로워 전체청산시킬 부분
        				Copytrade.followLiq(order.userIdx, order.symbol);
        				if (oldPosition.buyQuantity < order.buyQuantity ) {
        					Log.print("포지션 전환  시작", 0, "buyLimit");     
        					// 반대 포지션의 양이 더 많을 때
        					// 포지션 전부 청산 후 반대 포지션 새 구매
        					Log.print("포지션 전부 판매", 0, "buyLimit");        					
        					sellLimit(order, order.entryPrice);
        					// 새 구매 수량 = 구매 수량 -기존 구매 수량         기존보유포지션1개  추가주문수량10개    10-1 = 9 남은 주문수량
        					double newBuyQuantity = BigDecimal.valueOf(order.buyQuantity).subtract(BigDecimal.valueOf(oldPosition.buyQuantity)).doubleValue();
        					order.buyQuantity = newBuyQuantity;
        					order.paidVolume = order.getPaidVolume();        					
        					Log.print("주문포지션 구매", 0, "buyLimit");         					        					
        					buyLimitAll(session, order, order.entryPrice);
        					Log.print("buyPositionCheck is false", 6, "log");
        					return false;
        				}else {
        					// 포지션 양이 같거나 적을 때
        					// 포지션 전부 청산  or 일부청산
        					sellLimit(order, order.entryPrice);
        					Log.print("buyPositionCheck is false", 6, "log");
        					return false;
    					}        				
        			}
        		}else{
        			Log.print("oldPosition is null", 0, "buyPositionCheck" );
        			return true;
        		}
        		return true;
			} catch (Exception e) {
				Log.print("buyPositionCheck order err! "+e, 0, "err" );
				return false;
			}
        }
        
        //true :호출한 트리거를 삭제한다, false :호출한 트리거를 삭제하지않는다(특수)
		public boolean buyMarket(Member user, Trade trade, Double entryPriceTmp, boolean leverChange, String isLiq){ // 포지션 구매
        	try {
        		Log.print("call buyMarket - trade", 5, "call");    
        		// 재구매 여부
        		int rt = buyPositionCheck(user, trade, leverChange);
        		if( rt != 0){
        			Log.print("-------------포지션 이미  존재 구매완료------------- ", 5, "buyMarket" );
        			if( rt == 2 )
        				return false;//buyMarket 호출한 tradetrigger 삭제하면 안됨
        			return true;//buyMarket 호출한 tradetrigger 삭제
        		}else if(isLiq != null){
        			Log.print("------------"+user.userIdx+" 유저 청산주문이지만 포지션 없음. 시장가주문 종료------------- ", 5, "buyMarket" );
        			return false;
        		}
        		Coin coin = Coin.getCoinInfo(trade.symbol);
        		
        		// 수량 시스템
        		// 가격 계산하기
        		BigDecimal buyQuantity = BigDecimal.valueOf(trade.buyQuantity); // 실 구매 수량
        		BigDecimal volume = BigDecimal.ZERO;
        		double entryPrice = entryPriceTmp; // 진입 가격
        		
        		BigDecimal price = BigDecimal.ZERO; // 시세 가격
        		
        		Log.print("Market 구매 종목:"+trade.symbol+" position = "+trade.position,	0, "buyMarket");
        		double sise = coin.getTailSise(trade.position);
        		if(sise == -1)
        			return true;
        		
        		price = BigDecimal.valueOf(sise);
        		
        		volume = price.multiply(buyQuantity); 
        		if(entryPriceTmp <= 0.0)
        			entryPrice = price.doubleValue();
        		
				// 구매
				if (buyProcess(user, trade, volume, entryPrice, null, null) == false) {
					Log.print("buyProcess == false : 잔액 부족", 0, "buyMarket");					
					return true;
				}
				//진입, 카피트레이딩 시장가 구매 
				Copytrade.followBuy(user.userIdx, trade.symbol, trade.position, trade.leverage, sise);
			} catch (Exception e) {
				Log.print("buyMarket err! "+e, 0, "err");
			}
			return true;
        	
        }
		
		public boolean buyProcess(Member trader, Trade trade, BigDecimal contractVolume, double entryPrice, Order order, Copytrade copy) {
			try {
				Log.print("call buyProcess sise:"+entryPrice, 5, "call");
				Coin coin = Coin.getCoinInfo(trade.symbol);
				if (Trade.maxContractVolumeCheck(trade.userIdx, trade.leverage, trade.symbol, contractVolume.doubleValue(), "buy", trade.position) == false) {
					Log.print("구매 실패 maxContractVolumeCheck == false", 0, "buyProcess");
					
					if(copy != null){
						copy.maxQty = true;
					}
					return false;
				}
				
				BigDecimal feeRate = Project.getFeeRate(trader, trade.orderType);// 수수료
				BigDecimal openfee = contractVolume.multiply(feeRate);//진입수수료
				
				
				double prevMoney = trader.wallet;
				if(CointransService.isInverse(trade.symbol)){
					prevMoney = trader.getWalletC(trade.symbol);
					openfee = CointransService.coinTrans(openfee, coin);
				}
				
				
				Log.print("openfee = "+openfee, 1, "buyProcess");
				Position position = new Position(trade.symbol, trade.position, entryPrice, trade.buyQuantity, contractVolume.doubleValue(), trade.leverage, trader, trade.marginType, trade.orderType, openfee.doubleValue());								
				if(copy != null){
					if(!copy.positionQtyCheck(position.position,position.fee)){
						return false;
					}
				}
				trader.dangerCheck(position.symbol, openfee.doubleValue() + position.fee);

				BigDecimal validationAmount = BigDecimal.valueOf(position.fee);
				Log.print("feeRate:"+feeRate.doubleValue()+" 규모:"+contractVolume.doubleValue()+" 차감되는 진입수수료:"+openfee.doubleValue()+" 필요한돈(fee): "+validationAmount.doubleValue(), 0, "buyProcess");				
				Log.print("구매 시 위탁 금액:"+validationAmount.doubleValue()+" 구매 시 수수료:"+openfee, 0, "qabuy");
				// walletValidation
				double wallet = Wallet.walletValidation(trader, validationAmount.doubleValue(), order, trade.symbol);
				Log.print("지갑 잔액체크 walletValidation wallet 출금가능잔고(디비지갑 - (유지증거금+fee+profit 주문 포지션)) = "+wallet, 0, "buyProcess");
				if (wallet < 0) {
					Log.print("지갑 잔액 체크 실패 : buyProcess is false", 0, "buyProcess");
					//showPopup(trade.userIdx, "<spring:message code='pop.transfer.notBalance'/>", 2);
					return false;
				}
				//진입수수료 갱신 				
				//trader.resetSum(openfee.doubleValue(), 0, 0);
				
				// 뺄 돈 = 진입 수수료만 빠진다.				
				double nowMoney = Wallet.updateWalletAmountSubtract(trader, openfee.doubleValue(), trade.symbol, "trade");
				Log.print("산직후 금액(진입수수료만 빠진 금액):"+nowMoney, 0, "changeLeverage");
				// 수수료 떼어주기
				BigDecimal adminProfit = Referral.accumPileFee(trader,contractVolume.doubleValue(),position.symbol,openfee,trade.orderNum);
				
				// position 창에 보내주기
				position.inPosition(trade.orderNum);
				
				Position.updateLiquidationPriceByUser(trader.userIdx, position.symbol);
				// trade log DB에 넣기
				trade.insertTradeLog(openfee.doubleValue(), entryPrice, 0, 0, adminProfit, true, 0, trade.marginType);
        		if(copy != null){
        			copy.updateFollowMoney(openfee.doubleValue());
        			Copytrade.updateCopytrade(copy);
        			copy.setPosition();
        			copy.insertCopytradeLog(null, CopytradeKind.BUY);
        		}
        		
        		showPopup(trade.userIdx, "buyPos", 1);
        		Log.print("구매 완료. 거래전 지갑 잔액 "+prevMoney+" , 거래후 지갑 잔액 "+nowMoney, 5, "qabuy" );
        		return true;
			} catch (Exception e) {
				Log.print("buyProcess err! "+e, 0, "err");
				return false;
			}
		}
		
		public void buyMarketTrigger(TradeTrigger tradeTrigger){ // 자동 포지션 구매 - 트리거 발동        	
        	// 주문 가져오기
			int orderIdx = Order.getOrderIdxByOrderNum(tradeTrigger.orderNum);
			if (orderIdx < 0) { return; }
			Log.print("orderIdx = "+orderIdx, 0, "buyStopMarket");
			Order order = orderList.get(orderIdx);			
        	// 시장가 주문
    		Trade trade = new Trade(order.getMember(), order.symbol, "market", order.position, order.buyQuantity, order.leverage, order.marginType);
    		// 스탑 흔적 삭제
    		showPopup(order.userIdx, "orderRun", 1);
    		order.updateOrderState("ordered"); // 주문 처리 (돈이 부족해서 주문 취소 되었을때도 포함됨 : 강제로 포인트를 뺏을경우 이러함.)
    		order.removeOrderList(); // 주문 목록에서 삭제
    		//트리거에서 제거 해야되는데 이걸 안한거 같다.. 디비랑 메모리 둘다 해야될듯!!!!!    	

    		if( buyMarket(order.getMember(), trade, 0.0, false, null) == true){
    			//삭제.
    			removeTradeTriggerByTriggerTypeByBuyMarketTrigger(tradeTrigger.userIdx, tradeTrigger.symbol, tradeTrigger.triggerType, tradeTrigger.orderNum);
    		}
    		Position.updateLiquidationPriceByUser(order.userIdx, order.symbol);
        }
		
		public void buyLimitTrigger(TradeTrigger tradeTrigger){ // 자동 포지션 구매 - 트리거 발동
			Log.print("---------------------지정가 구매 시작", 5, "buyLimit");
			// 주문 가져오기
			int orderIdx = Order.getOrderIdxByOrderNum(tradeTrigger.orderNum);
			if(orderIdx == -1){
				Log.print("문제있는오더 tradeTrigger 삭제", 1, "err");
				tradeTrigger.removeTradeTriggerInDB();
				return;
			}
			
			Order order = orderList.get(orderIdx);
			if (orderIdx < 0) { return; }
			
			WebSocketSession session = GetSession(""+tradeTrigger.userIdx);
			if(buyPositionCheckLimit(session, order) == false){
				Log.print("buyPositionCheck == false", 0, "buyLimit");
				//showPopup(trade.userIdx, "<spring:message code='pop.transfer.notBalance'/>", 2);
				return;
			}
			buyLimitAll(session, order, order.entryPrice);	
		}
		
		public void buyLimitAll(WebSocketSession session, Order order, double sise){ // 가격 지정 주문
			try {
				// 취소할 때까지 계속 주문 유지
				Log.print("call buyLimitAll", 5, "buyLimit");		
				
				Coin coin = Coin.getCoinInfo(order.symbol);
        		
				BigDecimal price = BigDecimal.valueOf(sise);
				BigDecimal volume = BigDecimal.ZERO;  // 계약 USDT
				BigDecimal newBuyQuantity = BigDecimal.valueOf(order.buyQuantity);
				Log.print("newBuyQuantity = "+order.buyQuantity, 0, "buyLimit");
				volume = price.multiply(newBuyQuantity); // 총액 = 시세 수량 * 시세
				Log.print("volume = "+volume, 0, "buyLimit");
				showPopup(order.userIdx, "orderRun", 1);
				//구매 로직
				Trade trade = new Trade(order.getMember(), order.symbol, order.orderType, order.position, newBuyQuantity.doubleValue(), order.leverage, order.marginType);
				if (buyProcess(order.getMember(), trade, volume, price.doubleValue(), order, null) == false) {
					Log.print("buyProcess(trade, volume, price.doubleValue()) == false", 0, "buyLimit");
					showPopup(trade.userIdx, "nonBalanceCancel", 2);
					orderFail(order, "balanceCancle");
					return;
				}
//				Hoga hoga = new Hoga(order.buyQuantity, order.entryPrice, coin, order.position);
//				hoga.removeHoga();
				order.updateOrderState("ordered");
				order.removeOrderList();
				Position.updateLiquidationPriceByUser(order.userIdx, order.symbol);
				//진입, 트레이더 주문실행. 
				Copytrade.followBuy(trade.userIdx, trade.symbol, trade.position, trade.leverage, sise);
				Log.print("update order", 0, "buyLimit");
			} catch (Exception e) {
				Log.print("buyLimitGTC err! "+e, 0, "err");
			}
		}		
		
		private void sellMarketTrigger(TradeTrigger trigger, double sise){ // 강제 청산
			Log.print("trigger.position = "+trigger.position, 0, "liquidation");
			Log.print("trigger.triggerPrice = "+trigger.triggerPrice, 0, "liquidation");
			Liquid(trigger.userIdx, trigger.symbol, "", sise);
			Copytrade.followLiq(trigger.userIdx, trigger.symbol);
		}
		
		 //강제청산
		public void Liquid(int userIdx, String symbol, String newOrderType, double sise){
	    	Log.print("--call liquid--", 5, "liquid");
	    	try {
	    		// 포지션 가져오기
	        	Position position = Position.getPosition(userIdx, symbol);
	        	if (position == null) {
					Log.print("position is null", 0, "err");
					return;
				}
	        	
	        	double profit = 0;
	        	if(position.position.equals("long")){
	        		profit = (sise * position.buyQuantity) - (position.contractVolume);
	        	}else{
	        		profit = (position.contractVolume) - (sise * position.buyQuantity);
	        	}
	        	if(CointransService.isInverse(symbol)){
	        		profit = profit / sise;
	        	}
	        	Log.print("강제 청산 발생!! 코인명 = "+position.symbol+" / 레버리지 "+position.leverage+" / 손실 % = "+((profit/position.fee)*100), 1, "test");
				Member trader = Member.getMemberByIdx(userIdx);
				
	        	// tradelog
	        	String sellPosition = "";
	        	if (position.position.compareTo("long") == 0) {
	        		sellPosition = "short";
				}else if (position.position.compareTo("short") == 0) {
	        		sellPosition = "long";
	        	}else{
	        		Log.print("sellPosition err! position = "+position.position, 0, "err");
	        		return;
	        	}
	        	
	        	// 수수료
	        	BigDecimal feetmp = BigDecimal.ONE.subtract(BigDecimal.ONE.divide(BigDecimal.valueOf(position.leverage), 8, BigDecimal.ROUND_HALF_DOWN)); 
	        	BigDecimal fee = BigDecimal.valueOf(position.contractVolume).multiply(feetmp).multiply(Project.getFeeRate(trader, "market"));   		        		        		        	
	        	Coin coin = Coin.getCoinInfo(symbol);
	        	if(CointransService.isInverse(symbol)){
	        		fee = CointransService.coinTrans(fee, coin);	        	
	        	}
	        	
	        	position.liqFee += fee.doubleValue();
				//청산금액 격리   fee(개시증거금+ 파산가격수수료)
				BigDecimal liquidP = BigDecimal.valueOf(position.fee);
				//청산금액 교차일떄는 유지증거금 뺴고 전부 뺀다.				
				if (position.marginType.compareTo("cross") == 0){
					//liquidP = new BigDecimal(trader.wallet).multiply( new BigDecimal(0.994) );
					liquidP = liquidP.add(CointransService.getWithdrawWallet(userIdx, symbol)); // 청산 포지션 증거금 + 사용가능금액만 뺌.
				}
				if(liquidP.doubleValue()<0) {
					liquidP = liquidP.multiply(BigDecimal.valueOf(-1));					
				}
				
	        	Trade trade = new Trade(position.member, position.symbol, "market", sellPosition, position.buyQuantity, position.leverage, position.marginType);
	        	
	        	BigDecimal adminProfit = Referral.accumPileFee(trader,position.contractVolume,position.symbol,fee,trade.orderNum);
	        	adminProfit = adminProfit.add(Referral.accumPile(trader,position.contractVolume,position.symbol,liquidP.multiply(BigDecimal.valueOf(-1)),trade.orderNum,true));
	        	
	        	//trader.resetSum(liquidP.doubleValue(), 0, 0);
	        	trader.liqAlert(position,-liquidP.doubleValue(), sise);
	        	
	        	//tradelog 에 pnl값 - 로 기록
	        	BigDecimal tmpLiquidP = liquidP;
	        	BigDecimal minusQty = BigDecimal.valueOf(-1);
	        	tmpLiquidP = tmpLiquidP.multiply(minusQty);
	        	trade.insertTradeLog(fee.doubleValue(), sise, tmpLiquidP.doubleValue(),position.fee,adminProfit, false, sise, trade.marginType);
	        	
	        	//청산금액 차감
	        	if(Project.isLiqFee())
					liquidP = liquidP.add(fee);
	        	Wallet.updateWalletAmountSubtract(trader, liquidP.doubleValue(), position.symbol, "liquid");	   

	        	Copytrade copy = Copytrade.getCopytrade(userIdx, symbol);
	        	if(copy != null){
	        		copy.updateFollowMoney(fee.doubleValue());
	        		copy.updateProfit(-position.fee);
	        		Copytrade.updateCopytrade(copy);
	        		copy.insertCopytradeLog(CopytradeKind.LIQ);
	        		copy.position = null;
	        	}
	        	
	        	// 포지션에서 지우기
	        	removePosition(position, false);	        		
	        	
	        	Position.updateLiquidationPriceByUser(userIdx, symbol);
	        	JSONObject obj = new JSONObject();
	        	obj.put("useridx", userIdx);
	        	obj.put("symbol", symbol);
	        	liqOrderAllCancel(userIdx, symbol, "");
//	        	Copytrade.followLiq(trade.userIdx, trade.symbol);
			} catch (Exception e) {
				Log.print("sellMarket err! "+e, 0, "err");
			}
	    }
		
		public void sellMarket(Position position, String newOrderType, boolean leverChange, Copytrade copy){ // 시장가 청산			
//	    	Log.print("--call sellMarket--", 5, "sellMarket");
	    	try {
	        	// 수익 계산
	    		BigDecimal quantity = BigDecimal.valueOf(position.buyQuantity); // 판매 대기 수량 - 구매 수량 계산 필요 변수
//	    		BigDecimal siseQuantity = BigDecimal.ZERO;
//	    		BigDecimal sisePrice = BigDecimal.ZERO;
	    		BigDecimal volume = BigDecimal.ZERO;
	    		
	    		Coin coin = Coin.getCoinInfo(position.symbol);
	    		double sise = coin.getSise(position.position);
	    		if(sise == -1)
	    			return;
	    		
	    		volume = volume.add(quantity.multiply(BigDecimal.valueOf(sise))); // 총액 = 구매 대기 수량 * 시세	    				
//	        	int i = 0;
//	        	int coinNum = Coin.getCoinNum(position.symbol);
	    		
	        	/*String[] quantityList = new String[10];
	    		String[] priceList = new String[10];
	    			    		
	        	if(position.position.compareTo("long") == 0){ // 매수 포지션을 팔 때
    				for (int j = 0; j < 10; j++) {
    					quantityList[j] = asksQuantityList[coinNum][j];
    					priceList[j] = asksPriceList[coinNum][j];
    					Log.print("시세 :"+priceList[j]+" 수량:"+quantityList[j], 5, "sellMarket");
					}
	    			siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[0])); // 현 시세 수량 
	    			if (siseQuantity.doubleValue() < sellQuantity.doubleValue()) { // 시세 수량 < 판매 수량	    				        			
	    				while(siseQuantity.doubleValue() < quantity.doubleValue()){ // '판매 대기 수량 > 시세 수량' 동안 반복
	    					siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[i])); // 시세 별 수량 
	    					sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
	    					volume = volume.add(siseQuantity.multiply(sisePrice)); // 판매 총액 = 기존 총액 + 시세 수량 * 시세 가격
	    					quantity = quantity.subtract(siseQuantity); // 판매 대기 수량 - 판매 수량	    					
	    					i++;
	    					if(i >= 10){ i = 9; }
	    				}
	    				// 구매 대기 수량 < 시세 수량이 되어 반복문 탈출
	    				sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
	    				volume = volume.add(quantity.multiply(sisePrice)); // 총액 = 구매 대기 수량 * 시세	    				
	    				entryPrice = volume.divide(sellQuantity,5,RoundingMode.HALF_DOWN).doubleValue(); // 진입 평균 가격 = 총액 / 구매 수량 
	    				Log.print("시세 수량 부족=> 총 구매 금액: "+volume+" 진입 평균 가격: "+entryPrice, 5, "sellMarket");
	    				
					}else{ // 시세 수량 > 구매 수량						
						sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[0])); // 시세 가격						
						volume = sellQuantity.multiply(sisePrice); // 총액 = 기존 총액 + 구매 수량 * 시세						
						entryPrice = sisePrice.doubleValue();
						Log.print("시세 수량 부족하지 않음=> 총 구매 금액: "+volume+" 진입 평균 가격: "+entryPrice, 5, "sellMarket");
					}
	    		}else if(position.position.compareTo("short") == 0){ // 매도 판매
    				for (int j = 0; j < 10; j++) {
    					quantityList[j] = bidsQuantityList[coinNum][j];
    					priceList[j] = bidsPriceList[coinNum][j];
					}
	    			siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[0])); // 현 시세 수량 
	    			if (siseQuantity.doubleValue() < sellQuantity.doubleValue()) { // 시세 수량 < 판매 수량	    			
	    				while(siseQuantity.doubleValue() < quantity.doubleValue()){ // '판매 대기 수량 > 시세 수량' 동안 반복
	    					siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[i])); // 시세 별 수량 
	    					sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
	    					volume = volume.add(siseQuantity.multiply(sisePrice)); // 판매 총액 = 기존 총액 + 시세 수량 * 시세 가격
	    					quantity = quantity.subtract(siseQuantity); // 판매 대기 수량 - 판매 수량	    					
	    					i++;
	    					if(i >= 10){ i = 9; }
	    				}
	    				// 구매 대기 수량 < 시세 수량이 되어 반복문 탈출
	    				sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
	    				volume = volume.add(quantity.multiply(sisePrice)); // 총액 = 구매 대기 수량 * 시세	    				
	    				entryPrice = volume.divide(sellQuantity,5,RoundingMode.HALF_DOWN).doubleValue(); // 진입 평균 가격 = 총액 / 구매 수량 
	    				Log.print("시세 수량 부족=> 총 구매 금액: "+volume+" 진입 평균 가격: "+entryPrice, 5, "sellMarket");
					}else{ // 시세 수량 > 구매 수량
						Log.print("시세 수량 부족하지 않음", 0, "sellMarket");
						sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[0])); // 시세 가격						
						volume = sellQuantity.multiply(sisePrice); // 총액 = 기존 총액 + 구매 수량 * 시세						
						entryPrice = sisePrice.doubleValue();
						Log.print("시세 수량 부족하지 않음=> 총 구매 금액: "+volume+" 진입 평균 가격: "+entryPrice, 5, "sellMarket");
					}
	    		}*/
	        	//주문가격, 수량, 주문가치 
	        	quantity = quantity.setScale(5, RoundingMode.HALF_DOWN);
	        	sellProcess(position, volume, sise, position.orderType, newOrderType, quantity.doubleValue(),leverChange, copy);
	        	
			} catch (Exception e) {
				Log.print("sellMarket err! "+e, 0, "err");
			}
	    }
		private void sellLimit(Order order, double sise){
			// 포지션 가져오기
        	Position position = Position.getPosition(order.userIdx, order.symbol);
        	if (position == null) {
				Log.print("position is null", 0, "err");
				return;
			}
        	sellLimitAll(order, position, sise);
		}
		

		//수량관계없이 청산 하는 것  시장가 수수료  / 시장가 진입가격
		public void sellLimitAll(Order order, Position position, double sise){ // 가격 지정 주문 Position position은 기존 포지션
			try {
				// 지정가 이하로 호가가 내려가면 해당 수량이 계약 수량보다 적게 있으면 주문 취소
				Log.print("call sellLimitAll", 5, "buyLimit");
				
				BigDecimal price = BigDecimal.valueOf(sise);// 시세 가격
				BigDecimal volume = BigDecimal.ZERO;  // 계약 USDT
				
				//기존꺼 > 새로운거 , 새로운거갯수만큼 판다
				BigDecimal newBuyQuantity = BigDecimal.valueOf(order.buyQuantity); 
				//기존 <= 새로운거 , 기존거갯수만큼판다
				if(position.buyQuantity <= order.buyQuantity){
					newBuyQuantity = BigDecimal.valueOf(position.buyQuantity);
				}
		
				volume = price.multiply(newBuyQuantity); // 총액 = 시세 수량 * 시세
				Log.print("현재 시세 quantity "+newBuyQuantity+" 시세 가격 "+price +"판매수량 :"+newBuyQuantity+ " 주문수량x시세 = "+volume, 0, "buyLimit");
				//판매 로직
				showPopup(order.userIdx, "orderRun", 1);		
				
				if( position.buyQuantity <= order.buyQuantity ){
					Log.print("기존수량 <= 새주문수량   전부청산", 0, "buyLimit");
									
					sellProcess(position, volume, price.doubleValue(), "limit", order.orderType, newBuyQuantity.doubleValue(), false, null);
					liqOrderAllCancel(order.userIdx, order.symbol, order.orderNum);
				}
				else{					
					if(order.getIsLiq() == 0){ //청산 말고 일반 주문으로 포지션 청산되었을때도 청산 수량을 포지션 최대수량에 맞춰줘야 함
						BigDecimal liqOrderQty = BigDecimal.valueOf(Order.getLiqOrderQty(order.userIdx, order.symbol));
						liqOrderQty = liqOrderQty.subtract(newBuyQuantity);
						double over = PublicUtils.toFixed(liqOrderQty.setScale(4,RoundingMode.HALF_UP).doubleValue(),4);
						if(over > 0){
							orderSellPartMinus(over, order);
						}
					}
					
					sellPartProcess(position, volume, newBuyQuantity, price.doubleValue(), "limit", order.orderType);
				}
				// 트리거에서 제거
				order.updateOrderState("ordered");
				order.removeOrderList();
			} catch (Exception e) {
				Log.print("sellLimitGTC err! "+e, 0, "err");
			}
		}
		
		public void liqOrderSync(int userIdx, String symbol, double positionQty, double inQty, String position){
			BigDecimal liqOrderQty = BigDecimal.valueOf(Order.getLiqOrderQty(userIdx, symbol));
			liqOrderQty = liqOrderQty.subtract(BigDecimal.valueOf(positionQty).subtract(BigDecimal.valueOf(inQty)));
			double over = PublicUtils.toFixed(liqOrderQty.setScale(4,RoundingMode.HALF_UP).doubleValue(),4);
			if(over > 0){
				orderSellPartMinus(over, userIdx, symbol, position);
			}
		}

		//판매하려는 포지션, 판매하려는 포지션 규모, 판매하려는 포지션 진입가격, 판매하려는 포지션 주문형태, 판매하고자하는 수량
		public void sellProcess(Position position, BigDecimal volume, double entryPrice, String orderType, String neworderType, double sellQuantity, boolean leverChange, Copytrade copy) {
			try {
				int userIdx = position.userIdx;				
				Log.print("call sellProcess", 5, "sellProcess");
				
				BigDecimal dir = BigDecimal.ZERO; // 거래 방향				
	        	if (position.position.compareTo("long") == 0) { // 매수
	        		dir = BigDecimal.valueOf(1);
				}else if (position.position.compareTo("short") == 0) { // 매도
					dir = BigDecimal.valueOf(-1);
	        	}else{
	        		Log.print("position position dir err", 0, "err");
	        		return;
	        	}	        		        	
	        	
				// 결과 = 판매 총액 - 주문 USDT
	        	BigDecimal result = volume.subtract(BigDecimal.valueOf(position.contractVolume));	        	
	        	//순손익 = 거래 방향 *(판매 총액 - 주문 USDT)
	        	BigDecimal profit;
	        	Coin coin = Coin.getCoinInfo(position.symbol);
	        	if(CointransService.isInverse(position.symbol))
	        		profit = CointransService.coinTrans(dir.multiply(result),coin);
	        	else
	        		profit = dir.multiply(result);
	        	
	        	Log.print("회원번호 = "+userIdx+" 판매규모("+volume+") - 기존보유규모("+position.contractVolume+") = 이윤("+profit+")", 0, "sellProcess");	        	
	        	String ot = orderType;
	        	String logkind = "tradeclose";
	        	//반대포지션 구매했을 경우 반대포지션에 대한 진입수수료를 낸다. , close 청산했을 경우에는 기존포지션에대한 청산수수료를 낸다
	        	if(neworderType.compareTo("")!=0){
	        		ot = neworderType;
	        		logkind = "tradeclose2";
	        	}
	        	// 수수료
	        	BigDecimal feeRate = Project.getFeeRate(position.member, ot);
	        	BigDecimal fee;
	        	if(CointransService.isInverse(position.symbol))
	        		fee = CointransService.coinTrans(volume.multiply(feeRate),coin);//판것에대한 수수료
	        	else
	        		fee = volume.multiply(feeRate);//판것에대한 수수료
	        	
	        	position.liqFee += fee.doubleValue();
	        	
	        	Log.print(ot+" fee = volume("+volume+") * feeRate("+feeRate+") = "+fee, 0, "sellProcess");
	        	//trader.resetSum(fee.doubleValue(), profit.doubleValue(), 0);
	        	Wallet.updateWalletAmountSubtract(position.member, fee.doubleValue(), position.symbol, logkind);
	        	
	        	sendCloseInfo(position, profit.doubleValue(), volume, sellQuantity);
	        	// tradelog
	        	String sellPosition = "";
	        	if (position.position.compareTo("long") == 0) {
	        		sellPosition = "short";
				}else if (position.position.compareTo("short") == 0) {
	        		sellPosition = "long";
	        	}else{
	        		Log.print("sellPosition err! position = "+position.position, 0, "err");
	        		return;
	        	}
	        	if(!leverChange)
	        		position.member.liqAlert(position,profit.doubleValue(),entryPrice);
	        	
	        	
	        	// 지갑에 더해주기				
	        	Wallet.updateWalletAmountAdd(position.member, profit.doubleValue(), position.symbol, "profit");
	        	
	        	ot = "market";
	        	if(neworderType.compareTo("")!=0){
	        		ot = neworderType;	        		
	        	}	 	        	
	        	Trade trade = new Trade(position.member, position.symbol, ot, sellPosition, position.buyQuantity, position.leverage, position.marginType);
	        	// 수수료 떼어주기
	        	BigDecimal adminProfit = Referral.accumPileFee(position.member,volume.doubleValue(),position.symbol,fee,trade.orderNum);
	        	adminProfit = adminProfit.add(Referral.accumPile(position.member,volume.doubleValue(),position.symbol,profit,trade.orderNum,true));

	        	trade.insertTradeLog(fee.doubleValue(), position.entryPrice, profit.doubleValue(),position.fee,adminProfit, false, coin.getSise(trade.position),trade.marginType);
	        	// 포지션에서 지우기	        	
	        	
	        	if(copy != null){
	        		copy.updateFollowMoney(fee.doubleValue());
	        		copy.updateProfit(profit.doubleValue());
	        		Copytrade.updateCopytrade(copy);
	        		copy.insertCopytradeLog(profit.doubleValue(), CopytradeKind.SELL);
	        		copy.position = null;
	        	}
	        	position.member.checkSetWarningUser(profit.doubleValue());
	        	removePosition(position, leverChange);
	        	Position.updateLiquidationPriceByUser(position.userIdx, position.symbol);
			} catch (Exception e) {
				Log.print("sellProcess err! "+e, 0, "err" );
			}
		}
		//청산팝업
		public void sendCloseInfo(Position position, double profit, BigDecimal volume, double sellQuantity) {
			try {				
				JSONObject obj = new JSONObject();
        		obj.put("protocol", "closeInfo");
        		obj.put("userIdx", position.userIdx);
        		obj.put("buyQuantity", sellQuantity);
        		obj.put("symbol", position.symbol);
        		obj.put("entryPrice", position.entryPrice);
        		obj.put("contractVolume", volume);
        		obj.put("profit", profit);
        		obj.put("leverage", position.leverage);
        		obj.put("marginType", position.marginType);//격리 교차
        		obj.put("orderType", position.orderType);//stoplimit  market
        		sendMessageToMeAllBrowser(obj);        						
				
			} catch (Exception e) {
				Log.print("removePosition err! "+e, 0, "err");
			}			
		}
		
		public void removePosition(Position position, boolean leverChange) {
			try {
				int userIdx = position.userIdx;
				String symbol = position.symbol;	
				for (Iterator<Position> iter = SocketHandler.positionList.iterator(); iter.hasNext(); ) {
    				Position pos = iter.next();
					if (pos.userIdx == userIdx && pos.symbol.equals(symbol)) {
						Log.print("removePosition find position "+pos.toString(), 6, "log");
						
						pos.TP = null;
						pos.SL = null;
						iter.remove();
						break;
					}
				}
				EgovMap in = new EgovMap();
				in.put("userIdx", userIdx);
				in.put("symbol", symbol);
				
				JSONObject obj = new JSONObject();
        		obj.put("protocol", "remove Position");
        		obj.put("userIdx", userIdx);
        		obj.put("symbol", symbol);
        		obj.put("leverChange", leverChange);
        		
        		sendMessageToMeAllBrowser(obj);
        		sise.sendSiseServer(obj);
        		QueryWait.pushQuery("deletePosition",userIdx, in, QueryType.DELETE);
//				sampleDAO.delete("deletePosition",in);
				removeTradeTriggerByTriggerType(userIdx, symbol, "inPosition");
				
			} catch (Exception e) {
				Log.print("removePosition err! "+e, 0, "err");
			}			
		}

		public void sellMarketPart(Trade trade, double clearingQuantity, String newOrderType){ // 포지션 일부 청산
	    	//포지션을 찾기
			try {
				Log.print("call sellMarketPart", 5, "call");
	    		// 포지션 가져오기
				String symbol = trade.symbol;
	        	Position position = Position.getPosition(trade.userIdx, symbol);
	        	if (position == null) {
					Log.print("position is null", 0, "err");
					return;
				}
	        	// 수익 계산
	        	BigDecimal sellQuantity = BigDecimal.valueOf(clearingQuantity); // 실 판매 
	    		BigDecimal quantity = sellQuantity; // 판매 대기 수량 - 구매 수량 계산 필요 변수
	    		BigDecimal siseQuantity = BigDecimal.ZERO;
	    		BigDecimal sisePrice = BigDecimal.ZERO;
	    		BigDecimal volume = BigDecimal.ZERO;
	    		double entryPrice = 0; // 진입 가격
	        	
	        	int i = 0;
	        	Coin coin = Coin.getCoinInfo(symbol);
	    		String[] quantityList = new String[10];
//	    		String[] priceList = new String[10];
	    		double sise = coin.getSise(trade.position);
	    		
	    		Log.print("position = "+position.position,	0, "sellMarket");
	        	if(position.position.compareTo("long") == 0){ // 매수 포지션을 팔 때
//    				for (int j = 0; j < 10; j++) {
//    					quantityList[j] = coin.asksQuantityList[j];
//    					priceList[j] = coin.asksPriceList[j];
//					}
//	    			siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[0])); // 현 시세 수량 
//	    			if (siseQuantity.doubleValue() < sellQuantity.doubleValue()) { // 시세 수량 < 판매 수량
//	    				Log.print("시세 수량 부족", 0, "sellMarket");
//        				Log.print("구매 대기 수량: "+quantity, 0, "sellMarket");
//        				int loopcounting=0;
//	    				while(siseQuantity.doubleValue() < quantity.doubleValue()){ // '판매 대기 수량 > 시세 수량' 동안 반복
//	    					siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[i])); // 시세 별 수량 
//	    					if(siseQuantity.doubleValue()<0.001)
//	    						siseQuantity = BigDecimal.valueOf(0.001);
//	    					sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
//	    					volume = volume.add(siseQuantity.multiply(sisePrice)); // 판매 총액 = 기존 총액 + 시세 수량 * 시세 가격
//	    					quantity = quantity.subtract(siseQuantity); // 판매 대기 수량 - 판매 수량
//	    					//Log.print(i+"] "+sisePrice+" | "+siseQuantity+"    남은 판매 대기 수량 :"+quantity, 0, "sellMarket");
//	    					loopcounting++;
//	    					i++;
//	    					if(i >= 10){ i = 9; }
//	    				}
//	    				Log.print("긁기 횟수: "+loopcounting, 0, "sellMarket");
//	    				// 구매 대기 수량 < 시세 수량이 되어 반복문 탈출
//	    				sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
//	    				volume = volume.add(quantity.multiply(sisePrice)); // 총액 = 구매 대기 수량 * 시세
//	    				Log.print("총 구매 금액: "+volume, 0, "sellMarket");
//	    				entryPrice = volume.divide(sellQuantity,5,RoundingMode.HALF_DOWN).doubleValue(); // 진입 평균 가격 = 총액 / 구매 수량 
//	    				Log.print("진입 평균 가격: "+entryPrice, 0, "sellMarket");
//	    				
//					}else{ // 시세 수량 > 구매 수량
//						Log.print("시세 수량 부족하지 않음", 0, "sellMarket");
//						sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[0])); // 시세 가격
//						Log.print("시세 가격 = "+sisePrice, 0, "sellMarket");
//						volume = sellQuantity.multiply(sisePrice); // 총액 = 기존 총액 + 구매 수량 * 시세
//						Log.print("거래 크기 = "+volume, 0, "sellMarket");
//						entryPrice = sisePrice.doubleValue();
//						Log.print("진입 가격  = "+entryPrice, 0, "sellMarket");
//					}
	        		
					sisePrice = BigDecimal.valueOf(sise); // 시세 가격
					Log.print("시세 가격 = "+sisePrice, 0, "sellMarket");
					volume = sellQuantity.multiply(sisePrice); // 총액 = 기존 총액 + 구매 수량 * 시세
					Log.print("거래 크기 = "+volume, 0, "sellMarket");
					entryPrice = sisePrice.doubleValue();
					Log.print("진입 가격  = "+entryPrice, 0, "sellMarket");
	    		}else if(position.position.compareTo("short") == 0){ // 매도 판매
//    				for (int j = 0; j < 10; j++) {
//    					quantityList[j] = coin.bidsQuantityList[j];
//    					priceList[j] = coin.bidsPriceList[j];
//					}
//	    			siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[0])); // 현 시세 수량 
//	    			if (siseQuantity.doubleValue() < sellQuantity.doubleValue()) { // 시세 수량 < 판매 수량
//	    				Log.print("시세 수량 부족", 0, "sellMarket");
//	    				Log.print("판매 대기 수량: "+quantity, 0, "sellMarket");
//	    				while(siseQuantity.doubleValue() < quantity.doubleValue()){ // '판매 대기 수량 > 시세 수량' 동안 반복
//	    					siseQuantity = BigDecimal.valueOf(Double.parseDouble(quantityList[i])); // 시세 별 수량
//	    					if(siseQuantity.doubleValue()<0.001)
//	    						siseQuantity = BigDecimal.valueOf(0.001);
//	    					sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
//	    					volume = volume.add(siseQuantity.multiply(sisePrice)); // 판매 총액 = 기존 총액 + 시세 수량 * 시세 가격
//	    					quantity = quantity.subtract(siseQuantity); // 판매 대기 수량 - 판매 수량
//	    					Log.print(i+"] "+sisePrice+" | "+siseQuantity+"    남은 판매 대기 수량 :"+quantity , 0, "sellMarket");
//	    					i++;
//	    					if(i >= 10)	i = 9;	    					
//	    				}
//	    				// 구매 대기 수량 < 시세 수량이 되어 반복문 탈출
//	    				sisePrice = BigDecimal.valueOf(Double.parseDouble(priceList[i])); // 시세당 가격
//	    				volume = volume.add(quantity.multiply(sisePrice)); // 총액 = 구매 대기 수량 * 시세
//	    				Log.print("총 구매 금액: "+volume  , 0, "sellMarket");
//	    				entryPrice = volume.divide(sellQuantity,5,RoundingMode.HALF_DOWN).doubleValue(); // 진입 평균 가격 = 총액 / 구매 수량 
//	    				Log.print("진입 평균 가격: "+entryPrice , 0, "sellMarket");
//					}else{ // 시세 수량 > 구매 수량
						Log.print("시세 수량 부족하지 않음", 0, "sellMarket");
						sisePrice = BigDecimal.valueOf(sise); // 시세 가격
						Log.print("시세 가격 = "+sisePrice, 0, "sellMarket");
						volume = sellQuantity.multiply(sisePrice); // 총액 = 기존 총액 + 구매 수량 * 시세
						Log.print("거래 크기 = "+volume, 0, "sellMarket");
						entryPrice = sisePrice.doubleValue();
						Log.print("진입 가격  = "+entryPrice, 0, "sellMarket");
//					}
	    		}
	        	
	        	sellPartProcess(position, volume, sellQuantity, entryPrice, "limit", newOrderType);
	        	
			} catch (Exception e) {
				Log.print("sellMarket err! "+e, 0, "err");
			}
	    }
		//Position position 는 과거 , 나머지 새거   10개중에 3개를 팔았다면  		 position : 10개    volume: 3개
		private void sellPartProcess(Position position, BigDecimal volume, BigDecimal sellQuantity, double entryPrice, String orderType, String newOrderType) {
			try {
				Log.print("call sellPartProcess", 5, "sellMarket");
				Member trader = position.member;
				
				BigDecimal dir = BigDecimal.ZERO; // 거래 방향
	        	if (position.position.compareTo("long") == 0) { // 매수
	        		dir = BigDecimal.ONE;
				}else if (position.position.compareTo("short") == 0) { // 매도
					dir = BigDecimal.valueOf(-1);
	        	}else{
	        		Log.print("position position dir err", 0, "err");
	        		return;
	        	}
	        	//5개 숏 보유하고있는데 롱3개를 샀다  숏3개가 청산되어야함 , 숏2개가 남는다
	        	// (판매진입가격x판매수량) -   {(기존포지션 진입가격 x 기존수량) x 판매수량 / 기존수량}
				// 결과 = 판매 총액 - 주문 USDT       판매규모 (롱3개 진입가격곱함) - {기존규모(숏5개 진입가격곱함) x 판매수량(3개) / 기존수량(5개)}
				// 결과 = 판매 총액 - 주문 USDT
	        	BigDecimal result = volume.subtract(BigDecimal.valueOf(position.contractVolume)
														.multiply(sellQuantity
														.divide(BigDecimal.valueOf(position.buyQuantity), 4, BigDecimal.ROUND_HALF_DOWN)));
	        	
	        	
	        	
	        	//순손익 = 거래 방향 * 레버리지 * (판매 총액 - 주문 USDT)
	        	BigDecimal profit;
	        	Coin coin = Coin.getCoinInfo(position.symbol);
	        	if(CointransService.isInverse(position.symbol))
	        		profit = CointransService.coinTrans(dir.multiply(result),coin);
	        	else
	        		profit = dir.multiply(result);
	        		
	        	Log.print("회원번호 = "+trader.userIdx+" 판매규모("+volume+") - 기존보유규모("+position.contractVolume+") = 이윤("+profit+")", 0, "sellProcess");
	        	String ot = orderType;
	        	String logkind = "tradeclose";
	        	//반대포지션 구매했을 경우 반대포지션에 대한 진입수수료를 낸다. , close 청산했을 경우에는 기존포지션에대한 청산수수료를 낸다
	        	if(newOrderType.compareTo("")!=0){
	        		ot = newOrderType;
	        		logkind = "tradeclose2";
	        	}
	 
	        	// 수수료
	        	BigDecimal feeRate = Project.getFeeRate(trader, ot);
	        	BigDecimal fee;
	        	if(CointransService.isInverse(position.symbol))
	        		fee = CointransService.coinTrans(volume.multiply(feeRate),coin);//판것에대한 수수료
	        	else
	        		fee = volume.multiply(feeRate);//판것에대한 수수료
	        	
	        	position.liqFee += fee.doubleValue();
	        	
	        	Log.print(ot+" fee = volume("+volume+") * feeRate("+feeRate+") = "+fee, 0, "sellProcess");
	        	Wallet.updateWalletAmountSubtract(trader, fee.doubleValue(), position.symbol, logkind);
	        	sendCloseInfo(position, profit.doubleValue(), volume, sellQuantity.doubleValue());
	        	// tradelog
	        	String sellPosition = "";
	        	if (position.position.compareTo("long") == 0) {
	        		sellPosition = "short";
				}else if (position.position.compareTo("short") == 0) {
	        		sellPosition = "long";
	        	}else{
	        		Log.print("sellPosition err! position = "+position.position, 0, "err");
	        		return;
	        	}
	        	
	        	trader.liqAlert(position, profit.doubleValue(), entryPrice);
				
	        	// 지갑에 더해주기
	        	Wallet.updateWalletAmountAdd(trader, profit.doubleValue(), position.symbol, "profit");
	        	
	        	ot = "market";
	        	if(newOrderType.compareTo("")!=0){
	        		ot = newOrderType;	        		
	        	}
	 
	        	Trade trade = new Trade(position.member, position.symbol, ot, sellPosition, sellQuantity.doubleValue(), position.leverage, position.marginType);
	        	// 수수료 떼어주기
	        	BigDecimal adminProfit = Referral.accumPileFee(trader,volume.doubleValue(),position.symbol,fee,trade.orderNum);
	        	adminProfit = adminProfit.add(Referral.accumPile(trader,volume.doubleValue(),position.symbol,profit,trade.orderNum,true));

	        	trade.insertTradeLog(fee.doubleValue(), position.entryPrice, profit.doubleValue(),position.fee,adminProfit, false,coin.getSise(trade.position),trade.marginType);
	        	position.member.checkSetWarningUser(profit.doubleValue());	        	
	        	// 포지션업데이트
	        	updateSellPosition(trade, position, trader);
	        	Position.updateLiquidationPriceByUser(trade.userIdx, trade.symbol);
				
			} catch (Exception e) {
				Log.print("sellPartProcess err! "+e, 0, "err" );
			}
			
		}
		
		public void orderFail(Order order, String reason){
			// 주문 구매 실패시
			order.updateOrderState(reason); // 로그 변경
			//showPopup(order.userIdx, order.symbol+" <spring:message code='pop.show.orderFailCancel'/>", 2); // 안내 문구
			showPopup(order.userIdx, "orderFailCancel", 2); // 안내 문구
			// 주문 리스트에서 삭제
			order.removeOrderList();
		}
		
		private void updateOrderDB(Order order){
			try {
				EgovMap in = new EgovMap();
        		in.put("userIdx", order.userIdx);
        		in.put("orderNum", order.orderNum);
        		in.put("buyQuantity", order.buyQuantity);
        		in.put("conclusionQuantity", order.conclusionQuantity);
        		in.put("paidVolume", order.paidVolume);
        		in.put("leverage", order.leverage);
        		QueryWait.pushQuery("updateOrderConclusion",order.userIdx, in, QueryType.UPDATE,false);
//        		sampleDAO.update("updateOrderConclusion", in);
			} catch (Exception e) {
				Log.print("updateOrderConclusion err! "+e, 0, "err");
			}
		}
		
		private void updateOrder(Order order) {
			try {
				EgovMap in = new EgovMap();
        		in.put("userIdx", order.userIdx);
        		in.put("orderNum", order.orderNum);
        		in.put("buyQuantity", order.buyQuantity);
        		in.put("conclusionQuantity", order.conclusionQuantity);
        		in.put("paidVolume", order.paidVolume);
        		in.put("leverage", order.leverage);
        		Log.print( "updateOrder paidVolume:"+order.paidVolume+" buyQuantity:"+order.buyQuantity , 0, "call");
        		
        		sendOrderUpdate(GetSession(""+order.userIdx), order);
        		QueryWait.pushQuery("updateOrderConclusion",order.userIdx, in, QueryType.UPDATE,false);
//        		sampleDAO.update("updateOrderConclusion", in);
			} catch (Exception e) {
				Log.print("updateOrderConclusion err! "+e, 0, "err");
			}
		}

		private void sendOrderUpdate(WebSocketSession session, Order order) {
			Log.print("call sendOrder", 5, "call");
        	try {
        		JSONObject obj = new JSONObject();
        		obj.put("protocol", "order update");
        		obj.put("userIdx", order.userIdx);
        		obj.put("orderNum", order.orderNum);
        		obj.put("symbol", order.symbol);
        		obj.put("entryPrice", order.entryPrice);
        		obj.put("buyQuantity", order.buyQuantity);
        		obj.put("leverage", order.leverage);
        		obj.put("paidVolume", order.paidVolume);
        		obj.put("conclusionQuantity", order.conclusionQuantity);
        		sendMessageToMeAllBrowser(obj);
        		sise.sendSiseServer(obj);
        	} catch (Exception e) {
        		Log.print("sendOrderUpdate err! "+e, 0, "err");
        	}
			
		}

        public void removeTradeTriggerByTriggerType(int userIdx, String symbol, String triggerType){ //
        	try {
        		Log.print("call removeTradeTriggerByTriggerType", 5, "call");
        		// List에서 삭제
        		for (Iterator<TradeTrigger> iter = triggerList.iterator(); iter.hasNext(); ) {
    				TradeTrigger trigger = iter.next();
        			if (trigger.userIdx == userIdx && trigger.symbol.equals(symbol) && trigger.triggerType.equals(triggerType)) {
        				trigger.removeTradeTriggerInDB();
        				iter.remove();
        			}
        		}
        	} catch (Exception e) {
        		Log.print("removeTradeTriggerByTriggerType err! "+e, 0, "err");
        	}
        }
        
        //BuyMarketTrigger() 호출할때 tradetrigger에서 limit이나 stoplimit을 삭제해야하는 경우
        public void removeTradeTriggerByTriggerTypeByBuyMarketTrigger(int userIdx, String symbol, String triggerType, String orderNum){ //
        	try {
        		Log.print("call removeTradeTriggerByTriggerType", 5, "call");
        		// List에서 삭제
        		for (Iterator<TradeTrigger> iter = triggerList.iterator(); iter.hasNext(); ) {
    				TradeTrigger trigger = iter.next();
        			if (trigger.userIdx == userIdx && trigger.symbol.equals(symbol) && 
        					trigger.triggerType.equals(triggerType) && 
        					trigger.orderNum.equals(orderNum)) {
        				// DB에서 삭제
        				trigger.removeTradeTriggerInDB();
        				// 목록에서 삭제
        				iter.remove();
        			}
        		}
        	} catch (Exception e) {
        		Log.print("removeTradeTriggerByTriggerType err! "+e, 0, "err");
        	}
        }        
        public void removeTradeTriggerForOrderAllCancel(int userIdx, String symbol){ //
        	try {
        		Log.print("call removeTradeTriggerForOrderAllCancel", 5, "call");
        		// List에서 삭제
        		Log.print("triggerList.size() = "+triggerList.size(), 6, "log");
        		Log.print("userIdx : "+userIdx+" | symbol : "+symbol, 6, "log");
        		for (Iterator<TradeTrigger> iter = triggerList.iterator(); iter.hasNext(); ) {
    				TradeTrigger trigger = iter.next();
        			// inPosition이 아니면 삭제 -> 주문이란 소리
        			if (trigger.userIdx == userIdx && trigger.symbol.equals(symbol) && 
        					!trigger.triggerType.equals("inPosition")) {
        				// DB에서 삭제
        				trigger.removeTradeTriggerInDB();
        				// 목록에서 삭제
        				iter.remove();
        			}
        		}
        	} catch (Exception e) {
        		Log.print("removeTradeTriggerForOrderAllCancel err! "+e, 0, "err");
        	}
        }
        
        public void registerOrder(WebSocketSession session, Member user, JSONObject obj){ // 지정가 주문 등록 , stop market stop limit 트리거등록
        	try {
        		Log.print("call registerOrder", 5, "buyProcess");
        		if(Order.getOrderList(user.userIdx).size() >= Order.Max){
        			showPopup(user.userIdx, "maxOrder", 2);
        			return;
        		}
        		
        		Date date = new Date(Calendar.getInstance().getTimeInMillis()); 
    			SimpleDateFormat sdf = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss"); 
    			String today = sdf.format(date);
    			double triggerPrice = Double.parseDouble(""+obj.get("triggerPrice").toString());
    			if(obj.get("orderType").toString().compareTo("stopLimit") != 0){
    				triggerPrice = 0.0;
    			}
    			Log.print("userIdx:"+obj.get("userIdx").toString() +" symbol:"+obj.get("symbol").toString()
    					+" orderType:"+obj.get("orderType").toString()+" position:"+obj.get("position").toString() +" entryPrice:"+obj.get("entryPrice").toString()
    					+" buyQuantity:"+obj.get("buyQuantity").toString()+" leverage:"+obj.get("leverage").toString()
    					+"marginType:"+obj.get("marginType").toString(), 5, "buyProcess");
    			
    			Coin coin = Coin.getCoinInfo(obj.get("symbol").toString());
        		double entryPrice = PublicUtils.toFixed(Double.parseDouble(obj.get("entryPrice").toString()),coin.priceFixed);
        		double buyQuantity = PublicUtils.toFixed(Double.parseDouble(obj.get("buyQuantity").toString()),coin.qtyFixed);
        		
        		Order order = new Order(obj.get("userIdx").toString(), obj.get("symbol").toString(), obj.get("orderType").toString(), obj.get("position").toString(),  entryPrice, buyQuantity
        				,  obj.get("strategy").toString(),  obj.get("leverage").toString(), obj.get("marginType").toString(), obj.get("postOnly").toString(), obj.get("auto").toString(), today, triggerPrice);
        		Log.print("fee+유지증거금 있어야 게임가능 : "+order.paidVolume, 0, "registerOrder");
        		//기존 포지션 보유시 해당수량만큼은 잔고 체크를 안한다 
        		Position oldPosition = Position.getPosition(user.userIdx, obj.get("symbol").toString());
        		Log.print("oldposition : "+oldPosition, 0, "registerOrder");
        		double positionQty = 0;
        		double orderQty = PublicUtils.toFixed(Double.parseDouble(obj.get("buyQuantity").toString()),4);//2개
        		Log.print("obj.buyQuantity = "+Double.parseDouble(obj.get("buyQuantity").toString()), 0, "registerOrder");
        		

        		String isL = obj.get("isLiqBuy")+""; // 청산주문으로 주문한경우만 "1"이라는 값이 들어가고 , 일반 주문일 경우엔 null
    			if( obj.get("isLiqBuy") == null){
    				isL = null;
    			}else{
    				//기존 포지션 있을 때 + 지정가 청산 시 
            		if(oldPosition != null && isL.compareTo("1")==0 ){
            			positionQty = PublicUtils.toFixed(oldPosition.buyQuantity,4);//기존 포지션 보유수량 5개
            			//System.out.println("이전주문수량 합 = "+getLiqOrderQty(userIdx, obj.get("symbol").toString()));
            			double prevOrderQty = PublicUtils.toFixed(Order.getLiqOrderQty(user.userIdx, obj.get("symbol").toString()),4);
    	    			if( prevOrderQty + orderQty > positionQty){//기존 주문 수량 + 이번 주문 수량이 이 포지션 수량을 넘었다면
    	    				BigDecimal over = BigDecimal.valueOf(prevOrderQty);
    	    				over = over.add(BigDecimal.valueOf(orderQty)).subtract(BigDecimal.valueOf(positionQty));
    	    				over = over.setScale(4, RoundingMode.HALF_UP);
    	    				if( orderQty > over.doubleValue() ){ // 이번주문이 초과량보다 크다면
    	    					BigDecimal resultQty = BigDecimal.valueOf(orderQty).subtract(over);
    	    					resultQty = resultQty.setScale(4,RoundingMode.HALF_UP);
    	    					order.buyQuantity = PublicUtils.toFixed(resultQty.doubleValue(),4);
    	    				}else{
    	    					if(!orderMinus(over.doubleValue(), order)){
    	    						showPopup(user.userIdx, "Close order quantity exceeds available quantity to close", 2);
    	    						return;
    	    					}
    	    				}
    	    			}
    	    			
            			Double qtyDiff = orderQty - positionQty;//이차이가 0보다 클때만 잔액 체크를 한다
            			order.setIsLiq(true);
            			if(qtyDiff>0){
            				Order difforder = new Order(obj.get("userIdx").toString(), obj.get("symbol").toString(), obj.get("orderType").toString(), obj.get("position").toString(),  Double.parseDouble(obj.get("entryPrice").toString()), qtyDiff
                    				,  obj.get("strategy").toString(),  obj.get("leverage").toString(), obj.get("marginType").toString(), obj.get("postOnly").toString(), obj.get("auto").toString(), today, triggerPrice);
        	        		if (Wallet.walletValidation(user, difforder.paidVolume, difforder, obj.get("symbol").toString()) < 0) {
        	        			Log.print("기존 포지션 존재 차액수량 : "+qtyDiff+" 주문 잔고 부족 checkMoney = "+difforder.paidVolume+" trader wallet = "+user.wallet, 0, "registerOrder");
        	        			showPopup(user.userIdx, "nonBalanceNotOrderRun", 2);
        	        			return;
        	        		}
        	        		
        	        		
        	        		if (Trade.maxContractVolumeCheck(difforder.userIdx, difforder.leverage, difforder.symbol, (difforder.entryPrice*difforder.buyQuantity), "buy", difforder.position) == false) {
        						Log.print("구매 실패 maxContractVolumeCheck == false", 0, "buyProcess");
        						return;
        					}  
            			}
            		}else{
            			Log.print("registerOrder 청산주문인데 이전 포지션이 없는 경우. 유저 "+user.userIdx, 0, "registerOrder");
            			return;
            		}
    			}
        		
    			    			
        		//기존 포지션 없을 때 + limit 탭 주문
        		if(oldPosition == null 
        				|| isL == null ){//기존 포지션이 있어도 청산 팝업에서 한 주문이 아니고 주문창에서 주문한것이면  isLiq 셋팅하진 않는다. 
        			double wallet = Wallet.walletValidation(user, order.paidVolume, order, obj.get("symbol").toString());
	        		if (wallet < 0) {
	        			Log.print("주문 잔고 부족 checkMoney = "+order.paidVolume+" 사용가능잔고 = "+wallet, 0, "registerOrder");
	        			//showPopup(trader.userIdx, "<spring:message code='pop.show.nonBalanceNotOrderRun'/>", 2);
	        			showPopup(user.userIdx, "nonBalanceNotOrderRun", 2);
	        			return;
	        		}
	        		
	        		if (Trade.maxContractVolumeCheck(order.userIdx, order.leverage, order.symbol, (order.entryPrice*order.buyQuantity), "buy", order.position) == false) {
						Log.print("구매 실패 maxContractVolumeCheck == false", 0, "buyProcess");
						return;
					}  
        		}
        		        		
        		// order DB에 등록
        		EgovMap in = new EgovMap();
        		in.put("userIdx", order.userIdx);
        		in.put("orderNum", order.orderNum);
        		in.put("symbol", order.symbol);
        		in.put("orderType", order.orderType);
        		in.put("position", order.position);
        		in.put("entryPrice", order.entryPrice);
        		in.put("buyQuantity", order.buyQuantity);
        		in.put("strategy", order.strategy);
        		in.put("leverage", order.leverage);
        		in.put("conclusionQuantity", order.conclusionQuantity);
        		in.put("state", order.state);
        		in.put("marginType", order.marginType);
        		in.put("paidVolume", order.paidVolume);
        		in.put("postOnly", order.postOnly);
        		in.put("entryPriceForStop", order.entryPriceForStop);
        		in.put("auto", order.auto);
        		in.put("triggerPrice", order.triggerPrice);
        		in.put("isLiq", order.getIsLiq());
//        		sampleDAO.insert("insertOrder",in);  
        		QueryWait.pushQuery("insertOrder",order.userIdx, in, QueryType.INSERT);
        		
        		order.addOrderList();// 주문 추가
        		Position.updateLiquidationPriceByUser(user.userIdx, order.symbol);
        		
//        		int coinNum = Coin.getCoinNum(order.symbol);
        		//Hoga hoga = new Hoga(order.buyQuantity, order.entryPrice, coinNum, order.position);
        		//hoga.addHoga();
        		//클라이언트에게 알리기
        		showPopup(order.userIdx, "orderRegister", 1);
        		
        		// TriggerList에 등록
        		Log.print("orderType : "+obj.get("orderType"), 0, "registerOrder");
        		if (obj.get("orderType").toString().compareTo("stopLimit") == 0) {
        			double triggerPricet = Double.parseDouble(obj.get("triggerPrice").toString());
        			TradeTrigger tradeTrigger = new TradeTrigger(""+order.userIdx, order.orderNum, order.symbol, order.orderType, order.position, ""+triggerPricet);
        			tradeTrigger.addTradeTrigger();
        			 
        			
				}else{
					TradeTrigger tradeTrigger = new TradeTrigger(""+order.userIdx, order.orderNum, order.symbol, order.orderType, order.position, ""+order.entryPrice);
					tradeTrigger.addTradeTrigger();
				}
			} catch (Exception e) {
				System.out.println("e:"+e.toString());
				Log.print("registerOrder err! "+e+" obj : "+obj, 0, "err");
			}
        }
        
        public boolean orderMinus(double minusQty, Order order){
        	int userIdx = order.userIdx;
        	ArrayList<Order> myOrders = Order.getOrderList(userIdx);
        	boolean orderComplete = false;
			if(order.position.equals("long"))
				Order.sortDownEntryOrderlist(myOrders);
			else
				Order.sortUpEntryOrderlist(myOrders);
			
			ArrayList<Order> cancelList = new ArrayList<Order>();
			
			
			for(Order o : myOrders){
				if(userIdx == o.userIdx && order.symbol.equals(o.symbol) && o.getIsLiq() == 1){ // 유저, 심볼 , 청산주문인지 비교
					if(order.position.equals("short")){ // 포지션이 롱일때는 가장 큰 주문부터 감소. 만약 새로 넣는 주문이 더 큰 주문이라면 감소 불가
						if(o.entryPrice < order.entryPrice) break;
					}else{ // 포지션이 숏일때는 가장 작은 주문부터 감소. 만약 새로 넣는 주문이 더 작은 주문이라면 감소 불가
						if(o.entryPrice > order.entryPrice) break;
					}
					orderComplete = true; // 한번이라도 감소 했다면 그 수량만큼 주문이 들어갈 것. 그게 아니라면 false 리턴(주문 안들어감)
					
					if(o.buyQuantity > minusQty){
						BigDecimal oqty = BigDecimal.valueOf(o.buyQuantity);
						oqty = oqty.subtract(BigDecimal.valueOf(minusQty));
						oqty.setScale(4,RoundingMode.HALF_UP);
						o.buyQuantity = PublicUtils.toFixed(oqty.doubleValue(),4);
						updateOrder(o); // 오더 DB 업데이트 , 패킷 전송
						minusQty = 0;
						break;
					}else{
						minusQty -= o.buyQuantity;
						cancelList.add(o);
						
						if(minusQty == 0) break;
					}
				}
			}
			
			for(int i = 0; i < cancelList.size(); i++){ 
				cancelList.get(i).updateOrderState("cancel");  // 오더 DB 업데이트(취소)
				cancelList.get(i).removeOrderList(); // 메모리, 트리거 삭제 
			}
			
			if(orderComplete && minusQty != 0){ // 주문 변동 되었는데 다 감소시키지 못한 경우 ( 발동가 비교로 인해 일부 주문만 취소시킨 경우 )
				order.buyQuantity -= minusQty; // 이떄까지 남아있는 minusQty는 초과 수량임. 빼준다
				order.buyQuantity = PublicUtils.toFixed(order.buyQuantity,4);
			}
			
			return orderComplete;
        }
        
        public void orderSellPartMinus(double minusQty, Order removeOrder){
        	orderSellPartMinus(minusQty,removeOrder.userIdx,removeOrder.symbol,removeOrder.position);
        }
        
        public void orderSellPartMinus(double minusQty, int userIdx, String symbol, String position){
        	ArrayList<Order> myOrders = Order.getOrderList(userIdx);
			if(position.equals("long"))
				Order.sortDownEntryOrderlist(myOrders);
			else
				Order.sortUpEntryOrderlist(myOrders);
			
			ArrayList<Order> cancelList = new ArrayList<Order>();
			
			for(Order o : myOrders){
				if(userIdx == o.userIdx && symbol.equals(o.symbol) && o.getIsLiq() == 1){ // 유저, 심볼 , 청산주문인지 비교
					
					if(o.buyQuantity > minusQty){
						BigDecimal oqty = BigDecimal.valueOf(o.buyQuantity);
						oqty = oqty.subtract(BigDecimal.valueOf(minusQty));
						oqty.setScale(4,RoundingMode.HALF_UP);
						o.buyQuantity = PublicUtils.toFixed(oqty.doubleValue(),4);
						updateOrder(o); // 오더 DB 업데이트 , 패킷 전송
						minusQty = 0;
						break;
					}else{
						minusQty -= o.buyQuantity;
						cancelList.add(o);
						if(minusQty == 0) break;
					}
				}
			}
			for(int i = 0; i < cancelList.size(); i++){ 
				cancelList.get(i).updateOrderState("cancel");  // 오더 DB 업데이트(취소)
				cancelList.get(i).removeOrderList(); // 메모리, 트리거 삭제 
			}
        }
        
        public void liqOrderAllCancel(int userIdx, String symbol, String orderNum){
			ArrayList<Order> cancelList = new ArrayList<Order>();
			for (Iterator<Order> iter = orderList.iterator(); iter.hasNext(); ) {
	    		Order o = iter.next();
				if(!o.orderNum.equals(orderNum) && userIdx == o.userIdx && symbol.equals(o.symbol) && o.getIsLiq() == 1){ // 유저, 심볼 , 청산주문인지 비교
					cancelList.add(o);
				}
			}
			for(int i = 0; i < cancelList.size(); i++){ 
				cancelList.get(i).updateOrderState("cancel");  // 오더 DB 업데이트(취소)
				cancelList.get(i).removeOrderList(); // 메모리, 트리거 삭제 
			}
        }
        
        public void showPopup(int userIdx, String msg, int level) {
        	Log.print("call showPopup : "+msg, 5, "call");
        	try {
        		JSONObject obj = new JSONObject();
        		obj.put("protocol", "showPopup");
        		obj.put("userIdx", userIdx);
        		obj.put("msg", msg);
        		obj.put("level", level);
        		sendMessageToMeAllBrowser(obj);
			} catch (Exception e) {
				Log.print("showPopup err! "+e, 0, "err");
			}
			
		}

		public void registerLimitOrder(TradeTrigger tradeTrigger){ // 스탑 지정가 트리거 발동 후 지정가 등록 
        	try {
        		Log.print("call registerLimitOrder", 5, "call");
    			int orderIdx = Order.getOrderIdxByOrderNum(tradeTrigger.orderNum);
    			if (orderIdx < 0) { return; }
    			Order order = orderList.get(orderIdx);
    			
    			Date date = new Date(Calendar.getInstance().getTimeInMillis()); 
    			SimpleDateFormat sdf = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss"); 
    			String today = sdf.format(date);

    			Order newOrder = new Order(order.userIdx, order.symbol, "limit", order.position, order.entryPrice, order.buyQuantity, order.strategy, order.conclusionQuantity, order.leverage, order.marginType, order.paidVolume, order.postOnly, order.entryPriceForStop, order.auto, today, order.triggerPrice);
        		// order DB에 등록
        		EgovMap in = new EgovMap();
        		in.put("userIdx", newOrder.userIdx);
        		in.put("orderNum", newOrder.orderNum);
        		in.put("symbol", newOrder.symbol);
        		in.put("orderType", newOrder.orderType);
        		in.put("position", newOrder.position);
        		in.put("entryPrice", newOrder.entryPrice);
        		in.put("buyQuantity", newOrder.buyQuantity);
        		in.put("strategy", newOrder.strategy);
        		in.put("leverage", newOrder.leverage);
        		in.put("conclusionQuantity", newOrder.conclusionQuantity);
        		in.put("state", newOrder.state);
        		in.put("marginType", newOrder.marginType);
        		in.put("paidVolume", newOrder.paidVolume);
        		in.put("postOnly", newOrder.postOnly);
        		in.put("triggerPrice", newOrder.triggerPrice);
        		
        		order.updateOrderState("ordered");
        		order.removeOrderList();
    			Log.print("remove old order", 0, "buyStopLimit");
    			
    			QueryWait.pushQuery("insertOrder",newOrder.userIdx, in, QueryType.INSERT);
//        		sampleDAO.insert("insertOrder",in);
        		LocalDateTime now = LocalDateTime.now();
				System.out.println("현재시간 insertOrder : "+now);
        		Log.print("insert new order in: "+in, 0, "buyStopLimit");
        		
        		newOrder.addOrderList();
        		Position.updateLiquidationPriceByUser(newOrder.userIdx, order.symbol);
//        		int coinNum = Coin.getCoinNum(order.symbol);
        		//Hoga hoga = new Hoga(order.buyQuantity, order.entryPrice, coinNum, order.position);
        		//hoga.addHoga();
        		
        		//클라이언트에게 알리기
        		//showPopup(order.userIdx, order.symbol+" <spring:message code='pop.show.orderRegister'/>", 1);
        		showPopup(order.userIdx, "orderRegister", 1);
        		
        		// TriggerList에 등록
        		Log.print("insert TriggerList", 0, "buyStopLimit");
        		TradeTrigger newtradeTrigger = new TradeTrigger(""+newOrder.userIdx, newOrder.orderNum, newOrder.symbol, newOrder.orderType, newOrder.position, ""+order.entryPrice);
        		newtradeTrigger.addTradeTrigger();
			} catch (Exception e) {
				Log.print("registerLimitOrder err! "+e, 0, "err");
			}
        }

        private void updateSellPosition(Trade trade, Position oldPosition, Member member) { // 부분 청산 기존 포지션 DB 업데이트
        	try {
        		Log.print("call updateSellPosition", 5, "sellProcess");
        		// 기존 값 가져와서 새 값 계산
        		// 새 수량 = 기존 수량 - 판매 수량
        		BigDecimal newBuyQuantity = BigDecimal.valueOf(oldPosition.buyQuantity).subtract(BigDecimal.valueOf(trade.buyQuantity));
        		Log.print("newBuyQuantity = oldBuyQuantity("+oldPosition.buyQuantity+") - buyQuantity("+trade.buyQuantity+") = "+newBuyQuantity, 0, "updateSellPosition");
        		// 새 계약 USDT = 진입가격 * 새 수량
        		BigDecimal newVolume = BigDecimal.valueOf(oldPosition.entryPrice).multiply(newBuyQuantity);
        		Log.print("newVolume = entryPrice("+oldPosition.entryPrice+") * newBuyQuantity("+newBuyQuantity+") = "+newVolume, 0, "updateSellPosition");
        		// 새 포지션
        		Position newPosition = new Position(trade.symbol, 
							        				oldPosition.position, 
							        				oldPosition.entryPrice, 
							        				newBuyQuantity.doubleValue(), 
							        				newVolume.doubleValue(), 
							        				trade.leverage,
							        				member,
							        				oldPosition.marginType,
							        				oldPosition.orderType,
							        				oldPosition.openFee);
        		newPosition.updatePosition();
        		
        	} catch (Exception e) {
        		Log.print("updatePosition err! "+e, 0, "err");
        	}
        }
        
		public boolean checkOnlineUser(String userIdx) {
			for (WebSocketSession session : this.sessionSet) {
				if (session.isOpen()) {
					Map<String, Object> m = session.getAttributes();
					String sessionUserIdx = "" + m.get("userIdx");
					if (userIdx.equals(sessionUserIdx)) {
						return true;
					}
//					else{
//						return false;
//					}
				}
//				else{
//					return false;
//				}
			}
			return false;
		}
		
		public void initToUser(WebSocketSession session, JSONObject obj){
        	try {
        		Log.print("initToUser userIdx : "+session.getAttributes().get("userIdx").toString(), 6, "log");
        		initOrderAndPositionToUser(session, obj);
        		//initOrderToUser(session, obj);
        		//initPositionToUser(session, obj);
			} catch (Exception e) {
				Log.print("initToUser err! "+e, 0, "err");
			}
        }
        public void init(){
        	try {
        		Log.print("init", 6, "log");
        		initProjectSetting();
        		initAllMembers();
        		initOrder();        		
        		initPosition();
        		initTriggerList();
        		initCopytradeList();
        		initAutoCancelP2PDeposit();
        		ipBanList = (List<EgovMap>) sampleDAO.list("selectAllBanList");
    			userBanList = (List<EgovMap>) sampleDAO.list("selectAllUserBanList");
    			adminIpList = (List<EgovMap>) sampleDAO.list("selectAdminIp");
    			
    			spotManager.init();
        	} catch (Exception e) {
        		Log.print("init err! "+e, 0, "err");
        	}
        }
        
        public void initProjectSetting(){
        	EgovMap projectSetting = (EgovMap) sampleDAO.select("selectProjectSetting");
        	ArrayList<EgovMap> coinList = (ArrayList<EgovMap>) sampleDAO.list("selectCoinList");
        	setting = new Project(projectSetting, coinList, messageSource);
        }

        public void initAutoCancelP2PDeposit(){
        	if(Project.isP2PAutoCancel()){
        		List<EgovMap> dplist = (ArrayList<EgovMap>) sampleDAO.list("selectP2PDepositPendingList");
        		for(EgovMap m : dplist){
        			int p2pIdx = Integer.parseInt(m.get("idx").toString());
        			int userIdx = Integer.parseInt(m.get("useridx").toString());
        			LocalDateTime dt = Send.getLocalDateTime(m.get("mdate").toString(), "yyyy-MM-dd HH:mm:ss.S");
        			P2PAutoCancel.putAutoCancelList(p2pIdx, userIdx, dt);
        		}
        	}
        	
        }

        public void initAllMembers(){
        	List<Integer> memberList = (List<Integer>) sampleDAO.list("selectAllMemberIdx");
        	for(Integer i : memberList){
        		Member.getMemberByIdx(i);
        	}
        }
        
        public void initCopytradeList(){
        	try {
        		Log.print("call initCopytradeList", 5, "call");
        		copytradeList = new ArrayList<>();
        		List<EgovMap> selectList = (List<EgovMap>) sampleDAO.list("selectCopytradeAllList");
        		if(selectList != null){
        			for (int i = 0; i < selectList.size(); i++) {
        				Integer fixLev = (Integer)selectList.get(i).get("fixLeverage");
        				Double lossCutRate = (Double)selectList.get(i).get("lossCutRate");
        				Double profitCutRate = (Double)selectList.get(i).get("profitCutRate");
        				Double maxPositionQty = (Double)selectList.get(i).get("maxPositionQty");
        				Double followMoney = (Double)selectList.get(i).get("followMoney");
        				Double profit = (Double)selectList.get(i).get("profit");
        				Copytrade copy = new Copytrade((int)selectList.get(i).get("uidx"), 
        												(int)selectList.get(i).get("tidx"),
        												selectList.get(i).get("symbol").toString(),
        												Boolean.parseBoolean(selectList.get(i).get("isQtyRate").toString()), 
        												Double.parseDouble(selectList.get(i).get("fixQty").toString()),
        												fixLev, 
        												lossCutRate,
        												profitCutRate,
        												maxPositionQty,
        												(int)selectList.get(i).get("state"),
        												""+selectList.get(i).get("guid"),
        												followMoney,
        												profit,
        												Send.getTime(selectList.get(i).get("sdate").toString()));
        				copytradeList.add(copy);
        			}
        		}
			} catch (Exception e) {
				Log.print("initCopytradeList err! "+e, 0, "err");
			}
        }
        
        public void initTriggerList(){
        	try {
        		Log.print("call initTriggerList", 5, "call");
        		triggerList = new ArrayList<>();
            	List<EgovMap> selectList = (List<EgovMap>) sampleDAO.list("selectAllTradeTrigger");
            	if(selectList != null){
            		for (int i = 0; i < selectList.size(); i++) {
    					TradeTrigger newTrigger = new TradeTrigger(selectList.get(i).get("idx").toString(),
    																selectList.get(i).get("userIdx").toString(),
    																selectList.get(i).get("orderNum").toString(),
    																selectList.get(i).get("symbol").toString(),
    																selectList.get(i).get("triggerType").toString(),
    																selectList.get(i).get("position").toString(),
    																selectList.get(i).get("triggerPrice").toString());
    					triggerList.add(newTrigger);
    				}
            	}
         
			} catch (Exception e) {
				Log.print("initTriggerList err! "+e, 0, "err");
			}
        }

        
        public void initPosition(){
        	try {
        		Log.print("call initPosition", 5, "call");
        		positionList = new ArrayList<>();
            	List<EgovMap> selectList = (List<EgovMap>) sampleDAO.list("selectAllPosition");
            	if(selectList != null){
            		Log.print("selectList is not null", 6, "log");
            		for (int i = 0; i < selectList.size(); i++) {
            			Member positionMember = Member.getMemberByIdx(Integer.parseInt(selectList.get(i).get("userIdx").toString()));
            			if (positionMember == null) {
            				positionMember = Member.addMembers(selectList.get(i).get("userIdx").toString(),null);
						}
            			Double TP = null;
            			Double SL = null;
            			if(selectList.get(i).get("tp") != null)
            				TP = Double.parseDouble(selectList.get(i).get("tp").toString());
            			if(selectList.get(i).get("sl") != null)
            				SL = Double.parseDouble(selectList.get(i).get("sl").toString());
            			
            			double openFee = 0;
            			if(selectList.get(i).get("openFee") != null)
            				openFee = Double.parseDouble(selectList.get(i).get("openFee").toString());
            			
            			// DB에서 가져오기
    					Position position = new Position(selectList.get(i).get("symbol").toString(),
    														selectList.get(i).get("position").toString(),
    														selectList.get(i).get("entryPrice").toString(),
    														selectList.get(i).get("buyQuantity").toString(),
    														selectList.get(i).get("liquidationPrice").toString(), 
    														selectList.get(i).get("contractVolume").toString(), 
    														selectList.get(i).get("leverage").toString(),
    														"0",
    														positionMember,
    														selectList.get(i).get("marginType").toString(),
    														selectList.get(i).get("orderType").toString(),
    														selectList.get(i).get("fee").toString(),
    														TP,
    														SL,
    														openFee);
    					// positionList에 추가
    					position.addPositionList();
    					
    					if(TP != null){
    						tpList.add(position);
    					}
    					if(SL != null){
    						slList.add(position);
    					}
    				}
            	}
            	Log.print("positionList size = "+positionList.size(), 6, "log");
			} catch (Exception e) {
				Log.print("initPosition err! "+e, 0, "err");
			}
        }
        
        public void initOrder(){
        	try {
        		orderList = new ArrayList<>();
        		EgovMap in = new EgovMap();
        		in.put("state", "wait");
        		List<EgovMap> selectList = (List<EgovMap>) sampleDAO.list("selectOrderAll", in);
    			for (int i = 0; i < selectList.size(); i++) {    			
    				// DB에서 가져오기
    				boolean liq = false;
    				if(Integer.parseInt(selectList.get(i).get("isLiq").toString()) == 1){
    					liq = true;
    				}
    				Order order = new Order(selectList.get(i).get("userIdx").toString(),
			        						selectList.get(i).get("orderNum").toString(),
			        						selectList.get(i).get("symbol").toString(),
			        						selectList.get(i).get("orderType").toString(),
			        						selectList.get(i).get("position").toString(),
			        						selectList.get(i).get("entryPrice").toString(),
			        						selectList.get(i).get("buyQuantity").toString(),
			        						selectList.get(i).get("strategy").toString(), 
			        						selectList.get(i).get("conclusionQuantity").toString(), 
			        						selectList.get(i).get("leverage").toString(),
    										selectList.get(i).get("marginType").toString(),
    										selectList.get(i).get("paidVolume").toString(),
						    				selectList.get(i).get("postOnly").toString(),
						    				selectList.get(i).get("entryPriceForStop").toString(),
						    				selectList.get(i).get("auto").toString(),
						    				selectList.get(i).get("orderDatetime").toString(),
						    				Double.parseDouble(""+selectList.get(i).get("triggerPrice")),
						    				liq);
    				// positionList에 추가, 클라이언트에게 알림
    				order.addOrderList();
    			}
        	} catch (Exception e) {
        		Log.print("initOrder err! "+e, 0, "err");
        	}
        }
        
        public void initOrderAndPositionToUser(WebSocketSession session, JSONObject objp){
        	try {
        		Log.print("call initOrderAndPositionToUser", 5, "call");
        		int userIdx = Integer.parseInt(session.getAttributes().get("userIdx").toString());
        		String symbol = ""+objp.get("symbol"); // btcusd or btcusdt
        		String coinbet = ""+objp.get("coinbet");//usdt or inverse
        		Log.print("dbg1 userIdx:"+userIdx+" symbol:"+symbol, 5, "call");
        		JSONObject obj = new JSONObject();
        		obj.put("protocol", "initOrderAndPosition");
        		obj.put("userIdx", userIdx);
        		obj.put("symbol", symbol);
        		JSONArray j = new JSONArray();
        		
        		Log.print("st 포지션 리스트 ", 5, "call");
        		for (int i = 0; i < positionList.size(); i++) {
        			if (positionList.get(i).userIdx == userIdx 
        					&& symbol.compareTo(positionList.get(i).symbol)==0) {
        				Log.print(i+" 포지션 리스트 ", 5, "call");
        				JSONObject item = new JSONObject();   
                		item.put("userIdx", positionList.get(i).userIdx);
                		item.put("symbol", positionList.get(i).symbol);
                		item.put("position", positionList.get(i).position);
                		item.put("entryPrice", positionList.get(i).entryPrice);
                		item.put("buyQuantity", positionList.get(i).buyQuantity);
                		item.put("liquidationPrice", positionList.get(i).liquidationPrice);
                		item.put("contractVolume", positionList.get(i).contractVolume);
                		item.put("leverage", positionList.get(i).leverage);
                		item.put("margin", 0); //<=== 유지증거금 변수는 사라졌지만 다른 모듈과의 융통성을 위해 남겨둠
                		item.put("marginType", positionList.get(i).marginType);
                		item.put("fee", positionList.get(i).fee);
                		item.put("TP", positionList.get(i).TP);
                		item.put("SL", positionList.get(i).SL);
                		//sendPositionInit(positionList.get(i));
                		j.add(item);
                		/*String s = ""+orderList.get(i).symbol;
    	        		if(symbol.compareTo(s)==0){
    	        			Log.print("symbol:"+symbol+" s:"+s, 2, "log");
    	        			j.add(item);
    	        		}*/                		
					}
				}        		
        		obj.put("plist", j);
        		Log.print("end 포지션 리스트 ", 5, "call");
        		
        		Log.print("st 주문 리스트 ", 5, "call");
        		JSONArray orderj = new JSONArray();
    			for (int i = 0; i < orderList.size(); i++) {
    				if (orderList.get(i).userIdx == userIdx
    						&& symbol.compareTo(orderList.get(i).symbol)==0) {   
    					// positionList에 추가, 클라이언트에게 알림
    					Log.print(i+" 주문 리스트 ", 5, "call");
    					JSONObject item = new JSONObject();    					
    	        		item.put("userIdx", orderList.get(i).userIdx);
    	        		item.put("orderNum", orderList.get(i).orderNum);
    	        		item.put("symbol", orderList.get(i).symbol);
    	        		item.put("orderType", orderList.get(i).orderType);
    	        		item.put("position", orderList.get(i).position);
    	        		item.put("entryPrice", orderList.get(i).entryPrice);
    	        		item.put("buyQuantity", orderList.get(i).buyQuantity);
    	        		item.put("leverage", orderList.get(i).leverage);
    	        		item.put("strategy", orderList.get(i).strategy);
    	        		item.put("paidVolume", orderList.get(i).paidVolume);
    	        		item.put("mainMargin", 0);//유지증거금 변수는 사라졌지만 다른 모듈과 융통성을 위해 남겨둠.
    	        		item.put("marginType", orderList.get(i).marginType);
    	        		item.put("conclusionQuantity", orderList.get(i).conclusionQuantity);
    	        		item.put("orderTime", orderList.get(i).orderTime);
    	        		item.put("triggerPrice", orderList.get(i).triggerPrice);
    	        		item.put("entryPriceForStop", orderList.get(i).entryPriceForStop);
    	        		
    	        		//String s = ""+orderList.get(i).symbol;    	        		
    	        		//Log.print("symbol:"+symbol+" s:"+s, 2, "log");
    	        		orderj.add(item);
    	        		
    					//sendOrderInit(orderList.get(i));
					}
    			}
    			obj.put("olist", orderj);
    			Log.print("end 주문 리스트 "+obj.toJSONString() , 5, "call");
    			
    			sendMessageToMe(session, obj); 
    			sise.sendSiseServer(obj);
			} catch (Exception e) {
				Log.print("initPositionToUser err! "+e, 0, "err");
			}
        }        

        public void initOrderAndPositionToUserSise(WebSocketSession session, JSONObject objp){
        	try {
        		Log.print("call initOrderAndPositionToUserSise", 5, "call");
        		int userIdx = Integer.parseInt(session.getAttributes().get("userIdx").toString());
        		String symbol = ""+objp.get("symbol");
        		Log.print("dbg1 userIdx:"+userIdx+" symbol:"+symbol, 5, "call");
        		JSONObject obj = new JSONObject();
        		obj.put("protocol", "initOrderAndPosition");
        		obj.put("userIdx", userIdx);
        		obj.put("symbol", symbol);
        		JSONArray j = new JSONArray();
        		
        		Log.print("st 포지션 리스트 ", 5, "call");
        		for (int i = 0; i < positionList.size(); i++) {
        			if (positionList.get(i).userIdx == userIdx) {
        				Log.print(i+" 포지션 리스트 ", 5, "call");
        				JSONObject item = new JSONObject();   
                		item.put("userIdx", positionList.get(i).userIdx);
                		item.put("symbol", positionList.get(i).symbol);
                		item.put("position", positionList.get(i).position);
                		item.put("entryPrice", positionList.get(i).entryPrice);
                		item.put("buyQuantity", positionList.get(i).buyQuantity);
                		item.put("liquidationPrice", positionList.get(i).liquidationPrice);
                		item.put("contractVolume", positionList.get(i).contractVolume);
                		item.put("leverage", positionList.get(i).leverage);
                		item.put("margin", 0);//유지 증거금은사라졌지만 다른 모듈과 융통성을 위해 남겨둠
                		item.put("marginType", positionList.get(i).marginType);
                		item.put("fee", positionList.get(i).fee);
                		j.add(item);                              	
					}
				}        		
        		obj.put("plist", j);
        		Log.print("end 포지션 리스트 ", 5, "call");
        		
        		Log.print("st 주문 리스트 ", 5, "call");
        		JSONArray orderj = new JSONArray();
    			for (int i = 0; i < orderList.size(); i++) {
    				if (orderList.get(i).userIdx == userIdx) {    					    				
    					// positionList에 추가, 클라이언트에게 알림
    					Log.print(i+" 주문 리스트 ", 5, "call");
    					JSONObject item = new JSONObject();    					
    	        		item.put("userIdx", orderList.get(i).userIdx);
    	        		item.put("orderNum", orderList.get(i).orderNum);
    	        		item.put("symbol", orderList.get(i).symbol);
    	        		item.put("orderType", orderList.get(i).orderType);
    	        		item.put("position", orderList.get(i).position);
    	        		item.put("entryPrice", orderList.get(i).entryPrice);
    	        		item.put("buyQuantity", orderList.get(i).buyQuantity);
    	        		item.put("leverage", orderList.get(i).leverage);
    	        		item.put("strategy", orderList.get(i).strategy);
    	        		item.put("paidVolume", orderList.get(i).paidVolume);
    	        		item.put("mainMargin", 0);////유지 증거금은사라졌지만 다른 모듈과 융통성을 위해 남겨둠
    	        		item.put("marginType", orderList.get(i).marginType);
    	        		item.put("conclusionQuantity", orderList.get(i).conclusionQuantity);
    	        		item.put("orderTime", orderList.get(i).orderTime);
    	        		item.put("triggerPrice", orderList.get(i).triggerPrice);
    	        		item.put("entryPriceForStop", orderList.get(i).entryPriceForStop);
    	        		
    	        		String s = ""+orderList.get(i).symbol;
    	        		if(symbol.compareTo(s)==0){
    	        			Log.print("symbol:"+symbol+" s:"+s, 2, "log");
    	        			orderj.add(item);
    	        		}
					}
    			}
    			obj.put("olist", orderj);
    			Log.print("end 주문 리스트 "+obj.toJSONString() , 5, "call");
    			    			
    			sise.sendSiseServer(obj);
			} catch (Exception e) {
				Log.print("initPositionToUser err! "+e, 0, "err");
			}
        }          
        
        @Override
        public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        	Log.print("client disconnected ID:"+session.getId(), 0, "call");
                // this.logger.error("web socket error!", exception);
        }

        @Override
        public boolean supportsPartialMessages() {
    		Log.print("call method!", 5, "call");
            return super.supportsPartialMessages();
        }

        public WebSocketSession GetSession(String idx){
            for (WebSocketSession session : this.sessionSet) {
                if (session.isOpen()) {
            		Map<String, Object> m = session.getAttributes();
            		if( m.get("userIdx") != null && (""+m.get("userIdx")).compareTo(idx) ==0 )
            			return session;

                }
            }
        	return null;
        }
        
	    public void sendMessageToMe(WebSocketSession session, JSONObject obj) {
	    	Log.print("sendMessageToMe session:"+session , 5, "call");
	    	if(session == null)
	    		return;
	    	
            if (session.isOpen() ) {
        		Log.print("sendMessageToMe 데이터 전송  protocol:"+obj.get("protocol") , 5, "call");
        		synchronized(sendList){
        			sendList.add(new SendMsg(session,obj));
        		}
            }
	    }        
	    public void sendMessageToMeAllBrowser(JSONObject obj) {
	    	Log.print("sendMessageToMeAllBrowser" , 5, "call");
	    	String idx = ""+obj.get("userIdx");
	    	String game = "futures";
	        for (WebSocketSession session : this.sessionSet) {
                if (session.isOpen()) {
            		Map<String, Object> m = session.getAttributes();   
            		String sessionGame = ""+m.get("game"); 
            		if(sessionGame.compareTo(game)!=0)	continue;
            		if( m.get("userIdx") != null && (""+m.get("userIdx")).compareTo(idx) ==0 ){
            			synchronized(sendList){
            				sendList.add(new SendMsg(session,obj));
            			}
            		}
                }
            }           
	    }        

        public void sendMessageAll(JSONObject obj) {
            for (WebSocketSession session : this.sessionSet) {
                if (session.isOpen()) {
            		synchronized(sendList){
            			sendList.add(new SendMsg(session,obj));
            		}
//             		session.sendMessage(new TextMessage(obj.toString()));
                }
            }
        }
        
	    public void sendAdminMessage(JSONObject obj) {
			for (WebSocketSession session : this.sessionSet) {
				if (session.isOpen()) {
					Map<String, Object> m = session.getAttributes();
					String admin = "" + m.get("adminLogin");
					if (admin.compareTo("1") == 0){
						synchronized (session) {
							sendList.add(new SendMsg(session,obj));
//							session.sendMessage(new TextMessage(obj.toString()));
						}
					}
				}
			}
		}
	    
	    public void OnManagerSendHoga(JSONObject obj){
	    	sise.sendSiseServer(obj);
	    }
	    
	    static public String result = null;
	    static public double triggerPriceTmp = 0;	    
    	static public double bidtmp = 0;
    	static public double asktmp = 0;
    	static public double bidHtmp = 0;
    	static public double askHtmp = 0;    
    	static public double bidLtmp = 0;
    	static public double askLtmp = 0;    	
    	
    	static public String symboltmp = null;
    	public static int logNum = 0;
    	public static int reInit = 0;//1로 변경시 초기화
    	public static String logTime = null;
    	public static String orderIdxTmp = null;
    	
		public static long lastSiseGetTime = -1;
		
		private void reInitCheck(){
			if(reInit == 1){
    			Log.print("reInit:"+reInit, 5, "call");
    			init();	  
    			reInit = 0;
    		}
		}
		
		private int getMsgProcessQty(){
			int msgSize = msgList.size();
			if(msgSize < 10)
				return 1;
			else if(msgSize > 5000)
				return 500;
			
			return (int)(msgSize / 10);
		}
		
//		private void triggerRemove(Iterator<TradeTrigger> iter, TradeTrigger trigger){
//			trigger.removeTradeTriggerInDB();
//			iter.remove();
//		}
		
		private void triggerListCheck(){
			double currentBidSise = 0;
			double currentAskSise = 0;
			
			logNum = 1;
			for (Coin coin : Project.getUseCoinList()) {
				coin.siseTmpChange();
			}
			spotManager.spotListCheck();
			
			boolean loop = true;
			int loopCnt = 0;
			while(loop){
				loopCnt++;
				loop = false;
				if(loopCnt > 10){
					Log.print("triggerListCheck Loop 10번 이상 발생. loop 탈출", 1, "err");
					break;
				}
				
				for (TradeTrigger trigger : SocketHandler.triggerList) {
					try {
						Coin coin = Coin.getCoinInfo(trigger.symbol);
						if(!coin.isUse) continue;
						
						logNum = 2;
						
						if(coin.nullCheck()) return;
						
						currentBidSise = Double.parseDouble(coin.bidsPriceList[0]);
						bidtmp = currentBidSise;
						
						logNum = 3;
						currentAskSise = Double.parseDouble(coin.asksPriceList[0]);
						asktmp = currentAskSise;
						
						logNum = 4;
						bidHtmp = coin.tmpBidsH;
						
						logNum = 5;
						bidLtmp = coin.tmpBidsL;
						
						logNum = 6;
						askHtmp = coin.tmpAsksH;
						
						logNum = 7;
						askLtmp = coin.tmpAsksL;
						
						logNum = 8;											
						symboltmp = trigger.symbol;
						
						logNum = 9;	
						if (trigger != null) {
							
							double siseH = coin.tmpBidsH;
							double siseL = coin.tmpBidsL;
							
							if(trigger.position.compareTo("short") == 0){
								siseH = coin.tmpAsksH;
								siseL = coin.tmpAsksL;
							}
							if(trigger.triggerType.compareTo("stopLimit") == 0 || trigger.triggerType.compareTo("stopMarket") == 0)
							{																														
								int orderIdx = Order.getOrderIdxByOrderNum(trigger.orderNum);											
								if (orderIdx < 0) {
									orderIdxTmp =  trigger.orderNum;
									Log.print("afterPropertiesSet 문제 발생 오더번호:"+trigger.orderNum, 5, "buyLimit");
									continue; 
								}
								logNum = 10;
								Order order = orderList.get(orderIdx);										
								if( (trigger.triggerPrice >= order.entryPriceForStop && siseH>=trigger.triggerPrice)
										|| (trigger.triggerPrice <= order.entryPriceForStop && siseL<=trigger.triggerPrice)) 
								{
									triggerPriceTmp = trigger.triggerPrice;
									if(trigger.triggerType.compareTo("stopLimit") == 0){ // 스탑 지정가일 때 -> 트리거 가격 도달 -> 지정가 주문
										logNum = 11;
										registerLimitOrder(trigger);// 지정가 주문 등록
										loop = true;
										break;
									}else if(trigger.triggerType.compareTo("stopMarket") == 0){ // 스탑 시장가일 때 -> 트리거 가격 도달 -> 시장가 주문													
										logNum = 12;
										buyMarketTrigger(trigger);// 시장가 구매
										loop = true;
										break;
									}
								}
								continue;
							}
							
							if(trigger.position.compareTo("long") == 0){ // 주문이 매수일 때										
								if(trigger.triggerPrice >= siseL ){ // 시세가 트리거 가격보다 낮아졌을 때
									if(trigger.triggerType.compareTo("inPosition") == 0){ // 포지션 -> 강제 청산 금액 도달 -> 강제 청산
										EgovMap in = new EgovMap();
										in.put("sise", siseL);
										in.put("triggerPrice", trigger.triggerPrice);
										in.put("userIdx", trigger.userIdx);
										in.put("position", trigger.position);
										in.put("symbol", trigger.symbol);
										QueryWait.pushQuery("insertLiqlog",trigger.userIdx, in, QueryType.INSERT);
										
										Log.print("청산체크 롱  sise = "+sise+" < triggerPrice = "+trigger.triggerPrice, 0, "liquidation");
										logNum = 13;
										sellMarketTrigger(trigger, siseL);// 강제 청산		
										loop = true;
										break;
									}else if(trigger.triggerType.compareTo("limit") == 0){ // 지정가 주문일 때 -> 지정가 도달 -> 자동 구매		
										logNum = 14;
										buyLimitTrigger(trigger);// 지정가 구매
										loop = true;
										break;
									}
									else{//오류
										logNum = 15;
										Log.print("check triggerType error triggerType: "+trigger.triggerType, 0, "err");
									}
								}
							}else if(trigger.position.compareTo("short") == 0){ // 주문이 매도일 때
								if(trigger.triggerPrice <= siseH){ // 시세가 트리거 가격보다 높아졌을 때
									if(trigger.triggerType.compareTo("inPosition") == 0){ // 포지션 -> 강제 청산 금액 도달 -> 강제 청산
										EgovMap in = new EgovMap();
										in.put("sise", siseH);
										in.put("triggerPrice", trigger.triggerPrice);
										in.put("userIdx", trigger.userIdx);
										in.put("position", trigger.position);
										in.put("symbol", trigger.symbol);
										QueryWait.pushQuery("insertLiqlog",trigger.userIdx, in, QueryType.INSERT);
										
										Log.print("청산체크 숏  sise = "+sise+" > triggerPrice = "+trigger.triggerPrice, 0, "liquidation");
										logNum = 16;
										sellMarketTrigger(trigger, siseH);// 강제 청산
										loop = true;
										break;
									}else if(trigger.triggerType.compareTo("limit") == 0){ // 지정가 주문일 때 -> 지정가 도달 -> 자동 구매
										logNum = 17;
										buyLimitTrigger(trigger);// 지정가 구매
										loop = true;
										break;
									}
									else{//오류
										logNum = 18;
										Log.print("check triggerType error triggerType: "+trigger.triggerType, 0, "err");
									}
								}
							}else{//오류
								logNum = 19;
								Log.print("check position error orderNum: "+trigger.orderNum, 0, "err");
							}
							//marginRisk();
						}else{
							logNum = 20;
							Log.print("trigger is null", 0, "err");
						}
						
					} catch (Exception e) {
						loop = false;
						Log.print("trigger 에러 발생. userIdx "+trigger.userIdx+" / "+trigger.toString(), 1, "err");
						// TODO: handle exception
					}
				}
				logNum = 0;
			}
		}

	public void cmdProcess() throws Exception {
		SocketHandler.logNum = 21;
		UserMsg um = null;
		
		int ff=msgList.size(),ss=0;
		synchronized (msgList) {
			if (msgList.size() > 0) {
				if(msgList.size() > 10)
					Log.print("cmdProcess msgList size = "+msgList.size(), 1, "call");
				um = msgList.poll();
			}
		}
		SocketHandler.logNum = 22;
		ss =msgList.size();
		
		if( ff == ss && ff != 0){
			Log.print("err 메세지 큐 안 줄어듬", 1, "err");
		}
		
		if (um == null)
			return;
		WebSocketSession session = um.session;
		String msg = um.msg;
		SocketHandler.logNum = 23;
		// =================================================} msg
		JSONParser p = new JSONParser();
		JSONObject obj = null;
		
		try {
			obj = (JSONObject) p.parse(msg);
		} catch (Exception e) {
			Log.print("cmdProcess 파싱 중 에러. msg = "+msg, 1, "err_notsend");
			return;
		}
		
		SocketHandler.logNum = 24;
		if(fixstat == 1){ rest(); return;}
        
		long before = System.currentTimeMillis();
		
		String protocol = obj.get("protocol").toString();
		switch(protocol){
		case "buyBtn": 				OnBuyBtn(session, obj); break;
		case "setTPSL":				setTPSL(session, obj); break;
		case "login":				OnLogin(session, obj); break;
		case "adminLogin":			OnAdminLogin(session, obj); break;
		case "sendLinePacket":		sendLinePacket(session, obj); break;
		case "orderCancel":			cancelOrder(obj); break;
		case "orderAllCancel":		cancelAllOrder(obj); break;
		case "changeLeverage":		changeLeverage(session, obj); break;
		case "changeLeverageStart":	changeLeverageStart(session, obj); break;
		case "changeSymbol":		initOrderAndPositionToUserSise(session, obj); break;
		case "submitRequest":		submitRequest(obj); break;
		case "newMember":			newMember(obj); break;
		}
		spotManager.onMessage(obj,session);
		
		long after = System.currentTimeMillis();
		
        Log.print("처리완료 걸린 시간 = "+(after - before)+" ms / 프로토콜 = "+obj.get("protocol"), 1, "timecheck");
	}
			        	  
	@Override
	public void afterPropertiesSet() throws Exception {
		Log.print("call afterPropertiesSet", 5, "call");
		try {
			init();			
			// MiddlewareManager.getHandle().startThread();
			
		} catch (Exception e) {
			Log.print("afterPropertiesSet init err! " + e, 0, "err");
		}
		sise = new SiseManager();
		Thread thread = new Thread() {
			@Override
			public void run() {
				while (true) {
					try {
						Thread.sleep(10);
						if(fixstat == 1) return; //점검일때 트리거 실행도 안함.
						
						long before = System.currentTimeMillis();
						
						reInitCheck();
						
						long after = System.currentTimeMillis();
						long time = after - before;
						if(time > 5) Log.print("메인스레드 호출 종료 걸린시간 = "+time+" ms / reInitCheck", 1, "timecheck");
						before = System.currentTimeMillis();
						
						Coin.coinDisconnectedCheck();
						
						after = System.currentTimeMillis();
						time = after - before;
						if(time > 5) Log.print("메인스레드 호출 종료 걸린시간 = "+time+" ms / coinDisconnectedCheck", 1, "timecheck");
						before = System.currentTimeMillis();
						
						triggerListCheck();						
						
						after = System.currentTimeMillis();
						time = after - before;
						if(time > 5) Log.print("메인스레드 호출 종료 걸린시간 = "+time+" ms / triggerListCheck", 1, "timecheck");
						before = System.currentTimeMillis();
						
						Position.checkTPSL();
						
						after = System.currentTimeMillis();
						time = after - before;
						if(time > 5) Log.print("메인스레드 호출 종료 걸린시간 = "+time+" ms / Position.checkTPSL", 1, "timecheck");
						before = System.currentTimeMillis();
						
						Copytrade.allCutCheck();
						
						after = System.currentTimeMillis();
						time = after - before;
						if(time > 5) Log.print("메인스레드 호출 종료 걸린시간 = "+time+" ms / Copytrade.allCutCheck", 1, "timecheck");
						before = System.currentTimeMillis();
						
						int msize = msgList.size();
						if(msize > 0){
							int msgQty = getMsgProcessQty();
							for(int i=0;i<msgQty;i++)
								cmdProcess();
						}

					} catch (Exception e) {
						if(logNum >= 20){ // 
							Log.print(logNum + " afterPropertiesSet ERROR " + e.toString() + " bidtmp:" + bidtmp
									+ " asktmp:" + asktmp, 2, "err_notsend");
						}else{
							Log.print(logNum + " afterPropertiesSet ERROR " + e.toString() + " bidtmp:" + bidtmp
									+ " asktmp:" + asktmp, 2, "err");
						}
						e.printStackTrace();
					}
				}
			}
		};
		thread.start();
		
		Thread queryThread = new Thread() {
			@Override
			public void run() {
				while (true) {
					try {
						Thread.sleep(10000);
						
						long before = System.currentTimeMillis();
						QueryWait.QueryListStart(queryList,"");
						
						long after = System.currentTimeMillis();
						long time = after - before;
						
						if(time > 5) Log.print("쿼리스레드 호출 종료 걸린시간 = "+time+" ms / queryList", 1, "timecheck");
						before = System.currentTimeMillis();
						
						QueryWait.QueryListStart(updateQueryList,"UPDATE");
						
						after = System.currentTimeMillis();
						time = after - before;
						if(time > 5) Log.print("쿼리스레드 호출 종료 걸린시간 = "+time+" ms / updateQueryList", 1, "timecheck");
						
						SiseManager.autoConnectCheck(sise);

					} catch (Exception e) {
						Log.print("queryThread ERROR " + e.toString(), 2, "error3");
						e.printStackTrace();
					}
				}
			}
		};
		queryThread.start();
		Thread sendThread = new Thread() {
			@Override
			public void run() {
				while (true) {
					try {
						Thread.sleep(100);
						if(sendList.size() != 0){
							synchronized (sendList) {
								for(SendMsg send : sendList){
									sendStartList.add(send.deepCopy());
								}
								sendList.clear();
							}
							while(sendStartList.size() != 0){
								SendMsg smg = sendStartList.poll();
								if(smg != null && smg.session != null)
									smg.send();
							}
						}

					} catch (Exception e) {
						Log.print("sendThread ERROR " + e.toString(), 2, "error3");
						e.printStackTrace();
					}
				}
			}
		};
		sendThread.start();
	}
}