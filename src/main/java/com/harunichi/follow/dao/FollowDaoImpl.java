package com.harunichi.follow.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.harunichi.follow.vo.FollowVo;

@Repository("followDao")
public class FollowDaoImpl implements FollowDao {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<FollowVo> selectFollowList(String searchKeyword, int offset, int pageSize) {
        Map<String, Object> params = new HashMap<>();
        params.put("searchKeyword", searchKeyword);
        params.put("offset", offset);
        params.put("pageSize", pageSize);
        return sqlSession.selectList("mapper.follow.selectFollowList", params);
    }

    @Override
    public int selectFollowCount(String searchKeyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("searchKeyword", searchKeyword);
        return sqlSession.selectOne("mapper.follow.selectFollowCount", params);
    }
    
    @Override
    public void deleteFollowAdmin(String followerId, String followeeId) throws DataAccessException {
        Map<String, Object> params = new HashMap<>();
        params.put("followerId", followerId);
        params.put("followeeId", followeeId);
        sqlSession.delete("mapper.follow.deleteFollowAdmin", params);
    }

}

