package org.hee.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.hee.domain.AttachDTO;
import org.hee.domain.BoardVO;
import org.hee.domain.PageMaker;
import org.hee.domain.PagingDTO;
import org.hee.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@RequestMapping("/board/*")
@Log4j
public class BoardController {

	@Setter(onMethod_ = @Autowired)
	private BoardService service;

	@GetMapping("/list")
	public void listGET(Model model, PagingDTO dto) {

		log.info("list get----------------------------" + dto);

		PageMaker pm = new PageMaker(service.getCount(dto), dto);
		log.info("PageMaker: " + pm);

		model.addAttribute("list", service.getList(dto));
		model.addAttribute("pm", pm);
	}

	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void registerGET(@ModelAttribute("dto") PagingDTO dto) {
		log.info("register get----------------------------");
	}

	@GetMapping(value = "/viewFile")
	@ResponseBody
	public ResponseEntity<byte[]> viewFile(String fileName) {
		log.info("viewFile----------------------------");
		log.info("fileName: " + fileName);

		File file = new File("C:\\upload\\" + fileName);

		log.info("file: " + file);

		ResponseEntity<byte[]> result = null;

		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	private boolean checkImageType(File file) {
		try {

			log.info("checkImageType----------------------------");

			log.info("File: " + file);
			String contentType = Files.probeContentType(file.toPath());

			log.info("contentType: " + contentType);

			return contentType.startsWith("image");

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/upload", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachDTO>> uploadPOST(MultipartFile[] uploadFile) {
		log.info("uploadPOST----------------------------");

		String uploadFolder = "C:\\upload";

		List<AttachDTO> attachList = new ArrayList<>();

		for (MultipartFile multipartFile : uploadFile) {
			log.info("FileName: " + multipartFile.getOriginalFilename());
			log.info("FileSize: " + multipartFile.getSize());

			String uploadFileName = multipartFile.getOriginalFilename();
			UUID uuid = UUID.randomUUID();

			String saveFileName = uuid.toString() + "_" + uploadFileName;

			try {
				File saveFile = new File(uploadFolder, saveFileName);
				multipartFile.transferTo(saveFile);

				boolean isImage = checkImageType(saveFile);
				log.info("isImage: " + isImage);

				if (isImage) {
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadFolder, "s_" + saveFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}

				AttachDTO fileInfo = new AttachDTO(uploadFileName, isImage, uploadFolder + "\\", saveFileName);

				log.info("upload file info: " + fileInfo);
				attachList.add(fileInfo);

			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		return new ResponseEntity<List<AttachDTO>>(attachList, HttpStatus.OK);
	}

	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		log.info("deleteFile----------------------------");

		log.info("delete File Name: " + fileName);
		log.info("type: " + type);

		File file;

		try {
			log.info("decode: " + URLDecoder.decode(fileName, "UTF-8"));
			file = new File(URLDecoder.decode(fileName, "UTF-8"));

			if (file.delete()) {
				log.info("delete success");
			} else {
				log.info("delete fail");
			}

			if (type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_", "");

				log.info("largeFileName" + largeFileName);

				file = new File(largeFileName);
				log.info("-------------------------" + file.toString());

				if (file.delete()) {
					log.info("delete success");
				} else {
					log.info("delete fail");
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}

	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String registerPOST(BoardVO vo) {
		log.info("registerPOST----------------------------");

		if (vo.getAttachList() != null) {
			vo.getAttachList().forEach(attach -> log.info(attach));
		}

		log.info("BoardVO: " + vo);
		service.register(vo);

		return "redirect:/board/list";
	}

	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<byte[]> downloadFile(String fname) {
		log.info("downloadFile----------------------------");

		log.info("fname ============================== " + fname);
		File file = new File("C:\\upload", fname);
		log.info("==================================>" + file.toString());

		HttpHeaders header = new HttpHeaders();
		try {

			header.add("Content-Disposition",
					"attachment; filename=" + new String(fname.getBytes("UTF-8"), "ISO-8859-1"));

			byte[] data = FileCopyUtils.copyToByteArray(file);
			
			return new ResponseEntity<byte[]>(data, header, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	@GetMapping("/read")
	public void read(@ModelAttribute("dto") PagingDTO dto, Model model) {
		log.info("read----------------------------");
		
		model.addAttribute("board", service.findByBno(dto.getBno()));
	}

	@PreAuthorize("principal.username == #writer")
	@PostMapping("/delete")
	public String deletePOST(Integer bno) {
		log.info("deletePOST----------------------------");
		log.info("delete: " + service.delete(bno));

		return "redirect:/board/list";
	}

	@GetMapping("/update")
	public void updateGET(Integer bno, Model model) {
		log.info("updateGET----------------------------");
		model.addAttribute("board", service.findByBno(bno));

	}

	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/update")
	public String updatePOST(BoardVO vo, String[] uuids) {
		log.info("updatePOST----------------------------");
		// 파일정보 + 본문내용
		log.info(vo);
		// 삭제할 파일
		if (uuids != null) {
			for (int i = 0; i < uuids.length; i++) {
				log.info("uuids ====================================>" + uuids[i]);
				service.deleteFile(uuids[i]);
			}
		}

		int bno = vo.getBno();
		// 글 업데이트 // 새 파일 있을 때
		// log.info(service.update(vo));
		service.update(vo);

		return "redirect:/board/read?bno=" + bno;
	}

}
