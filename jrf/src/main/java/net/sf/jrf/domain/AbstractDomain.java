/*
 *  The contents of this file are subject to the Mozilla Public License
 *  Version 1.1 (the "License"); you may not use this file except in
 *  compliance with the License. You may obtain a copy of the License at
 *
 *  http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS IS"
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *  License for the specific language governing rights and limitations under
 *  the License.
 *
 *  The Original Code is jRelationalFramework.
 *
 *  The Initial Developer of the Original Code is is.com.
 *  Portions created by is.com are Copyright (C) 2000 is.com.
 *  All Rights Reserved.
 *
 *  Contributor(s): 	Jonathan Carlson (joncrlsn@users.sf.net)
 *  Contributor: 		James Evans (jevans@vmguys.com)
 *  Contributor(s): ____________________________________
 *
 *  Alternatively, the contents of this file may be used under the terms of
 *  the GNU General Public License (the "GPL") or the GNU Lesser General
 *  Public license (the "LGPL"), in which case the provisions of the GPL or
 *  LGPL are applicable instead of those above.  If you wish to allow use of
 *  your version of this file only under the terms of either the GPL or LGPL
 *  and not to allow others to use your version of this file under the MPL,
 *  indicate your decision by deleting the provisions above and replace them
 *  with the notice and other provisions required by either the GPL or LGPL
 *  License.  If you do not delete the provisions above, a recipient may use
 *  your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.domain;

import net.sf.jrf.*;
import net.sf.jrf.column.gettersetters.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.column.*;
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.join.*;
import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;
import net.sf.jrf.sqlbuilder.*;
import net.sf.jrf.rowhandlers.*;
import java.lang.reflect.Method;
import javax.sql.DataSource;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.beans.*;
import java.util.ArrayList;
import java.util.Properties;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import java.util.Enumeration;
import java.util.Map;
import java.util.StringTokenizer;
import java.lang.reflect.Field;
import org.apache.log4j.Category;

/**
 *  This class is the cornerstone of the framework. Extensions of this class
 *  have the responsibility of managing a specific <code>PersistentObject</code>
 *  sub-class. (See <code>PersistentObject</code> documentation for a
 *  description of the various flavors of <code>PersistentObject</code>s).
 *  Methods are provided to find by primary key, find by an adhoc SQL where
 *  clause, save the object and delete the object. In addition, methods exist to
 *  create and drop a table should the <code>PersistentObject</code> have the
 *  appropriate attributes that map directly to an SQL table. <p>
 *
 *  Sub-classes are required to implement two abstract protected methods, one
 *  relatively simple and one rather complex method. The simple method is: <p>
 *
 *  <pre>
 * 	public abstract PersistentObject newPersistentObject();
 * </pre> This implementation of the method usually just will require a call to
 *  the default constructor for the subclass of <code>PersistentObject</code>.
 *  The second, more complex method to implement is: <p>
 *
 *  <pre>
 * 	public abstract void setup();
 * </pre> This method is called by the constructor of this base class. <code>setup</code>
 *  is required to provide enough information to the base class to perform data
 *  management on the <code>PersistentObject</code>. Minimally, at least a table
 *  name and a single column specification must be specified. <p>
 *
 *  <b>Domains and Connections</b> <p>
 *
 *  Each domain contains single <code>JRFConnection</code> instance to manage
 *  interaction with the database. An application does not have direct control
 *  of setting the <code>JRFConnection</code> instance for the domain. Rather,
 *  applications have indirect control over the connection mechanism through one
 *  of three ways:
 *  <ol>
 *    <li> An application does not call any method on the domain to set up
 *    connection handling. When a connection to the database is required by the
 *    domain, the no-argument version <code>JRFConnectionFactory.create()</code>
 *    will instantiate a <code>JRFConnection</code> instance based on the JRF
 *    system <code>Properties</code> instance. This way of handling connections
 *    should suit the majority of applications.
 *    <li> An application explicitly sets the connection <code>Properties</code>
 *    instance to use for creating a <code>JRFConnection</code> instance via a
 *    call to <code>setProperties</code>. The domain will then use the <code>JRFConnectionFactory.create(Properties)</code>
 *    version to obtain a <code>JRFConnection</code> instance. This factory
 *    method will use whatever properties exist in the supplied argument and
 *    fallback on the JRF system <code>Properties</code> for any property value
 *    it does not find. See the documentation for <code>JRFConnectionFactory</code>
 *    for more details on this behavior.
 *    <li> An application may set a <code>DataSource</code> instance to use via
 *    a call to <code>setDataSource</code>. This methodology will suit
 *    applications where properties to instantiate a <code>DataSource</code> are
 *    not known at program start up. For example, an application server may
 *    receive a message with the requisite parameters for obtaining a <code>DataSource</code>
 *    through <code>JNDI</code>.
 *  </ol>
 *  <p>
 *
 *  <strong>Heavily-used Public Methods and Usage Contexts</strong>
 *  
 *  <table border=4>
 *    <thead>
 *
 *      <tr align='left'bgcolor='gold'>
 *
 *        <th>
 *          Method(s)
 *        </th>
 *
 *        <th>
 *          Description
 *        </th>
 *
 *        <th>
 *          Standard Usage Context
 *        </th>
 *
 *      </tr>
 *
 *    </thead>
 *    <tbody>
 *    <tr align='left'>
 *
 *      <th>
 *        public PersistentObject find(Object obj)
 *      </th>
 *
 *      <th>
 *        Finds a <code>PersistentObject</code> based on the primary key of the
 *        object. The single method parameter is either a simple wrapper object
 *        such as <code>String</code>, <code>Date</code> or <code>Integer</code>
 *        for single column primary key values or a <code>PersistentObject</code>
 *        for compound primary keys. In the latter case, user is obliged to set
 *        all the compound primary key values via the <code>PersistentObject</code>
 *        's setter methods.
 *      </th>
 *
 *      <th>
 *        When a single record (or master record and accompanying child records)
 *        needs to be fetched for potential update.
 *      </th>
 *
 *    </tr>
 *
 *    <tr align='left'>
 *
 *      <th>
 *        public void find(Object obj,ApplicationRowHandler handler)
 *      </th>
 *
 *      <th>
 *        Same as <code>find(Object)</code> except user may manage the returned
 *        <code>PersistentObject</code> while the <code>java.sql.ResultSet</code>
 *        is still in scope.
 *      </th>
 *
 *      <th>
 *        When binary, BLOB, or CLOB data is fetched.
 *      </th>
 *      .
 *    </tr>
 *
 *    <tr align='left'>
 *
 *      <th>
 *        public PersistentObject update(PersistentObject obj)
 *      </th>
 *
 *      <th>
 *        Updates the parameter <code>PersistentObject</code> and performs SQL
 *        DELETE,INSERT or UPDATEs based on the examination of the <code>PersistentState</code>
 *        of the <code>PersistentObject</code> and any potential child objects.
 *        In the case of master and detail objects, if the master is marked as
 *        deleted, all child objects will automatically be deleted.
 *      </th>
 *
 *      <th>
 *        To update the database with a given <code>PersistentObject</code>.
 *
 *      </th>
 *      .
 *    </tr>
 *
 *    <tr align='left'>
 *
 *      <th>
 *        public PersistentObject save(PersistentObject obj)
 *      </th>
 *
 *      <th>
 *        Equivalent of calling update(), but <code>PersistentState</code> is
 *        either new or modified.
 *      </th>
 *
 *      <th>
 *        To update the database with a given <code>PersistentObject</code>.
 *
 *      </th>
 *      .
 *    </tr>
 *
 *    <tr align='left'>
 *
 *      <th>
 *        public PersistentObject delete(PersistentObject obj)
 *      </th>
 *
 *      <th>
 *        Equivalent of calling <code>obj.forceDeletedPeristentState()<code> followed
 *by a call to <code>update()</code>.
 *      </th>
 *
 *      <th>
 *        To delete from the database a given <code>PersistentObject</code>.
 *
 *      </th>
 *      .
 *    </tr>
 *
 *    <tr align='left'>
 *
 *      <th>
 *        public List findAll()
 *      </th>
 *
 *      <th>
 *        Finds all records for the given persistent object and returns the
 *        result as a <code>java.util.List</code> object.
 *        <th>
 *          When the approximate total number of records for the <code>PersistentObject</code>
 *          is known and memory resources exist to hold all the records. Using
 *          findAll() for relatively small look up tables is a common practice.
 *
 *        </th>
 *
 *      </tr>
 *
 *      <tr align='left'>
 *
 *        <th>
 *          public List findWhereOrderBy(String whereClause,String orderBy)
 *
 *        </th>
 *
 *        <th>
 *          Finds and returns all records for the given persistent object based
 *          on the parameter where clause and orders the result by an optional
 *          order by clause.
 *          <th>
 *            When an application needs to fetch a sub-set of the data.
 *          </th>
 *
 *        </tr>
 *
 *        <tr align='left'>
 *
 *          <th>
 *            public List findWhereOrderBy(String whereClause,String orderBy,int
 *            maxRows)
 *          </th>
 *
 *          <th>
 *            Finds and returns all records for the given persistent object
 *            based on the parameter where clause and orders the result by an
 *            optional order by clause and restricts the total number or rows
 *            fetched.
 *            <th>
 *              When an application needs to fetch a sub-set of the data that
 *              might be quite large and need to handle paging. To implement
 *              paging, a user could qualify the where clause based on the last
 *              row fetched from a previous call.
 *            </th>
 *
 *          </tr>
 *
 *          <tr align='left'>
 *
 *            <th>
 *              public void findWhereOrderBy(String whereClause,String
 *              orderBy,int maxRows,ApplicationRowHandler handler)
 *            </th>
 *
 *            <th>
 *              Same as <code>findWhereOrderBy(String,String,int)</code> except
 *              that user determines the storage mechanism of the result.
 *            </th>
 *
 *            <th>
 *              When an application needs to fetch a sub-set of the data, but
 *              either needs to store the result in some else besides a <code>java.util.List</code>
 *              or needs to abort a fetch based on examination of some
 *              attributes of a given row.
 *            </th>
 *
 *          </tr>
 *
 *          <tr align='left'>
 *
 *            <th>
 *              public int findByPreparedStatement(String
 *              preparedStatementKey,ApplicationRowHandler handler,List params)
 *              throws IllegalArgumentException public void
 *              addPreparedFindStatement(String key,String tableName,String
 *              whereClause, String orderBy,List ColumnSpecs) and
 *              findByPreparedStatement(String key, ApplicationRowHandler
 *              handler,List params)
 *            </th>
 *
 *            <th>
 *              Allows a user to register an application-specific statement that
 *              will be stored by the framework as a prepared statement.
 *            </th>
 *
 *            <th>
 *              To reduce overhead of a constructing a static SQL for a
 *              considerably complex statement and where clause.
 *            </th>
 *
 *          </tr>
 *          </tbody>
 *        </table>
 *
 *
 *@see        net.sf.jrf.domain.PersistentObject
 *@see        #setup()
 *@see        net.sf.jrf.sql.JRFConnectionFactory
 */
public abstract class AbstractDomain
         implements JRFConstants {
    // Log4j static.
    final static Category LOG = Category.getInstance(AbstractDomain.class.getName());
    /////////////////////////////////////////////////////////////////////
    // Domain state variables.
    /////////////////////////////////////////////////////////////////////
    // State to disallow calls to public method (should be protected)
    // that should only be called from set up.
    private boolean setupComplete = false;
    private boolean i_inTransactionState = false;
    // If true, domain is part of trx process
    /////////////////////////////////////////////////////////////////////
    // Connection related resource variables.
    /////////////////////////////////////////////////////////////////////
    private JRFConnection i_jrfConnection = null;
    // Connection to use.
    private StatementExecuter i_stmtExecuter = null;
    // For convenience only -- stored in JRFConnection
    private DatabasePolicy i_databasePolicy = null;
    // For convenience only -- ditto
    private Properties i_connectionProperties = null;
    // Connection properties.
    private GetAutoIncrementIdHandler i_getAutoIncrementHandler = null;
    /////////////////////////////////////////////////////////////////////
    // Parameter values set directly or indirectly in setup() that
    // provide the required information to process a PersistentObject.
    /////////////////////////////////////////////////////////////////////
    private String i_tableName = null;
    private String i_propertyName = null;
    private String i_tableAlias = null;
    private String i_sequenceName = null;
    private String i_subtypeTableName = null;
    private String i_subtypeTableAlias = null;
    private JoinTable i_subtypeTable = null;
    private ArrayList i_subtypeColumnSpecs = new ArrayList();
    private ArrayList i_subtypeColSpecsForSql = null;
    private ArrayList i_columnSpecs = new ArrayList();
    // Keep a list of any sized columns specs --
    private Vector i_sizedColumnSpecs = new Vector();
    private ArrayList i_joinTables = new ArrayList();
    private ColumnSpec i_primaryKeyColumnSpec = null;
    private ColumnSpec i_subtypeIdentifierColumnSpec = null;
    private ColumnSpec i_subtypePrimaryKeyColumnSpec = null;
    private ArrayList i_otherPreparedStatements = new ArrayList();
    private ArrayList i_embeddedPersistentObjHandlers = new ArrayList();
    // This is a re-used utility variable for localUpdate()
    private ArrayList i_embeddedPersistentObjHandlersToFetch = new ArrayList();
    private boolean i_gotSequenceColumnToHandle = false;
    private boolean i_gotWriteableEmbeddedObjects = false;
    private boolean i_gotDeleteableEmbeddedObjects = false;
    private boolean i_gotWriteableTimestampDbColumns = false;
    private boolean i_gotCompoundPrimaryKey = false;
    private int i_embeddedObjectsContextAfterAll = 0;
    private int i_embeddedObjectsContextAfterEach = 0;
    private Vector i_updateListeners = new Vector();
    private static HashMap updateListeners = new HashMap();
    private HashMap embeddedPropertyNames = new HashMap(); // Map of persistent object class names 
							// managed by this object.
							// Key = className
							// Value = embeddedHandler
    final static Map s_subtypeDomains = new HashMap();

    private HashMap i_attributes = new HashMap();
    /////////////////////////////////////////////////////////////////////
    // Domain behavior properties variables.
    /////////////////////////////////////////////////////////////////////
    private boolean i_validateBeforeSaving = true;
    private boolean i_returnSavedObject = false;
    private boolean i_useAutoSetupNewColumnMethodology = true;
    private boolean i_usePostFind = true;
    private boolean i_supportValidateUnique = true;
    private boolean i_supportDuplicateKeyErrorCheck = false;
    private boolean i_readOnly = false;
    private boolean i_verifyDelete = true;

    /////////////////////////////////////////////////////////////////////
    // ResultPageIterator variables.
    /////////////////////////////////////////////////////////////////////
    /**
     *  This is the index of the first row to be converted to an object and
     *  returned. The index numbers start at 1 (not 0)
     */
    private int i_startingIndex = -1;
    /**
     *  This is the index of the last row to be converted to an object and
     *  returned. The index numbers start at 1 (not 0)
     */
    private int i_endingIndex = -1;

    /////////////////////////////////////////////////////////////////////
    // GetterSetter factory access variables.
    /////////////////////////////////////////////////////////////////////
    private Method getterSetterImplFactory = null;
    private Class poClass = null;

    /////////////////////////////////////////////////////////////////////
    // Process handling optimization variables.
    /////////////////////////////////////////////////////////////////////
    // find()
    ApplicationRowHandlerPrimaryKey primaryKeyRowHandler = new ApplicationRowHandlerPrimaryKey();
    // findCustom()
    ApplicationRowHandlerList listRowHandler = new ApplicationRowHandlerList();
    // Persist this guy for better performance.
    private SelectSQLBuilder i_selectSQLBuilder = null;
    private String psPrefix = null;
    // Prepared statement prefix (see init())
    protected JRFWriteTransaction localWriteTransaction = new JRFWriteTransaction();
    protected JRFReadTransaction localReadTransaction = new JRFReadTransaction();

    ///////////////////////////////////////////////////////////////
    // psKey offset locations for critical prepared statements
    // used by the domain.
    ///////////////////////////////////////////////////////////////
    private final static int PS_FIND = 0;
    // Find the base table by PK.
    private final static int PS_DELETE = 1;
    // Delete base table by PK.
    private final static int PS_INSERTBASE = 2;
    // Insert base table.
    private final static int PS_UPDATEBASE = 3;
    // Update base table.
    private final static int PS_INSERTSUB = 4;
    // Insert sub table.
    private final static int PS_UPDATESUB = 5;
    // Update sub table.
    private final static int PS_FINDALL = 6;
    // Find all records
    private final static int PS_GETLASTID = 7;
    // Last auto-increment id fetching SQL statement for db vendor.
    private final static int PS_STATEMENTS = 8;
    // Total statements.
    private String psKeySuffix[] = {
    // Keys to use for PreparedStatementListHandler
            "findbase",
            "delete",
            "insertbase",
            "updatebase",
            "insertsub",
            "updatesub",
            "findall",
            "getlastid",
            };
    private String psKey[] = new String[PS_STATEMENTS];

    // Constants for prepared statement type.
    private final static int PREPSTMT_SELECT = 0;
    private final static int PREPSTMT_DELETE = 1;
    private final static int PREPSTMT_UPDATE = 2;
    private final static int PREPSTMT_INSERT = 3;

    private final static String PREPAREDTYPES[] = {"Select", "Delete", "Update", "Insert"};


    /*
     *  ===============  Constructors  ===============
     */
    /**
     *  Default constructor. Sub-classes that call use this method in their
     *  constructors will use the JRF properties to set domain properties.
     *
     *@see    #AbstractDomain(Properties)
     */
    public AbstractDomain() {
        setDomainProperties(JRFProperties.getProperties());
        init();

    }

    // AbstractDomain()


    /**
     *  Constructs a domain using suppied post find option.
     *
     *@param  option  domain option.
     *@deprecated     Use <code>AbstractDomain(Properties)</code>.
     *@see            #AbstractDomain(Properties)
     *@see            #setUsePostFind(boolean)
     */
    public AbstractDomain(int option) {
        this();
        if (option == NO_POST_FIND) {
            this.setUsePostFind(false);
        }
    }


    /**
     *  Constructs an instance using <code>Properties</code> arguments for both
     *  domain and connection properties.
     *
     *@param  domainProperties  <code>Properties</code> instance containing
     *      domain properties.
     */
    public AbstractDomain(Properties domainProperties) {
        setDomainProperties(domainProperties);
        init();
    }


    /**
     *  Initialize a domain; call setup()
     *  Description of the Method
     */
    private void init() {
        PersistentObjectCache.findOrCreateCache(this.getClass());
        // Set up for prepared statement keys.
        int i = this.getClass().getName().lastIndexOf(".");
        if (i != -1) {
            psPrefix = this.getClass().getName().substring(i + 1);
        } else {
            psPrefix = this.getClass().getName();
        }
        for (i = 0; i < PS_STATEMENTS; i++) {
            psKey[i] = this.createPreparedStatementKey(psKeySuffix[i]);
        }
        if (i_useAutoSetupNewColumnMethodology) {
            String factoryName = null;
            try {
                this.poClass = newPersistentObject().getClass();
                factoryName = poClass.getPackage().getName() + ".generated.GetterSetterFactory" +
                        ReflectionHelper.getAbbreviatedClassName(this.poClass);
                Class c = java.lang.Class.forName(factoryName);
                getterSetterImplFactory = c.getMethod("getImpl", new Class[]{java.lang.String.class});
                LOG.info(this + ": FOUND " + factoryName + " for " + poClass.getName());
            } catch (Exception e) {
                LOG.info(this + ": Unable to find GetterSetter implementation factory for " + factoryName + ": "
                        + e.getClass().getName() + ": " + e.getMessage());
                getterSetterImplFactory = null;
            }
        }
        //////////////////////////////////////////////////////////////////////
        // Call abstract method to add table type, column specs, and so forth.
        if (LOG.isDebugEnabled()) {
            LOG.debug(this + ": calling setup()");
        }
        this.setup();
        setupComplete = true;
        //////////////////////////////////////////////////////////////////////
        // Make sure setup() did its job.
        if (i_tableName == null || i_tableName.trim().length() == 0) {
            throw new ConfigurationException(
                    "The table name was not set properly in the setup() method "
                    + "of this class: " + this.getClass());
        }
        if (i_columnSpecs.size() == 0) {
            throw new ConfigurationException("No column specs defined in " + this.getClass());
        }
        // Process what was added in setup();
        this.categorizeColumnSpecs();
        this.setupSubtypeObjects();
        /*
        boolean isCached = PersistentObjectCache.isClassCached(this.getClass());
        boolean isParentCached = PersistentObjectCache.isClassCached(this.getClass().getSuperclass());
         *  Don't do this -- TODO -- revisit this. It is fixable.
         *  if (isCached) {
         *  if (!isParentCached) {
         *  if (i_embeddedPersistentObjHandlers.size() > 0) {
         *  LOG.warn("WARNING",new ConfigurationException("You have specified this composite "+this.getClass()+" to cache "+
         *  " persistent objects, but not "+this.getClass().getSuperclass()+". "
         *  +this.getClass().getSuperclass()+" must NEVER be used in the "+
         *  " application or the cache maintained by "+this.getClass()+" will not be consistent."));
         *  }
         *  }
         *  }
         */
        //////////////////////////////////////////////////
        // Force read only status if joins exist. -- can't do this for legacy reason -- need to discuss
        //////////////////////////////////////////////////
        /*
         *  if (isJoinTableDomain())
         *  this.i_readOnly = true;
         */
        // Set up for transactions just within this domain and possible embedded object domains.
        this.localWriteTransaction.addDomain(this);
        this.localReadTransaction.addDomain(this);
	// Set up list of class names under the domain so that newPersistentObject(PersistentObject,String) 
	// can be called by user.
	addEmbeddedPropertyNames(this,this.embeddedPropertyNames);

    }

    /** Recursive method to gather all embedded class names in a composite.
    */
    private void addEmbeddedPropertyNames(AbstractDomain domain, HashMap map) {
        Iterator iterator = domain.i_embeddedPersistentObjHandlers.iterator();
        while (iterator.hasNext()) {
            EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
            AbstractDomain subDomain = handler.getDomain();
            if (subDomain != null) {
		addEmbeddedPropertyNames(subDomain,map);
    		map.put(handler.getBeanAttribute(),handler);
	    }
	}	
    }

    // Sets up the properties for the domain.
    /**
     *  Sets the domainProperties attribute of the AbstractDomain object
     *
     *@param  p  The new domainProperties value
     */
    private void setDomainProperties(Properties p) {
        i_validateBeforeSaving = JRFProperties.getBooleanProperty(p, "validateBeforeSaving", i_validateBeforeSaving);
        i_returnSavedObject = JRFProperties.getBooleanProperty(p, "returnSavedObject", i_returnSavedObject);
        i_usePostFind = JRFProperties.getBooleanProperty(p, "usePostFind", i_usePostFind);
        i_supportDuplicateKeyErrorCheck = JRFProperties.getBooleanProperty(p, "supportDuplicateKeyErrorCheck",
                i_supportDuplicateKeyErrorCheck);
        i_supportValidateUnique = JRFProperties.getBooleanProperty(p, "supportValidateUnique", i_supportValidateUnique);
        i_useAutoSetupNewColumnMethodology = JRFProperties.getBooleanProperty(p, "useAutoSetupNewColumnMethodology",
                i_useAutoSetupNewColumnMethodology);
        i_verifyDelete = JRFProperties.getBooleanProperty(p, "verifyDelete", i_verifyDelete);
    }


    /**
     *  This assumes there is one and only one primary key value attribute.
     *
     *@throws  ConfigurationException  if there is not exactly one primary key
     *      attribute or if there are more than one subtype identifier
     *      attributes.
     */
    private void categorizeColumnSpecs() {
        if (i_columnSpecs == null) {
            // Application developer error.
            throw new ConfigurationException(
                    "No ColumnSpecs have been defined for table '"
                    + i_tableName + "'.");
        }
        // Loop through attributes to find the primary key attribute.
        Iterator attributes = i_columnSpecs.iterator();
        while (attributes.hasNext()) {
            ColumnSpec aColumnSpec = (ColumnSpec) attributes.next();
            // If this is a sized column spec, add it to our list.
            if (aColumnSpec instanceof SizedColumnSpec) {
                i_sizedColumnSpecs.addElement(aColumnSpec);
            }
            if (aColumnSpec instanceof TimestampColumnSpecDbGen) {
                i_gotWriteableTimestampDbColumns = true;
            }
            if (aColumnSpec.isPrimaryKey()) {

                if (i_primaryKeyColumnSpec == null) {
                    i_primaryKeyColumnSpec = aColumnSpec;
                    if (i_primaryKeyColumnSpec instanceof CompoundPrimaryKeyColumnSpec) {
                        i_gotCompoundPrimaryKey = true;
                        CompoundPrimaryKeyColumnSpec cpk = (CompoundPrimaryKeyColumnSpec) this.i_primaryKeyColumnSpec;
                        if (cpk.hasEmbeddedSequenceColumn()) {
                            i_gotSequenceColumnToHandle = true;
                        }
                    } else if (i_primaryKeyColumnSpec.isSequencedPrimaryKey()) {
                        i_gotSequenceColumnToHandle = true;
                    }
                } else {
                    // Application developer error.
                    throw new ConfigurationException(
                            "Multiple primary key ColumnSpecs have been defined for '"
                            + i_tableName + "'.");
                }
            } else if (aColumnSpec.isSubtypeIdentifier()) {
                if (i_subtypeIdentifierColumnSpec == null) {
                    i_subtypeIdentifierColumnSpec = aColumnSpec;
                } else {
                    // Application developer error.
                    throw new ConfigurationException(
                            "Multiple subtype identifier ColumnSpecs have been defined for '"
                            + i_tableName + "'.");
                }
            }
        }
        // while

        // We should try taking this requirement out to see if a table with no
        // primary key works OK -- someone might want to do that.
        if (i_primaryKeyColumnSpec == null) {
            // Application developer error.
            throw new ConfigurationException(
                    "No primary key ColumnSpec for '"
                    + i_tableName + "' has been defined.");
        }
    }

    // categorizeColumnSpecs()


    /**
     *  This is called by the constructor after setup() is called
     */
    private void setupSubtypeObjects() {
        if (i_subtypeColumnSpecs.size() == 0) {
            return;
        }
        if (i_subtypeTableName == null) {
            throw new ConfigurationException("Subtype table name was not set.");
        }

        // Subtype table will be treated as a join table for 'select'ing.
        i_subtypeTable =
                new JoinTable(
                i_subtypeTableName + " " + i_subtypeTableAlias,
                i_primaryKeyColumnSpec.getColumnName(),
        // super (left) table columns
                i_primaryKeyColumnSpec.getColumnName());
        // sub table columns

        // Create columns for the subtype join table
        Iterator iterator = i_subtypeColumnSpecs.iterator();
        AbstractColumnSpec colSpec = null;
        // AbstractColumnSpec is intentional
        while (iterator.hasNext()) {
            // only AbstractColumnSpec and subclasses have buildJoinColumn()
            colSpec = (AbstractColumnSpec) iterator.next();
            i_subtypeTable.addJoinColumn(colSpec.buildJoinColumn());
        }

        // If there are sub columns and the super-class contains
        // a sequenced primary key, this must be changed to a natural primary key.
        // JE Change 3
        try {
            i_subtypePrimaryKeyColumnSpec = i_primaryKeyColumnSpec.getSubTypePrimaryKeyColumnSpec();
        } catch (CloneNotSupportedException ce) {
            throw new ConfigurationException("Clone not supported for column spec " + i_primaryKeyColumnSpec);
        }
        i_subtypeColSpecsForSql = getSubTypeColSpecsForSql();

    }


    /*
     *  ===============  Methods to Override  ===============
     */
    /**
     *  Provides the domain with the requisite information to perform its
     *  responsibilities of managing a <code>PersistentObject</code>. At an
     *  absolute minimum, this includes calls to:
     *  <ul>
     *    <li> setTableName(). Need to know entity name.
     *    <li> addColumnSpec(). Need at least one column.
     *  </ul>
     *  <p>
     *
     *  This method is called by the constructors. Failure for sub-classes to
     *  fill in required parameters will result in a <code>ConfigurationException</code>
     *  . <p>
     *
     *
     *
     *@see    #addColumnSpec(ColumnSpec)
     *@see    #addJoinTable(JoinTable)
     *@see    #setTableName(String)
     */
    protected abstract void setup();


    /**
     *  Returns new instance of the <code>PersistentObject</code> managed by
     *  this domain.
     *
     *@return    new instance of the <code>PersistentObject</code> managed by
     *      this domain.
     * @see #newPersistentObject()
     */
    public abstract PersistentObject newPersistentObject();


     /**  Returns a new instance of an embedded or detail <code>PersistentObject</code> managed by
     * this domain, accessible through a class name, copying
     * key values from the master <code>PersistentObject</code>
     * into the newly created detail record via a call to
     * <code>EmbeddedPersistentObjectHandler.populateEmbeddedObjectKeyValues()</code>.
     * <p><strong>NOTE</strong>
     *<p>
     * This method exists for an alternative way of updating a composite.  Rather than
     * handling inserts by updating an entire composite object, this method provides a way
     * to insert an individual component of a composite.
     *
     * @param master <code>PersistentObject</code> instance that <em>must</em> be the
     * 		     parent record of <code>className</code> object.  For simple two-level
     *		     composites, this value will be the type returned by <code>newPersistentObject</code>.
     * @param beanProperty bean attribute name of <code>PersistentObject</code> to instantiate.
     * @return new instanceo of the <code>PersistentObject</code>
     * @throws IllegalArgumentException if class name is invalid.
     * @throws ClassCastException if <code>master</code> is not the appropriate 
     *				  class type.
     * @see #newPersistentObject()
     * @see net.sf.jrf.domain.EmbeddedPersistentObjectHandler#populateEmbeddedObjectKeyValues(PersistentObject,PersistentObject)
     */
    public PersistentObject newEmbeddedPersistentObject(PersistentObject master, String beanProperty) 
			throws IllegalArgumentException, ClassCastException {
            EmbeddedPersistentObjectHandler handler = getHandler(beanProperty);
	    PersistentObject result = handler.getDomain().newPersistentObject();
	    handler.populateEmbeddedObjectKeyValues(master,result);
	    result.forceNewPersistentState();
	    return result;
    }

    /** Copies keys from the master object to the embedded detail object.
     * @param master <code>PersistentObject</code> instance that <em>must</em> be the
     * 		     parent record of <code>beanProperty</code> object.  For simple two-level
     *		     composites, this value will be the type returned by <code>newPersistentObject</code>.
     * @param embedded embedded <code>PersistentObject</code> instance to populate.
     * @param beanProperty bean attribute name of <code>PersistentObject</code> to instantiate.
     * @throws IllegalArgumentException if class name of <code>embedded</code> is invalid.
     * @throws ClassCastException if <code>master</code> is not the appropriate 
     *				  class type.
     */
    public void populateEmbeddedObjectKeyValues(PersistentObject master, PersistentObject embedded,
						String beanProperty) 
		throws IllegalArgumentException, ClassCastException  {
            EmbeddedPersistentObjectHandler handler = getHandler(beanProperty);
	    handler.populateEmbeddedObjectKeyValues(master,embedded);
    }

    private EmbeddedPersistentObjectHandler getHandler(String beanProperty) {
            EmbeddedPersistentObjectHandler handler = 
			(EmbeddedPersistentObjectHandler) embeddedPropertyNames.get(beanProperty);
	    if (handler == null) {
		IllegalArgumentException ex = new 
			IllegalArgumentException(this.getTableName()+": Bean property ["+beanProperty+
					"] is not valid: valid bean aggregate property names are: "+
					embeddedPropertyNames.keySet());
		LOG.error(ex.getMessage(),ex);
		throw ex;
	    }
   	    return handler;
    }

    /** Returns a list of embedded <code>PersistentObject</code> property names in this object.
    * @return a list of property names in this object. An empty list will be returned if no embedded
    * <code>PersistentObject</code> property names exist.
    * @see #newEmbeddedPersistentObject(PersistentObject,String)
    */
    public List getEmbeddedPropertyNames() {
	return new ArrayList(embeddedPropertyNames.keySet());
    }

    /**
     *  Returns the super-class version of the <code>PersistentObject</code>.
     *  This version returns <code>null</code>. Sub-classes that are composite
     *  objects should either write a generate a version that calls <code>super.newPersistentObject</code>
     *  .
     *
     *@return    version of parent <code>PersistentObject</code> if a composite
     *      object or <code>null</code> if no parent exists.
     */
    protected PersistentObject createParentPersistentObject() {
        return null;
    }


    /**
     *  Returns the super-class version of the <code>PersistentObject</code>
     *  encoded primary key. This version returns <code>null</code>.
     *
     *@param  aPO  <code>PersistentObject</code> instance of the parent. the
     *      <code>PersistentObject</code>. Sub-classes that are composite
     *      objects should either write a generate a version that calls <code>super.encodePrimaryKey()</code>
     *      .
     *@return      version of parent <code>PersistentObject</code> encoded
     *      primary key if a composite object or <code>null</code> if no *
     *      parent exists.
     */
    protected String getParentEncodedPrimaryKey(PersistentObject aPO) {
        return null;
    }


    /**
     *  Returns a version of the super class <code>PersistentObject</code> with
     *  values set from derived class. This version uses reflection. Sub-classes
     *  should override with a code-generated version. This method is used to
     *  keep a parent cache updated from changes to a composite object.
     *
     *@param  aPO  <code>PersistentObject</code> instance whose values to be set
     *      in a super-class version of the <code>PersistentObject</code>.
     *@return      super-class version of the <code>PersistentObject</code> with
     *      all values set from the derived version.
     */
    protected PersistentObject createAndPopulateParentPersistentObject(PersistentObject aPO) {
        PersistentObject result = createParentPersistentObject();
        if (result != null) {
            BeanInfo beanInfo;
            try {
                beanInfo = Introspector.getBeanInfo(result.getClass());
                // Get all methods.
            } catch (IntrospectionException ex) {
                throw new ConfigurationException(ex, "Unexpected introspection exception on " + result.getClass());
            }
            PropertyDescriptor[] properties = beanInfo.getPropertyDescriptors();
            for (int i = 0; i < properties.length; i++) {
                Method parentWriter = properties[i].getWriteMethod();
                Method parentReader = properties[i].getReadMethod();
                if (parentWriter != null && parentReader != null) {
                    try {
                        // Write base object instance property from property read from the composite.
                        // Note: this only works because a sub-class object attributes are
                        // copied to a base class.
                        Object childObj = parentReader.invoke(aPO, new Object[0]);
                        parentWriter.invoke(result, new Object[]{childObj});
                    } catch (Exception ex) {
                        // Throw error here???
                        LOG.error("Unexpected reflection exception in " + parentWriter.getName(), ex);
                    }
                }
            }
        }
        return result;
    }


    /*
     *  ===============  Static Methods  ===============
     */
    /**
     *  Informs this supertype domain class of a subtype domain class
     *
     *@param  subtypeIdentifierValue  - value of the SUBTYPE_IDENTIFIER field
     *@param  domainClass             - value of the SUBTYPE_IDENTIFIER field
     */
    public static synchronized void addSubtypeDomain(Object subtypeIdentifierValue,
            Class domainClass) {
        // Make sure the SUBTYPE_CODE field exists.
        Field subtypeCodeField = null;
        try {
            subtypeCodeField = domainClass.getField("SUBTYPE_CODE");
        } catch (Exception e) {
            String msg = "There is no public static SUBTYPE_CODE field defined "
                    + "in subtype class: " + domainClass.getName();
            LOG.error(msg, e);
            throw new ConfigurationException(e, msg);
        }
        Object codeValue = null;
        try {
            codeValue = subtypeCodeField.get(domainClass);
        } catch (Exception e) {
            String msg =
                    "There was a problem accessing the static SUBTYPE_CODE field "
                    + "in subtype class: " + domainClass.getName();
            LOG.error(msg, e);
            throw new ConfigurationException(e, msg);
        }
        s_subtypeDomains.put(codeValue, domainClass);
    }


    //////////////////////////////////////////////////////////////////////////
    /*
     *  BEGIN --  Getters and Setters of domain behavior variables
     */
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Sets connection properties to use. This method should usually be called
     *  from <code>setup</code>, but may be called in other places in an
     *  application. If a properties value is set, the <code>JRFConnectionFactory</code>
     *  method will use this value obtain a connection rather than the no
     *  argument version. <p>
     *
     *  The best context for this method to be called is before the first
     *  connection is required by the domain. If the method is called and an
     *  active underlying <code>JRFConnection</code> entity has been created for
     *  ths object, this instance will be closed and the next connection
     *  requirement will be fufilled by the properties argument supplied by this
     *  method. <p>
     *
     *  Generally applications will either use the strategy of calling this
     *  method or <code>setDataSource()</code> but rarely both.
     *
     *@param  p  connection properties to use.
     *@see       net.sf.jrf.sql.JRFConnectionFactory#create(Properties)
     *@see       net.sf.jrf.sql.JRFConnectionFactory#create()
     *@see       #setDataSource(DataSource)
     */
    public void setConnectionProperties(Properties p) {
        if (i_inTransactionState) {
            throw new IllegalStateException(this + " is currently in a transaction. Unable to set properties.");
        }
        if (i_jrfConnection != null) {
            LOG.info("Warning: setConnectionProperties() has been called after a JRFConnection entity has already been " +
                    "created.  Closing current JRFConnection instance.");
            i_jrfConnection.close();
            i_jrfConnection = null;
            // Force the next one from factory methods.
        }
        i_connectionProperties = p;
    }


    /**
     *  Gets value for whether domain will validate data before saving.
     *
     *@return    The validateBeforeSaving value
     *@see       #setValidateBeforeSaving(boolean)
     *@see       #validate(PersistentObject)
     *@see       #save(PersistentObject)
     */
    public boolean getValidateBeforeSaving() {
        return i_validateBeforeSaving;
    }


    /**
     *  Sets value for whether domain will validate data before saving.
     *
     *@param  b  if <code>true</code> <code>validate()</code> will be called in
     *      the save process.
     *@see       #getValidateBeforeSaving()
     *@see       #validate(PersistentObject)
     *@see       #save(PersistentObject)
     */
    public void setValidateBeforeSaving(boolean b) {
        i_validateBeforeSaving = b;
    }


    /**
     *  Gets the attribute to determine whether the object is refetched from the
     *  database and is returned to the user at the end of an update operation
     *  in the methods <code>save()</code> and <code>update()</code>. The
     *  default setting of this value is <code>false</code>. Only applications
     *  that need to know the values of <code>Timestamp</code> columns for
     *  successive updates should set this attribute to <code>true</code>. As
     *  far as integer optimistic lock columns and auto-sequence columns go,
     *  <code>update()</code> will call setters on the <code>PersistentObject</code>
     *  passed as parameter to update these values. Setting this value to <code>true</code>
     *  should be avoided since an unnecessary performance degradation is
     *  introduced with the refetching of record or records after every update.
     *  <p>
     *
     *  Generally, application contexts that use <code>Timestamp</code>
     *  optimistic lock columns with <i>successive</i> updates on the <i>same
     *  </i> object will require refetching the data. For example: <pre>
     *  		OpLockColumnDomain domain; 	// Domain that uses a timestamp op lock column
     *		OpLockObject obj;			// Persistent object managed by the domain.
     *		.
     *		obj = domain.find(key);		// Fetch a specific object under given key.
     *		.
     *	     obj.setAValue(value);		// Setting some value.
     *		.
     *		obj = domain.update(obj);	// Update it.
     *		.						// Allow object to have values updated again.
     *	     obj.setAValue(value);		// Setting some value.
     *		obj = domain.update(obj);	// Update it again.
     *
     * </pre> Obviously, using <code>Integer</code> optimistic lock columns will
     *  result in better performance since refetching will never be necessary.
     *
     *@return    if <code>true</code> object is refetched after a database save.
     *@see       #setReturnSavedObject(boolean)
     *@see       #save(PersistentObject)
     *@see       #update(PersistentObject)
     */
    public boolean getReturnSavedObject() {
        return i_returnSavedObject;
    }


    /**
     *  Sets the attribute to activate retrieving from the database the object
     *  just recently saved in a call to <code>save</code>.
     *
     *@param  b  if <code>true</code>, object will be refetched after a database
     *      save.
     *@see       #getReturnSavedObject()
     *@see       #save(PersistentObject)
     *@see       #update(PersistentObject)
     */
    public void setReturnSavedObject(boolean b) {
        i_returnSavedObject = b;
    }


    /**
     *  Gets whether the <code>postFindMethod()</code> will be called after a
     *  <code>find call.
     *
     *
     *
     *
     *@return    <code>true</code> if <code>postFind()</code> method will be
     *      called.
     *@see       #find(Object)
     */
    public boolean usePostFind() {
        return i_usePostFind;
    }


    /**
     *  Sets whether the <code>postFindMethod()</code> will be called after a
     *  <code>find call.
     *
     *
     *
     *
     *@param  b  if <code>true</code>, <code>postFind()</code> method will be
     *      called.
     *@see       #find(Object)
     */
    public void setUsePostFind(boolean b) {
        i_usePostFind = b;
    }


    /**
     *  Gets whether the <code>validateUnique</code> should be called in <code>validate()</code>
     *  . Application may wish to use duplicate key error codes in the database
     *  if supported and assure that this value is false.
     *
     *@return    <code>true</code> if <code>validateUnique</code> should be
     *      called in <code>validate()</code>
     *@see       #getSupportDuplicateKeyErrorCheck()
     *@see       #validate(PersistentObject)
     */
    public boolean getSupportValidateUnique() {
        return i_supportValidateUnique;
    }


    /**
     *  Sets whether the <code>validateUnique</code> should be called in <code>validate()</code>
     *  . Application may wish to use duplicate key error codes in the database
     *  if supported.
     *
     *@param  b  if <code>true</code> if <code>validateUnique</code> should be
     *      called in <code>validate()</code>.
     *@see       #validate(PersistentObject)
     *@see       #setSupportDuplicateKeyErrorCheck(boolean)
     */
    public void setSupportValidateUnique(boolean b) {
        this.i_supportValidateUnique = b;
    }


    /**
     *  Sets the attribute on whether a delete should be verified. The default
     *  behavior is to verify that a deletion has change and throw <code>ObjectHasChangeException</code>
     *  if the deletion deletes zero rows.
     *
     *@param  verifyDelete  if <code>true</code>, deletes will be verified.
     */
    public void setVerifyDelete(boolean verifyDelete) {
        this.i_verifyDelete = verifyDelete;
    }


    /**
     *  Gets attribute Determines whether a delete should be verified. The
     *  default behavior is to verify that a deletion has change and throw
     *  <code>ObjectHasChangeException</code> if the deletion deletes zero rows.
     *
     *@return    <code>true</code> if deletes will be verified.
     */
    public boolean isVerifyDelete() {
        return this.i_verifyDelete;
    }


    /**
     *  Gets whether the duplicate key error codes or error text search will be
     *  supported in database inserts. Database will have to support it, but an
     *  application may wish to use <code>validateUnique</code> alternatively.
     *
     *@return    <code>true</code> if duplicate key error codes/error text
     *      search should be supported in database inserts.
     *@see       #getSupportValidateUnique()
     */
    public boolean getSupportDuplicateKeyErrorCheck() {
        return i_supportDuplicateKeyErrorCheck;
    }


    /**
     *  Sets whether the duplicate key error codes will be supported in database
     *  inserts. Database will have to support it, but an application may wish
     *  to use <code>validateUnique</code> alternatively.
     *
     *@param  b  if <code>true</code>, duplicate key error codes/error text
     *      search should be supported in database inserts.
     *@see       #setSupportValidateUnique(boolean)
     *@see       net.sf.jrf.DatabasePolicy#DUPKEYCHECK_TEXT
     *@see       net.sf.jrf.DatabasePolicy#DUPKEYCHECK_CODE
     *@see       net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorCode()
     *@see       net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorText()
     *@see       net.sf.jrf.DatabasePolicy#getDuplicateKeyCheckType()
     */
    public void setSupportDuplicateKeyErrorCheck(boolean b) {
        this.i_supportDuplicateKeyErrorCheck = b;
    }


    /**
     *  Sets the internal transaction state flag of the domain. If set to <code>true</code>
     *  , all write methods (<code>update(), save(), delete</code>, etc.) will
     *  result deferring the commits or roll backs. In the case of both write
     *  and read methods (e.g. <code>find</code>), the connection will not be
     *  released via a call to <code>JRFConnection.closeOrReleaseResources()</code>
     *  . <i><b>WARNING:</b> This method should not be used under normal
     *  circumstances by an application. Use is best left in the hands of <code>JrfTransaction</code>
     *  . Injudicious use of this method could lead to unexpected consequences!
     *  </i>.
     *
     *@param  state  if <code>true</code>, commit/rollback and connection
     *      release will be deferred.
     *@see           net.sf.jrf.sql.JRFTransaction
     */
    public void setInTransactionState(boolean state) {
        this.i_inTransactionState = state;
    }


    /**
     *  Returns the current in-transaction state.
     *
     *@return    current in-transaction state.
     *@see       #setInTransactionState(boolean)
     */
    public boolean getInTransactionState() {
        return this.i_inTransactionState;
    }


    //////////////////////////////////////////////////////////////////////////
    /*
     *  END --  Getters and Setters of domain behavior variables
     */
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    /// BEGIN -- Connection handling private and public methods
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Returns the underlying database policy for the domain.
     *
     *@return    database policy used.
     *@see       #getJRFConnection()
     */
    public DatabasePolicy getDatabasePolicy() {
        // If there is a JRF connection; get the policy from the connection; otherwise, instantiate
        // a default properties instance
        if (i_databasePolicy != null) {
            return i_databasePolicy;
        }
        return DataSourceProperties.getInstance().getDatabasePolicy();
    }


    /**
     *  Returns <code>true</code> if a <code>JRFConnection</code> handle has
     *  been instantiated for this domain. Returns <code>false</code> if not.
     *
     *@return    <code>true</code> if a <code>JRFConnection</code> handle has
     *      been instantiated for this domain.
     */
    public boolean hasJRFConnection() {
        return i_jrfConnection == null ? false : true;
    }


    /**
     *  Sets the data source to use for obtaining a connection. If a <code>JRFConnection</code>
     *  instance has yet to be constructed for this domain, one will be
     *  constructed using this data source and a <code>DataSourceProperties</code>
     *  constructed from either the supplied connection properties instance or
     *  the JRF system <code>Properties</code> instance. This method is supplied
     *  mostly for applications that need to persist domains that may have use
     *  different <code>DataSource</code>s under the same set of properties.
     *
     *@param  dataSource              data source to use.
     *@throws  IllegalStateException  if domain is in a transaction state.
     *@see                            net.sf.jrf.sql.DataSourceChangeEventHandler#checkDataSourceChangeEvent(DataSource)
     *@see                            net.sf.jrf.sql.JRFConnection#JRFConnection(Object,DataSourceProperties)
     *@see                            #setConnectionProperties(Properties)
     *@see                            net.sf.jrf.sql.JRFConnectionFactory#create(Properties)
     *@see                            net.sf.jrf.sql.JRFConnectionFactory#create()
     */
    public void setDataSource(DataSource dataSource) {
        if (this.i_jrfConnection != null) {
            this.i_jrfConnection.setDataSource(dataSource);
        } else {
            JRFConnection newConn;
            if (i_connectionProperties == null) {
                newConn = new JRFConnection(dataSource, new DataSourceProperties(new Properties()));
            } else {
                newConn = new JRFConnection(dataSource, new DataSourceProperties(i_connectionProperties));
            }
            initConnectionEnvironment(newConn, false);
            setEmbeddedJRFConnection(newConn);
        }
    }


    /**
     *  Constructs a prepared statement key value, by combining a prefix that
     *  includes that class name followed by a user-supplied suffix.
     *
     *@param  suffix  Description of the Parameter
     *@return         a prepared statement key that may be used in <code>addPrepardFindStatement</code>
     *      or any of the <code>PreparedStatement</code> create methods.
     *@see            #addPreparedFindStatement(String,String,String,String,List)
     */
    public String createPreparedStatementKey(String suffix) {
        return psPrefix + "-" + suffix;
    }


    /**
     *  Gets the underlying <code>JRFConnection</code> used by this domain for
     *  database access. If <code>setDataSource()</code> was not explicitly
     *  called and there is no current <code>JRFConnection<code>
     * instantiated for this domain, one of the two factory creation methods will
     * be called dependent on whether connection properties have been
     * established for this class.
     * <p>
     *
     *  Under ordinary circumstances, there rarely should be a reason for an
     *  application to call this method. The framework needs this method to
     *  handle transactions.
     *
     *@return    <code>JRFConnection</code> handle used by the domain.
     *@see       #setConnectionProperties(Properties)
     *@see       #setDataSource(DataSource)
     *@see       net.sf.jrf.sql.JRFConnectionFactory#create()
     *@see       net.sf.jrf.sql.JRFConnectionFactory#create(Properties)
     *@see       net.sf.jrf.sql.JRFTransaction
     */
    public JRFConnection getJRFConnection() {
        if (i_jrfConnection == null) {
            LOG.debug(this + ".getJRFConnection(): connection handle about to be initialized.");
            initConnectionEnvironment(i_connectionProperties == null ?
                    JRFConnectionFactory.create() : JRFConnectionFactory.create(i_connectionProperties), false);
            setEmbeddedJRFConnection(i_jrfConnection);
        } else {
            LOG.debug(this + ".getJRFConnection(): connection handle ready to go.");
        }
        return i_jrfConnection;
    }


    /**
     *  Allow implementations to synchronize attributes, if desired. This method
     *  is designed for composites to allow them to synchronize a given
     *  attribute before a connection instantiation is attempted. Called before
     *  attempting to get a connection for the first time.
     */
    protected void synchronizeAttributes() { }


    // All embedded objects should use the same JRF connection handle.
    // For databases that enforce foreign key constraints, this is absolutely critical!
    /**
     *  Sets the embeddedJRFConnection attribute of the AbstractDomain object
     *
     *@param  conn  The new embeddedJRFConnection value
     */
    private void setEmbeddedJRFConnection(JRFConnection conn) {
        Iterator iterator = i_embeddedPersistentObjHandlers.iterator();
        while (iterator.hasNext()) {
            EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
            AbstractDomain domain = handler.getDomain();
            if (domain != null) {
                if (LOG.isDebugEnabled()) {
                    LOG.debug(this + ": recursively calling setEmbeddedJRFConnection() for " + domain);
                }
                domain.setEmbeddedJRFConnection(conn);
                if (domain.i_jrfConnection != null) {
                    if (LOG.isDebugEnabled()) {
                        LOG.debug(domain + " setting connection handle from master (" + this + ")");
                    }
                    domain.i_jrfConnection.close();
                    domain.i_jrfConnection = null;
                }
                domain.initConnectionEnvironment(conn, true);
            }
        }
    }


    /////////////////////////////////////////////////////////////////
    // Set up for a new JRFConnection - Normally, this method should be
    // called just once upon the first request for a database connection.
    // Jobs the will be done:
    //  - Assign convenience domain instance variables.
    //  - Instantiate the resuable SelectSQLBuilder instance.
    //  - Set up all prepared statements
    //  - Call SizedColumnSpec.setSqlType() for any SizedColumnSpec sub-class.
    //  - Set up for any sequence handling.
    /////////////////////////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  c           Description of the Parameter
     *@param  isEmbedded  Description of the Parameter
     */
    private void initConnectionEnvironment(JRFConnection c, boolean isEmbedded) {
        boolean redoPreparedStatements = true;
        if (i_jrfConnection != null) {
            // Have we gone from no-ANSI joins to ANSI joins or vice versa?
            // Are we using the same database policy instance?
            if (i_jrfConnection.getDataSourceProperties().isAnsiJoinSupported()
                    == i_selectSQLBuilder.getUseANSIJoins() &&
                    i_databasePolicy.getClass().getName().equals(c.getDatabasePolicy().getClass().getName())) {
                redoPreparedStatements = false;
            }
        }
        // Assign convenience variables.
        this.i_jrfConnection = c;

        this.i_stmtExecuter = c.getStatementExecuter();
        this.i_databasePolicy = c.getDatabasePolicy();
        // Heavyweight object; persist it.
        i_selectSQLBuilder = new SelectSQLBuilder(this,
                c.getDataSourceProperties().isAnsiJoinSupported());
        // Only have to redo prepared statements if policy and ANSI joins information has changed.
        if (!redoPreparedStatements) {
            return;
        }
        PreparedStatementListHandler preparedStatements = c.getPreparedStatementList();
        // Don't clear if embedded; will wipe out super-classes statemetns.
        if (!isEmbedded) {
            this.i_jrfConnection.setName(i_tableName);
            preparedStatements.clear();
            synchronizeAttributes();
        }
        // Set up for fetching the auto-increment value after the fetch, if required.
        if (i_gotSequenceColumnToHandle) {
            int type = i_databasePolicy.getSequenceSupportType();
	    if (type == DatabasePolicy.SEQUENCE_SUPPORT_NONE) {
                    throw new ConfigurationException(this + ": Database policy (" + (i_databasePolicy) + ") does not " +
                            "support sequenced primary keys yet you have specified one: "
                            + i_primaryKeyColumnSpec.getColumnName());
	    }
            // Set up embedded primary key column for implicit insert or external sequence based on the database type.
            if (this.i_primaryKeyColumnSpec instanceof CompoundPrimaryKeyColumnSpec) {
                   CompoundPrimaryKeyColumnSpec cpk = (CompoundPrimaryKeyColumnSpec) this.i_primaryKeyColumnSpec;
                   cpk.resolveSequenceColumns(i_databasePolicy);
            }
            type = i_databasePolicy.getSequenceFetchAfterInsertSupportType();
            switch (type) {
                case DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY:
                    preparedStatements.addNoParameterStatement(psKey[PS_GETLASTID],
                            i_databasePolicy.getFindLastInsertedSequenceSql(i_sequenceName, i_tableName));
                    i_getAutoIncrementHandler = new GetAutoIncrementIdSql();
                    break;
                case DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE:
                    i_getAutoIncrementHandler = new GetAutoIncrementIdByMethod();
                    break;
                default:
                    throw new ConfigurationException(i_primaryKeyColumnSpec.getColumnName() +
                            "is specified as sequenced column type yet the database policy (" +
                            i_databasePolicy + ") does not seem to have any way of fetching the last inserted " +
                            "value. Support type needs to be either " +
                            "DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY (" +
                            DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY +
                            ") or DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE (" +
                            +DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE + ").");
            }
        } else {
            i_getAutoIncrementHandler = new GetAutoIncrementIdNoOp();
        }
        // Set up all sized columns specs.
        for (int i = 0; i < i_sizedColumnSpecs.size(); i++) {
            SizedColumnSpec sz = (SizedColumnSpec) i_sizedColumnSpecs.elementAt(i);
            sz.setSqlType(this.i_databasePolicy);
        }

        // Prepared statements.
        // Select by PK Base
        preparedStatements.addSelectByPrimaryKeyStatement(
                psKey[PS_FIND],
                i_selectSQLBuilder,
                i_primaryKeyColumnSpec,
                i_tableAlias);
        // FindAll() prepared statement.
        i_selectSQLBuilder.setWhere(null);
        i_selectSQLBuilder.setOrderBy(null);
        preparedStatements.addNoParameterStatement(psKey[PS_FINDALL], i_selectSQLBuilder.buildSQL());
        // Add any user select statements added in setup()
        Iterator iter = i_otherPreparedStatements.iterator();
        while (iter.hasNext()) {
            OtherPreparedStatement us = (OtherPreparedStatement) iter.next();
            if (us.isFind) {
                preparedStatements.addSelectWhereOrderbyStatement(
                        us.key,
                        i_selectSQLBuilder,
                        us.whereClause,
                        us.orderBy,
                        us.tableName,
                        us.columnSpecs);
            } else {
                preparedStatements.addAdHocStatement(us.key, us.sql, us.columnSpecs);
            }
        }

        if (!i_readOnly) {
            // Insert base
            InsertSQLBuilder insertBuilder = this.getInsertSQLBuilder();
            UpdateSQLBuilder updateBuilder = this.getUpdateSQLBuilder();
            preparedStatements.addInsertStatement(
                    psKey[PS_INSERTBASE],
                    insertBuilder,
                    i_columnSpecs,
                    i_tableName);
            // Update base.
            preparedStatements.addUpdateStatement(
                    psKey[PS_UPDATEBASE],
                    updateBuilder,
                    i_columnSpecs,
                    i_tableName);

            if (i_subtypeColumnSpecs.size() == 0) {
                // Delete Base
                preparedStatements.addDeleteByPrimaryKeyStatement(
                        psKey[PS_DELETE],
                        i_primaryKeyColumnSpec,
                        i_tableName);
            } else {
                // Delete sub.
                preparedStatements.addDeleteByPrimaryKeyStatement(
                        psKey[PS_DELETE],
                        i_subtypePrimaryKeyColumnSpec,
                        i_subtypeTableName);

                preparedStatements.addInsertStatement(
                        psKey[PS_INSERTSUB],
                        insertBuilder,
                        i_subtypeColSpecsForSql,
                        i_subtypeTableName);
                // Update base.
                preparedStatements.addUpdateStatement(
                        psKey[PS_UPDATESUB],
                        updateBuilder,
                        i_subtypeColSpecsForSql,
                        i_subtypeTableName);
            }
        }
        addApplicationPreparedStatements(preparedStatements);
    }


    /**
     *  Add any additional prepared statements as required by a sub-class. This
     *  version will do nothing. Implementers should be aware that the framework
     *  will call this only when a <em>new</em> JRF connection is established.
     *
     *@param  preparedStatementHandler  for convenience, <code>PreparedStatementListHandler</code>
     *      that will be the same as object as the one obtained through <code>getJRFConnection().getPreparedStatementList()</code>
     *      .
     */
    protected void addApplicationPreparedStatements(PreparedStatementListHandler preparedStatementHandler) { }


    /**
     *@return        The jDBCHelper value
     *@deprecated    the <code>JDBCHelper</code> instance used is no longer of
     *      any use
     */
    public JDBCHelper getJDBCHelper() {
        throw new RuntimeException("setJDBCHelper() no longer in use. See JRFConnection. ");
    }


    /**
     *  Set underlying <code>JDBCHelper</code> instance to use.
     *
     *@param  helper  helper instance to use.
     *@deprecated     no longer in use.
     */
    public void setJDBCHelper(JDBCHelper helper) {
        throw new RuntimeException("setJDBCHelper() no longer in use. See JRFConnection.");
    }


    /////////////////////////////////////////////////////
    // Prepares for any database access operation.
    /**
     *  Description of the Method
     */
    private void assureDatabaseConnection() {
        try {
            this.getJRFConnection().assureDatabaseConnection();
        } catch (Exception ex) {
            throw new DatabaseException(ex, "Unable to get a database connection.");
        }
    }


    //////////////////////////////////////////////////////////
    // Execute statement wrappers				//
    //////////////////////////////////////////////////////////

    /// Static SQL ---
    //////////////////////////////////////////////////////////
    ////// Deprecated SQLUpdate
    //////////////////////////////////////////////////////////
    /**
     *  Deprecated method. Do not call.
     *
     *@param  sql          Description of the Parameter
     *@param  aJDBCHelper  Description of the Parameter
     *@return              Description of the Return Value
     *@deprecated          <code>AbstractDomain</code> does not use this method.
     *      If you wish to simply execute an SQL update statement, simply call
     *      <code>getJRFConnection.getStatementExecuter().executeUpdate(sql)</code>
     */
    protected int executeSQLUpdate(String sql, JDBCHelper aJDBCHelper) {
        return executeSQLUpdate(sql);
    }


    /**
     *  Executes static SQL non-query statement. This method does not rollback
     *  or commit data.
     *
     *@param  sql  SQL statement to execute. If you wish to simply execute an
     *      SQL update statement, simply call <code>getJRFConnection.getStatementExecuter().executeUpdate(sql)</code>
     *@return      Description of the Return Value
     */
    protected int executeSQLUpdate(String sql) {
        this.assureDatabaseConnection();
        int rowCount = 0;
        try {
            rowCount = i_stmtExecuter.executeUpdate(sql);
        } catch (Exception e) {
            handleDbException("AbstractDomain#excecuteSQLUpdate()", sql, e);
        } finally {
            if (!i_inTransactionState) {
                i_jrfConnection.closeOrReleaseResources();
            }
        }
        return rowCount;
    }


    /**
     *  Description of the Method
     *
     *@param  sql  Description of the Parameter
     */
    private void logQueryStatus(String sql) {
        if (i_inTransactionState) {
            LOG.debug("RUNNING A TRANSACTION-CONTEXT QUERY: [" + sql + "]");
        } else {
            LOG.debug("Executing domain query [" + sql + "] not under a transaction.");
        }
    }


    /////////////////////////////////////////////////////////////////////////////
    // Executes a static SQL statement, using the supplied row handler.
    // see findCustom()
    // Returns rows fetched.
    /////////////////////////////////////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  sql          Description of the Parameter
     *@param  aRowHandler  Description of the Parameter
     *@return              Description of the Return Value
     */
    private int executeSQLQuery(String sql, ApplicationRowHandler aRowHandler) {
        if (LOG.isDebugEnabled()) {
            logQueryStatus(sql);
        }
        int i = 0;
        boolean endAReadTransaction = checkReadTransactionBegin();
        try {
            aRowHandler.clear();
            JRFResultSet r = i_stmtExecuter.executeQuery(sql);
            i = (i_usePostFind ? appRowIteratorPostFind(aRowHandler, r) : appRowIterator(aRowHandler, r));
        } catch (Exception e) {
            handleDbException("AbstractDomain#executeSQLQuery()", sql, e);
        } finally {
            checkReadTransactionEnd(endAReadTransaction);
        }
        if (LOG.isDebugEnabled()) {
            LOG.debug(sql + " returned " + i + " row(s).");
        }
        return i;
    }


    // Set up for read transactions: critical for embedded objects.

    /**
     *  Description of the Method
     *
     *@return    Description of the Return Value
     */
    private boolean checkReadTransactionBegin() {
        if (!i_inTransactionState) {
            localReadTransaction.beginTransaction();
            return true;
            // Not in transaction; checkReadTransactionEnd() must finish up.
        }
        return false;
    }


    /**
     *  Description of the Method
     *
     *@param  endTransaction  Description of the Parameter
     */
    private void checkReadTransactionEnd(boolean endTransaction) {
        if (endTransaction) {
            localReadTransaction.endTransaction();
        }
    }


    ///////////////////////////////////////////////////////////////
    // Iterators for find with and without post find calls thus avoiding
    // a boolean value test on each row.
    ///////////////////////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  aRowHandler    Description of the Parameter
     *@param  r              Description of the Parameter
     *@return                Description of the Return Value
     *@exception  Exception  Description of the Exception
     */
    private int appRowIteratorPostFind(ApplicationRowHandler aRowHandler, JRFResultSet r) throws Exception {
        int i = 0;
        boolean keepFetching = true;
        PersistentObject aPO = null;
        while (keepFetching && r.next()) {
            aPO = convertToPersistentObject(r);
            keepFetching = aRowHandler.processRow(aPO);
            i++;
            if (i_embeddedObjectsContextAfterEach > 0) {
                constructEmbeddedObjectsForRow(aPO, r, i_embeddedPersistentObjHandlers);
            }
            postFind(aPO, r);
        }
        r.close();
        checkForEmbeddedObjectFetch(aPO, i_embeddedPersistentObjHandlers);
        return i;
    }


    /**
     *  Description of the Method
     *
     *@param  aRowHandler    Description of the Parameter
     *@param  r              Description of the Parameter
     *@return                Description of the Return Value
     *@exception  Exception  Description of the Exception
     */
    private int appRowIterator(ApplicationRowHandler aRowHandler, JRFResultSet r) throws Exception {
        int i = 0;
        boolean keepFetching = true;
        PersistentObject aPO = null;
        while (keepFetching && r.next()) {
            aPO = convertToPersistentObject(r);
            keepFetching = aRowHandler.processRow(aPO);
            i++;
            if (i_embeddedObjectsContextAfterEach > 0) {
                constructEmbeddedObjectsForRow(aPO, r, i_embeddedPersistentObjHandlers);
            }
        }
        r.close();
        checkForEmbeddedObjectFetch(aPO, i_embeddedPersistentObjHandlers);
        return i;
    }


    /**
     *  Description of the Method
     *
     *@param  aPO                     Description of the Parameter
     *@param  embeddedObjectsToFetch  Description of the Parameter
     */
    private void checkForEmbeddedObjectFetch(PersistentObject aPO, List embeddedObjectsToFetch) {
        if (aPO != null && i_embeddedObjectsContextAfterAll > 0) {
            this.constructEmbeddedObjectsAfterFetch(aPO, embeddedObjectsToFetch);
        }
    }


    // Just find the key record
    /**
     *  Description of the Method
     *
     *@param  pkOrPersistentObject    Description of the Parameter
     *@param  embeddedObjectsToFetch  Description of the Parameter
     *@param  usePostFind             Description of the Parameter
     *@return                         Description of the Return Value
     */
    private PersistentObject keyFind(Object pkOrPersistentObject, List embeddedObjectsToFetch, boolean usePostFind) {
        PersistentObject aPO = null;
        this.assureDatabaseConnection();
        JRFPreparedStatement stmt = i_jrfConnection.getPreparedStatementList().getAndPrepare(psKey[PS_FIND],
                pkOrPersistentObject);
        boolean endAReadTransaction = checkReadTransactionBegin();
        try {
            JRFResultSet r = i_stmtExecuter.executeQuery(stmt);
            if (r.next()) {
                aPO = convertToPersistentObject(r);
                aPO.forceCurrentPersistentState();
                // For key find, CONSTRUCT_CONTEXT_AFTER_EACH_ROW and CONSTRUCT_CONTEXT_AFTER_ALL_ROWS
                // contexts are equivalent.
                Iterator iterator = embeddedObjectsToFetch.iterator();
                while (iterator.hasNext()) {
                    EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
                    switch (handler.getConstructObjectContext()) {
                        case EmbeddedPersistentObjectHandler.CONSTRUCT_CONTEXT_AFTER_EACH_ROW:
                            handler.constructObjects(aPO, r);
                            break;
                        case EmbeddedPersistentObjectHandler.CONSTRUCT_CONTEXT_AFTER_ALL_ROWS:
                            handler.constructObjects(aPO);
                            break;
                        default:
                            break;
                    }
                }
                if (usePostFind) {
                    postFind(aPO, r);
                }
            }
        } catch (Exception e) {
            handleDbException("AbstractDomain#executePreparedSQLQuery()", stmt.getSql(), e);
        } finally {
            checkReadTransactionEnd(endAReadTransaction);
        }
        return aPO;
    }


    // Prepared SQL.
    /**
     *  Description of the Method
     *
     *@param  stmt         Description of the Parameter
     *@param  aRowHandler  Description of the Parameter
     *@return              Description of the Return Value
     */
    private int executePreparedSQLQuery(JRFPreparedStatement stmt, ApplicationRowHandler aRowHandler) {
        int i = 0;
        if (LOG.isDebugEnabled()) {
            logQueryStatus(stmt.getSql());
        }
        boolean endAReadTransaction = checkReadTransactionBegin();
        try {
            aRowHandler.clear();
            JRFResultSet r = i_stmtExecuter.executeQuery(stmt);
            i = (i_usePostFind ? appRowIteratorPostFind(aRowHandler, r) : appRowIterator(aRowHandler, r));
        } catch (Exception e) {
            handleDbException("AbstractDomain#executePreparedSQLQuery()", stmt.getSql(), e);
        } finally {
            checkReadTransactionEnd(endAReadTransaction);
        }
        return i;
    }

    // executePreparedSQLQuery(sqlString, aRowHandler)


    /**
     *  Description of the Method
     *
     *@param  p                          Description of the Parameter
     *@param  tableName                  Description of the Parameter
     *@return                            Description of the Return Value
     *@exception  DuplicateRowException  Description of the Exception
     */
    private int executePreparedSQLInsert(JRFPreparedStatement p, String tableName)
             throws DuplicateRowException {
        int rowCount = 0;
        try {
            rowCount = i_stmtExecuter.executeUpdate(p);
        } catch (Exception e) {
            handleDupKeyException(e, p.getSql());
            // If we get there.
            handleDbException("executePreparedSQLInsert()", p.getSql(), e);
        }
        if (rowCount < 1) {
            throw new DatabaseException(
                    "Insert into table (" + tableName
                    + ") failed.  Zero rows affected.");
        }
        return rowCount;
    }


    /**
     *  Description of the Method
     *
     *@param  stmt  Description of the Parameter
     *@return       Description of the Return Value
     */
    private int executePreparedSQLUpdate(JRFPreparedStatement stmt) {
        int rowCount = 0;
        try {
            rowCount = i_stmtExecuter.executeUpdate(stmt);
        } catch (Exception e) {
            handleDbException("AbstractDomain#excecutePreparedSQLUpdate()", stmt.getSql(), e);
        }
        return rowCount;
    }

    // executePreparedSQLUpdate(JRFPreparedStatement)


    /**
     *  Description of the Method
     *
     *@param  context  Description of the Parameter
     *@param  stmt     Description of the Parameter
     *@param  e        Description of the Parameter
     */
    private void handleDbException(String context, String stmt, Exception e) {
        LOG.error(context + " exception. Statment is " + stmt, e);
        if (e instanceof RuntimeException) {
            throw (RuntimeException) e;
        }
        throw new DatabaseException(e, stmt);
    }


    ///////////////////////////////////////////////////////

    // Handle dup key error from database vendor, if supported.
    ///////////////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  e                          Description of the Parameter
     *@param  sql                        Description of the Parameter
     *@exception  DuplicateRowException  Description of the Exception
     */
    private void handleDupKeyException(Exception e, String sql) throws DuplicateRowException {
        if (i_supportDuplicateKeyErrorCheck && e instanceof SQLException) {
            SQLException s = (SQLException) e;
            if (LOG.isDebugEnabled()) {
                LOG.debug("DuplicateRowException check: SQL Error code " + s.getErrorCode() + " must equal " +
                        i_databasePolicy.getDuplicateKeyErrorCode() + " or " +
                        s.getMessage() + " must contain [" + i_databasePolicy.getDuplicateKeyErrorText() + "]");
            }
            if ((i_databasePolicy.getDuplicateKeyCheckType() == DatabasePolicy.DUPKEYCHECK_CODE &&
                    i_databasePolicy.getDuplicateKeyErrorCode() == s.getErrorCode()) ||
                    (i_databasePolicy.getDuplicateKeyCheckType() == DatabasePolicy.DUPKEYCHECK_TEXT &&
                    s.getMessage().indexOf(i_databasePolicy.getDuplicateKeyErrorText()) != -1)) {
                throw new DuplicateRowException(sql + " generated a duplicate key error: "+e.getMessage());
            }
        }
    }


    /**
     *@param  sql          Description of the Parameter
     *@param  aRowHandler  Description of the Parameter
     *@param  aJDBCHelper  Description of the Parameter
     *@deprecated          <code>JDBCHelper</code> argument will be ignored.
     */
    protected void executeSQLQuery(String sql, RowHandler aRowHandler, JDBCHelper aJDBCHelper) {
        executeSQLQuery(sql, aRowHandler);
    }


    /**
     *  Execute the SQL and pass each row to the given RowHandler.
     *
     *@param  sql          a value of type 'String'
     *@param  aRowHandler  a value of type 'RowHandler' - This is an inner class
     *      that gets called for each row in the result set.
     */
    protected void executeSQLQuery(String sql, RowHandler aRowHandler) {
        assureDatabaseConnection();
        if (aRowHandler == null) {
            throw new IllegalArgumentException(
                    "A null value argument for aRowHandler was pass to "
                    + "AbstractDomain#executeSQLQuery(sql,handler,jdbcHelper)");
        }
        boolean endAReadTransaction = checkReadTransactionBegin();
        try {
            JRFResultSet r = i_stmtExecuter.executeQuery(sql);
            Object value = null;
            while (r.next()) {
                aRowHandler.handleRow(r);
            }
            // while
            r.close();
        } catch (Exception e) {
            handleDbException("AbstractDomain#executeSQLQuery()", sql, e);
        } finally {
            checkReadTransactionEnd(endAReadTransaction);
        }

    }

    // executeSQLQuery(sqlString, aRowHandler)


    /**
     *  Execute the prepared statement and pass each row to the given
     *  RowHandler.
     *
     *@param  stmt         <code>JRFPreparedStatement</code> instance.
     *@param  aRowHandler  a value of type 'RowHandler' - This is an inner class
     *      that gets called for each row in the result set.
     */
    protected void executeSQLQuery(JRFPreparedStatement stmt, RowHandler aRowHandler) {
        assureDatabaseConnection();
        if (aRowHandler == null) {
            throw new IllegalArgumentException(
                    "A null value argument for aRowHandler was pass to "
                    + "AbstractDomain#executeSQLQuery(sql,handler,jdbcHelper)");
        }
        boolean endAReadTransaction = checkReadTransactionBegin();
        try {
            JRFResultSet r = i_stmtExecuter.executeQuery(stmt);
            Object value = null;
            while (r.next()) {
                aRowHandler.handleRow(r);
            }
            // while
            r.close();
        } catch (Exception e) {
            handleDbException("AbstractDomain#executeSQLQuery()", stmt.getSql(), e);
        } finally {
            checkReadTransactionEnd(endAReadTransaction);
        }

    }

    // executeSQLQuery(sqlString, aRowHandler)

    //////////////////////////////////////////////////////////////////////////

    /// END -- Connection handling private and public methods
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  Domain set up methods and associated set up getters
    //////////////////////////////////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  t  Description of the Parameter
     */
    private void checkSetupState(String t) {
        if (setupComplete) {
            throw new IllegalStateException(t + " may not be called after setup() is complete!");
        }
    }


    /**
     *  Adds to the list of <code>EmbeddedPersistentObjectHandler</code>s for
     *  this domain.
     *
     *@param  handler  <code>EmbeddedPersistentObjectHandler</code> to add.
     *@see             net.sf.jrf.domain.EmbeddedPersistentObjectHandler
     */
    protected void addEmbeddedPersistentObjectHandler(EmbeddedPersistentObjectHandler handler) {
        checkSetupState("addEmbeddedPersistentObjectHandler()");
        i_embeddedPersistentObjHandlers.add(handler);
        // For optimization in fetches, keep count of context fetch type.
        switch (handler.getConstructObjectContext()) {
            case EmbeddedPersistentObjectHandler.CONSTRUCT_CONTEXT_AFTER_ALL_ROWS:
                i_embeddedObjectsContextAfterAll++;
                break;
            case EmbeddedPersistentObjectHandler.CONSTRUCT_CONTEXT_AFTER_EACH_ROW:
                i_embeddedObjectsContextAfterEach++;
                break;
            default:
                break;
        }

        if (!handler.isReadOnly()) {
            i_gotWriteableEmbeddedObjects = true;
	    // If the sub-domain is cacheable and the master composite domain is also cacheable,
	    // then any changes to the detail record will violate the master composite domain.
	    // In this case, register this classe's cache to be cleared for any changes to the detail
	    // record cache.
            AbstractDomain domain = handler.getDomain();
            if (domain != null) {
        	boolean isCached = PersistentObjectCache.isClassCached(this.getClass());
        	boolean isSubDomainCached = PersistentObjectCache.isClassCached(domain.getClass());
		if (isCached && isSubDomainCached) {
			LOG.debug("Detail domain "+domain.getClass().getName()+" is cached and composite "+
				  this.getClass().getName()+" is also cached.  Any changes to "+
				  domain.getClass().getName()+" cache will result in clearing of the "+
				  "composite cache.");
			// Add it in if not already done so previously (see addRelatedCache).
    		 	PersistentObjectCache.addRelatedCache(domain.getClass(),this.getClass());
		}
            }
            if (handler.isDependentDetailRecord()) {
                i_gotDeleteableEmbeddedObjects = true;
            }
        }
    }


    /**
     *  Returns iterator of embedded handlers.
     *
     *@return    iterator of <code>EmbeddedPersistentObjectHandler</code>
     *      instances in the domain..
     *@see       net.sf.jrf.sql.JRFTransaction#addDomain(AbstractDomain)
     */
    public Iterator getEmbeddedPersistentObjectHandlersIterator() {
        return i_embeddedPersistentObjHandlers.iterator();
    }

    /**
     *  Sets object attribute of any kind. Application determines the context.
     *
     *@param  key          key to store.
     *@param  value        value to store.
     *@param  setEmbedded  if <code>true</code>, set this value in all embedded
     *      domains as well as the parent.
     */
    public void setAttribute(Object key, Object value, boolean setEmbedded) {
        if (setEmbedded) {
            Iterator iterator = i_embeddedPersistentObjHandlers.iterator();
            while (iterator.hasNext()) {
                EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
                AbstractDomain domain = handler.getDomain();
                if (domain != null) {
                    domain.setAttribute(key, value, true);
                }
            }
        }
        if (LOG.isDebugEnabled()) {
            LOG.debug(this + ": setAttribute(\"" + key + "\"," + value + "," + setEmbedded + ")");
        }
        i_attributes.put(key, value);
    }


    /**
     *  Returns attribute for given key.
     *
     *@param  key  key value for attribute.
     *@return      value associated with key or <code>null</code> if not found.
     *@see         #setAttribute(Object,Object,boolean)
     */
    public Object getAttribute(Object key) {
        return i_attributes.get(key);
    }

    /** Returns attribute key iterator.
     * @return attribute key iterator.
     */
    public Iterator getAttributeKeyIterator() {
	return i_attributes.keySet().iterator();
    } 

    /**
     *  Removes attribute value, if it exists.
     *
     *@param  key  key value for attribute.
     *@return      value associated with key or <code>null</code> if not found.
     *@see         #setAttribute(Object,Object,boolean)
     */
    public Object removeAttribute(Object key) {
        return i_attributes.remove(key);
    }


    /**
     *  Sets the read only status of this domain. Call this method from <code>setup()</code>
     *  if the <code>PersistentObject</code> instance managed by the domain will
     *  never require database updates or creation (e.g. calls to <code>createTable</code>
     *  , <code>dropTable</code>, <code>update</code>, <code>save()</code> and
     *  <code>delete()</code>). Setting a domain to read only will disallow the
     *  construction of prepared statement instances for SQL insert and delete,
     *  which will, of course, save resources.
     *
     *@param  readOnly                if <code>true</code>, domain manages a
     *      read-only object.
     *@throws  IllegalStateException  if called outside of <code>setup()</code>
     *@see                            #setup()
     */
    protected void setReadOnly(boolean readOnly) {
        checkSetupState("setReadOnly()");
        this.i_readOnly = readOnly;
    }


    /**
     *  Returns the read-only status of this domain.
     *
     *@return    <code>true</code> if domain manages a read-only object.
     *@see       #setReadOnly(boolean)
     */
    public boolean isReadOnly() {
        return this.i_readOnly;
    }


    /**
     *  Returns the table name.
     *
     *@return    underlying table managed by the domain. For composite objects,
     *      returns the root or base table name.
     */
    public String getTableName() {
        return this.i_tableName;
    }


    /**
     *  Sets the table and optionally sets the table alias. <i>This method must
     *  be called from setup().</i> If the name looks like this: 'Customer c',
     *  then 'Customer' will be the tableName and 'c' will be the tableAlias.
     *  <em>Aliases are no longer required since the only reason for using them
     *  is to distinguish columns of the same name between joined tables in a
     *  SQL select statement. The framework no longer uses <code>java.sql.ResultSet.getX(String)</code>
     *  , but always uses <code>java.sql.ResultSet.getX(int)</code>. Therefore,
     *  table aliases are not required.</em> .
     *
     *@param  s                       table name or alias.
     *@throws  IllegalStateException  if called outside of <code>setup()</code>
     *@see                            #setup()
     */
    public void setTableName(String s) {
        checkSetupState("setTableName()");
        String result[] = parseEntityArgument(s, "main table name");
        i_tableName = result[0];
        i_tableAlias = result[1];
        if (i_sequenceName == null) {
            i_sequenceName = "seq_" + i_tableName;
        }
    }

     /** Sets the property name of the object.
     * If no value is set, the name will be the equivalent of <code>this.getClass().getName()</code>.
     * @see #getPropertyName()
     */
     public void setPropertyName(String name) {
         checkSetupState("setPropertyName()");
         this.i_propertyName = name;
     }

     /** Returns the property name.
     * @see #setPropertyName(String)
     * @return the property name.
     */
     public String getPropertyName() {
         if (this.i_propertyName == null) {
             i_propertyName = this.getClass().getName();
         }
         return i_propertyName;
     }

    /**
     *  Parses a entity name and alias
     *
     *@param  argument  argument containing at least a entity name and
     *      potentially a following alias.
     *@param  context   context to use for any exception message.
     *@return           a two-member <code>String</code> array with offset zero
     *      containing the entity name and offset one containing the entity
     *      alias, if one exists, or the entity name if an alias does not exist.
     */
    public static String[] parseEntityArgument(String argument, String context) {
        String result[] = new String[2];
        StringTokenizer st = new StringTokenizer(argument, " ");
        if (st.hasMoreTokens()) {
            result[0] = st.nextToken();
        } else {
            throw new ConfigurationException(context + ": Invalid argument: " + argument);
        }
        if (st.hasMoreTokens()) {
            result[1] = st.nextToken();
        } else {
            result[1] = result[0];
        }
        return result;
    }


    /**
     *  Sets the sequence name if applicable. <i>This method must be called from
     *  setup().</i> This method only applies to databases with external
     *  sequence types.
     *
     *@param  sequenceName            sequence name
     *@throws  IllegalStateException  if called outside of <code>setup()</code>
     *@see                            #setup()
     *@see                            net.sf.jrf.DatabasePolicy#SEQUENCE_SUPPORT_EXTERNAL
     */
    public void setSequenceName(String sequenceName) {
        checkSetupState("setSequenceName()");
        i_sequenceName = sequenceName;

    }


    /**
     *  Gets the sequence name.
     *
     *@return    sequence name
     */
    public String getSequenceName() {
        return i_sequenceName;
    }


    /**
     *  Returns the subtype table name.
     *
     *@return    subtype table name.
     */
    public String getSubtypeTableName() {
        return i_subtypeTableName;
    }


    /**
     *  If the name looks like this: 'Customer c', then 'Customer' will be the
     *  tableName and 'c' will be the tableAlias. <i>This method must be called
     *  from setup().</i>
     *
     *@param  s                       subtype tagle name
     *@throws  IllegalStateException  if called outside of <code>setup()</code>
     *@see                            #setup()
     */
    public void setSubtypeTableName(String s) {
        checkSetupState("setSubtypeTableName()");
        String result[] = parseEntityArgument(s, "Subtype table name");
        i_subtypeTableName = result[0];
        i_subtypeTableAlias = result[1];
    }

    // setSubtypeTableName(aString)


    /**
     *  Returns the join table of the subtype.
     *
     *@return    join table entity of the subtype table.
     */
    public JoinTable getSubtypeTable() {
        return i_subtypeTable;
    }


    /**
     *  Sets the table alias. <em>Alias is no longer required since the only
     *  reason for using them is to distinguish columns of the same name between
     *  joined tables in an SQL select statement. The framework no longer uses
     *  <code>java.sql.ResultSet.getX(String)</code>, but always uses <code>java.sql.ResultSet.getX(int)</code>
     *  . Therefore, table aliases are not required.</em> . <i>This method must
     *  be called from setup().</i>
     *
     *@param  alias  table alias to use.
     *@deprecated    using aliases are no longer necessary.
     */
    public void setTableAlias(String alias) {
        i_tableAlias = alias;
    }


    /**
     *  Gets the table alias <em>Alias is no longer required since the only
     *  reason for using them is to distinguish columns of the same name between
     *  joined tables in an SQL select statement. The framework no longer uses
     *  <code>java.sql.ResultSet.getX(String)</code>, but always uses <code>java.sql.ResultSet.getX(int)</code>
     *  . Therefore, table aliases are not required.</em> .
     *
     *@return    table alias.
     */
    public String getTableAlias() {
        return i_tableAlias;
    }


    /**
     *  Description of the Method
     *
     *@param  getter  Description of the Parameter
     *@param  setter  Description of the Parameter
     *@return         Description of the Return Value
     */
    private GetterSetter findGetterSetterImpl(String getter, String setter) {
        Object getterSetterImplArgs[] = new Object[1];
        getterSetterImplArgs[0] = (setter != null ? setter : getter);
        try {
            return (GetterSetter) getterSetterImplFactory.invoke(null, getterSetterImplArgs);
        } catch (Exception ex) {
            LOG.warn("AbstractDomain.addColumnSPec(): error loading getter setter", ex);
            return null;
        }
    }



    /**
     *  Description of the Method
     *
     *@param  aColumnSpec  Description of the Parameter
     */
    private void implementNewColumnValueSetMethodology(ColumnSpec aColumnSpec) {
        GetterSetter getterSetter = null;
        if (getterSetterImplFactory != null) {
            getterSetter = (GetterSetter) findGetterSetterImpl(
                    aColumnSpec.getGetter(), aColumnSpec.getSetter());
        }
        if (getterSetter != null) {
            aColumnSpec.setGetterSetterImpl(getterSetter);
        } else {
            // Use optimized reflection version.
            aColumnSpec.setGetterSetterImpl(new GetterSetterReflection(poClass, aColumnSpec.getGetter(),
                    aColumnSpec.getSetter(), true));
        }
    }


    private final static String ADDCOLUMNSPEC = "addColumnSpec()";


    /**
     *  Adds a column specification. <i>This method must be called from setup()
     *  </i>.
     *
     *@param  aColumnSpec             column specification.
     *@throws  IllegalStateException  if called outside of <code>setup()</code>
     *@see                            #setup()
     */
    public void addColumnSpec(ColumnSpec aColumnSpec) {
        checkSetupState(ADDCOLUMNSPEC);
        if (i_useAutoSetupNewColumnMethodology) {
            if (aColumnSpec instanceof CompoundPrimaryKeyColumnSpec) {
                CompoundPrimaryKeyColumnSpec cp = (CompoundPrimaryKeyColumnSpec) aColumnSpec;
                Iterator iter = cp.getColumnSpecs().iterator();
                while (iter.hasNext()) {
                    implementNewColumnValueSetMethodology((ColumnSpec) iter.next());
                }
            } else {
                implementNewColumnValueSetMethodology(aColumnSpec);
            }
        }
        i_columnSpecs.add(aColumnSpec);
    }


    /**
     *  Returns a copy of the column specifications.
     *
     *@return    a copy of the column specifications.
     */
    public List getColumnSpecs() {
        // This list is cloned to protect someone from changing it inadvertently
        return (List) i_columnSpecs.clone();
    }


    private final static String ADDSUBTYPECOLUMNSPEC = "addSubtypeColumnSpec()";


    /**
     *  Cannot add CompoundPrimaryKeyColumnSpec using this
     *
     *@param  aColumnSpec  The feature to be added to the SubtypeColumnSpec
     *      attribute
     */

    /**
     *  Adds subtype column specification. <i>This method must be called from
     *  setup()</i> .
     *
     *@param  aColumnSpec             sub type column specification to add.
     *@throws  IllegalStateException  if called outside of <code>setup()</code>
     *@see                            #setup()
     */
    public void addSubtypeColumnSpec(AbstractColumnSpec aColumnSpec) {
        checkSetupState(ADDSUBTYPECOLUMNSPEC);
        // JE Change 2
        if (i_useAutoSetupNewColumnMethodology) {
            implementNewColumnValueSetMethodology(aColumnSpec);
        }
        i_subtypeColumnSpecs.add(aColumnSpec);
    }


    /**
     *  Gets a copy of the subtype column specifications.
     *
     *@return    a copy of the subtype column specifications.
     */
    public List getSubtypeColumnSpecs() {
        // This list is cloned to protect someone from changing it inadvertently
        return (List) i_subtypeColumnSpecs.clone();
    }


    /**
     *  Gets the subTypeColSpecsForSql attribute of the AbstractDomain object
     *
     *@return    The subTypeColSpecsForSql value
     */
    private ArrayList getSubTypeColSpecsForSql() {
        ArrayList colSpecs = new ArrayList();
        colSpecs.add(i_subtypePrimaryKeyColumnSpec);
        colSpecs.addAll(i_subtypeColumnSpecs);
        return colSpecs;
    }


    /**
     *  Returns a copy of all existing column specifications, both base and
     *  subtype, should it exist.
     *
     *@return    the union of the regular and the subtype columnspec lists
     */
    public List getAllColumnSpecs() {
        List list = new ArrayList();
        // JE Change 3
        list.add(i_subtypePrimaryKeyColumnSpec);
        Iterator columnSpecs = i_columnSpecs.iterator();
        // reset iterator
        while (columnSpecs.hasNext()) {
            ColumnSpec aColumnSpec = (ColumnSpec) columnSpecs.next();
            if (aColumnSpec.equals(i_primaryKeyColumnSpec)) {
                continue;
            }
            list.add(aColumnSpec);
        }
        list.addAll(i_subtypeColumnSpecs);
        return list;
    }


    private final static String ADDJOINTABLE = "addJoinTable()";


    /**
     *  Adds a new join table to the specification. <i>This method must be
     *  called from setup()</i> .
     *
     *@param  aJoinTable              join table to add.
     *@throws  IllegalStateException  if called outside of <code>setup()</code>
     */
    public void addJoinTable(JoinTable aJoinTable) {
        checkSetupState(ADDJOINTABLE);
        // JE Change 2
        // Go through all join tables and nested join table and set up getter/setter impls.
        if (i_useAutoSetupNewColumnMethodology) {
            addJoinGetterSetters(aJoinTable);
        }
        i_joinTables.add(aJoinTable);
    }


    /**
     *  Returns <code>true</code> if domain has join tables.
     *
     *@return    <code>true</code> if domain has join tables.
     */
    public boolean isJoinTableDomain() {
        return i_joinTables.size() > 0 ? true : false;
    }


    /**
     *  Adds a feature to the JoinGetterSetters attribute of the AbstractDomain
     *  object
     *
     *@param  aJoinTable  The feature to be added to the JoinGetterSetters
     *      attribute
     */
    private void addJoinGetterSetters(JoinTable aJoinTable) {
        List nestedJoins = aJoinTable.getJoinTables();
        for (int i = 0; i < nestedJoins.size(); i++) {
            addJoinGetterSetters((JoinTable) nestedJoins.get(i));
        }
        List joinCols = aJoinTable.getJoinColumns();
        for (int i = 0; i < joinCols.size(); i++) {
            JoinColumn j = (JoinColumn) joinCols.get(i);
            GetterSetter getterSetter = null;
            if (getterSetterImplFactory != null) {
                getterSetter = (GetterSetter) findGetterSetterImpl(null, j.getSetter());
            }
            if (getterSetter != null) {
                j.setGetterSetterImpl(getterSetter);
            } else {
                // Use optimized reflection version.
                j.setGetterSetterImpl(
                        new GetterSetterReflection(poClass, null, j.getSetter(), false));
            }
        }
    }


    /**
     *  Returns a copy of the join tables for this domain.
     *
     *@return    a copy of the join tables for this domain.
     */
    public List getJoinTables() {
        return (List) i_joinTables.clone();
    }


    /**
     *  Returns the primary key column specification.
     *
     *@return    primary key column specification.
     */
    public ColumnSpec getPrimaryKeyColumnSpec() {
        return i_primaryKeyColumnSpec;
    }


    /**
     *  Adds a transaction domain to the class so that if <code>preSave()</code>
     *  or <code>postSave()</code> are implemented using these domains,
     *  transaction processing will be properly handled.
     *
     *@param  listener  The feature to be added to the UpdateListener attribute
     */

    /**
     *  Adds an update listener for local instance.
     *
     *@param  listener  <code>UpdateListener</code> instance to add.
     *@see              net.sf.jrf.domain.UpdateListener
     *@see              #update(PersistentObject)
     *@see              #removeUpdateListener(UpdateListener)
     */
    public void addUpdateListener(UpdateListener listener) {
        if (!i_updateListeners.contains(listener)) {
            i_updateListeners.addElement(listener);
        }
    }


    /**
     *  Removes an update listener for local instance.
     *
     *@param  listener  <code>UpdateListener</code> instance to add.
     *@see              net.sf.jrf.domain.UpdateListener
     *@see              #update(PersistentObject)
     *@see              #addUpdateListener(UpdateListener)
     */
    public void removeUpdateListener(UpdateListener listener) {
        i_updateListeners.remove(listener);
    }

    /**
     *  Adds a global update listener.
     *
     *@param  className class name of domain.
     *@param  listener  <code>UpdateListener</code> instance to add.
     *@see              net.sf.jrf.domain.UpdateListener
     *@see              #update(PersistentObject)
     *@see              #removeUpdateListener(UpdateListener)
     */
    public static void addUpdateListener(String className,UpdateListener listener) {
	synchronized (updateListeners) {
		List list = (List) updateListeners.get(className);
		if (list == null) {
			list = new ArrayList();
			updateListeners.put(className,list);
		}
        	if (!list.contains(listener)) {
       	 	    list.add(listener);
        	}
	}
    }


    /**
     *  Removes a global update listener.
     *
     *@param  className class name of domain.
     *@param  listener  <code>UpdateListener</code> instance to add.
     *@see              net.sf.jrf.domain.UpdateListener
     *@see              #update(PersistentObject)
     *@see              #addUpdateListener(UpdateListener)
     */
    public static void removeUpdateListener(String className, UpdateListener listener) {
	synchronized (updateListeners) {
		List list = (List) updateListeners.get(className);
		if (list != null) {
        		list.remove(listener);
		}
	}
    }

    /**
     *  Returns <code>true</code> if managed <code>PersistentObject</code> in
     *  this domain contains a compound primary key.
     *
     *@return    <code>true</code> if managed <code>PersistentObject</code> in
     *      this domain contains a compound primary key.
     */
    public boolean hasCompoundPrimaryKey() {
        return this.i_gotCompoundPrimaryKey;
    }


    //////////////////////////////////////////////////////////////////////////
    // END  --  Domain set up methods and associated getters.
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  ResultPageIterator-related getters and setters.
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Return the index of the first row to be converted to an object and
     *  returned. The index numbers start at 1 (not 0).
     *
     *@return    a value of type 'int'
     */
    public int getStartingIndex() {
        return i_startingIndex;
    }


    /**
     *  Set the index of the first row to be converted to an object and
     *  returned. The index numbers start at 1 (not 0). Don't forget to reset
     *  these before reusing this domain instance.
     *
     *@param  v  The new startingIndex value
     *@see       #resetStartingAndEndingIndexes()
     */
    public void setStartingIndex(int v) {
        i_startingIndex = v;
    }


    /**
     *  Return the index of the last row to be converted to an object and
     *  returned. The index numbers start at 1 (not 0).
     *
     *@return    a value of type 'int'
     */
    public int getEndingIndex() {
        return i_endingIndex;
    }


    /**
     *  Set the index of the last row to be converted to an object and returned.
     *  The index numbers start at 1 (not 0). Don't forget to reset these before
     *  reusing this domain instance.
     *
     *@param  v  The new endingIndex value
     *@see       #resetStartingAndEndingIndexes()
     */
    public void setEndingIndex(int v) {
        i_endingIndex = v;
    }


    /**
     *  Reset the starting and ending indexes so the whole resultset will be
     *  returned the next time a query is called.
     */
    public void resetStartingAndEndingIndexes() {
        i_startingIndex = -1;
        i_endingIndex = -1;
    }


    //////////////////////////////////////////////////////////////////////////
    // END --  ResultPageIterator-related getters and setters.
    //////////////////////////////////////////////////////////////////////////



    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  Protected methods that have no implementation in this class.
    //////////////////////////////////////////////////////////////////////////


    /**
     *  Called from <code>find()</code> methods. While this method is still
     *  supported, it is now deprecated. The model of <code>postFind</code> is
     *  based on a procedural programming concept rather than an object-oriented
     *  one. Furthermore, the most logical use of <code>postFind</code> is to
     *  populate embedded and computed attributes. This functionality is handled
     *  by <code>EmbeddedPersistentObjectHandler</code>. To illustrate how to
     *  convert existing <code>postFind</code> methods to the new approach,
     *  examine this example (assuming you have already converted the JDBCHelper
     *  argument to the JRFResultSet argument): <pre>
     * // Post find version.
     * public VideoDomain extends AbstractDomain {
     * 		private CustomerDomain customerDomain = new CustomerDomain();
     * .
     * .
     * .
     * protected void postFind(PersistentObject aPO, JRFResultSet baseFindResultSet)
     * {
     * 		Video video = (Video) aPO;
     *		List customers = customerDomain.findForVideo(video);
     *		video.setCustomers(customers);
     * 		// Attach the appropriate media and genre objects
     *		Integer mediaId = null;
     *		Integer genreId = null;
     * try
     * {
     *		Media media = new Media(
     *				baseFindResultSet.getInteger("MEDIA_ID"),
     *				baseFindResultSet.getString("MEDIA_NAME"));
     *		video.setMedia(media);
     *		genreId = baseFindResultSet.getInteger("GENRE_ID");
     * }
     * catch (SQLException e)
     * {
     *  	throw new DatabaseException(e);
     * }
     *}
     * // New version.
     * </pre>
     *
     *@param  aPO                <code>PersistentObject</code> will values from
     *      the base "table" fetch already populated by <code>save</code>.
     *@param  baseFindResultSet  <code>JRFResultSet</code> instance from the
     *      base "table" find to use by sub-classes to find the requisite key
     *      values for additional database queries.
     */
    protected void postFind(PersistentObject aPO, JRFResultSet baseFindResultSet) { }


    /**
     *  This is the default, no-operation implementation which is executed for
     *  all found objects. Subclasses should override when they want to do
     *  something to a PersistentObject after it is found in the database. <p>
     *
     *  The JDBCHelper is an argument so that we have the flexibility to do our
     *  own object manipulation using the current row in the result set. <p>
     *
     *  <b>Note:</b> If you wish to use the JDBCHelper to do another SQL call,
     *  you must first clone it to get a new connection.
     *
     *@param  aPO          a value of type 'PersistentObject'
     *@param  aJDBCHelper  Description of the Parameter
     */
    protected void postFind(PersistentObject aPO, JDBCHelper aJDBCHelper) {
        // No-operation.  Subclasses can override.
    }


    /**
     *  This is the default, no-operation implementation. Subclasses should
     *  override when they want to do something to a PersistentObject before it
     *  is validated. If the subclass wants to do an update in the same
     *  transaction context, the given JDBCHelper should be used.
     *
     *@param  aPO                            a value of type 'PersistentObject'
     *@param  aJDBCHelper                    Description of the Parameter
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  DuplicateRowException      Description of the Exception
     */
    protected void preValidate(PersistentObject aPO,
            JDBCHelper aJDBCHelper)
             throws
            ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException {
        // No-operation.  Subclasses can override.
    }


    /**
     *  Description of the Method
     *
     *@param  aPO                            Description of the Parameter
     *@param  stmtExecuter                   Description of the Parameter
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  DuplicateRowException      Description of the Exception
     */
    protected void preValidate(PersistentObject aPO, StatementExecuter stmtExecuter)
             throws
            ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException {
        // No-operation.  Subclasses can override.
    }


    /**
     *  This is the default, no-operation implementation. Subclasses should
     *  override when they want to do something to a PersistentObject before it
     *  is saved. If the subclass wants to do an update in the same transaction
     *  context, the given JDBCHelper should be used.
     *
     *@param  aPO                            a value of type 'PersistentObject'
     *@param  aJDBCHelper                    Description of the Parameter
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  DuplicateRowException      Description of the Exception
     */
    protected void preSave(PersistentObject aPO, JDBCHelper aJDBCHelper) throws ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException {
        // No-operation.  Subclasses can override.
    }


    /**
     *  Description of the Method
     *
     *@param  aPO                            Description of the Parameter
     *@param  stmtExecuter                   Description of the Parameter
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  DuplicateRowException      Description of the Exception
     */
    protected void preSave(PersistentObject aPO, StatementExecuter stmtExecuter) throws ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException {
        // No-operation.  Subclasses can override.
    }


    /**
     *  This is the default, no-operation implementation. Subclasses should
     *  override when they want to do something to a PersistentObject after it
     *  is updated or inserted -- like save objects that depend on it's primary
     *  key. If the subclass wants to do an update in the same transaction
     *  context, the given JDBCHelper should be used.
     *
     *@param  aPO                            a value of type 'PersistentObject'
     *@param  aJDBCHelper                    Description of the Parameter
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  DuplicateRowException      Description of the Exception
     */
    protected void postSave(PersistentObject aPO,
            JDBCHelper aJDBCHelper)
             throws
            ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException {
        // No-operation.  Subclasses can override.
    }


    /**
     *  Description of the Method
     *
     *@param  aPO                            Description of the Parameter
     *@param  stmtExecuter                   Description of the Parameter
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  DuplicateRowException      Description of the Exception
     */
    protected void postSave(PersistentObject aPO,
            StatementExecuter stmtExecuter)
             throws
            ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException {
        // No-operation.  Subclasses can override.
    }


    /**
     *  This is the default, no-operation implementation. Subclasses should
     *  override when they want to do something to a PersistentObject before it
     *  is deleted -- like delete objects that depend on it.
     *
     *@param  aPO          a value of type 'PersistentObject'
     *@param  aJDBCHelper  Description of the Parameter
     */
    protected void preDelete(PersistentObject aPO,
            JDBCHelper aJDBCHelper) {
        // No-operation.  Subclasses can override.
    }


    /**
     *  Description of the Method
     *
     *@param  aPO           Description of the Parameter
     *@param  stmtExecuter  Description of the Parameter
     */
    protected void preDelete(PersistentObject aPO,
            StatementExecuter stmtExecuter) {
        // No-operation.  Subclasses can override.
    }


    /**
     *  This is the default, no-operation implementation. Subclasses should
     *  override when they want to do something to a PersistentObject after it
     *  is deleted.
     *
     *@param  aPO          a value of type 'PersistentObject'
     *@param  aJDBCHelper  Description of the Parameter
     */
    protected void postDelete(PersistentObject aPO,
            JDBCHelper aJDBCHelper) {
        // No-operation.  Subclasses can override.
    }


    /**
     *  Description of the Method
     *
     *@param  aPO           Description of the Parameter
     *@param  stmtExecuter  Description of the Parameter
     */
    protected void postDelete(PersistentObject aPO,
            StatementExecuter stmtExecuter) {
        // No-operation.  Subclasses can override.
    }


    //////////////////////////////////////////////////////////////////////////

    // END  --  Protected methods that have no implementation in this class.
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    // BEGIN --  Find methods and supporting utilities.
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Convert the result set data encapsulated in <code>JRFResultSet</code>
     *  instance the the domain's persistent object. Handle all embedded objects
     *  as well.
     *
     *@param  aJRFResultSet  <code>JRFResultSet</code> instance.
     *@return                <code>PersistentObject</code> instance.
     *@exception  Exception  if any conversion error occurs.
     */
    protected PersistentObject convertToPersistentObject(JRFResultSet aJRFResultSet)
             throws Exception {
        PersistentObject aPO = this.newPersistentObject();
        Iterator iterator = null;
        Iterator it = null;
        ColumnSpec aColumnSpec = null;
        JoinTable aJoinTable = null;
        JoinColumn aJoinColumn = null;

        iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {

            aColumnSpec = (ColumnSpec) iterator.next();
            aColumnSpec.copyColumnValueToPersistentObject(aJRFResultSet, aPO);
        }
        // while

        // Assign joined columns to the object too.
        iterator = i_joinTables.iterator();
        while (iterator.hasNext()) {
            // join columns
            aJoinTable = (JoinTable) iterator.next();
            aJoinTable.copyColumnValuesToPersistentObject(aJRFResultSet, aPO);
        }

        if (i_subtypeTable != null) {
            i_subtypeTable.copyColumnValuesToPersistentObject(aJRFResultSet, aPO);
        }
        if (LOG.isDebugEnabled()) {
            LOG.debug("converttoPersistentObject result: " + aPO);
        }
        return aPO;
    }

    // convertToPersistentObject(aJRFResultSet,boolean)


    /**
     *  Converts embedded objects base on each row context. *
     *
     *@param  aPO                     Description of the Parameter
     *@param  resultSet               Description of the Parameter
     *@param  embeddedObjectsToFetch  Description of the Parameter
     */
    private void constructEmbeddedObjectsForRow(PersistentObject aPO, JRFResultSet resultSet, List embeddedObjectsToFetch) {
        Iterator iterator = embeddedObjectsToFetch.iterator();
        while (iterator.hasNext()) {
            EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
            if (handler.getConstructObjectContext() == EmbeddedPersistentObjectHandler.CONSTRUCT_CONTEXT_AFTER_EACH_ROW) {
                handler.constructObjects(aPO, resultSet);
            }
        }
    }


    /**
     *  Converts embedded objects base after all rows fetched context. *
     *
     *@param  aPO                     Description of the Parameter
     *@param  embeddedObjectsToFetch  Description of the Parameter
     */
    private void constructEmbeddedObjectsAfterFetch(PersistentObject aPO, List embeddedObjectsToFetch) {
        Iterator iterator = embeddedObjectsToFetch.iterator();
        while (iterator.hasNext()) {
            EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
            if (handler.getConstructObjectContext() == EmbeddedPersistentObjectHandler.CONSTRUCT_CONTEXT_AFTER_ALL_ROWS) {
                handler.constructObjects(aPO);
            }
        }
    }


    ///////////////////////////////////////////////////////////////////
    // Part 1 of 3: Primary key Finds /////////////////////////////////
    ///////////////////////////////////////////////////////////////////

    /**
     *  Finds the primary key record for this domain using the handler provided.
     *  This method is primarily designed to allow applications to handle
     *  complex objects such as <code>Clob</code> and <code>Blob</code>.
     *
     *@param  pkOrPersistentObject  primary key object or persistent key to use
     *      for the search.
     *@param  handler               <code>ApplicationRowHandler</code> to use to
     *      process the result.
     *@return                       true <code> if data was found.  (Since user has control of processing
     * each row, the number of rows fetched can be obtained outside the framework.)
     *
     *
     */
    public boolean find(Object pkOrPersistentObject, ApplicationRowHandler handler) {
        this.assureDatabaseConnection();
        int rowCount = this.executePreparedSQLQuery(
                i_jrfConnection.getPreparedStatementList().getAndPrepare(psKey[PS_FIND],
                pkOrPersistentObject),
                handler);
        return rowCount > 0 ? true : false;
    }


    /**
     *  Finds the primary key record for this domain using a sub-class of <code>
     * ApplicationRowHandlerPrimaryKey</code>. This method is useful for
     *  contexts where when a join table included in this domain may cause more
     *  than a single record to be fetched for the same primary key. The
     *  implementation of the handler provided resolves the information provided
     *  in the few multiple rows into a single <code>PersistentObject</code>
     *  instance.
     *
     *@param  pkOrPersistentObject  primary key object or persistent key to use
     *      for the search.
     *@param  handler               <code>ApplicationRowHandlerPrimaryKey</code>
     *      to use to process the result.
     *@return                       true <code> if data was found.  (Since user has control of processing
     * each row, the number of rows fetched can be obtained outside the framework.)
     *
     *
     */
    public PersistentObject find(Object pkOrPersistentObject,
            ApplicationRowHandlerPrimaryKey handler) {
        this.assureDatabaseConnection();
        this.executePreparedSQLQuery(
                i_jrfConnection.getPreparedStatementList().getAndPrepare(psKey[PS_FIND],
                pkOrPersistentObject),
                handler);
        return (PersistentObject) handler.getResult();
    }


    /*
     *  ========  These methods will usually not be overridden  ========
     */
    /*
     *  ========  unless additional behavior is needed          ========
     */
    /**
     *  Finds the object by primary key.
     *
     *@param  pkOrPersistentObject  <code>PersistentObject</code> instance with
     *      the appropriate primary key fields set (usually a compound primary
     *      key) or or single <code>Object</code> which is usually a simple
     *      object
     *@return                       <code>PersistentObject</code> instance in
     *      the database that matched the key or <code>null</code>. if not
     *      found.
     */
    public PersistentObject find(Object pkOrPersistentObject) {
        return this.finalFind(pkOrPersistentObject);
    }


    /**
     *  Gets the findArgPersistentObject attribute of the AbstractDomain object
     *
     *@param  arg  Description of the Parameter
     *@return      The findArgPersistentObject value
     */
    private boolean isFindArgPersistentObject(Object arg) {
        if (arg instanceof PersistentObject) {
            return true;
        }
        if (hasCompoundPrimaryKey()) {
            throw new IllegalArgumentException(this.getTableName() +
                    " contains a compound primary key. Therefore, you cannot call find(" + arg + "). The argument " +
                    "must be a PersistentObject with the embedded values of the compound key set.");
        }
        return false;
    }


    /**
     *  Finds the object by primary key.
     *
     *@param  pkOrPersistentObject  <code>PersistentObject</code> instance with
     *      the appropriate primary key fields set (usually a compound primary
     *      key) or or single <code>Object</code> which is usually a simple
     *      object
     *@return                       <code>PersistentObject</code> instance in
     *      the database that matched the key or <code>null</code>. if not
     *      found.
     */
    protected final PersistentObject finalFind(Object pkOrPersistentObject) {
        PersistentObjectCache.SearchResult searchResult =
                new PersistentObjectCache.SearchResult(pkOrPersistentObject, isFindArgPersistentObject(pkOrPersistentObject));
        PersistentObjectCache.find(this, searchResult);
        PersistentObject result = searchResult.getResult();
        if (result == null) {
            if (LOG.isDebugEnabled()) {
                LOG.debug(this + ".finalFind(" + pkOrPersistentObject + ") not found in cache.");
            }
            result = keyFind(pkOrPersistentObject, i_embeddedPersistentObjHandlers, i_usePostFind);
            if (searchResult.isCacheable() && result != null) {
                PersistentObjectCache.updateCache(this.getClass(), searchResult.getEncodedKey(), result);
            }
        }
        return result;
    }

    // finalFind(pkOrPersistentObject)


    ///////////////////////////////////////////////////////////////////
    // Part 2 of 3: Find all          /////////////////////////////////
    ///////////////////////////////////////////////////////////////////

    /**
     *  Returns a list of all data for the given domain in the database.
     *
     *@return    a list of all data in the database.
     *@see       #findAll(ApplicationRowHandler)
     */
    public List findAll() {
        List result = PersistentObjectCache.findAll(this);
        // not cache all returns null.
        if (result == null) {
            this.listRowHandler.clear();
            findAll(listRowHandler);
            this.listRowHandler.trim();
            result = (List) this.listRowHandler.getResult();
        }
        return result;
    }


    /**
     *  Finds all records but uses the application handler parameter to process
     *  each record thus allowing user to decide on the storage mechanism.
     *
     *@param  handler  <code>ApplicationRowHandler</code> instance to use for
     *      each record found.
     *@see             #findAll()
     */
    public void findAll(ApplicationRowHandler handler) {
        assureDatabaseConnection();
        i_jrfConnection.setMaxRows(0);
        executePreparedSQLQuery(i_jrfConnection.getPreparedStatementList().get(psKey[PS_FINDALL]), handler);
    }


    ///////////////////////////////////////////////////////////////////
    // Part 3 of 3: Adhoc query finds./////////////////////////////////
    ///////////////////////////////////////////////////////////////////

    /**
     *  Adds a prepared SQL select by adhoc where statement and optional order
     *  by clause to the list of prepared statements for this domain. Statement
     *  may be executed through a call to <code>findByPreparedStatement</code>.
     *
     *@param  key          key to use for fetching statement for processing
     *      through a call to <code>findByPreparedStatement()</code>. This
     *      method may be called from <code>setup</code> or outside of <code>setup</code>
     *      .
     *@param  tableName    this must be either the base table name or subtype
     *      tablename.
     *@param  whereClause  syntactically correct prepared where clause.
     *@param  orderBy      optional order by clause. May be <code>null</code>.
     *@param  columnSpecs  The feature to be added to the PreparedFindStatement
     *      attribute
     *@see                 #setup()
     */
    public void addPreparedFindStatement(String key, String tableName, String whereClause, String orderBy, List columnSpecs) {
        OtherPreparedStatement us = new OtherPreparedStatement(key, tableName, whereClause, orderBy, columnSpecs);
        i_otherPreparedStatements.add(us);
        if (!setupComplete || i_jrfConnection == null) {
            return;
        }
        this.getJRFConnection().getPreparedStatementList().addSelectWhereOrderbyStatement(
                us.key,
                i_selectSQLBuilder,
                us.whereClause,
                us.orderBy,
                us.tableName,
                us.columnSpecs);
    }


    /**
     *  Adds a prepared SQL completely adhoc statement. domain. Statement may be
     *  executed through a call to <code>executeAdhocPreparedStatement</code>.
     *
     *@param  key          key to use for fetching statement for processing
     *      through a call to <code>executeAdHocPreparedStatement()</code>. This
     *      method may be called from <code>setup</code> or outside of <code>setup</code>
     *      .
     *@param  sql          complete SQL statement.
     *@param  columnSpecs  The feature to be added to the AdhocPreparedStatement
     *      attribute
     *@see                 #executeAdhocPreparedStatement(String,List)
     */
    public void addAdhocPreparedStatement(String key, String sql, List columnSpecs) {
        OtherPreparedStatement us = new OtherPreparedStatement(key, columnSpecs, sql);
        i_otherPreparedStatements.add(us);
        if (!setupComplete || i_jrfConnection == null) {
            return;
        }
        this.getJRFConnection().getPreparedStatementList().addAdHocStatement(us.key, us.sql, us.columnSpecs);
    }


    /**
     *  Finds data by the prepared where clause added in <code>addPreparedFindStatement()</code>
     *  using specific parameters and <code>ApplicationRowHandler</code>
     *  instance.
     *
     *@param  preparedStatementKey       key added in <code>addPreparedFindStatement()</code>
     *      .
     *@param  handler                    <code>ApplicationRowHandler</code> to
     *      use.
     *@param  params                     list of object parameters to use to set
     *      up <code>PreparedStatment</code>.
     *@return                            number or rows fetched.
     *@throws  IllegalArgumentException  if number of parameters in <code>params</code>
     *      does not match number of column specifications set in <code>addPreparedFindStatement()</code>
     *      .
     *@see
     *      #addPreparedFindStatement(String,String,String,String,List)
     */
    public int findByPreparedStatement(String preparedStatementKey, ApplicationRowHandler handler, List params)
             throws IllegalArgumentException {
        this.assureDatabaseConnection();
        i_jrfConnection.setMaxRows(0);
        PreparedStatementListHandler list = i_jrfConnection.getPreparedStatementList();
        return this.executePreparedSQLQuery(list.getAndPrepare(preparedStatementKey, params), handler);
    }


    /**
     *  Executes the SQL adhoc prepared where clause added in <code>addAdhocPreparedStatement()</code>
     *  using specific parameters.
     *
     *@param  preparedStatementKey       key added in <code>addPreparedFindStatement()</code>
     *      .
     *@param  params                     list of object parameters to use to set
     *      up <code>PreparedStatment</code>.
     *@return                            number or rows fetched.
     *@throws  IllegalArgumentException  if number of parameters in <code>params</code>
     *      does not match number of column specifications set in <code>addAdHocPreparedStatement()</code>
     *      .
     *@see
     *      #addAdhocPreparedStatement(String,String,List)
     */
    public int executeAdhocPreparedStatement(String preparedStatementKey, List params)
             throws IllegalArgumentException {
        this.assureDatabaseConnection();
        PreparedStatementListHandler list = i_jrfConnection.getPreparedStatementList();
        return this.executePreparedSQLUpdate(list.getAndPrepare(preparedStatementKey, params));
    }


    /**
     *  Find in database given supplied where clause. 'WHERE' should not be
     *  included in the argument string.
     *
     *@param  whereString  where clause; 'WHERE' should not be present.
     *@param  maxRows      maximum rows to fetch.
     *@return              a list of rows that met the criteria specified in the
     *      where clause. An empty list denotes no rows found.
     */
    public final List findWhere(String whereString, int maxRows) {
        return this.findWhereOrderBy(whereString, null, maxRows);
    }


    /**
     *  Find in database given supplied where clause. 'WHERE' should not be
     *  included in the argument string.
     *
     *@param  whereString  where clause; 'WHERE' should not be present.
     *@return              a list of rows that met the criteria specified in the
     *      where clause. An empty list denotes no rows found.
     */
    public final List findWhere(String whereString) {
        return this.findWhereOrderBy(whereString, null, 0);
    }


    /**
     *  Find all data, but order the result by supplied order by clause. 'ORDER
     *  BY' should not be included in the argument string.
     *
     *@param  orderByString  ordery by clause; 'ORDER BY' should not be present.
     *@return                a list of rows of all rows ordered by specified
     *      order by clause.
     */
    public final List findOrderBy(String orderByString) {
        return this.findWhereOrderBy(null, orderByString, 0);
    }


    /**
     *  Find in database given supplied where clause and order by clause.
     *
     *@param  whereString    where clause; 'WHERE' should not be present.
     *@param  orderByString  order by clause; 'ORDER BY' should not be present.
     *@param  maxRows        maximum rows to fetch.
     *@return                a list of rows that met the criteria specified in
     *      the where clause. An empty list denotes no rows found.
     */
    public final List findWhereOrderBy(String whereString, String orderByString, int maxRows) {
        this.assureDatabaseConnection();
        i_selectSQLBuilder.setWhere(whereString);
        i_selectSQLBuilder.setOrderBy(orderByString);
        return this.find(i_selectSQLBuilder, maxRows);
    }


    /**
     *  Find in database given supplied where clause and order by clause using
     *  <code>ApplicationRowHandler</code> instance supplied.
     *
     *@param  whereString    where clause; 'WHERE' should not be present.
     *@param  orderByString  order by clause; 'ORDER BY' should not be present.
     *@param  maxRows        maximum rows to fetch.
     *@param  handler        Description of the Parameter
     */
    public void findWhereOrderBy(String whereString, String orderByString, int maxRows,
            ApplicationRowHandler handler) {
        this.assureDatabaseConnection();
        i_selectSQLBuilder.setWhere(whereString);
        i_selectSQLBuilder.setOrderBy(orderByString);
        i_jrfConnection.setMaxRows(maxRows);
        this.executeSQLQuery(i_selectSQLBuilder.buildSQL(), handler);
    }


    /**
     *  Find in database given supplied where clause and order by clause.
     *  Calling this method is the equivalent of calling: <pre>
     * 	findWhereOrderBy(whereString,orderByString,0)
     * </pre>
     *
     *@param  whereString    where clause; 'WHERE' should not be present.
     *@param  orderByString  order by clause; 'ORDER BY' should not be present.
     *@return                a list of rows that met the criteria specified in
     *      the where clause. An empty list denotes no rows found.
     *@see                   #findWhereOrderBy(String,String,int)
     */
    public final List findWhereOrderBy(String whereString, String orderByString) {
        return findWhereOrderBy(whereString, orderByString, 0);
    }



    /**
     *  Finds data based on constructed SQL select statement in builder. Calling
     *  this method is the equivalent of calling: <pre>
     * 	find(builder,0)
     * </pre>
     *
     *@param  builder  a properly constructed <code>SQLBuilder</code> instance.
     *@return          a list of data based on supplied information in SQL
     *      statement.
     */
    public List find(SelectSQLBuilder builder) {
        return this.find(builder, 0);
    }


    /**
     *  Finds data based on constructed SQL select statement in builder.
     *
     *@param  builder  a properly constructed <code>SQLBuilder</code> instance.
     *@param  maxRows  maximum rows to fetch.
     *@return          a list of data based on supplied information in SQL
     *      statement.
     */
    public List find(SelectSQLBuilder builder, int maxRows) {
        return this.findCustom(builder.buildSQL(), maxRows);
    }


    /**
     *  Finds data specified in supplied SQL statement. Calling this method is
     *  the equivalent of calling: <pre>
     * 	findCustom(sql,0)
     * </pre>
     *
     *@param  sql  a valid SQL select statement.
     *@return      a list of data based on supplied information in SQL
     *      statement.
     */
    public List findCustom(String sql) {
        return findCustom(sql, 0);
    }


    /**
     *  Finds data specified in supplied SQL statement.
     *
     *@param  sql      a valid SQL select statement.
     *@param  maxRows  maximum rows to fetch.
     *@return          a list of data based on supplied information in SQL
     *      statement.
     */
    public List findCustom(String sql, int maxRows) {
        // Only use previous version of findCustom if application is using result page iterator.
        this.assureDatabaseConnection();
        if (i_endingIndex != -1) {
            return findCustomResultPageIterator(sql);
        }
        i_jrfConnection.setMaxRows(maxRows);
        // Use the reusable list handler -- trim to size to activate garbage collection.
        this.listRowHandler.clear();
        this.executeSQLQuery(sql, this.listRowHandler);
        this.listRowHandler.trim();
        return (List) this.listRowHandler.getResult();
    }


    /**
     *  This method should *rarely*, if ever, be used by subclasses. The
     *  findWhere methods are to be preferred over this method. Subclasses can
     *  use this method when (for whatever reason) they need to write totally
     *  custom SQL but still want the result set converted to persistent
     *  objects. This method returns a List of persistent objects using the
     *  given SQL string. An inner class is used that tells the
     *  executeSQLQuery() method how to handle the result set rows.
     *
     *@param  sql  a value of type 'String'
     *@return      a value of type 'List'
     */

    private List findCustomResultPageIterator(String sql) {
        final List result = new ArrayList();
        RowHandler handler;
        if (i_endingIndex < i_startingIndex) {
            throw new ConfigurationException("Starting index must not be greater than the ending index");
        }
        handler =
            new RowHandler() {
                PersistentObject aPO = null;
                int startingIndex = i_startingIndex;
                int endingIndex = i_endingIndex;
                int rowNumber = 0;


                public void handleRow(JRFResultSet aJRFResultSet) throws Exception {
                    rowNumber++;
                    if (startingIndex < 0 || endingIndex < 0 || (rowNumber >= startingIndex && rowNumber <= endingIndex)) {
                        aPO = convertToPersistentObject(aJRFResultSet);
                        if (i_embeddedObjectsContextAfterEach > 0) {
                            constructEmbeddedObjectsForRow(aPO, aJRFResultSet, i_embeddedPersistentObjHandlers);
                        }
                        if (i_usePostFind) {
                            postFind(aPO, aJRFResultSet);
                        }
                        aPO.forceCurrentPersistentState();
                        result.add(aPO);
                    }
                }
                // handleRow(aJRFResultSet)
            };
        this.executeSQLQuery(sql, handler);
        return result;
    }

    //


    /// Deprecated JDBCHelper methods.
    /**
     *  Returns a list of all data for the given domain in the database.
     *
     *@param  aJDBCHelper  <code>JDBCHelper</code> instance.
     *@return              a list of all data in the database.
     *@deprecated          <code>JDBCHelper</code> argument will be ignored.
     */
    public List findAll(JDBCHelper aJDBCHelper) {
        return this.findAll();
    }

    // findAll()


    /**
     *  Find in database given supplied where clause. 'WHERE' should not be
     *  included in the argument string.
     *
     *@param  whereString  where clause; 'WHERE' should not be present.
     *@param  helper       Description of the Parameter
     *@return              a list of rows that met the criteria specified in the
     *      where clause. An empty list denotes no rows found.
     *@deprecated          <code>JDBCHelper</code> argument will be ignored.
     */
    public final List findWhere(String whereString, JDBCHelper helper) {
        return findWhere(whereString);
    }


    /**
     *  Finds the object by primary key.
     *
     *@param  pkOrPersistentObject  <code>PersistentObject</code> instance with
     *      the appropriate primary key fields set (usually a compound primary
     *      key) or or single <code>Object</code> which is usually a simple
     *      object
     *@param  aJDBCHelper           <code>JDBCHelper</code> instance.
     *@return                       <code>PersistentObject</code> instance in
     *      the database that matched the key or <code>null</code>. if not
     *      found.
     *@deprecated                   <code>JDBCHelper</code> argument will be
     *      ignored.
     */
    public PersistentObject find(Object pkOrPersistentObject, JDBCHelper aJDBCHelper) {
        return this.finalFind(pkOrPersistentObject);
    }


    /**
     *  Finds data based on constructed SQL select statement in builder.
     *
     *@param  builder      a properly constructed <code>SQLBuilder</code>
     *      instance.
     *@param  aJDBCHelper  <code>JDBCHelper</code> instance.
     *@return              a list of data based on supplied information in SQL
     *      statement.
     *@deprecated          <code>JDBCHelper</code> argument will be ignored.
     */
    public List find(SelectSQLBuilder builder, JDBCHelper aJDBCHelper) {
        return this.findCustom(builder.buildSQL());
    }


    /**
     *  Finds data specified in supplied SQL statement.
     *
     *@param  sql          a valid SQL select statement.
     *@param  aJDBCHelper  <code>JDBCHelper</code> instance.
     *@return              a list of data based on supplied information in SQL
     *      statement.
     *@deprecated          <code>JDBCHelper</code> argument will be ignored.
     */
    public List findCustom(String sql, JDBCHelper aJDBCHelper) {
        return this.findCustom(sql);
    }


    /**
     *  Find in database given supplied where clause and order by clause.
     *
     *@param  whereString    where clause; 'WHERE' should not be present.
     *@param  orderByString  order by clause; 'ORDER BY' should not be present.
     *@param  helper         Description of the Parameter
     *@return                a list of rows that met the criteria specified in
     *      the where clause. An empty list denotes no rows found.
     *@deprecated            <code>JDBCHelper</code> argument will be ignored.
     */
    public final List findWhereOrderBy(String whereString, String orderByString, JDBCHelper helper) {
        return this.findWhereOrderBy(whereString, orderByString);
    }


    /**
     *  Find all data, but order the result by supplied order by clause. 'ORDER
     *  BY' should not be included in the argument string.
     *
     *@param  orderByString  order by clause; 'ORDER BY' should not be present.
     *@param  aJDBCHelper    <code>JDBCHelper</code> instance.
     *@return                a list of rows of all rows ordered by specified
     *      order by clause.
     *@deprecated            <code>JDBCHelper</code> argument will be ignored.
     */
    public final List findOrderBy(String orderByString, JDBCHelper aJDBCHelper) {
        return this.findOrderBy(orderByString);
    }


    //////////////////////////////////////////////////////////////////////////

    // END  --  Find methods and supporting utilities.
    //////////////////////////////////////////////////////////////////////////


    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  SQL builder get methods.
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Returns the Select SQL buider instance associated with this domain.
     *
     *@return    the Select SQL buider instance associated with this domain.
     */
    public SelectSQLBuilder getSelectSQLBuilder() {
        return new SelectSQLBuilder(this,
                this.getJRFConnection().getDataSourceProperties().isAnsiJoinSupported());
    }


    /**
     *  Returns the Insert SQL buider instance associated with this domain.
     *
     *@return    the Insert SQL buider instance associated with this domain.
     */
    public InsertSQLBuilder getInsertSQLBuilder() {
        return new InsertSQLBuilder(this);
    }


    /**
     *  Returns the Update SQL buider instance associated with this domain.
     *
     *@return    the Update SQL buider instance associated with this domain.
     */
    public UpdateSQLBuilder getUpdateSQLBuilder() {
        return new UpdateSQLBuilder(this);
    }


    /**
     *  Returns the Create SQL buider instance associated with this domain.
     *
     *@return    the Create SQL buider instance associated with this domain.
     */
    public CreateTableSQLBuilder getCreateTableSQLBuilder() {
        return new CreateTableSQLBuilder(this);
    }


    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  Database update methods (save and delete).
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Validates the <code>PersistentObject</code> data that is most likely
     *  about to be written to the database. This method no longer rollsback
     *  upon encountering an error as it did in older versions.
     *
     *@param  aPO                            <code>PersistentObject</code>
     *      instance to validate.
     *@param  aJDBCHelper                    <code>JDBCHelper</code> instance.
     *@exception  MissingAttributeException  if a required attribute is missing.
     *@exception  InvalidValueException      if attibrute is not a valid value.
     *@exception  DuplicateRowException      if this row is already in the
     *      database.
     *@deprecated                            <code>JDBCHelper</code> argument
     *      will be ignored.
     */
    public void validate(PersistentObject aPO, JDBCHelper aJDBCHelper) throws MissingAttributeException, DuplicateRowException,
            InvalidValueException {
        validate(aPO);
    }


    /**
     *  Validates the <code>PersistentObject</code> data that is most likely
     *  about to be written to the database. This method no longer rollsback
     *  upon encountering an error.
     *
     *@param  aPO                            <code>PersistentObject</code>
     *      instance to validate.
     *@exception  MissingAttributeException  if a required attribute is missing.
     *@exception  DuplicateRowException      if this row is already in the
     *      database.
     *@exception  InvalidValueException      if attibrute is not a valid value.
     */
    public void validate(PersistentObject aPO) throws MissingAttributeException, DuplicateRowException,
            InvalidValueException {
        // It is not necessary to check database access, unless validateUnique is going to be used.
        if (i_supportValidateUnique || i_gotWriteableEmbeddedObjects) {
            assureDatabaseConnection();
        }
        if (LOG.isDebugEnabled()) {
            // this avoids StringBuffer creation

            LOG.debug(i_tableName + ": AbstractDomain.validate(" + aPO + ")");
        }
        ColumnSpec aColumnSpec = null;
        // This defines an attribute
        if (aPO == null) {
            throw new IllegalArgumentException(
                    "Null argument value for aPO was passed to "
                    + "AbstractDomain#validate(...)");
        }
        try {
            // Validate the supertype columnSpecs
            Iterator columnSpecs = i_columnSpecs.iterator();
            // reset iterator
            while (columnSpecs.hasNext()) {
                aColumnSpec = (ColumnSpec) columnSpecs.next();

                // If this attribute is required and not present, throw
                // MissingAttributeException.
                aColumnSpec.validateRequired(aPO);

                aColumnSpec.validateValue(aPO);

                // If this attribute is unique, verify that no other rows match it.
                // JE Change 5
                if (i_supportValidateUnique) {
                    aColumnSpec.validateUnique(aPO,
                            i_stmtExecuter,
                            i_primaryKeyColumnSpec,
                            i_databasePolicy,
                            i_tableName);
                }
            }
            // while

            // Validate all subtype columnSpecs
            columnSpecs = i_subtypeColumnSpecs.iterator();
            // reset iterator
            while (columnSpecs.hasNext()) {
                aColumnSpec = (ColumnSpec) columnSpecs.next();

                // If this attribute is required and not present, throw
                // MissingAttributeException.
                aColumnSpec.validateRequired(aPO);

                // If this attribute is unique, verify that no other rows match it.
                // JE Change 5
                if (i_supportValidateUnique) {
                    aColumnSpec.validateUnique(aPO,
                            i_stmtExecuter,
                            i_primaryKeyColumnSpec,
                            i_databasePolicy,
                            i_subtypeTableName);
                }
            }
            // while
        } catch (MissingAttributeException e) {
            throw e;
        } catch (DuplicateRowException e) {
            throw e;
        } catch (DatabaseException e) {
            throw e;
        }
        if (LOG.isDebugEnabled()) {
            // this avoids StringBuffer creation

            LOG.debug(i_tableName + ": AbstractDomain.validate(" + aPO + ") was successful.");
        }
    }

    // validate(aPO, aJDBCHelper)


    /**
     *  Updates the database by the <code>PersistentState</code> of the supplied
     *  <code>PersistentObject</code>.
     *
     *@param  aPO                            <code>PersistentObject</code>
     *      instance to update.
     *@param  aJDBCHelper                    <code>JDBCHelper</code> instance.
     *@return                                Description of the Return Value
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  InvalidValueException      Description of the Exception
     *@see
     *      net.sf.jrf.sql.JRFTransaction#endTransaction()
     *@throws  ObjectHasChangeException      when another user has already
     *      updated the record (i.e. an optimistic lock error.
     *@throws  MissingAtributeException      if the column specification for
     *      some fields are marked as required and these fields are <code>null</code>
     *      in the <code>PersistentObject</code> parameter.
     *@throws  DuplicateRowException         if an insert operation fails or
     *      would fail because of key duplication.
     *@see                                   net.sf.jrf.sql.JRFTransaction
     *@deprecated                            <code>JDBCHelper</code> argument
     *      will be ignored.
     */
    public PersistentObject save(PersistentObject aPO, JDBCHelper aJDBCHelper)
             throws ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException,
            InvalidValueException {
        return save(aPO);
    }


    /**
     *  Updates the database by the <code>PersistentState</code> of the supplied
     *  <code>PersistentObject</code>. Calling this method is the equivalent of
     *  calling <code>update</code>.
     *
     *@param  aPO                            <code>PersistentObject</code>
     *      instance to update.
     *@return                                Description of the Return Value
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  InvalidValueException      Description of the Exception
     *@see
     *      net.sf.jrf.sql.JRFTransaction#endTransaction()
     *@throws  ObjectHasChangeException      when another user has already
     *      updated the record (i.e. an optimistic lock error.
     *@throws  MissingAtributeException      if the column specification for
     *      some fields are marked as required and these fields are <code>null</code>
     *      in the <code>PersistentObject</code> parameter.
     *@throws  DuplicateRowException         if an insert operation fails or
     *      would fail because of key duplication.
     *@see                                   net.sf.jrf.sql.JRFTransaction
     *@see                                   #update(PersistentObject)
     */
    public PersistentObject save(PersistentObject aPO)
             throws ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException,
            InvalidValueException {
        return update(aPO);
    }


    /**
     *  Updates object, respecting both deletes and saves by examining <code>PersistentState</code>
     *  values in <code>PersistentObject</code> parameter and any of its
     *  embedded <code>PersistentObjects</code>s. The entire operation will be
     *  handled as a single transaction if this update is not part of a larger
     *  transaction set. <p>
     *
     *  Any <code>UpdateListener</code> instances registered with be notified of
     *  the update.
     *
     *@param  aPO   <code>PersistentObject</code>
     *      instance to update. This parameter and any embedded objects will
     *      have the changes upon a successful operation:
     *      <ul>
     *        <li> Any auto-sequence values will be set (inserts).
     *        <li> Any optimistic lock column values will be set.
     *        <li> Any embedded objects marked as deleted will be removed.
     *      </ul>
     *
     *@return   if the domain is to return the
     *      <code>PersistentObject</code>, the return value will be the object
     *      just updated; otherwise the return value will be <code>null</code>.
     *@throws  InvalidValueException          If an attribute in the object is not valid.
     *@throws  ObjectHasChangedException      when another user has already
     *                                        updated the record (i.e. an optimistic lock error).
     *@throws  MissingAtributeException       if the column specification for
     *                                        some fields are marked as required and these fields are <code>null</code>
     *                                        in the <code>PersistentObject</code> parameter.
     *@throws  DuplicateRowException          If an insert operation fails or
     *                                         would fail because of key duplication.
     *@throws  IllegalStateException          If object is read-only.
     *@see                                   net.sf.jrf.sql.JRFTransaction
     *@see                                   net.sf.jrf.domain.EmbeddedPersistentObjectHandler
     *@see                                   #getReturnSavedObject()
     *@see                                   net.sf.jrf.domain.UpdateListener
     *@see                                   #addUpdateListener(UpdateListener)
     */
    public PersistentObject update(PersistentObject aPO)
             throws ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException, IllegalStateException, InvalidValueException {
        if (i_readOnly) {
            throw new IllegalStateException("Domain is read-only. Can't update.");
        }
        PersistentObject result = null;
        if (i_inTransactionState) {
            // Already part of a transaction.
            result = this.localUpdate(aPO, 1, i_returnSavedObject);
        } else {
            localWriteTransaction.beginTransaction();
            try {
                result = this.localUpdate(aPO, 1, i_returnSavedObject);
            } catch (Exception ex) {
                localWriteTransaction.abortTransaction();
                if (ex instanceof ObjectHasChangedException) {
                    throw (ObjectHasChangedException) ex;
                }
                if (ex instanceof MissingAttributeException) {
                    throw (MissingAttributeException) ex;
                }
                if (ex instanceof DuplicateRowException) {
                    throw (DuplicateRowException) ex;
                }
                if (ex instanceof InvalidValueException) {
                    throw (InvalidValueException) ex;
                }
                throw (RuntimeException) ex;
            }
            localWriteTransaction.endTransaction();
        }
        PersistentObject changed = (result == null ? aPO : result);
        if (LOG.isDebugEnabled())
		LOG.debug("State of object update() complete: "+changed);
        // Update cache if required.
        PersistentObjectCache.updateCache(this, changed);
	// Update local and global listeners.
        Iterator iter = i_updateListeners.iterator();
        while (iter.hasNext()) {
            UpdateListener listener = (UpdateListener) iter.next();
            listener.objectUpdated(changed);
        }
	List globalListeners = (List) updateListeners.get(this.getClass().getName());
	if (globalListeners != null) {
        	iter = globalListeners.iterator();
      		while (iter.hasNext()) {
            		UpdateListener listener = (UpdateListener) iter.next();
            		listener.objectUpdated(changed);
		}
	}
        return result;
    }


    /**
     *  Saves the object. Subclasses only need to call this class when they
     *  override <code>embeddedObjectSave()</code>.
     *
     *@param  parentPO                       object to save.
     *@param  recurseLevel                   Description of the Parameter
     *@param  returnSavedObjectParent        Description of the Parameter
     *@return                                Description of the Return Value
     *@exception  ObjectHasChangedException  Description of the Exception
     *@exception  MissingAttributeException  Description of the Exception
     *@exception  DuplicateRowException      Description of the Exception
     *@exception  InvalidValueException      Description of the Exception
     */
    private PersistentObject localUpdate(PersistentObject parentPO, int recurseLevel, boolean returnSavedObjectParent)
             throws ObjectHasChangedException,
            MissingAttributeException,
            DuplicateRowException, InvalidValueException {

        i_embeddedPersistentObjHandlersToFetch.clear();
        // Clear list set below for embedded objects.
        PersistentObject returnValue = null;
        assureDatabaseConnection();
        // Make sure we are ready to touch the database.
        PreparedStatementListHandler preparedStatements = i_jrfConnection.getPreparedStatementList();
        int recordsUpdated = 0;

        if (parentPO == null) {
            throw new IllegalArgumentException(
                    "Null argument value for aPO was passed to "
                    + "AbstractDomain#save(...)");
        }
        if (LOG.isDebugEnabled()) {
            LOG.debug(this + ".localUpdate(" + parentPO + "," + recurseLevel + "); \n" +
                    "Persistent state: " + parentPO.getPersistentState() +
                    "\nNumber of embedded object handlers: " + i_embeddedPersistentObjHandlers.size() +
                    "\n\tDeletable embedded objects exist? " + i_gotDeleteableEmbeddedObjects +
                    "\n\tWriteable embedded objects exist? " + i_gotWriteableEmbeddedObjects +
                    "\nApplicable save attribute values: \n" +
                    "\tValidate before saving? " + i_validateBeforeSaving + "\n" +
                    "\tReturn saved object (e.g. refetch)? " + i_returnSavedObject + "\n" +
                    "\tWill handle duplicate key error codes or text? " + i_supportDuplicateKeyErrorCheck + "\n" +
                    "\tHave to worry about a sequence? " + i_gotSequenceColumnToHandle + "\n" +
                    "\tWill call validateUnique()? " + i_supportValidateUnique + "\n");
        }
        if (parentPO.hasDeletedPersistentState()) {
            // Don't care about states of embedded objects. Master is gone; blow away any applicable
            // detail records.
            if (i_gotDeleteableEmbeddedObjects) {
                Iterator iterator = i_embeddedPersistentObjHandlers.iterator();
                while (iterator.hasNext()) {
                    EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
                    if (handler.isDependentDetailRecord()) {
                        handler.deleteDetailRecords(parentPO);
                    }
                }
            }
            this.localDelete(parentPO);
            return parentPO;
        }
        // Throw an exception if trying to resave an old instance.
        if (parentPO.hasDeadPersistentState()) {
            throw new DatabaseException(
                    "This instance has persistent state of \"dead\" and cannot be saved again. "
                    + "If you wish to reuse instances, set ReturnSavedObject to false or refetch the object. "
                    + "However, be warned that you won't get updated timestamps.");
        }
        if (!parentPO.hasCurrentPersistentState()) {
            // Main object is a modify or a new.

            // Perform any pre-validation logic defined by subclass.  This happens
            // before validating so it can be made valid if needed.
            this.preValidate(parentPO, i_stmtExecuter);
            if (i_validateBeforeSaving) {
                // Throw exception if object is not valid
                this.validate(parentPO);
            }
            // Perform any pre-save logic defined by subclass.  This happens after
            // validating so you can be sure the object is valid.
            this.preSave(parentPO, i_stmtExecuter);
            List columnSpecs = i_columnSpecs;
            if (parentPO.hasNewPersistentState()) {
                // this is an insert

                LOG.debug("Execute prepared insert start.");
                this.executePreparedSQLInsert(
                        preparedStatements.getAndPrepare(psKey[PS_INSERTBASE], parentPO),
                        i_tableName);
                LOG.debug("Execute prepared insert complete.");
                try {
                    i_getAutoIncrementHandler.updatePrimaryKeyWithAutoIncrementId(parentPO);
                } catch (SQLException e) {
                    throw new DatabaseException(e, "Fetch auto-increment Id failed.");
                }
                // Insert into a subtype table if there is one.
                if (i_subtypeColumnSpecs.size() > 0) {
                    // Insert into the Subtype table.
                    this.executePreparedSQLInsert(
                            preparedStatements.getAndPrepare(psKey[PS_INSERTSUB],
                            parentPO), i_subtypeTableName);
                }
                // if there is a subtype table
            }
            // if this is an insert
            else {
                // this is an update

                this.doUpdate(preparedStatements.getAndPrepare(psKey[PS_UPDATEBASE], parentPO),
                        parentPO);
                // Insert to or update the subtype table if there is one.
                if (i_subtypeColumnSpecs.size() > 0) {
                    // Check to see if we need to do an insert or an update
                    // This adds an extra JDBC call, which I don't like, but there
                    // is no db-neutral way (that I know of) to trap a
                    // "row not found" error on an update.  Another solution might
                    // be to have a subtype PersistentState in each PO.
                    SelectSQLBuilder selectSQLBuilder = this.getSelectSQLBuilder();
                    Integer i = this.findInteger(
                            selectSQLBuilder.buildCountSQL(i_subtypeTableName,
                            i_primaryKeyColumnSpec,
                            parentPO,
                            i_databasePolicy));
                    if (i.intValue() == 0) {
                        // Insert into the subtype table.
                        this.executePreparedSQLInsert(
                                preparedStatements.getAndPrepare(psKey[PS_INSERTSUB],
                                parentPO),
                                i_subtypeTableName);
                    }
                    // if we needed to insert
                    else {
                        // Update the subtype table.
                        this.doUpdate(preparedStatements.getAndPrepare(psKey[PS_UPDATESUB], parentPO), parentPO);
                    }
                }
            }
            // else
            // Perform any post-save logic defined by subclass.
            this.postSave(parentPO, i_stmtExecuter);
            // TODO: deprecated call.
            // Return whatever got stored in the database.  This is needed because
            // timestamp and sequence columns can be changed during the JDBC call.
            recordsUpdated++;
        }
        ///////////////////////////////////////////////////
        // Do we have to deal with embedded objects?
        ///////////////////////////////////////////////////
        if (i_gotWriteableEmbeddedObjects) {
            if (LOG.isDebugEnabled()) {
                LOG.debug(this + ": got writeable embedded objects.");
            }
            // Traverse the list of embedded object handlers.
            Iterator iterator = i_embeddedPersistentObjHandlers.iterator();
            while (iterator.hasNext()) {
                EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
                // Read only objects are ignored, of course.
                if (handler.isReadOnly()) {
                    continue;
                }
                if (LOG.isDebugEnabled()) {
                    LOG.debug(this + ": processing embedded handler " + handler);
                }
                Iterator objs = handler.getObjectIterator(parentPO);
                // If there are no objects, carry on to the next.
                if (objs == null) {
                    if (LOG.isDebugEnabled()) {
                        LOG.debug(this + " handler " + handler + " returned null from getObjectIterator(); no objects exist.");
                    }
                    continue;
                }
                // Add this to list of sub-objects to fetch so keyFind() will know what to do.
                i_embeddedPersistentObjHandlersToFetch.add(handler);
                ////////////////
                AbstractDomain embeddedDomain = handler.getDomain();
                int counter = 0;
                // For each embedded object:
                while (objs.hasNext()) {
                    PersistentObject embeddedPO = (PersistentObject) objs.next();
                    if (LOG.isDebugEnabled()) {
                        LOG.debug(embeddedPO + ": processing object " + (++counter) + ".");
                    }
                    // Save some time by not even bothering to process objects with current states.
                    // (calling localUpdate() would result in a no-op)
                    // However, allow dead states to go through an generate an exception; see above.
                    if (!embeddedPO.hasCurrentPersistentState()) {
                        if (embeddedPO.hasNewPersistentState()) {
                            // Populate embedded object key values where necessary.
                            handler.populateEmbeddedObjectKeyValues(parentPO, embeddedPO);
                        }
                        // Run the recursive call to localUpdate().  If the parent does NOT
                        // have return saved object flag set to true, and embedded does,
                        // set the flag for the call from the local setting.
                        PersistentObject retVal = embeddedDomain.localUpdate(embeddedPO, recurseLevel + 1,
                                i_returnSavedObject ? i_returnSavedObject : returnSavedObjectParent);
                        /////////////////////////////////////////////////////////////////////////////////
                        // Returned saved object handling Part 1
                        // If the parent (or grandparent) record has i_returnSavedObject set to true,
                        // it makes no sense to handle any refetch at the embedded level since the
                        // parent/grandparent will refetch all anyway. We do, however, want to handle the
                        // returned saved object flag for embedded objects when the parent i_returnSavedObject
                        // is false.
                        // See code below.
                        /////////////////////////////////////////////////////////////////////////////////
                        if (LOG.isDebugEnabled()) {
                            LOG.debug(this + " handler " + handler + ": recursive call to localUpdate() for item " + counter +
                                    " complete.");
                        }
                        if (embeddedPO.hasDeletedPersistentState()) {
                            objs.remove();
                            // Remove from the list.
                        } else if (!returnSavedObjectParent &&
                                embeddedDomain.getReturnSavedObject()) {
                            embeddedDomain.copyAttributes(retVal, embeddedPO);
                            embeddedPO.forceCurrentPersistentState();
                            // Overwrite dead status set in localUpdate() call.
                        }
                        recordsUpdated++;
                    }
                    if (LOG.isDebugEnabled()) {
                        LOG.debug(this + ": for handler " + handler + ". Processing of " + counter + " embedded records is complete.");
                    }
                }
            }
        }
        if (LOG.isDebugEnabled()) {
            LOG.debug(this + ".localUpdate(): Total records updated for "
                    + (recurseLevel == 1 ? "root" : "embedded") + " record: " + recordsUpdated);
        }
        if (i_returnSavedObject) {
            if (recordsUpdated == 0) {
                return parentPO;
            }
            // Returned saved object handling Part 2
            // Only refetch if: 1) At the root record; 2) Not root and parent is NOT refetching.
            if (recurseLevel == 1 || !returnSavedObjectParent) {
                // This is the master record. Refetch everything.
                if (LOG.isDebugEnabled()) {
                    LOG.debug(this + ".localUpdate(): Refetching of returned object.");
                }
                // Find; but bother to fetch embedded objects only when you know they exist.
                returnValue = this.keyFind(parentPO, i_embeddedPersistentObjHandlersToFetch, false);
                if (returnValue == null) {
                    LOG.error(this + ": find after database update returned NULL: " + parentPO);
                }
            } else if (LOG.isDebugEnabled()) {
                LOG.debug(this + ": leaving fetch returned object up to parent PO");
            }
        }
        // Force to dead ONLY if we have timestamp columns
        if (i_gotWriteableTimestampDbColumns) {
            parentPO.forceDeadPersistentState();
        } else {
            parentPO.forceCurrentPersistentState();
        }
        return returnValue;
    }

    // localUpdate(parentPO,recurseLevel)


    /**
     *  This method is here to help clean up the save() method a bit
     *
     *@param  p                              Description of the Parameter
     *@param  aPO                            Description of the Parameter
     *@exception  ObjectHasChangedException  Description of the Exception
     */
    private void doUpdate(JRFPreparedStatement p, PersistentObject aPO) throws ObjectHasChangedException {

        int rowCount;
        rowCount = this.executePreparedSQLUpdate(p);
        if (rowCount < 1) {
            throw new ObjectHasChangedException(this.find(aPO),aPO);
        }
    }

    // doUpdate(...)


    ////////////////////////////////////////////////////
    // Delete methods.
    ////////////////////////////////////////////////////

    /**
     *  Deletes the persistent object (e.g. a single row) from the database.
     *
     *@param  aPO                            a <code>PersistentObject</code>
     *      instance.
     *@return                                <code>1</code> for a successful
     *      deletion.
     *@exception  ObjectHasChangedException  Description of the Exception
     */
    public final int delete(PersistentObject aPO) throws ObjectHasChangedException {
        aPO.forceDeletedPersistentState();
        try {
            this.update(aPO);
        }
        // Wrap other exceptions that won't happen in this context.
        catch (Exception ex) {
            if (ex instanceof ObjectHasChangedException) {
                throw (ObjectHasChangedException) ex;
            }
            if (ex instanceof DatabaseException) {
                throw (DatabaseException) ex;
            }
            throw new DatabaseException(ex, "Unexpected dalete() exception.");
            // Should never happen
        }
        return 1;
    }


    // Private method to delete. // NO ROLLBACKS OR COMMITS !!!
    /**
     *  Description of the Method
     *
     *@param  aPO                            Description of the Parameter
     *@return                                Description of the Return Value
     *@exception  ObjectHasChangedException  Description of the Exception
     */
    private int localDelete(PersistentObject aPO) throws ObjectHasChangedException {
        if (LOG.isDebugEnabled()) {
            LOG.debug(
                    "AbstractDomain.delete(" + aPO + ")");
        }
        if (aPO == null) {
            throw new IllegalArgumentException(
                    "A null value argument for aPO was passed to "
                    + "AbstractDomain#delete(aPO)");
        }
        /////////////////////////////////////////////////////////////////////////////////////////
        // Perform any special logic specified in the subclass.
        this.preDelete(aPO, i_stmtExecuter);
        String tableName = null;
        List colSpecs = null;
        ColumnSpec pkSpec = null;
        if (i_subtypeColumnSpecs.size() == 0) {
            tableName = i_tableName;
            colSpecs = i_columnSpecs;
            pkSpec = i_primaryKeyColumnSpec;
        } else {
            tableName = i_subtypeTable.getTableName();
            colSpecs = i_subtypeColSpecsForSql;
            pkSpec = i_subtypePrimaryKeyColumnSpec;
        }
        int rowCount = this.executePreparedSQLUpdate(
                i_jrfConnection.getPreparedStatementList().getAndPrepare(psKey[PS_DELETE], aPO));
        if (i_verifyDelete && rowCount != 1) {
            throw new ObjectHasChangedException(this.keyFind(aPO, i_embeddedPersistentObjHandlers, i_usePostFind),aPO);
        }
        this.postDelete(aPO, i_stmtExecuter);
        return rowCount;
    }

    // delete(aPO, aJDBCHelper)


    // Deprecated methods.
    /**
     *  Deletes the persistent object (e.g. a single row) from the database.
     *
     *@param  aPO                            a <code>PersistentObject</code>
     *      instance.
     *@param  aJDBCHelper                    <code>JDBCHelper</code> instance.
     *@return                                <code>1</code> for a successful
     *      deletion.
     *@exception  ObjectHasChangedException  Description of the Exception
     *@deprecated                            use delete() with no arguments.
     *      <code>JDBCHelper argument will
     * be ignored.
     *
     *
     */
    public int delete(PersistentObject aPO, JDBCHelper aJDBCHelper) throws ObjectHasChangedException {
        return this.delete(aPO);
    }


    //////////////////////////////////////////////////////////////////////////
    // END  --  Database update methods (save and delete).
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  Table create and drop methods.
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Creates table for underlying domain.
     *
     *@param  aJDBCHelper  <code>JDBCHelperInstance.
     *
     *
     *@deprecated          <code>JDBCHelper</code> argument will be ignored.
     */
    public void createTable(JDBCHelper aJDBCHelper) {
        this.createTable();
    }


    /**
     *  Creates a table for the underlying domain.
     *
     *@see    #createTable(List,String,String)
     */
    public void createTable() {
        createTable(null, null, null);
    }


    /**
     *  Creates a table for the underlying domain.
     *
     *@param  foreignKeys           List of <code>ForeignKey</code> elements.
     *@param  vendorSpecifications  Database vendor-specific expression that is
     *      inserted after the CREATE TABLE construct to specify specification
     *      parameters, usually for how the table should be stored physically.
     *      (e.g. Under Oracle, tablepace, etc).
     */
    public void createTable(List foreignKeys, String vendorSpecifications) {
        createTable(foreignKeys, vendorSpecifications, null);
    }


    /**
     *  Creates a table for the underlying domain.
     *
     *@param  foreignKeys           List of <code>ForeignKey</code> elements.
     *@param  vendorSpecifications  Database vendor-specific expression that is
     *      inserted after the CREATE TABLE construct to specify specification
     *      parameters, usually for how the table should be stored physically.
     *      (e.g. Under Oracle, tablepace, etc).
     *@param  sequenceParameters    Sequence parameters if applicable.
     */
    public void createTable(List foreignKeys, String vendorSpecifications, String sequenceParameters) {
        if (i_inTransactionState) {
            if (!i_jrfConnection.getDataSourceProperties().isTransactionsForDropAndCreateSupported()) {
                throw new RuntimeException("Transactions are not supported for create table under: " +
                        i_jrfConnection.getDataSourceProperties());
            }
            this.createTableLocal(foreignKeys, vendorSpecifications);
            this.createTableSequence(sequenceParameters);
            return;
        }
        this.assureDatabaseConnection();
        // Treat create table and sequence create as separate transactions.
        try {
            this.createTableLocal(foreignKeys, vendorSpecifications);
            this.createTableSequence(sequenceParameters);
        } finally {
            this.i_jrfConnection.closeOrReleaseResources();
        }
    }


    /**
     *  Description of the Method
     *
     *@param  sequenceParameters  Description of the Parameter
     *@return                     Description of the Return Value
     */
    private boolean createTableSequence(String sequenceParameters) {
        if (i_primaryKeyColumnSpec.isSequencedPrimaryKey()) {
            try {
                this.getDatabasePolicy().createSequence(this, sequenceParameters, i_stmtExecuter);
                return true;
            } catch (SQLException ex) {
                throw new DatabaseException(ex, "Unable to create sequence.");
            }
        }
        return false;
    }


    /**
     *  Description of the Method
     *
     *@param  foreignKeys           Description of the Parameter
     *@param  vendorSpecifications  Description of the Parameter
     */
    private void createTableLocal(List foreignKeys, String vendorSpecifications) {
        CreateTableSQLBuilder sqlBuilder = this.getCreateTableSQLBuilder();
        String tableName = null;
        List columnSpecs = null;
        if (i_subtypeColumnSpecs.size() > 0) {
            // Create the subtype table instead
            tableName = i_subtypeTable.getTableName();
            columnSpecs = i_subtypeColSpecsForSql;
        } else {
            tableName = i_tableName;
            columnSpecs = i_columnSpecs;
        }
        try {
            i_stmtExecuter.executeCreateOrDropTableSQL(
                    sqlBuilder.buildSQL(tableName, columnSpecs, foreignKeys, vendorSpecifications, false));
            LOG.debug(tableName + " table created.");
            // If we could not create foreign keys inside the CREATE TABLE statment, create them outside it.
            if (foreignKeys != null && foreignKeys.size() > 0 && !i_databasePolicy.foreignKeyExpressionsAllowedInCreateTable()) {
                Iterator iter = foreignKeys.iterator();
                while (iter.hasNext()) {
                    ForeignKey fk = (ForeignKey) iter.next();
                    String stmt = i_databasePolicy.getForeignKeySQLStatement(fk);
                    i_stmtExecuter.executeUpdate(stmt);
                    LOG.debug(stmt + " successfully executed.");
                }
            }
        } catch (Exception ex) {
            throw new DatabaseException(ex, "Create table on " + tableName + " failed.");
        }
    }

    // createTableLocal(List,String)


    /**
     *  Execute SQL to drop the table for this domain object.
     *
     *@param  ignoreErrors  a value of type 'boolean'
     *@param  helper        Description of the Parameter
     *@deprecated           JDBCHelper argument will be ignored.
     */
    public void dropTable(boolean ignoreErrors, JDBCHelper helper) {
        dropTable(ignoreErrors);
    }


    /**
     *  Execute SQL to drop the table for this domain object.
     *
     *@param  ignoreErrors  a value of type 'boolean'
     */
    public void dropTable(boolean ignoreErrors) {
        if (i_inTransactionState) {
            if (!i_jrfConnection.getDataSourceProperties().isTransactionsForDropAndCreateSupported()) {
                throw new RuntimeException("Transactions are not supported for drop table under: " +
                        i_jrfConnection.getDataSourceProperties());
            }
            this.dropTableLocal(ignoreErrors);
            return;
        }
        this.assureDatabaseConnection();
        try {
            this.dropTableLocal(ignoreErrors);
        } finally {
            i_jrfConnection.closeOrReleaseResources();
        }
    }


    /**
     *  Execute SQL to drop the table for this domain object. If this class
     *  represents a subtype table, then the subtype table will be dropped
     *  instead. This code is unfortunately ugly because of the reimplementation
     *  of error handling when ignoreErrors is true.
     *
     *@param  ignoreErrors  a value of type 'boolean' - It is often that we
     *      don't want to know if the table wasn't there.
     *@return               Description of the Return Value
     */
    private boolean dropTableLocal(boolean ignoreErrors) {
        String sql = null;
        if (i_subtypeColumnSpecs.size() > 0) {
            sql = "DROP TABLE " + i_subtypeTable.getTableName();
        } else {
            sql = "DROP TABLE " + i_tableName;
        }
        try {
            i_stmtExecuter.executeCreateOrDropTableSQL(sql);
            LOG.debug(sql + " succeeeded. Table existed.");
            return true;
        } catch (SQLException ex) {
            if (!ignoreErrors) {
                LOG.error(sql + " failed. ", ex);
                throw new DatabaseException(ex, "Unable to drop table.");
            }
        }
        return false;
    }

    // dropTableLocal(ignoreErrors)


    //////////////////////////////////////////////////////////////////////////
    // END  --  Table create and drop methods.
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  Sequence handling methods.
    //////////////////////////////////////////////////////////////////////////

    /**
     *@param  aJDBCHelper  Description of the Parameter
     *@return              Description of the Return Value
     *@deprecated          -- JDBCHelper arguement will be ignored.
     */
    public Long nextSequence(JDBCHelper aJDBCHelper) {
        return nextSequence();
    }


    /**
     *  Use JDBC to call a stored procedure to get a the next available sequence
     *  id.
     *
     *@return    a value of type 'Long'
     */
    public Long nextSequence() {
        assureDatabaseConnection();
        try {
            return this.findLong(this.getDatabasePolicy().sequenceSQL(this.getSequenceName(), this.getTableName()));
        } finally {
            if (!i_inTransactionState) {
                i_jrfConnection.closeOrReleaseResources();
            }
        }

    }

    // nextSequence()


    //////////////////////////////////////////////////////////////////////////
    // END  --  Sequence handling methods.
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  General database access utility methods.
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Returns a single row, single column query result as a <code>Integer.
     *
     *
     *
     *
     *@param  sql  a value of type 'String'
     *@return      a value of type 'Integer'
     */
    protected Integer findInteger(String sql) {
        assureDatabaseConnection();
        try {
            return i_stmtExecuter.getSingleRowColAsInteger(sql);
        } catch (SQLException ex) {
            throw new DatabaseException(ex, sql + " failed.");
        } finally {
            if (!i_inTransactionState) {
                i_jrfConnection.closeOrReleaseResources();
            }
        }
    }


    /**
     *  This method calls findLong and casts the result down to an Integer. It
     *  is up to the developer to be sure the result will fit into an Integer.
     *
     *@param  sql          a value of type 'String'
     *@param  aJDBCHelper  Description of the Parameter
     *@return              a value of type 'Integer'
     *@deprecated          -- JDBCHelper arguement will be ignored.
     */
    protected Integer findInteger(String sql, JDBCHelper aJDBCHelper) {
        return findInteger(sql);
    }


    /**
     *  This is a pass-through method that adds the default JDBCHelper to the
     *  parameter list.
     *
     *@param  sql          a value of type 'String'
     *@param  aJDBCHelper  a value of type 'JDBCHelper'
     *@return              a value of type 'Long'
     *@deprecated          -- JDBCHelper arguement will be ignored.
     */
    protected Long findLong(String sql, JDBCHelper aJDBCHelper) {
        return this.findLong(sql);
    }


    /**
     *  Execute SQL that returns a Long. This is great for SQL where you just
     *  want to get a count of rows, or anything else where all you need from
     *  the result set is one Integer.
     *
     *@param  sql    a value of type 'String'
     *@return        a value of type 'Long'
     *@deprecated    use JDBCHelper.getSingleRowColAsLong()
     */
    protected Long findLong(String sql) {
        assureDatabaseConnection();
        try {
            return i_stmtExecuter.getSingleRowColAsLong(sql);
        } catch (SQLException ex) {
            throw new DatabaseException(ex, sql + " failed.");
        } finally {
            if (!i_inTransactionState) {
                i_jrfConnection.closeOrReleaseResources();
            }
        }

    }

    // findLong(sql, aJDBCHelper)


    /**
     *  Execute SQL that will return the current date and time from the
     *  database. This method should only be used when you want to display the
     *  database time to the user or something like that. To update a
     *  PersistentObject using the current timestamp, put
     *  JRFConstants.CURRENT_TIMESTAMP into the object. This is much more
     *  efficient.
     *
     *@param  jdbcHelper  Description of the Parameter
     *@return             a value of type 'Timestamp'
     *@deprecated         -- JDBCHelper arguement will be ignored.
     */
    public Timestamp findCurrentTimestamp(JDBCHelper jdbcHelper) {
        return this.findCurrentTimestamp();
    }


    /**
     *  Execute SQL that will find the current timestamp value from the
     *  database. This should generally not be used to set a timestamp in an
     *  instance that is about to be saved. Instead set that timestamp to
     *  JRFConstants.CURRENT_TIMESTAMP before saving. This will save a JDBC call
     *  and will be more precise.
     *
     *@return    a value of type 'Timestamp'
     */
    public Timestamp findCurrentTimestamp() {
        assureDatabaseConnection();
        try {
            return i_stmtExecuter.getSingleRowColAsTimestamp(i_databasePolicy.currentTimestampSQL());
        } catch (SQLException ex) {
            throw new DatabaseException(ex, "time stamp fetch failed.");
        } finally {
            if (!i_inTransactionState) {
                i_jrfConnection.closeOrReleaseResources();
            }
        }

    }

    // findCurrentTimestamp(aJDBCHelper)


    //////////////////////////////////////////////////////////////////////////
    // END  --  General database access utility methods.
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    // BEGIN  --  General utility methods.
    //////////////////////////////////////////////////////////////////////////

    /**
     *  Generates SQL insert scripts for a particular <code>PersistentObject</code>
     *  instance and all of its embedded objects.
     *
     *@param  aPO                        <code>PersistentObject</code> instance
     *      to process.
     *@param  writer                     <code>PrintWriter</code> instance to
     *      place the generated
     *@param  includeImplicitInsertCols  if this value is <code>true</code>,
     *      insert script generated will include the value of any auto-insert
     *      columns. statements.
     */
    public void generateInsertScript(PersistentObject aPO, PrintWriter writer, boolean includeImplicitInsertCols) {
        Iterator iterator = i_embeddedPersistentObjHandlers.iterator();
        InsertSQLBuilder masterBuilder = new InsertSQLBuilder(this);
        writer.println(masterBuilder.buildSQL(aPO, i_tableName, i_columnSpecs, includeImplicitInsertCols));
        while (iterator.hasNext()) {
            EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iterator.next();
            if (handler.isReadOnly()) {
                continue;
            }
            AbstractDomain embeddedDomain = handler.getDomain();
            Iterator objs = handler.getObjectIterator(aPO);
            if (objs == null) {
                continue;
            }
            InsertSQLBuilder embeddedBuilder = new InsertSQLBuilder(embeddedDomain);
            while (objs.hasNext()) {
                PersistentObject embeddedPO = (PersistentObject) objs.next();
                writer.println(embeddedBuilder.buildSQL(embeddedPO, embeddedDomain.getTableName(), embeddedDomain.getColumnSpecs(),
                        includeImplicitInsertCols));
            }
        }
    }


    /**
     *  Encode the primary key for the given PersistentObject instance as a
     *  string that can be decoded later.
     *
     *@param  aPO  a value of type 'PersistentObject'
     *@return      a value of type 'String'
     */
    public String encodePrimaryKey(PersistentObject aPO) {
        return i_primaryKeyColumnSpec.encodeFromPersistentObject(aPO);
    }


    /**
     *  Encode the primary key for the given PersistentObject instance as a
     *  string that can be decoded later.
     *
     *@param  aString  a value of type 'String'
     *@return          a value of type 'PersistentObject'
     */
    public PersistentObject decodePrimaryKey(String aString) {
        PersistentObject aPO = this.newPersistentObject();
        i_primaryKeyColumnSpec.decodeToPersistentObject(aString, aPO);
        return aPO;
    }


    /**
     *  If there is a table alias, this would concatenate the table name and
     *  table alias like this 'Customer c' for a FROM clause.
     *
     *@param  sqlBuffer  a value of type 'StringBuffer'
     */
    private void buildFromTableName(StringBuffer sqlBuffer) {
        sqlBuffer.append(this.getTableName());
        if (!this.getTableName().equals(this.getTableAlias())) {
            sqlBuffer.append(" ");
            sqlBuffer.append(this.getTableAlias());
        }
    }


    /**
     *  Delimits single quotes in a string. This is a helper method for use by
     *  subclasses that are creating SQL. Any single quotes in the string are
     *  doubled, and single quotes are placed around the string. Example: param
     *  string: "Jonathan's Restaurant" return string: "'Jonathan''s
     *  Restaurant'"
     *
     *@param  aString  a value of type 'String'
     *@return          a value of type 'String'
     *@deprecated      call <code>StringUtil</code> method directly.
     *@see             net.sf.jrf.util.StringUtil#delimitSingleQuote(String)
     */
    public String delimitString(String aString) {
        return StringUtil.delimitSingleQuote(aString);
    }


    /**
     *  Copy the attribute values from a supertype instance to a subtype
     *  instance. Example of when to use this: When converting an Employee
     *  supertype instance to a Manager subtype instance.<br>
     *  <tt>Manager mgr = managerDomain.convertToSubtypePersistentObject(anEmployee);
     *  </tt>
     *
     *@param  aPO1  Description of the Parameter
     *@return       a PersistentObject (this is the new subtype instance)
     */
    public PersistentObject convertToSubtypePersistentObject(PersistentObject aPO1) {
        if (i_subtypeColumnSpecs.size() == 0) {
            throw new ConfigurationException(
                    "This method (convertToSubtypePersistentObject(aPO)) should only be "
                    + "executed on subtype domain instances.");
        }
        PersistentObject aPO2 = this.newPersistentObject();
        this.copyAttributes(aPO1, aPO2, i_columnSpecs);
        aPO2.setPersistentState(aPO1.getPersistentState());
        return aPO2;
    }


    /**
     *  Copies the ColumnSpec attributes from one PersistentObject to another.
     *  <br>
     *  Note: If this is a subtype Domain instance then the subtype fields will
     *  be copied as well.
     *
     *@param  aPO1  Description of the Parameter
     *@param  aPO2  Description of the Parameter
     */
    public void copyAttributes(PersistentObject aPO1, PersistentObject aPO2) {
        this.copyAttributes(aPO1, aPO2, this.getAllColumnSpecs());
    }


    /**
     *  Copy the ColumnSpec attributes from one PersistentObject to another.
     *
     *@param  aPO1         Description of the Parameter
     *@param  aPO2         Description of the Parameter
     *@param  columnSpecs  Description of the Parameter
     */
    private void copyAttributes(PersistentObject aPO1, PersistentObject aPO2, List columnSpecs) {
        Iterator iterator = columnSpecs.iterator();
        while (iterator.hasNext()) {
            ColumnSpec aColumnSpec = (ColumnSpec) iterator.next();
            aColumnSpec.copyAttribute(aPO1, aPO2);
        }
    }


    //////////////////////////////////////////////////////////////////////////
    // END  --  General utility methods.
    //////////////////////////////////////////////////////////////////////////
    /*
     *  ===============  Interfaces  ===============
     */
    /**
     *  Interface to handle low-level access to the <code>java.sql.ResultSet</code>
     *  for each row of a query.
     *
     *@created    June 13, 2002
     *@see        net.sf.jrf.ApplicationRowHandler
     */
    protected interface RowHandler {
        /**
         *  Process a row from an SQL query.
         *
         *@param  resultSet   Description of the Parameter
         *@throws  Exception  if some thing goes awry with fetching fields or
         *      other processing.
         *@see                #executeSQLQuery(String,net.sf.jrf.domain.AbstractDomain.RowHandler)
         */
        public void handleRow(JRFResultSet resultSet)
                 throws Exception;
    }

    // RowHandler


    // The following set of classes implements auto-increment identifiers for the various flavors
    // in DatabasePolicy
    /**
     *  Description of the Interface
     *
     */
    private interface GetAutoIncrementIdHandler {
        /**
         *  Description of the Method
         *
         *@param  aPO               Description of the Parameter
         *@exception  SQLException  Description of the Exception
         */
        public void updatePrimaryKeyWithAutoIncrementId(PersistentObject aPO) throws SQLException;
    }


    /**
     *  Description of the Class
     *
     */
    private class GetAutoIncrementIdNoOp implements GetAutoIncrementIdHandler {
        /**
         *  Description of the Method
         *
         *@param  aPO               Description of the Parameter
         *@exception  SQLException  Description of the Exception
         */
        public void updatePrimaryKeyWithAutoIncrementId(PersistentObject aPO) throws SQLException { }
    }


    /**
     *  Description of the Class
     *
     */
    private class GetAutoIncrementIdSql implements GetAutoIncrementIdHandler {
        /**
         *  Description of the Method
         *
         *@param  aPO               Description of the Parameter
         *@exception  SQLException  Description of the Exception
         */
        public void updatePrimaryKeyWithAutoIncrementId(PersistentObject aPO) throws SQLException {

            setAutoIncrementId(aPO, i_stmtExecuter.getSingleRowColAsLong(
                    i_jrfConnection.getPreparedStatementList().get(psKey[PS_GETLASTID])));

        }
    }


    /**
     *  Description of the Class
     *
     */
    private class GetAutoIncrementIdByMethod implements GetAutoIncrementIdHandler {
        /**
         *  Description of the Method
         *
         *@param  aPO               Description of the Parameter
         *@exception  SQLException  Description of the Exception
         */
        public void updatePrimaryKeyWithAutoIncrementId(PersistentObject aPO) throws SQLException {
            setAutoIncrementId(aPO, i_databasePolicy.findAutoIncrementIdByMethodInvoke(i_tableName,
                    i_primaryKeyColumnSpec.getColumnName(),
                    i_jrfConnection.getPreparedStatementList().get(psKey[PS_INSERTBASE]).getStatement()));
        }
    }


    /**
     *  Sets the autoIncrementId attribute of the AbstractDomain object
     *
     *@param  aPO    The new autoIncrementId value
     *@param  value  The new autoIncrementId value
     */
    private void setAutoIncrementId(PersistentObject aPO, Long value) {
        if (value == null) {
            throw new DatabaseException("Auto Increment Id is null");
        }
	/**
	LOG.info("Updating AUTO inc ID for "+aPO+" with "+value+" PK name is "+i_primaryKeyColumnSpec.getColumnName());
	*/
        // Determine the real type.
	Object setValue;		// Assume long, but may be short or int.
	if (i_primaryKeyColumnSpec.getColumnClass().equals(java.lang.Short.class)) {
		setValue = new Short(value.shortValue());
	}	
	else if (i_primaryKeyColumnSpec.getColumnClass().equals(java.lang.Integer.class)) {
		setValue = new Integer(value.intValue()); 
	}
	else
		setValue = value;	// Assume long.
        i_primaryKeyColumnSpec.setValueTo(setValue, aPO);
	if (LOG.isDebugEnabled())
		LOG.debug("setAutoIncrementId("+aPO+","+value+")");
    }


    // Domain Statement
    /**
     *  Description of the Class
     *
     */
    private class OtherPreparedStatement {
        String key;
        String sql;
        List columnSpecs;
        String whereClause;
        String tableName;
        String orderBy;
        boolean isFind = false;


        /**
         *  Constructor for the OtherPreparedStatement object
         *
         *@param  key          Description of the Parameter
         *@param  columnSpecs  Description of the Parameter
         *@param  sql          Description of the Parameter
         */
        OtherPreparedStatement(String key, List columnSpecs, String sql) {
            this.key = key;
            this.columnSpecs = columnSpecs;
            this.sql = sql;
        }


        /**
         *  Constructor for the OtherPreparedStatement object
         *
         *@param  key          Description of the Parameter
         *@param  tableName    Description of the Parameter
         *@param  whereClause  Description of the Parameter
         *@param  orderBy      Description of the Parameter
         *@param  columnSpecs  Description of the Parameter
         */
        OtherPreparedStatement(String key, String tableName, String whereClause, String orderBy, List columnSpecs) {
            this(key, columnSpecs, null);
            this.tableName = tableName;
            this.orderBy = orderBy;
            this.whereClause = whereClause;
            isFind = true;
        }
    }


    /**
     *@deprecated    -- no longer in use. *
     */
    public void beginTransaction() { }


    /**
     *@param  aJDBCHelper  Description of the Parameter
     *@deprecated          -- no longer in use. *
     */
    public void beginTransaction(JDBCHelper aJDBCHelper) { }


    /**
     *@deprecated    -- no longer in use. *
     */
    public void endTransaction() { }


    /**
     *@param  aJDBCHelper  Description of the Parameter
     *@deprecated          -- no longer in use. *
     */
    public void endTransaction(JDBCHelper aJDBCHelper) { }

}
// AbstractDomain

