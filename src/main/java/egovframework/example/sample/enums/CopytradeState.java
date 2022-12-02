package egovframework.example.sample.enums;

public enum CopytradeState {
	RUN(0),SELFSTOP(1),LOSSCUT(2),PROFITCUT(3),NOMONEY(4),TRADER_RELEASE(5),SYMBOL_RELEASE(6),REQUEST(7),REJECT(8);
	
	private final int value;
    private CopytradeState(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
