package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


public class Chm62edtHabitatReferencePersist extends PersistentObject {

    private String source = null;
    private String title = null;
    private String haveSource = null;
    private String haveRef = null;
	
    private Integer idHabitat = null;
    private Integer idDc = null;

    public Chm62edtHabitatReferencePersist() {
        super();
    }
	
    public Integer getIdDc() {
        return idDc;
    }
	
    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
    }

    public String getSource() {
        return source;
    }
	
    public void setSource(String source) {
        this.source = source;
    }
	
    public String getTitle() {
        return title;
    }
	
    public void setTitle(String title) {
        this.title = title;
    }
	
    public String getHaveSource() {
        return haveSource;
    }
	
    public void setHaveSource(String haveSource) {
        this.haveSource = haveSource;
    }
	
    public String getHaveRef() {
        return haveRef;
    }
	
    public void setHaveRef(String haveRef) {
        this.haveRef = haveRef;
    }

    public Integer getIdHabitat() {
        return idHabitat;
    }

    public void setIdHabitat(Integer idHabitat) {
        this.idHabitat = idHabitat;
    }

}
