package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.domain.PersistentObject;


 /**
 * Date: Oct 2, 2003
 * Time: 1:32:55 PM
 */
public class SitesByNatureObjectPersist extends PersistentObject {
    private String IDSite = null;
    private String name = null;
    private String sourceDB = null;
    private String areaNameEn = null;
    private String Latitude = "";
    private String Longitude = "";

    public String getLatitude() {
        return Latitude;
    }

    public void setLatitude(String latitude) {
        Latitude = latitude;
    }

    public String getLongitude() {
        return Longitude;
    }

    public void setLongitude(String longitude) {
        Longitude = longitude;
    }

    public String getIDSite() {
        return IDSite;
    }

    public void setIDSite(String IDSite) {
        this.IDSite = IDSite;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSourceDB() {
        return sourceDB;
    }

    public void setSourceDB(String sourceDB) {
        this.sourceDB = sourceDB;
    }

    public String getAreaNameEn() {
        if (areaNameEn == null) {
            return "";
        }
        return areaNameEn;
    }

    public void setAreaNameEn(String areaNameEn) {
        this.areaNameEn = areaNameEn;
    }
}
