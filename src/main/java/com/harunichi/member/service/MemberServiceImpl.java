package com.harunichi.member.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.harunichi.board.vo.BoardVo;
import com.harunichi.member.dao.MemberDao;
import com.harunichi.member.vo.MemberVo;

@Service("memberService")
@Transactional
public class MemberServiceImpl implements MemberService{
	
	@Autowired
	private MemberDao memberDao;
	
	@Override
	public int insertMember(MemberVo memberVO) throws DataAccessException {
		
		return memberDao.insertMember(memberVO);
	}

	@Override
	public int updateMember(MemberVo memberVo) throws Exception {
		return memberDao.updateMember(memberVo);
	}
	
	//카카오 아이디로 회원 조회
	@Override
	public MemberVo selectMemberByKakaoId(String kakaoId) throws Exception {
		return memberDao.selectMemberByKakaoId(kakaoId);
	}
	
	//네이버 아이디로 회원 조회
	@Override
	public MemberVo selectMemberByNaverId(String naverId) throws Exception {
		return memberDao.selectMemberByNaverId(naverId);
	}

	//이메일 중복 체크 기능 (매개변수로 받은 이메일이 중복인지 아닌지를 판단)
	@Override
	public boolean isEmailDuplicate(String email) {
		return memberDao.selectMemberByEmail(email) != null;
	}

	//아이디 중복 체크 기능
	@Override
	public boolean checkId(String id) {
		//DB에서 이 id를 가진 회원이 1명 이상 존재하면 true, 없으면 false 반환
		return memberDao.checkId(id) > 0;
	}

	//아이디로 회원 정보 조회
	@Override
	public MemberVo selectMemberById(String id) {
		return memberDao.selectMemberById(id);
	}
	
	//전체 회원정보 조회
	@Override
	public Map<String, Object> getMemberList(String searchKeyword, String searchType, int page) {
	    int pageSize = 7;
	    int offset = (page - 1) * pageSize;

	    Map<String, Object> result = new HashMap<>();
	    result.put("list", memberDao.selectMemberList(searchKeyword, searchType, offset, pageSize));
	    result.put("totalCount", memberDao.selectMemberCount(searchKeyword, searchType));
	    result.put("currentPage", page);
	    result.put("pageSize", pageSize);

	    return result;
	}

	//회원 삭제 메소드
	@Override
	public void deleteMember(String id) {
		memberDao.deleteMember(id);
	}
	
	//어드민 - 프로필이미지초기화
	public void resetProfileImg(String id) throws Exception {
        memberDao.resetProfileImg(id);
    }
	
	@Override
	public List<Map<String, Object>> getGenderDistribution() {
	    return memberDao.selectGenderDistribution();
	}

	@Override
	public List<Map<String, Object>> getCountryDistribution() {
	    return memberDao.selectCountryDistribution();
	}
	
	//내가 좋아요한 게시글
	@Override
	public List<BoardVo> getMyLikedBoards(String memberId) {
	    return memberDao.selectMyLikedBoards(memberId);
	}
	
	//내가 쓴 게시글
	@Override
	public List<BoardVo> getMyBoards(String memberId) {
	    return memberDao.selectMyBoards(memberId);
	}

	@Override
	public List<Integer> getLikedBoardIds(String memberId) {
	    return memberDao.selectLikedBoardIds(memberId);
	}

	
	
}
