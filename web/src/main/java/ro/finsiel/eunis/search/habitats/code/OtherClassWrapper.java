package ro.finsiel.eunis.search.habitats.code;


/**
 * Wrapper for other classification. Encapsulates information about a classification: code/name/relation.
 *
 * @author finsiel
 */
public class OtherClassWrapper {
    private String classificationCode = "";
    private String code = "";
    private String classificatioName = "";
    private String relation = "";
    private String title = "";

    /**
     * Ctor.
     *
     * @param code              Code.
     * @param classificatioName Name of the classificaiton.
     * @param relation          Relation.
     */
    public OtherClassWrapper(String code, String classificatioName, String relation) {
        this.code = code;
        this.classificatioName = classificatioName;
        this.relation = relation;
    }

    /**
     * Wrapper for 'other classification' data.
     *
     * @param code               code
     * @param classificatioName  classification name
     * @param relation           telation
     * @param classificationCode code
     * @param title              title
     */
    public OtherClassWrapper(String code, String classificatioName, String relation, String classificationCode, String title) {
        this.code = code;
        this.classificatioName = classificatioName;
        this.relation = relation;
        this.classificationCode = classificationCode;
        this.title = title;
    }

    /**
     * Getter.
     *
     * @return classificationCode
     */
    public String getClassificationCode() {
        return classificationCode;
    }

    /**
     * Setter.
     *
     * @param classificationCode New value
     */
    public void setClassificationCode(String classificationCode) {
        this.classificationCode = classificationCode;
    }

    /**
     * Getter for code property.
     *
     * @return code.
     */
    public String getCode() {
        return code;
    }

    /**
     * Getter for classificatioName property.
     *
     * @return classificatioName.
     */
    public String getClassificatioName() {
        return classificatioName;
    }

    /**
     * Getter for relation property.
     *
     * @return relation.
     */
    public String getRelation() {
        return relation;
    }

    /**
     * Getter.
     * @return title
     */
    public String getTitle() {
        return title;
    }

    /**
     * Setter.
     * @param title New value
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Decode the relation.
     *
     * @return Decoded representation (ex. < = 'narrower').
     */
    public String getRelationDecoded() {
        String relationDescr = "";

        if (relation.equalsIgnoreCase("<")) {
            relationDescr = "(narrower)";
        }
        if (relation.equalsIgnoreCase(">")) {
            relationDescr = "(wider)";
        }
        if (relation.equalsIgnoreCase("=")) {
            relationDescr = "(same)";
        }
        if (relation.equalsIgnoreCase("#")) {
            relationDescr = "(overlap)";
        }
        if (relation.equalsIgnoreCase("?")) {
            relationDescr = "(not defined)";
        }
        if (relation.equalsIgnoreCase("s")) {
            relationDescr = "(source)";
        }
        return relationDescr;
    }
}
