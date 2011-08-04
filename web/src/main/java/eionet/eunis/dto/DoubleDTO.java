package eionet.eunis.dto;


import java.io.Serializable;

import org.simpleframework.xml.Root;


/**
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@Root
public class DoubleDTO implements Serializable {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String one;
    private String two;

    public String getOne() {
        return one;
    }
    public void setOne(String one) {
        this.one = one;
    }
    public String getTwo() {
        return two;
    }
    public void setTwo(String two) {
        this.two = two;
    }

}
