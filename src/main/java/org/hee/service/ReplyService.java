package org.hee.service;

import java.util.List;

import org.hee.domain.PagingDTO;
import org.hee.domain.ReplyPageDTO;
import org.hee.domain.ReplyVO;

public interface ReplyService {
	public boolean insertReple(ReplyVO vo);

	public boolean insertReReple(ReplyVO vo);

	public List<ReplyVO> replySelect(Integer bno, PagingDTO dto);

	public int replyCount(Integer bno);

	public ReplyPageDTO getListPage(PagingDTO dto, Integer bno);

	public int remove(Integer rno);

	public boolean update(ReplyVO vo);

	public int updateDelChk(Integer rno);

}
