package eionet.eunis.dto;

import java.lang.reflect.Field;

import org.simpleframework.xml.convert.Converter;
import org.simpleframework.xml.stream.InputNode;
import org.simpleframework.xml.stream.OutputNode;

/**
 * Converter class to convert {@link SpeciesAttributeDto} to xml.
 */
public final class SpeciesAttributeConverter implements Converter<SpeciesAttributeDto> {
	
	public SpeciesAttributeDto read(InputNode arg0) throws Exception {
		throw new IllegalStateException("not allowed");
	}
	
	public void write(OutputNode node, SpeciesAttributeDto dto) throws Exception {
		//small hacking, as OutputElement is not accessible
		Field name =  node.getClass().getDeclaredField("name");
		name.setAccessible(true);
		name.set(node, dto.getName());
		if (dto.isLiteral()) {
			node.setValue(dto.getValue());
		} else {
			node.setAttribute("rdf:resource", dto.getValue());
		}
	}
}