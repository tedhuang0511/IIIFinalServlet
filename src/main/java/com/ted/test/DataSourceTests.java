package com.ted.test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

public class DataSourceTests {
    public static void main(String[] args) throws Exception {
        ApplicationContext context = new FileSystemXmlApplicationContext(
                "D:\\Program Files\\IIIFinalServlet2\\src\\main\\webapp\\WEB-INF\\beans.config.xml");

        DataSource dataSource = context.getBean("dataSource", DataSource.class);
        Connection conn = dataSource.getConnection();
        PreparedStatement stmt = conn.prepareStatement("select * from products");
        ResultSet rset = stmt.executeQuery();
        while(rset.next()) {
            String col1 = rset.getString(1);
            String col2 = rset.getString(2);
            System.out.println(col1+":"+col2);
        }
        rset.close();
        stmt.close();
        conn.close();

        ((ConfigurableApplicationContext) context).close();
    }
}
