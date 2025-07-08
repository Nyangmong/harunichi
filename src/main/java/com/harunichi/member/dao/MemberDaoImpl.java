package com.harunichi.member.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.harunichi.board.vo.BoardVo;
import com.harunichi.member.vo.MemberVo;

@Repository("memberDao")
public class MemberDaoImpl implements MemberDao {

	@Autowired
	private SqlSession sqlSession;
	
	//회원가입 기능
	@Override
	public int insertMember(MemberVo memberVO) throws DataAccessException {
		return sqlSession.insert("mapper.member.insertMember", memberVO);
		// insert 성공 시 : 반환값은 삽입된 row 수 (보통 1) , 실패 시 → 예외가 발생하거나 0
	}
	
	//아이디로 회원 정보 조회 기능
	@Override
	public MemberVo selectMemberById(String id) throws DataAccessException {
		MemberVo memberVo = sqlSession.selectOne("mapper.member.selectMemberById", id);
		return memberVo; // DB에서 가져온 MemberVo 객체 돌려주기
	}
	
	// 이메일로 회원 조회
	@Override
	public MemberVo selectMemberByEmail(String email) throws DataAccessException {
		return sqlSession.selectOne("mapper.member.selectMemberByEmail", email);
	}

	//(카카오아이디) DB에 이미 가입된 회원인지 확인하는 메서드
	@Override
	public MemberVo selectMemberByKakaoId(String kakaoId) throws DataAccessException {
		 // sqlSession.selectOne() 메서드를 사용하여 DB에서 kakaoId로 회원 정보 조회
        MemberVo memberVo = sqlSession.selectOne("mapper.member.selectMemberByKakaoId", kakaoId);
        return memberVo;
	}
	
	//(네이버아이디) DB에 이미 가입된 회원인지 확인하는 메서드
	@Override
	public MemberVo selectMemberByNaverId(String naverId) throws DataAccessException {
        MemberVo memberVo = sqlSession.selectOne("mapper.member.selectMemberByNaverId", naverId);
        return memberVo;
	}

	//회원 정보 수정 기능
	@Override
	public int updateMember(MemberVo memberVO) throws DataAccessException {
		int result = sqlSession.update("mapper.member.updateMember", memberVO);
		return result;
	}
	
	//아이디 중복 체크
	@Override
	public int checkId(String id) {
		return sqlSession.selectOne("mapper.member.countById", id);
	}
	
	//아이디 중복 체크
	@Override
	public List<MemberVo> selectMemberList(String searchKeyword, String searchType, int offset, int pageSize) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("searchKeyword", searchKeyword);
	    params.put("searchType", searchType);
	    params.put("offset", offset);
	    params.put("pageSize", pageSize);
	    return sqlSession.selectList("mapper.member.selectMemberList", params);
	}

	@Override
	public int selectMemberCount(String searchKeyword, String searchType) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("searchKeyword", searchKeyword);
	    params.put("searchType", searchType);
	    return sqlSession.selectOne("mapper.member.selectMemberCount", params);
	}

	//회원삭제
	@Override
	public void deleteMember(String id) {
		sqlSession.delete("mapper.member.deleteMember", id);
		
	}
	
	//어드민 - 이미지초기화
	@Override
	public void resetProfileImg(String id) {
	    sqlSession.update("mapper.member.resetProfileImg", id);
	}
	
	@Override
	public List<Map<String, Object>> selectGenderDistribution() {
	    return sqlSession.selectList("mapper.member.selectGenderDistribution");
	}

	@Override
	public List<Map<String, Object>> selectCountryDistribution() {
	    return sqlSession.selectList("mapper.member.selectCountryDistribution");
	}
	
	//내가 좋아요한 게시글
	@Override
	public List<BoardVo> selectMyLikedBoards(String memberId) {
	    return sqlSession.selectList("mapper.member.selectMyLikedBoards", memberId);
	}
	
	//내가 쓴 게시글
	@Override
	public List<BoardVo> selectMyBoards(String memberId) {
	    return sqlSession.selectList("mapper.member.selectMyBoards", memberId);
	}

	@Override
    public List<Integer> selectLikedBoardIds(String memberId) {
        return sqlSession.selectList("mapper.member.selectLikedBoardIds", memberId);
    }

	
	
}
