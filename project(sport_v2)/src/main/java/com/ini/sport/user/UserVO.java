package com.ini.sport.user;

public class UserVO {

	/* SEQ */
	private String seq;
	/* 등록일 */
	private String rgstDt;
	/* 등록자 */
	private String rgstId;
	/* 수정일 */
	private String rvseDt;
	/* 수정자 */
	private String rvseId;
	/* 사용여부 */
	private String useYn;
	/* ID */
	private String uId;
	/* 비밀번호 */
	private String uPw;
	/* 이름 */
	private String uNm;
	/* 주소 */
	private String uAddr;
	/* 상세주소 */
	private String uDtlsAddr;
	/* 전화번호 */
	private String uTel;
	/* 나이스 본인인증 키 */
	private String uCertKeyEncVal;

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getRgstDt() {
		return rgstDt;
	}

	public void setRgstDt(String rgstDt) {
		this.rgstDt = rgstDt;
	}

	public String getRgstId() {
		return rgstId;
	}

	public void setRgstId(String rgstId) {
		this.rgstId = rgstId;
	}

	public String getRvseDt() {
		return rvseDt;
	}

	public void setRvseDt(String rvseDt) {
		this.rvseDt = rvseDt;
	}

	public String getRvseId() {
		return rvseId;
	}

	public void setRvseId(String rvseId) {
		this.rvseId = rvseId;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getuId() {
		return uId;
	}

	public void setuId(String uId) {
		this.uId = uId;
	}

	public String getuPw() {
		return uPw;
	}

	public void setuPw(String uPw) {
		this.uPw = uPw;
	}

	public String getuNm() {
		return uNm;
	}

	public void setuNm(String uNm) {
		this.uNm = uNm;
	}

	public String getuAddr() {
		return uAddr;
	}

	public void setuAddr(String uAddr) {
		this.uAddr = uAddr;
	}

	public String getuDtlsAddr() {
		return uDtlsAddr;
	}

	public void setuDtlsAddr(String uDtlsAddr) {
		this.uDtlsAddr = uDtlsAddr;
	}

	public String getuTel() {
		return uTel;
	}

	public void setuTel(String uTel) {
		this.uTel = uTel;
	}

	public String getuCertKeyEncVal() {
		return uCertKeyEncVal;
	}

	public void setuCertKeyEncVal(String uCertKeyEncVal) {
		this.uCertKeyEncVal = uCertKeyEncVal;
	}
}
