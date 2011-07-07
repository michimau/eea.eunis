package eionet.eunis.dto;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.simpleframework.xml.convert.Converter;
import org.simpleframework.xml.stream.InputNode;
import org.simpleframework.xml.stream.OutputNode;

/**
 * Converter class to convert {@link AttributeDto} to xml.
 */
public final class AttributeConverter implements Converter<AttributeDto> {

    List<String> bioRegions = Arrays.asList("alpine", "anatol", "arctic", "atlantic", "boreal", "continental", "macronesia",
            "mediterranian", "pannonian", "black_sea", "steppic");

    public AttributeDto read(InputNode arg0) throws Exception {
        throw new IllegalStateException("not allowed");
    }

    public void write(OutputNode node, AttributeDto dto) throws Exception {
        // small hacking, as OutputElement is not accessible
        Field name = node.getClass().getDeclaredField("name");

        name.setAccessible(true);
        name.set(node, dto.getName());
        if (dto.isLiteral()) {
            node.setValue(dto.getValue());
            // For biogeographic regions add boolean datatype. Ticket #1175
            if (!StringUtils.isBlank(dto.getName()) && bioRegions.contains(dto.getName().toLowerCase())) {
                node.setAttribute("rdf:datatype", "http://www.w3.org/2001/XMLSchema#boolean");
            }
        } else {
            node.setAttribute("rdf:resource", dto.getValue());
        }
    }
}
