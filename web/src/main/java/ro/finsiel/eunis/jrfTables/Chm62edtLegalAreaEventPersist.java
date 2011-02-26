package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:50 $
 **/
public class Chm62edtLegalAreaEventPersist extends PersistentObject implements HabitatOtherInfo {

    private Integer idLegalAreaEvent = null;
    private String name = null;
    private String description = null;

    public Integer getIdLegalAreaEvent() {
        return idLegalAreaEvent;
    }

    public void setIdLegalAreaEvent(Integer idLegalAreaEvent) {
        this.idLegalAreaEvent = idLegalAreaEvent;
        this.forceNewPersistentState();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.markModifiedPersistentState();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
        this.markModifiedPersistentState();
    }

    public Chm62edtLegalAreaEventPersist() {
        super();
    }

}
