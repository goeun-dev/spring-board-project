package org.hee.service;

import java.util.List;

import org.hee.domain.BoardVO;
import org.hee.domain.PagingDTO;

public interface BoardService {
	
	public void register(BoardVO vo);
	
	public List<BoardVO> getList(PagingDTO dto);
	
	public BoardVO findByBno(Integer bno);
	
	public boolean delete(Integer bno);
	
	public void update(BoardVO vo);
	
	public int getCount(PagingDTO dto);
	
	public boolean deleteFile(String uuid);
	
}
