/*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is Content Registry 3
 *
 * The Initial Owner of the Original Code is European Environment
 * Agency. Portions created by TripleDev or Zero Technologies are Copyright
 * (C) European Environment Agency.  All Rights Reserved.
 *
 * Contributor(s):
 *        jaanus
 */

package eionet.eunis.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;

import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.search.CountryUtil;
import eionet.eunis.stripes.actions.CountryFactsheetActionBean;

/**
 * Redirects requests to the sites-statistical-result.jsp, species-country-result.jsp and habitats-country-result.jsp.
 *
 * @author jaanus
 */
public class StatisticalResultRedirectServlet extends HttpServlet {

    /**  */
    private static final long serialVersionUID = -9202192573370667747L;

    /*
     * (non-Javadoc)
     *
     * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    /*
     * (non-Javadoc)
     *
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp);
    }

    /**
     *
     * @param req
     * @param res
     * @throws ServletException
     * @throws IOException
     */
    private void handleRequest(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        Chm62edtCountryPersist country = null;

        String servletPath = req.getServletPath();
        if (servletPath == null) {
            return;
        } else if (servletPath.endsWith("sites-statistical-result.jsp") || servletPath.endsWith("habitats-country-result.jsp")) {
            String countryNameEn = req.getParameter("country");
            if (StringUtils.isNotBlank(countryNameEn)) {
                country = CountryUtil.findCountry(countryNameEn);
            }
        } else if (servletPath.endsWith("species-country-result.jsp")) {
            int countryId = NumberUtils.toInt(req.getParameter("country"));
            if (countryId > 0) {
                country = CountryUtil.findCountry(countryId);
            } else {
                String countryNameEn = req.getParameter("countryName");
                if (StringUtils.isNotBlank(countryNameEn)) {
                    country = CountryUtil.findCountry(countryNameEn);
                }
            }
        }

        if (country == null) {
            res.sendRedirect(req.getContextPath() + "/countries/NOT_FOUND");
        } else {

            String redirUrl = req.getContextPath() + "/countries/" + country.getEunisAreaCode();

            if (servletPath.endsWith("sites-statistical-result.jsp")) {
                boolean showDesignations = BooleanUtils.toBoolean(req.getParameter("showDesignations"));
                if (showDesignations) {
                    redirUrl = redirUrl + "/" + CountryFactsheetActionBean.Tab.DESIG_TYPES;
                }
                redirUrl = redirUrl + reconstructQueryString(req.getParameterMap(), "country", "showDesignations");
            } else if (servletPath.endsWith("species-country-result.jsp")) {
                redirUrl = redirUrl + "/" + CountryFactsheetActionBean.Tab.SPECIES;
                redirUrl = redirUrl + reconstructQueryString(req.getParameterMap());
            } else if (servletPath.endsWith("habitats-country-result.jsp")) {
                redirUrl = redirUrl + "/" + CountryFactsheetActionBean.Tab.HABITAT_TYPES;
                redirUrl = redirUrl + reconstructQueryString(req.getParameterMap());
            }
            res.sendRedirect(redirUrl);
        }
    }

    /**
     *
     * @param paramsMap
     * @param skipParams
     * @return
     */
    @SuppressWarnings("rawtypes")
    private String reconstructQueryString(Map paramsMap, String... skipParams) {

        if (paramsMap == null || paramsMap.isEmpty()) {
            return "";
        }

        List<String> skipList = skipParams == null ? new ArrayList<String>() : Arrays.asList(skipParams);

        StringBuilder buf = new StringBuilder();
        for (Iterator iter = paramsMap.entrySet().iterator(); iter.hasNext();) {

            Map.Entry entry = (Entry) iter.next();
            String paramName = entry.getKey().toString();
            if (!skipList.contains(paramName)){
                String[] paramValues = (String[]) entry.getValue();

                for (int i = 0; i < paramValues.length; i++) {
                    if (buf.length() > 0) {
                        buf.append("&");
                    }
                    buf.append(paramName).append("=").append(paramValues[i]);
                }
            }
        }

        return buf.length() > 0 ? "?" + buf.toString() : "";
    }

}
