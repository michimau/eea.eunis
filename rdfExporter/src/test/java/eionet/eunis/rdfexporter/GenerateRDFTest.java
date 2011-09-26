package eionet.eunis.rdfexporter;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import junit.framework.TestCase;
import junit.framework.Assert;

/**
 * Uses the Reflection API to get private members
 * @see http://onjava.com/pub/a/onjava/2003/11/12/reflection.html
 * @see http://download.oracle.com/javase/tutorial/reflect/class/index.html
 * @see http://tutorials.jenkov.com/java-reflection/private-fields-and-methods.html
 */
class GenerateRDFTest extends TestCase {


    private void callParseName(String testString, String testDatatype,
              String expectedName, String expectedDatatype, String expectedLangcode) throws Exception {
        GenerateRDF classToTest = new GenerateRDF();
        Field f;
        final Method method = classToTest.getClass().getDeclaredMethod("parseName",
                   new Class[]{String.class, String.class});
        method.setAccessible(true);
        Object ret = method.invoke(classToTest, testString, testDatatype);
        f = ret.getClass().getDeclaredField("name");
        f.setAccessible(true);
        assertEquals(expectedName, (String) f.get(ret));

        f = ret.getClass().getDeclaredField("datatype");
        f.setAccessible(true);
        assertEquals(expectedDatatype, (String) f.get(ret));

        f = ret.getClass().getDeclaredField("langcode");
        f.setAccessible(true);
        assertEquals(expectedLangcode, (String) f.get(ret));
    }

    public void test_parseName() throws Exception {
        callParseName("hasRef->export", "", "hasRef", "->export", "");
        callParseName("hasRef->", "", "hasRef", "->", "");
        callParseName("price^^xsd:decimal", "", "price", "xsd:decimal", "");
        callParseName("title@de", "", "title", "", "de");
        callParseName("rdfs:label@de", "", "rdfs:label", "", "de");
        callParseName("rdfs:label", "", "rdfs:label", "", "");
        callParseName("title","xsd:string", "title", "xsd:string", "");
    }

    private void callInjectIdentifier(String testQuery, String testIdentifier,
              String expectedQuery) throws Exception {
        GenerateRDF classToTest = new GenerateRDF();
        String f;
        final Method method = classToTest.getClass().getDeclaredMethod("injectIdentifier",
                   new Class[]{String.class, String.class});
        method.setAccessible(true);
        Object ret = method.invoke(classToTest, testQuery, testIdentifier);
        f = (String) ret;
        assertEquals(expectedQuery, f);
    }

    public void test_injectIdentifier() throws Exception {
        // Test injection of identifier
        callInjectIdentifier("SELECT X AS id, * FROM Y", "819", 
                "SELECT X AS id, * FROM Y HAVING id='819'");
        callInjectIdentifier("SELECT X AS id, * FROM Y ORDER BY postcode", "819", 
                "SELECT X AS id, * FROM Y HAVING id='819' ORDER BY postcode");
        // Test injection of identifier with LIMIT
        callInjectIdentifier("SELECT X AS id, * FROM Y ORDER BY postcode LIMIT 10 OFFSET 2", "819", 
                "SELECT X AS id, * FROM Y HAVING id='819' ORDER BY postcode LIMIT 10 OFFSET 2");
        callInjectIdentifier("SELECT X AS id, * FROM Y LIMIT 10 OFFSET 2", "819", 
                "SELECT X AS id, * FROM Y HAVING id='819' LIMIT 10 OFFSET 2");
        // Test injection of identifier with HAVING
        callInjectIdentifier("SELECT X AS id, count(*) FROM Y GROUP BY id HAVING Z=1", "819", 
                "SELECT X AS id, count(*) FROM Y GROUP BY id HAVING id='819' AND Z=1");
        callInjectIdentifier("SELECT X AS id, count(*) FROM Y GROUP BY id HAVING Z=1 ORDER BY ID", "819", 
                "SELECT X AS id, count(*) FROM Y GROUP BY id HAVING id='819' AND Z=1 ORDER BY ID");
    }

    public static void main(String args[]) throws Exception {
        GenerateRDFTest testClass = new GenerateRDFTest();
        testClass.test_parseName();
        testClass.test_injectIdentifier();
    }
}
