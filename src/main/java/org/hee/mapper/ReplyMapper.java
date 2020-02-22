package org.hee.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.hee.domain.PagingDTO;
import org.hee.domain.ReplyVO;

public interface ReplyMapper {

	public int insertReple(ReplyVO vo);

	public int insertReReple(ReplyVO vo);

	public List<ReplyVO> replySelect(@Param("bno")Integer bno, @Param("dto")PagingDTO dto);

	public int replyCount(Integer bno);

	public int delete(int rno);

	public int update(ReplyVO vo);

	public int getReply(Integer rno);

	public int updateGroupno();

	public int updateDelChk(Integer rno);
}
