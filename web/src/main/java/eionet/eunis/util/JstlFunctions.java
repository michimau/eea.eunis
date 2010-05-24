package eionet.eunis.util;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Vector;

import org.apache.log4j.Logger;

import ro.finsiel.eunis.WebContentManagement;
import ro.finsiel.eunis.jrfTables.species.references.ReferencesJoinDomain;
import ro.finsiel.eunis.jrfTables.species.references.ReferencesJoinPersist;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.utilities.EunisUtil;

/**
 * Collection of eunis JSTL functions.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class JstlFunctions {
	
	private static final Logger logger = Logger.getLogger(JstlFunctions.class);
	
	
	/**
	 * jstl wrapper to factsheet.exists();
	 * 
	 * @param factsheet
	 * @return
	 */
	public static boolean exists(Object suspicious) {
		try {
			Method exists = suspicious.getClass().getMethod("exists");
			boolean result = false;
			if (exists != null) {
				result = (Boolean) exists.invoke(suspicious);
			}
			return result;
		} catch (Exception e) {
			logger.error(e);
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * 
	 * @param cms
	 * @param key
	 * @return
	 */
	public static String cms(WebContentManagement cms, String key ) {
		if(key == null) { 
			throw new NullPointerException("key cannot be null");
		}
		return cms != null
				? cms.cms(key)
				: key;
	}
	
	/**
	 * @param cms
	 * @param key
	 * @return
	 */
	public static String cmsTitle(WebContentManagement cms, String key ) {
		if(key == null) { 
			throw new NullPointerException("key cannot be null");
		}
		return cms != null
				? cms.cmsTitle(key)
				: key;
	}

	/**
	 * @param cms
	 * @param key
	 * @return
	 */
	public static String cmsInput(WebContentManagement cms, String key ) {
		if(key == null) { 
			throw new NullPointerException("key cannot be null");
		}
		return cms != null
		? cms.cmsInput(key)
				: key;
	}
	
	/**
	 * @param cms
	 * @param key
	 * @return
	 */
	public static String cmsLabel(WebContentManagement cms, String key ) {
		if(key == null) { 
			throw new NullPointerException("key cannot be null");
		}
		return cms != null
		? cms.cmsLabel(key)
				: key;
	}

	/**
	 * @param cms
	 * @param key
	 * @return
	 */
	public static String cmsPhrase(WebContentManagement cms, String key ) {
		if(key == null) { 
			throw new NullPointerException("key cannot be null");
		}
		return cms != null
				? cms.cmsPhrase(key)
				: key;
	}
	
	/**
	 * @param cms
	 * @param key
	 * @return
	 */
	public static String cmsMsg(WebContentManagement cms, String key ) {
		if(key == null) { 
			throw new NullPointerException("key cannot be null");
		}
		return cms != null
				? cms.cmsMsg(key)
				: key;
	}

	/**
	 * @param cms
	 * @return
	 */
	public static String br(WebContentManagement cms) {
		return cms.br();
	}
	
	/**
	 * 
	 * @param in
	 * @return
	 */
	public static String replaceTags(String in) {
		return EunisUtil.replaceTags(in);
	}
	
	/**
	 * 
	 * @param in
	 * @param dontCreateHTMLAnchors
	 * @param dontCreateHTMLLineBreaks
	 * @return
	 */
	public static String replaceTags(String in, boolean dontCreateHTMLAnchors, boolean dontCreateHTMLLineBreaks ) {
		return EunisUtil.replaceTags(in, dontCreateHTMLAnchors, dontCreateHTMLLineBreaks);
	}
	
	/**
	 * @param object
	 * @param defaultValue
	 * @return
	 */
	public static String formatString( Object object, String defaultValue ) {
	    if(null == object)
	    	return defaultValue;
	    if(object.toString().equalsIgnoreCase("null"))
	    	return defaultValue;
	    if(object.toString().length() == 0)
	    	return defaultValue;
	    return object.toString();
	}
	
	/**
	 * @param object
	 * @param decimals
	 * @return
	 */
	public static String formatDecimal( Object val, Integer dec ) {
	    String val2 = "";
	    int decimals = dec.intValue();
	    decimals++;
	    try{
	    	if ( val != null ){
	    		val2 = val.toString();
	    		int pos = val2.indexOf( "." );
	    		if ( pos > 0 && pos + decimals <= val2.length() )
	    			val2 = val2.substring( 0, pos + decimals );
	    	}
	    } catch ( Exception ex ) {
	    	ex.printStackTrace();
	    }
	    return val2;
	}
	
	/**
	   * Translate the SOURCE_DB field from CHM62EDT_SITES in human readable language.
	   *
	   * @param sourceDB Source db.
	   * @return Source database.
	   */
	public static String translateSourceDB( String sourceDB ) {
		if ( null == sourceDB )
			return "n/a";
	    String result = sourceDB.replaceAll( "CDDA_NATIONAL", "CDDA National" ).replaceAll( "CDDA_INTERNATIONAL", "CDDA International" ).replaceAll( "NATURA2000", "Natura 2000" ).replaceAll( "CORINE", "Corine" ).replaceAll( "DIPLOMA", "European diploma" ).replaceAll( "BIOGENETIC", "Biogenetic reserves" ).replaceAll( "NATURENET", "NatureNet" ).replaceAll( "EMERALD", "Emerald" );
	    return result;
	}
	
	/**
	 * Replace characters having special meaning inside HTML tags
	 * with their escaped equivalents, using character entities.
	 *
	 * @param str String to be parsed
	 * @return Processed string.
	 */
	public static String treatURLSpecialCharacters( String str ) {
		if ( str == null ){
			return "";
		}
		String result = str;

		result = result.replaceAll( "&", "&amp;" );
		result = result.replaceAll( "<", "&lt;" );
		result = result.replaceAll( ">", "&gt;" );
		result = result.replaceAll( "\"", "&quot;" );
		result = result.replaceAll( "'", "&#039;" );
		result = result.replaceAll( "\\\\", "&#092;" );
		result = result.replaceAll( "%", "&#037;" );

		return result;
	}
	
	/**
	   * This method formats the area field from the sites module which is displayed within HTML result pages.
	   *
	   * @param input the input string
	   * @param left  how much spaces to left on the left side
	   * @param right how much spaces to let on the right side
	   * @param blank which is the blank character to fill empty spaces (ie. in HTML is used &nbsp;)
	   * @return The formatted string
	   */
	public static String formatArea( String input, int left, int right, String blank ) {
	    String result = "<span style=\"font-family:courier; font-size: 10px\">";
	    result += Utilities.formatArea( input, left, right, blank, null );
	    result += "</span>";
	    return result;
	}
	
	/**
	   * Find a reference by an idDc and return a vector with two elements , first element contains author of that
	   * reference and second element contains url of reference.
	   *
	   * @param idDc idDC of reference
	   * @return author
	   */
	public static String getAuthorAndUrlByIdDc( String idDc ) {
	    String author = "";
	    try
	    {
	      List references = new ReferencesJoinDomain().findWhere( "DC_INDEX.ID_DC = " + idDc );
	      if ( references != null && references.size() > 0 )
	      {
	        author = ( ( ( ReferencesJoinPersist ) references.get( 0 ) ).getSource() == null ? "" : ( ( ReferencesJoinPersist ) references.get( 0 ) ).getSource() );
	        author = treatURLSpecialCharacters(author);
	      }
	    }
	    catch ( Exception ex )
	    {
	      ex.printStackTrace();
	    }
	    return author;
	}
	
	/**
	   *
	   * @param input the input string
	   * @param what to replace
	   * @param replacement
	   */
	public static String replaceAll( String input, String what, String replacement ) {
		return input.replaceAll(what, replacement);
	}


}
