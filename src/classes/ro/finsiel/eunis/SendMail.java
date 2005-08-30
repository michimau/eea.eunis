package ro.finsiel.eunis;

import java.io.*;

/** Report EUNIS feedback to the app provider using sendmail.
 * @author finsiel
 */
public class SendMail implements java.io.Serializable {

  /**
   * Creates a new instance of SendMail.
   */
  public SendMail() {
  }

  /**
   * Send mail method.
   * @param mailTo Recipient.
   * @param subject Subject of e-mail.
   * @param body Body of e-mail.
   * @throws IOException If cannot create the process 'mail' on linux.
   */
  protected static synchronized void sendMail(final String mailTo, final String subject, final String body) throws IOException {
    String[] cmd = new String[3];
    cmd[0] = new String("mail");
    cmd[1] = new String("-s EUNIS Feedback - " + subject);
    cmd[2] = new String(mailTo);
    Process mailProc = Runtime.getRuntime().exec(cmd);
    OutputStream outStream = mailProc.getOutputStream();
    outStream.write(body.getBytes());
    outStream.flush();
    outStream.close();
  }

  /**
   * Send feedback method.
   * @param recipient The destination e-mail address.
   * @param feedBackType Type of feedback as listed in the report page.
   * @param body Body of the message as entered by the user.
   */
  public static void sendEUNISFeedback(String recipient, String feedBackType, String body) {
    try
    {
      sendMail(recipient, feedBackType, body);
    } catch (IOException ioex) {
      ioex.printStackTrace();
    }
  }

  /**
   * Test this class.
   * @param args Command line args.
   */
  public static void main(String args[]) {
    sendEUNISFeedback("eunis@finsiel.ro", "Encountered software BUGs", "Everything works 'K ;)");
  }
}