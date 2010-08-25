package eionet.eunis.dto;

import java.io.ByteArrayOutputStream;
import java.util.LinkedList;
import java.util.List;

import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;

import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.SpeciesFactsheetDto;
import junit.framework.TestCase;

/**
 * Unit test to test convertion mechanisms for {@link AttributeDto}.
 * 
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
public class SpeciesAttributeConverterTest extends TestCase {
	
	
	/**
	 * test converter mechanism
	 * @throws Exception
	 */
	public void testConverter() throws Exception {
		SpeciesFactsheetDto tested = new SpeciesFactsheetDto();
		List<ResourceDto> expectedInLocations = new LinkedList<ResourceDto>();
		ResourceDto location = new ResourceDto("id", "prefix");
		expectedInLocations.add(location);
		tested.setExpectedInLocations(expectedInLocations);
		List<AttributeDto> attributes = new LinkedList<AttributeDto>();
		attributes.add(new AttributeDto("literal", true, "literalValue"));
		attributes.add(new AttributeDto("link", false, "link_to_resource"));
		tested.setAttributes(attributes);
		Persister persister = new Persister(new AnnotationStrategy());
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		persister.write(tested, output);
		String outputString = output.toString();
		System.out.println(outputString);
		assertTrue(outputString.contains("<literal>literalValue</literal>"));
		assertTrue(outputString.contains("<link rdf:resource=\"link_to_resource\"/>"));
		assertTrue(outputString.contains("<isExpectedIn"));
	}

}
