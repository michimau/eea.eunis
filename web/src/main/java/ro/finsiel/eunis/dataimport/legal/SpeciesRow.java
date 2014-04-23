package ro.finsiel.eunis.dataimport.legal;

import java.util.Arrays;

public class SpeciesRow {
    private String speciesName;

    private String habitatsD;
    private String habitatsIIPriority;
    private String habitatsRestrictions;
    private String habitatsName;

    private String birdsD;
    private String birdsName;

    private String bernConvention;
    private String bernRestrictions;
    private String bernName;

    private String emeraldR6;
    private String emeraldRestrictions;
    private String emeraldName;

    private String bonnConvention;
    private String bonnRestrictions;
    private String bonnName;

    private String cites;
    private String euTrade;
    private String aewa;
    private String eurobats;
    private String accobams;
    private String ascobams;
    private String wadden;
    private String spa;
    private String ospar;
    private String helcom;
    private String redList;
    private String redListName;

    private String idSpecies;
    private String idNatureObject;

    private String[] habitatsDAnnex;
    private String[] birdsDAnnex;
    private String[] bernConventionAnnex;
    private String[] bonnConventionAnnex;
    private String[] citesAnnex;
    private String[] euTradeAnnex;

    public String[] getEuTradeAnnex() {
        return euTradeAnnex;
    }

    public String[] getCitesAnnex() {
        return citesAnnex;
    }

    public String[] getBonnConventionAnnex() {
        return bonnConventionAnnex;
    }

    public String[] getBernConventionAnnex() {
        return bernConventionAnnex;
    }

    public boolean isSpecies(){
        return speciesName != null
            && speciesName.contains(" ")
            && !(speciesName.contains("("));
    }

    public String getSpeciesName() {
        return speciesName;
    }

    public void setSpeciesName(String speciesName) {
        this.speciesName = speciesName;
    }

    public String getHabitatsD() {
        return habitatsD;
    }

    public void setHabitatsD(String habitatsD) {
        this.habitatsD = habitatsD;
        habitatsDAnnex = explode(habitatsD, ",");
    }

    private String[] explode(String list, String separator){
        String[] exploded = list.split(separator);

        for(int i=0;i<exploded.length;i++){
            exploded[i] = exploded[i].trim();
        }
        return exploded;
    }

    public String[] getHabitatsDAnnex() {
        return habitatsDAnnex;
    }

    public String getHabitatsIIPriority() {
        return habitatsIIPriority;
    }

    public void setHabitatsIIPriority(String habitatsIIPriority) {
        this.habitatsIIPriority = habitatsIIPriority;
    }

    public String getHabitatsRestrictions() {
        return habitatsRestrictions;
    }

    public void setHabitatsRestrictions(String habitatsRestrictions) {
        this.habitatsRestrictions = habitatsRestrictions;
    }

    public String getHabitatsName() {
        return habitatsName;
    }

    public void setHabitatsName(String habitatsName) {
        this.habitatsName = habitatsName;
    }

    public String getBirdsD() {
        return birdsD;
    }

    public void setBirdsD(String birdsD) {
        this.birdsD = birdsD;
        birdsDAnnex = explode(birdsD,",");
    }

    public String[] getBirdsDAnnex() {
        return birdsDAnnex;
    }

    public String getBirdsName() {
        return birdsName;
    }

    public void setBirdsName(String birdsName) {
        this.birdsName = birdsName;
    }

    public String getBernConvention() {
        return bernConvention;
    }

    public void setBernConvention(String bernConvention) {
        this.bernConvention = bernConvention;
        bernConventionAnnex = explode(bernConvention, ",");
    }

    public String getBernRestrictions() {
        return bernRestrictions;
    }

    public void setBernRestrictions(String bernRestrictions) {
        this.bernRestrictions = bernRestrictions;
    }

    public String getBernName() {
        return bernName;
    }

    public void setBernName(String bernName) {
        this.bernName = bernName;
    }

    public String getEmeraldR6() {
        return emeraldR6;
    }

    public void setEmeraldR6(String emeraldR6) {
        this.emeraldR6 = emeraldR6;
    }

    public String getEmeraldRestrictions() {
        return emeraldRestrictions;
    }

    public void setEmeraldRestrictions(String emeraldRestrictions) {
        this.emeraldRestrictions = emeraldRestrictions;
    }

    public String getEmeraldName() {
        return emeraldName;
    }

    public void setEmeraldName(String emeraldName) {
        this.emeraldName = emeraldName;
    }

    public String getBonnConvention() {
        return bonnConvention;
    }

    public void setBonnConvention(String bonnConvention) {
        this.bonnConvention = bonnConvention;
        bonnConventionAnnex = explode(bonnConvention, ",");
    }

    public String getBonnRestrictions() {
        return bonnRestrictions;
    }

    public void setBonnRestrictions(String bonnRestrictions) {
        this.bonnRestrictions = bonnRestrictions;
    }

    public String getBonnName() {
        return bonnName;
    }

    public void setBonnName(String bonnName) {
        this.bonnName = bonnName;
    }

    public String getCites() {
        return cites;
    }

    public void setCites(String cites) {
        this.cites = cites;
        citesAnnex = explode(cites, ",");
    }

    public String getEuTrade() {
        return euTrade;
    }

    public void setEuTrade(String euTrade) {
        this.euTrade = euTrade;
        euTradeAnnex = explode(euTrade, ",");
    }

    public String getAewa() {
        return aewa;
    }

    public void setAewa(String aewa) {
        this.aewa = aewa;
    }

    public String getEurobats() {
        return eurobats;
    }

    public void setEurobats(String eurobats) {
        this.eurobats = eurobats;
    }

    public String getAccobams() {
        return accobams;
    }

    public void setAccobams(String accobams) {
        this.accobams = accobams;
    }

    public String getAscobams() {
        return ascobams;
    }

    public void setAscobams(String ascobams) {
        this.ascobams = ascobams;
    }

    public String getWadden() {
        return wadden;
    }

    public void setWadden(String wadden) {
        this.wadden = wadden;
    }

    public String getSpa() {
        return spa;
    }

    public void setSpa(String spa) {
        this.spa = spa;
    }

    public String getOspar() {
        return ospar;
    }

    public void setOspar(String ospar) {
        this.ospar = ospar;
    }

    public String getHelcom() {
        return helcom;
    }

    public void setHelcom(String helcom) {
        this.helcom = helcom;
    }

    public String getRedList() {
        return redList;
    }

    public void setRedList(String redList) {
        this.redList = redList;
    }

    public String getRedListName() {
        return redListName;
    }

    public void setRedListName(String redListName) {
        this.redListName = redListName;
    }

    public String getIdNatureObject() {
        return idNatureObject;
    }

    public void setIdNatureObject(String idNatureObject) {
        this.idNatureObject = idNatureObject;
    }

    public String getIdSpecies() {
        return idSpecies;
    }

    public void setIdSpecies(String idSpecies) {
        this.idSpecies = idSpecies;
    }

    public String toInitialString() {
        return "SpeciesRow{" +
                "speciesName='" + speciesName + '\'' +
                ", habitatsD='" + habitatsD + '\'' +
                ", habitatsIIPriority='" + habitatsIIPriority + '\'' +
                ", habitatsRestrictions='" + habitatsRestrictions + '\'' +
                ", habitatsName='" + habitatsName + '\'' +
                ", birdsD='" + birdsD + '\'' +
                ", birdsName='" + birdsName + '\'' +
                ", bernConvention='" + bernConvention + '\'' +
                ", bernRestrictions='" + bernRestrictions + '\'' +
                ", bernName='" + bernName + '\'' +
                ", emeraldR6='" + emeraldR6 + '\'' +
                ", emeraldRestrictions='" + emeraldRestrictions + '\'' +
                ", emeraldName='" + emeraldName + '\'' +
                ", bonnConvention='" + bonnConvention + '\'' +
                ", bonnRestrictions='" + bonnRestrictions + '\'' +
                ", bonnName='" + bonnName + '\'' +
                ", cites='" + cites + '\'' +
                ", euTrade='" + euTrade + '\'' +
                ", aewa='" + aewa + '\'' +
                ", eurobats='" + eurobats + '\'' +
                ", accobams='" + accobams + '\'' +
                ", ascobams='" + ascobams + '\'' +
                ", wadden='" + wadden + '\'' +
                ", spa='" + spa + '\'' +
                ", ospar='" + ospar + '\'' +
                ", helcom='" + helcom + '\'' +
                ", redList='" + redList + '\'' +
                ", redListName='" + redListName + '\'' +
                '}';
    }

    public String toAnnexString() {
        return "SpeciesRow{" +
                "habitatsDAnnex=" + (habitatsDAnnex == null ? null : Arrays.asList(habitatsDAnnex)) +
                ", birdsDAnnex=" + (birdsDAnnex == null ? null : Arrays.asList(birdsDAnnex)) +
                ", bernConventionAnnex=" + (bernConventionAnnex == null ? null : Arrays.asList(bernConventionAnnex)) +
                ", bonnConventionAnnex=" + (bonnConventionAnnex == null ? null : Arrays.asList(bonnConventionAnnex)) +
                ", citesAnnex=" + (citesAnnex == null ? null : Arrays.asList(citesAnnex)) +
                ", euTradeAnnex=" + (euTradeAnnex == null ? null : Arrays.asList(euTradeAnnex)) +
                '}';
    }

    @Override
    public String toString() {
        return "SpeciesRow{" +
                "speciesName='" + speciesName + '\'' +
                ", habitatsD='" + habitatsD + '\'' +
                ", habitatsIIPriority='" + habitatsIIPriority + '\'' +
                ", habitatsRestrictions='" + habitatsRestrictions + '\'' +
                ", habitatsName='" + habitatsName + '\'' +
                ", birdsD='" + birdsD + '\'' +
                ", birdsName='" + birdsName + '\'' +
                ", bernConvention='" + bernConvention + '\'' +
                ", bernRestrictions='" + bernRestrictions + '\'' +
                ", bernName='" + bernName + '\'' +
                ", emeraldR6='" + emeraldR6 + '\'' +
                ", emeraldRestrictions='" + emeraldRestrictions + '\'' +
                ", emeraldName='" + emeraldName + '\'' +
                ", bonnConvention='" + bonnConvention + '\'' +
                ", bonnRestrictions='" + bonnRestrictions + '\'' +
                ", bonnName='" + bonnName + '\'' +
                ", cites='" + cites + '\'' +
                ", euTrade='" + euTrade + '\'' +
                ", aewa='" + aewa + '\'' +
                ", eurobats='" + eurobats + '\'' +
                ", accobams='" + accobams + '\'' +
                ", ascobams='" + ascobams + '\'' +
                ", wadden='" + wadden + '\'' +
                ", spa='" + spa + '\'' +
                ", ospar='" + ospar + '\'' +
                ", helcom='" + helcom + '\'' +
                ", redList='" + redList + '\'' +
                ", redListName='" + redListName + '\'' +
                ", habitatsDAnnex=" + (habitatsDAnnex == null ? null : Arrays.asList(habitatsDAnnex)) +
                ", birdsDAnnex=" + (birdsDAnnex == null ? null : Arrays.asList(birdsDAnnex)) +
                ", bernConventionAnnex=" + (bernConventionAnnex == null ? null : Arrays.asList(bernConventionAnnex)) +
                ", bonnConventionAnnex=" + (bonnConventionAnnex == null ? null : Arrays.asList(bonnConventionAnnex)) +
                ", citesAnnex=" + (citesAnnex == null ? null : Arrays.asList(citesAnnex)) +
                ", euTradeAnnex=" + (euTradeAnnex == null ? null : Arrays.asList(euTradeAnnex)) +
                '}';
    }
}
