package ro.finsiel.eunis;


import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.activation.DataHandler;
import java.util.Date;
import java.util.Properties;
import java.util.ArrayList;
import java.io.File;


/**
 * Report EUNIS feedback to the app provider using sendmail.
 *
 * @author finsiel
 */
public class SendMail implements java.io.Serializable {

    /**
     * Creates a new instance of SendMail.
     */
    public SendMail() {}

    /**
     * Send mail method.
     *
     * @param mailTo  Recipient.
     * @param subject Subject of e-mail.
     * @param body    Body of e-mail.
     * @param attachments List of files on the server ( with absolute paths )
     */
    public static synchronized void sendMail(
            final String mailTo,
            final String subject,
            final String body,
            final String SMTP_SERVER,
            final String smtp_username,
            final String smtp_password,
            final String smtp_accountFrom,
            final ArrayList<String> attachments) {
        // JavaMail API
        Properties sysProps = System.getProperties();

        sysProps.put("mail.smtp.host", SMTP_SERVER);

        SmtpAuthenticator auth = null;

        if (smtp_username != null && smtp_password != null) {
            auth = new SmtpAuthenticator(smtp_username, smtp_password);
        }
        Session s = Session.getDefaultInstance(sysProps, auth);

        s.setDebug(true);
        MimeMessage msg = new MimeMessage(s);

        try {
            msg.setFrom(new InternetAddress(smtp_accountFrom));
            msg.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(mailTo, false));
            msg.setSubject(subject);

            BodyPart mbody = new MimeBodyPart();

            mbody.setText(body);

            Multipart mp = new MimeMultipart();

            mp.addBodyPart(mbody);

            // Attachments
            if (attachments != null) {
                mbody = new MimeBodyPart();
                for (int i = 0; i < attachments.size(); i++) {
                    DataSource ds = new FileDataSource(attachments.get(i));

                    mbody.setDataHandler(new DataHandler(ds));
                    File f = new File(attachments.get(i));

                    mbody.setFileName(f.getName());
                    System.out.println("f.getName() = " + f.getName());
                    mp.addBodyPart(mbody);
                }
            }
            msg.setContent(mp);
            msg.setSentDate(new Date());
            Transport.send(msg);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        // Old command line style
        // String[] cmd = new String[3];
        // cmd[0] = new String("mail");
        // cmd[1] = new String("-s EUNIS Database Feedback - " + subject);
        // cmd[2] = new String(mailTo);
        // Process mailProc = Runtime.getRuntime().exec(cmd);
        // OutputStream outStream = mailProc.getOutputStream();
        // outStream.write(body.getBytes());
        // outStream.flush();
        // outStream.close();
    }
}


class SmtpAuthenticator extends Authenticator {
    private String username;
    private String password;

    public SmtpAuthenticator() {}

    public SmtpAuthenticator(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(username, password);
    }
}
