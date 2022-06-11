package com.ted.model.viewTables;

import java.util.Date;
import java.util.List;

public interface ProductsaleDAO {
    List<Object[]> select(Date fromDate, Date endDate);
}
