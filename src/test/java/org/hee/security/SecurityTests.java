package org.hee.security;

import java.util.stream.IntStream;

import org.hee.domain.AuthVO;
import org.hee.domain.MemberVO;
import org.hee.mapper.MemberMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)

@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/security-context.xml",
		"file:src/main/webapp/WEB-INF/spring/root-context.xml " })
@Log4j
public class SecurityTests {

	@Autowired
	private BCryptPasswordEncoder encoder;
	@Autowired
	private MemberMapper memberMapper;

	@Test
	public void testDummyMember() {

		IntStream.range(1, 101).forEach(i -> {
			MemberVO vo = new MemberVO();
			if (i < 90) {
				vo.setUserid("user" + i);
				vo.setUserpw(encoder.encode("user" + i));
				vo.setUsername("회원" + i);

			} else {
				vo.setUserid("admin" + i);
				vo.setUserpw(encoder.encode("admin" + i));
				vo.setUsername("관리자" + i);
			}
			memberMapper.insertMember(vo);
		});
	}

	@Test
	public void testInsertMemberRole() {

		IntStream.range(1, 101).forEach(i -> {
			AuthVO vo = new AuthVO();
			if (i < 90) {
//				vo.setUserid("user" +i);
//				vo.setAuthority("ROLE_MEMBER");

			} else {
				vo.setUserid("admin" + i);
				vo.setAuthority("ROLE_ADMIN");
				memberMapper.insertAuth(vo);
			}
//			memberMapper.insertAuth(vo);
		});
	}

	@Test
	public void test2() {
		String text = "$2a$10$ugxnbn6uQsweYBqUVYiJ7.udSMdEa7aYPBvZgIp7inLrxdcm7WFWm";

		boolean result = encoder.matches("abcde", text);

		log.info(result);

	}

	@Test
	public void test1() {

		log.info(encoder);

		String text = "abcde";

		String en1 = encoder.encode(text);

		log.info(en1);

		String en2 = encoder.encode(text);

		log.info(en2);

	}

	@Test
	public void TestRead() {

		MemberVO vo = memberMapper.read("admin95");

		log.info(vo);

		vo.getAuthList().forEach(authVO -> log.info(authVO));

	}
}
