package eionet.eunis;

import javax.servlet.*;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

/**
 * Filter for uniform encoding on all pages
 */
public class UTF8Filter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

}
