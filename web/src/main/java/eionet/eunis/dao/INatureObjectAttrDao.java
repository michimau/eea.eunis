package eionet.eunis.dao;

/**
 * Interface for DAO operations related to the setup of "external data" (aka linked data) tabs on factsheets of species and
 * habitats for example.
 * 
 * @author jaanus
 */
public interface INatureObjectAttrDao {

    /** Possible object types for which linked data exists. */
    public enum ObjectType {
        SPECIES, HABITATS
    };

    /**
     * Returns FAO code for species from chm62edt_nature_object_attributes table.
     * 
     * @param natObjId
     *            - ID_NATURE_OBJECT.
     * @param name
     *            - name of the attribute.
     * @return FAO code.
     */
    String getNatObjAttribute(Integer natObjId, String name);

    /**
     * Returns true if query has any result for this species
     * 
     * @param natObjId
     *            - ID_NATURE_OBJECT.
     * @param queryId
     *            .
     * @param queriesName
     *            _linkedDataQueries or _conservationStatusQueries
     * @return boolean.
     */
    boolean queryResultExists(Integer natObjId, String queryId, String queriesName);

    /**
     * Inserts the given attribute to for all objects in a table identified by the given {@link ObjectType}.
     * For example {@link ObjectType#SPECIES} matches the chm62edt_species table.
     * @param objectType
     * @param attrName
     */
    public void insertNatureObjAttrForAll(ObjectType objectType, String attrName);

    /**
     * Appends the given value to the OBJECT field of the given attribute of the given objects in a table identified by the
     * given {@link ObjectType}. For example {@link ObjectType#SPECIES} matches the chm62edt_species table.
     * 
     * @param objectType
     * @param objectIds
     * @param attrName
     * @param attrValue
     */
    public void appendToNatureObjAttr(INatureObjectAttrDao.ObjectType objectType, String objectIds, String attrName, String attrValue);

    /**
     * Deletes all chm62edt_nature_object_attributes records where NAME matches the given attribute name, OBJECT is empty
     * and the nature object's type is determined by the given object type.
     * 
     * @param objectType
     * @param attrName
     */
    public void deleteEmptyNatureObjAttrsForAll(ObjectType objectType, String attrName);

    /**
     * Deletes all chm62edt_nature_object_attributes where NAME matches the given attribute name and the nature object's type
     * is determined by the given object type.
     * 
     * @param objectType
     * @param attrName
     */
    public void deleteNatureObjAttrsForAll(ObjectType objectType, String attrName);
}
