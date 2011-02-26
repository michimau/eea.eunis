package eionet.eunis.dto;


import java.io.Serializable;

import org.simpleframework.xml.Root;


/**
 * Document dto object.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@Root
public class DcRelationDTO implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String idDc;
    private String idRelation;
    private String relation;
    private String isVersionOf;
    private String hasVersion;
    private String isReplacedBy;
    private String isRequiredBy;
    private String requires;
    private String isPartOf;
    private String hasPart;
    private String isReferencedBy;
    private String references;
    private String isFormatOf;
    private String hasFormat;

    public String getIdDc() {
        return idDc;
    }

    public void setIdDc(String idDc) {
        this.idDc = idDc;
    }

    public String getIdRelation() {
        return idRelation;
    }

    public void setIdRelation(String idRelation) {
        this.idRelation = idRelation;
    }

    public String getRelation() {
        return relation;
    }

    public void setRelation(String relation) {
        this.relation = relation;
    }

    public String getIsVersionOf() {
        return isVersionOf;
    }

    public void setIsVersionOf(String isVersionOf) {
        this.isVersionOf = isVersionOf;
    }

    public String getHasVersion() {
        return hasVersion;
    }

    public void setHasVersion(String hasVersion) {
        this.hasVersion = hasVersion;
    }

    public String getIsReplacedBy() {
        return isReplacedBy;
    }

    public void setIsReplacedBy(String isReplacedBy) {
        this.isReplacedBy = isReplacedBy;
    }

    public String getIsRequiredBy() {
        return isRequiredBy;
    }

    public void setIsRequiredBy(String isRequiredBy) {
        this.isRequiredBy = isRequiredBy;
    }

    public String getRequires() {
        return requires;
    }

    public void setRequires(String requires) {
        this.requires = requires;
    }

    public String getIsPartOf() {
        return isPartOf;
    }

    public void setIsPartOf(String isPartOf) {
        this.isPartOf = isPartOf;
    }

    public String getHasPart() {
        return hasPart;
    }

    public void setHasPart(String hasPart) {
        this.hasPart = hasPart;
    }

    public String getIsReferencedBy() {
        return isReferencedBy;
    }

    public void setIsReferencedBy(String isReferencedBy) {
        this.isReferencedBy = isReferencedBy;
    }

    public String getReferences() {
        return references;
    }

    public void setReferences(String references) {
        this.references = references;
    }

    public String getIsFormatOf() {
        return isFormatOf;
    }

    public void setIsFormatOf(String isFormatOf) {
        this.isFormatOf = isFormatOf;
    }

    public String getHasFormat() {
        return hasFormat;
    }

    public void setHasFormat(String hasFormat) {
        this.hasFormat = hasFormat;
    }
}
