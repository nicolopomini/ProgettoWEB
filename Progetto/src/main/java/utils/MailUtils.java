/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import dao.entities.User;
import java.util.Date;
import java.util.Properties;

import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.MessagingException;
/**
 *
 * @author Marco
 */
public class MailUtils 
{
    public static void sendActivationEmail(User user)
    {
        String from = "webprojecttest2017@gmail.com";
        final String username = "webprojecttest2017@gmail.com";
        final String password = "WebProject2017Safe";
        final String port = "587";
        String host = "smtp.gmail.com";
        
        Properties props = new Properties();
        props.setProperty("mail.smtp.host", host);
        props.setProperty("mail.smtp.port", port);
        props.setProperty("mail.smtp.auth", "true");
        props.setProperty("mail.smtp.starttls.enable", "true");
        props.setProperty("mail.smtp.ssl.trust","*");

        Session session = Session.getInstance(props);
        
        
            // Create a default MimeMessage object.
            Message message = new MimeMessage(session);
        try {        
   	   // Set From: header field of the header.
	   message.setFrom(new InternetAddress(username));

	   // Set To: header field of the header.
	   message.setRecipients(Message.RecipientType.TO,
              InternetAddress.parse(user.getEmail(), false));

	   // Set Subject: header field
	   message.setSubject("Email activation");
           message.setSentDate(new Date());
           message.setHeader("MIME-Version", "1.0");
	   // Send the actual HTML message, as big as you like
	   message.setContent("<html>"
                   + "<head>"
                   + "<title>Activation email</title>"
                   + "</head>"
                   + "<body>"
                   + "<h3>Account activation</h3>"
                   + "<p>Email: "+user.getEmail()+"</p>"
                   + "<p>Name: "+user.getName()+"</p>"
                   + "<p>Surname: "+user.getSurname()+"</p>"
                   + "<p>Address: "+user.getAddress()+"</p>"
                   + "<form action='localhost/Progetto/activation.jsp' target='_blank' method='post'>"
                   + "<input type='hidden' name='ActivationCode' value='"+user.getVerificationCode()+"'>"
                   + "<button type='submit'>Activate account</button>"
                   + "</form>"
                   + "</body>"
                   + "</html>",
             "text/html");

	   // Send message
	   Transport.send(message, username,password);

      } catch (MessagingException e) {
	   e.printStackTrace();
	   throw new RuntimeException(e);
      }
    }
}
