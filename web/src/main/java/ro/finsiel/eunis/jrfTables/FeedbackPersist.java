package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * Date: 03.08.2003
 * Time: 23:30:38
 */
public class FeedbackPersist extends PersistentObject {

    private Integer IDFeedback = null;
    private String feedbackType = null;
    private String module = null;
    private String comment = null;
    private String name = null;
    private String email = null;
    private String company = null;
    private String address = null;
    private String phone = null;
    private String fax = null;
    private String url = "";

    public Integer getIDFeedback() {
        return IDFeedback;
    }

    public void setIDFeedback(Integer IDFeedback) {
        this.IDFeedback = IDFeedback;
        this.markModifiedPersistentState();
    }

    public String getFeedbackType() {
        return feedbackType;
    }

    public void setFeedbackType(String feedbackType) {
        this.feedbackType = feedbackType;
        this.markModifiedPersistentState();
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
        this.markModifiedPersistentState();
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
        this.markModifiedPersistentState();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.markModifiedPersistentState();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
        this.markModifiedPersistentState();
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
        this.markModifiedPersistentState();
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
        this.markModifiedPersistentState();
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
        this.markModifiedPersistentState();
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
        this.markModifiedPersistentState();
    }

    public String getURL() {
        return url;
    }

    public void setURL(String url) {
        this.url = url;
        this.markModifiedPersistentState();
    }
}
