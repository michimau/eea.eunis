package ro.finsiel.eunis.dataimport.parsers;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.BufferedInputStream;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Method;
import java.util.*;

/**
 * Generic SAX parser with callbacks.
 * <p/>
 * This parser will read the whole XML, keep the read values in memory, and call methods when a specific element is reached.
 * <p/>
 * To use:
 * Create a Class containing public methods with the following signature:
 *
 * @SaxCallback("Natura2000-SDF.SiteIdentification.SiteCode")
 * public void callSiteCode(String path, Values values) throws Exception { ... }
 *
 * <p/>
 * The annotation will be used to match the path in the XML, and at the <i>end</i> of the element, the callSiteCode method
 * will be called. The path parameter will contain the current path (same as the matching path, useful if the call matches
 * more than one path), and the Values is a Map containing all the previous values parsed from the XML.
 * There is no need to add callbacks for every data element, as they are added automatically to the Values map.
 * The Values map will contain only the <i>last</i> values in one path, so if there is a list of elements with the same
 * apparent path, the values <i>will</i> be overwritten. To receive warnings (stdout print) about overwritten values, callback
 * start and elements that are not found in the Values map please enable the debug flag.<br/>
 * <p/>
 * The Values is backed by a Map, but has a few more methods:
 * <p/>
 * public String getFromCurrent(String key);
 *
 * This method returns the values stored under the current path, so inside the "Natura2000-SDF.SiteLocation"
 * callback, the values.getFromCurrent("Latitude") is the same as values.get("Natura2000-SDF.SiteLocation.Latitude")
 * but easier to write.
 * <p/>
 * If needed, the current path of the Values map can be changed during callbacks without side effects.
 * <p/>
 * There are three special callback annotations:
 *
 * @SaxCallback("*")
 * public void callDebugPrint(String path, Values values){ ... }
 *
 * This callback matches all the elements that are not specifically included in other annotations.
 *
 * @SaxCallback(">start")
 * public void init() throws Exception{ ... }
 *
 * A method with this annotation will only be called once, <i>before</i> the parsing starts.
 * Important: this method has a different signature!
 *
 * @SaxCallback({">end"})
 * public void callFinal(List<Exception> exceptions) throws Exception {
 *
 * A method with this annotation will only be called once, <i>after</i> the parsing is finished.
 * Important: this method has a different signature! The parameter contains a list of all the Exceptions caught inside.
 * <p/>
 * If for some reason the defualt '.' (dot) path separator cannot be used, it can be overwritten (PATH_SEPARATOR),
 * <i>before</i> the parsing is started.
 * <p/>
 * Example:
 * For the following XML:
 * <a><b><c>C1</c><d>D1</d></b><b><c>C2</c><d>D2</d></b></a>
 * <p/>
 * Get a callback when the <b> element ends and read the values of <c> and <d>:
 * <p/>
 * public class Callback {
 *   @SaxCallback("a.b")
 *   public void callB(String path, Values values) {
 *   values.getFromCurrent("c");
 *   values.getFromCurrent("a.b.d");
 *  }
 * }
 * <p/>
 * Callback c = new Callback();
 * CallbackSAXParser csp = new CallbackSAXParser(c);
 * List<Exception> = csp.execute(bufferedInputStream);
 */
public class CallbackSAXParser extends DefaultHandler {

    public char PATH_SEPARATOR = '.';
    List<Exception> exceptionList;
    private BufferedInputStream inputStream;
    private StringBuffer buf;
    private Object callback;
    private Stack<String> stack;
    private Values values;
    /**
     * Receive warnings about overwritten and missing elements, and callback start
     */
    private boolean debug = false;
    private Map<String, Method> endElementMap = new HashMap<String, Method>();

    /**
     * @param callback The object that implements the callbacks, annotated with @SaxCallback
     */
    public CallbackSAXParser(Object callback) {
        this.callback = callback;
        buf = new StringBuffer();
        exceptionList = new ArrayList<Exception>();
        stack = new Stack<String>();
        values = new Values();

        // populate the call map from annotations
        for (Method m : callback.getClass().getDeclaredMethods()) {
            SaxCallback s = m.getAnnotation(SaxCallback.class);
            if (s != null) {
                for (String v : s.value())
                    endElementMap.put(v, m);
            }
        }
    }

    /**
     * Starts the parsing
     *
     * @param inputStream The input stream to be read
     * @return List of exceptions caught during the parsing
     * @throws Exception
     */
    public List<Exception> execute(BufferedInputStream inputStream) throws Exception {
        this.inputStream = inputStream;

        // runs the init procedure, if exists
        if (endElementMap.containsKey(">start")) {
            try {
                Method method = endElementMap.get(">start");
                method.invoke(callback);
            } catch (Exception e) {
                exceptionList.add(e);
            }
        }

        parseDocument();

        // runs the finish procedure, if exists
        if (endElementMap.containsKey(">end")) {
            try {
                Method method = endElementMap.get(">end");
                method.invoke(callback, exceptionList);
            } catch (Exception e) {
                exceptionList.add(e);
            }
        }

        return exceptionList;
    }

    private void parseDocument() throws SAXException {

        // get a factory
        SAXParserFactory spf = SAXParserFactory.newInstance();

        try {
            // get a new instance of parser
            SAXParser sp = spf.newSAXParser();

            // parse the file and also register this class for call backs
            sp.parse(inputStream, this);

        } catch (Exception e) {
            exceptionList.add(e);
        }
    }

    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        buf = new StringBuffer();
        stack.push(qName);
        int cleaned = values.cleanup(getFullPath());

        if (debug && cleaned > 0 && !endElementMap.containsKey(getFullPath())) {
            System.out.println("WARNING: Parsing problem: Path " + getFullPath() + " is not unique. You should add a callback for it!");
        }

    }

    public void characters(char[] ch, int start, int length) throws SAXException {
        buf.append(ch, start, length);
    }

    public void endElement(String uri, String localName, String qName) throws SAXException {
        String currentPath = getFullPath();

        if (buf.toString().trim().length() > 0)
            values.put(currentPath, buf.toString().trim());
        else {
            values.setCurrentPath(currentPath);
        }

        // callback
        if (endElementMap.containsKey(currentPath) || endElementMap.containsKey("*")) {
            try {
                Method method = endElementMap.get(currentPath);
                if (method == null)
                    method = endElementMap.get("*");
                else if (debug) System.out.println("Called " + method.getName());

                method.invoke(callback, currentPath, values);
            } catch (Exception e) {
                exceptionList.add(e);
            }
        }

        stack.pop();
        buf = new StringBuffer();
    }

    /**
     * Returns the current path in the XMl tree
     *
     * @return The path, separated by PATH_SEPARATOR
     */
    private String getFullPath() {
        String result = "";
        for (String s : stack.subList(0, stack.size()))
            result += s + PATH_SEPARATOR;
        if (result.length() > 0)
            result = result.substring(0, result.length() - 1);
        return result;
    }

    /**
     * Sets the debug flag, to get warnings on overwritten values and missing values.
     *
     * @param debug Debug flag value
     */
    public void setDebug(boolean debug) {
        this.debug = debug;
    }

    /**
     * Annotation to be added to the callback methods
     */
    @Target({ElementType.METHOD})
    @Retention(RetentionPolicy.RUNTIME)
    public @interface SaxCallback {
        String[] value();
    }

    /**
     * Map to keep the current read values.
     */
    public class Values {
        private HashMap<String, String> values;
        private String currentPath;

        /**
         * Default constructor
         */
        public Values() {
            values = new HashMap<String, String>();
            currentPath = "";
        }

        /**
         * Gets the object for the key
         *
         * @param key Key for the object
         * @return The object
         */
        public String get(String key) {
            return values.get(key);
        }

        /**
         * Adds an object to the map
         * Important! Lists of the same element (like: <a>bla</a><a>bla2</a>...) are squashed, only the last value is kept
         *
         * @param key   The key for the object
         * @param value The object
         */
        private String put(String key, String value) {
            String response = values.get(key);
            values.put(key, value);
            this.currentPath = key;
            return response;
        }

        /**
         * Removes one key
         *
         * @param key Key to be removed
         * @return The object removed
         */
        public String remove(String key) {
            return values.remove(key);
        }

        /**
         * Clean the data on the given path, removing the child elements
         *
         * @param path The path to be cleaned
         * @return Number of elements removed
         */
        private int cleanup(String path) {
            path = path + PATH_SEPARATOR;
            List<String> elementsToRemove = new ArrayList<String>();

            // remove all child elements from the hash
            for (String s : values.keySet())
                if (s.startsWith(path)) {
                    elementsToRemove.add(s);
                }

            for (String s : elementsToRemove)
                values.remove(s);

            return elementsToRemove.size();
        }

        /**
         * Sets the current path (used by getFromCurrent to reduce verbosity)
         *
         * @param currentPath Path to be set
         */
        public void setCurrentPath(String currentPath) {
            this.currentPath = currentPath;
        }

        /**
         * Returns the value of the given key in the current path
         *
         * @param key Key to be found
         * @return The value if found, or null if not
         */
        public String getFromCurrent(String key) {
            if (debug && !values.containsKey(currentPath + PATH_SEPARATOR + key))
                System.out.println("WARNING: getFromCurrent path " + currentPath + PATH_SEPARATOR + key + " not found");
            return values.get(currentPath + PATH_SEPARATOR + key);
        }

        /**
         * Lists all the keys under the current path
         *
         * @return List of keys
         */
        public List<String> getCurrentKeyList() {
            List<String> l = new ArrayList<String>();
            for (String s : values.keySet())
                if (s.startsWith(currentPath) && s.length() > currentPath.length()) {
                    l.add(s);
                }
            return l;
        }
    }
}
