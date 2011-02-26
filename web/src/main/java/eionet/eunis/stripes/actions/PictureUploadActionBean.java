package eionet.eunis.stripes.actions;


import java.io.File;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import ro.finsiel.eunis.factsheet.PicturesHelper;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPictureDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPicturePersist;
import eionet.eunis.util.JstlFunctions;


/**
 * @author alex
 *
 *         <a href="mailto:aleks21@gmail.com">contact<a>
 */
@UrlBinding("/pictures-upload.jsp")
public class PictureUploadActionBean extends AbstractStripesAction {

    private String operation;
    private String idobject;
    private String natureobjecttype;
    private String filename; // used only for deletion
    private String message;
    private String errorMessage;
    private boolean hasMain = false;

    @DefaultHandler
    public Resolution defaultAction() {
        if (!getContext().getSessionManager().isAuthenticated()
                || !getContext().getSessionManager().isUpload_pictures_RIGHT()) {
            errorMessage = JstlFunctions.cms(getContentManagement(),
                    "pictures_upload_login");
            return new ForwardResolution("/stripes/pictures-upload_error.jsp");
        }

        if (null != idobject && null != natureobjecttype && null != operation
                && operation.equalsIgnoreCase("upload")) {
            return uploadPicture();

        } else if (null != idobject && null != natureobjecttype
                && null != operation && operation.equalsIgnoreCase("delete")) {
            return deletePicture();
        } else {
            errorMessage = JstlFunctions.cms(getContentManagement(),
                    "pictures_upload_denied");
            return new ForwardResolution("/stripes/pictures-upload_error.jsp");
        }
    }

    public Resolution uploadPicture() {
        List<Chm62edtNatureObjectPicturePersist> pictureList = new Chm62edtNatureObjectPictureDomain().findWhere(
                "MAIN_PIC = 1 AND ID_OBJECT = " + idobject);

        if (pictureList != null && pictureList.size() > 0) {
            hasMain = true;
        }
        return new ForwardResolution("/stripes/pictures-upload.jsp");
    }

    private Resolution deletePicture() {
        boolean result = PicturesHelper.deletePicture(idobject, natureobjecttype,
                getScientificName(), filename);
        // Delete picture physically from disk
        String instanceHome = getContext().getServletContext().getRealPath("/");
        String baseDir = "";

        if (StringUtils.equalsIgnoreCase("species", natureobjecttype)) {
            baseDir = getContext().getInitParameter(
                    "UPLOAD_DIR_PICTURES_SPECIES");
        } else if (StringUtils.equalsIgnoreCase("sites", natureobjecttype)) {
            baseDir = getContext().getInitParameter("UPLOAD_DIR_PICTURES_SITES");
        } else if (StringUtils.equalsIgnoreCase("habitats", natureobjecttype)) {
            baseDir = getContext().getInitParameter(
                    "UPLOAD_DIR_PICTURES_HABITATS");
        }
        String absoluteFilename = instanceHome + baseDir + filename;
        File absolutFile = new File(absoluteFilename);

        if (absolutFile.exists()) {
            logger.debug("removing file:" + absoluteFilename);
            absolutFile.delete();
        }
        if (!result) {
            errorMessage = "failed to delete the picture";
            return new ForwardResolution("/stripes/pictures-upload_error.jsp");
        }
        return new RedirectResolution(
                "/pictures.jsp?idobject=" + idobject + "&natureobjecttype="
                + natureobjecttype);
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getIdobject() {
        return idobject;
    }

    public void setIdobject(String idobject) {
        this.idobject = idobject;
    }

    public String getNatureobjecttype() {
        return natureobjecttype;
    }

    public void setNatureobjecttype(String natureobjecttype) {
        this.natureobjecttype = natureobjecttype;
    }

    public String getScientificName() {
        if (StringUtils.equalsIgnoreCase(natureobjecttype, "species")) {
            return PicturesHelper.findSpeciesByIDObject(idobject);
        } else if (StringUtils.equalsIgnoreCase(natureobjecttype, "sites")) {
            return PicturesHelper.findSitesByIDObject(idobject);
        } else if (StringUtils.equalsIgnoreCase(natureobjecttype, "habitats")) {
            return PicturesHelper.findHabitatsByIDObject(idobject);
        }
        return "";
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public boolean isHasMain() {
        return hasMain;
    }

    public void setHasMain(boolean hasMain) {
        this.hasMain = hasMain;
    }
}
