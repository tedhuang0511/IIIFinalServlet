package com.ted.model.viewTables;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Component
@Transactional
public class OrderReportService {
	@Autowired
	private OrdersumDAO ordersumDAO;
	
	public List<OrdersumBean> select(Date fromDate, Date endDate){
		List<OrdersumBean> result = null;
		if(fromDate!=null && endDate!=null) {
			List<OrdersumBean> temp = ordersumDAO.select(fromDate,endDate);
			if(temp!=null&&temp.size()!=0) {
				result = temp;
				return result;
			}
		}else {
//			result = productsaleDAOHibernate.select();
		}	
		return result;
	};

}
