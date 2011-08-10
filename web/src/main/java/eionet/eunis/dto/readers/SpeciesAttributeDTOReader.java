package eionet.eunis.dto.readers;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;
import eionet.eunis.dto.AttributeDto;


/**
 * Reader class for {@link AttributeDto}.
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class SpeciesAttributeDTOReader extends ResultSetBaseReader<AttributeDto> {

    private List<AttributeDto> results = new LinkedList<AttributeDto>();

    public void readRow(ResultSet rs) throws SQLException {
        String name = rs.getString("NAME");
        String object = rs.getString("OBJECT");
        String type = rs.getString("TYPE");

        if (StringUtils.isBlank(name)) {
            return;
        }
        results.add(new AttributeDto(name, type, object));
    }

    public List<AttributeDto> getResultList() {
        return results;
    }

}
