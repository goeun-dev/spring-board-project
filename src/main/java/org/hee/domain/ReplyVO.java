package org.hee.domain;

import java.util.Date;

import lombok.Data;
@Data
public class ReplyVO {

	private Integer rno;
	private Integer bno;
	private String content;
	private String writer;
	private Date regdate;
	private Integer groupno;
	private int depth;
	private int delchk;

}
