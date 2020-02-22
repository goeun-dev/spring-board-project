package org.hee.service;

import java.util.List;

import org.hee.domain.BoardVO;
import org.hee.domain.PagingDTO;
import org.hee.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;

	@Override
	@Transactional
	public void register(BoardVO vo) {
		log.info("service vo: " + vo);
		mapper.insert(vo);

		if (vo.getAttachList() != null) {

			vo.getAttachList().forEach(attach -> {

				mapper.fileInsert(attach);
			});
		}

	}

	@Override
	public List<BoardVO> getList(PagingDTO dto) {
		log.info(mapper.getList(dto));
		return mapper.getList(dto);
	}

	@Override
	public BoardVO findByBno(Integer bno) {
		log.info(bno);
		return mapper.selectOne(bno);
	}

	@Override
	public boolean delete(Integer bno) {
		log.info("delete: " + bno);
		return mapper.delete(bno) == 1 ? true : false;
	}

	@Transactional
	@Override
	public void update(BoardVO vo) {
		mapper.update(vo);
		log.info("update: " + vo);

		if (vo.getAttachList() != null) {

			vo.getAttachList().forEach(attach -> {
				attach.setBoardNo(vo.getBno());
				mapper.fileUpdate(attach);
			});
		}

	}

	@Override
	public int getCount(PagingDTO dto) {
		log.info(mapper.getCount(dto));
		return mapper.getCount(dto);
	}

	@Override
	public boolean deleteFile(String uuid) {
		log.info(uuid);
		return mapper.fileDelete(uuid) == 1 ? true : false;
	}


}
