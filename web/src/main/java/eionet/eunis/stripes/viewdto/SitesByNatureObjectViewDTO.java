package eionet.eunis.stripes.viewdto;

public class SitesByNatureObjectViewDTO {

    private String IDSite = null;
    private String name = null;
    private String sourceDB = null;
    private String areaNameEn = null;
    private String Latitude = "";
    private String Longitude = "";
    private String areaUrl = "";
    private String siteNameUrl = "";
    private Boolean natura2000 = false;
    
    public String getIDSite() {
        return IDSite;
    }
    public void setIDSite(String iDSite) {
        IDSite = iDSite;
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
        return areaNameEn;
    }
    public void setAreaNameEn(String areaNameEn) {
        this.areaNameEn = areaNameEn;
    }
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
    public String getAreaUrl() {
        return areaUrl;
    }
    public void setAreaUrl(String areaUrl) {
        this.areaUrl = areaUrl;
    }
    public String getSiteNameUrl() {
        return siteNameUrl;
    }
    public void setSiteNameUrl(String siteNameUrl) {
        this.siteNameUrl = siteNameUrl;
    }
    public Boolean getNatura2000() {
        return natura2000;
    }
    public void setNatura2000(Boolean natura2000) {
        this.natura2000 = natura2000;
    }


    
}
