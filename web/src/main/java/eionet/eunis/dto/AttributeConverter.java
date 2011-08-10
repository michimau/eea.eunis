package eionet.eunis.dto;

import java.lang.reflect.Field;

import org.simpleframework.xml.convert.Converter;
import org.simpleframework.xml.stream.InputNode;
import org.simpleframework.xml.stream.OutputNode;

/**
 * Converter class to convert {@link AttributeDto} to xml.
 */
public final class AttributeConverter implements Converter<AttributeDto> {

    public AttributeDto read(InputNode arg0) throws Exception {
        throw new IllegalStateException("not allowed");
    }

    public void write(OutputNode node, AttributeDto dto) throws Exception {
        // small hacking, as OutputElement is not accessible
        Field name = node.getClass().getDeclaredField("name");

        name.setAccessible(true);
        name.set(node, dto.getName());
        if (dto.getType() != null) {
            if (dto.getType().equals("reference")) {
                node.setAttribute("rdf:resource", dto.getValue());
            } else {
                node.setValue(dto.getValue());
                if (dto.getType().length() > 0) {
                    node.setAttribute("rdf:datatype", "http://www.w3.org/2001/XMLSchema#" + dto.getType());
                }
            }
        }
    }
}
