package ro.finsiel.eunis;

import ro.finsiel.eunis.jrfTables.Chm62edtLanguageDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtLanguagePersist;
import ro.finsiel.eunis.jrfTables.WebContentDomain;
import ro.finsiel.eunis.jrfTables.WebContentPersist;
import ro.finsiel.eunis.search.UniqueVector;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

/**
 * Mange the content from the WEB_CONTENT table. Used for HTML editing of the web pages.
 * This object is constructed to store the content of page in a cache. If HTML is edited directly on database,
 * the looks on page might not be resembled in current page without starting a new browser session. This is because
 * page content is loaded on cache only when new session is created.
 *
 * @author finsiel
 */
public class WebContentManagement implements java.io.Serializable {
  /**
   * This page keeps all the content of the web pages from database when object initialized in order to avoid
   * query overhead. It is declared as static so that all sessions share the same HTML content to avoid memory overheads
   * in Java VM.
   * The content of the hashmap is:
   * <UL>
   * <LI>Key - ID of the page from database</LI>
   * <LI>Value - WebContentPersist associated in database with that ID_PAGE</LI>
   * </UL>
   * So this is a (String, WebContentPersist) pair.
   */
  private HashMap<String, WebContentPersist> htmlContent = new HashMap<String, WebContentPersist>();

  private String language = "en";

  private boolean editMode = false;

  /**
   * Change current language displayed within web pages
   *
   * @param language
   */
  public void setLanguage( final String language ) {
    this.language = language;
    reloadLanguageData();
  }

  public void reloadLanguageData() {
    cacheHTMLContent( language );
  }

  /**
   * Load the HTML content when object initialized from EUNIS_WEB_CONTENT into a
   * HashMap object and caches for later use while generating pages.
   */
  private void cacheHTMLContent( final String language ) {
    long l = new Date().getTime();
    try
    {
      htmlContent.clear();
      final List<WebContentPersist> pages = new WebContentDomain().findCustom( "select a.* from `eunis_web_content` as a, (select max(record_date) mx,id_page,lang from `eunis_web_content` group by id_page,lang) as b where a.id_page = b.id_page and a.lang = b.lang and a.record_date = b.mx;" );
      for ( int i = 0; i < pages.size(); i++ )
      {
        final WebContentPersist text = pages.get( i );
        final String id_page = text.getIDPage();
        htmlContent.put( id_page, text );
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
  }

  /**
   * Find specific pages available for a module.
   *
   * @param module
   * @return List of Strings objects, one for each page found (with name of the page)
   *         Note: This method gets the data directly from database
   */
  public List getPagesForModule( final String module ) {
    List results = new Vector();
    if ( null != module )
    {
      try
      {
        final List<WebContentPersist> duplicatePages = new WebContentDomain().findWhere( "ID_PAGE LIKE '" + module + "%' ORDER BY ID_PAGE" );
        final UniqueVector pages = new UniqueVector();
        // Get the all the pages from EUNIS_WEB_CONTENT (they are duplicated because version - edited date - may differ)
        for ( WebContentPersist duplicatePage : duplicatePages )
        {
          pages.addElement( duplicatePage.getIDPage() );
        }
        // For each page we find the last page version and add it
        final List<WebContentPersist> tempList = new Vector<WebContentPersist>();
        for ( int i = 0; i < pages.elements().size(); i++ )
        {
          // For each page...
          final String pageID = ( String ) pages.elements().get( i );
          // ...find the most recent modified version.
          final List<WebContentPersist> newresults = new WebContentDomain().findWhere( "ID_PAGE='" + pageID + "' ORDER BY RECORD_DATE DESC" );
          if ( newresults.size() > 0 )
          {
            final WebContentPersist page = newresults.get( 0 );
            tempList.add( page );
          }
          else
          {
            System.out.println( "Warning: " + WebContentManagement.class.getName() + "::getPagesForModule(" + module + ") : Page with ID: " + pageID + " not found..." );
          }
        }
        // Remove duplicates from pages List (duplicates appear beacuse of the paragraph. For example
        // generic_test_01 and generic_test_02 will put here 2 entries named 'test')
        final UniqueVector u = new UniqueVector();
        for ( WebContentPersist page : tempList )
        {
          final String pageName = getPageNameFromID( page.getIDPage() );
          u.addElement( pageName );
        }
        results = u.elements();
      }
      catch ( Exception ex )
      {
        ex.printStackTrace();
      }
    }
    if ( null == results )
    {
      results = new Vector();
    }
    return results;
  }

  /**
   * Find specific paragraphs for a page.
   *
   * @param module Module name ($MODULE$).
   * @param page   Page name ($PAGE$).
   * @return List of WebContentPersist objects, one for each paragraph found.
   */
  public List<WebContentPersist> getParagraphsForPage( final String module, final String page ) {
    List<WebContentPersist> results = new Vector<WebContentPersist>();
    if ( null != module && null != page )
    {
      final String IDPage = module + "_" + page + "\\_"; // MySQL treats '_' as wildcard!
      try
      {
        results = new WebContentDomain().findWhere( "ID_PAGE LIKE '" + IDPage + "%' GROUP BY ID_PAGE" );
      }
      catch ( Exception _ex )
      {
        _ex.printStackTrace();
      }
    }
    if ( null == results )
    {
      results = new Vector<WebContentPersist>();
    }
    return results;
  }

  /**
   * Retrieve the content of a page based on its ID.
   * The ID is encoded as following:<BR>
   * $MODULE$_$PAGE$_$PARAGRAPH$, for example: species_names-result_0 means first paragraph from
   * Species::Names::Results (species-names-result.jsp) page.<BR>
   * Page content is loaded from cache!
   *
   * @param IDPage ID of the page to be retrieved (ID_PAGE from WEB_CONTENT table)
   * @return HTML content of the web page or if ID not found or exception ocurred the empty "" string.
   */
  public WebContentPersist getPageContent( final String IDPage ) {
    final WebContentPersist result = htmlContent.get( IDPage );
    if ( result == null )
    {
      System.out.println( "Warning: " + WebContentManagement.class.getName() + "getPageContent(" + IDPage + "): IDPage=" + IDPage + " was not found in cache." );
    }
    return result;
  }

  /**
   * Retrieve always last version of english version of page content directly from database.
   * $MODULE$_$PAGE$_$PARAGRAPH$, for example: species_names-result_0 means first paragraph from
   * Species::Names::Results (species-names-result.jsp) page.<BR>
   *
   * @param idPage ID of the page to be retrieved (ID_PAGE from WEB_CONTENT table)
   * @return HTML content of the web page or if ID not found or exception ocurred the empty "" string.
   */
  public WebContentPersist getPageContentEnglish( final String idPage ) {
    WebContentPersist ret = new WebContentPersist();
    try
    {
      final List<WebContentPersist> results = new WebContentDomain().findWhere( "ID_PAGE='" + idPage + "' AND LANG='en' ORDER BY RECORD_DATE DESC" );
      if ( results.size() > 0 )
      {
        ret = results.get( 0 );
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    return ret;
  }

  /**
   * Retrieve the content as HTML data of a page based on its ID. The ID is encoded as following:<BR>
   * $MODULE$_$PAGE$_$PARAGRAPH$, for example: species_names-result_0 means first paragraph from
   * Species::Names::Results (species-names-result.jsp) page.
   *
   * @param idPage ID of the page to be retrieved (ID_PAGE from WEB_CONTENT table)
   * @return HTML content of the web page or if ID not found or exception ocurred the empty "" string.
   */
  public String getContent( final String idPage ) {
    return getContent( idPage, editMode );
  }

  public String getContent( final String idPage, boolean showEditTag ) {
    String result = idPage;
    if ( htmlContent.containsKey( idPage ) )
    {
      final WebContentPersist text = htmlContent.get( idPage );
      if ( null != text )
      {
        if ( text.getContent() != null )
        {
          result = text.getContent().trim();
        }
        else
        {
          result = idPage;
        }
      }
      else
      {
        // Eventually double-check on database for that page (?)
        System.out.println( "Warning:" + WebContentManagement.class.getName() + "::getContent(" + idPage + "): Page not found in cache." );
      }
      result += writeEditTag( idPage, showEditTag );
    }
    else
    {
      final List<WebContentPersist> dbKeyList = new WebContentDomain().findWhereOrderBy( "ID_PAGE='" + idPage + "'", "RECORD_DATE DESC" );
      if( !dbKeyList.isEmpty() )
      {
        htmlContent.put( idPage, dbKeyList.get( 0 ) );
        result = dbKeyList.get( 0 ).getContent();
      }
      else
      {
        System.out.println( "Warning:" + WebContentManagement.class.getName() + "::getContent(" + idPage + "): Page not found in cache and database." );
      }
    }
    return result;
  }

  public String writeEditTag( final String idPage, boolean showEditTag ) {
    if ( !showEditTag )
    {
      return "";
    }
    else
    {
      return "<a title=\"Edit this text\" href=\"javascript:editContent('" + idPage + "');\">" +
              "<img src=\"images/edit-content.jpg\" style=\"border : 0px;\" width=\"9\" height=\"9\" " +
              "alt=\"Edit this text\" " +
              "title=\"Edit this text\" /></a>";
    }
  }

  public String writeEditTag( final String idPage ) {
    return writeEditTag( idPage, editMode );
  }

  public String getPageContentAsHTML( final String idPage, final String language ) {
    String ret = "";
    try
    {
      final List<WebContentPersist> results = new WebContentDomain().findWhere( "ID_PAGE='" + idPage + "' AND LANG='" + language + "' ORDER BY RECORD_DATE DESC" );
      if ( results.size() > 0 )
      {
        final WebContentPersist page = results.get( 0 );
        ret = page.getContent();
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    return ret;
  }

  /**
   * Parse the IDPage and retrieve the $PAGE$ attribute from IDPage.
   *
   * @param idPage ID of the page to be parsed.
   * @return page name or empty string "". Page name looks loke "specie-names", "habitats-legal-result" etc.
   * @see WebContentManagement#getPageContent notes from above.
   */
  public String getPageNameFromID( final String idPage ) {
    String result = "";
    if ( null != idPage )
    {
      final int firstUnderline = idPage.indexOf( '_' );
      final int lastUnderline = idPage.lastIndexOf( '_' );
      if ( firstUnderline != -1 && lastUnderline != -1 && ( firstUnderline < lastUnderline ) )
      {
        // We have found the two '_' which delimits the page name
        try
        {
          result = idPage.substring( firstUnderline + 1, lastUnderline );
        }
        catch ( ArrayIndexOutOfBoundsException _ex )
        {
          _ex.printStackTrace();
        }
      }
    }
    return result;
  }

  /**
   * Parse IDPage and retrieve the $PARAGRAPH$ atrribute from IDPage.
   *
   * @param idPage ID of the page to be parsed.
   * @return paragraph ID or empty string "". ID paragraph looks like "01", "02" etc.
   * @see WebContentManagement#getPageContent notes from above.
   */
  public String getParagraphNameFromID( final String idPage ) {
    String result = "";
    if ( null != idPage )
    {
      final int lastUnderline = idPage.lastIndexOf( '_' );
      if ( lastUnderline != -1 )
      {
        // We have found the last '_' which delimits the paragraph to the end of the string
        try
        {
          result = idPage.substring( lastUnderline + 1, idPage.length() );
        }
        catch ( ArrayIndexOutOfBoundsException _ex )
        {
          _ex.printStackTrace();
        }
      }
    }
    return result;
  }

  /**
   * Parse IDPage and retrieve the $MODULE$ atrribute from IDPage.
   *
   * @param idPage ID of the page to be parsed.
   * @return Module name or empty string "". Module looks like "generic", "species", "habitats", "sites".
   * @see WebContentManagement#getPageContent notes from above.
   */
  public String getModuleNameFromID( final String idPage ) {
    String result = "";
    if ( null != idPage )
    {
      final int firstUnderline = idPage.indexOf( '_' );
      if ( -1 != firstUnderline )
      {
        // We have found the first '_' which delimits the module to the rest of the string
        try
        {
          result = idPage.substring( 0, firstUnderline );
        }
        catch ( ArrayIndexOutOfBoundsException _ex )
        {
          _ex.printStackTrace();
        }
      }
    }
    return result;
  }

  public boolean savePageContent( final String module,
                                  final String page,
                                  final String paragraph,
                                  final String content,
                                  final String description,
                                  final String lang,
                                  final String username,
                                  final boolean modifyAllIdentical ) {
    boolean ret;
    if ( module != null && !module.equalsIgnoreCase( "" ) &&
            page != null && !page.equalsIgnoreCase( "" ) &&
            paragraph != null && !paragraph.equalsIgnoreCase( "" ) )
    {
      final String idPage = module + "_" + page + "_" + paragraph;
      ret = savePageContent( idPage, content, description, lang, username, modifyAllIdentical );
    }
    else
    {
      ret = false;
    }
    return ret;
  }

  public boolean savePageContent( String idPage,
                                  final String content,
                                  final String description,
                                  final String lang,
                                  final String username,
                                  final boolean modifyAllIdentical ) {
    boolean ret = false;
    if ( null != content && null != lang )
    {
      try
      {
        final WebContentPersist row = new WebContentPersist();
        row.setIDPage( idPage );
        row.setContent( content );
        row.setDescription( description );
        row.setLang( lang );
        row.setRecordDate( new Timestamp( new Date().getTime() ) );
        row.setRecordAuthor( username );

        new WebContentDomain().save( row );
        // Refresh the content of the cache

        // Take the old text, search the database and replace it with the new text.
        if ( modifyAllIdentical )
        {
          final WebContentPersist oldContent = getPageContent( idPage );

          // Escape the old Content
          final String oldText = oldContent.getContent().replaceAll( "\"", "\\\"" );

          final WebContentDomain table = new WebContentDomain();
          final List<WebContentPersist>allIdenticalTexts = new WebContentDomain().findWhere( "CONTENT=\"" + oldText + "\"" );
          for ( WebContentPersist identicText : allIdenticalTexts )
          {
            identicText.setContent( content );
            table.update( identicText );
          }
        }
        cacheHTMLContent( this.language );
        ret = true;
      }
      catch ( Exception ex )
      {
        ex.printStackTrace();
      }
    }
    return ret;
  }

  public boolean savePageContentJDBC( String idPage,
                                      final String content,
                                      final String description,
                                      final String lang,
                                      final String username,
                                      final boolean modifyAllIdentical,
                                      String SQL_DRV,
                                      String SQL_URL,
                                      String SQL_USR,
                                      String SQL_PWD ) {
    boolean result = false;
    Connection con = null;
    PreparedStatement ps = null;
    try
    {
      Class.forName( SQL_DRV );
      con = DriverManager.getConnection( SQL_URL, SQL_USR, SQL_PWD );

      ps = con.prepareStatement( "INSERT INTO EUNIS_WEB_CONTENT( ID_PAGE, CONTENT, DESCRIPTION, LANG, RECORD_AUTHOR, RECORD_DATE ) VALUES ( ?, ?, ?, ?, ?, CURRENT_TIMESTAMP )" );
      ps.setString( 1, idPage );
      ps.setString( 2, content );
      ps.setString( 3, description );
      ps.setString( 4, lang );
      ps.setString( 5, username );
      ps.executeUpdate();
      // Do not reload all language again, just modify the current key.
      // cacheHTMLContent( this.language );
      WebContentPersist data = htmlContent.get( idPage );
      data.setContent( content );
      htmlContent.remove( idPage );
      htmlContent.put( idPage, data );
      result = true;
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      result = false;
    }
    finally
    {
      try
      {
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
    return result;
  }

  /**
   * Find all modules from the EUNIS_WEB_CONTENT table.
   * Module is the first part of the ID_PAGE from EUNIS_WEB_CONTENT. For example in 'generic_about_01', 'generic' is
   * the name of the module.
   *
   * @return List of strings with module names.
   */
  public List findModulesNames() {
    final UniqueVector u = new UniqueVector();
    try
    {
      final List<WebContentPersist> allPages = new WebContentDomain().findAll();
      for ( WebContentPersist page : allPages )
      {
        try
        {
          final String pageName = page.getIDPage().substring( 0, page.getIDPage().indexOf( '_' ) );
          u.addElement( pageName );
        }
        catch ( Exception ex )
        {
          System.out.println( "Could not parse the name:" + page.getIDPage() );
          ex.printStackTrace();
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    return u.elements();
  }

  /**
   * Main methor of this class, used for testing the class.
   *
   * @param args Command line arguments.
   */
  public static void main( final String[] args ) {
    System.out.println( new WebContentManagement().getPageNameFromID( "generic_about_01" ) );
    System.out.println( new WebContentManagement().getParagraphNameFromID( "generic_about_01" ) );
    System.out.println( new WebContentManagement().getModuleNameFromID( "generic_about_01" ) );
  }

  /**
   * Translate language code into language name in english. For example 'da' translates to 'Danish';
   *
   * @param code Code which will be decoded.
   * @return Decoded language or null if code is not found within CHM62EDT_LANGUAGE
   */
  public String translateLanguageCode( final String code ) {
    String value = null;
    try
    {
      final List<Chm62edtLanguagePersist> items = new Chm62edtLanguageDomain().findWhere( "CODE='" + code + "'" );
      if ( items.size() > 0 )
      {
        final Chm62edtLanguagePersist languageName = items.get( 0 );
        value = languageName.getNameEn();
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    return value;
  }

  /**
   * Retrieve the list of languages in which application is already translated.
   *
   * @return List of languages.
   */
  public List<Chm62edtLanguagePersist> getTranslatedLanguages() {
    final List<Chm62edtLanguagePersist> languages = new Vector<Chm62edtLanguagePersist>();
    try
    {
      final List<WebContentPersist> items = new WebContentDomain().findCustom( "SELECT * FROM EUNIS_WEB_CONTENT WHERE LANG <> 'en' AND LANG_STATUS > 0 GROUP BY LANG" );
      // Decode the languages from CHM62EDT_LANGUAGE table
      for ( WebContentPersist item : items )
      {
        final List<Chm62edtLanguagePersist> tmp = new Chm62edtLanguageDomain().findWhere( "CODE = '" + item.getLang() + "'" );
        if ( tmp.size() > 0 )
        {
          languages.add( tmp.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    return languages;
  }

  /**
   * Find all available language into which EUNIS can be translated.
   * Formula is: SELECT CODE FROM CHM62EDT_LANGUAGE - ( SELECT DISTINCT(LANG) EUNIS_WEB_CONTENT ) )
   */
  public List<Chm62edtLanguagePersist> getAvailableLanguages() {
    List<Chm62edtLanguagePersist> languages = new Vector<Chm62edtLanguagePersist>();
    try
    {
      final List<Chm62edtLanguagePersist> all_languages = new Chm62edtLanguageDomain().findOrderBy( "NAME_EN" );
      final List<WebContentPersist> translated_languages = new WebContentDomain().findCustom( "SELECT * FROM EUNIS_WEB_CONTENT GROUP BY LANG" );
      for ( Chm62edtLanguagePersist language : all_languages )
      {
        boolean exists = false;
        for ( WebContentPersist existing_lang : translated_languages )
        {
          if ( existing_lang.getLang().equalsIgnoreCase( language.getCode() ) )
          {
            exists = true;
            break;
          }
        }
        if ( !exists )
        {
          languages.add( language );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    return languages;
  }

  /**
   * Add a new language for translation into the database.
   *
   * @param code Language code from CHM62EDT_LANGUAGE
   */
  public boolean addLanguage( final String code ) throws Exception {
    boolean ret = false;
    if ( code != null && !code.equalsIgnoreCase( "en" ) )
    {
      // Check if languages is not already in database
      List<WebContentPersist> languages = new WebContentDomain().findWhere( "LANG='" + code + "'" );
      if ( languages.size() > 0 )
      {
        throw new Exception( "Language already added for translation." );
      }
      try
      {
        //System.out.println( "Saving new language" );
        final WebContentPersist row = new WebContentPersist();
        row.setIDPage( "language_support" );
        row.setContent( "" );
        row.setDescription( "null" );
        row.setLang( code );
        row.setLangStatus( new Short( ( short ) 0 ) );
        row.setContentLength( new Short( ( short ) 0 ) );
        row.setRecordDate( new Timestamp( new Date().getTime() ) );
        new WebContentDomain().save( row );
        ret = true;
      }
      catch ( Exception ex )
      {
        ret = false;
        ex.printStackTrace();
      }
    }
    return ret;
  }

  public String getLanguage() {
    return this.language;
  }

  public boolean isEditMode() {
    return editMode;
  }

  public void setEditMode( boolean editMode ) {
    this.editMode = editMode;
  }

  public String getCurrentLanguage() {
    return language;
  }
}