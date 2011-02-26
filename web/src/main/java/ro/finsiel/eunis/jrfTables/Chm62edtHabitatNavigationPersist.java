/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:50 $
 **/
public class Chm62edtHabitatNavigationPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private String i_habitatCategory = null;

    /**
     * This is a database field.
     **/
    private String i_idQuestion = null;

    /**
     * This is a database field.
     **/
    private String i_idQuestionParent = null;

    /**
     * This is a database field.
     **/
    private Short i_level = null;

    /**
     * This is a database field.
     **/
    private String i_question = null;

    /**
     * This is a database field.
     **/
    private String i_questionDescription = null;

    /**
     * This is a database field.
     **/
    private String i_answer = null;

    /**
     * This is a database field.
     **/
    private String i_idQuestionChild = null;

    /**
     * This is a database field.
     **/
    private String i_node = null;

    public Chm62edtHabitatNavigationPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getAnswer() {
        return i_answer;
    }

    /**
     * Getter for a database field.
     **/
    public String getHabitatCategory() {
        return i_habitatCategory;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdQuestion() {
        return i_idQuestion;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdQuestionChild() {
        return i_idQuestionChild;
    }

    /**
     * Getter for a database field.
     **/
    public String getIdQuestionParent() {
        return i_idQuestionParent;
    }

    /**
     * Getter for a database field.
     **/
    public Short getLevel() {
        if (null == i_level) {
            return new Short((short) 0);
        }
        return i_level;
    }

    /**
     * Getter for a database field.
     **/
    public String getNode() {
        return i_node;
    }

    /**
     * Getter for a database field.
     **/
    public String getQuestion() {
        return i_question;
    }

    /**
     * Getter for a database field.
     **/
    public String getQuestionDescription() {
        return i_questionDescription;
    }

    /**
     * Setter for a database field.
     * @param answer
     **/
    public void setAnswer(String answer) {
        i_answer = answer;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param habitatCategory
     **/
    public void setHabitatCategory(String habitatCategory) {
        i_habitatCategory = habitatCategory;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idQuestion
     **/
    public void setIdQuestion(String idQuestion) {
        i_idQuestion = idQuestion;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idQuestionChild
     **/
    public void setIdQuestionChild(String idQuestionChild) {
        i_idQuestionChild = idQuestionChild;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idQuestionParent
     **/
    public void setIdQuestionParent(String idQuestionParent) {
        i_idQuestionParent = idQuestionParent;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param level
     **/
    public void setLevel(Short level) {
        i_level = level;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param node
     **/
    public void setNode(String node) {
        i_node = node;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param question
     **/
    public void setQuestion(String question) {
        i_question = question;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param questionDescription
     **/
    public void setQuestionDescription(String questionDescription) {
        i_questionDescription = questionDescription;
        this.markModifiedPersistentState();
    }

}
