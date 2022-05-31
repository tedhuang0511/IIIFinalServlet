package com.ted.model;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ProductService {
    @Autowired
    private ProductDAO productDao;

    @Transactional(readOnly = true)
    public List<ProductBean> select(ProductBean bean) {
        System.out.println("in PS select method");
        List<ProductBean> result = null;
        if(bean!=null && bean.getProductId()!=null && !bean.getProductId().equals(0)) { //如果傳進來的bean不是空 && getId不是空 && id != 0
            ProductBean temp = productDao.select(bean.getProductId());  //呼叫DAO有id參數的select方法
            if(temp!=null) {
                result = new ArrayList<>();
                result.add(temp);
            }
        } else {
            assert bean != null;
            String pdname = bean.getProductName();
            String pdtype = bean.getProductCatalog();
            System.out.println("in PS multiple select method"+":"+pdname+":"+pdtype);
            result = productDao.select(pdname,pdtype); //呼叫DAO無參數的select方法
        }
        return result;
    }
    public ProductBean insert(ProductBean bean) {
        ProductBean result = null;
        if(bean!=null && bean.getProductId()!=null) {
            System.out.println(bean.getProductId() + " from product service");
            result = productDao.insert(bean);
        }
        return result;
    }

    public ProductBean update(ProductBean bean) {
        ProductBean result = null;
        if(bean!=null && bean.getProductId()!=null) {
            result = productDao.update(bean.getProductName(), bean.getProductPrice(),
                    bean.getProductDesc(), bean.getProductCatalog(), bean.getProductId(), bean.getUpdateDate(), bean.getUpdateUser());
        }
        return result;
    }

    public ProductBean deleteImg(ProductBean bean, String index) {
        ProductBean result = null;
        if(bean!=null && bean.getProductId()!=null) {
            result = productDao.updateImg(index, bean.getProductId());
        }
        return result;
    }

    public boolean delete(ProductBean bean) {
        boolean result = false;
        if(bean!=null && bean.getProductId()!=null) {
            result = productDao.delete(bean.getProductId());
        }
        return result;
    }

}
