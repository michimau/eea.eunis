package ro.finsiel.eunis.formBeans;


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
     * Getter for searchString value.
     * @return Value of searchString request parameter.
     */
    public String getSearchString() {
        return searchString;
    }

    /**
     * Setter for searchString value.
     * @param searchString Request parameter of searchString.
     */
    public void setSearchString(String searchString) {
        this.searchString = searchString;
    }

    /**
     * Getter for operand value.
     * @return Value of operand request parameter.
     */
    public String getOperand() {
        return operand;
    }

    /**
     * Setter for operand value.
     * @param operand Request parameter of searchString.
     */
    public void setOperand(String operand) {
        this.operand = operand;
    }

    /**
     * Getter for searchTerms value.
     * @return Value of searchString request parameter.
     */
    public String getSearchTerms() {
        return searchTerms;
    }

    /**
     * Setter for searchTerms value.
     * @param searchTerms Request parameter of searchString.
     */
    public void setSearchTerms(String searchTerms) {
        this.searchTerms = searchTerms;
    }

    /**
     * Getter for searchDefinitions value.
     * @return Value of searchString request parameter.
     */
    public String getSearchDefinitions() {
        return searchDefinitions;
    }

    /**
     * Setter for searchDefinitions value.
     * @param searchDefinitions Request parameter of searchString.
     */
    public void setSearchDefinitions(String searchDefinitions) {
        this.searchDefinitions = searchDefinitions;
    }

    /**
     * Getter for module value.
     * @return Value of module request parameter.
     */
    public String getModule() {
        return module;
    }

    /**
     * Setter for module value.
     * @param module Request parameter of searchString.
     */
    public void setModule(String module) {
        this.module = module;
    }

    /**
     * Getter for showReference property.
     * @return showReference.
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
     * @param showSource Show source.
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
