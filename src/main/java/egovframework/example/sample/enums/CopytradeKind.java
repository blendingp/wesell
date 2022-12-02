package egovframework.example.sample.enums;

public enum CopytradeKind {
	BUY(0),SELL(1),LOSSCUT(2),PROFITCUT(3),LIQ(4);
	
	private final int value;
    private CopytradeKind(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
