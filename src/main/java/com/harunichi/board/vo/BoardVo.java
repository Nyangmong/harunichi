package com.harunichi.board.vo;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class BoardVo {
	private int boardId;
	private String boardWriter;
	private String boardCont;
	private Timestamp boardDate;
	private Timestamp boardModDate;
	private int boardLike;
	private int boardCount;
	private int boardRe;
	private String boardCate;
	private String boardImg1;
	private String boardImg2;
	private String boardImg3;
	private String boardImg4;
	private String boardWriterImg;
	private String boardWriterId;

	// 이미지를 List<String> 형태로 반환하는 메서드 추가
	public List<String> getImageFiles() {
		List<String> imageFiles = new ArrayList<>();
		if (this.boardImg1 != null && !this.boardImg1.isEmpty()) {
			imageFiles.add(this.boardImg1);
		}
		if (this.boardImg2 != null && !this.boardImg2.isEmpty()) {
			imageFiles.add(this.boardImg2);
		}
		if (this.boardImg3 != null && !this.boardImg3.isEmpty()) {
			imageFiles.add(this.boardImg3);
		}
		if (this.boardImg4 != null && !this.boardImg4.isEmpty()) {
			imageFiles.add(this.boardImg4);
		}
		return imageFiles;
	}
}