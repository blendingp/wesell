package egovframework.example.sample.classes;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.Queue;

import egovframework.example.sample.enums.QueryType;
import egovframework.example.sample.service.impl.Log;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public class QueryWait {
	public QueryType type;
	public EgovMap map;
	public String queryName;
	public int userIdx;
	
	public QueryWait(String _qname, int _userIdx, EgovMap _map,QueryType _type) 
	{
		this.type = _type;
		this.map =_map;
		this.queryName = _qname;
		this.userIdx = _userIdx;
	}
	
	public QueryWait deepCopy(){
		QueryWait qw = new QueryWait(this.queryName, this.userIdx, this.map,this.type);
		return qw;
	}
	
	public boolean isOldUpdate(String queryName, int userIdx){
		if(this.queryName.equals(queryName) && this.userIdx == userIdx){
			return true;
		}
		return false;
	}
	
	private static void oldUpdateDelete(String queryName, int userIdx){
		for(Iterator<QueryWait> iter = SocketHandler.updateQueryList.iterator(); iter.hasNext(); ){
			QueryWait qw = iter.next();
			if(qw.isOldUpdate(queryName, userIdx)){
				iter.remove();
				
			}
		}
	}

	public static void pushQuery(String qname, int userIdx, EgovMap map, QueryType type){
		pushQuery(qname,userIdx,map,type,true);
	}
	
	public static void pushQuery(String qname, int userIdx, EgovMap map, QueryType type, boolean oldDelete){
		EgovMap in = new EgovMap();
		in.putAll(map); // 인자 map 이 push이후 요소가 바뀔 수 있기 때문에 깊은복사해서 추가해줌
		QueryWait qw = new QueryWait(qname, userIdx, in, type);

		if(type == QueryType.UPDATE){
			synchronized(SocketHandler.updateQueryList){
				if(oldDelete)
					oldUpdateDelete(qname,userIdx);
				SocketHandler.updateQueryList.add(qw);
			}
		}
		else{
			synchronized(SocketHandler.queryList){
				SocketHandler.queryList.add(qw);
			}
		}
	}
	
	public static boolean QueryStart(QueryWait qw){
		try {
			switch(qw.type){
			case SELECT:
				SocketHandler.sh.getSampleDAO().select(qw.queryName,qw.map);
				break;
			case UPDATE:
				SocketHandler.sh.getSampleDAO().update(qw.queryName,qw.map);
				break;
			case INSERT:
				SocketHandler.sh.getSampleDAO().insert(qw.queryName,qw.map);
				break;
			case DELETE:
				SocketHandler.sh.getSampleDAO().delete(qw.queryName,qw.map);
				break;
			}
			return true;
		} catch (Exception e) {
			Log.print("QueryStart err!! query name = "+qw.queryName+" map = "+qw.map+" type = "+qw.type, 1,"err");
			return false;
		}
	}
	
	public static boolean QueryListStart(LinkedList<QueryWait> querylist, String update){
		
		if(querylist.size() == 0) return true;
		
		Log.print("QueryListStart"+update+"!", 1 , "query");

		QueryWait [] tempList;

		synchronized (querylist) {
			tempList = new QueryWait[querylist.size()];
			for(int i = 0; i < querylist.size(); i++){
				tempList[i] = querylist.get(i).deepCopy();
			}
			querylist.clear();
		}
//		Log.print("QueryListStart"+update+" DeepCopy Complete, run start", 1 , "query");
		try {
			synchronized (SocketHandler.sh.getSampleDAO()) {
				SocketHandler.sh.getSampleDAO().getSqlMapClient().startBatch();
				
				for(QueryWait qw : tempList){
					switch(qw.type){
					case UPDATE:
						SocketHandler.sh.getSampleDAO().getSqlMapClient().update(qw.queryName,qw.map);
						break;
					case INSERT:
						SocketHandler.sh.getSampleDAO().getSqlMapClient().insert(qw.queryName,qw.map);
						break;
					case DELETE:
						SocketHandler.sh.getSampleDAO().getSqlMapClient().delete(qw.queryName,qw.map);
						break;
					case SELECT:
						break;
					default:
						break;
					}
				}
				SocketHandler.sh.getSampleDAO().getSqlMapClient().executeBatch();
				SocketHandler.sh.getSampleDAO().getSqlMapClient().endTransaction();
			}
			Log.print("QueryListStart"+update+" end! "+tempList.length+" 개 쿼리 수행", 1 , "query");
			return true;
		} catch (Exception e) {
			Log.print("QueryListStart"+update+" err!! "+e, 1 , "err");
			return false;
		}
	}
}
