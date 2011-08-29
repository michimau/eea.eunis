package eionet.eunis.dto.readers;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.eunis.dto.AttributeDto;

/**
 * Reader class to read site related {@link AttributeDto} from database.
 * @author alex <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class SiteAttributeDTOReader extends ResultSetBaseReader<AttributeDto> {

    private List<AttributeDto> results = new LinkedList<AttributeDto>();

    @Override
    public List<AttributeDto> getResultList() {
        return results;
    }

    @Override
    public void readRow(ResultSet rs) throws SQLException {
        results.add(new AttributeDto(StringUtils.lowerCase(rs.getString("NAME")), StringUtils.lowerCase(rs.getString("TYPE")),
                StringUtils.lowerCase(rs.getString("VALUE"))));
    }

}
