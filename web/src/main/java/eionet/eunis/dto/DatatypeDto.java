package eionet.eunis.dto;


import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Text;


/**
 * Datatype dto for rdf exporting.
 * 
 * @author altnyris
 */
@Root
public class DatatypeDto implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    @Text(required = false)
    private String value;
    @Attribute(required = false, name = "rdf:datatype")
    private String type;

    public DatatypeDto() {// blank
    }

    /**
     * @param value
     * @param type
     */
    public DatatypeDto(Short value, String type) {
        setValue(value);
        this.type = type;
    }
    
    /**
     * @return value
     */
    public String getValue() {
        return value;
    }

    /**
     * @param value
     */
    public void setValue(Short value) {
        if (value != null && value == 1) {
            this.value = "true";
        } else {
            this.value = "false";
        }
    }

    /**
     * @return type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type
     */
    public void setType(String type) {
        this.type = type;
    }

}
