package com.harunichi.follow.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.harunichi.follow.vo.FollowVo;

public interface FollowDao {
	
    List<FollowVo> selectFollowList(String searchKeyword, int offset, int pageSize);
    
    int selectFollowCount(String searchKeyword);
    
    //팔로우 삭제 기능 (어드민)
    public void deleteFollowAdmin(String followerId, String followeeId) throws DataAccessException;
}