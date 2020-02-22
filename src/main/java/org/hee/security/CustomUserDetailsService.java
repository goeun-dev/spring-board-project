
package org.hee.security;

import org.hee.domain.MemberVO;
import org.hee.mapper.MemberMapper;
import org.hee.security.domain.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {

	@Setter(onMethod_ = { @Autowired })
	private MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String userid) throws UsernameNotFoundException {
		MemberVO vo = memberMapper.read(userid);
		log.warn("Load User By UserName : " + userid);

		return vo == null ? null : new CustomUser(vo);
	}
}
