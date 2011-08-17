package eionet.eunis.dto.readers;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.eunis.dto.DcIndexDTO;


public class DcIndexDTOReader extends ResultSetBaseReader<DcIndexDTO> {

    /** */
    List<DcIndexDTO> resultList = new ArrayList<DcIndexDTO>();

    public void readRow(ResultSet rs) throws SQLException {

        DcIndexDTO dto = new DcIndexDTO();

        dto.setIdDc(rs.getString("ID_DC"));
        dto.setComment(rs.getString("COMMENT"));
        dto.setRefCd(rs.getString("REFCD"));
        dto.setReference(rs.getString("REFERENCE"));
        dto.setSource(rs.getString("SOURCE"));
        dto.setEditor(rs.getString("EDITOR"));
        dto.setJournalTitle(rs.getString("JOURNAL_TITLE"));
        dto.setBookTitle(rs.getString("BOOK_TITLE"));
        dto.setJournalIssue(rs.getString("JOURNAL_ISSUE"));
        dto.setIsbn(rs.getString("ISBN"));
        dto.setUrl(rs.getString("URL"));
        dto.setCreated(rs.getString("CREATED"));
        dto.setTitle(rs.getString("TITLE"));
        dto.setAlternative(rs.getString("ALTERNATIVE"));
        dto.setPublisher(rs.getString("PUBLISHER"));
        resultList.add(dto);
    }

    /**
     * @return the resultList
     */
    public List<DcIndexDTO> getResultList() {
        return resultList;
    }

}
