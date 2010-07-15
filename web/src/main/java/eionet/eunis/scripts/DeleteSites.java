package eionet.eunis.scripts;

import java.util.HashMap;
import java.util.Map;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.ISitesDao;


public class DeleteSites {
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		try {
			if(args.length == 0){
				System.out.println("Missing site IDs!");
				System.out.println("Usage: deletesites {site1ID} {site2ID} {site3ID} ...");
			} else {
				Map<String,String> siteIds = new HashMap<String,String>();
				for (String siteID : args) {
					if(siteID != null && siteID.length() > 0)
						siteIds.put(siteID,null);
				}
				if(siteIds.size() > 0){
					ISitesDao dao = DaoFactory.getDaoFactory().getSitesDao();
					dao.deleteSites(siteIds);
					System.out.println("Successfully deleted!");
				}
			}
		     
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
