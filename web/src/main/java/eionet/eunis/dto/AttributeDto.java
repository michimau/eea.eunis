package eionet.eunis.dto;


import java.io.Serializable;


/**
 * Dto object to hold species attributes.
 *
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class AttributeDto implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String name;
    private String value;
    private String lang;
    private String type;
    private String label;

    public AttributeDto() {// blank
    }

    public AttributeDto(String name, String type, String value, String label) {
        this.name = name;
        this.type = type;
        this.value = value;
        this.label = label;
    }

    public AttributeDto(String name, String type, String value, String lang, String label) {
        this.name = name;
        this.type = type;
        this.value = value;
        this.lang = lang;
        this.label = label;
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

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }


}

