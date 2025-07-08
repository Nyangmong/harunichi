package com.harunichi.member.service;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.harunichi.board.vo.BoardVo;
import com.harunichi.member.vo.MemberVo;

public interface MemberService {
	
	//회원 가입 기능
	public int insertMember(MemberVo memberVO) throws DataAccessException;
	//회원 업데이트 기능
	public int updateMember(MemberVo memberVo) throws Exception;
	//카카오 아이디로 회원 조회
	public MemberVo selectMemberByKakaoId(String kakaoId) throws Exception;
	//네이버 아이디로 회원 조회
	public MemberVo selectMemberByNaverId(String naverId) throws Exception;
	//이메일 중복 체크 기능 (매개변수로 받은 이메일이 중복인지 아닌지를 판단)
	public boolean isEmailDuplicate(String email);
	//아이디 중복 체크 기능
	public boolean checkId(String id);
	//아이디로 회원 정보 조회
	public MemberVo selectMemberById(String id);
	//회원 전체 정보 조회
	public Map<String, Object> getMemberList(String searchKeyword, String searchType, int page);
    //회원 삭제 메소드
    void deleteMember(String id);
	//어드민 - 프로필이미지초기화
    void resetProfileImg(String id) throws Exception;
    
    List<Map<String, Object>> getGenderDistribution();

    List<Map<String, Object>> getCountryDistribution();
    
    //내가 좋아요한 게시글 (내가 좋아요한 게시글의 상세 정보(BoardVo 리스트))
    List<BoardVo> getMyLikedBoards(String memberId);
    
    //내가 쓴 게시글
    List<BoardVo> getMyBoards(String memberId);
    
    //가 좋아요한 게시글 ID만 뽑아오기 위한 메소드
	public List<Integer> getLikedBoardIds(String id);
	
}
