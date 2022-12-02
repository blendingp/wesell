package egovframework.example.sample.enums;

public enum MemberInfo {
	NAME(0,"이름"),
	INVITECODE(1,"초대코드"),
	PHONE(3,"연락처"),
	ID(4,"아이디"),
	PW(5,"비밀번호"),
	EMAIL(6,"이메일"),
	RATE(7,"수수료비율"),
	POINT(8,"포인트"),
	MEMO(9,"회원메모"),
	WALLETADDRESS(10,"지갑주소"),
	PARENT(11,"상위 총판"),
	LEVELUP(12,"총판 승급"),
	DELETE(13,"삭제"),
	MNAME(21,"예금주"),
	ACCOUNT(22,"계좌"),
	VACCOUNT(23,"가상 계좌");
	
	private final int value;
	private final String kind;
    private MemberInfo(int value,String kind) {
        this.value = value;
        this.kind = kind;
    }

    public int getValue() {
        return value;
    }
    public String getKind() {
    	return kind;
    }
}
