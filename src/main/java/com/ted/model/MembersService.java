package com.ted.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Component
@Transactional
public class MembersService {
	@Autowired
	private MembersDAO membersDao;
	
	public List<MembersBean> select(MembersBean bean){
		List<MembersBean> result = null;
		if(bean!=null && bean.getMemberId()!=0) {
			MembersBean temp = membersDao.select(bean.getMemberId());
			if(temp!=null) {
				result = new ArrayList<>();
				result.add(temp);
			}
		}else {
			result = membersDao.select();
		}	
		return result;
	};
	public MembersBean insert(MembersBean bean){
		MembersBean result = null;
		if(bean!=null && bean.getMemberId()!=0) {
			System.out.println(bean.getMemberId() + " from Members service");
			result = membersDao.insert(bean);
		}	
		return result;
	};
	
	public MembersBean update(MembersBean bean){
		MembersBean result = null;
		if(bean!=null && bean.getMemberId()!=0) {
			result = membersDao.update(bean.getMemberLastname(),
					bean.getMemberFirstname(),
					bean.getMemberNickname(),
					bean.getMemberEmail(),
					bean.getMemberTel(),
					bean.getMemberAddr(),
					bean.getMemberBirth(),
					bean.getMemberId());				
		}	
		return result;
	};
	
	public boolean delete(MembersBean bean) {
		boolean result = false;
		if(bean!=null && bean.getMemberId()!=0) {
			result = membersDao.delete(bean.getMemberId());
		}
		return result;
	};
	

}
