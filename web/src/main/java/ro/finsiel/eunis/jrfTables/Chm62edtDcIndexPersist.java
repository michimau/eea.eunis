package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtDcIndexPersist extends PersistentObject {
    private Integer IdDc = null;
    private Integer Refcd = null;
    private Integer reference = null;
    private String Comment = null;

    /**
     * Creates an new instance of Chm62edtDcIndexPersist object.
     */
    public Chm62edtDcIndexPersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdDc() {
        return IdDc;
    }

    /**
     * Setter for a database field.
     * @param idDc New value.
     **/
    public void setIdDc(Integer idDc) {
        IdDc = idDc;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getRefcd() {
        return Refcd;
    }

    /**
     * Setter for a database field.
     * @param refcd New value.
     **/
    public void setRefcd(Integer refcd) {
        Refcd = refcd;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getReference() {
        return reference;
    }

    /**
     * Setter for a database field.
     * @param reference New value.
     **/
    public void setReference(Integer reference) {
        this.reference = reference;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getComment() {
        return Comment;
    }

    /**
     * Setter for a database field.
     * @param comment New value.
     **/
    public void setComment(String comment) {
        Comment = comment;
    }
}
