package org.hee.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AttachDTO {

	private Integer boardNo;
	private String uploadPath;
	private String fname;
	private String uuid;
	private boolean image;

	public AttachDTO(String fname, String uploadPath, String uuid) {
		this(fname, false, uploadPath, uuid);
	}

	public AttachDTO(String fname, boolean image, String uploadPath, String uuid) {
		super();
		this.fname = fname;
		this.uuid = uuid;
		this.image = image;
		this.uploadPath = uploadPath;
	}
	

}
