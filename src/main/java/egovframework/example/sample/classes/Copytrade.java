package egovframework.example.sample.classes;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

import egovframework.example.sample.enums.CopytradeKind;
import egovframework.example.sample.enums.CopytradeState;
import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.util.PublicUtils;
import egovframework.example.sample.web.util.Send;
import egovframework.example.sample.web.util.Validation;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class Copytrade {
	String guid;
	int userIdx;
	int traderIdx;
	public String symbol;
	boolean isQtyRate; // 수량 모드 false = 고정개수 사용, true = 고정 비율 사용
	double fixQty; // 고정 개수 사용시 그 개수  , 혹은 고정 비율 사용시 비율
	boolean isLeverageFollow; // 레버리지 팔로우 여부
	Integer fixLeverage = null; // 팔로우 안할시 설정한 레버리지
	boolean useLossCut; //손절 사용여부
	Double lossCutRate = null; //손절률
	boolean useProfitCut; //익절 사용여부
	Double profitCutRate = null; //익절률
	boolean useMaxPosition; //최대 포지션 사용여부
	Double maxPositionQtyUSDT = null; //최대 포지션 개수
	Position position = null;
	Member member = null;
	Member trader = null;
	double followMoney = 0; // 원금
	double profit = 0; // 수익
	boolean maxQty = false; // 맥스포지션으로 인한 구매거절시 체크용도
	String sdate = "";
	boolean plLog = false;
	boolean request = false;
	
	public Copytrade(int _useridx, int _traderIdx, String _symbol, boolean _isQtyRate, 
			double _fixQty, Integer _fixLeverage, Double _lossCutRate, Double _profitCutRate, Double _maxPositionQty, int state, String guid, double followMoney, double profit, String sdate){
		if(guid == null || guid.equals("null")){
			this.guid = System.currentTimeMillis()+userIdx+Validation.getTempNumber(2);
		}else{
			this.guid = guid;
		}
		
		if(state == CopytradeState.REQUEST.getValue())
			this.request = true;
		this.userIdx = _useridx;
		this.traderIdx = _traderIdx;
		this.symbol = _symbol;
		this.isQtyRate = _isQtyRate;
		this.fixQty = _fixQty;
		this.followMoney = followMoney;
		this.profit = profit;
		if(_fixLeverage == null)
			this.isLeverageFollow = true;
		else{
			this.isLeverageFollow = false;
			this.fixLeverage = _fixLeverage;
		}
		
		if(_lossCutRate == null)
			this.useLossCut = false;
		else{
			this.useLossCut = true;
			this.lossCutRate = _lossCutRate;
		}
		
		if(_profitCutRate == null)
			this.useProfitCut = false;
		else{
			this.useProfitCut = true;
			this.profitCutRate = _profitCutRate;
		}
		
		if(_maxPositionQty == null)
			this.useMaxPosition = false;
		else{
			this.useMaxPosition = true;
			this.maxPositionQtyUSDT = _maxPositionQty;
		}
		this.sdate = sdate;
	}
	
	public void setPosition(){
		for(Position pos : SocketHandler.positionList){
			if(pos.symbol.equals(this.symbol) && pos.userIdx == this.userIdx)
				this.position = pos;
		}
	}
	
	private Position getPosition(){
//		if(this.position == null){
			setPosition();
//		}
		return this.position;
	}
	
	public Member getMember(){
		if(member == null)
			member = Member.getMemberByIdx(userIdx);
		return member;
	}
	
	public Member getTrader(){
		if(trader == null)
			trader = Member.getMemberByIdx(traderIdx);
		return trader;
	}
	
	//state 변동 조건체크함수
	//db state = 0 - 작동, 1 - 직접 중지, 2 - 손절, 3 - 익절, 4 - 잔액부족
	private CopytradeState getState(){
		if(position == null)
			return CopytradeState.RUN;
		
		if(useLossCut && getPosition().getProfitRate() <= -lossCutRate)
			return CopytradeState.LOSSCUT;
		else if(useProfitCut && getPosition().getProfitRate() >= profitCutRate)
			return CopytradeState.PROFITCUT;
		
		Member user = getMember();
		if(user.wallet <= 1)
			return CopytradeState.NOMONEY;
		//보다 상세한 잔액 부족은 구매에서 다뤄야 함
		return CopytradeState.RUN;
	}
	
	public void cutProcess(CopytradeState state){
		switch(state){
		case LOSSCUT: 
			insertCopytradeLog(CopytradeKind.LOSSCUT);
			plLog = true;
			liq();
			break;
		case PROFITCUT:
			insertCopytradeLog(CopytradeKind.PROFITCUT);
			plLog = true;
			liq();
			break;
		default:
			break;
		}
	}
	
	public void liq(){
		if(request) return;
		
		//sellMarket
		if(getPosition() == null){
			Log.print("copytrade liq 실행, 판매할 포지션 없음. 유저 = "+userIdx+"심볼 = "+symbol, 1, "copytrade");
		}else{
			Log.print("copytrade liq 실행. 유저 = "+userIdx+"심볼 = "+symbol+" 수익률 "+position.getProfitRate(), 1, "copytrade");
			SocketHandler.sh.sellMarket(getPosition(), "", false, this);
		}
		position = null;
	}
	
	public void buy(String position, int leverage, double sise){
		if(request) return;
		
		if(!isLeverageFollow){
			leverage = fixLeverage;
		}
		Coin coin = Coin.getCoinInfo(symbol);
		if(sise == -1){
			Log.print(symbol+" "+position+" 시세 로드 오류. copytrade buy 중지, userIdx = "+userIdx, 1, "err");
			return;
		}
		double qty = 0;
		double use = fixQty; // 사용 USDT
		if(isQtyRate){ // true = 자산 비율, false = 고정 개수
			double rate = fixQty * 0.01;
			use = CointransService.getWithdrawWallet(userIdx, symbol).doubleValue() * rate * 0.98;
		}
		qty = getQty(use, leverage, position, coin);
		
		double min = PublicUtils.toFixed(SocketHandler.getMinValue(coin.qtyFixed),coin.qtyFixed);
		if(qty < min){
			Log.print("copytrade 구매 실패 , 최소수량 = "+min+" 구매요청수량 = "+qty, 0, "copytrade");

			if(Position.getPosition(userIdx, symbol) == null){ // 기존 포지션이 없을 경우에만 카피트레이드 종료 처리.
//				updateCopytrade(this, CopytradeState.NOMONEY);
			}
			return;
		} 
		
		BigDecimal price = BigDecimal.valueOf(sise);
		BigDecimal volume = price.multiply(BigDecimal.valueOf(qty)); 
		Trade trade = new Trade(member, symbol, "market", position, qty, leverage, "iso");
		Log.print("copytrade buy 실행. 유저 = "+userIdx+"심볼 = "+symbol+" 시세 = "+sise+" 레버리지 = "+leverage+" 자산비율사용여부 "+isQtyRate+
				"수량(비율) = "+fixQty+" 구매 Qty = "+qty, 1, "copytrade");
		if(!SocketHandler.sh.buyProcess(getMember(), trade, volume, sise, null, this)){ // 잔액 부족
			if(!maxQty){
//				updateCopytrade(this, CopytradeState.NOMONEY);
			}else
				maxQty = false;
		}
	}
	
	public boolean positionQtyCheck(String position, double margin){
		if(useMaxPosition){
			double fee = 0;
			if(getPosition() != null)
				fee = getPosition().fee;
			double totalUSDT = fee + margin;
			if(totalUSDT > maxPositionQtyUSDT){ // USDT로 수량 비교)
				double prevMargin = 0;
				if(getPosition() != null)
					prevMargin = getPosition().fee;
				Log.print("카피트레이드 구매 포지션증거금체크 거절 / "+userIdx+" 유저 , 심볼 = "+symbol+" / 맥스증거금 "+maxPositionQtyUSDT+" / 새로 넣게될 증거금 - "+margin+" 기존 증거금 = "+prevMargin,1,"copytrade");
				maxQty = true;
				return false;
			}
		}
		return true;
	}
	
	public void updateFollowMoney(double money){
		followMoney += money;
	}
	public void updateProfit(double money){
		profit += money;
	}
	
	public String getCopyInfo(){
		return "uidx = "+userIdx+" / tidx = "+traderIdx+" / symbol = "+symbol+" / 비율사용 = "+isQtyRate+" / 구매량 = "+fixQty+" / 레버리지  = "+fixLeverage+
				" / 손절률 "+lossCutRate+" / 익절률 "+profitCutRate+" / 최대포지션수량 "+maxPositionQtyUSDT+"\n";
	}
	
	public EgovMap getMap(){
		EgovMap map = new EgovMap();
		map.put("uidx", userIdx);
		map.put("tname", getTrader().name);
		map.put("symbol", symbol);
		map.put("fixQty", fixQty);
		map.put("isQtyRate", isQtyRate);
		map.put("fixLeverage", fixLeverage);
		map.put("lossCutRate", lossCutRate);
		map.put("profitCutRate", profitCutRate);
		map.put("maxPositionQty", maxPositionQtyUSDT);
		map.put("profit", profit);
		map.put("followMoney", followMoney);
		map.put("sdate", sdate);
		
		return map;
	}
	
	public boolean requestConfirm(){
		if(request){
			EgovMap in = new EgovMap();
			in.put("uidx",userIdx);
			in.put("tidx",traderIdx);
			in.put("symbol",symbol);
			in.put("state",CopytradeState.RUN.getValue());
			in.put("sdate",Send.getTime());
			QueryWait.pushQuery("requestConfirmCopytrade",userIdx, in, QueryType.UPDATE,false);
			
			request = false;
			return true;
		}
		return false;
	}

	public static void allCutCheck(){
		if(!Project.isCopytrade())
			return;
		Queue<Copytrade> lcutQueue = new LinkedList<>();
		Queue<Copytrade> pcutQueue = new LinkedList<>();
		try {
			synchronized (SocketHandler.copytradeList) {
				for(Copytrade copy : SocketHandler.copytradeList){
					CopytradeState state = copy.getState();
					if(state == CopytradeState.LOSSCUT)
						lcutQueue.add(copy);
					else if(state == CopytradeState.PROFITCUT)
						pcutQueue.add(copy);
				}
			}
			
			while(lcutQueue.size() != 0){
				lcutQueue.poll().cutProcess(CopytradeState.LOSSCUT);
			}
			while(pcutQueue.size() != 0){
				pcutQueue.poll().cutProcess(CopytradeState.PROFITCUT);
			}
		} catch (Exception e) {
			Log.print("allCutCheck err!", 1, "err");
		}
	}

	public static boolean pushCopytrade(Copytrade copy){
		Log.print("call pushCopytrade / "+copy, 1, "call");
		try {
			if(Member.hasPositionOrder(copy.userIdx, copy.symbol)){
				Log.print("pushCopytrade 등록실패. "+copy.userIdx+" 유저 "+copy.symbol+"에 소유중인 포지션 혹은 오더 있음", 1, "copytrade");
				return false;
			}else if(getCopytrade(copy.userIdx, copy.symbol) != null){
				Log.print("pushCopytrade 등록실패. "+copy.userIdx+" 유저 "+copy.symbol+"에 이미 실행중인 카피트레이딩 정보 있음", 1, "copytrade");
				return false;
			}
			EgovMap in = new EgovMap();
			in.put("uidx",copy.userIdx);
			in.put("tidx",copy.traderIdx);
			in.put("symbol",copy.symbol);
			in.put("isQtyRate",copy.isQtyRate);
			in.put("fixQty",copy.fixQty);
			in.put("fixLeverage",copy.fixLeverage);
			in.put("lossCutRate",copy.lossCutRate);
			in.put("profitCutRate",copy.profitCutRate);
			in.put("maxPositionQty",copy.maxPositionQtyUSDT);

			in.put("guid",copy.guid);
			if(copy.request)
				in.put("state",CopytradeState.REQUEST.getValue());
				
			QueryWait.pushQuery("insertCopytrade",copy.userIdx, in, QueryType.INSERT);
			
			synchronized (SocketHandler.copytradeList) {
				SocketHandler.copytradeList.add(copy);
			}
			
			Member trader = copy.getTrader();
			trader.getTrader().addFollowers(copy.userIdx);
			return true;
		} catch (Exception e) {
			// TODO: handle exception
			Log.print("err pushCopytrade / "+copy, 1, "err");
			return false;
		}
		
	}
	public static void updateCopytrade(Copytrade copy){
		try {
			EgovMap in = new EgovMap();
			in.put("uidx",copy.userIdx);
			in.put("tidx",copy.traderIdx);
			in.put("symbol",copy.symbol);
			in.put("followMoney",copy.followMoney);
			in.put("profit",copy.profit);
			in.put("guid",copy.guid);
			QueryWait.pushQuery("updateCopytrade",copy.userIdx, in, QueryType.UPDATE, false);
		} catch (Exception e) {
			Log.print("err updateCopytrade / "+copy, 1, "err");
		}
	}
	
	public static void updateCopytrade(Copytrade copy, CopytradeState setState){ // state 바뀌면 종료로 간주
		if(setState == CopytradeState.RUN){
			updateCopytrade(copy);
			return;
		}
		try {
			Trader.removeFollower(copy.traderIdx,copy.userIdx);
			EgovMap in = new EgovMap();

			in.put("guid",copy.guid);
			in.put("uidx",copy.userIdx);
			in.put("tidx",copy.traderIdx);
			in.put("symbol",copy.symbol);
			in.put("state",setState.getValue());
			in.put("followMoney",copy.followMoney);
			in.put("profit",copy.profit);
			QueryWait.pushQuery("updateCopytrade",copy.userIdx, in, QueryType.UPDATE, false);
			synchronized (SocketHandler.copytradeList) {
				SocketHandler.copytradeList.remove(copy);
			}
		} catch (Exception e) {
			Log.print("err updateCopytrade / "+copy, 1, "err");
		}
	}
	//팔로워, 심볼
	public static Copytrade getCopytrade(int userIdx, String symbol){
		synchronized (SocketHandler.copytradeList) {
			for(Copytrade copy : SocketHandler.copytradeList){
				if(copy.userIdx == userIdx){
					if(copy.symbol.equals(symbol)){
						return copy;
					}
				}
			}
		}
		return null;
	}
	//팔로워의 모든 심볼 정보 불러옴
	public static ArrayList<Copytrade> getCopytrades(int userIdx){
		ArrayList<Copytrade> clist = new ArrayList<>();
		synchronized (SocketHandler.copytradeList) {
			for(Copytrade copy : SocketHandler.copytradeList){
				if(copy.userIdx == userIdx){
					clist.add(copy);
				}
			}
		}
		return clist;
	}
	public static ArrayList<EgovMap> getRunMaps(int userIdx){
		ArrayList<EgovMap> maps = new ArrayList<>();
		ArrayList<Copytrade> clist = getCopytrades(userIdx);
		
		for(Copytrade copy : clist){
			if(copy.request) continue;
			maps.add(copy.getMap());
		}
		return maps;
	}
	//트레이더의 해당 심볼에 대한 모든 팔로우
	public static ArrayList<Copytrade> getFollowCopys(int traderIdx, String symbol){
		ArrayList<Copytrade> clist = new ArrayList<>();
		synchronized (SocketHandler.copytradeList) {
			for(Copytrade copy : SocketHandler.copytradeList){
				if(copy.traderIdx == traderIdx && copy.symbol.equals(symbol)){
					clist.add(copy);
				}
			}
		}
		return clist;
	}
	public static void followLiq(int trader, String symbol){
		if(!Project.isCopytrade())
			return;
		
		if(Member.getMemberByIdx(trader).getTrader() == null)
			return;
		
		long beforeTime = System.currentTimeMillis(); // 코드 실행 후에 시간 받아오기
		
		ArrayList<Copytrade> followlist = getFollowCopys(trader,symbol);
		for(Copytrade copy : followlist){
			copy.liq();
		}

		long afterTime = System.currentTimeMillis(); // 코드 실행 후에 시간 받아오기
		long secDiffTime = (afterTime - beforeTime); //두 시간에 차 계산
		Log.print(trader+" 트레이더 "+symbol+" 포지션 청산, 하위 팔로워 "+followlist.size()+"명 청산완료. 걸린시간(ms) - "+secDiffTime, 1, "copytrade");
	}
	public static void followBuy(int trader, String symbol, String position, int leverage, double sise){
		if(!Project.isCopytrade())
			return;
		if(Member.getMemberByIdx(trader).getTrader() == null)
			return;
		
		long beforeTime = System.currentTimeMillis(); // 코드 실행 후에 시간 받아오기
		
		ArrayList<Copytrade> followlist = getFollowCopys(trader,symbol);
		for(Copytrade copy : followlist){
			copy.buy(position, leverage, sise);
		}
		long afterTime = System.currentTimeMillis(); // 코드 실행 후에 시간 받아오기
		long secDiffTime = (afterTime - beforeTime); //두 시간에 차 계산
		Log.print(trader+" 트레이더 "+symbol+" 포지션 구매, 하위 팔로워 "+followlist.size()+"명 구매완료. 걸린시간(ms) - "+secDiffTime, 1, "copytrade");
	}
	//트레이더 모든 팔로워 중지
	public static void releaseFollower(int tidx){
		Queue<Copytrade> release = new LinkedList<>();
		synchronized (SocketHandler.copytradeList) {
			for(Copytrade copy : SocketHandler.copytradeList){
				if(copy.traderIdx == tidx)
					release.add(copy);
			}
		}
		while(release.size() != 0){
			Copytrade copy = release.poll();
			updateCopytrade(copy, CopytradeState.TRADER_RELEASE);
		}
	}
	//트레이더 특정 심볼 유저들 중지
	public static void stopSymbol(int traderIdx, String symbol){
		ArrayList<Copytrade> clist = getFollowCopys(traderIdx,symbol);
		Queue<Copytrade> release = new LinkedList<>();
		for(Copytrade copy : clist){
			release.add(copy);
		}
		while(release.size() != 0){
			Copytrade copy = release.poll();
			updateCopytrade(copy, CopytradeState.SYMBOL_RELEASE);
		}
	}
	
	private double getQty(double useUSDT, int leverage, String position, Coin coin){
		double sise = coin.getSise(position);
		double price = useUSDT * leverage;
		double qty = price / sise;
		qty = PublicUtils.toFixed(qty, coin.qtyFixed);
		double rate = Project.getFeeRate(getMember(),"market").doubleValue();
		double resultFee = getFee(sise,qty,leverage,rate);
		double minus = qtyWhileMinus(coin.qtyFixed, leverage, qty);
		
		if(qty < minus * 10)
			minus = qtyWhileMinus(coin.qtyFixed, 0, qty);
		
		while(resultFee > useUSDT){
			qty -= minus;
			resultFee = getFee(sise,qty,leverage, rate);
		}
		qty = PublicUtils.toFixed(qty,coin.qtyFixed);
		
		double maxQty = Coin.getMaxContractVolume(symbol,leverage) / sise;
		Position pos = Position.getPosition(userIdx, symbol);
		double prevQty = 0;
		if(pos != null) prevQty = pos.buyQuantity;
		double possibleQty = (maxQty - prevQty) * 0.98;
		
		if(qty > possibleQty)
			qty = PublicUtils.toFixed(possibleQty,coin.qtyFixed);
				
		return qty;
	}
	
	private double qtyWhileMinus(int qtyFixed, int leverage, double qty){
		double minus = 1;
		for(int i = 0; i < qtyFixed; i++)
			minus *= 0.1;
		return PublicUtils.toFixed(minus + (minus * (leverage / 2)),4);
	}
	
	private double getFee(double price, double qty, double leverage,double rate){
		double volume = price * qty;
		double init = volume / leverage;
		double fee2 = volume * (1 - (1 / leverage)) * rate;
		double fee = init + volume * rate;
		fee = fee + fee2;
		return fee;
	}
	
	public boolean insertCopytradeLog(CopytradeKind kind){
		if(getPosition() == null)
			return false;

		return insertCopytradeLog(position.getProfit().doubleValue(), kind);
	}
	
	public boolean insertCopytradeLog(Double result, CopytradeKind kind){
		if(getPosition() == null)
			return false;
		if(plLog){
			plLog = false;
			return false;
		}

		EgovMap in = new EgovMap();
		in.put("uidx", userIdx);
		in.put("tidx", traderIdx);
		in.put("symbol", symbol);
		in.put("position", position.position);
		in.put("entryPrice", position.entryPrice);
		in.put("buyQuantity", position.buyQuantity);
		in.put("levFollow", isLeverageFollow);
		in.put("leverage", position.leverage);
		in.put("margin", position.fee);
		in.put("kind", kind.getValue());
		in.put("result", result);
		
		QueryWait.pushQuery("insertCopytradeLog",userIdx, in, QueryType.INSERT);
		return true;
	}
	public static boolean isCopytradeRun(int userIdx){
    	for(Copytrade c : SocketHandler.copytradeList){
    		if(c.userIdx == userIdx) return true;
    	}
    	return false;
    }
}









