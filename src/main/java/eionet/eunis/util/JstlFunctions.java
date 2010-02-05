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
}
