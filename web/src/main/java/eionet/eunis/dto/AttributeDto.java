package eionet.eunis.dto;


import java.io.Serializable;

import org.simpleframework.xml.Root;
import org.simpleframework.xml.convert.Convert;


/**
 * Dto object to hold species attributes.
 * 
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
@Root
@Convert(AttributeConverter.class)
public class AttributeDto implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String name;
    private String value;
    private String type;

    public AttributeDto() {// blank
    }

    public AttributeDto(String name, String type, String value) {
        this.name = name;
        this.type = type;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}

