package ro.finsiel.eunis.jrfTables.species.factsheet;

import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:13 $
 **/
public class ReportsDistributionStatusPersist extends PersistentObject {
  private Integer IdNatureObject = null;
  private Integer IdNatureObjectLink = null;
  private Integer IdReportType = null;
  private Integer IdReportAttributes = null;

  public Integer getIdNatureObject() {
    return IdNatureObject;
  }

  public void setIdNatureObject(Integer idNatureObject) {
    IdNatureObject = idNatureObject;
  }

  public Integer getIdNatureObjectLink() {
    return IdNatureObjectLink;
  }

  public void setIdNatureObjectLink(Integer idNatureObjectLink) {
    IdNatureObjectLink = idNatureObjectLink;
  }

  public Integer getIdReportType() {
    return IdReportType;
  }

  public void setIdReportType(Integer idReportType) {
    IdReportType = idReportType;
  }

  public Integer getIdReportAttributes() {
    return IdReportAttributes;
  }

  public void setIdReportAttributes(Integer idReportAttributes) {
    IdReportAttributes = idReportAttributes;
  }

  public String getLookupTypeGrid() {
    return LookupTypeGrid;
  }

  public void setLookupTypeGrid(String lookupTypeGrid) {
    LookupTypeGrid = lookupTypeGrid;
  }

  public String getLookupTypeDist() {
    return LookupTypeDist;
  }

  public void setLookupTypeDist(String lookupTypeDist) {
    LookupTypeDist = lookupTypeDist;
  }

  public String getIdLookupGrid() {
    return IdLookupGrid;
  }

  public void setIdLookupGrid(String idLookupGrid) {
    IdLookupGrid = idLookupGrid;
  }

  public String getIdLookupDist() {
    return IdLookupDist;
  }

  public void setIdLookupDist(String idLookupDist) {
    IdLookupDist = idLookupDist;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Double getLongitude() {
    if (null == Longitude) return new Double(0);
    return Longitude;
  }

  public void setLongitude(Double longitude) {
    Longitude = longitude;
  }

  public Double getLatitude() {
    if (null == Latitude) return new Double(0);
    return Latitude;
  }

  public void setLatitude(Double latitude) {
    Latitude = latitude;
  }

  public Integer getIdDc() {
    return IdDc;
  }

  public void setIdDc(Integer idDc) {
    IdDc = idDc;
  }

  public String getDistributionStatus() {
    return DistributionStatus;
  }

  public void setDistributionStatus(String distributionStatus) {
    DistributionStatus = distributionStatus;
  }

  private String LookupTypeGrid = null;
  private String LookupTypeDist = null;
  private String IdLookupGrid = null;
  private String IdLookupDist = null;
  private String name = null;
  private Double Longitude = null;
  private Double Latitude = null;
  private Integer IdDc = null;
  private String DistributionStatus = null;

  public ReportsDistributionStatusPersist() {
    super();
  }

}
