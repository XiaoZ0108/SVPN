package com.example.MyVPNCentral.Service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class MailService {


    private JavaMailSender mailSender;

    public MailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }
    @Async
    public void sendEmail(String to,String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("SecureNetVPN Test");
        message.setText(otp);
        message.setFrom("\"SecureNet VPN\" <securenetvpn@zohomail.com>"); // The sender's email
        mailSender.send(message);
    }
}