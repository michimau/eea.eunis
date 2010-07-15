package eionet.eunis.scripts;

import java.util.HashMap;
import java.util.Map;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.ISpeciesDao;

public class DeleteSpecies {
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		try {
			if(args.length == 0){
				System.out.println("Missing species IDs!");
				System.out.println("Usage: deletespecies {species1ID} {species2ID} {species3ID} ...");
			} else {
				Map<String,String> speciesIds = new HashMap<String,String>();
				for (String speciesID : args) {
					if(speciesID != null && speciesID.length() > 0)
						speciesIds.put(speciesID,null);
				}
				if(speciesIds.size() > 0){
					ISpeciesDao dao = DaoFactory.getDaoFactory().getSpeciesDao();
					dao.deleteSpecies(speciesIds);
					System.out.println("Successfully deleted!");
				}
			}
		     
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
