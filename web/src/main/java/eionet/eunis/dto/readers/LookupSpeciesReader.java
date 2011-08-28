package eionet.eunis.dto.readers;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import eionet.eunis.api.LookupSpeciesResult;
import eionet.eunis.api.SpeciesDTO;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;


/**
 * Reader class to read SpeciesDTO from the database.
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleks21@gmail.com">contact</a>
 */

public class LookupSpeciesReader extends ResultSetBaseReader<Object> {
	
    private LookupSpeciesResult result = new LookupSpeciesResult();
    private List<SpeciesDTO> fullMatches = new LinkedList<SpeciesDTO>();
    private List<SpeciesDTO> fuzzyMatches = new LinkedList<SpeciesDTO>();

    /* (non-Javadoc)
     * @see ro.finsiel.eunis.utilities.ResultSetBaseReader#readRow(java.sql.ResultSet)
     */
    @Override
    public void readRow(ResultSet rs) throws SQLException {
        int distance = rs.getInt("DISTANCE");
        SpeciesDTO dto = new SpeciesDTO(rs.getInt("ID_SPECIES"), rs.getString("SCIENTIFIC_NAME"), rs.getString("author"));

        if (distance > 0) {
            fuzzyMatches.add(dto);
        } else {
            fullMatches.add(dto);
        }
    }

    /* (non-Javadoc)
     * @see ro.finsiel.eunis.utilities.ResultSetBaseReader#getResultList()
     */
    @Override
    public List<Object> getResultList() {
        throw new IllegalStateException("not allowed");
    }

    public LookupSpeciesResult getLookupSpeciesResult() {
        if (result.getFullMatches() == null) {
            result.setFullMatches(fullMatches.toArray(new SpeciesDTO[fullMatches.size()]));
        }
        if (result.getFuzzyMatches() == null) {
            result.setFuzzyMatches(fuzzyMatches.toArray(new SpeciesDTO[fuzzyMatches.size()]));
        }
        return result;
    }

}
