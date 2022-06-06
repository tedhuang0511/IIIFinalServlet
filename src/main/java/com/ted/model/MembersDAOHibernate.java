package com.ted.model;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;


@Repository
public class MembersDAOHibernate implements MembersDAO{	

	@PersistenceContext
	private Session session = null;

	public Session getSession() {
		return session;
	}

	@Override
	public MembersBean select(Integer memberId) {
		if (memberId != null) {
			return this.getSession().get(MembersBean.class, memberId);
		}
		return null;
	}
	@Override
	public List<MembersBean> select() {
		
		CriteriaBuilder criteriaBuilder = this.getSession().getCriteriaBuilder();
		CriteriaQuery<MembersBean> criteriaQuery = criteriaBuilder.createQuery(MembersBean.class);

		Root<MembersBean> root = criteriaQuery.from(MembersBean.class);

		TypedQuery<MembersBean> typedQuery = this.getSession().createQuery(criteriaQuery);
		List<MembersBean> result = typedQuery.getResultList();
		if(result!=null && !result.isEmpty()) {
			return result;
		}
		return null;
	}

	@Override
	public MembersBean insert(MembersBean bean) {
		if (bean != null && bean.getMemberId() != 0) {
			MembersBean temp = this.getSession().get(MembersBean.class, bean.getMemberId());
			if (temp == null) {
				this.getSession().save(bean);
				return bean;
			}
		}
		return null;
	}
	public MembersBean update(MembersBean bean) {
		if(bean!=null && bean.getMemberId()!=0) {
			MembersBean temp = this.getSession().get(MembersBean.class, bean.getMemberId());
			if(temp!=null) {
				return (MembersBean) this.getSession().merge(bean);
			}
		}
		return null;
	}
	@Override
	public MembersBean update(String memberLastname, String memberFirstname, String memberNickname, String memberEmail,
			String memberTel, String memberAddr, Date memberBirth,Integer memberId) {
		if (memberId != null) {
			MembersBean temp = this.getSession().get(MembersBean.class, memberId);
			if (temp != null) {
				temp.setMemberLastname(memberLastname);
				temp.setMemberFirstname(memberFirstname);
				temp.setMemberNickname(memberNickname);
				temp.setMemberTel(memberTel);
				temp.setMemberAddr(memberAddr);
				temp.setMemberBirth(memberBirth);
				
				return temp;
			}
		}
		return null;
	}

	@Override
	public boolean delete(Integer memberId) {
		if (memberId != null) {
			MembersBean temp = this.getSession().get(MembersBean.class, memberId);
			if (temp != null) {
				this.getSession().delete(temp);
				return true;
			}
		}
		return false;
	}

}
