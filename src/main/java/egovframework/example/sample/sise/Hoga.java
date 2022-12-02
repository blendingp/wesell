package egovframework.example.sample.sise;

import org.json.simple.JSONObject;

import egovframework.example.sample.classes.Coin;
import egovframework.example.sample.classes.SocketHandler;

public class Hoga{
	double quantity;
	double price;
	String position;
	Coin coin;
	
	//생성자	
	public Hoga(double quantity, double price, Coin coin, String position){
		this.quantity = quantity;
		this.price = price;
		this.position = position; 
		this.coin = coin;
	}
	
	public void sendHoga(){
		JSONObject obj = new JSONObject();
		obj.put("protocol", "sendHoga");
		obj.put("coinNum", coin.coinNum);
		obj.put("quantity", this.quantity);
		obj.put("price", this.price);
		obj.put("position", this.position);
		System.out.println("coinNUm:"+coin.coinNum+" quantity:"+this.quantity+" price:"+this.price);
		SocketHandler.sh.OnManagerSendHoga(obj);		
	}
	
	public void sendRemoveHoga(){
		double quan = this.quantity*-1;
		JSONObject obj = new JSONObject();
		obj.put("protocol", "sendHoga");
		obj.put("coinNum", coin.coinNum);
		obj.put("quantity", quan);
		obj.put("price", this.price);
		obj.put("position", this.position);
		System.out.println("coinNUm:"+coin.coinNum+" quantity:"+quan+" price:"+this.price);
		SocketHandler.sh.OnManagerSendHoga(obj);		
	}
	//호가 삽입(병합)
/*	public void addHoga(){	
		if( this.position.compareTo("long")==0){
			synchronized (coin.hogaLongList) {	
				//0번쨰 데이터
				if(coin.hogaLongList[0] == null){
					coin.hogaLongList[0] = this;		
					sendHoga();
					return;
				}			
				
				int tmp = 0;
				for (int i = 0; i < coin.hogaLongList.length; i++) {
					if(coin.hogaLongList[i] == null) break;
					tmp = i;
					double hogaPrice = coin.hogaLongList[i].price;
					double hogaQuantity = coin.hogaLongList[i].quantity;
					//같으면 병합
					if( hogaPrice == this.price){
						//데이터 이미 존재하면 병합
						sendHoga();
						this.quantity += hogaQuantity;
						coin.hogaLongList[i].quantity = this.quantity;						
						printHoga();
						return;
					}
				}		
				
				coin.hogaLongList[tmp+1] = this;
				//두번째 이후 데이터 부터 ( 같은 가격없을때 여기서 보내줌)
				sendHoga();
				printHoga();
			}	
		}
		else {
			synchronized (coin.hogaShortList) {			
				if(coin.hogaShortList[0] == null){
					coin.hogaShortList[0] = this;
					sendHoga();
					return;
				}			
				
				int tmp = 0;
				for (int i = 0; i < coin.hogaShortList.length; i++) {
					if(coin.hogaShortList[i] == null) break;
					tmp = i;
					double hogaPrice = coin.hogaShortList[i].price;
					double hogaQuantity = coin.hogaShortList[i].quantity;
					//같으면 병합
					if( hogaPrice == this.price){
						sendHoga();
						this.quantity += hogaQuantity;
						coin.hogaShortList[i].quantity = this.quantity; 
						printHoga();						
						return;
					}
				}			
								
				coin.hogaShortList[tmp+1] = this;
				sendHoga();
				printHoga();
			}			
		}
	}*/
	
	public void printHoga(){
		System.out.println("롱 호가 정렬 체크");
		for (int i = 0; i < coin.hogaLongList.length; i++) {
			if(coin.hogaLongList[i] == null) break;
			System.out.println(i+" 가격: "+ coin.hogaLongList[i].price +" 수량:"+ coin.hogaLongList[i].quantity+" 방향:"+coin.hogaLongList[i].position);
		}
		System.out.println("숏 호가 정렬 체크");
		for (int i = 0; i < coin.hogaShortList.length; i++) {
			if(coin.hogaShortList[i] == null) break;
			System.out.println(i+" 가격: "+ coin.hogaShortList[i].price +" 수량:"+ coin.hogaShortList[i].quantity+" 방향:"+coin.hogaShortList[i].position);
		}
	}
	//호가 삭제(차감)
	public void removeHoga(){	
		if( this.position.compareTo("long")==0){
			synchronized (coin.hogaLongList) {
				for (int i = 0; i < coin.hogaLongList.length; i++) {
					if(coin.hogaLongList[i] == null) return;
					double hogaPrice = coin.hogaLongList[i].price;
					double hogaQuantity = coin.hogaLongList[i].quantity;					
					//같으면 병합
					if( hogaPrice == this.price){
						sendRemoveHoga();
						System.out.println("기존수량 :"+hogaQuantity+" 차감수량:"+this.quantity);						
						hogaQuantity -= this.quantity;		
						this.quantity = hogaQuantity; 
						System.out.println("현수량 :"+this.quantity);
						coin.hogaLongList[i].quantity = this.quantity;
						//0보다 작으면 제거 
						if(this.quantity<=0){
							for (int k = i; k < coin.hogaLongList.length; k++) {
								if(coin.hogaLongList[k] == null)
									break;
								coin.hogaLongList[k] = coin.hogaLongList[k+1];
							}
						}
						return;
					}
				}				
			}
			sendRemoveHoga();
		}
		else{
			synchronized (coin.hogaShortList) {
				for (int i = 0; i < coin.hogaShortList.length; i++) {
					if(coin.hogaShortList[i] == null) return;
					double hogaPrice = coin.hogaShortList[i].price;
					double hogaQuantity = coin.hogaShortList[i].quantity;
					
					//같으면 병합
					if( hogaPrice == this.price){
						sendRemoveHoga();
						System.out.println("기존수량 :"+hogaQuantity+" 차감수량:"+this.quantity);
						hogaQuantity -= this.quantity;		
						this.quantity = hogaQuantity; 
						System.out.println("현수량 :"+this.quantity);
						coin.hogaShortList[i].quantity = this.quantity;
						//0보다 작으면 제거 
						if(this.quantity<=0){
							for (int k = i; k < coin.hogaShortList.length; k++) {
								if(coin.hogaShortList[k] == null)
									break;
								coin.hogaShortList[k] = coin.hogaShortList[k+1];
							}
						}
						return;
					}
				}
			}
			sendRemoveHoga();
		}
	
		
		System.out.println("롱 호가 제거 체크");
		for (int i = 0; i < coin.hogaLongList.length; i++) {
			if(coin.hogaLongList[i] == null) break;
			System.out.println(i+" 가격: "+ coin.hogaLongList[i].price +" 수량:"+ coin.hogaLongList[i].quantity+" 방향:"+coin.hogaLongList[i].position);
		}
		System.out.println("숏 호가 제거 체크");
		for (int i = 0; i < coin.hogaShortList.length; i++) {
			if(coin.hogaShortList[i] == null) return;
			System.out.println(i+" 가격: "+ coin.hogaShortList[i].price +" 수량:"+ coin.hogaShortList[i].quantity+" 방향:"+coin.hogaShortList[i].position);
		}
	}
}

