package com.harunichi.follow.service;

import java.util.Map;

public interface FollowService {
	Map<String, Object> getFollowList(String searchKeyword, int page);
	
	//팔로우 삭제 기능 (어드민)
	public void deleteFollowAdmin(String followerId, String followeeId) throws Exception;
	
	public Map<String, Object> getMemberList(Map<String, Object> paramMap);
}
