package ro.finsiel.eunis;

import org.junit.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Enumeration;
import java.util.Set;
import java.util.Vector;

import static junit.framework.Assert.assertEquals;

/**
 * Test class for ro.finisiel.eunis.Settings
 */
public class SettingsTest {

    @Test
    public void testGetSet(){
        String notSet = Settings.getSetting("test_setting");
        assertEquals("", notSet);
        Settings.setSetting("test_setting", "test");
        String nowSet = Settings.getSetting("test_setting");
        assertEquals("test", nowSet);
    }

    @Test
    public void testNulls(){
        Settings.setSetting("test_null_setting",null);
        assertEquals("",Settings.getSetting("test_null_setting"));

        Settings.setSetting(null, "abc");
        assertEquals("", Settings.getSetting(null));
    }

    @Test
    public void testLoad() throws ServletException {

        // initial value empty
        assertEquals("", Settings.getSetting("test_servlet_setting"));

        // Servlet stub to show one parameter to be loaded
        HttpServlet h = new HttpServlet(){
            @Override
            public ServletContext getServletContext() {
                return new ServletContext() {
                    @Override
                    public ServletContext getContext(String s) {
                        return null;
                    }

                    public String getContextPath() {
                        return null;
                    }

                    @Override
                    public int getMajorVersion() {
                        return 0;  
                    }

                    @Override
                    public int getMinorVersion() {
                        return 0;  
                    }

                    @Override
                    public String getMimeType(String s) {
                        return null;  
                    }

                    @Override
                    public Set getResourcePaths(String s) {
                        return null;  
                    }

                    @Override
                    public URL getResource(String s) throws MalformedURLException {
                        return null;  
                    }

                    @Override
                    public InputStream getResourceAsStream(String s) {
                        return null;  
                    }

                    @Override
                    public RequestDispatcher getRequestDispatcher(String s) {
                        return null;  
                    }

                    @Override
                    public RequestDispatcher getNamedDispatcher(String s) {
                        return null;  
                    }

                    @Override
                    public Servlet getServlet(String s) throws ServletException {
                        return null;  
                    }

                    @Override
                    public Enumeration getServlets() {
                        return null;  
                    }

                    @Override
                    public Enumeration getServletNames() {
                        return null;  
                    }

                    @Override
                    public void log(String s) {
                    }

                    @Override
                    public void log(Exception e, String s) {
                    }

                    @Override
                    public void log(String s, Throwable throwable) {
                    }

                    @Override
                    public String getRealPath(String s) {
                        return null;  
                    }

                    @Override
                    public String getServerInfo() {
                        return null;  
                    }

                    @Override
                    public String getInitParameter(String name) {
                        if(name.equals("test_servlet_setting"))
                            return "this_servlet_setting";
                        return null;
                    }

                    @Override
                    public Enumeration getInitParameterNames() {
                        Vector parameters =new Vector();
                        parameters.add("test_servlet_setting");
                        return parameters.elements();
                    }

                    @Override
                    public Object getAttribute(String s) {
                        return null;  
                    }

                    @Override
                    public Enumeration getAttributeNames() {
                        return null;  
                    }

                    @Override
                    public void setAttribute(String s, Object o) {
                    }

                    @Override
                    public void removeAttribute(String s) {
                    }

                    @Override
                    public String getServletContextName() {
                        return null;  
                    }
                };
            }
        };

        Settings.loadSettings(h);

        // now it's set
        assertEquals("this_servlet_setting", Settings.getSetting("test_servlet_setting"));
    }

}
