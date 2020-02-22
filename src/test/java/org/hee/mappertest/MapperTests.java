package org.hee.mappertest;

import java.util.stream.IntStream;

import org.hee.domain.BoardVO;
import org.hee.domain.PagingDTO;
import org.hee.domain.ReplyVO;
import org.hee.mapper.BoardMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class) 
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class MapperTests {

	@Autowired
	private BoardMapper mapper;
	
	@Test
	public void testselectOne() {
		
		log.info(mapper.selectOne(338));
	}
	
	@Test
	public void testList() {
//		log.info(mapper.getList());
	}
	
	
	@Test
	public void testKeyword() {
		PagingDTO dto = new PagingDTO();
		dto.setType("TCW");
		dto.setKeyword("술");
		log.info(mapper.getList(dto));
	}
	
	
	@Test
	public void test() {
		log.info(mapper);
		IntStream.range(1,101).forEach(i->{
			BoardVO vo = new BoardVO();
			vo.setTitle("제목입니다"+i);
			vo.setContent("내용입니다"+i);
			vo.setWriter("글쓴이"+i);
			log.info(mapper.insert(vo));
		});
		
		
	}
	@Test 
	public void replytest() {
		ReplyVO vo= new ReplyVO();
		
		vo.setBno(1);
		//vo.setRno(1);
		vo.setContent("댓글입니다~");
		vo.setWriter("작성자");
		//mapper.insertReple(vo);
	}
	
	@Test
	public void replyTests() {
//		log.info(mapper.replySelect(1));
	}
	
}
