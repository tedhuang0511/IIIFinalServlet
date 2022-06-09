package com.ted.controller;

import org.json.JSONException;
import org.json.JSONObject;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Date;
import java.util.Properties;

@WebServlet(
        urlPatterns = {"/mail"},
        initParams = {
                @WebInitParam(name = "host", value="smtp.gmail.com"),
                @WebInitParam(name = "port", value="587"),
                @WebInitParam(name = "username", value="sbbty218@gmail.com"),
                @WebInitParam(name = "password", value="xrqonlxqjfhweukl"),
        }
)
public class MailServlet extends HttpServlet {
    private String host;
    private int port;
    private String username;
    private String password;
    private Properties props;

    @Override
    public void init() throws ServletException {
        host = getServletConfig().getInitParameter("host");
        port = Integer.parseInt(getServletConfig().getInitParameter("port"));
        username = getServletConfig().getInitParameter("username");
        password = getServletConfig().getInitParameter("password");

        props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", port);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("something come mail servlet doPost method");
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String to;
        String subject;
        String text;

        StringBuffer jb = new StringBuffer();
        String line;
        try {
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null)
                jb.append(line);
        } catch (Exception e) {
            System.out.println("bufferedReader err 8787");
        }

        try {
            JSONObject jsonObject =  new JSONObject(jb.toString());
            System.out.println(jsonObject);
            to = jsonObject.getString("to");
            subject = jsonObject.getString("subject");
            text = jsonObject.getString("text");
            System.out.println("to: "+to+" subject: "+subject);
        } catch (JSONException e) {
            throw new IOException("Error parsing JSON request string");
        }

        try{
            Message message = createMessage( to, subject, text);
            Transport.send(message);
            response.getWriter().println("郵件傳送成功");
        }catch(MessagingException e){
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

    private Multipart multipart (String text) throws MessagingException {
        Multipart mp = new MimeMultipart();
        MimeBodyPart htmlPart = new MimeBodyPart();
        htmlPart.setContent(text,"text/html;charset=UTF-8");
        mp.addBodyPart(htmlPart);
        return mp;
    }
}
