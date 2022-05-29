package com.ted.model;

import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;
import javax.persistence.PersistenceContext;

@Repository
public class ProductDAOHibernate implements ProductDAO {

	@PersistenceContext
	private Session session;

	public Session getSession() {
		return session;
	}
	
	@Override
	public ProductBean select(Integer id) {
		if(id!=null) {
			return this.getSession().get(ProductBean.class, id);
		}
		return null;
	}

	@Override
	public List<ProductBean> select() {
		return this.getSession().createQuery(
				"FROM ProductBean", ProductBean.class).list();
	}
	@Override
	public ProductBean insert(ProductBean bean) {
		System.out.println("DAO:"+bean.getProductId());
		if(bean!=null && bean.getProductId()!=null) {
			ProductBean temp = this.getSession().get(ProductBean.class, bean.getProductId());
			if(temp==null) {
				System.out.println("null temp detected! so we do INSERT sql");
				this.getSession().save(bean);
				return bean;
			}
		}
		return null;
	}
	@Override
	public ProductBean update(String name, Integer price,
			String desc, String catalog, Integer id) {
		if(id!=null) {
			ProductBean temp = this.getSession().get(ProductBean.class, id);
			if(temp!=null) {
				temp.setProductName(name);
				temp.setProductPrice(price);
				temp.setProductDesc(desc);
				temp.setProductCatalog(catalog);
				return temp;
			}
		}
		return null;
	}
	
	@Override
	public boolean delete(Integer id) {
		if(id!=null) {
			ProductBean temp = this.getSession().get(ProductBean.class, id);
			if(temp!=null) {
				this.getSession().delete(temp);
				return true;
			}
		}
		return false;
	}
}
