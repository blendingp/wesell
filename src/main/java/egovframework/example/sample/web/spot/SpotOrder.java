package egovframework.example.sample.web.spot;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;

import org.json.simple.JSONObject;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Member;
import egovframework.example.sample.classes.Order;
import egovframework.example.sample.classes.Position;
import egovframework.example.sample.classes.QueryWait;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.TradeTrigger;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SpotOrder {
	public final static int Max = 30;
	public int userIdx = 0; // 유저 idx
	public 	String orderNum = ""; // 주문 번호
	public String symbol = ""; // 코인 종류
	public String orderType = ""; // limit, market, stopLimit, stopMarket
	public String position = ""; // buy or sell
	public double entryPrice = 0; //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격
	public double entryPriceForStop = 0; // stopmarket과 stoplimit에 대한 주문당시 시세
	public double triggerPrice = 0;
	public double buyQuantity = 0; //  주문 수량
	public double conclusionQuantity = 0; // 체결 수량
	public String state = ""; // 주문 상태 wait (대기 중) / ordered (주문됨) / canceled (취소됨)
	public double paidVolume = 0;
	public String orderTime;
	private Member member = null;
	
	public SpotOrder(String _userIdx, String _symbol, String _orderType, String _position, double _entryPrice,  double _buyQuantity, String today, double triggerPrice){
		Coin coin = Coin.getCoinInfo(_symbol);
		double sise = coin.getSise(_position);
		this.triggerPrice = triggerPrice;
		orderTime = today;
		entryPriceForStop = sise;
		try{
			userIdx = Integer.parseInt(_userIdx);
			position = _position;
			this.entryPrice = _entryPrice;
			buyQuantity = _buyQuantity;
			paidVolume = BigDecimal.valueOf(entryPrice).multiply(BigDecimal.valueOf(buyQuantity)).doubleValue();
		}catch(Exception e){System.out.println("Order err 1 " + e);}
		symbol = _symbol; // 코인 종류
		orderType = _orderType;
		state = "wait"; // 처음엔 대기 상태		
		member = getMember();
		orderNum = member.getOrderNum(); 
	}
	
// 디비 갱신
public SpotOrder(String _userIdx, String _orderNum, String _symbol, String _orderType, String _position, String _entryPrice,  String _buyQuantity, String _conclusionQuantity, String _entryPriceForStop, String _orderTime, double _triggerPrice, double _paidVolume){
		userIdx = 0; 
		entryPrice = 0;
		orderNum = ""; 
		this.triggerPrice = _triggerPrice;
		this.orderTime = _orderTime;
		
		try{
			this.entryPriceForStop = Double.parseDouble(_entryPriceForStop);
			userIdx = Integer.parseInt(_userIdx);
			//member = getMemberByIdx(userIdx);
			conclusionQuantity = Double.parseDouble(_conclusionQuantity);
			entryPrice = Double.parseDouble(_entryPrice);
			buyQuantity = Double.parseDouble(_buyQuantity);		
			paidVolume = _paidVolume;
		}catch(Exception e){System.out.println("Order err 2 " + e);}
		orderNum = _orderNum; 
		symbol = _symbol; // 코인 종류
		orderType = _orderType;
		position = _position;		
		state = "wait"; // 처음엔 대기 상태						
		member = getMember();
	}

	 public static ArrayList<SpotOrder> getOrderList(int userIdx){
		ArrayList<SpotOrder> myOrders = new ArrayList<>();
		for (SpotOrder order : SocketHandler.spotOrderList) {
			if (userIdx == order.userIdx)
				myOrders.add(order);
		}
		return myOrders;
	}
	
	public Member getMember() {
		if (member == null)
			member = Member.getMemberByIdx(userIdx);
		return member;
	}
	
	public void addOrderList() { // positionList 추가
		try {
			SocketHandler.spotOrderList.add(this);
			sendOrder();
		} catch (Exception e) {
			Log.print("addPositionList err! " + e, 0, "err");
		}
	}
	
	public void sendOrder() {
    	Log.print("call sendOrder", 5, "call");
    	try {
    		JSONObject obj = new JSONObject();
    		obj.put("protocol", "order set");
    		obj.put("userIdx", userIdx);
    		obj.put("orderNum", orderNum);
    		obj.put("symbol", symbol);
    		obj.put("orderType", orderType);
    		obj.put("position", position);
    		obj.put("entryPrice", entryPrice);
    		obj.put("buyQuantity", buyQuantity);
    		obj.put("conclusionQuantity", conclusionQuantity);
    		obj.put("orderTime", orderTime);
    		obj.put("triggerPrice", triggerPrice);
    		obj.put("paidVolume", paidVolume);
    		obj.put("entryPriceForStop", entryPriceForStop);
    		SocketHandler.sh.spotManager.sendMessageToMeAllBrowser(obj);
    		//차트 지시선 그리는 정보를 미들웨어로 전달, 미들웨어는 미들웨어에 연결되어있는 트뷰차트 클라이언트에 정보전달
    		if(SocketHandler.sise != null)
    			SocketHandler.sise.sendSiseServer(obj);
    	} catch (Exception e) {
    		Log.print("sendOrder err! "+e, 0, "err");
    	}
    }
	
	public static int getOrderIdxByOrderNum(String orderNum){
		try {
			for (Iterator<SpotOrder> iter = SocketHandler.spotOrderList.iterator(); iter.hasNext(); ) {
				SpotOrder order = iter.next();
				if (order.orderNum.compareTo(orderNum) == 0) {
					return SocketHandler.spotOrderList.indexOf(order);
				}
			}					
			Log.print("SPOT: getOrderIdxByOrderNum end orderNum:"+orderNum, 2, "buyLimit");
			//Log.print("getOrderIdxByOrderNum err! orderNum : "+orderNum, 0, "err");
			return -1;
		} catch (Exception e) {
			Log.print("SPOT: orderNum:"+orderNum+" getOrderIdxByOrderNum err! "+e, 0, "err");
			return -1;
		}
	}
	
	public void updateOrderState(String state){
    	try {
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("orderNum", orderNum);
    		in.put("state", state);
    		QueryWait.pushQuery("updateSpotOrderState",userIdx, in, QueryType.UPDATE, false);
//    		sampleDAO.update("updateOrderState", in);
		} catch (Exception e) {
			Log.print("SPOT: updateOrderState err! "+e, 0, "err" );
		}
    }
	
	public void removeOrderList() {
		try {
			sendRemoveOrder();
			SocketHandler.spotOrderList.remove(this);			
			SpotTradeTrigger.removeTradeTriggerByOrderNum(orderNum);
		} catch (Exception e) {
			Log.print("SPOT: removeOrderList err! "+e, 0, "err");
		}
	}
	
	public void sendRemoveOrder(){
		try {
			JSONObject obj = new JSONObject();
    		obj.put("protocol", "order remove");
    		obj.put("orderNum", orderNum);
    		obj.put("userIdx", userIdx);
    		obj.put("symbol", symbol);
    		SocketHandler.sh.spotManager.sendMessageToMeAllBrowser(obj);
    		//SocketHandler.sise.sendSiseServer(obj);
		} catch (Exception e) {
			Log.print("SPOT: sendRemoveOrder err! "+e, 0, "err");
		}
	}
}
