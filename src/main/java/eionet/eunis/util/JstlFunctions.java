package eionet.eunis.util;

import ro.finsiel.eunis.WebContentManagement;
import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;

/**
 * Collection of eunis JSTL functions.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class JstlFunctions {
	
	
	/**
	 * jstl wrapper to factsheet.exists();
	 * 
	 * @param factsheet
	 * @return
	 */
	public static boolean exists(SpeciesFactsheet factsheet) {
		return factsheet != null && factsheet.exists();
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
}
