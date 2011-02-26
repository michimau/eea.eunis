package ro.finsiel.eunis.urls;


import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ro.finsiel.eunis.utilities.SQLUtilities;


public class Urls extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String SQL_DRV = request.getSession().getServletContext().getInitParameter(
                "JDBC_DRV");
        String SQL_URL = request.getSession().getServletContext().getInitParameter(
                "JDBC_URL");
        String SQL_USR = request.getSession().getServletContext().getInitParameter(
                "JDBC_USR");
        String SQL_PWD = request.getSession().getServletContext().getInitParameter(
                "JDBC_PWD");

        try {

            SQLUtilities sql = new SQLUtilities();

            sql.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            StringBuffer s = new StringBuffer();

            s.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>").append("<rdf:RDF").append(" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"").append(" xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"").append(" xmlns:seis=\"http://www.eionet.europa.eu/rdf/seis/\"").append(
                    ">");

            List<String> urls = sql.getUrls();

            for (String url : urls) {
                s.append("<seis:Resource rdf:about=\"").append(url).append(
                        "\"/>");
            }

            s.append("</rdf:RDF>");

            response.setContentType("application/rdf+xml;charset=UTF-8");
            response.setHeader("Content-Disposition",
                    "attachment; filename=urls.rdf");

            response.getWriter().write(s.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
