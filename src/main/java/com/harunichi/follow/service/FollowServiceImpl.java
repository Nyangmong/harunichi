package com.harunichi.follow.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.harunichi.follow.dao.FollowDao;
import com.harunichi.follow.vo.FollowVo;

@Service("followService")
public class FollowServiceImpl implements FollowService {

    @Autowired
    private FollowDao followDao;

    @Override
    public Map<String, Object> getFollowList(String searchKeyword, int page) {
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<FollowVo> list = followDao.selectFollowList(searchKeyword, offset, pageSize);
        int totalCount = followDao.selectFollowCount(searchKeyword);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        result.put("currentPage", page);
        result.put("pageSize", pageSize);

        return result;
    }
    
    //팔로우 삭제 기능 (어드민)
	@Override
	public void deleteFollowAdmin(String followerId, String followeeId) throws Exception {
		followDao.deleteFollowAdmin(followerId, followeeId);
		
	}

	@Override
	public Map<String, Object> getMemberList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return null;
	}
    
    
    
}
