package egovframework.example.sample.web.spot;

import java.util.Iterator;

import egovframework.example.sample.classes.QueryWait;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.classes.TradeTrigger;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SpotTradeTrigger {
	public String idx;
	public int userIdx; // 유저 idx
	public String orderNum; // 주문 고유 번호
	public String symbol; // 코인 종류
	public String triggerType; // inPosition : 포지션 안에 있음 = 강제 청산 가격 체크 / limit : 지정가 트리거 가격 체크 / stopLimit : 스탑 지정가 가격 체크 / stopMarket : 스탑 시장가 가격 체크 + / market: 시장가진입
	public String position; // long, short
	public double triggerPrice; //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격  + market: 현시세로 무조건 진입
	
	public SpotTradeTrigger(String _userIdx, String _orderNum, String _symbol, String _triggerType, String _position, String _triggerPrice){		
		userIdx = 0; 
		triggerPrice = 0;
		try{
			userIdx = Integer.parseInt(_userIdx); // 유저 idx
			triggerPrice = Double.parseDouble(_triggerPrice); //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격
		}catch(Exception e){System.out.println("SpotTradeTrigger trprice:String err");}
		orderNum = _orderNum; // 주문 고유 번호
		symbol = _symbol; // 코인 종류
		triggerType = _triggerType; // limit, market, stopLimit, stopMarket
		position = _position; // long, short		
	}	
	
	//디비 초기화
	public SpotTradeTrigger(String _idx, String _userIdx, String _orderNum, String _symbol, String _triggerType, String _position, String _triggerPrice){		
		idx = _idx;
		userIdx = 0; 
		triggerPrice = 0;
		try{
			userIdx = Integer.parseInt(_userIdx); // 유저 idx
			triggerPrice = Double.parseDouble(_triggerPrice); //  limit: 주문 가격 , market: 강제 청산 가격, stop: 트리거 가격
		}catch(Exception e){System.out.println("SPOT: TradeTrigger trprice:String err");}
		orderNum = _orderNum; // 주문 고유 번호
		symbol = _symbol; // 코인 종류
		triggerType = _triggerType; // limit, market, stopLimit, stopMarket
		position = _position; // long, short		
	}	
	
	public void removeTradeTriggerInDB(){ // 주문 번호로 DB 삭제
    	try {
    		Log.print("SPOT: call removeTradeTriggerInDB", 5, "call");
    		// DB에서 삭제
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("orderNum", orderNum);
    		QueryWait.pushQuery("deleteSpotTradeTriggerByOrderNum",userIdx, in, QueryType.DELETE);
//    		sampleDAO.delete("deleteTradeTriggerByOrderNum",in);
    		Log.print("SPOT: remove TradeTrigger in DB orderNum : "+orderNum, 6, "log");
    	} catch (Exception e) {
    		Log.print("SPOT: removeTradeTriggerInDB err! "+e, 0, "err");
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
    		QueryWait.pushQuery("insertSpotTradeTrigger",userIdx, in, QueryType.INSERT);
			SocketHandler.spotTriggerList.add(this);
    	} catch (Exception e) {
    		Log.print("add SpotTradeTrigger err!" + e, 0, "err");
    	}
    	
    }
	
	public static void removeTradeTriggerByOrderNum(String orderNum){ // 주문 번호로 삭제
    	try {
    		// DB에서 삭제
    		SpotTradeTrigger tradeTrigger = getTradeTrigger(orderNum);
    		tradeTrigger.removeTradeTriggerInDB();
    		// List에서 삭제
    		SocketHandler.spotTmpTriggerList.add(tradeTrigger);
    		//SocketHandler.spotTriggerList.remove(tradeTrigger);    		
		} catch (Exception e) {
			Log.print("SPOT: removeTradeTriggerByOrderNum err! "+e, 0, "err");
		}
    }
	
	public static SpotTradeTrigger getTradeTrigger(String orderNum) {
    	try {
    		SpotTradeTrigger tradeTrigger = null;
    		for (Iterator<SpotTradeTrigger> iter = SocketHandler.spotTriggerList.iterator(); iter.hasNext(); ) {
    			SpotTradeTrigger trigger = iter.next();
				if (trigger.orderNum.compareTo(orderNum)  == 0) {
					tradeTrigger = trigger;
					return tradeTrigger;
				}
			}
    		Log.print("SPOT: getTradeTrigger err! tradeTrigger is null orderNum : "+orderNum, 0, "err");
    		return null;
		} catch (Exception e) {
			Log.print("SPOT: getTradeTrigger err! "+e, 0, "err");
			return null;
		}
	}
	
}
