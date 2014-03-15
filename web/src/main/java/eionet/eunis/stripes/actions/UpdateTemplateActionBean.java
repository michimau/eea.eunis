package eionet.eunis.stripes.actions;


import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.LinkedList;
import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.dataimport.parsers.CDDADesignationsCallback;
import ro.finsiel.eunis.dataimport.parsers.CallbackSAXParser;
import ro.finsiel.eunis.jrfTables.EunisISOLanguagesPersist;
import eionet.eunis.util.Pair;


/**
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/refreshtemplate")
public class UpdateTemplateActionBean extends AbstractStripesAction {

    public static final String HEADER = "header_template.jsp";
    public static final String FOOTER = "footer_template.jsp";
    public static final String REQUIRED_HEAD = "required_head_template.jsp";

    private List<String> errors = new LinkedList<String>();

    /**
     * updates the templates and redirects to result page
     * @return redirection
     */
    @DefaultHandler
    public Resolution defaultAction() {
        List<EunisISOLanguagesPersist> languages = getContentManagement().getTranslatedLanguages();
        // filtering the languages
        List<String> filteredLanguages = new LinkedList<String>();

        for (EunisISOLanguagesPersist language : languages) {
            if (language.getCode() != null
                    && !"en".equalsIgnoreCase(language.getCode().trim())) {
                filteredLanguages.add(language.getCode().trim().toLowerCase());
            }
        }

        // HEADER update
        String rawHeaderUrl = getContext().getApplicationProperty(
                "TEMPLATES_HEADER");

        // updating English template
        if (!updateTemplate(rawHeaderUrl.replace("#{lang}", ""), HEADER,
                "header_template.jsp", "EN")) {
            errors.add("Could not update header template for language EN");
        }
        // fetching localizations
        for (String language : filteredLanguages) {
            if (!updateTemplate(rawHeaderUrl.replace("#{lang}", language + '/'),
                    HEADER, "header_template.jsp", language)) {
                errors.add(
                        "Could not update header template for language "
                                + language);
            }
        }

        // FOOTER update
        String rawFooterUrl = getContext().getApplicationProperty(
                "TEMPLATES_FOOTER");

        // English template
        if (!updateTemplate(rawFooterUrl.replace("#{lang}", ""), FOOTER,
                "footer_template.jsp", "EN")) {
            errors.add("Could not update footer template for language EN");
            ;
        }
        // fetching localizations
        for (String language : filteredLanguages) {
            if (!updateTemplate(rawFooterUrl.replace("#{lang}", language + '/'),
                    FOOTER, "footer_template.jsp", language)) {
                errors.add(
                        "Could not update footer template for language "
                                + language);
                ;
            }
        }

        // REQUIRED_HEAD update
        String reqHeaderUrl = getContext().getApplicationProperty(
                "TEMPLATES_REQUIRED_HEAD");

        if (!updateTemplate(reqHeaderUrl, REQUIRED_HEAD,
                "required_head_template.jsp", "EN")) {
            errors.add("Could not update required head template for language EN");
            ;
        }

        // update the CDDA Destinations
        updateCDDADesignations("http://dd.eionet.europa.eu/CodelistServlet?id=66479&type=ELM&format=xml");

        if (!errors.isEmpty()) {
            logger.warn(errors.toString());
        }
        return new RedirectResolution("/templateUpdated.jsp");
    }

    private boolean updateTemplate(String url, String idPage, String description, String language) {
        Pair<Integer, String> result = getContentManagement().readContentFromUrl(
                url);

        if (result != null && result.getId() != null && result.getId() == 200
                && StringUtils.isNotBlank(result.getValue())) {
            return getContentManagement().savePageContentJDBC(idPage,
                    result.getValue(), description, language,
                    (short) result.getValue().length(), null, true,
                    getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                    getContext().getJdbcUser(), getContext().getJdbcPassword());
        }
        return false;
    }

    private boolean updateCDDADesignations(String url){
        Pair<Integer, String> result = getContentManagement().readContentFromUrl(url);
        if (result != null && result.getId() != null && result.getId() == 200
                && StringUtils.isNotBlank(result.getValue())) {

            CDDADesignationsCallback c = new CDDADesignationsCallback();
            CallbackSAXParser parser = new CallbackSAXParser(c);
            try {
                InputStream stream = new ByteArrayInputStream(result.getValue().getBytes("UTF-8"));
                BufferedInputStream bis = new BufferedInputStream(stream);
                parser.execute(bis);

                for(Pair<String, String> pair : c.getResultList()){
                    getContentManagement().savePageContentJDBC("CDDA_" + pair.getId(),
                            pair.getValue(), "dd.eionet.europa.eu/CodelistServlet?id=66479", "EN",
                            (short) pair.getValue().length(), null, true,
                            getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                            getContext().getJdbcUser(), getContext().getJdbcPassword());

                }

            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
            return true;
        }
        return false;
    }

    /**
     * @return the headerUpdated
     */
    public boolean isCorrectlyUpdated() {
        return errors.isEmpty();
    }

    /**
     * @return list errors
     */
    public List<String> getErrors() {
        return errors;
    }

}
