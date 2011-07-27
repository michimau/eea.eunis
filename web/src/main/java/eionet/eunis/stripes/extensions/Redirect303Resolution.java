package eionet.eunis.stripes.extensions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sourceforge.stripes.action.Resolution;

public class Redirect303Resolution implements Resolution {

    private String redirectPath;

    public Redirect303Resolution(String path) {
        redirectPath = path;
    }

    public void execute(HttpServletRequest request, HttpServletResponse response) {
        response.setStatus(HttpServletResponse.SC_SEE_OTHER);
        response.setHeader("Location", redirectPath);
    }

}
