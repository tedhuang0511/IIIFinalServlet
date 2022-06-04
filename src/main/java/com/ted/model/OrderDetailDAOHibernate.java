package com.ted.model;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;
import java.util.Objects;

@Repository
public class OrderDetailDAOHibernate implements OrderDetailDAO {
	@PersistenceContext
	private Session session;

	public Session getSession() {
		return session;
	}

	@Override
	public List<OrderDetailBean> select(String id) {  //這邊的參數取決於前端有哪些選項
		CriteriaBuilder criteriaBuilder = this.getSession().getCriteriaBuilder();
		CriteriaQuery<OrderDetailBean> criteriaQuery = criteriaBuilder.createQuery(OrderDetailBean.class);

		//FROM product
		Root<OrderDetailBean> root = criteriaQuery.from(OrderDetailBean.class);
		//如果使用者有輸入產品名稱 或 產品類別才進來

		TypedQuery<OrderDetailBean> typedQuery = this.getSession().createQuery(criteriaQuery);
		List<OrderDetailBean> result = typedQuery.getResultList();
		if(result!=null && !result.isEmpty()) {
			return result;
		}
		return null;
	}

	@Override
	public Integer insert(OrderDetailBean bean) throws Exception {
		if(bean!=null) {
			this.getSession().save(bean);
			return 1;
		}
		return 0;
	}
}
