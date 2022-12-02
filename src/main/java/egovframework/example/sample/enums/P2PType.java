package egovframework.example.sample.enums;

public enum P2PType {
	BUY(0),SELL(1);
	private final int value;
    private P2PType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
