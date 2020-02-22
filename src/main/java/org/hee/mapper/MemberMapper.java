package org.hee.mapper;

import org.hee.domain.AuthVO;
import org.hee.domain.MemberVO;

public interface MemberMapper {
	
	public MemberVO read(String userid);
	
	public int insertMember(MemberVO vo);
	
	public int insertAuth(AuthVO vo);

}
