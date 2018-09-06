package com.daekyo.clab.common.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("mybatisDAO")
public class MybatisDAO{

	protected Log log = LogFactory.getLog(MybatisDAO.class);
	
    @Autowired
    @Resource(name="sqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
    
    public Object insert(String queryId, Object params){
    	Object result = null;
    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.insert(queryId, params);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
     
    public Object update(String queryId, Object params){
        Object result = null;
    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.update(queryId, params);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
     
    public Object delete(String queryId, Object params){
	    	Object result = null;
	    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.delete(queryId, params);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
    
	public Object selectOne(String queryId){
	    	Object result = null;
	    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.selectOne(queryId);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
     
	public Object selectOne(String queryId, Object params){
	    	Object result = null;
	    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.selectOne(queryId, params);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId){
	    	List result = null;
	    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.selectList(queryId);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId, Object params){
	    	List result = null;
	    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.selectList(queryId, params);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
    
    public int selectCount(String queryId) {
	    	int result = 0;
	    	
	    	try {
	    		long startTime = System.currentTimeMillis();

			result = sqlSession.selectOne(queryId);

			long endTime = System.currentTimeMillis();
			
 			if (log.isDebugEnabled()) {
 				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
 			}
 		}
 		catch(Exception e) {
 			if (log.isDebugEnabled()) {
 				log.debug(e.getMessage());
 			}
 			throw new RuntimeException (e);
 		}
    	
        return result;
    }
    
    public int selectCount(String queryId, Object params) {
    	int result = 0;
    	
    	try {
    		long startTime = System.currentTimeMillis();

		result = sqlSession.selectOne(queryId, params);

		long endTime = System.currentTimeMillis();
		
			if (log.isDebugEnabled()) {
				log.debug("["+queryId+"]query execute TIME : " + (endTime - startTime) + "(ms)]]");
			}
		}
		catch(Exception e) {
			if (log.isDebugEnabled()) {
				log.debug(e.getMessage());
			}
			throw new RuntimeException (e);
		}
	
    return result;
}
}
