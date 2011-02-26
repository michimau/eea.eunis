package eionet.eunis.dto;


import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Text;

import ro.finsiel.eunis.search.species.VernacularNameWrapper;


/**
 * @author alex
 *
 * &lt;a href="mailto:aleks21@gmail.com"&gt;contact&lt;a&gt;
 */
@Root (name = "dwc:vernacularName")
public class VernacularNameDto implements Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = 1009968749712710452L;

    @Attribute(required = false, name = "xml:lang")
    private String code;
    @Text(required = false)
    private String value;

    public VernacularNameDto() {}

    public VernacularNameDto(VernacularNameWrapper wrapper) {
        code = wrapper.getLanguageCode();
        value = wrapper.getName();
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

}
