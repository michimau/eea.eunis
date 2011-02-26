package ro.finsiel.eunis.glossary;


/**
 * Form bean which passes the request parameters used in search glossary pages (glossary.jsp, glossary-result.jsp).
 * @author finsiel
 */
public class GlossaryBean implements java.io.Serializable {
    private String searchString = null;
    private String operand = null;
    private String searchTerms = null;
    private String searchDefinitions = null;
    private String module = null;

    private String showReference = null;
    private String showSource = null;
    private String showURL = null;

    /**
     * Getter for searchString property.
     * @return searchString.
     */
    public String getSearchString() {
        return searchString;
    }

    /**
     * Setter for searchString property.
     * @param searchString searchString.
     */
    public void setSearchString(String searchString) {
        this.searchString = searchString;
    }

    /**
     * Getter for operand property.
     * @return operand.
     */
    public String getOperand() {
        return operand;
    }

    /**
     * Setter for operand property.
     * @param operand operand.
     */
    public void setOperand(String operand) {
        this.operand = operand;
    }

    /**
     * Getter for searchTerms property.
     * @return searchTerms.
     */
    public String getSearchTerms() {
        return searchTerms;
    }

    /**
     * Setter for searchTerms property.
     * @param searchTerms searchTerms.
     */
    public void setSearchTerms(String searchTerms) {
        this.searchTerms = searchTerms;
    }

    /**
     * Getter for searchDefinitions property.
     * @return searchDefinitions.
     */
    public String getSearchDefinitions() {
        return searchDefinitions;
    }

    /**
     * Setter for searchDefinitions property.
     * @param searchDefinitions searchDefinitions.
     */
    public void setSearchDefinitions(String searchDefinitions) {
        this.searchDefinitions = searchDefinitions;
    }

    /**
     * Getter for module property.
     * @return module.
     */
    public String getModule() {
        return module;
    }

    /**
     * Setter for module property.
     * @param module module.
     */
    public void setModule(String module) {
        this.module = module;
    }

    /**
     * Getter for showReference property.
     * @return showReference showReference.
     */
    public String getShowReference() {
        return showReference;
    }

    /**
     * Setter for showReference property.
     * @param showReference showReference.
     */
    public void setShowReference(String showReference) {
        this.showReference = showReference;
    }

    /**
     * Getter for showSource property.
     * @return showSource.
     */
    public String getShowSource() {
        return showSource;
    }

    /**
     * Setter for showSource property.
     * @param showSource showSource.
     */
    public void setShowSource(String showSource) {
        this.showSource = showSource;
    }

    /**
     * Getter for showURL property.
     * @return showURL.
     */
    public String getShowURL() {
        return showURL;
    }

    /**
     * Setter for showURL property.
     * @param showURL showURL.
     */
    public void setShowURL(String showURL) {
        this.showURL = showURL;
    }
}
