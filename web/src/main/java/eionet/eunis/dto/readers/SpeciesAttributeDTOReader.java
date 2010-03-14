package eionet.eunis.dto.readers;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.eunis.dto.SpeciesAttributeDto;

/**
 * Reader class for {@link SpeciesAttributeDto}.
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class SpeciesAttributeDTOReader extends ResultSetBaseReader<SpeciesAttributeDto> {

	
	private List<SpeciesAttributeDto> results = new LinkedList<SpeciesAttributeDto>();

	public void readRow(ResultSet rs) throws SQLException {
		results.add(
				new SpeciesAttributeDto(
						rs.getString("NAME"),
						rs.getBoolean("LITOBJECT"),
						rs.getString("OBJECT")));
	}

	public List<SpeciesAttributeDto> getResultList() {
		return results;
	}

}
