package com.ted.model;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Objects;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.engine.jdbc.spi.SqlExceptionHelper;
import org.springframework.stereotype.Repository;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

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
		return null;
	}

	@Override
	public List<ProductBean> select(String pdname, String pdtype) {
		CriteriaBuilder criteriaBuilder = this.getSession().getCriteriaBuilder();
		CriteriaQuery<ProductBean> criteriaQuery = criteriaBuilder.createQuery(ProductBean.class);

		//FROM product
		Root<ProductBean> root = criteriaQuery.from(ProductBean.class);
		//如果使用者有輸入產品名稱 或 產品類別才進來
		Predicate p1,p2;
		try{
			if(!Objects.equals(pdname, "XX") || !Objects.equals(pdtype, "XX")){
				if(!Objects.equals(pdname, "XX") && pdname.length()!=0){
					//name like '%xxx%'
					p1 = criteriaBuilder.like(root.get("productName"), "%"+pdname+"%");
					criteriaQuery.where(p1);
				}
				if(!Objects.equals(pdtype, "XX") && pdtype.length()!=0){
					//product_catalog = ?
					p2 = criteriaBuilder.equal(root.get("productCatalog"),pdtype);
					criteriaQuery.where(p2);
				}
				if(!pdname.equals("XX") && !pdtype.equals("XX")){
					p1 = criteriaBuilder.like(root.get("productName"), "%"+pdname+"%");
					p2 = criteriaBuilder.equal(root.get("productCatalog"),pdtype);
					criteriaQuery.where(p1,p2);
				}
			}
		}catch (Exception e){
			System.out.println(e);
		}

		TypedQuery<ProductBean> typedQuery = this.getSession().createQuery(criteriaQuery);
		List<ProductBean> result = typedQuery.getResultList();
		if(result!=null && !result.isEmpty()) {
			return result;
		}
		return null;
	}
	@Override
	public ProductBean insert(ProductBean bean) throws Exception {
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
							  String desc, String catalog, Integer id, Date updateDate, String updateUser) {
		if(id!=null) {
			ProductBean temp = this.getSession().get(ProductBean.class, id);
			if(temp!=null) {
				temp.setProductName(name);
				temp.setProductPrice(price);
				temp.setProductDesc(desc);
				temp.setProductCatalog(catalog);
				temp.setUpdateDate(updateDate);
				temp.setUpdateUser(updateUser);
				return temp;
			}
		}
		return null;
	}

	public ProductBean updateImg(String index, Integer id) {
		if(id!=null) {
			ProductBean temp = this.getSession().get(ProductBean.class, id);
			System.out.println("deleteImg DAO: " + id + " " + index);
			if(temp!=null) {
				switch (index){
					case "1":
						temp.setProductImg1("https://s3.ap-northeast-1.amazonaws.com/tedawsbucket20220530/javaproject/2022_05_31_16_00_31_187.jpg");
						break;
					case "2":
						temp.setProductImg2("https://s3.ap-northeast-1.amazonaws.com/tedawsbucket20220530/javaproject/2022_05_31_16_00_31_187.jpg");
						break;
					case "3":
						temp.setProductImg3("https://s3.ap-northeast-1.amazonaws.com/tedawsbucket20220530/javaproject/2022_05_31_16_00_31_187.jpg");
						break;
					case "4":
						temp.setProductImg4("https://s3.ap-northeast-1.amazonaws.com/tedawsbucket20220530/javaproject/2022_05_31_16_00_31_187.jpg");
				}
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
