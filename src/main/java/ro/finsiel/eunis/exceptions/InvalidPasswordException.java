package ro.finsiel.eunis.exceptions;

/**
 * This exception is thrown when an error occurs during password encryption / decryption.
 * @author finsiel
 */
public class InvalidPasswordException extends Exception {

  /**
   * Creates an instance of InvalidPasswordException.
   */
  public InvalidPasswordException() {
  }

  /**
   * Creates an instance of InvalidPasswordException.
   * @param msg Custom exception message
   */
  public InvalidPasswordException(String msg) {
    super(msg);
  }
}