package org.hee.domain;

import lombok.Data;

@Data
public class PagingDTO {
	
	private Integer bno;
	private int page;
	private int amount;
	private String type;
	private String keyword;
	
	public PagingDTO(){
		this(1, 10);
	}
	
	public PagingDTO(int page, int amount) {
		this.page = page;
		this.amount = amount;
	}
	
	public int getSkip() {
		
		return (page-1)*amount;
	}
	
	public String[] getTypes() {
		if(type==null||type.trim().length()==0) {
			
			return null;
		}
		return type.split("");
	}



}
