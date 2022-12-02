package egovframework.example.sample.classes;

import java.util.Iterator;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class TradeTrigger {
	public String idx;
	public int userIdx; // 유저 idx
	public String orderNum; // 주문 고유 번호
	public String symbol; // 코인 종류
	public String triggerType; // inPosition : 포지션 안에 있음 = 강제 청산 가격 체크 / limit : 지정가 트리거 가격 체크 / stopLimit : 스탑 지정가 가격 체크 / stopMarket : 스탑 시장가 가격 체크
	public String position; // long, short
	public double triggerPrice; //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격
	// 유저 지갑 포인터
	
	public TradeTrigger(String _userIdx, String _orderNum, String _symbol, String _triggerType, String _position, String _triggerPrice){		
		userIdx = 0; 
		triggerPrice = 0;
		try{
			userIdx = Integer.parseInt(_userIdx); // 유저 idx
			triggerPrice = Double.parseDouble(_triggerPrice); //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격
		}catch(Exception e){System.out.println("TradeTrigger trprice:String err");}
		orderNum = _orderNum; // 주문 고유 번호
		symbol = _symbol; // 코인 종류
		triggerType = _triggerType; // limit, market, stopLimit, stopMarket
		position = _position; // long, short
		
	}

	//디비 초기화
	public TradeTrigger(String _idx, String _userIdx, String _orderNum, String _symbol, String _triggerType, String _position, String _triggerPrice){		
		idx = _idx;
		userIdx = 0; 
		triggerPrice = 0;
		try{
			userIdx = Integer.parseInt(_userIdx); // 유저 idx
			triggerPrice = Double.parseDouble(_triggerPrice); //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격
		}catch(Exception e){System.out.println("TradeTrigger trprice:String err");}
		orderNum = _orderNum; // 주문 고유 번호
		symbol = _symbol; // 코인 종류
		triggerType = _triggerType; // limit, market, stopLimit, stopMarket
		position = _position; // long, short
		
	}	

	public void updatePositionTradeTriggerInDB(Position position){ // 주문 번호로 DB 삭제
    	try {
    		Log.print("call updatePositionTradeTriggerInDB", 5, "call");
    		// DB에서 삭제
    		EgovMap in = new EgovMap();        		
    		in.put("orderNum", orderNum);
    		in.put("position", position.position);
//    		in.put("idx", tradeTrigger.idx);
    		in.put("triggerPrice", position.liquidationPrice);
    		QueryWait.pushQuery("updateTradeTriggerForPosition",position.userIdx, in, QueryType.UPDATE,false);
//    		sampleDAO.update("updateTradeTriggerForPosition",in);
    	} catch (Exception e) {
    		Log.print("updatePositionTradeTriggerInDB err! "+e, 0, "err");
    	}
    }
	
	public void removeTradeTriggerInDB(){ // 주문 번호로 DB 삭제
    	try {
    		Log.print("call removeTradeTriggerInDB", 5, "call");
    		// DB에서 삭제
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("orderNum", orderNum);
    		QueryWait.pushQuery("deleteTradeTriggerByOrderNum",userIdx, in, QueryType.DELETE);
//    		sampleDAO.delete("deleteTradeTriggerByOrderNum",in);
    		Log.print("remove TradeTrigger in DB orderNum : "+orderNum, 6, "log");
    	} catch (Exception e) {
    		Log.print("removeTradeTriggerInDB err! "+e, 0, "err");
    	}
    }
	
	public void addTradeTrigger(){ // 트리거 리스트에 넣기
    	try {
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("orderNum", orderNum);
    		in.put("symbol", symbol);
    		in.put("triggerType", triggerType);
    		in.put("position", position);
    		in.put("triggerPrice", triggerPrice);
//    		int triggeridx = (int)sampleDAO.insert("insertTradeTrigger", in);
    		QueryWait.pushQuery("insertTradeTrigger",userIdx, in, QueryType.INSERT);
			SocketHandler.triggerList.add(this);
    	} catch (Exception e) {
    		Log.print("add TradeTrigger err!" + e, 0, "err");
    	}
    	
    }
	
	public static TradeTrigger getTradeTrigger(Position position) {
    	try {
    		TradeTrigger tradeTrigger = null;
    		for (Iterator<TradeTrigger> iter = SocketHandler.triggerList.iterator(); iter.hasNext(); ) {
				TradeTrigger trigger = iter.next();
				if (trigger.userIdx == position.userIdx && trigger.symbol.compareTo(position.symbol)  == 0 && trigger.triggerType.compareTo("inPosition")  == 0) {
					tradeTrigger = trigger;
					return tradeTrigger;
				}
			}
    		Log.print("getTradeTrigger err! tradeTrigger is null userIdx : "+position.userIdx+" / symbol : "+position.symbol , 0, "err");
    		return null;
		} catch (Exception e) {
			Log.print("getTradeTrigger err! "+e, 0, "err");
			return null;
		}
	}
	
	public static TradeTrigger getTradeTrigger(String orderNum) {
    	try {
    		TradeTrigger tradeTrigger = null;
    		for (Iterator<TradeTrigger> iter = SocketHandler.triggerList.iterator(); iter.hasNext(); ) {
				TradeTrigger trigger = iter.next();
				if (trigger.orderNum.compareTo(orderNum)  == 0) {
					tradeTrigger = trigger;
					return tradeTrigger;
				}
			}
    		Log.print("getTradeTrigger err! tradeTrigger is null orderNum : "+orderNum, 0, "err");
    		return null;
		} catch (Exception e) {
			Log.print("getTradeTrigger err! "+e, 0, "err");
			return null;
		}
	}
	
	public static TradeTrigger getTradeTrigger(Order order) {
    	try {
    		TradeTrigger tradeTrigger = null;
    		
    		for (Iterator<TradeTrigger> iter = SocketHandler.triggerList.iterator(); iter.hasNext(); ) {
				TradeTrigger trigger = iter.next();
				if (trigger.userIdx == order.userIdx && trigger.symbol.compareTo(order.symbol)  == 0 && trigger.triggerType.compareTo("inPosition")  != 0) {
					tradeTrigger = trigger;
					return tradeTrigger;
				}
			}
    		Log.print("getTradeTrigger err! tradeTrigger is null userIdx : "+order.userIdx+" / symbol : "+order.symbol , 0, "err");
    		return null;
		} catch (Exception e) {
			Log.print("getTradeTrigger err! "+e, 0, "err");
			return null;
		}
	}
	
	public static void removeTradeTriggerByOrderNum(String orderNum){ // 주문 번호로 삭제
    	try {
    		Log.print("call removeTradeTriggerByOrderNum", 5, "call");
    		// DB에서 삭제
    		TradeTrigger tradeTrigger = getTradeTrigger(orderNum);
    		tradeTrigger.removeTradeTriggerInDB();
    		// List에서 삭제
    		SocketHandler.triggerList.remove(tradeTrigger);
    		Log.print("remove TradeTrigger orderNum : "+orderNum, 6, "log");
		} catch (Exception e) {
			Log.print("removeTradeTriggerByOrderNum err! "+e, 0, "err");
		}
    }
}
