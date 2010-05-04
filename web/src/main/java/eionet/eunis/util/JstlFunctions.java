package eionet.eunis.util;

import java.lang.reflect.Method;

import org.apache.log4j.Logger;

import ro.finsiel.eunis.WebContentManagement;
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
}
