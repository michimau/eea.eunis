package ro.finsiel.eunis.search.species.taxcode;

/**
 * User: cromanescu
 * Date: Jan 31, 2006
 * Time: 12:29:30 PM
 */
public class TaxonomyTreeBean
{
  private String idTaxonomy = null;
  private int level = 0;

  public String getIdTaxonomy()
  {
    return idTaxonomy;
  }

  public void setIdTaxonomy( String idTaxonomy )
  {
    this.idTaxonomy = idTaxonomy;
  }

  public int getLevel()
  {
    return level;
  }

  public void setLevel( int level )
  {
    this.level = level;
  }
}
