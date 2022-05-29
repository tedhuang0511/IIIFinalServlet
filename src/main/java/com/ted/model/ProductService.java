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
        List<ProductBean> result = null;
        if(bean!=null && bean.getProductId()!=null && !bean.getProductId().equals(0)) {
            ProductBean temp = productDao.select(bean.getProductId());
            if(temp!=null) {
                result = new ArrayList<ProductBean>();
                result.add(temp);
            }
        } else {
            result = productDao.select();
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
                    bean.getProductDesc(), bean.getProductCatalog(), bean.getProductId());
        }
        return result;
    }

    public ProductBean deleteImg(ProductBean bean, Integer index) {
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
