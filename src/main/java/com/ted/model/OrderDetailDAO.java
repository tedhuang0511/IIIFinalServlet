package com.ted.model;

import java.util.List;

public interface OrderDetailDAO {
    List<OrderDetailBean> select(String id);

    Integer insert(OrderDetailBean bean) throws Exception;
}
