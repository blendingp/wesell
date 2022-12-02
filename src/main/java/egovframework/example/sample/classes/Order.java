package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.simple.JSONObject;
import egovframework.example.sample.comparator.OrderListComparator;
import egovframework.example.sample.comparator.OrderListDownComparator;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Order {
	public final static int Max = 30;
	public int userIdx = 0; // 유저 idx
	public 	String orderNum = ""; // 주문 번호
	public String symbol = ""; // 코인 종류
	public String orderType = ""; // limit, market, stopLimit, stopMarket
	public String position = ""; // long, short
	public double entryPrice = 0; //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격
	public double entryPriceForStop = 0; // stopmarket과 stoplimit에 대한 주문당시 시세
	public double triggerPrice = 0;
	public double buyQuantity = 0; //  주문 수량
	public String strategy = ""; // 지정가 전략 GTC / GTX / FOK / IOC
	public double conclusionQuantity = 0; // 체결 수량
	public String state = ""; // 주문 상태 wait (대기 중) / ordered (주문됨) / canceled (취소됨)
	public int leverage = 0;
	public String marginType = "";
	public double openFee = 0;
	public double paidVolume = 0; // 지불한 증거금의 총 합 ( fee + 유지증거금)
//	public double mainMargin = 0; // 유지증거금의 총합
	public int postOnly = 0; // postOnly 0(체크 안됨) 1(체크 됨)
	public String orderTime;
	public String auto;
	private boolean isLiq = false;
	private Member member = null;
	
	public Member getMember(){
		if(member == null)
			member = Member.getMemberByIdx(userIdx);
		return member;
	}
	public Member getMember(boolean nullReturn){
		if(member == null)
			member = Member.getMemberByIdx(userIdx,nullReturn);
		return member;
	}
	
	public void setIsLiq(boolean liq){
		isLiq = liq;
	}
	public int getIsLiq(){
		if(isLiq) return 1;
		return 0;
	}
	//지정가 예약주문시
	public Order(String _userIdx, String _symbol, String _orderType, String _position, double _entryPrice,  double _buyQuantity, String _strategy, String _leverage, String _marginType, String _postOnly, String auto, String today, double triggerPrice){		
		Coin coin = Coin.getCoinInfo(_symbol);
		double sise = coin.getSise(_position);
		this.auto = auto;
		this.triggerPrice = triggerPrice;
		orderTime = today;
		entryPriceForStop = sise;
		try{
			userIdx = Integer.parseInt(_userIdx);
			//member = getMemberByIdx(userIdx);
			position = _position;
			setTriggerEntryPrice(sise, _entryPrice, _orderType);
			buyQuantity = _buyQuantity;
			leverage = Integer.parseInt(_leverage);
			if (_postOnly.compareTo("1") == 0 || _postOnly.compareTo("0") == 0) {
				postOnly = Integer.parseInt(_postOnly);
			}else{
				if (_postOnly.compareTo("false") == 0 ) {
					postOnly = 0;
				}else if (_postOnly.compareTo("true") == 0 ) {
					postOnly = 1;
				}
			}
		}catch(Exception e){System.out.println("Order err 1 " + e);}
		symbol = _symbol; // 코인 종류
		orderType = _orderType;
		strategy = _strategy;
		conclusionQuantity = 0;
		state = "wait"; // 처음엔 대기 상태
		marginType = _marginType; // marginType(교차) , iso(격리)
		paidVolume = getPaidVolume();
		openFee = getOpenFee();
		member = getMember();
		orderNum = member.getOrderNum(); 
	}
	// 디비 갱신
	public Order(String _userIdx, String _orderNum, String _symbol, String _orderType, String _position, String _entryPrice,  String _buyQuantity, String _strategy, String _conclusionQuantity, String _leverage, String _marginType, String _paidVolume, String _postOnly, String entryPriceForStop, String auto, String orderTime, double triggerPrice, boolean _isLiq){
		userIdx = 0; 
		entryPrice = 0;
		orderNum = ""; 
		leverage=0;
		this.auto = auto;
		this.triggerPrice = triggerPrice;
		this.orderTime = orderTime;
		
		try{
			this.entryPriceForStop = Double.parseDouble(entryPriceForStop);
			userIdx = Integer.parseInt(_userIdx);
			//member = getMemberByIdx(userIdx);
			conclusionQuantity = Double.parseDouble(_conclusionQuantity);
			entryPrice = Double.parseDouble(_entryPrice);
			buyQuantity = Double.parseDouble(_buyQuantity);
			leverage = Integer.parseInt(_leverage);			
			paidVolume = Double.parseDouble(_paidVolume);
			
			if (_postOnly.compareTo("1") == 0 || _postOnly.compareTo("0") == 0) {
				postOnly = Integer.parseInt(_postOnly);
			}else{
				if (_postOnly.compareTo("false") == 0 ) {
					postOnly = 0;
				}else if (_postOnly.compareTo("true") == 0 ) {
					postOnly = 1;
				}
			}
			Log.print("Order postOnly af = "+postOnly, 0, "test");
		}catch(Exception e){System.out.println("Order err 2 " + e);}
		orderNum = _orderNum; 
		symbol = _symbol; // 코인 종류
		orderType = _orderType;
		position = _position;
		strategy = _strategy;
		state = "wait"; // 처음엔 대기 상태
		marginType = _marginType; // marginType(교차) , iso(격리)
		setIsLiq(_isLiq);
		openFee = getOpenFee();
		member = getMember();
	}
	
	//트리거 예약주문시
	public Order(int _userIdx, String _symbol, String _orderType, String _position, double _entryPrice,  double _buyQuantity, String _strategy, double _conclusionQuantity, int _leverage, String _marginType, double _paidVolume, int _postOnly, double _entryPriceForStop, String auto, String today, double triggerPrice){
		this.auto = auto;
		this.triggerPrice = triggerPrice;
		orderTime = today;
		userIdx = _userIdx; 
		symbol = _symbol; // 코인 종류
		orderType = _orderType;
		position = _position;
		entryPrice = _entryPrice;
		entryPriceForStop = _entryPriceForStop;
		buyQuantity = _buyQuantity;
		leverage = _leverage;
		conclusionQuantity = _conclusionQuantity;
		paidVolume = _paidVolume;
		postOnly = _postOnly;
		strategy = _strategy;
		state = "wait"; // 처음엔 대기 상태
		marginType = _marginType; // marginType(교차) , iso(격리)
		openFee = getOpenFee();
		member = getMember();
		try{
			orderNum = member.getOrderNum(); 
		}catch(Exception e){System.out.println("Order err 3 " + e);}
	}
	public void print() {
		Log.print(orderNum+"] "+userIdx+" | "+symbol+" | "+orderType+" | "+position+" | "+entryPrice+" | "+buyQuantity+" | "+strategy+" | "+conclusionQuantity+" | "+userIdx+" | "+leverage+" | "+paidVolume+" | "+marginType+" | "+postOnly, 0, "evt");
	}
	
	public double getPaidVolume(){
		BigDecimal contractVolume = BigDecimal.valueOf(entryPrice).multiply(BigDecimal.valueOf(buyQuantity));		
		BigDecimal feetmp = BigDecimal.ONE.subtract(BigDecimal.ONE.divide(BigDecimal.valueOf(leverage), 8, BigDecimal.ROUND_HALF_DOWN)); 
		BigDecimal fee = contractVolume.multiply(feetmp).multiply(Project.getFeeRate(getMember(true), "market"));
		//개시증거금
		BigDecimal initMargin = Trade.getInitMargin(buyQuantity, entryPrice, leverage, symbol);
		
		//fee  개시증거금+ 파산가격수수료 + 유지증거금
		BigDecimal _paidVolume = fee.add(initMargin);
		
		if(CointransService.isInverse(symbol))
			_paidVolume = CointransService.coinTrans(_paidVolume, symbol);
		
		_paidVolume = _paidVolume.setScale(5,RoundingMode.HALF_UP);
		return PublicUtils.toFixed(_paidVolume.doubleValue(),5);
	}
    
    public double getOpenFee(){
    	String ot = orderType;
    	if(ot.equals("stopMarket")){
    		ot = "market";
    	}
    	BigDecimal contractVolume = BigDecimal.valueOf(this.buyQuantity).multiply(BigDecimal.valueOf(this.entryPrice));
    	BigDecimal rate = Project.getFeeRate(getMember(), ot);
    	BigDecimal of = contractVolume.multiply(rate);
    	if(CointransService.isInverse(symbol))
    		of = CointransService.coinTrans(of, symbol);
    	return of.doubleValue();
    }
    
    public boolean orderMemory(){
    	for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
			Order order = iter.next();
			if(this == order)
				return true;
		}
    	return false;
    }
    
    public void updateOrderState(String state){
    	try {
    		Log.print(state+" call updateOrderState userIdx:"+userIdx, 5, "call" );
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("orderNum", orderNum);
    		in.put("state", state);
    		QueryWait.pushQuery("updateOrderState",userIdx, in, QueryType.UPDATE, false);
//    		sampleDAO.update("updateOrderState", in);
		} catch (Exception e) {
			Log.print("updateOrderState err! "+e, 0, "err" );
		}
    }
	
    public void addOrderList() { // positionList 추가
    	try {
			SocketHandler.orderList.add(this);
			sendOrder();
		} catch (Exception e) {
			Log.print("addPositionList err! "+e, 0, "err");
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
    		obj.put("leverage", leverage);
    		obj.put("strategy", strategy);
    		obj.put("paidVolume", PublicUtils.toFixed(paidVolume + openFee,5));
    		obj.put("mainMargin", 0);////유지 증거금은사라졌지만 다른 모듈과 융통성을 위해 남겨둠
    		obj.put("marginType", marginType);
    		obj.put("conclusionQuantity", conclusionQuantity);
    		obj.put("orderTime", orderTime);
    		obj.put("triggerPrice", triggerPrice);
    		obj.put("entryPriceForStop", entryPriceForStop);
    		obj.put("isLiq", getIsLiq());
    		SocketHandler.sh.sendMessageToMeAllBrowser(obj);
    		if(SocketHandler.sise != null)
    			SocketHandler.sise.sendSiseServer(obj);
    	} catch (Exception e) {
    		Log.print("sendOrder err! "+e, 0, "err");
    	}
    }
    
    public void removeOrderList() {
		try {
			Log.print("call removeOrderList", 5, "call");
			sendRemoveOrder();
			SocketHandler.orderList.remove(this);
			Position.updateLiquidationPriceByUser(userIdx, symbol);
			TradeTrigger.removeTradeTriggerByOrderNum(orderNum);
		} catch (Exception e) {
			Log.print("removeOrderList err! "+e, 0, "err");
		}
	}
    
    public void sendRemoveOrder(){
		try {
			JSONObject obj = new JSONObject();
    		obj.put("protocol", "order remove");
    		obj.put("orderNum", orderNum);
    		obj.put("userIdx", userIdx);
    		obj.put("symbol", symbol);
    		SocketHandler.sh.sendMessageToMeAllBrowser(obj);
    		SocketHandler.sise.sendSiseServer(obj);
		} catch (Exception e) {
			Log.print("sendRemoveOrder err! "+e, 0, "err");
		}
	}
    
    public void setTriggerEntryPrice(double sise, double entryPrice, String orderType){
    	this.entryPrice = entryPrice;
    	if(!orderType.equals("stopMarket")){
    		if(position.equals("long")){
    			if(entryPrice > sise)
    				this.entryPrice = sise;
    		}else{
    			if(entryPrice < sise)
    				this.entryPrice = sise;
    		}
    	}
    }
    
    public static int getOrderIdxByOrderNum(String orderNum){
		try {
			for (Iterator<Order> iter = SocketHandler.orderList.iterator(); iter.hasNext(); ) {
				Order order = iter.next();
				if (order.orderNum.compareTo(orderNum) == 0) {
					return SocketHandler.orderList.indexOf(order);
				}
			}					
			Log.print("getOrderIdxByOrderNum end orderNum:"+orderNum, 2, "buyLimit");
			//Log.print("getOrderIdxByOrderNum err! orderNum : "+orderNum, 0, "err");
			return -1;
		} catch (Exception e) {
			Log.print("orderNum:"+orderNum+" getOrderIdxByOrderNum err! "+e, 0, "err");
			return -1;
		}
	}
    
    public static double getLiqOrderQty(int userIdx, String symbol){
    	double qty = 0;
    	// close long 으로할때는 close long 만샘 
    	// limit 탭에서 바로 short으로 진입할때는 체크하면안됨 
    	for (Order order : SocketHandler.orderList) {
			if (order.userIdx == userIdx && order.getIsLiq() == 1) {
				if(order.symbol.equals(symbol)){
					qty += order.buyQuantity;
				}
			}
		}   
		return qty;
    }
    
    public static ArrayList<Order> getOrderList(int userIdx){
    	ArrayList<Order> myOrders = new ArrayList<>();
		for(Order order : SocketHandler.orderList){
			if(userIdx == order.userIdx)
				myOrders.add(order);
		}
    	return myOrders;
    }
    
    public static void sortUpEntryOrderlist(ArrayList<Order> list){
    	Collections.sort(list, new OrderListComparator());
    }
    public static void sortDownEntryOrderlist(ArrayList<Order> list){
    	Collections.sort(list, new OrderListDownComparator());
    }
}
