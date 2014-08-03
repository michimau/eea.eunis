package ro.finsiel.eunis.search;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Filter to trim the input fields.
 * All requests containing "result" are intercepted and their parameters are trimmed.
 */
public class TrimFilter implements Filter {
    public void init(FilterConfig config)throws ServletException {
    }

    /**
     * Filters the requests and adds a trimming filter
     * Only filters the pages that contain "result"
     */
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        String url = "";
        if (request instanceof HttpServletRequest) {
            url = ((HttpServletRequest) request).getRequestURL().toString();
//            String queryString = ((HttpServletRequest) request).getQueryString();
        }

        if (url.contains("result")) {
            chain.doFilter(new FilteredRequest(request), response);
        } else {
            chain.doFilter(request, response);
        }

    }

    public void destroy() {
      /* Called before the Filter instance is removed
      from service by the web container*/
    }

    static class FilteredRequest extends HttpServletRequestWrapper {

        /**
         * The modified map to be accessed by the getParameterMap() method
         */
        private Map trimmedMap = null;
        private Map cachedMap = null;

        public FilteredRequest(ServletRequest request) {
            super((HttpServletRequest) request);
        }

        @Override
        public String getParameter(String paramName) {
            String value = super.getParameter(paramName);
            value = applyChanges(value);
            return value;
        }

        @Override
        public String[] getParameterValues(String paramName) {
            String values[] = super.getParameterValues(paramName);
            applyChanges(values);
            return values;
        }

        /**
         * Used to populate the page beans
         * @return A new parameter map containing the trimmed fields.
         */
        @Override
        public Map getParameterMap() {

            if(super.getParameterMap() != cachedMap){
                cachedMap = super.getParameterMap();
                trimmedMap = null;
            }

            if (trimmedMap == null) {
                HashMap h = new HashMap();
                h.putAll(cachedMap);
                for (Object o : h.keySet()) {
                    Object s = h.get(o);
                    if (s instanceof String[]) {
                        String[] sa = (String[]) s;
                        applyChanges(sa);
                    }
                }
                trimmedMap = h;
            }
            return trimmedMap;
        }

        /**
         * Implements the changes to the strings (trim)
         *
         * @param s The source string
         * @return the trimmed result
         */
        private String applyChanges(String s) {
            if(s != null){
                return s.trim();
            } else {
                return s;
            }
        }

        /**
         * Run applyChanges(String) for a String[]. The changes are applied in-place.
         *
         * @param strings The strings to be modified
         */
        private void applyChanges(String[] strings) {
            for (int i = 0; i < strings.length; i++) {
                strings[i] = applyChanges(strings[i]);
            }
        }
    }
}