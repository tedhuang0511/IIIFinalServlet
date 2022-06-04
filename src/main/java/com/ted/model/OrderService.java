package com.ted.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class OrderService {
    @Autowired
    private MemberOrderDAO memberOrderDAO;
    @Autowired
    private OrderDetailDAO orderDetailDAO;

    @Transactional(readOnly = true)
    public List<Object> select(MemberOrderBean bean) {
        System.out.println("in order select method");
        List<Object> result1 = new ArrayList<>();
        if(bean!=null && bean.getOrderId()!=null && !bean.getOrderId().equals("XX")) { //如果傳進來的bean不是空 && getId不是空 && id != "XX"
            MemberOrderBean temp = memberOrderDAO.select(bean.getOrderId()); //根據id找出唯一訂單
            List<OrderDetailBean> temp1 = null;
            if (temp != null) {
                result1.add(temp);//如果有找到id就把找到的bean塞進去
                temp1 = orderDetailDAO.select(bean.getOrderId()); //根據id找出可能多個明細
            }
            result1.add(temp1);
            return result1;  //回傳一個list裡面有 1.member order bean 2.這個orderbean的多個detail bean
        } else {
            assert bean != null;
            Integer mid = bean.getMemberId();
            String status = bean.getStatus();
            System.out.println("in OS multiple select method"+":"+mid+":"+status);
            List<MemberOrderBean> temp2 = memberOrderDAO.select(mid,status); //呼叫DAO有兩個參數的select方法
            result1.add(temp2);
        }
        return result1;
    }
    public MemberOrderBean insert(MemberOrderBean bean) throws Exception {
        MemberOrderBean result = null;
        if(bean!=null && bean.getOrderId()!=null) {
            System.out.println(bean.getOrderId() + " from order service");
            result = memberOrderDAO.insert(bean);
        }
        return result;
    }

    public int insert(OrderDetailBean bean) throws Exception {
        var result = 0;
        if (bean != null && bean.getOrderId() != null) {
            System.out.println(bean.getOrderId() + " detail insert from order service!!");
            result = orderDetailDAO.insert(bean);
        }
        return result;
    }

    public MemberOrderBean update(MemberOrderBean bean) {
        MemberOrderBean result = null;
//        if(bean!=null && bean.getProductId()!=null) {
//            result = memberOrderDAO.update(bean.getProductName(), bean.getProductPrice(),
//                    bean.getProductDesc(), bean.getProductCatalog(), bean.getProductId(), bean.getUpdateDate(), bean.getUpdateUser());
//        }
        return result;
    }

    public boolean delete(MemberOrderBean bean) {
        boolean result = false;
        if(bean!=null && bean.getOrderId()!=null) {
            result = memberOrderDAO.delete(bean.getOrderId());
        }
        return result;
    }

}
