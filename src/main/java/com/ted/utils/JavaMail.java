package com.ted.utils;

import org.json.JSONArray;
import org.json.JSONObject;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.util.Date;
import java.util.Properties;

public class JavaMail {
    private final String username;
    private final String password;
    private final Properties props;
    private final String memberEmail;
    private final String title;
    private final String memberName;

    public JavaMail(String memberEmail,String memberName) {
        this.memberName = memberName;
        this.memberEmail = memberEmail;
        this.title = "Java webapp 網路購物訂單確認信";
        String host = "smtp.gmail.com";
        int port = 587;
        username = "sbbty218@gmail.com";
        password = "xrqonlxqjfhweukl";

        props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", port);
    }

    public String sendMail(String text) {
        String to = memberEmail;
        try {
            Message message = createMessage(to, title , text);
            Transport.send(message);
            return "郵件傳送成功";
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }

    private Message createMessage(String to, String subject, String text) throws MessagingException {
        Session session = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                }
        );
        Message message = new MimeMessage(session);
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(subject);
        message.setSentDate(new Date());
        message.setContent(multipart(text));
        return message;
    }

    private Multipart multipart(String text) throws MessagingException {
        Multipart mp = new MimeMultipart();
        MimeBodyPart htmlPart = new MimeBodyPart();
        htmlPart.setContent(text, "text/html;charset=UTF-8");
        mp.addBodyPart(htmlPart);
        return mp;
    }

    public String createText(String productList) {
        JSONArray jsonarr = new JSONArray(productList); //把前端json字串轉乘json array
        String str = "";
        int totalPrice = 0;
        for (int i = 0; i < jsonarr.length(); i++) {
            JSONObject jobj = new JSONObject(jsonarr.get(i).toString()); //把json array裡面的json物件字串轉成json object
            totalPrice = totalPrice + (Integer)jobj.get("單項總額");
            str = str + "<tr>" +
                    "    <td style=\"padding: 16px; font-size: 18px;\">" + jobj.get("productName") + "\uD83D\uDD25" + "</td>\n" +
                    "    <td style=\"padding: 16px;\">" + "<img src=\"" + jobj.get("productImg") + "\" width=\"100px\">" + "</td>\n" +
                    "    <td style=\"padding: 16px; font-size: 16px;\">" + jobj.get("qty") + "</td>\n" +
                    "  </tr>";
        }
        System.out.println(str);
        String text1 = "<body>\n" +
                "<h3>親愛的  " +"<a style=\"font-size: 31px; color: #31b0d5\">"+memberName+"</a>"+"  您好 \uD83D\uDE4C\uD83D\uDE4C</h3>" +
                "<h1>\uD83D\uDD7A我們已經收到您的訂單，將會盡快安排為您出貨\uD83D\uDD7A</h1>\n" +
                "<h3>以下是您的訂購明細 ：</h3>\n" +
                "\n" +
                "<table style=\"border:3px #00D6D6 dashed; width: 100%;\" cellpadding=\"10\" border='1'>" +
                "  <tr>\n" +
                "    <th style=\"padding: 16px; text-align: left; width:35%;\">產品名稱</th>\n" +
                "    <th style=\"padding: 16px; text-align: left; width:30%;\">產品照片</th>\n" +
                "    <th style=\"padding: 16px; text-align: left; width:35%;\">訂購數量</th>\n" +
                "  </tr>\n"
                + str +
                "  <tr>\n" +
                "    <td></td>\n" +
                "    <td></td>\n" +
                "    <td style=\"padding: 16px;\">訂單總計:<b>"+ totalPrice +"</b></td>\n" +
                "  </tr>\n" +
                "</table>\n" +
                "</body>";
        return text1;
    }

    public static void main(String[] args) {
        JavaMail javaMail = new JavaMail("sbbty218@gmail.com","Ted Huang");
        String res = javaMail.sendMail(javaMail.createText("[\n" +
                "    {\n" +
                "        \"productId\": 52,\n" +
                "        \"qty\": 1,\n" +
                "        \"productImg\": \"https://s3.ap-northeast-1.amazonaws.com/tedawsbucket20220530/javaproject/2022_06_02_21_50_52_422.jpg\",\n" +
                "        \"單項總額\": 18899,\n" +
                "        \"productName\": \"Samsung S22 Ultra\",\n" +
                "        \"productPrice\": 18899\n" +
                "    }\n" +
                "]"));
        System.out.println(res);
    }
}
