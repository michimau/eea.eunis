package eionet.eunis.dto.readers;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.eunis.dto.DocumentDTO;


public class DocumentDTOReader extends ResultSetBaseReader<DocumentDTO> {

    /** */
    List<DocumentDTO> resultList = new ArrayList<DocumentDTO>();

    public void readRow(ResultSet rs) throws SQLException {

        DocumentDTO docDTO = new DocumentDTO();

        docDTO.setIdDoc(rs.getString("ID_DC"));
        docDTO.setIdTitle(rs.getString("ID_TITLE"));
        docDTO.setTitle(rs.getString("TITLE"));
        docDTO.setAlternative(rs.getString("ALTERNATIVE"));
        docDTO.setAuthor(rs.getString("SOURCE"));
        docDTO.setYear(rs.getString("CREATED"));

        resultList.add(docDTO);
    }

    /**
     * @return the resultList
     */
    public List<DocumentDTO> getResultList() {
        return resultList;
    }

}
