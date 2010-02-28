package ro.finsiel.eunis.exceptions;

/**
 * This exception is thrown when a record isn't found in database.
 * @author finsiel
 */
public class RecordNotFoundException extends Exception {

  /**
   * Creates an instance of RecordNotFoundException.
   */
  public RecordNotFoundException() {
    super();
  }

  /**
   * Creates an instance of RecordNotFoundException.
   * @param message Custom exception message
   */
  public RecordNotFoundException(String message) {
    super(message);
  }
}