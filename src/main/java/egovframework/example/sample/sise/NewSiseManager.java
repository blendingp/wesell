package egovframework.example.sample.sise;

import java.net.URI;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHttpHeaders;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.client.WebSocketClient;
import org.springframework.web.socket.client.standard.StandardWebSocketClient;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.Project;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;
import egovframework.example.sample.web.admin.AdminDeleteListController;

public class NewSiseManager {
	
	public static boolean _autoReconnect = false;//접속 끊기면 바로 재접속 요청 함
	
	//{거래 테스트용 시세 조작 관련
	public static double _rc_target=0;//시세 조작 목표값
	public static double _rc_adder=0;//증감된 시세값
	public static double _rc_adderpower=0;//틱마다 증감될 시세 값
	public static String _rc_symbol="";//목표 심볼
	public static boolean _rc_checked=false;//목표에 닿았는지
	public static boolean _rc_start=false;//시세 조작하는 중인지
	public static void setStartRC(double adderpower,double target,String symbol){
		_rc_target = target;
		_rc_symbol = symbol;
		_rc_adderpower = adderpower;
		_rc_adder = 0;
		_rc_checked = false;
		_rc_start=true;
	}
	//}
	
	static public int[] handmake={-1,-1}; 
	public WebSocketSession webSocketSession=null;
	boolean isSeted = false;
//	public String url="ws://localhost:8288/port8288";//8287이아니라 8288로 한건... 암튼 노드 보면 암.
    public String url="wss://fstream.binance.com/stream?streams=";//시세 받을 서버 주소문자열,바이낸스

	public NewSiseManager(){
		websocketConnect();
	}
	long lasttick=(new  Date()).getTime()+60000;
	public String isotimestr(Date time){
		String str=""+(time.getYear()+1900)
				+"-"+StringUtils.substring(("0"+(time.getMonth()+1)),-2)
				+"-"+StringUtils.substring(("0"+time.getDate() ),-2)+" "
				+ StringUtils.substring(("0"+time.getHours() ),-2)
				+":"+StringUtils.substring(("0"+time.getMinutes() ),-2)+":00";
		return str;
	}
	public String isotimestrs(Date time){
		String str=""+(time.getYear()+1900)
				+"-"+StringUtils.substring(("0"+(time.getMonth()+1)),-2)
				+"-"+StringUtils.substring(("0"+time.getDate() ),-2)+" "
				+ StringUtils.substring(("0"+time.getHours() ),-2)
				+":"+StringUtils.substring(("0"+time.getMinutes() ),-2)
				+":"+StringUtils.substring(("0"+time.getSeconds()),-2);
		return str;
	}
	public void checkState(){//외부에서 1분에 한번씩 호출해주고, 1분동안 패킷 받은게 없다면 재접속하는 역할을 한다.
		if( (new Date()).getTime() -   lasttick > 60000)
		{
            try {
            	JSONObject exitJson = new JSONObject();
            	exitJson.put("protocol", "exit");
            	synchronized(webSocketSession){
            		webSocketSession.sendMessage(new TextMessage(exitJson.toJSONString()));
            	}
            	Thread.sleep(500);
            } catch (Exception ignored) {
            	System.out.println("종료 코드 send error ");
            }
			websocketConnect();
		}
	}
	public void sendSiseServer(JSONObject tmpobj){
        try {       
        	Log.print("sendSiseServer json :"+tmpobj.toJSONString(),2,"sise" );
        	synchronized(webSocketSession){
        		webSocketSession.sendMessage(new TextMessage(tmpobj.toJSONString()));
        	}
        } catch (Exception ignored) {
        	System.out.println("managerOne  send error ");
        }
	}	
	
	WebSocketClient webSocketClient = null;
	public WebSocketSession websocketConnect(){
    	Log.print("connect start", 1, "log");
		try {
			ArrayList<String> useCoins = Project.getUseCoinNames();
			for(String coin : useCoins){
				if(useCoins.indexOf(coin) != 0) url+="/";
				coin = coin.toLowerCase()+"usdt";
				url += coin+"@markPrice@1s/"+coin+"@depth20/"+coin+"@ticker/"+coin+"@kline_1m/"+coin +"@aggTrade";
			}
            System.out.println("websocket connect start : "+ url);
			
            webSocketClient = new StandardWebSocketClient();
 
            webSocketSession= webSocketClient.doHandshake(new TextWebSocketHandler() {
                @Override public void handleTextMessage(WebSocketSession session, TextMessage message) {
                	OnMessageManager(session,message.getPayload());
                }
                @Override public void afterConnectionEstablished(WebSocketSession session) {
                	Log.print("connect ok", 1, "call_send");
                	OnAfterConnect(session);
                }
                @Override public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
                	Log.print("connect tsp error .", 1, "err");
                }
                @Override
                public void afterConnectionClosed(WebSocketSession session,CloseStatus status) throws Exception {
                	Log.print("connect tsp closed .", 1, "err_notsend");
                	afterConnectionClosedManager(session);
                }
            }, new WebSocketHttpHeaders(), URI.create(url)).get();
            return webSocketSession;
        } catch (Exception e) {
        	Log.print("connect start "+e.getMessage(), 1, "err_notsend");
        	_autoReconnect = true;
        	return null;
        }
	}
	
	public void afterConnectionClosedManager(WebSocketSession session){
		try{			
			Log.print("afterConnectionClosedManager 접속끊김 .", 1, "err");
			webSocketSession = null;
			webSocketClient = null;
			_autoReconnect = true;
		}catch(Exception e){System.out.println("s err:"+e.toString() );}
	}
	public void OnAfterConnect(WebSocketSession session){
		_autoReconnect = false;
	}
		
	public void OnMessageManager(WebSocketSession session, String msg){
		
		JSONParser p = new JSONParser();
		JSONObject obj = null;
        String s ="";
		
		try {
			obj = (JSONObject) p.parse(msg);
            s = ""+obj.get("stream");
		} catch (Exception e) {
			return;
		}
		if      (s.indexOf("@depth20") >= 0 ) {//오더북
           // System.out.println("o : "+msg );
		}else if (s.indexOf("@kline_1m") >= 0 ) {
            JSONObject ok = (JSONObject)obj.get("data");
            String coin = ""+ok.get("s");
            JSONObject oc = (JSONObject)ok.get("k");
    		OnMessageManagerWrap(coin,session, ""+ oc.get("c"));
        }
		
		
	}
	public void OnMessageManagerWrap(String symbol, WebSocketSession session, String msg){
		
		Coin coin = Coin.getCoinInfo(symbol);
    	setHL(coin, 0, msg);
    	coin.bidsPriceList[0] = msg;
    	setHL(coin, 1,msg);
    	coin.asksPriceList[0] = msg;
		
	}
	void siseChange(JSONObject obj, String symbol ){
		if( _rc_start == false )					return;
		if( symbol.compareTo(_rc_symbol) != 0 )		return;
		
		Coin coin = Coin.getCoinInfo(symbol);
		
		if( _rc_checked == false){
			if( _rc_adderpower < 0 ){
					_rc_adder +=_rc_adderpower;
					if( coin.getSise("long") < _rc_target ){
						_rc_checked= true;
					}
			}else{
				_rc_adder +=_rc_adderpower;
				if( coin.getSise("long") > _rc_target ){
					_rc_checked= true;
				}
			}
		}else{
			_rc_adder += _rc_adderpower *-1;
			if( _rc_adderpower < 0 ){
				if( _rc_adder > 0 )	_rc_start = false;
			}else{
				if( _rc_adder < 0 )	_rc_start = false;
			}
		}
	}
	
	private void setHL(Coin coin, int type, String price){
		try{
			if(price == null) return;
			//bids 
			
			if(type == 0){
				//if( coinNum == 0)
					//Log.print("2 setHL type:"+type+"\tcoinNum:"+coinNum+"\tprice:"+price +"\tbidsH:"+SocketHandler.bidsH[coinNum]+ "\tbidsL:"+SocketHandler.bidsL[coinNum] , 1, "setHL");
				
				// 최고가 최저가 저장
				if(Double.parseDouble(price) > Double.parseDouble(coin.bidsH)){
					coin.bidsH = price;
				}
				if(Double.parseDouble(price) < Double.parseDouble(coin.bidsL)){
					coin.bidsL = price;
				}
					
			}
			//asks
			else if(type == 1){
				// 최고가 최저가 저장
				if(Double.parseDouble(price) > Double.parseDouble(coin.asksH)){
					coin.asksH = price;
				}
				if(Double.parseDouble(price) < Double.parseDouble(coin.asksL)){
					coin.asksL = price;
				}
					
			}			
		}catch(Exception e){
			Log.print("setHL err "+e+" coin:"+coin.coinName+" type:"+type+" price:"+price, 1, "err");
		}
	}
	
	public static void autoConnectCheck(NewSiseManager siseMgr){
		if(_autoReconnect){
			if(siseMgr.webSocketSession == null){
				siseMgr.websocketConnect();
			}
		}
	}
}
