package egovframework.example.sample.enums;

public enum CopytraderInfo {
	TOTAL(0,"최대팔로우인원"),
	WRITE_FOLLOWER(1,"팔로워 작성"),
	WRITE_F_RELEASE(2,"팔로워 작성 해제"),
	WRITE_INFO(3,"정보 작성"),
	WRITE_I_RELEASE(4,"정보 작성 해제"),
	DELETE_TRADER(5,"트레이더 삭제");
	
	private final int value;
	private final String kind;
    private CopytraderInfo(int value,String kind) {
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
