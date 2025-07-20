package util;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;

public class EmailService {
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private static final Properties props = new Properties();

    static {
        try (InputStream input = EmailService.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                LOGGER.severe("Sorry, unable to find config.properties");
            } else {
                props.load(input);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading email configuration", e);
        }
    }

    public void sendOtpEmail(String toEmail, String otp) {
        final String fromEmail = props.getProperty("mail.from");
        final String password = props.getProperty("mail.password");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your Verification Code for KidSocial");
            
            String emailContent = "<h3>Welcome to KidSocial!</h3>"
                                + "<p>Thank you for registering. Please use the following One-Time Password (OTP) to verify your account:</p>"
                                + "<h2><strong>" + otp + "</strong></h2>"
                                + "<p>This code will expire in 10 minutes.</p>"
                                + "<p>If you did not request this, please ignore this email.</p>"
                                + "<br>"
                                + "<p>Best regards,<br>The KidSocial Team</p>";

            message.setContent(emailContent, "text/html");

            Transport.send(message);
            LOGGER.info("OTP Email sent successfully to " + toEmail);
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send OTP email to " + toEmail, e);
        }
    }
} 