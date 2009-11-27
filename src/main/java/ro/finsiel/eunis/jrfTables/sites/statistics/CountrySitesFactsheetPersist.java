package ro.finsiel.eunis.jrfTables.sites.statistics;

/**
 * Date: Jul 24, 2003
 * Time: 4:53:56 PM
 */


import net.sf.jrf.domain.PersistentObject;


public class CountrySitesFactsheetPersist extends PersistentObject {


  private String sourceDB = null;
  private String country = null;
  private String NumberOfSites = null;
  private String NumberOfSpecies = null;
  private String NumberOfHabitats = null;
  private String PerSquare = null;
  private String SurfaceAvailable = null;
  private String TotalSize = null;
  private String AvgSize = null;
  private String NoPriority = null;
  private String TotalPriority = null;
  private String Deviation = null;


  public CountrySitesFactsheetPersist() {
    super();
  }


  public void setSourceDB(String sourceDB) {
    this.sourceDB = sourceDB;
  }

  public String getSourceDB() {
    return sourceDB;
  }

  public void setCountry(String sourceDB) {
    this.country = sourceDB;
  }

  public String getCountry() {
    return country;
  }

  public void setNumberOfSites(String sourceDB) {
    this.NumberOfSites = sourceDB;
  }

  public String getNumberOfSites() {
    return NumberOfSites;
  }

  public void setPerSquare(String sourceDB) {
    this.PerSquare = sourceDB;
  }

  public String getPerSquare() {
    return PerSquare;
  }

  public void setSurfaceAvailable(String sourceDB) {
    this.SurfaceAvailable = sourceDB;
  }

  public String getSurfaceAvailable() {
    return SurfaceAvailable;
  }

  public void setTotalSize(String sourceDB) {
    this.TotalSize = sourceDB;
  }

  public String getTotalSize() {
    return TotalSize;
  }

  public void setAvgSize(String sourceDB) {
    this.AvgSize = sourceDB;
  }

  public String getAvgSize() {
    return AvgSize;
  }

  public void setNoPriority(String sourceDB) {
    this.NoPriority = sourceDB;
  }

  public String getNoPriority() {
    return NoPriority;
  }

  public void setTotalPriority(String sourceDB) {
    this.TotalPriority = sourceDB;
  }

  public String getTotalPriority() {
    return TotalPriority;
  }

  public void setDeviation(String sourceDB) {
    this.Deviation = sourceDB;
  }

  public String getDeviation() {
    return Deviation;
  }

  public String getNumberOfSpecies() {
    return NumberOfSpecies;
  }

  public void setNumberOfSpecies(String numberOfSpecies) {
    NumberOfSpecies = numberOfSpecies;
  }

  public String getNumberOfHabitats() {
    return NumberOfHabitats;
  }

  public void setNumberOfHabitats(String numberOfHabitats) {
    NumberOfHabitats = numberOfHabitats;
  }
}
