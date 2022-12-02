package egovframework.example.sample.web.spot;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.web.socket.WebSocketSession;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.QueryWait;
import egovframework.example.sample.classes.SendMsg;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.Wallet;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SpotManager {
	public void init(){
    	try {
    		Log.print("SpotInit", 6, "log");    		
    		initOrder();        		    		
    		initTriggerList();    		    		
    	} catch (Exception e) {
    		Log.print("init err! "+e, 0, "err");
    	}
    }
	String spotOrderIdxTmp = null;
	double spotTriggerPriceTmp = 0;
	public void spotListCheck(){
		double bidHtmp = 0;
		double bidLtmp = 0;
		double askHtmp = 0;
		double askLtmp = 0;
		String symboltmp = null;
		try {
			
		
			for (SpotTradeTrigger trigger : SocketHandler.spotTriggerList) {
				try {
					Coin coin = Coin.getCoinInfo(trigger.symbol);
					if(coin.nullCheck()) return;
					bidHtmp = coin.tmpBidsH;
					bidLtmp = coin.tmpBidsL;
					askHtmp = coin.tmpAsksH;
					askLtmp = coin.tmpAsksL;
					symboltmp = trigger.symbol;
					
					if (trigger != null) {
						double siseH = coin.tmpBidsH;
						double siseL = coin.tmpBidsL;
						
						if(trigger.position.compareTo("short") == 0){
							siseH = coin.tmpAsksH;
							siseL = coin.tmpAsksL;
						}
						
						//스탑마켓
						if(trigger.triggerType.compareTo("stopLimit") == 0 || trigger.triggerType.compareTo("stopMarket") == 0)
						{	
							int orderIdx = SpotOrder.getOrderIdxByOrderNum(trigger.orderNum);											
							if (orderIdx < 0) {
								spotOrderIdxTmp =  trigger.orderNum;
								Log.print("afterPropertiesSet 문제 발생 오더번호:"+trigger.orderNum, 5, "buyLimit");
								continue; 
							}
							SpotOrder order = SocketHandler.spotOrderList.get(orderIdx);	
							if( (trigger.triggerPrice >= order.entryPriceForStop && siseH>=trigger.triggerPrice)
									|| (trigger.triggerPrice <= order.entryPriceForStop && siseL<=trigger.triggerPrice)) 
							{
								spotTriggerPriceTmp = trigger.triggerPrice;
								if(trigger.triggerType.compareTo("stopLimit") == 0){ // 스탑 지정가일 때 -> 트리거 가격 도달 -> 지정가 주문								
									//registerLimitOrder(trigger);// 지정가 주문 등록
								}else if(trigger.triggerType.compareTo("stopMarket") == 0){ // 스탑 시장가일 때 -> 트리거 가격 도달 -> 시장가 주문																					
									buyLimitTrigger(trigger);// 시장가 구매
								}
							}
						}					
						//시장가진입
						else if(trigger.triggerType.compareTo("market") == 0){
							buyLimitTrigger(trigger);// 시장가 구매
						}					
						//limit buy
						else if(trigger.position.compareTo("long") == 0){
							if(trigger.triggerPrice >= siseL ){ // 시세가 트리거 가격보다 낮아졌을 때
								buyLimitTrigger(trigger);// 지정가 구매
							}
						}
						//limit sell
						else if(trigger.position.compareTo("short") == 0){
							if(trigger.triggerPrice <= siseH){ // 시세가 트리거 가격보다 높아졌을 때
								buyLimitTrigger(trigger);// 지정가 구매
							}
						}				
					}
				}catch(Exception e){
					Log.print("SPOT: trigger 에러 발생. userIdx "+trigger.userIdx+" / "+trigger.toString(), 1, "err");
				}
			}
			
			SocketHandler.spotTriggerList.removeAll( SocketHandler.spotTmpTriggerList );
			SocketHandler.spotTmpTriggerList.clear();
					
		}catch(Exception e){
			Log.print("SPOT: Thread error", 1, "err");
		}	
	}
	public void onMessage(JSONObject obj,WebSocketSession session){
		
		String protocol = obj.get("protocol").toString();
		switch(protocol){
		case "spotBuyBtn":	SpotBuyBtn(session, obj); break;
		case "spotLogin":	OnSpotLogin(session, obj); break;
		case "spotOrderCancel":	cancelOrder(obj); break;
		}

	}
	
	private void OnSpotLogin(WebSocketSession session, JSONObject obj){
    	Log.print("call OnSpotLogin", 5, "call" );
    	try {
    		String userIdx = obj.get("userIdx").toString();
    		String game = "spot";//""+obj.get("game");        		
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
    			
		} catch (Exception e) {
			Log.print("login msg err! - "+e, 0, "err" );
		}
    }
	
	private void SpotBuyBtn(WebSocketSession session, JSONObject obj){
		Log.print("---------------call SpotBuyBtn---------------", 5, "call" );
		//종목
		String symbol = obj.get("symbol").toString();		
		if (symbol == null || symbol.compareTo("") == 0 || symbol.compareTo("null") == 0) {
			Log.print("OnBuyBtn wrong try symbol : "+symbol, 0, "err" );
			showPopup(Integer.parseInt(session.getAttributes().get("userIdx").toString()), "wrongSymbol", 2);
			return;
		}
		//회원체크
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
		if(Project.isKyc() && !user.isKyc){
			showPopup(user.userIdx, "kycPop", 2);
    		return;
		}
		if(user.p2pCheck()){
			showPopup(user.userIdx, "p2pStop", 2);
			Log.print("진행중 P2P 있음", 5, "qabuy" );
			return;
		}
		//수량
		Coin coin = Coin.getCoinInfo(symbol);
		Log.print("코인 시세 :"+coin.getSise("long"), 5, "qabuy" );
		double buyQuantity = PublicUtils.toFixed(Double.parseDouble(obj.get("buyQuantity").toString()), 5);
		double min = 0.0001;//PublicUtils.toFixed(SocketHandler.sh.getMinValue(coin.qtyFixed),coin.qtyFixed);
		if(buyQuantity < min){
			showPopup(user.userIdx, "wrongQuantity", 2);
			Log.print("buyQuantity 없음 :"+buyQuantity, 5, "qabuy" );
			return;
		}
		//진입가
		double entryPrice = PublicUtils.toFixed(Double.parseDouble(obj.get("entryPrice").toString()), coin.priceFixed);
		if(entryPrice < 0 || entryPrice < SocketHandler.getMinValue(coin.priceFixed))	{
			showPopup(user.userIdx, "wrongEntryPrice", 2);
			Log.print("entryPrice 없음 :"+entryPrice, 5, "qabuy" );
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
		
		String triggerPrice = ""+obj.get("triggerPrice");
		if(triggerPrice.compareTo("")==0)	{
			showPopup(Integer.parseInt(session.getAttributes().get("userIdx").toString()), "wrongTriggerPrice", 2);
			Log.print("triggerPrice 없음 :"+triggerPrice, 5, "qabuy" );
			return;
		}
		
		if(orderType.compareTo("market") == 0){			
			registerOrder(session, user, obj);
		}else if(orderType.compareTo("market") == 0 || orderType.compareTo("limit") == 0 || orderType.compareTo("stopLimit") == 0 || orderType.compareTo("stopMarket") == 0){        			
			// 지정가, 스탑 일 때
			registerOrder(session, user, obj);
		}else{
			Log.print("protocol orderType err! orderType : "+orderType, 0, "err" );
		}
	}

	public void registerOrder(WebSocketSession session, Member user, JSONObject obj){
		try {
			Log.print("SPOT: call SpotManager registerOrder", 5, "buyProcess");
    		if(SpotOrder.getOrderList(user.userIdx).size() >= SpotOrder.Max){
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
					+" buyQuantity:"+obj.get("buyQuantity").toString(), 5, "buyProcess");
			
			
			Coin coin = Coin.getCoinInfo(obj.get("symbol").toString());
    		double entryPrice = Double.parseDouble(obj.get("entryPrice").toString());
    		double buyQuantity = Double.parseDouble(obj.get("buyQuantity").toString());
    		
    		SpotOrder order = new SpotOrder(obj.get("userIdx").toString(), obj.get("symbol").toString(), obj.get("orderType").toString(), 
    				obj.get("position").toString(),  entryPrice, buyQuantity, today, triggerPrice);
    		
    		String position = obj.get("position").toString(); //long(buy) short(sell)
    		//BUY
    		if(position.compareTo("long")==0){
    			//현물USDT돈체크 
    			double myUSDT = user.getWithdrawWalletC("USDT");		
    			//구매 실패
    			if(myUSDT < order.paidVolume){
    				showPopup(user.userIdx, "notBalance", 2);
    				Log.print("limit 주문 진입 실패", 0, "buyLimit");
    				showPopup(user.userIdx, "nonBalanceCancel", 2);
    				orderFail(order, "balanceCancle");
    				return;
    			}
    		}else if(position.compareTo("short")==0){
    			//현물BTC돈체크
    			double myBTC = user.getWithdrawWalletC(order.symbol);
    			if(myBTC < order.buyQuantity){
    				showPopup(user.userIdx, "notBalance", 2);
    				Log.print("limit 주문 진입 실패", 0, "buyLimit");
    				showPopup(user.userIdx, "nonBalanceCancel", 2);
    				orderFail(order, "balanceCancle");
    				return;
    			}
    		}else{
    			return;
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
    		in.put("conclusionQuantity", order.conclusionQuantity);
    		in.put("state", order.state);
    		in.put("paidVolume", order.paidVolume);
    		in.put("entryPriceForStop", order.entryPriceForStop);
    		in.put("triggerPrice", order.triggerPrice);
//    		sampleDAO.insert("insertOrder",in);  
    		QueryWait.pushQuery("insertSpotOrder",order.userIdx, in, QueryType.INSERT);
    		
    		order.addOrderList();// 주문 추가
    		showPopup(order.userIdx, "orderRegister", 1);
    		
    		// TriggerList에 등록
    		SpotTradeTrigger tradeTrigger = new SpotTradeTrigger(""+order.userIdx, order.orderNum, order.symbol, order.orderType, order.position, ""+order.entryPrice);
			tradeTrigger.addTradeTrigger();
		} catch (Exception e) {
			Log.print("SpotRegisterOrder err! "+e+" obj : "+obj, 0, "err");
		}
	}
	
	public void buyLimitTrigger(SpotTradeTrigger tradeTrigger){ 
		Log.print("buyLimitTrigger---------------지정가 구매 시작", 5, "buyLimit");
		int orderIdx = SpotOrder.getOrderIdxByOrderNum(tradeTrigger.orderNum);
		if(orderIdx == -1){
			Log.print("문제있는오더 tradeTrigger 삭제", 1, "err");
			tradeTrigger.removeTradeTriggerInDB();
			return;
		}
		SpotOrder order = SocketHandler.spotOrderList.get(orderIdx);
		if (orderIdx < 0) { return; }
		
		WebSocketSession session = SocketHandler.sh.GetSession(""+tradeTrigger.userIdx);		
		Member member = Member.getMemberByIdx(Integer.parseInt(""+tradeTrigger.userIdx));
		Coin coin = Coin.getCoinInfo(order.symbol);
		double sise = coin.getTailSise(order.position);
		
		
		BigDecimal price = BigDecimal.valueOf(order.entryPrice);
		if(order.orderType.compareTo("market")==0 || order.orderType.compareTo("stopMarket")==0){
			price = BigDecimal.valueOf(sise);
		}else if(order.orderType.compareTo("limit")==0){
			//buy - 더 낮게 걸려고함 (더 낮게 걸고 기다림 , 더 높게 걸면 바로 시장가로 처리)
			//sell - 더 높게 걸려고함 (더 높게 걸고 기다림 , 더 낮게 걸면 바로 시장가로 처리)
			if((order.position.compareTo("long")==0 && order.entryPrice > order.entryPriceForStop) || 
					(order.position.compareTo("short")==0 && order.entryPrice < order.entryPriceForStop)	){  
				price = BigDecimal.valueOf(sise);
			}
		}
		
		BigDecimal volume = BigDecimal.ZERO;  // 계약 USDT
		BigDecimal newBuyQuantity = BigDecimal.valueOf(order.buyQuantity);
		Log.print("newBuyQuantity = "+order.buyQuantity, 0, "buyLimit");
		volume = price.multiply(newBuyQuantity); // 총액 = 시세 수량 * 시세
		Log.print("volume = "+volume, 0, "buyLimit");
		showPopup(order.userIdx, "orderRun", 1);		
		SpotTrade trade = new SpotTrade(order.getMember(), order.symbol, order.orderType, order.position, newBuyQuantity.doubleValue());
		//BTC구입
		
		if(order.position.compareTo("long")==0){
			//USDT잔액을 체크
			double myUSDT = member.getWithdrawWalletC("USDT") + volume.doubleValue();		
			//구매가능			
			if(myUSDT >= volume.doubleValue()){				
				//myUsdt차감 (메모리, 디비 갱신, 로그삽입) 
				Wallet.updateWalletAmountSubtract(member, volume.doubleValue(), "USDT", "spotbuy");
				//BTC증가  (메모리, 디비 갱신, 로그삽입)
				Wallet.updateWalletAmountAdd(member, newBuyQuantity.doubleValue(), coin.coinName , "spotbuy");
				//거래로그 기록				
				trade.insertTradeLog(0.0, price.doubleValue());		
				sendTradeBuy(member,trade.symbol,sise);
				showPopup(trade.userIdx, "buyPos", 1);
			}else{
				showPopup(member.userIdx, "notBalance", 2);
				Log.print("limit 주문 진입 실패", 0, "buyLimit");
				showPopup(trade.userIdx, "nonBalanceCancel", 2);
				orderFail(order, "balanceCancle");
			}			
		}
		//BTC 판매
		else if(order.position.compareTo("short")==0){
			//BTC잔액을 체크
			double myBTC = member.getWithdrawWalletC(order.symbol) + newBuyQuantity.doubleValue();
			if(myBTC >= newBuyQuantity.doubleValue()){				
				//myUsdt차감 (메모리, 디비 갱신, 로그삽입) 
				Wallet.updateWalletAmountAdd(member, volume.doubleValue(), "USDT", "spotsell");
				//BTC증가  (메모리, 디비 갱신, 로그삽입)
				Wallet.updateWalletAmountSubtract(member, newBuyQuantity.doubleValue(), coin.coinName, "spotsell");
				//거래로그 기록				
				trade.insertTradeLog(0.0, price.doubleValue());				
				showPopup(trade.userIdx, "buyPos", 1);
			}else{
				showPopup(member.userIdx, "notBalance", 2);
				Log.print("limit 주문 진입 실패", 0, "buyLimit");
				showPopup(trade.userIdx, "nonBalanceCancel", 2);
				orderFail(order, "balanceCancle");
			}		
		}	
		order.updateOrderState("ordered");
		order.removeOrderList();
	}

	public void orderRun(SpotOrder order){
		JSONObject obj = new JSONObject();
		
		sendMessageToMeAllBrowser(obj);
	}
	public void orderFail(SpotOrder order, String reason){
		// 주문 구매 실패시
		order.updateOrderState(reason); // 로그 변경
		//showPopup(order.userIdx, order.symbol+" <spring:message code='pop.show.orderFailCancel'/>", 2); // 안내 문구
		showPopup(order.userIdx, "orderFailCancel", 2); // 안내 문구
		// 주문 리스트에서 삭제
		order.removeOrderList();
	}	

	public void cancelOrder(JSONObject obj) {
    	Log.print("SPOT: call cancelOrder", 5, "call" );
    	try {
    		int userIdx = Integer.parseInt(obj.get("userIdx").toString());
    		String orderNum = obj.get("orderNum").toString();
    		int idx = SpotOrder.getOrderIdxByOrderNum(orderNum);
			if (idx < 0) { return; }
			SpotOrder order = SocketHandler.spotOrderList.get(idx);						
			Coin coin = Coin.getCoinInfo(order.symbol);			
			showPopup(userIdx, "orderCancel", 3);
			order.updateOrderState("cancel");
			order.sendRemoveOrder();
    		SpotTradeTrigger.removeTradeTriggerByOrderNum(orderNum); // 트리거 목록에서 제거
    		SocketHandler.spotOrderList.remove(idx);
		} catch (Exception e) {
			Log.print("cancelOrder err! "+e+" / "+obj, 0, "err" );
		}
	}
//---------------------공통함수---------------------
	public void showPopup(int userIdx, String msg, int level) {
    	Log.print("SPOT: call showPopup : "+msg, 5, "call");
    	try {
    		JSONObject obj = new JSONObject();
    		obj.put("protocol", "showPopup");
    		obj.put("userIdx", userIdx);
    		obj.put("msg", msg);
    		obj.put("level", level);
    		sendMessageToMeAllBrowser(obj);
		} catch (Exception e) {
			Log.print("SPOT: showPopup err! "+e, 0, "err");
		}
	}
	
	public void sendTradeBuy(Member member, String symbol, double entryPrice) {
		JSONObject obj = new JSONObject();
		obj.put("protocol", "sendTradeBuy");
		obj.put("userIdx", member.userIdx);
		obj.put("symbol", symbol);
		obj.put("entryPrice", entryPrice);
		sendMessageToMeAllBrowser(obj);
	}
	
	public void sendMessageToMeAllBrowser(JSONObject obj) {
    	Log.print("SPOT: sendMessageToMeAllBrowser" , 5, "call");
    	String idx = ""+obj.get("userIdx");
    	String game = "spot";
        for (WebSocketSession session : SocketHandler.sh.sessionSet) {
            if (session.isOpen()) {
        		Map<String, Object> m = session.getAttributes();   
        		String sessionGame = ""+m.get("game"); 
        		if(sessionGame.compareTo(game)!=0)	continue;
        		if( m.get("userIdx") != null && (""+m.get("userIdx")).compareTo(idx) ==0 ){
        			synchronized(SocketHandler.sendList){
        				SocketHandler.sendList.add(new SendMsg(session,obj));
        			}
        		}
            }
        }           
    }   
// --------------------초기화함수------------------	
	public void initOrder(){
		try {
			SocketHandler.sh.spotOrderList = new ArrayList<>();
			EgovMap in = new EgovMap();
			in.put("state", "wait");
			List<EgovMap> selectList = (List<EgovMap>) SocketHandler.sh.getSampleDAO().list("selectSpotOrderAll", in);
			for (int i = 0; i < selectList.size(); i++) {    						
				SpotOrder order = new SpotOrder(selectList.get(i).get("userIdx").toString(),
		        						selectList.get(i).get("orderNum").toString(),
		        						selectList.get(i).get("symbol").toString(),
		        						selectList.get(i).get("orderType").toString(),
		        						selectList.get(i).get("position").toString(),
		        						selectList.get(i).get("entryPrice").toString(),
		        						selectList.get(i).get("buyQuantity").toString(),	        						
		        						selectList.get(i).get("conclusionQuantity").toString(), 	        					
					    				selectList.get(i).get("entryPriceForStop").toString(),				    				
					    				selectList.get(i).get("orderDatetime").toString(),
					    				Double.parseDouble(""+selectList.get(i).get("triggerPrice")),
					    				Double.parseDouble(""+selectList.get(i).get("paidVolume")));
				// positionList에 추가, 클라이언트에게 알림
				order.addOrderList();
			}
		} catch (Exception e) {
			Log.print("SPOT: initOrder err! "+e, 0, "err");
		}
	}
	
	public void initTriggerList(){
    	try {
    		Log.print("SPOT: call initTriggerList", 5, "call");
    		SocketHandler.sh.spotTriggerList = new ArrayList<>();
        	List<EgovMap> selectList = (List<EgovMap>) SocketHandler.sh.getSampleDAO().list("selectAllSpotTradeTrigger");
        	if(selectList != null){
        		for (int i = 0; i < selectList.size(); i++) {
					SpotTradeTrigger newTrigger = new SpotTradeTrigger(selectList.get(i).get("idx").toString(),
																selectList.get(i).get("userIdx").toString(),
																selectList.get(i).get("orderNum").toString(),
																selectList.get(i).get("symbol").toString(),
																selectList.get(i).get("triggerType").toString(),
																selectList.get(i).get("position").toString(),
																selectList.get(i).get("triggerPrice").toString());
					SocketHandler.spotTriggerList.add(newTrigger);
				}
        	}
     
		} catch (Exception e) {
			Log.print("initTriggerList err! "+e, 0, "err");
		}
    }
}


