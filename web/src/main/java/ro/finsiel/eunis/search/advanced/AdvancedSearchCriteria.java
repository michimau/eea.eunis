package ro.finsiel.eunis.search.advanced;


import ro.finsiel.eunis.search.AbstractSearchCriteria;


/**
 * Search criteria used for advanced search.
 * @author finsiel
 */
public class AdvancedSearchCriteria extends AbstractSearchCriteria {

    /** Search species.*/
    public static final int TYPE_SPECIES = 0;

    /** Search habitats. */
    public static final int TYPE_HABITATS = 1;

    /** Search sites. */
    public static final int TYPE_SITES = 2;

    private String criteria = null;
    private String relationOp = null;
    private String searchCriteriaMin = null;
    private String searchCriteriaMax = null;

    private int type = TYPE_SPECIES;

    /**
     * Ctor for main serch criteria.
     * @param	criteria Search criteria.
     * @param	relationOp Relation operator.
     * @param	searchCriteriaMax Max value.
     * @param	searchCriteriaMin Min value.
     * @param	type Type of search.
     */
    public AdvancedSearchCriteria(String criteria, String relationOp, String searchCriteriaMax, String searchCriteriaMin, int type) {
        this.criteria = criteria;
        this.relationOp = relationOp;
        this.searchCriteriaMax = searchCriteriaMax;
        this.searchCriteriaMin = searchCriteriaMin;
        this.type = type;
    }

    /**
     * This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return null (No need to implement).
     */
    public String toURLParam() {
        return null;
    }

    /**
     * Transform this object into an SQL representation.
     * @return null (No need to implement).
     */
    public String toSQL() {
        return null;
    }

    /**
     * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
     * to say is that I can say about an object for example:<br />
     * < INPUT type='hidden" name="searchCriteria" value="natrix">
     * < INPUT type='hidden" name="oper" value="1">
     * < INPUT type='hidden" name="searchType" value="1">.
     * @return null (No need to implement).
     */
    public String toFORMParam() {
        return null;
    }

    /**
     * This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return null (No need to implement).
     */
    public String toHumanString() {
        return null;
    }

    /**
     * Getter for criteria property.
     * @return criteria.
     */
    public String getCriteria() {
        return criteria;
    }

    /**
     * Setter for criteria property.
     * @param criteria criteria.
     */
    public void setCriteria(String criteria) {
        this.criteria = criteria;
    }

    /**
     * Getter for relationOp property.
     * @return relationOp.
     */
    public String getRelationOp() {
        return relationOp;
    }

    /**
     * Setter for relationOp property.
     * @param relationOp relationOp.
     */
    public void setRelationOp(String relationOp) {
        this.relationOp = relationOp;
    }

    /**
     * Getter for searchCriteriaMax property.
     * @return searchCriteriaMax.
     */
    public String getSearchCriteriaMax() {
        return searchCriteriaMax;
    }

    /**
     * Setter for searchCriteriaMax property.
     * @param searchCriteriaMax searchCriteriaMax.
     */
    public void setSearchCriteriaMax(String searchCriteriaMax) {
        this.searchCriteriaMax = searchCriteriaMax;
    }

    /**
     * Getter for searchCriteriaMin property.
     * @return searchCriteriaMin.
     */
    public String getSearchCriteriaMin() {
        return searchCriteriaMin;
    }

    /**
     * Setter for searchCriteriaMin property.
     * @param searchCriteriaMin searchCriteriaMin.
     */
    public void setSearchCriteriaMin(String searchCriteriaMin) {
        this.searchCriteriaMin = searchCriteriaMin;
    }

    /**
     * Getter for type property.
     * @return type.
     */
    public int getType() {
        return type;
    }

    /**
     * Setter for type property.
     * @param type type.
     */
    public void setType(int type) {
        this.type = type;
    }
}
