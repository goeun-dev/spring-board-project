package org.hee.mappertest;

import java.util.List;
import java.util.stream.IntStream;

import org.hee.domain.PagingDTO;
import org.hee.domain.ReplyVO;
import org.hee.mapper.ReplyMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class) 
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {

	
	@Autowired
	private ReplyMapper mapper;
	
	
	@Test
	public void updateTest() {
		
		ReplyVO vo = new ReplyVO();
		vo.setContent("댓글 수정");
		vo.setRno(268);
		log.info(mapper.update(vo));
	}
	
	
	@Test
	public void testList2() {
		PagingDTO dto = new PagingDTO(3,10);
		
		List<ReplyVO> replies = mapper.replySelect(882, dto);
		replies.forEach(reply-> log.info(reply));
	}
	
	
	@Test
	public void testInsert() {
//		IntStream.range(1, 2).forEach(i->{
			ReplyVO vo = new ReplyVO();
			vo.setBno(882);
			vo.setDepth(1);
			vo.setContent("댓글작성");
			vo.setWriter("ㅋㅋㅋ");
			log.info(mapper.insertReple(vo));
//		}
//		);
	}
	
	
}
