package org.hee.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PageMaker {

	int total;
	boolean prev, next;
	int start, end;
	PagingDTO dto;
	public PageMaker(int total, PagingDTO dto){
		this.total = total;
		this.dto = dto;
		
		int tempEnd = (int)Math.ceil((dto.getPage()/10.0))*10;
		this.start = tempEnd - 9;
		this.prev = start!=1;
		int realEnd = (int)Math.ceil(total/(double)dto.getAmount());
		this.end = tempEnd > realEnd?realEnd:tempEnd;
		this.next = this.end * dto.getAmount() < total;
		
	}
	public static void main(String[] args) {
		PagingDTO dto = new PagingDTO();
		dto.setPage(22);
		dto.setAmount(10);
		PageMaker pm = new PageMaker(213,dto);
		System.out.println(pm);
	}
	
}
