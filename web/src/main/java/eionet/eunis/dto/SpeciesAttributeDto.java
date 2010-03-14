package eionet.eunis.dto;

import java.io.Serializable;
import java.lang.reflect.Field;

import org.simpleframework.xml.Root;
import org.simpleframework.xml.convert.Convert;
import org.simpleframework.xml.convert.Converter;
import org.simpleframework.xml.stream.InputNode;
import org.simpleframework.xml.stream.OutputNode;

/**
 * Dto object to hold species attributes.
 * 
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
@Root
@Convert(SpeciesAttributeDto.AttributeConverter.class)
public class SpeciesAttributeDto implements Serializable {
	
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String name;
	private boolean literal;
	private String value;
	
	public SpeciesAttributeDto() {
		//blank
	}
	
	public SpeciesAttributeDto(String name, boolean literal, String value) {
		this.name = name;
		this.literal = literal;
		this.value = value;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isLiteral() {
		return literal;
	}
	public void setLiteral(boolean literal) {
		this.literal = literal;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	
	/**
	 * Converter class to convert {@link SpeciesAttributeDto} to xml.
	 */
	public static final class AttributeConverter implements Converter<SpeciesAttributeDto> {
		
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
}



