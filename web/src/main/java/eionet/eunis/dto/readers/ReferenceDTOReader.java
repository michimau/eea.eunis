package eionet.eunis.dto.readers;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.eunis.dto.ReferenceDTO;


public class ReferenceDTOReader extends ResultSetBaseReader<ReferenceDTO> {

    /** */
    List<ReferenceDTO> resultList = new ArrayList<ReferenceDTO>();

    public void readRow(ResultSet rs) throws SQLException {

        ReferenceDTO docDTO = new ReferenceDTO();

        docDTO.setIdRef(rs.getString("ID_DC"));
        docDTO.setTitle(rs.getString("TITLE"));
        docDTO.setAlternative(rs.getString("ALTERNATIVE"));
        docDTO.setAuthor(rs.getString("SOURCE"));
        docDTO.setYear(rs.getString("CREATED"));

        resultList.add(docDTO);
    }

    /**
     * @return the resultList
     */
    public List<ReferenceDTO> getResultList() {
        return resultList;
    }

}
