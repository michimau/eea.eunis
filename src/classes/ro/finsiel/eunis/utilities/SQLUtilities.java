package ro.finsiel.eunis.utilities;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import ro.finsiel.eunis.dataimport.ColumnDTO;


/**
 * Created by IntelliJ IDEA.
 * User: ancai
 * Date: 03.03.2005
 * Time: 15:35:37
 * To change this template use File | Settings | File Templates.
 */
public class SQLUtilities {
  private String SQL_DRV = "";
  private String SQL_URL = "";
  private String SQL_USR = "";
  private String SQL_PWD = "";
  private int SQL_LIMIT = 1000;
  private int resultCount = 0;
  private static final String INSERT_BOOKMARK = "INSERT INTO EUNIS_BOOKMARKS( USERNAME, BOOKMARK, DESCRIPTION ) VALUES( ?, ?, ?)";

  /**
   * SQL used for soundex search
   */
  public static String smartSoundex = "" +
    " select name,phonetic,object_type" +
    " from `chm62edt_soundex`" +
    " where object_type = '<object_type>'" +
    " and phonetic = soundex('<name>')" +
    " and left(name,6) = left('<name>',6)" +
    " union" +
    " select name,phonetic,object_type" +
    " from `chm62edt_soundex`" +
    " where object_type = '<object_type>'" +
    " and phonetic = soundex('<name>')" +
    " and left(name,5) = left('<name>',5)" +
    " union" +
    " select name,phonetic,object_type" +
    " from `chm62edt_soundex`" +
    " where object_type = '<object_type>'" +
    " and phonetic = soundex('<name>')" +
    " and left(name,4) = left('<name>',4)" +
    " union" +
    " select name,phonetic,object_type" +
    " from `chm62edt_soundex`" +
    " where object_type = '<object_type>'" +
    " and phonetic = soundex('<name>')" +
    " and left(name,3) = left('<name>',3)" +
    " union" +
    " select name,phonetic,object_type" +
    " from `chm62edt_soundex`" +
    " where object_type = '<object_type>'" +
    " and phonetic = soundex('<name>')" +
    " and left(name,2) = left('<name>',2)" +
    " union" +
    " select name,phonetic,object_type" +
    " from `chm62edt_soundex`" +
    " where object_type = '<object_type>'" +
    " and left(phonetic,3) = left(soundex('<name>'),3)";

  /**
   * Creates a new SQLUtilities object.
   */
  public SQLUtilities() {
  }

  /**
   * Initialization method for this object.
   *
   * @param SQL_DRIVER_NAME     JDBC driver.
   * @param SQL_DRIVER_URL      JDBC url.
   * @param SQL_DRIVER_USERNAME JDBC username.
   * @param SQL_DRIVER_PASSWORD JDBC password.
   */
  public void Init( String SQL_DRIVER_NAME, String SQL_DRIVER_URL,
                    String SQL_DRIVER_USERNAME, String SQL_DRIVER_PASSWORD ) {
    SQL_DRV = SQL_DRIVER_NAME;
    SQL_URL = SQL_DRIVER_URL;
    SQL_USR = SQL_DRIVER_USERNAME;
    SQL_PWD = SQL_DRIVER_PASSWORD;
  }

  /**
   * Limit the results computed.
   *
   * @param SQLLimit Limit.
   */
  public void SetSQLLimit( int SQLLimit ) {
    SQL_LIMIT = SQLLimit;
  }

  /**
   * Execute an sql.
   *
   * @param SQL       SQL.
   * @param Delimiter LIMIT
   * @return result
   */
  public String ExecuteFilterSQL( String SQL, String Delimiter ) {

    if ( SQL == null || Delimiter == null || SQL.trim().length() <= 0 )
    {
      return "";
    }

    String result = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      resultCount = 0;

      ps = con.prepareStatement( SQL );
      rs = ps.executeQuery();
      result = "";
      while ( rs.next() )
      {
        resultCount++;
        if ( resultCount <= SQL_LIMIT )
        {
          result += Delimiter + rs.getString( 1 ) + Delimiter;
          result += ",";
        }
      }

      if ( result.length() > 0 )
      {
        if ( result.substring( result.length() - 1 ).equalsIgnoreCase( "," ) )
        {
          result = result.substring( 0, result.length() - 1 );
        }
      }

    }
    catch ( Exception e )
    {
      e.printStackTrace();
      return "";
    }
    finally
    {
      closeAll( con, ps, rs );
    }

    return result;
  }

  /**
   * Executes a SELECT sql and returns the first value.
   *
   * @param SQL SQL.
   * @return First column.
   */
  public ArrayList<String> SQL2Array( String SQL ) {

    if ( SQL == null || SQL.trim().length() <= 0 )
    {
      return null;
    }

    ArrayList<String> result = new ArrayList<String>();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( SQL );
      rs = ps.executeQuery();

      while ( rs.next() )
      {
        result.add(rs.getString( 1 ));
      }

      closeAll( con, ps, rs );
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      return null;
    }
    finally
    {
      closeAll( con, ps, rs );
    }

    return result;
  }

  /**
   * Executes a SELECT sql and returns the first value.
   *
   * @param SQL SQL.
   * @return First column.
   */
  public String ExecuteSQL( String SQL ) {

    if ( SQL == null || SQL.trim().length() <= 0 )
    {
      return "";
    }

    //System.out.println("SQL = " + SQL);
    
    String result = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( SQL );
      rs = ps.executeQuery();

      if ( rs.next() )
      {
        result = rs.getString( 1 );
      }

    }
    catch ( Exception e )
    {
      e.printStackTrace();
      return "";
    }
    finally
    {
      closeAll( con, ps, rs );
    }

    return result;
  }

  /**
   * Executes a sql.
   *
   * @param SQL SQL.
   */
  public void ExecuteDirectSQL( String SQL ) {

    if ( SQL == null || SQL.trim().length() <= 0 )
    {
      return;
    }

    Connection con = null;
    PreparedStatement ps = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( SQL );
      ps.execute();
    }
    catch ( Exception e )
    {
      e.printStackTrace();
    }
    finally
    {
      try
      {
        ps.close();
        con.close();
      }
      catch ( Exception ex )
      {
      }
    }
  }

  /**
   * Execute an sql.
   *
   * @param SQL       SQL.
   * @param noColumns Number of columns
   * @return list of sql results.
   */
  public List ExecuteSQLReturnList( String SQL, int noColumns ) {

    if ( SQL == null || SQL.trim().length() <= 0 || noColumns <= 0 )
    {
      return new ArrayList();
    }

    List result = new ArrayList();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( SQL );
      rs = ps.executeQuery();

      while ( rs.next() )
      {
        TableColumns columns = new TableColumns();
        List columnsValues = new ArrayList();
        for ( int i = 1; i <= noColumns; i++ )
        {
          columnsValues.add( rs.getString( i ) );
        }
        columns.setColumnsValues( columnsValues );
        result.add( columns );
      }
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      return new ArrayList();
    }
    finally
    {
      closeAll( con, ps, rs );
    }
    return result;
  }

  /**
   * Count search results.
   *
   * @return reusults count.
   */
  public int getResultCount() {
    return resultCount;
  }

  /**
   * Execute UPDATE statement
   * @param tableName table name
   * @param columnName column update
   * @param columnValue new value for column
   * @param whereCondition WHERE condition
   * @return operation status
   */
  public boolean ExecuteUpdate( String tableName, String columnName, String columnValue, String whereCondition ) {

    boolean result = true;

    Connection con = null;
    PreparedStatement ps = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( "UPDATE " + tableName
        + " SET " + columnName + " = '" + columnValue + "' WHERE 1=1" + ( whereCondition == null && whereCondition.trim().length() <= 0 ? "" : " AND " + whereCondition ) );
      ps.execute();
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      result = false;
    }
    finally
    {
      closeAll( con, ps, null );
    }
    return result;
  }

  /**
   * Execute DELETE statement
   *
   * @param tableName      table name
   * @param whereCondition WHERE
   * @return operation status
   */
  public boolean ExecuteDelete( String tableName, String whereCondition ) {

    boolean result = true;

    Connection con = null;
    PreparedStatement ps = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( "DELETE FROM " + tableName
        + " WHERE 1=1" + ( whereCondition == null || whereCondition.trim().length() <= 0 ? "" : " AND " + whereCondition ) );
      ps.execute();
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      result = false;
    }
    finally
    {
      closeAll( con, ps, null );
    }
    return result;
  }

  /**
   * Insert bookmark functionality
   * @param username username associated with that bookmark
   * @param bookmarkURL URL
   * @param description Short description displayed to the user
   * @return operation status
   */
  public boolean insertBookmark( String username, String bookmarkURL, String description ) {
    boolean result = false;

    Connection con = null;
    PreparedStatement ps = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );
      ps = con.prepareStatement( INSERT_BOOKMARK );
      ps.setString( 1, username );
      ps.setString( 2, bookmarkURL );
      ps.setString( 3, description );
      ps.execute();
      result = true;
    }
    catch ( Exception e )
    {
      e.printStackTrace();
    }
    finally
    {
      closeAll( con, ps, null );
    }
    return result;
  }

  /**
   * Execute INSERT statement
   *
   * @param tableName    table name
   * @param tableColumns columns
   * @return operation status
   */
  public boolean ExecuteInsert( String tableName, TableColumns tableColumns ) {

    if ( tableName == null || tableName.trim().length() <= 0 || tableColumns == null
      || tableColumns.getColumnsNames() == null || tableColumns.getColumnsNames().size() <= 0
      || tableColumns.getColumnsValues() == null || tableColumns.getColumnsValues().size() <= 0 )
    {
      return false;
    }

    boolean result = true;

    Connection con = null;
    PreparedStatement ps = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      String namesList = "";
      String valuesList = "";
      for ( int i = 0; i < tableColumns.getColumnsNames().size(); i++ )
      {
        namesList += ( String ) tableColumns.getColumnsNames().get( i ) + ( i < tableColumns.getColumnsNames().size() - 1 ? "," : "" );
        valuesList += "'" + ( String ) tableColumns.getColumnsValues().get( i ) + "'" + ( i < tableColumns.getColumnsNames().size() - 1 ? "," : "" );
      }

      ps = con.prepareStatement( "INSERT INTO " + tableName
        + " ( " + namesList + " ) values ( " + valuesList + " ) " );

      ps.execute();
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      result = false;
    }
    finally
    {
      closeAll( con, ps, null );
    }
    return result;
  }
  
  /**
   * Execute INSERT statement
   *
   * @param tableName    table name
   * @param tableColumns columns
   * @return operation status
   */
  public boolean ExecuteMultipleInsert( String tableName, List<TableColumns> tableRows ) throws Exception {

    if ( tableName == null || tableName.trim().length() <= 0 || tableRows == null || tableRows.size() <= 0)
    {
      return false;
    }

    boolean result = true;

    Connection con = null;
    PreparedStatement ps = null;

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );
      
      for(Iterator<TableColumns> it = tableRows.iterator(); it.hasNext();){
    	  
    	  TableColumns tableColumns = it.next();
    	  String namesList = "";
    	  String valuesList = "";
    	  
    	  for ( int i = 0; i < tableColumns.getColumnsNames().size(); i++ ){
    		  namesList += ( String ) tableColumns.getColumnsNames().get( i ) + ( i < tableColumns.getColumnsNames().size() - 1 ? "," : "" );
    		  valuesList += "'" + ( String ) tableColumns.getColumnsValues().get( i ) + "'" + ( i < tableColumns.getColumnsNames().size() - 1 ? "," : "" );
    	  }

    	  ps = con.prepareStatement( "INSERT INTO " + tableName + " ( " + namesList + " ) values ( " + valuesList + " ) " );
    	  ps.execute();
      }
    }
    catch ( Exception e )
    {
    	throw(e);
    }
    finally
    {
      closeAll( con, ps, null );
    }
    return result;
  }

  /**
   * Determines if a factsheet page will be displayed
   * @param idNatureObject object from database
   * @param NatureObjectType type of object (species, habitats, sites)
   * @param TabPageName Tab page name (see factsheets JSP pages for available values)
   * @return Boolean show/hide tab page in factsheet
   */
  public boolean TabPageIsEmpy( String idNatureObject, String NatureObjectType, String TabPageName ) {

    boolean ret = true;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String SQL = "SELECT ";
    SQL += "`" + TabPageName + "`";
    SQL += " FROM CHM62EDT_TAB_PAGE_" + NatureObjectType.toUpperCase();
    SQL += " WHERE ID_NATURE_OBJECT=" + idNatureObject;

    //System.out.println("SQL = " + SQL);
    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( SQL );
      rs = ps.executeQuery();

      if ( rs.next() )
      {
        ret = !rs.getString( TabPageName ).equalsIgnoreCase( "Y" );
        if(ret && TabPageName.equalsIgnoreCase("LEGAL_INSTRUMENTS"))
        {
          //search if we have legal instruments for synonyms
          String idNatureObjectLink = "";
          String idSpecies = "";

          SQL = "SELECT ID_SPECIES";
          SQL += " FROM CHM62EDT_SPECIES";
          SQL += " WHERE ID_NATURE_OBJECT = " + idNatureObject;
          //System.out.println("SQL = " + SQL);
          rs.close();
          ps.close();
          ps = con.prepareStatement( SQL );
          rs = ps.executeQuery();
          if ( rs.next() )
          {
            idSpecies = rs.getString(1);
            //System.out.println("idSpecies = " + idSpecies);
            SQL = "SELECT ID_NATURE_OBJECT";
            SQL += " FROM CHM62EDT_SPECIES";
            SQL += " WHERE ID_SPECIES_LINK = " + idSpecies;
            //System.out.println("SQL = " + SQL);
            rs.close();
            ps.close();
            ps = con.prepareStatement( SQL );
            rs = ps.executeQuery();

            if ( rs.next() )
            {
              idNatureObjectLink = rs.getString(1);
              //System.out.println("idNatureObjectLink = " + idNatureObjectLink);
              SQL = "SELECT ";
              SQL += "`" + TabPageName + "`";
              SQL += " FROM CHM62EDT_TAB_PAGE_" + NatureObjectType.toUpperCase();
              SQL += " WHERE ID_NATURE_OBJECT=" + idNatureObjectLink;

              rs.close();
              ps.close();
              ps = con.prepareStatement( SQL );
              rs = ps.executeQuery();

              if ( rs.next() )
              {
                ret = !rs.getString( TabPageName ).equalsIgnoreCase( "Y" );
              } else {
              rs.close();
              ps.close();
              }
            } else {
              rs.close();
              ps.close();
            }
          } else {
            rs.close();
            ps.close();
          }
        }
      }
    }
    catch ( Exception e )
    {
      //e.printStackTrace();
    }
    finally
    {
      closeAll( con, ps, rs );
    }

    return ret;
    //quick hack to display all tabs in factsheet
    //return false;
  }

  private void closeAll( Connection con, PreparedStatement ps, ResultSet rs ) {
    try
    {
      if ( rs != null )
      {
        rs.close();
      }
      if ( ps != null )
      {
        ps.close();
      }
      if ( con != null )
      {
        con.close();
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
  }

  public boolean DesignationHasSites(String idDesignation, String idGeoscope) {
    boolean result = false;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String strSQL = "SELECT SOURCE_DB, COUNT(*) AS RECORD_COUNT";
    strSQL = strSQL + " FROM `chm62edt_sites`";
    strSQL = strSQL + " INNER JOIN `chm62edt_designations` ON (`chm62edt_sites`.ID_DESIGNATION = `chm62edt_designations`.ID_DESIGNATION AND `chm62edt_sites`.ID_GEOSCOPE = `chm62edt_designations`.ID_GEOSCOPE)";
    strSQL = strSQL + " WHERE `chm62edt_sites`.ID_DESIGNATION = '" + idDesignation + "'";
    strSQL = strSQL + " AND `chm62edt_sites`.ID_GEOSCOPE = " + idGeoscope;
    strSQL = strSQL + " GROUP BY `chm62edt_sites`.ID_DESIGNATION, `chm62edt_sites`.ID_GEOSCOPE";
    strSQL = strSQL + " ORDER BY SOURCE_DB ASC";

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( strSQL );
      rs = ps.executeQuery();

      if ( rs.next() )
      {
        result = true;
      }
      con.close();
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }

    return result;
  }

  public boolean EunisHabitatHasChilds(String idCode) {
    boolean result = false;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String strSQL = "SELECT ID_HABITAT";
    strSQL = strSQL + " FROM CHM62EDT_HABITAT";
    strSQL = strSQL + " WHERE EUNIS_HABITAT_CODE LIKE '"+idCode+"%'";
    strSQL = strSQL + " AND LENGTH(EUNIS_HABITAT_CODE)>"+idCode.length();

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( strSQL );
      rs = ps.executeQuery();

      if ( rs.next() )
      {
        result = true;
      }
      con.close();
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }

    return result;
  }

  public boolean Annex1HabitatHasChilds(String idCode, String idCodeParent) {
    boolean result = false;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String strSQL = "SELECT ID_HABITAT";
    strSQL = strSQL + " FROM CHM62EDT_HABITAT";
    strSQL = strSQL + " WHERE CODE_2000 LIKE '"+idCode+"%'";
    strSQL = strSQL + " AND CODE_2000<>'"+idCodeParent+"'";

    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( strSQL );
      rs = ps.executeQuery();

      if ( rs.next() )
      {
        result = true;
      }
      con.close();
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }

    return result;
  }
  
  public boolean SpeciesHasChildTaxonomies(String idCode) {
	    boolean result = false;

	    Connection con = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    String strSQL = "SELECT ID_TAXONOMY";
	    strSQL = strSQL + " FROM CHM62EDT_TAXONOMY";
	    strSQL = strSQL + " WHERE ID_TAXONOMY_PARENT = '"+idCode+"'";
	    strSQL = strSQL + " AND ID_TAXONOMY<>'"+idCode+"'";

	    try
	    {
	      Class.forName( SQL_DRV );
	      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

	      ps = con.prepareStatement( strSQL );
	      rs = ps.executeQuery();

	      if ( rs.next() )
	      {
	        result = true;
	      }
	      con.close();
	    }
	    catch ( Exception ex )
	    {
	      ex.printStackTrace();
	    }

	    return result;
  }
  
  public boolean SpeciesHasChildSpecies(String idCode) {
	    boolean result = false;

	    Connection con = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    String strSQL = "SELECT ID_SPECIES";
	    strSQL = strSQL + " FROM CHM62EDT_SPECIES";
	    strSQL = strSQL + " WHERE ID_TAXONOMY = '"+idCode+"'";

	    try
	    {
	      Class.forName( SQL_DRV );
	      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

	      ps = con.prepareStatement( strSQL );
	      rs = ps.executeQuery();

	      if ( rs.next() )
	      {
	        result = true;
	      }
	      con.close();
	    }
	    catch ( Exception ex )
	    {
	      ex.printStackTrace();
	    }

	    return result;
  }
  
  public List<String> getAllChm62edtTableNames() {
	    
	  	List<String> ret = new ArrayList<String>();
	    Connection con = null;

	    try
	    {
	      Class.forName( SQL_DRV );
	      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

	      DatabaseMetaData meta = con.getMetaData(); 
	      ResultSet rs = meta.getTables(null, null, null, new String[]{"TABLE"});; 
	      
	      while (rs.next()) { 
	    	  String tableName = rs.getString("TABLE_NAME"); 
	    	  if(tableName != null && tableName.startsWith("chm62edt"))
	    		  ret.add(tableName);
	      } 
	      
	      con.close();
	    }
	    catch ( Exception ex )
	    {
	      ex.printStackTrace();
	    }

	    return ret;
  }
  
  public HashMap<String, ColumnDTO> getTableInfo(String tableName) {
	    
	    Connection con = null;
	    HashMap<String, ColumnDTO> columns = new HashMap<String, ColumnDTO>();
	    
	    try
	    {
	      Class.forName( SQL_DRV );
	      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );
	      
	      Statement st = con.createStatement();
	      ResultSet rs = st.executeQuery("SELECT * FROM "+tableName);
	      ResultSetMetaData rsMeta = rs.getMetaData();
	      
	      int numberOfColumns = rsMeta.getColumnCount();

          for (int x = 1; x <= numberOfColumns; x++) {
        	  String columnName = rsMeta.getColumnName(x);
        	  int columnType = rsMeta.getColumnType(x);
        	  int size = rsMeta.getColumnDisplaySize(x);
        	  int precision = rsMeta.getPrecision(x);
        	  int scale = rsMeta.getScale(x);
        	  boolean isSigned = rsMeta.isSigned(x);
        	  int isNullable = rsMeta.isNullable(x);
      	    
        	  ColumnDTO column = new ColumnDTO();
        	  column.setColumnName(columnName);
        	  column.setColumnType(columnType);
        	  column.setColumnSize(size);
        	  column.setPrecision(precision);
        	  column.setScale(scale);
        	  column.setSigned(isSigned);
        	  column.setNullable(isNullable);
      		
        	  columns.put(columnName.toLowerCase(),column);	                	    
          }
	      
          st.close();
	      con.close();
	    }
	    catch ( Exception ex )
	    {
	      ex.printStackTrace();
	    }

	    return columns;
  }
  
  public String getTableContentAsXML(String tableName) {
	    
	  Connection con = null;
	  StringBuilder ret = new StringBuilder();
	  
	  String nl = "\n";
	    
	  try {
		  Class.forName( SQL_DRV );
	      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );
	      
	      Statement st = con.createStatement();
	      ResultSet rs = st.executeQuery("SELECT * FROM "+tableName);
	      ResultSetMetaData rsMeta = rs.getMetaData();
	      int numberOfColumns = rsMeta.getColumnCount();
	      
	      while ( rs.next() ){
	    	  ret.append("<ROW>").append(nl);
		      for (int x = 1; x <= numberOfColumns; x++) {
		    	  String columnName = rsMeta.getColumnName(x);
		    	  String value = rs.getString(columnName);
		    	  if(value == null)
		    		  value = "NULL";
		    	  else if(value.equals("") || value.equalsIgnoreCase("NULL"))
		    		  value = "NULL";
		    	  
		    	  ret.append("<").append(columnName).append(">").append(EunisUtil.replaceTags(value)).append("</").append(columnName).append(">").append(nl);
		      }
		      ret.append("</ROW>").append(nl);
	      }
	      
	      st.close();
	      con.close();
	    }
	    catch ( Exception ex )
	    {
	      ex.printStackTrace();
	    }

	    return ret.toString();
}

}
