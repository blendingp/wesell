package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.web.socket.WebSocketSession;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.enums.TPSLType;
import egovframework.example.sample.service.impl.Log;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Position {
	public int userIdx = 0; // 유저 idx
	public String symbol = ""; // 코인 종류
	public String position = ""; // long, short
	public double entryPrice = 1; // 진입 금액
	public double buyQuantity = 1; //  주문 수량
	public double liquidationPrice = 1; //  강제 청산 금액
	public double contractVolume = 1; //  계약 가격 = 지불*레버리지  가격
	public int leverage = 1; // 배당
	public Member member = null;// 유저 포인터
	public String marginType = "";
	public String orderType="";//포지션이 limit,market 중 무엇으로부터 생성된것인지 ( 청산가 계산시 수수료율 얻을때 필요함)
	public double fee = 0; // fee : 개시증거금+ 파산가격수수료
	public Double TP = null;
	public Double SL = null;
	public double openFee = 0;
	public double liqFee = 0;
	
	public Position(String _symbol, String _position, String _entryPrice, String _buyQuantity, String _liquidationPrice, String _contractVolume, String _leverage, String _mainMargin, Member _member, String _marginType, String _orderType, String _fee, Double TP, Double SL, double _openFee){
		member = _member;
		symbol = _symbol; // 코인 종류
		position = _position; // long, short
		marginType = _marginType; // marginType(교차) , iso(격리)
		orderType = _orderType;
		try{
			userIdx = member.userIdx; // 유저 idx
			entryPrice = Double.parseDouble(_entryPrice);
			buyQuantity = Double.parseDouble(_buyQuantity);
			liquidationPrice = Double.parseDouble(_liquidationPrice);
//			mainMargin = Double.parseDouble(_mainMargin);
			leverage = Integer.parseInt(_leverage); // 배당
			contractVolume = Double.parseDouble(_contractVolume);
			fee = Double.parseDouble(_fee);
			this.TP = TP;
			this.SL = SL;
			openFee = _openFee;
		}catch(Exception e){System.out.println("Position err 1 " +e);}
	}
	public Position(String _symbol, String _position, double _entryPrice, double _buyQuantity, double _contractVolume, int _leverage, Member _member, String _marginType, String _orderType, double _openFee){
		userIdx = _member.userIdx; // 유저 idx
		buyQuantity = _buyQuantity;
		entryPrice = _entryPrice;
		symbol = _symbol; // 코인 종류
		position = _position; // long, short
		leverage = _leverage;
		contractVolume = _contractVolume;
		member = _member;
		marginType = _marginType; // marginType(교차) , iso(격리)
		orderType = _orderType;
		//개시증거금
		BigDecimal initMargin = Trade.getInitMargin(buyQuantity, entryPrice, leverage, symbol);
		//파산가격 수수료
		BigDecimal feetmp = BigDecimal.ONE.subtract(BigDecimal.ONE.divide(BigDecimal.valueOf(leverage), 8, BigDecimal.ROUND_HALF_DOWN)); 
		BigDecimal feeBig = BigDecimal.valueOf(contractVolume).multiply(feetmp).multiply(Project.getFeeRate(member, "market"));
		//fee  개시증거금+ 파산가격수수료		
		feeBig = feeBig.add(initMargin);		
		liquidationPrice = getLiquidationPrice();
		if(CointransService.isInverse(_symbol)) {//인버스시 코인단위로 변경해야
			feeBig = CointransService.coinTrans(feeBig, symbol);
		}
		fee = feeBig.doubleValue();
		openFee = _openFee;
		Log.print("볼륨:"+contractVolume+" fee(개시증거금+ 파산가격수수료):"+fee +" 개시증거금:"+initMargin , 0, "buyProcess");
	}
	
	public void setMember(Member _member){
		member = _member;
	}
	
	public String toString() {
		return "position("+userIdx+") ["+symbol+"] ["+buyQuantity+"] ["+entryPrice+"] ["+position+"] ["+liquidationPrice+"] ["+leverage+"]["+marginType+"]";
	}
	
	public void updateLiquidationPrice(){
		liquidationPrice = getLiquidationPrice();
		TradeTrigger tradeTrigger = TradeTrigger.getTradeTrigger(this);
		tradeTrigger.triggerPrice = liquidationPrice;
		EgovMap in = new EgovMap();
		in.put("userIdx", userIdx);
		in.put("symbol", symbol); // coin Symbol
		in.put("liquidationPrice", liquidationPrice); // 강제 청산 가격
		
		QueryWait.pushQuery("updatePositionLiquid",userIdx, in, QueryType.UPDATE, false);
		QueryWait.pushQuery("updateTradeTriggerPrice",userIdx, in, QueryType.UPDATE, false);
//		SocketHandler.sh.getSampleDAO().update("updatePositionLiquid", in);		
//		SocketHandler.sh.getSampleDAO().update("updateTradeTriggerPrice", in);		
		sendPosition();
	}
	
	public BigDecimal getProfit(){
		Coin coin = Coin.getCoinInfo(symbol);
		double sise = coin.getSise(position);
		
		double siseVol = buyQuantity * sise;
		BigDecimal profit;
		if(position.equals("long")){
			profit = BigDecimal.valueOf(siseVol).subtract(BigDecimal.valueOf(contractVolume));
		}else{
			profit = BigDecimal.valueOf(contractVolume).subtract(BigDecimal.valueOf(siseVol));
		}
		
		if(CointransService.isInverse(symbol))
			profit = CointransService.coinTrans(profit, symbol);
		
		return profit;
	}
	
	public double getProfitRate(){
		double profit = getProfit().doubleValue();
		return profit / fee * 100;
	}
	
	//cross 공식
	public double liquidationCross(String sise, BigDecimal _leverage, double qty,boolean isLongPositon ,String orderType, String symbol){
		BigDecimal entryPriceB = BigDecimal.valueOf(Double.parseDouble(sise));//평균진입가격
		BigDecimal qunatity = BigDecimal.valueOf(qty);//수량
		BigDecimal volume = qunatity.multiply(entryPriceB);//볼륨
		
		Coin coin = Coin.getCoinInfo(symbol);
		String longSise = coin.bidsPriceList[0];
		Log.print(">> liquidationCross  entryPriceB:"+entryPriceB+" qunatity:"+qunatity+" volume:"+volume+" longSise:"+longSise, 0, "liquidation");
		
		BigDecimal walletB = CointransService.getWithdrawWallet(userIdx, symbol);//사용 가능 
		BigDecimal inirate = BigDecimal.ONE.divide(BigDecimal.valueOf(this.leverage), 5, BigDecimal.ROUND_HALF_UP).subtract(getMainMarginRate(this.symbol, this.contractVolume));
		Log.print(">> liquidationCross에서 walletB 값 확인:"+walletB+" inirate:"+inirate, 0, "liquidation");
		double rt=0;
		
		if(CointransService.isInverse(symbol)){
			walletB = walletB.multiply(BigDecimal.valueOf(Double.parseDouble(longSise)));
		}
		
		if( isLongPositon )
			rt= entryPriceB.subtract((walletB.add(volume.multiply(inirate))).divide(BigDecimal.valueOf(this.buyQuantity), 5, BigDecimal.ROUND_HALF_UP)).doubleValue();
		else
			rt= entryPriceB.add((walletB.add(volume.multiply(inirate))).divide(BigDecimal.valueOf(this.buyQuantity), 5, BigDecimal.ROUND_HALF_UP)).doubleValue();		
		
		if( rt<0 )
			rt=0;
		Log.print(">> liquidationCross 최종 천산값 rt:"+rt, 0, "liquidation");
		return rt;
	}
	
	
	//entryPrice 진입가격
	public double getLiquidationPrice(){
    	try {
			Log.print("call getLiquidationPrice trade: marginType "+marginType, 5, "call");
			double liquidationPrice = 10;
			BigDecimal leverage = BigDecimal.valueOf(this.leverage);
			BigDecimal entryPriceB = BigDecimal.valueOf(entryPrice);//진입가격 50340.94			
			BigDecimal volume = BigDecimal.valueOf(buyQuantity).multiply(entryPriceB);//계약수량 : 0.1btc x 진입가격 =  5034.094 
			
			//유지증거금률
			BigDecimal mainMarginRate = getMainMarginRate(symbol, volume.doubleValue());//유지증거금 0.4% == 0.004
			//개시증거금률
			BigDecimal initMarginRate = BigDecimal.valueOf(100).divide(leverage, 5, BigDecimal.ROUND_HALF_UP);// (100/leverage)<-소수점둘째자리반올림처리 / 100
			initMarginRate = initMarginRate.divide(BigDecimal.valueOf(100));
			if (marginType.compareTo("iso") == 0) {				
				if (position.compareTo("long") == 0){					
					BigDecimal tmprate = BigDecimal.ONE.subtract(BigDecimal.ONE.divide(leverage , 5, BigDecimal.ROUND_HALF_UP)).add(mainMarginRate);
					liquidationPrice = entryPriceB.multiply(tmprate).doubleValue();
				} else if (position.compareTo("short") == 0){
					BigDecimal tmprate = BigDecimal.ONE.add(BigDecimal.ONE.divide(leverage , 5, BigDecimal.ROUND_HALF_UP)).subtract(mainMarginRate);
					liquidationPrice = entryPriceB.multiply(tmprate).doubleValue();
				}else{
					Log.print("getLiquidationPrice position err! position = "+position, 0, "err" );
				}
				return liquidationPrice;
			}else if (marginType.compareTo("cross") == 0) {
				if (position.compareTo("long") == 0){
					return liquidationCross(""+entryPrice, leverage , buyQuantity,true  , orderType, symbol  );
				} else if (position.compareTo("short") == 0){
					return liquidationCross(""+entryPrice, leverage , buyQuantity,false , orderType, symbol );
				}else{
					Log.print("getLiquidationPrice position err! position = "+position, 0, "err" );
				}
			}
			Log.print("getLiquidationPrice trade err! ", 0, "err");
			return 0;
		} catch (Exception e) {			
			Log.print("getLiquidationPrice trade err! "+e.getMessage(), 0, "err");
			return 0;
		}
	}
	
	public BigDecimal getMainMarginRate(String symbol, double volume){
//		return getMainMarginRateo(symbol,volume).divide(BigDecimal.valueOf(25),5,RoundingMode.HALF_UP);
		return getMainMarginRateo(symbol,volume);
	}
	public BigDecimal getMainMarginRateo(String symbol, double volume){
    	try {
    		BigDecimal rate = null;
    		Coin coin = Coin.getCoinInfo(symbol);
    		switch(coin.maxVolumeType){
    		case 1:
    			if (volume <= 1000000) { rate = BigDecimal.valueOf(0.005); }
        		else if (volume <= 2000000) { rate = BigDecimal.valueOf(0.01); }
        		else if (volume <= 3000000) { rate = BigDecimal.valueOf(0.015); }
        		else if (volume <= 4000000) { rate = BigDecimal.valueOf(0.02); }
        		else if (volume <= 5000000) { rate = BigDecimal.valueOf(0.025); }
        		else if (volume <= 6000000) { rate = BigDecimal.valueOf(0.03); }
        		else if (volume <= 7000000) { rate = BigDecimal.valueOf(0.035); }
        		else if (volume <= 8000000) { rate = BigDecimal.valueOf(0.04); }
        		else if (volume <= 9000000) { rate = BigDecimal.valueOf(0.045); }
        		else{ rate = BigDecimal.valueOf(0.05); } 
    			break;
    		case 2:
    			if (volume <= 800000) { rate = BigDecimal.valueOf(0.0083); }
//				if (volume <= 800000) { rate = new BigDecimal("0.01"); }
        		else if (volume <= 1600000) { rate = BigDecimal.valueOf(0.015); }
        		else if (volume <= 2400000) { rate = BigDecimal.valueOf(0.02); }
        		else if (volume <= 3200000) { rate = BigDecimal.valueOf(0.025); }
        		else if (volume <= 4000000) { rate = BigDecimal.valueOf(0.03); }
        		else if (volume <= 4800000) { rate = BigDecimal.valueOf(0.035); }
        		else if (volume <= 5600000) { rate = BigDecimal.valueOf(0.04); }
        		else if (volume <= 6400000) { rate = BigDecimal.valueOf(0.045); }
        		else if (volume <= 7200000) { rate = BigDecimal.valueOf(0.05); }
        		else{ rate = BigDecimal.valueOf(0.055); }
    			break;
    		case 3:
    			if (volume <= 200000) { rate = BigDecimal.valueOf(0.0083); }
        		else if (volume <= 400000) { rate = BigDecimal.valueOf(0.015); }
        		else if (volume <= 600000) { rate = BigDecimal.valueOf(0.02); }
        		else if (volume <= 800000) { rate = BigDecimal.valueOf(0.025); }
        		else if (volume <= 1000000) { rate = BigDecimal.valueOf(0.03); }
        		else if (volume <= 1200000) { rate = BigDecimal.valueOf(0.035); }
        		else if (volume <= 1400000) { rate = BigDecimal.valueOf(0.04); }
        		else if (volume <= 1600000) { rate = BigDecimal.valueOf(0.045); }
        		else if (volume <= 1800000) { rate = BigDecimal.valueOf(0.05); }
        		else if (volume <= 2000000) { rate = BigDecimal.valueOf(0.055); }
        		else if (volume <= 2200000) { rate = BigDecimal.valueOf(0.06); }
        		else if (volume <= 2400000) { rate = BigDecimal.valueOf(0.065); }
        		else if (volume <= 2600000) { rate = BigDecimal.valueOf(0.07); }
        		else if (volume <= 2800000) { rate = BigDecimal.valueOf(0.075); }
        		else{ rate = BigDecimal.valueOf(0.08); }
    			break;
    		case 4:
    			if (volume <= 200000) { rate = BigDecimal.valueOf(0.02); }
        		else if (volume <= 400000) { rate = BigDecimal.valueOf(0.025); }
        		else if (volume <= 600000) { rate = BigDecimal.valueOf(0.03); }
        		else if (volume <= 800000) { rate = BigDecimal.valueOf(0.035); }
        		else if (volume <= 1000000) { rate = BigDecimal.valueOf(0.04); }
        		else if (volume <= 1200000) { rate = BigDecimal.valueOf(0.045); }
        		else if (volume <= 1400000) { rate = BigDecimal.valueOf(0.05); }
        		else if (volume <= 1600000) { rate = BigDecimal.valueOf(0.055); }
        		else if (volume <= 1800000) { rate = BigDecimal.valueOf(0.06); }
        		else if (volume <= 2000000) { rate = BigDecimal.valueOf(0.065); }
        		else if (volume <= 2200000) { rate = BigDecimal.valueOf(0.07); }
        		else if (volume <= 2400000) { rate = BigDecimal.valueOf(0.075); }
        		else if (volume <= 2600000) { rate = BigDecimal.valueOf(0.08); }
        		else if (volume <= 2800000) { rate = BigDecimal.valueOf(0.085); }
        		else{ rate = BigDecimal.valueOf(0.09); }
    			break;
    		case 5:
    			if (volume <= 25000) { rate = BigDecimal.valueOf(0.04); }
        		else if (volume <= 50000) { rate = BigDecimal.valueOf(0.05); }
        		else if (volume <= 75000) { rate = BigDecimal.valueOf(0.06); }
        		else if (volume <= 100000) { rate = BigDecimal.valueOf(0.07); }
        		else if (volume <= 125000) { rate = BigDecimal.valueOf(0.08); }
        		else if (volume <= 150000) { rate = BigDecimal.valueOf(0.09); }
        		else if (volume <= 175000) { rate = BigDecimal.valueOf(0.1); }
        		else if (volume <= 200000) { rate = BigDecimal.valueOf(0.11); }
        		else if (volume <= 225000) { rate = BigDecimal.valueOf(0.12); }
        		else if (volume <= 250000) { rate = BigDecimal.valueOf(0.13); }
        		else if (volume <= 275000) { rate = BigDecimal.valueOf(0.14); }
        		else if (volume <= 300000) { rate = BigDecimal.valueOf(0.15); }
        		else if (volume <= 325000) { rate = BigDecimal.valueOf(0.16); }
        		else if (volume <= 350000) { rate = BigDecimal.valueOf(0.17); }
        		else{ rate = BigDecimal.valueOf(0.18); }
    			break;
			default:
				Log.print("getMainMarginRate symbol err! "+symbol, 0, "err");
        		rate = BigDecimal.valueOf(-1);
    		}
    		Log.print("getMainMarginRate("+symbol+", "+volume+") = "+rate, 0, "evt");
    		return rate;
		} catch (Exception e) {
			Log.print("getMainMarginRate err! "+e, 0, "err");
			return BigDecimal.valueOf(-1);
		}
    }
    
	public void addPositionList() { // positionList 추가
    	try {
    		Log.print("call addPositionList", 5, "call");
			Log.print("addPositionList find position user:"+userIdx+" 진입가격:"+entryPrice, 6, "log");
			SocketHandler.positionList.add(this); // 코인 포지션 업데이트
		} catch (Exception e) {
			Log.print("addPositionList err! "+e, 0, "err");
		}
	}
    
    public void sendPosition() {
    	Log.print("call sendPosition", 5, "call");
    	try {
    		JSONObject obj = new JSONObject();
    		obj.put("protocol", "position set");
    		obj.put("userIdx", userIdx);
    		obj.put("symbol", symbol);
    		obj.put("position", position);
    		obj.put("entryPrice", entryPrice);
    		obj.put("buyQuantity", buyQuantity);
    		obj.put("liquidationPrice", liquidationPrice);
    		obj.put("contractVolume", contractVolume);
    		obj.put("leverage", leverage);
    		obj.put("marginType", marginType);
    		obj.put("fee", fee);
    		SocketHandler.sh.sendMessageToMeAllBrowser(obj);
    		SocketHandler.sise.sendSiseServer(obj);
		} catch (Exception e) {
			Log.print("sendPosition err! "+e, 0, "err");
		}
	}
    
    public void addPosition(){ // 새로운 포지션 설정
    	try {
    		Log.print("call addPosition", 5, "call");
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("symbol", symbol); // coin Symbol
    		in.put("position", position); // long / short
    		in.put("entryPrice", entryPrice); // 진입 가격
    		in.put("buyQuantity", buyQuantity); // 구매 수량
    		in.put("liquidationPrice", liquidationPrice); // 강제 청산 가격
    		in.put("contractVolume", contractVolume); // 계약 USDT
    		in.put("leverage", leverage); // 배당
    		in.put("marginType", marginType); 
    		in.put("orderType", orderType); 
    		in.put("fee", fee); // 개시증거금(+파산가격수수료)
    		in.put("openFee", openFee); // 개시증거금(+파산가격수수료)
//    		sampleDAO.insert("insertPosition", in);
    		QueryWait.pushQuery("insertPosition",userIdx, in, QueryType.INSERT);
    		// positionList 추가
    		addPositionList();
    		// 클라이언트에게 보내주기
    		sendPosition();
		} catch (Exception e) {
			Log.print("addPosition err! "+e, 0, "err");
		}
    }
    
    public void updatePosition() {
    	try {
    		Log.print("call updatePosition", 5, "call");
    		// DB 업데이트
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("symbol", symbol); // coin Symbol
    		in.put("position", position); // long / short
    		in.put("entryPrice", entryPrice); // 진입 가격
    		in.put("buyQuantity", buyQuantity); // 구매 수량
    		in.put("liquidationPrice", liquidationPrice); // 강제 청산 가격
    		in.put("contractVolume", contractVolume); // 계약 USDT
    		in.put("leverage", leverage); // 배당
    		in.put("fee", fee); // 증거금
    		in.put("openFee", openFee); // 진입수수료
    		QueryWait.pushQuery("updatePosition",userIdx, in, QueryType.UPDATE,false);
//    		sampleDAO.update("updatePosition", in);        		
    		
    		//Position List 업데이트
			int oldPositionIdx = getPositionIdx(userIdx, symbol);
			SocketHandler.positionList.set(oldPositionIdx, this);
    		
    		//클라이언트에 보내주기
			sendPosition();
    		
    		// 트리거 리스트 추가
    		updatePositionTradeTrigger();
    	} catch (Exception e) {
    		Log.print("updatePosition err! "+e, 0, "err");
    	}
    }
    
    private void updatePositionTradeTrigger() {
		try {
			Log.print("call updateTradeTrigger", 5, "call");
			TradeTrigger tradeTrigger = TradeTrigger.getTradeTrigger(this);
			if (tradeTrigger != null) {
				tradeTrigger.updatePositionTradeTriggerInDB(this);
				tradeTrigger.position = position;
				tradeTrigger.triggerPrice = liquidationPrice;
			}
		} catch (Exception e) {
			Log.print("updateTradeTrigger err! "+e, 0, "err");
		}
	}
    
    private void setPosition(String orderNum){ // 새로운 포지션 설정
    	Log.print("call setPositon 기존포지션없음, 포지션추가", 5, "call");
    	try {
    		// 포지션 새로 추가
    		addPosition();
    		
    		//트리거에 강제 청산 금액넣어주기
    		TradeTrigger tradeTrigger = new TradeTrigger(""+userIdx, orderNum, symbol, "inPosition", position, ""+liquidationPrice);
    		tradeTrigger.addTradeTrigger();
			
		} catch (Exception e) {
			Log.print("setPosition err! "+e, 0, "err");
		}
    }
    
    public void inPosition(String orderNum){
		try {
			Log.print("call inPosition", 5, "call");
			// position 창에 보내주기
			Position oldPosition = Position.getPosition(userIdx, symbol);
			if(oldPosition != null && oldPosition.buyQuantity > 0){
				// 기존 position이 있으면	// 포지션 내용 업데이트
				updateBuyPosition(oldPosition);
			}else{
				// 기존 position이 없으면	// 새로운 포지션 생성
				setPosition(orderNum);
			}
		} catch (Exception e) {
			Log.print("inPosition err! "+e, 0, "err");
		}
	}
    
    private void updateBuyPosition(Position oldPosition) { // 기존 포지션 DB 업데이트
    	try {
    		Log.print("call updateBuyPosition 기존포지션존재,추가갱신", 5, "call");
    		// 기존 값 가져와서 새 값 계산
    		
    		// 새 계약 USDT = 기존 계약 USDT + 구매 USDT
    		BigDecimal oldVolume = BigDecimal.valueOf(oldPosition.contractVolume);
    		BigDecimal newVolume = oldVolume.add(BigDecimal.valueOf(contractVolume));
    		Log.print("기존규모("+oldVolume+") + 새규모("+contractVolume+") = "+newVolume, 0, "buyProcess");
    		// 새 수량 = 기존 수량 + 구매 수량
    		BigDecimal oldBuyQuantity = BigDecimal.valueOf(oldPosition.buyQuantity);
    		BigDecimal newBuyQuantity = oldBuyQuantity.add(BigDecimal.valueOf(buyQuantity));
    		Log.print("기존수량("+oldBuyQuantity+") + 새수량("+buyQuantity+") = "+newBuyQuantity, 0, "buyProcess");
    		// 새 진입 가격 = 새 계약 USDT / 새 수량
    		BigDecimal newEntryPrice = newVolume.divide(newBuyQuantity,5,BigDecimal.ROUND_HALF_DOWN);
    		Log.print("진입가격 = 규모("+newVolume+") / 수량("+newBuyQuantity+") = "+newEntryPrice, 0, "buyProcess");
    		        		
    		// 새 포지션
    		Position newPosition = new Position(symbol, 
												position, 
						        				newEntryPrice.doubleValue(), 
						        				newBuyQuantity.doubleValue(), 
						        				newVolume.doubleValue(), 
						        				leverage,
						        				member,
						        				marginType,
						        				orderType,
						        				oldPosition.openFee + openFee);
    		
    		newPosition.updatePosition();
    		
		} catch (Exception e) {
			Log.print("updatePosition err! "+e, 0, "err");
		}
	}
    public void useTPSL(TPSLType type, Double price){
    	ArrayList<Position> list = null;
    	switch(type){
    	case SL:
    		list = SocketHandler.slList;
    		this.SL = price;
    		break;
    	case TP:
    		list = SocketHandler.tpList;
    		this.TP = price;
    		break;
    	}
    	boolean contains = list.contains(this);
    	if(price == null){
    		if(contains){
    			list.remove(this);
    		}
    	}else{
    		if(!contains){
    			list.add(this);
    		}
    	}
    	updateTPSL();
    }
    
    public void updateTPSL(){
    	EgovMap in = new EgovMap();
    	in.put("userIdx", this.userIdx);
    	in.put("symbol", this.symbol);
    	in.put("tp", this.TP);
    	in.put("sl", this.SL);
    	QueryWait.pushQuery("updatePositionTPSL", userIdx, in, QueryType.UPDATE,false);
    }
    
    public static void checkTPSL(){
    	for (Iterator<Position> iter = SocketHandler.tpList.iterator(); iter.hasNext(); ) {
    		Position p = iter.next();
    		try {
    			Coin coin = Coin.getCoinInfo(p.symbol);
    			double sise = coin.getSise(p.position, false);
    			if(sise == -1)
    				return;
    			
    			if(p.TP == null){
    				Log.print("TP check 이미 사라진 포지션. userIdx = "+p.userIdx+" , symbol = "+p.symbol, 1, "evt");
    				iter.remove();
    			}else if(p.position.equals("long") && p.TP <= sise ||
    					p.position.equals("short") && p.TP >= sise ){
    				
    				if(SocketHandler.positionList.contains(p)){
    					Log.print("TP 실행, userIdx = "+p.userIdx+" , symbol = "+p.symbol+" Position = "+p.position+" , TP price = "+p.TP+" , sise = "+sise, 1, "call");
    					SocketHandler.sh.sellMarket(p, "", false, null);
    					SocketHandler.sh.liqOrderAllCancel(p.userIdx, p.symbol,"");
    					Copytrade.followLiq(p.userIdx,p.symbol);
    				}
    				iter.remove();
    			}
			} catch (Exception e) {
				double wallet = p.member.getWallet();
				if(CointransService.isInverse(p.symbol)){
					wallet = p.member.getWalletC(p.symbol);
				}
				Log.print("checkTPSL TP err! userIdx = "+p.userIdx+" wallet = "+wallet+" / position = "+p.toString(), 1, "err");
			}
    	}
    	
    	for (Iterator<Position> iter = SocketHandler.slList.iterator(); iter.hasNext(); ) {
    		Position p = iter.next();
    		try {
    			Coin coin = Coin.getCoinInfo(p.symbol);
    			double sise = coin.getSise(p.position);
    			if(sise == -1)
    				return;
    			
    			if(p.SL == null){
    				Log.print("SL check 이미 사라진 포지션. userIdx = "+p.userIdx+" , symbol = "+p.symbol, 1, "evt");
    				iter.remove();
    			}else if(p.position.equals("long") && p.SL >= sise ||
    					p.position.equals("short") && p.SL <= sise){
    				if(SocketHandler.positionList.contains(p)){
    					Log.print("SL 실행, userIdx = "+p.userIdx+" , symbol = "+p.symbol+" SL price = "+p.SL+" , sise = "+sise, 1, "call");
    					SocketHandler.sh.sellMarket(p, "", false, null);
    					SocketHandler.sh.liqOrderAllCancel(p.userIdx, p.symbol,"");
    					Copytrade.followLiq(p.userIdx,p.symbol);
    				}
    				iter.remove();
    			}
			} catch (Exception e) {
				double wallet = p.member.getWallet();
				if(CointransService.isInverse(p.symbol)){
					wallet = p.member.getWalletC(p.symbol);
				}
				Log.print("checkTPSL SL err! userIdx = "+p.userIdx+" wallet = "+wallet+" / position = "+p.toString(), 1, "err");
			}
    	}
    }
    
    public static int getPositionIdx(int userIdx, String symbol){
    	try {
    		int get = 0;
    		
    		for (Iterator<Position> iter = SocketHandler.positionList.iterator(); iter.hasNext(); ) {
				Position pos = iter.next();
				if (pos.userIdx == userIdx && pos.symbol.equals(symbol)) {
					Log.print("getPositionIdx find position "+pos.toString(), 6, "log");
					get = SocketHandler.positionList.indexOf(pos);
				}
			}
    		return get;
    	} catch (Exception e) {
    		Log.print("getPosition err! "+e, 0, "err");
    		return 0;
    	}
    }
    
	public static void updateLiquidationPriceByUser(int userIdx, String symbol){
    	if(symbol.equals("UToP") || symbol.equals("PToU")){
    		for (Iterator<Position> iter = SocketHandler.positionList.iterator(); iter.hasNext(); ) {
        		Position p = iter.next();
				if (p.userIdx == userIdx && p.marginType.compareTo("cross") == 0 &&
						!CointransService.isInverse(p.symbol)) {
					Log.print("updateLiquidationPriceByUser find position "+p.toString(), 6, "log");
					p.updateLiquidationPrice();
				}
			}
    	}else{
    		for (Iterator<Position> iter = SocketHandler.positionList.iterator(); iter.hasNext(); ) {
        		Position p = iter.next();
				if(CointransService.isInverse(symbol)){
    				if (p.userIdx == userIdx && p.marginType.compareTo("cross") == 0 &&
    						p.symbol.equals(symbol)) {
    					Log.print("updateLiquidationPriceByUser find position "+p.toString(), 6, "log");
    					p.updateLiquidationPrice();
    				}
				}else{
					if (p.userIdx == userIdx && p.marginType.compareTo("cross") == 0 &&
							!CointransService.isInverse(p.symbol)){
    					Log.print("updateLiquidationPriceByUser find position "+p.toString(), 6, "log");
    					p.updateLiquidationPrice();
    				}
				}
			}
    	}
    }
	
	public static Position getPosition(int userIdx, String symbol){
    	try {
    		Position get = null;
    		for (Iterator<Position> iter = SocketHandler.positionList.iterator(); iter.hasNext(); ) {
        		Position p = iter.next();
				if (p.userIdx == userIdx && p.symbol.compareTo(symbol) == 0) {
					Log.print("getPosition find position "+p.toString(), 6, "log");
					get = p;
				}
			}
    		return get;
		} catch (Exception e) {
			Log.print("getPosition err! "+e, 0, "err");
			return null;
		}
    }
	
	public static void giveFunding(){
		long before = System.currentTimeMillis();
		
		String[] tmpfundingRate = new String[Project.getFullCoinList().size()]; 
    	for(Coin coin : Project.getUseCoinList()){
    		int cnum = coin.coinNum;
    		tmpfundingRate[cnum] = coin.fundingRate;
    	}
        Log.print("---funding fee 제공 ---", 0, "FundingFee");
        
        int positionCoinNum = 0;//BTC 
        float frate = Float.parseFloat(tmpfundingRate[positionCoinNum]);//(float) 0.00075;
        
        synchronized (SocketHandler.positionList) {
        	for (Position p : SocketHandler.positionList) 
        	{ 
        		Coin coin = Coin.getCoinInfo(p.symbol);
        		
        		double gasiMargin = p.contractVolume / p.leverage;
        		
        		if(frate>0){
        			if(p.position.compareTo("long") == 0)
        				minusfundingRate( p.member, gasiMargin, frate, p.symbol, p.position, coin);										
        			else
        				plusfundingRate( p.member, gasiMargin, frate, p.symbol, p.position, coin);								
        		}else{
        			if(p.position.compareTo("long") == 0) 
        				plusfundingRate( p.member, gasiMargin, frate, p.symbol, p.position, coin);								
        			else
        				minusfundingRate( p.member, gasiMargin, frate, p.symbol, p.position, coin);		
        		}   
        		updateLiquidationPriceByUser(p.userIdx, p.symbol);
        	}
		}
        long after = System.currentTimeMillis();
        Log.print("펀딩 지급 완료, 걸린시간 = "+(after - before)+" ms",1,"timecheck");
	}
	
	private static void minusfundingRate(Member m, double contractVolume, float frate, String symbol, String position, Coin coin){
    	try{
    		if(frate < 0) frate = frate * -1;
    		BigDecimal fundingFee = BigDecimal.valueOf(contractVolume).multiply(BigDecimal.valueOf(frate));//뻇을돈
	    	fundingFee = fundingFee.setScale(8, BigDecimal.ROUND_HALF_UP);	 
	    	
	    	if(CointransService.isInverse(symbol))
	    		fundingFee = CointransService.coinTrans(fundingFee,coin);
	    	
	    	Log.print("fundingfee차감   useridx:"+m.userIdx+" 자산규모:"+contractVolume+" 펀딩률:"+frate +" symbol:"+symbol+" fundingfee:"+fundingFee, 0, "FundingFee");
			Wallet.updateWalletAmountSubtract(m, fundingFee.doubleValue(), symbol, "funding");
			
			BigDecimal minusQty = BigDecimal.valueOf(-1);
	    	fundingFee = fundingFee.multiply(minusQty);
			fundingLog(m.userIdx, symbol, position, ""+fundingFee);			
    	}catch(Exception e){
    		Log.print("minusfundingRate err! "+e, 0, "err");
    	}
    	
    }
    
    private static void plusfundingRate(Member m, double contractVolume, float frate, String symbol, String position, Coin coin){
    	try{
	    	if(frate < 0) frate = frate * -1;
    		BigDecimal fundingFee = BigDecimal.valueOf(contractVolume).multiply(BigDecimal.valueOf(frate));//뻇을돈
	    	fundingFee = fundingFee.setScale(1, BigDecimal.ROUND_HALF_UP);	  
	    	
	    	if(CointransService.isInverse(symbol))
	    		fundingFee = CointransService.coinTrans(fundingFee,coin);
	    	
	    	Log.print("fundingfee제공   useridx:"+m.userIdx+" 자산규모:"+contractVolume+" 펀딩률:"+frate +" symbol:"+symbol+" fundingfee:"+fundingFee, 0, "FundingFee");
    		Wallet.updateWalletAmountAdd(m, fundingFee.doubleValue(), symbol, "funding");
    		fundingLog(m.userIdx, symbol, position, ""+fundingFee);
    		
    	}catch(Exception e){
    		Log.print("plusfundingRate err! "+e, 0, "err");
    	}
    }
        
    private static void fundingLog(int userIdx, String symbol, String position, String amount){
    	try {
    		Log.print("call fundingLog : "+userIdx, 0, "evt");
    		EgovMap in = new EgovMap();
    		in.put("userIdx", userIdx);
    		in.put("symbol", symbol);
    		in.put("position", position);
    		in.put("fundingFee", amount);
    		QueryWait.pushQuery("insertFunding", userIdx, in, QueryType.INSERT);
		} catch (Exception e) {
			Log.print("fundingLog err! "+e, 0, "err");
		}
    }   
}
