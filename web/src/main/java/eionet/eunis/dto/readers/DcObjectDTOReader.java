package eionet.eunis.dto.readers;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import eionet.eunis.dto.DcObjectDTO;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;


public class DcObjectDTOReader extends ResultSetBaseReader<DcObjectDTO> {
	
    /** */
    List<DcObjectDTO> resultList = new ArrayList<DcObjectDTO>();
	
    public void readRow(ResultSet rs) throws SQLException {

        DcObjectDTO dto = new DcObjectDTO();

        dto.setId(rs.getString("ID_DC"));
        dto.setTitle(rs.getString("TITLE"));
        dto.setSource(rs.getString("SOURCE"));
        dto.setSourceUrl(rs.getString("URL"));
        dto.setContributor(rs.getString("CONTRIBUTOR"));
        dto.setCoverage(rs.getString("COVERAGE"));
        dto.setCreator(rs.getString("CREATOR"));
        dto.setDate(rs.getString("CREATED"));
        dto.setDescription(rs.getString("DESCRIPTION"));
        dto.setFormat(rs.getString("FORMAT"));
        dto.setIdentifier(rs.getString("IDENTIFIER"));
        dto.setLanguage(rs.getString("LANGUAGE"));
        dto.setPublisher(rs.getString("PUBLISHER"));
        dto.setRelation(rs.getString("RELATION"));
        dto.setRights(rs.getString("RIGHTS"));
        dto.setSubject(rs.getString("SUBJECT"));
        dto.setType(rs.getString("TYPE"));
		
        resultList.add(dto);
    }
	
    /**
     * @return the resultList
     */
    public List<DcObjectDTO> getResultList() {
        return resultList;
    }

}
