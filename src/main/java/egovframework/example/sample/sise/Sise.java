package egovframework.example.sample.sise;

import org.json.simple.JSONObject;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.SocketHandler;
import egovframework.example.sample.service.impl.Log;

public class Sise {
	String symbol;
	double price;
	double amount;
	
	public Sise(String _symbol, double _price, double _amount){
		symbol = _symbol;
		price = _price;
		amount = _amount;
	}
	public Sise(String _symbol, String _price, String _amount){
		symbol = _symbol;
		price = 0;
		amount = 0;
		try {
			price = Double.parseDouble(_price);
			amount = Double.parseDouble(_amount);
		} catch (Exception e) {
			Log.print("Sise err! "+e, 1, "err");
		}
	}
	
	public String getSymbol(){
		return symbol;
	}
	
	public JSONObject getSiseJSON(){
		JSONObject obj = new JSONObject();
		obj.put("protocol", "symbolSise");
		obj.put("symbol", symbol);
		obj.put("price", price);
		return obj;
	}
}
