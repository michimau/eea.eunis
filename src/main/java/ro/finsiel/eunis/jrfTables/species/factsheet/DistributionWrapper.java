package ro.finsiel.eunis.jrfTables.species.factsheet;


import java.util.List;

/**
 * //return distribution status list for a species identified by idNatureObject
 */
public class DistributionWrapper  {
  List distribution;

  /**
   * Constructs an new object with distribution for a species
   * @param id ID_NATURE_OBJECT of the species
   */
  public DistributionWrapper(Integer id) {
    try {
      distribution = new ReportsDistributionStatusDomain().findWhere("ID_NATURE_OBJECT = " + id + " AND (D.LOOKUP_TYPE ='DISTRIBUTION_STATUS' OR D.LOOKUP_TYPE ='GRID') GROUP BY C.NAME,C.LATITUDE,C.LONGITUDE");
    } catch (Exception _ex) {
      _ex.printStackTrace(System.err);
    }
  }


  /**
   * @return distribution list for this species
   */
  public List getDistribution() {
    return distribution;
  }
}







