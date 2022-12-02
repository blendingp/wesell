package egovframework.example.sample.enums;

public enum TPSLType {
	TP(0),SL(1);
	private final int value;
    private TPSLType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
