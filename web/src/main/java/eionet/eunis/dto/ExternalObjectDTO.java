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
public class ExternalObjectDTO implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String identifier;
    private String natureObjectId;
    private String specieId;
    private String name;
    private String nameSql;

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNameSql() {
        return nameSql;
    }

    public void setNameSql(String nameSql) {
        this.nameSql = nameSql;
    }

    public String getNatureObjectId() {
        return natureObjectId;
    }

    public void setNatureObjectId(String natureObjectId) {
        this.natureObjectId = natureObjectId;
    }

    public String getSpecieId() {
        return specieId;
    }

    public void setSpecieId(String specieId) {
        this.specieId = specieId;
    }
}
