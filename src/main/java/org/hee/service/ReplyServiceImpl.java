package org.hee.service;

import java.util.List;

import org.hee.domain.PagingDTO;
import org.hee.domain.ReplyPageDTO;
import org.hee.domain.ReplyVO;
import org.hee.mapper.BoardMapper;
import org.hee.mapper.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class ReplyServiceImpl implements ReplyService{

	@Setter(onMethod_ = @Autowired )
	private ReplyMapper mapper;

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;

	@Transactional
	@Override
	public boolean insertReple(ReplyVO vo) {
		log.info(vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1);

		int result = mapper.insertReple(vo);
		mapper.updateGroupno();
		return result == 1 ? true : false;
	}

	@Override
	public List<ReplyVO> replySelect(Integer bno, PagingDTO dto) {
		log.info(bno);
		return mapper.replySelect(bno, dto);
	}

	@Override
	public int replyCount(Integer bno) {
		log.info(bno);
		return mapper.replyCount(bno);
	}


	  @Override public ReplyPageDTO getListPage(PagingDTO dto, Integer bno) {
	  log.info("dto : "+ dto+", "+"bno : "+bno);
	  	return new ReplyPageDTO(mapper.replyCount(bno),mapper.replySelect(bno, dto));
	  }

	@Override
	public int remove(Integer rno) {
		log.info("rno: " +  rno);

		// 댓글 번호로 Reply 객체 생성해서 글번호 가져옴
		int bno = mapper.getReply(rno);
		// 댓글 개수 1 감소
		boardMapper.updateReplyCnt(bno, -1);

		return mapper.delete(rno);
	}

	@Override
	public boolean update(ReplyVO vo) {
		log.info("vo : "+vo);
		return mapper.update(vo)==1?true:false;
	}

	@Override
	public boolean insertReReple(ReplyVO vo) {
		log.info(vo);
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insertReReple(vo) == 1 ? true : false;
	}

	@Override
	public int updateDelChk(Integer rno) {
		// 댓글 번호로 Reply 객체 생성해서 글번호 가져옴
		int bno = mapper.getReply(rno);
		// 댓글 개수 1 감소
		boardMapper.updateReplyCnt(bno, -1);
		return mapper.updateDelChk(rno);
	}


}
