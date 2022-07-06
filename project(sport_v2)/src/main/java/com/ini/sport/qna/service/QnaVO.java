package com.ini.sport.qna.service;

public class QnaVO {

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
	private String userId;
	/* 게시물 제목 */
	private String qTitleNm;
	/* 게시물 내용 */
	private String qCtt;
	/* 게시물 공지여부 */
	private String qNtcYn;
	/* 게시물 조회수 */
	private String qClkCnt;

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

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getqTitleNm() {
		return qTitleNm;
	}

	public void setqTitleNm(String qTitleNm) {
		this.qTitleNm = qTitleNm;
	}

	public String getqCtt() {
		return qCtt;
	}

	public void setqCtt(String qCtt) {
		this.qCtt = qCtt;
	}

	public String getqNtcYn() {
		return qNtcYn;
	}

	public void setqNtcYn(String qNtcYn) {
		this.qNtcYn = qNtcYn;
	}

	public String getqClkCnt() {
		return qClkCnt;
	}

	public void setqClkCnt(String qClkCnt) {
		this.qClkCnt = qClkCnt;
	}
}
