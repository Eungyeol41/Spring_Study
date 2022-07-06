package com.ini.sport.list.service;

public class ListVO {
	/* SEQ */
	private String seq;
	/* 체육시설 코드 */
	private String facCd;
	/* 체육시설명 */
	private String facNm;
	/* 체육시설 전화번호 */
	private String facTel;
	/* 체육시설 주소 */
	private String facAddr;
	/* 체육시설 이용료 */
	private String facMoney;
	/* 체육시설 종목 */
	private String facSport;

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getFacCd() {
		return facCd;
	}

	public void setFacCd(String facCd) {
		this.facCd = facCd;
	}

	public String getFacNm() {
		return facNm;
	}

	public void setFacNm(String facNm) {
		this.facNm = facNm;
	}

	public String getFacTel() {
		return facTel;
	}

	public void setFacTel(String facTel) {
		this.facTel = facTel;
	}

	public String getFacAddr() {
		return facAddr;
	}

	public void setFacAddr(String facAddr) {
		this.facAddr = facAddr;
	}

	public String getFacMoney() {
		return facMoney;
	}

	public void setFacMoney(String facMoney) {
		this.facMoney = facMoney;
	}

	public String getFacSport() {
		return facSport;
	}

	public void setFacSport(String facSport) {
		this.facSport = facSport;
	}
}
