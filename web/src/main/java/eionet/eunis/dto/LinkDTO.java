package eionet.eunis.dto;


import java.io.Serializable;

import org.simpleframework.xml.Root;


/**
 *
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@Root
public class LinkDTO implements Serializable, Comparable<LinkDTO> {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String name;
    private String url;
    private String description;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public int compareTo(LinkDTO o) {
        return getName().compareTo(o.getName());
    }
}
