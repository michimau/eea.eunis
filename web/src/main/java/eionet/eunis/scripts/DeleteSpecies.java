package eionet.eunis.scripts;

import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

import ro.finsiel.eunis.utilities.SQLUtilities;

import eionet.eunis.dao.impl.SpeciesDaoImpl;


public class DeleteSpecies {
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		try {
			if(args.length == 0){
				System.out.println("Missing species IDs!");
				System.out.println("Usage: eionet.eunis.scripts.DeleteSpecies {species1ID} {species2ID} {species3ID} ...");
			} else {
				Map<String,String> speciesIds = new HashMap<String,String>();
				for (String speciesID : args) {
					if(speciesID != null && speciesID.length() > 0)
						speciesIds.put(speciesID,null);
				}
				if(speciesIds.size() > 0){
					
					ResourceBundle props = ResourceBundle.getBundle("jrf");
					String dbDriver = props.getString("mysql.driver");
					String dbUrl = props.getString("mysql.url");
					String dbUser = props.getString("mysql.user");
					String dbPass = props.getString("mysql.password");
					
					SQLUtilities sqlUtilities = new SQLUtilities();
					sqlUtilities.Init(dbDriver, dbUrl, dbUser, dbPass);
					
					SpeciesDaoImpl dao = new SpeciesDaoImpl(sqlUtilities);
					dao.deleteSpecies(speciesIds);
					System.out.println("Successfully deleted!");
				}
			}
		     
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
