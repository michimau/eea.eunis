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
    private boolean literal;
    private String value;

    public AttributeDto() {// blank
    }

    public AttributeDto(String name, boolean literal, String value) {
        this.name = name;
        this.literal = literal;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isLiteral() {
        return literal;
    }

    public void setLiteral(boolean literal) {
        this.literal = literal;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}

