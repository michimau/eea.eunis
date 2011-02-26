package ro.finsiel.eunis.admin;


import java.io.Serializable;


/**
 * Java Bean used for Related reports function.
 * @author finsiel
 */
public class RelatedReportsBean implements Serializable {

    /** Files to be deleted. */
    private String filenames[] = null;

    /** Operation to do: delete - delete currently selected files. */
    private String operation = null;

    /**
     * Getter for filenames property.
     * @return filenames
     */
    public String[] getFilenames() {
        return filenames;
    }

    /**
     * Setter for filenames property.
     * @param filenames New value for filenames.
     */
    public void setFilenames(String[] filenames) {
        this.filenames = filenames;
    }

    /**
     * Getter for operation property.
     * @return operation
     */
    public String getOperation() {
        return operation;
    }

    /**
     * Setter for operation property.
     * @param operation New value for operation.
     */
    public void setOperation(String operation) {
        this.operation = operation;
    }
}
