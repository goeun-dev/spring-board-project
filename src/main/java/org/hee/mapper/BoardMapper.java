package org.hee.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.hee.domain.AttachDTO;
import org.hee.domain.BoardVO;
import org.hee.domain.PagingDTO;

public interface BoardMapper {

	public int insert(BoardVO vo);

	public List<BoardVO> getList(PagingDTO dto);

	public BoardVO selectOne(Integer bno);

	public int delete(Integer bno);

	public int update(BoardVO vo);

	public int getCount(PagingDTO dto);

	public int fileInsert(AttachDTO dto);

	public int fileDelete(String uuid);

	public int fileUpdate(AttachDTO dto);

	public int updateReplyCnt(@Param("bno")Integer bno, @Param("amount") int amount);

}
