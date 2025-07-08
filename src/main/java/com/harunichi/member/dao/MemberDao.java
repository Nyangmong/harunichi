package com.harunichi.member.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.harunichi.board.vo.BoardVo;
import com.harunichi.member.vo.MemberVo;

//memeber 작업 dao 인터페이스
public interface MemberDao {
	
	//회원가입 기능 : 새로운 정보가 담긴 MemberVo객체를 받아서 DB에 저장
	public int insertMember(MemberVo memberVO) throws DataAccessException;
	
	//아이디로 회원 정보 조회 기능 : 특정아이디에 해당하는 회원 정보를 Membervo객체로 가져옴
	public MemberVo selectMemberById(String id) throws DataAccessException;
	
	// 이메일로 회원 조회
	public MemberVo selectMemberByEmail(String email) throws DataAccessException;
	
	//(카카오아이디) DB에 이미 가입된 회원인지 확인하는 메서드
	public MemberVo selectMemberByKakaoId(String kakaoId) throws DataAccessException;
	
	//(네이버아이디) DB에 이미 가입된 회원인지 확인하는 메서드
	public MemberVo selectMemberByNaverId(String naverId) throws DataAccessException;
	
	//회원 정보 수정 기능
	public int updateMember(MemberVo memberVO) throws DataAccessException;
	
	//아이디 중복 체크
	public int checkId(String id);
	
	//전체 회원 조회
	public List<MemberVo> selectMemberList(String searchKeyword, String searchType, int offset, int pageSize);
	
	public int selectMemberCount(String searchKeyword, String searchType);

    //회원 삭제
    void deleteMember(String id);
	
    //어드민 - 이미지초기화
    void resetProfileImg(String id);
    
    List<Map<String, Object>> selectGenderDistribution();

    List<Map<String, Object>> selectCountryDistribution();
    
    //내가 좋아요한 게시글
    List<BoardVo> selectMyLikedBoards(String memberId);
    
    //내가 쓴 게시글
    List<BoardVo> selectMyBoards(String memberId);
    
    //내가 좋아요한 게시글의 회원id
    List<Integer> selectLikedBoardIds(String memberId);
    

}
