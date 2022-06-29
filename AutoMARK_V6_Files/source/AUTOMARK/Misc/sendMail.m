% this function sends an email to the current email address
function sendMail(recipient, subject, message, attachments)    
    mail = 'ualbertaautomark@gmail.com'; 
    password = 'n3_=&N}M@(9w9W2X';
    setpref('Internet','SMTP_Server','smtp.gmail.com');
    setpref('Internet','E_mail',mail);
    setpref('Internet','SMTP_Username',mail);
    setpref('Internet','SMTP_Password',password);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', ...
                      'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    sendmail(recipient, subject,message, attachments)
end