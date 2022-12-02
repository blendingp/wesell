package egovframework.example.sample.comparator;

import java.util.Comparator;

import egovframework.example.sample.classes.Order;

public class OrderListComparator implements Comparator<Order>{

	@Override
	public int compare(Order o1, Order o2){
		double entry1 = o1.entryPrice;
		double entry2 = o2.entryPrice;
		
		if( entry1 > entry2 ){
			return -1;
		}else if(entry1 < entry2){
			return 1;
		}else
			return 0;
	}
}
