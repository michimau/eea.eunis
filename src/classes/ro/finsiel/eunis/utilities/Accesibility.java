package ro.finsiel.eunis.utilities;

import java.util.HashMap;

/**
 * Created by IntelliJ IDEA.
 * User: dchirca
 * Date: Jul 12, 2005
 * Time: 2:40:36 PM
 * To change this template use File | Settings | File Templates.
 */
public class Accesibility {

  private static HashMap<String,String> hm =  new HashMap<String, String>();

  static
  {
    // Generic
    hm.put("generic.noscript","JavaScript is disabled. Some functionality will be missing");
    hm.put("generic.refined.delete","Delete this filter");
    hm.put("generic.refined.question","Open values. This link will open a popup");
    hm.put("generic.popup","This link will open a popup");
    hm.put("generic.popup.lov","List of values. This link will open a popup");
    hm.put("generic.sortImage","Sort results by this column");
    hm.put("generic.criteria.mandatory","This search criteria is mandatory");
    hm.put("generic.criteria.optional","This search criteria is optional");
    hm.put("generic.criteria.included","At least one of these criteria must be entered");
    hm.put("generic.criteria.save","Save search criteria");

    //anca
    hm.put("Species.Name.SearchButton.Alt","Search button");
    //dan

    //cristi
  }

  public static String getText(String key)
  {
    String ret = key;
    try
    {
      ret =  hm.get( key );
    }
    catch(Exception ex)
    {
      System.out.println("key: " + key + " not found!");
    }
    return ret;
  }
}


