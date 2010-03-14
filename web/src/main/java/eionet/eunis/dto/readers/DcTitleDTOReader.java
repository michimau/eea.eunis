package eionet.eunis.dto.readers;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import eionet.eunis.dto.DcTitleDTO;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;


public class DcTitleDTOReader extends ResultSetBaseReader<DcTitleDTO> {
	
	/** */
	List<DcTitleDTO> resultList = new ArrayList<DcTitleDTO>();
	

	public void readRow(ResultSet rs) throws SQLException {

		DcTitleDTO docDTO = new DcTitleDTO();
		docDTO.setIdDoc(rs.getString("ID_DC"));
		docDTO.setIdTitle(rs.getString("ID_TITLE"));
		docDTO.setTitle(rs.getString("TITLE"));
		docDTO.setAlternative(rs.getString("ALTERNATIVE"));
		
		resultList.add(docDTO);
	}
	
	/**
	 * @return the resultList
	 */
	public List<DcTitleDTO> getResultList() {
		return resultList;
	}

}
