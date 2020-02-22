package org.hee.servicetest;

import java.util.ArrayList;
import java.util.List;

import org.hee.domain.AttachDTO;
import org.hee.domain.BoardVO;
import org.hee.domain.ReplyVO;
import org.hee.service.BoardService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class) 
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {

	@Autowired
	private BoardService service;
	
	@Test
	public void testFile () {
		BoardVO vo = new BoardVO();
		vo.setTitle("제목?");
		vo.setContent("내용");
		vo.setWriter("작성자");
		
		List<AttachDTO> list = new ArrayList<>();
		AttachDTO dto = new AttachDTO("한글.jpg", "C:\\upload\\", "0b794454-0633-447a-85b2-d98d77df3bab_한글.jpg");
		list.add(dto);
		
		log.info(list);
		log.info(dto);
		vo.setAttachList(list);
		
		service.register(vo);

			
	}
	
	@Test
	public void testbno() {
		log.info(service.findByBno(210));
	}
	
	@Test
	public void testList() {
//		log.info(service.getList());
	}
	
	@Test
	public void testRegister() {
//		log.info(service);
		
		BoardVO vo = new BoardVO();
		vo.setTitle("안녕");
		vo.setContent("내용");
		vo.setWriter("아프로디테");
		
		service.register(vo);
	}
	@Test
	public void repleTests() {
		//log.info(service.replySelect(1));
	}
	@Test 
	public void rpletest() {
		ReplyVO vo= new ReplyVO();
		
		vo.setBno(31);
		//vo.setRno(1);
		vo.setContent("content");
		vo.setWriter("writer");
		//service.insertReple(vo);
	}
	
}
