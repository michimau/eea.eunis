package eionet.eunis.dto.readers;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.eunis.dto.LegalReferenceDTO;

/**
 * Helper class to read {@link LegalReferenceDTO} objects from the database.
 * 
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class LegalReferenceDTOReader extends ResultSetBaseReader<LegalReferenceDTO> {
	
	private List<LegalReferenceDTO> results = new LinkedList<LegalReferenceDTO>();

	public List<LegalReferenceDTO> getResultList() {
		return results;
	}

	public void readRow(ResultSet rs) throws SQLException {
		
		results.add(new LegalReferenceDTO(
				rs.getInt("ID_DC"),
				rs.getString("ANNEX"),
				rs.getInt("PRIORITY"),
				rs.getString("COMMENT")));
	}

}
