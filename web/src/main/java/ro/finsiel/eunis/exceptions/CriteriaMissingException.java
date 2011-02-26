package ro.finsiel.eunis.exceptions;


/**
 * This exception is thrown when no criteria for search was set during execution of a search.
 * @author finsiel
 */
public class CriteriaMissingException extends Exception {

    /**
     * Creates an instance of CriteriaMissingException.
     */
    public CriteriaMissingException() {}

    /**
     * Creates an instance of CriteriaMissingException.
     * @param message Custom exception message
     */
    public CriteriaMissingException(String message) {
        super(message);
    }
}
