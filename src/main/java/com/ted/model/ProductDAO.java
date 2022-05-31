package com.ted.model;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public interface ProductDAO {

	ProductBean select(Integer id);

	List<ProductBean> select();

	List<ProductBean> select(String pdname, String pdtype);

	ProductBean insert(ProductBean bean) throws Exception;
	//TODO 處理 error mapping

	ProductBean update(String name, Integer price,
					   String desc, String catalog, Integer id , Date updateDate, String updateUser);

	ProductBean updateImg(String imgIndex, Integer id);

	boolean delete(Integer id);

}