package eionet.eunis.scripts;

import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

import ro.finsiel.eunis.utilities.SQLUtilities;

import eionet.eunis.dao.impl.SitesDaoImpl;


public class DeleteSites {
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		try {
			if(args.length == 0){
				System.out.println("Missing site IDs!");
				System.out.println("Usage: eionet.eunis.scripts.DeleteSites {site1ID} {site2ID} {site3ID} ...");
			} else {
				Map<String,String> siteIds = new HashMap<String,String>();
				for (String siteID : args) {
					if(siteID != null && siteID.length() > 0)
						siteIds.put(siteID,null);
				}
				if(siteIds.size() > 0){
					
					ResourceBundle props = ResourceBundle.getBundle("jrf");
					String dbDriver = props.getString("mysql.driver");
					String dbUrl = props.getString("mysql.url");
					String dbUser = props.getString("mysql.user");
					String dbPass = props.getString("mysql.password");
					
					SQLUtilities sqlUtilities = new SQLUtilities();
					sqlUtilities.Init(dbDriver, dbUrl, dbUser, dbPass);
					
					SitesDaoImpl dao = new SitesDaoImpl(sqlUtilities);
					dao.deleteSites(siteIds);
					System.out.println("Successfully deleted!");
				}
			}
		     
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
