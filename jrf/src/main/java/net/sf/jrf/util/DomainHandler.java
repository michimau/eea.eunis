/*
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations under
 * the License.
 *
 * The Original Code is jRelationalFramework.
 *
 * The Initial Developer of the Original Code is is.com.
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: James Evans (jevans@vmguys.com)
 * Contributor: ______________________________
 *
 * Alternatively, the contents of this file may be used under the terms of
 * the GNU General Public License (the "GPL") or the GNU Lesser General
 * Public license (the "LGPL"), in which case the provisions of the GPL or
 * LGPL are applicable instead of those above.  If you wish to allow use of
 * your version of this file only under the terms of either the GPL or LGPL
 * and not to allow others to use your version of this file under the MPL,
 * indicate your decision by deleting the provisions above and replace them
 * with the notice and other provisions required by either the GPL or LGPL
 * License.  If you do not delete the provisions above, a recipient may use
 * your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.util;

import java.io.*;
import java.sql.*;
import java.util.*;
import net.sf.jrf.*;
import net.sf.jrf.domain.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.rowhandlers.*;
import net.sf.jrf.sql.*;
import org.apache.log4j.Category;
import org.vmguys.util.*;

/**
 * A application framework pattern that handles the pooling of domains and
 * standard wrappings of methods.  Two standard domains are handled, one for searching
 * and one for updating and finding by primary key.
 */
public abstract class DomainHandler implements Serializable
{

    private static Category LOG = Category.getInstance(DomainHandler.class.getName());

    /** FindAll or searchable domain class name. */
    protected String searchDomainClassName = "";

    /** Fetch and save domain. */
    protected String fullDomainClassName = "";


    /**Constructor for the DomainHandler object */
    protected DomainHandler() { }

    /**
     * Protected constructor.
     *
     * @param searchDomainClassName  find domain class name that will be
     * used for <code>getAllAsList()</code>  and <code>getAllAsMap()</code> and any other
     * search parameter driven list fetch method by a sub-class.
     * @param fullDomainClassName domain class name that will be
     * used for updates and searches.
     */
    protected DomainHandler(String searchDomainClassName, String fullDomainClassName)
    {
        this.searchDomainClassName = searchDomainClassName;
        this.fullDomainClassName = fullDomainClassName;
    }

    /**
     * Get all objects as a list.
     *
     * @return   list of all objects or an empty list if none exist.
     * @see      #findByKey(Object)
     * @see      #getAllAsMap()
     */
    public List getAllAsList()
    {
        AbstractDomain domain = getDomain(searchDomainClassName);
        try
        {
            return domain.findAll();
        }
        finally
        {
            releaseDomain(domain);
        }
    }

    /** Creates embedded <code>PersistentObject</code>.
     * @return new instance of the embedded <code>PersistentObject</code>
     */
    public PersistentObject newPersistentObject() {
        AbstractDomain domain = getDomain(fullDomainClassName);
        try {
            return domain.newPersistentObject();
        }
        finally {
            releaseDomain(domain);
        }
    }

    /** Creates new embedded <code>PersistentObject</code>.
     * @param master <code>PersistentObject</code> instance that <em>must</em> be the
     *           parent record of <code>className</code> object.  For simple two-level
     *           composites, this value will be the type returned by <code>newPersistentObject</code>.
     * @param beanProperty bean name of <code>PersistentObject</code> to instantiate.
     * @return new instance of the embedded <code>PersistentObject</code>
     * @throws IllegalArgumentException if class name is invalid.
     * @throws ClassCastException if <code>master</code> is not the appropriate
     *                class type.
     * @see net.sf.jrf.domain.AbstractDomain#newEmbeddedPersistentObject(PersistentObject,String)
     * @see net.sf.jrf.domain.EmbeddedPersistentObjectHandler#getBeanAttribute()
     */
    public PersistentObject newEmbeddedPersistentObject(PersistentObject master, String beanProperty) {
        AbstractDomain domain = getDomain(fullDomainClassName);
        try {
            return domain.newEmbeddedPersistentObject(master,beanProperty);
        }
        finally {
            releaseDomain(domain);
        }

    }

    /** Copies keys from the master object to the embedded detail object.
     * @param master <code>PersistentObject</code> instance that <em>must</em> be the
     *           parent record of <code>className</code> object.  For simple two-level
     *           composites, this value will be the type returned by <code>newPersistentObject</code>.
     * @param embedded embedded <code>PersistentObject</code> instance to populate.
     * @param beanProperty bean name of accessor in <code>PersistentObject</code> to instantiate.
     * @throws IllegalArgumentException if class name of <code>embedded</code> is invalid.
     * @throws ClassCastException if <code>master</code> is not the appropriate
     *                class type.
     */
    public void populateEmbeddedObjectKeyValues(PersistentObject master, PersistentObject embedded,String beanProperty) {
        AbstractDomain domain = getDomain(fullDomainClassName);
        try {
            domain.populateEmbeddedObjectKeyValues(master,embedded,beanProperty);
        }
        finally {
            releaseDomain(domain);
    }
    }

   /** Returns a list of embedded <code>PersistentObject</code> class property names in this object.
    * @return a list of embedded property names in this object. An empty list will be returned if no embedded
    * <code>PersistentObject</code> class names exist.
    * @see #newEmbeddedPersistentObject(PersistentObject,String)
    */
    public List getEmbeddedPropertyNames() {
        AbstractDomain domain = getDomain(fullDomainClassName);
        try {
            return domain.getEmbeddedPropertyNames();
        }
        finally {
            releaseDomain(domain);
        }
    }

    /**
     * Returns complete composite object, if applicable, by searching the
     * database key on the <code>List</code> object of <code>PersistentObject</code>s
     * that contains an encoded key (<code>PersistentObject.getEncodedKey()</code>).
     *
     * @param list        <code>List</code> of objects to search.
     * @param encodedKey  key obtained via <code>PersistentObject.getEncodedKey()</code>.
     * @return            object that matches encoded key or <code>null</code> if not found.
     * @see               net.sf.jrf.domain.PersistentObject#getEncodedKey()
     * @see               #findIndexByKey(List,String)
     */
    public PersistentObject findByKey(List list, String encodedKey)
    {
        PersistentObject po = getPoInList(list, encodedKey);
        if (po == null)
        {
            LOG.error("findByKey(List," + encodedKey + ") called without key on the list.");
            return null;
        }
        return findByKey(po);
    }

    /**
     * Scans a list of <code>PersistentObject</code>s and return the object that
     * matches the key or <code>null</code> if not found.
     *
     * @param list        list of <code>PersistentObject</code>s to scan.
     * @param encodedKey  key to locate correct record on the list.
     * @return            key-matching record of <code>null</code> if not found.
     */
    public static PersistentObject getPoInList(List list, String encodedKey)
    {
        Iterator iter = list.iterator();
        while (iter.hasNext())
        {
            PersistentObject p = (PersistentObject) iter.next();
            if (p.getEncodedKey().equals(encodedKey))
            {
                return p;
            }
        }
        return null;
    }

    /**
     * Returns index of the object a <code>List</code> object of <code>PersistentObject</code>s
     * that contains an encoded key (<code>getEncodedKey()</code>).
     *
     * @param list        <code>List</code> of objects to search.
     * @param encodedKey  key obtained via <code>getEncodedKey()</code>.
     * @return            index of object on list or <code>-1</code> if not found.
     * @see               net.sf.jrf.domain.PersistentObject#getEncodedKey()
     * @see               #findByKey(List,String)
     */
    public static int findIndexByKey(List list, String encodedKey)
    {
        for (int i = 0; i < list.size(); i++)
        {
            PersistentObject p = (PersistentObject) list.get(i);
            if (p.getEncodedKey().equals(encodedKey))
            {
                return i;
            }
        }
        return -1;
    }

    /**
     * Get all objects as a map.
     *
     * @return   list of all objects or an empty list if none exist.
     * @see      #findByKey(Object)
     * @see      #getAllAsList()
     */
    public Map getAllAsMap()
    {
        AbstractDomain domain = getDomain(searchDomainClassName);
        try
        {
            ApplicationRowHandlerHashMap map = new ApplicationRowHandlerHashMap();
            domain.findAll(map);
            return (Map) map.getResult();
        }
        finally
        {
            releaseDomain(domain);
        }
    }

    /**
     * Fetches a specific object or object graph, in many cases one fetched
     * through a call to <code>getAllAsList()</code> or <code>getAllAsMap()</code>.
     *
     * @param key  object key.
     * @return     object under given key or <code>null</code> if not found.
     * @see        #getAllAsList()
     * @see        #getAllAsMap()
     */
    public PersistentObject findByKey(Object key)
    {
        AbstractDomain domain = getDomain(fullDomainClassName);
        try
        {
            // If a string decode to binary.
            if (key instanceof String)
            {
                key = domain.decodePrimaryKey((String) key);
            }
            return domain.find(key);
        }
        finally
        {
            releaseDomain(domain);
        }
    }

    /**
     * Finds by a specific where/clause order by parameter.  This method simply
     * wraps a poolable searchable <code>AbstractDomain.findWhereOrderBy()</code> method.
     *
     * @param whereClause    where clause
     * @param orderByClause  Description of the Parameter
     * @return               a list of objects that meet critieria.  An empty list will be returned if
     * no objects match.
     * @see                  net.sf.jrf.domain.AbstractDomain#findWhereOrderBy(String,String)
     */
    public List findWhereOrderBy(String whereClause, String orderByClause)
    {
        AbstractDomain domain = getDomain(searchDomainClassName);
        try
        {
            return domain.findWhereOrderBy(whereClause, orderByClause);
        }
        finally
        {
            releaseDomain(domain);
        }
    }

    /**
     * Finds by a specific prepared find statement by wrapping the poolable search
     *<code>AbstractDomain.findByPreparedStatement</code> method using the searchable domain.
     * Sub-classes must create the key. Calling this method is the equivalent of calling
     * <code>findByPreparedStatement(preparedStatementKey,handler,params,true)</code>.
     * @param preparedStatementKey       key added in <code>addPreparedFindStatement()</code>.
     * @param handler                    <code>ApplicationRowHandler</code> to use.
     * @param params                     list of object parameters to use to set up <code>PreparedStatment</code>.
     * @see #findByPreparedStatement(String,ApplicationRowHandler,List,boolean)
     */
    protected int findByPreparedStatement(String preparedStatementKey,
        ApplicationRowHandler handler, List params) {
        return findByPreparedStatement(preparedStatementKey,handler,params,true);
    }


    /** Finds by a specific prepared find statement by wrapping the poolable search
     *<code>AbstractDomain.findByPreparedStatement</code> method.  Sub-classes must create the key.
     * @param preparedStatementKey       key added in <code>addPreparedFindStatement()</code>.
     * @param handler                    <code>ApplicationRowHandler</code> to use.
     * @param params                     list of object parameters to use to set up <code>PreparedStatment</code>.
     * @param useSearchDomain        If <code>true</code>, <code>searchClassDomainClassName</code> will be
     *                   used. Otherwise, <code>fullDomainClassName will be used.
     * @return                           number of rows fetched.
     * @throws IllegalArgumentException  if number of parameters in <code>params</code> does not
     * match number of column specifications set in <code>addPreparedFindStatement()</code>.
     * @see                              net.sf.jrf.domain.AbstractDomain#findByPreparedStatement(String,ApplicationRowHandler,List)
     */
    protected int findByPreparedStatement(String preparedStatementKey,
        ApplicationRowHandler handler, List params,boolean useSearchDomain)
    {
        AbstractDomain domain = getDomain(useSearchDomain ? searchDomainClassName:fullDomainClassName);
        try
        {
            return domain.findByPreparedStatement(preparedStatementKey, handler, params);
        }
        finally
        {
            releaseDomain(domain);
        }
    }

     /** Finds by a specific prepared find statement with an array of  <code>Object</code> parameters,
     * using the search domain and returning the result as a <code>List</code>.
     * @param preparedStatementKey       key added in <code>addPreparedFindStatement()</code>.
     * @param params      <code>Object</code> array of search parameters.
     * @see #findByPreparedStatement(String,List,boolean)
     */
    protected List findByPreparedStatement(String preparedStatementKey, Object [] params) {
    ArrayList a = new ArrayList();
    for (int i = 0; i < params.length; i++)
        a.add(params[i]);
    return findByPreparedStatement(preparedStatementKey,a,true);
    }

     /** Finds by a specific prepared find statement with an array of  <code>Object</code> parameters,
     * returning the result as a <code>List</code>.
     * @param preparedStatementKey       key added in <code>addPreparedFindStatement()</code>.
     * @param params      <code>Object</code> array of search parameters.
     * @param useSearchDomain        If <code>true</code>, <code>searchClassDomainClassName</code> will be
     *                   used. Otherwise, <code>fullDomainClassName will be used.
     * @see #findByPreparedStatement(String,List,boolean)
     */
    protected List findByPreparedStatement(String preparedStatementKey, Object [] params, boolean useSearchDomain) {
    ArrayList a = new ArrayList();
    for (int i = 0; i < params.length; i++)
        a.add(params[i]);
    return findByPreparedStatement(preparedStatementKey,a,useSearchDomain);
    }

     /** Finds by a specific prepared find statement by wrapping the poolable search
     *<code>AbstractDomain.findByPreparedStatement</code> method using the searchable domain,
     * returning the result as a <code>List</code>.
     * Sub-classes must create the key. Calling this method is the equivalent of calling
     * <code>findByPreparedStatement(preparedStatementKey,params,true)</code>.
     * @param preparedStatementKey       key added in <code>addPreparedFindStatement()</code>.
     * @param params                     list of object parameters to use to set up <code>PreparedStatment</code>.
     * @see #findByPreparedStatement(String,List,boolean)
     */
    protected List findByPreparedStatement(String preparedStatementKey,List params) {
    return findByPreparedStatement(preparedStatementKey,params,true);
    }


    /**
     * Finds by a specific prepared find statement by wrapping the poolable search
     *<code>AbstractDomain.findByPreparedStatement</code> method and returning the result as
     * a <code>List</code>.  Sub-classes must create the key.
     *
     * @param preparedStatementKey       key added in <code>addPreparedFindStatement()</code>.
     * @param params                     list of object parameters to use to set up <code>PreparedStatment</code>.
     * @param useSearchDomain        If <code>true</code>, <code>searchClassDomainClassName</code> will be
     *                   used. Otherwise, <code>fullDomainClassName will be used.
     * @return                           <code>List</code> of rows fetched.
     * @throws IllegalArgumentException  if number of parameters in <code>params</code> does not
     * match number of column specifications set in <code>addPreparedFindStatement()</code>.
     * @see net.sf.jrf.domain.AbstractDomain#findByPreparedStatement(String,ApplicationRowHandler,List)
     */
    protected List findByPreparedStatement(String preparedStatementKey, List params,boolean useSearchDomain)
    {
    net.sf.jrf.rowhandlers.ApplicationRowHandlerList handler =
                new net.sf.jrf.rowhandlers.ApplicationRowHandlerList();
        findByPreparedStatement(preparedStatementKey, handler, params);
    return (List) handler.getResult();
    }

    /**
     * Updates a <code>PersistentObject</code> instance, in many cases one fetched
     * through a call to <code>findByKey()</code>.
     *
     * @param persistentObject               object to save.
     * @exception ObjectHasChangedException  Description of the Exception
     * @exception MissingAttributeException  Description of the Exception
     * @throws ObjectHasChangeException      when another user has already updated the record (i.e.
     *                  an optimistic lock error.
     * @throws MissingAtributeException      if the column specification for some fields are marked
     *                          as required and these fields are <code>null</code> in
     *                          the <code>PersistentObject</code> parameter.
     * @throws DuplicateRowException         if an insert operation fails or would fail because of
     *                        key duplication.
     * @throws InvalidValueException         if a value in a column is invalid (e.g. out of range).
     * @see                                  #findByKey(Object)
     */
    public void update(PersistentObject persistentObject)
        throws ObjectHasChangedException,
        MissingAttributeException,
        DuplicateRowException,
        InvalidValueException
    {
        AbstractDomain domain = getDomain(fullDomainClassName);
        try
        {
            domain.update(persistentObject);
        }
        finally
        {
            releaseDomain(domain);
        }
    }

    /**
     * Updates a <code>List</code> of objects obtained through a call to
     * <code>findAllByList()</code>.  Each modified row in the list will
     *                         be updated.
     *
     * @param list                           list of <code>PersistentObject</code>s.
     * @exception ObjectHasChangedException  Description of the Exception
     * @exception MissingAttributeException  Description of the Exception
     * @throws ObjectHasChangeException      when another user has already updated the record (i.e.
     *                  an optimistic lock error.
     * @throws MissingAtributeException      if the column specification for some fields are marked
     *                          as required and these fields are <code>null</code> in
     *                          the <code>PersistentObject</code> parameter.
     * @throws DuplicateRowException         if an insert operation fails or would fail because of
     *                        key duplication.
     * @throws InvalidValueException         if a value in a column is invalid (e.g. out of range).
     * @see                                  #findByKey(Object)
     * @see                                  #getAllAsList()
     */
    public void update(List list)
        throws ObjectHasChangedException,
        MissingAttributeException,
        DuplicateRowException,
        InvalidValueException
    {
        update(list.iterator());
    }

    /**
     * Deletes a <code>PersistentObject</code> instance, in many cases one fetched
     * through a call to <code>findByKey()</code>.  Calling this method is the equivalent of calling
     * <pre>delete( persistentObject, false)</pre>.  This method will <em>not</em> ignore
     * <code>ObjectHasChangedException</code>
     *
     * @param persistentObject               object to delete.
     * @throws ObjectHasChangeException      when another user has already delete the record (i.e.
     *                                       an optimistic lock error
     * @see                                  #findByKey(Object)
     * @see                                  #getAllAsList()
     * @see                                  #delete(PersistentObject,boolean)
     */
    public void delete( PersistentObject persistentObject )
        throws ObjectHasChangedException {
         delete( persistentObject, false );
    }

    /**
     * Deletes a <code>PersistentObject</code> instance, in many cases one fetched
     * through a call to <code>findByKey()</code>.
     *
     * @param persistentObject               object to delete.
     * @param ignoreChangedException         If <code>true</code>, <code>ObjectHasChangedException</code>
     *                                       will not be thrown, but ignored.
     * @throws ObjectHasChangeException      when another user has already delete the record (i.e.
     *                                       an optimistic lock error) and <code>ignoreChangedException</code>
     *                                       is <code>false</code>.
     * @see                                  #findByKey(Object)
     * @see                                  #getAllAsList()
     */
    public void delete(PersistentObject persistentObject, boolean ignoreChangedException )
        throws ObjectHasChangedException
    {
        AbstractDomain domain = getDomain(fullDomainClassName);
        PersistentObject objectToDelete = persistentObject;
        try
        {
            if (!fullDomainClassName.equals(searchDomainClassName))
            {
                // May have to fetch the composite object.
                objectToDelete = domain.find(persistentObject);
                if (objectToDelete == null)
                {
                    throw new ObjectHasChangedException(persistentObject);
                }// Handle race condition.
            }
            domain.delete(objectToDelete);
        }
    catch (ObjectHasChangedException oe) {
        if (!ignoreChangedException)
            throw oe;
    }
    catch (Exception ex ) {
        if (ex instanceof DatabaseException )
            throw (DatabaseException) ex;
        throw new DatabaseException(ex,"Unexpected delete exception");
    }
        finally {
            releaseDomain(domain);
        }
    }


    /**
     * Updates a <code>Map</code> of objects obtained through a call to
     * <code>findAllByMap()</code>.   Each modified row in the map will
     *                         be updated.
     *
     * @param map                            <code>HashMap</code> of <code>PersistentObject</code>s.
     * @exception ObjectHasChangedException  Description of the Exception
     * @exception MissingAttributeException  Description of the Exception
     * @throws ObjectHasChangeException      when another user has already updated the record (i.e.
     *                  an optimistic lock error.
     * @throws MissingAtributeException      if the column specification for some fields are marked
     *                          as required and these fields are <code>null</code> in
     *                          the <code>PersistentObject</code> parameter.
     * @throws DuplicateRowException         if an insert operation fails or would fail because of
     *                        key duplication.
     * @throws InvalidValueException         if a value in a column is invalid (e.g. out of range).
     * @see                                  #findByKey(Object)
     * @see                                  #getAllAsMap()
     */
    public void update(Map map)
        throws ObjectHasChangedException,
        MissingAttributeException,
        DuplicateRowException,
        InvalidValueException
    {
        update(map.values().iterator());
    }

    private void update(Iterator iter)
        throws ObjectHasChangedException,
        MissingAttributeException,
        DuplicateRowException,
        InvalidValueException
    {
        while (iter.hasNext())
        {
            PersistentObject po = (PersistentObject) iter.next();
            update(po);
        }
    }

    /**
     * Fetches requisite domain from a pool. Subclasses may override this method to add
     * more functionality.
     *
     * @param className  className of domain to fetch.
     * @return           The domain value
     */
    protected AbstractDomain getDomain(String className)
    {
        AbstractDomain domain = (AbstractDomain) ObjectPoolFactory.getObject(className);
        return domain;
    }

    /**
     * Releases domain back to a pool.  Sub-classes may override this method, if desired.
     *
     * @param domain  <code>AbstractDomain</code> instance to return to a pool.
     */
    protected void releaseDomain(AbstractDomain domain)
    {
        ObjectPoolFactory.returnObject(domain);
    }

}
