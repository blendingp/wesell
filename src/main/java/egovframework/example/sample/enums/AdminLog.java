package egovframework.example.sample.enums;

public enum AdminLog {
	INSERT_TESTUSER(0,"테스트유저생성"),
	INSERT_TESTCHONG(1,"테스트총판생성"),
	INSERT_USER(2,"유저생성"),
	INSERT_CHONG(3,"총판생성"),
	INSERT_NOTICE(4,"공지사항"),
	INSERT_FAQ(5,"FAQ"),
	INSERT_EVENT(6,"팝업 공지사항"),
	CONTACT_ANSWER(7,"문의답변"),
	CONTACT(8,"문의처리"),
	UPDATE_JSTAT(9,"가입 승인"),
	UPDATE_USER(10,"유저 정보 변경"),
	GIVEUSDT(11,"USDT 지급"),
	BLOCK_IP(12,"IP차단"),
	BLOCK_USER(13,"유저차단"),
	UPDATE_KYC(14,"KYC"),
	SET_TRADER(15,"카피트레이더 승인"),
	UPDATE_TRADERINFO(16,"카피트레이더 정보수정"),
	UPDATE_WFEE(17,"출금수수료변경"),
	DEPOSIT(18,"입금"),
	CANCLE_DEPOSIT(19,"입금취소"),
	WITHDRAW(20,"출금"),
	UPDATE_DFEE(21,"입금수수료변경"),
	ADMINPHONE(22,"관리자 휴대폰"),
	P2P_DEPOSIT(23,"P2P입금"),
	P2P_WITHDRAW(24,"P2P출금"),
	REFERRAL(25,"레퍼럴지급"),
	UPDATE_POINT(26,"포인트 지급"),
	SEND_MESSAGE(27,"쪽지 보내기"),
	PENDING(28,"입출금 대기"),
	VCONFIRM(29,"가상계좌 승인");
	
	private final int value;
	private final String kind;
    private AdminLog(int value,String kind) {
        this.value = value;
        this.kind = kind;
    }

    public int getValue() {
        return value;
    }
    public String getKind() {
    	return kind;
    }
    
    public String getAction(int action){
    	String str = "";
    	switch(this){
    	case INSERT_TESTUSER:
    	case INSERT_TESTCHONG:
    	case INSERT_USER:
    		str = "생성";
    		break;
    	case INSERT_EVENT:
    	case INSERT_NOTICE:
    	case INSERT_FAQ:
    		if(action==0) str = "삭제";
			else str = "작성";
    		break;
    	case CONTACT_ANSWER:
    		str = "답변";
    		break;
    	case CONTACT:
    		if(action==0) str = "삭제";
			else str = "처리";
    		break;
    	case BLOCK_IP:
    	case BLOCK_USER:
    		if(action==0) str = "해제";
			else str = "차단";
    		break;
    	case UPDATE_USER:
    	case UPDATE_TRADERINFO:
    	case UPDATE_WFEE:
    	case UPDATE_DFEE:
    		str = "설정";
    		break;
    	case ADMINPHONE:
    		if(action==0) str = "삭제";
			else str = "등록";
    		break;
    	case REFERRAL:
    	case UPDATE_POINT:
    	case GIVEUSDT:
    		str = "지급";
    		break;
		default:
			if(action==0) str = "미승인";
			else str = "승인";
    	}
    	return str;
    }
}
