package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.util.ArrayList;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.socket.WebSocketSession;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.Send;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Trade {
	int userIdx; // 유저 idx
	String orderNum; // 주문 고유 번호
	String symbol; // 코인 종류
	String orderType; // limit, market, stopLimit, stopMarket
	String position; // long, short
	double buyQuantity; //  주문 수량
	int leverage; // 배당
	String marginType = "";
	// 유저 지갑 포인터
	
	public Trade(Member mem, String _symbol, String _orderType, String _position, double _buyQuantity, String _leverage, String _marginType){
		userIdx = 0; 
		leverage = 1; // 배당
		try{
			userIdx = mem.userIdx; // 유저 idx
			orderNum = mem.getOrderNum(); //주문 고유 번호
			leverage = Integer.parseInt(_leverage); // 배당
			buyQuantity = _buyQuantity;
		}catch(Exception e){System.out.println("Trade err 1 ");}
		symbol = _symbol; // 코인 종류
		orderType = _orderType;
		position = _position;
		marginType = _marginType; // marginType(교차) , iso(격리)
	}
	public Trade(String _orderNum,int _userIdx, String _symbol, String _orderType, String _position, double _buyQuantity, int _leverage, String _marginType){
		try{
			userIdx = _userIdx;
			orderNum = _orderNum;
			leverage = _leverage;
			buyQuantity = _buyQuantity;
			symbol = _symbol;
			orderType = _orderType;
			position = _position;
			marginType = _marginType; // marginType(교차) , iso(격리)
		}catch(Exception e){System.out.println("Trade err 2 ");}
	}
	public Trade(Member mem, String _symbol, String _orderType, String _position, double _buyQuantity, int _leverage, String _marginType){
		try{
			userIdx = mem.userIdx;
			orderNum = mem.getOrderNum(); //주문 고유 번호
			leverage = _leverage;
			buyQuantity = _buyQuantity;
			symbol = _symbol;
			orderType = _orderType;
			position = _position;
			marginType = _marginType; // marginType(교차) , iso(격리)
		}catch(Exception e){System.out.println("Trade err 3");}
	}
	
	public void insertTradeLog(double fee, double entryPrice, double pnl, double margin, BigDecimal admimProfit, boolean isOpen, double liqPrice, String marginType){ // tradelog DB insert
    	try {
    		Log.print("call insertTradeLog", 5, "call");
    		EgovMap in = new EgovMap();
        	in.put("userIdx", userIdx);
        	in.put("orderNum", orderNum);
    		in.put("symbol", symbol);
    		in.put("orderType", orderType);
    		in.put("position", position);
    		in.put("entryPrice", entryPrice);
    		in.put("buyQuantity", buyQuantity);
    		in.put("leverage", leverage);
    		in.put("result", pnl);
    		in.put("fee", fee);
			in.put("margin", margin);
			in.put("buyDatetime", Send.getTime());
			in.put("adminProfit", admimProfit);
			in.put("isOpen", isOpen);
			in.put("liqPrice", liqPrice);
			in.put("marginType", marginType);
    		QueryWait.pushQuery("insertTradeLog",userIdx, in, QueryType.INSERT);
//    		sampleDAO.insert("insertTradeLog", in);
		} catch (Exception e) {
			Log.print("insertTradeLog err! "+e, 0, "err");
		}
    }
	
	public static boolean maxContractVolumeCheck(int userIdx, int leverage, String symbol, double contractVolume, String kind, String position){
		int maxContractVolume = 0;
		
		Position oldPosition = Position.getPosition(userIdx, symbol);
		double oldVolume = 0;
		if(kind.compareTo("leverage")!=0)
		{				
			if(oldPosition != null){
				if(oldPosition.position.compareTo(position)==0){
					oldVolume = oldPosition.contractVolume;
				}
			}
		}	
		
		maxContractVolume = Coin.getMaxContractVolume(symbol, leverage);
		if(maxContractVolume == -1){
			SocketHandler.sh.showPopup(userIdx, "maxDividend", 2);
			return false;
		}

		if (oldVolume + contractVolume > maxContractVolume) {
			SocketHandler.sh.showPopup(userIdx, "maxSize", 2);
			return false;
		}else{
			return true;
		}
	}
	
	public static BigDecimal getInitMargin(double buyQuantity, double entryPrice, int leverage,String symbol){
    	BigDecimal rate = BigDecimal.valueOf(leverage);
    	BigDecimal bigBuyQuantity = BigDecimal.valueOf(buyQuantity);
    	BigDecimal bigEntryPrice = BigDecimal.valueOf(entryPrice);
    	BigDecimal initMargin = bigBuyQuantity.multiply(bigEntryPrice).divide(rate, 4, BigDecimal.ROUND_HALF_DOWN);
    	return initMargin;
    }
}
