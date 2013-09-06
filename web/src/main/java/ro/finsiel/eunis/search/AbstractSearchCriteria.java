package ro.finsiel.eunis.search;


/**
 * This class represents an abstract search which must be extended by other objects which are used in search
 * operations. Basically it does nothing but offering a generic interface to connect searches with JRF tables.
 * Provides fields used for filtering (search in results), common to all searches.
 * @author finsiel
 */
public abstract class AbstractSearchCriteria {
    // The following fields are used for search in results and defines the criteria used. Basically all searches from
    // EUNIS application have search in results so I declared here the code so that one should not declare in every
    // search criteria these variables
    /** Search string used for search in results. */
    protected String criteriaSearch = null;

    /** Criteria typeForm used for search in results. */
    protected Integer criteriaType = null;

    /** Relation between criteriaSearch and criteriaType. */
    protected Integer oper = null;

    /**
     * This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public abstract String toURLParam();

    /**
     * Transform this object into an SQL representation.
     * @return SQL string representing this object.
     */
    public abstract String toSQL();
    
    /**
     * Transform this object into an SQL representation with option to use fuzzy search.
     * @return SQL string representing this object.
     */
    public String toSQL(boolean fuzzySearch){
        return toSQL();
    }

    /**
     * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
     * to say is that I can say about an object for example:<br />
     * < INPUT type='hidden" name="searchCriteria" value="natrix">
     * < INPUT type='hidden" name="oper" value="1">
     * < INPUT type='hidden" name="searchType" value="1">.
     * @return Web page FORM representation of the object.
     */
    public abstract String toFORMParam();

    /**
     * This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */
    public abstract String toHumanString();
    
}
