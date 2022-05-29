package com.ted.model;

import java.util.List;

public interface ProductDAO {

	public abstract ProductBean select(Integer id);

	public abstract List<ProductBean> select();

	public abstract ProductBean insert(ProductBean bean);

	public abstract ProductBean update(String name, Integer price,
									   String desc, String catalog, Integer id);

	public abstract boolean delete(Integer id);

}