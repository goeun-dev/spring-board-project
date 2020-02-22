package org.hee.controller;

import org.hee.domain.PagingDTO;
import org.hee.domain.ReplyPageDTO;
import org.hee.domain.ReplyVO;
import org.hee.service.ReplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RequestMapping("/reply/*")
@Log4j
@RestController
public class ReplyController {

	@Setter(onMethod_ = @Autowired)
	private ReplyService service;

	// list
	@GetMapping(value = "/list/{bno}/{page}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<ReplyPageDTO> replyList(@PathVariable("page") int page, @PathVariable("bno") Integer bno,
			Model model) {
		log.info("bno: " + bno);
		
		PagingDTO dto = new PagingDTO(page, 10);
		
		log.info("reply list: " + service.replySelect(bno, dto));
		model.addAttribute("reply", service.replySelect(bno, dto));

		return new ResponseEntity<>(service.getListPage(dto, bno), HttpStatus.OK);
	}

	// insert
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/reply", consumes = "application/json ", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> replePost(@RequestBody ReplyVO vo) {
		log.info("Reply Info: " + vo);
		
		boolean insertSuccess = false;
		
		// depth: 0 - 원댓글 작성 시
		if (vo.getDepth() == 0) {
			insertSuccess = service.insertReple(vo);
			
		// 답댓글 작성 시
		} else {
			insertSuccess = service.insertReReple(vo);
		}
		
		log.info(insertSuccess);

		return insertSuccess == true ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@PreAuthorize("principal.username == #vo.writer")
	@DeleteMapping(value = "/{rno}")
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Integer rno) {
		log.info("remove: " + rno);

		int count = -1;
		ResponseEntity<String> result = null;
		try {

			count = service.updateDelChk(rno);

			System.out.println("-----------------------------" + count);

			if (count == 1) {
				result = new ResponseEntity<>("success", HttpStatus.OK);
			} else {
				result = new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
			}

		} catch (Exception e) {

			e.printStackTrace();
		}
		return result;
	}

	@PreAuthorize("principal.username == #vo.writer")
	@RequestMapping(method = { RequestMethod.PUT,
			RequestMethod.PATCH }, value = "/{rno}", consumes = "application/json ")
	public ResponseEntity<String> update(@PathVariable("rno") Integer rno, @RequestBody ReplyVO vo) {

		boolean update = service.update(vo);

		return update == true ? new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}

}
