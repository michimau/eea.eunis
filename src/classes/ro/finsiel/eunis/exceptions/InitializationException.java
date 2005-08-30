package ro.finsiel.eunis.exceptions;

/**
 * This exception is thrown when something was unitialized during an operation.
 * @author finsiel
 */
public class InitializationException extends Exception {

  /**
   * Creates an new InitializationException object.
   */
  public InitializationException() {
  }

  /**
   * Creates an new InitializationException object.
   * @param message Custom exception message
   */
  public InitializationException(String message) {
    super(message);
  }
}