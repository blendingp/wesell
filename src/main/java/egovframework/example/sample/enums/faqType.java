package egovframework.example.sample.enums;

public enum faqType {
	AUTH(0,"인증 및 보안"),REG(1,"계정 등록 및 닫기"),SERVICE(2,"서비스 이용"),PERSONAL(3,"개인 정보"),DEPOSIT(4,"입출금");
	private final int value;
	private final String name;
    private faqType(int value, String name) {
        this.value = value;
        this.name = name;
    }

    public int getValue() {
        return value;
    }
    
    public String getName(){
    	return name;
    }
}
