package com.ted.model.viewTables;

import java.util.Date;
import java.util.List;

public interface OrdersumDAO {
    List<OrdersumBean> select(Date fromDate, Date endDate);
}
