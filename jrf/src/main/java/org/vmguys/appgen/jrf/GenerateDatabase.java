/* ====================================================================
 * The VM Systems, Inc. Software License, Version 1.0
 *
 * Copyright (c) 2002 VM Systems, Inc.  All rights reserved.
 *
 * THIS SOFTWARE IS PROVIDED PURSUANT TO THE TERMS OF THIS LICENSE.
 * ANY USE, REPRODUCTION, OR DISTRIBUTION OF THE SOFTWARE OR ANY PART
 * THEREOF CONSTITUTES ACCEPTANCE OF THE TERMS AND CONDITIONS HEREOF.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by
 *        VM Systems, Inc. (http://www.vmguys.com/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "VM Systems" must not be used to endorse or promote products
 *    derived from this software without prior written permission. For written
 *    permission, please contact info@vmguys.com.
 *
 * 5. VM Systems, Inc. and any other person or entity that creates or
 *    contributes to the creation of any modifications to the original
 *    software specifically disclaims any liability to any person or
 *    entity for claims brought based on infringement of intellectual
 *    property rights or otherwise. No assurances are provided that the
 *    software does not infringe on the property rights of others.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE TITLE
 * AND NON-INFRINGEMENT ARE DISCLAIMED. IN NO EVENT SHALL VM SYSTEMS, INC.,
 * ITS SHAREHOLDERS, DIRECTORS OR EMPLOYEES BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE. EACH RECIPIENT OR USER IS SOLELY RESPONSIBLE
 * FOR DETERMINING THE APPROPRIATENESS OF USING AND DISTRIBUTING THE SOFTWARE
 * AND ASSUMES ALL RISKS ASSOCIATED WITH ITS EXERCISE OF RIGHTS HEREUNDER,
 * INCLUDING BUT NOT LIMITED TO THE RISKS (INCLUDING COSTS) OF ERRORS,
 * COMPLIANCE WITH APPLICABLE LAWS OR INTERRUPTION OF OPERATIONS.
* ====================================================================
*/
//
package org.vmguys.appgen.jrf;
import org.vmguys.appgen.*;
import org.vmguys.xml.*;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.text.*;
import java.io.*;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;
import javax.naming.*;
import java.beans.*;
import javax.naming.directory.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.vmguys.reflect.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.ErrorHandler;
import java.util.*;
import net.sf.jrf.*;
import net.sf.jrf.domain.*;
import net.sf.jrf.column.*;
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.util.*;
import net.sf.jrf.sql.*;
import net.sf.jrf.sqlbuilder.*;
import org.apache.log4j.Category;
import org.vmguys.reflect.*;

/** A class with a <code>main()</code> method
 * that will parse two XML files, a database schema file that is also parsed
 * by <code>BaseGenerator</code> that contains database table and
 * column information and a database storage parameter file
 * that contains storage information
 * for tables, indexes and sequences.  All storage parameters
 * indicated in the former file must have a value in the latter file to
 * successfully generate SQL scripts or create an actual database.
 * This program does <em>not</em> read every element from the schema file.
 * The program is run under that assumption that:
 * <ul>
 * <li> <code>BaseGenerator</code> has been run successfully, creating
 * all <code>PersistentObject</code> beans and associated <code>AbstractDomain</code>s
 * using the <strong>exact same</strong> XML schema file that will be used for this program.
 * <li> All the <code>AbstractDomain</code>s generated are present in the class path for the
 * run of this program.
 * </ul>
 * The information retrieved from the database schema file is as follows:
 * For each table:
 *  <ul>
 *  <li>   Optional database storage parameter.
 *  <li>   Index information.
 *  <li>   For each column
 *      <ul>
 *      <li>Sequence information, including storage information
 *      <li>Foreign key information.
 *      </ul>
 *  </ul>
 * This program will fail for any of the following reasons:
 * <ol>
 * <li> Class path is not correct and <code>AbstractDomains</code> cannot be found.
 * <li> File IO errors, where XML files could not be found or script file could not be created.
 * <li> XML parsing errors.
 * <li> Possible mismatched information between XML file and created domain.
 * <li> Storage parameter indicated in schema XML file is not found in storage XML file.
 * <li> Foreign key relationship information is incorrect.
 * </ol>
* @see org.vmguys.appgen.jrf.BaseGenerator
*/
public class GenerateDatabase {
    
    static Category LOG = Category.getInstance(GenerateDatabase.class.getName());


    // Likewise, temporary class to sort index info
    private class IndexTempCol implements Comparable {
        int position;
        String columnName;
        IndexTempCol(String columnName,int position) {
            this.position = position;
            this.columnName = columnName;
        }
        public int compareTo(Object obj) {
            IndexTempCol other = (IndexTempCol) obj;
            return this.position - other.position;
        }
    }

    private class IndexTemp {
        String storageKey;
        Vector cols;
        IndexTemp(String storageKey) {
            this.storageKey = storageKey;
            cols = new Vector();
        }   

    }

    // Storage information for all information in master hash table
    // of domains:
    private class Domain {
        AbstractDomain domain = null;   
        List indexes;
        String tableStorage;
        String description;
        boolean hasSequence = false;
        String sequenceName;
        String sequenceStorage;
        boolean visited = false;    // For depth first search of foreign key tree.
        List foreignKeys;       // List of Foreign keys entities.
        HashMap columnNames = new HashMap();

        Domain(String objectName,String tableName) {
            Iterator pIter = packageNames.iterator();
            StringBuffer errors = new StringBuffer();
            while (domain == null && pIter.hasNext()) {
                String dbPackageName = (String) pIter.next();       
                try {
                    domain = (AbstractDomain) org.vmguys.reflect.ReflectionHelper.createObject(
                        dbPackageName+"."+objectName+"Domain"); 
                }
                catch (RuntimeException r) {
                    errors.append(r.getMessage());  
                }
            }
            if (domain == null)
                throw new IllegalArgumentException("Unable to find domain "+objectName+" under any of the specified "+
                    "package names: "+errors.toString());
            // Set type of sequence support, if not already set.
            if (policy == null)
                policy = domain.getDatabasePolicy();
            Iterator iter = domain.getColumnSpecs().iterator();
            while (iter.hasNext()) {
                ColumnSpec spec = (ColumnSpec) iter.next();
                if (spec instanceof CompoundPrimaryKeyColumnSpec) {
                    CompoundPrimaryKeyColumnSpec cpk = (CompoundPrimaryKeyColumnSpec) spec;
                    Iterator iter2 = cpk.getColumnSpecs().iterator();
                    while (iter2.hasNext()) {
                        ColumnSpec spec2 = (ColumnSpec) iter2.next();
                        columnNames.put(spec2.getColumnName(),"");
                    }
                }
                else
                    columnNames.put(spec.getColumnName(),"");
            }   
            String testTableName = domain.getTableName();
            if (!testTableName.equals(tableName))
                throw new IllegalArgumentException("For domain "+domain+" table name mismatch; "+
                        "Domain version: "+testTableName+": XML version: "+tableName);
            foreignKeys = new ArrayList();
            indexes = new ArrayList();
        }
        public String showColumnNames() {
            StringBuffer result = new StringBuffer();
            Iterator iter = columnNames.keySet().iterator();
            int i = 0;
            while (iter.hasNext()) {
                String cn = (String) iter.next();
                if (++i > 1)
                    result.append(",");
                result.append(cn);
            }
            return result.toString();
        }
        public String toString() {
            return domain.getTableName();
        }
    }
    // Hash table of ALL domains.
    // Key = table name; value = Domain
    private HashMap domains = new HashMap();

    private DatabasePolicy policy = null;

    // Hash table of sequence information
    // Key = sequence name; Value = storage text
    private HashMap sequences = new HashMap();

    // Hash table of index information
    // Key = index name; valu = Index storage clause.
    private HashMap indexes = new HashMap();

    // Hash table of table storage information
    // Key = table name; Value = storage clause.
    private HashMap tableStorageParameters = new HashMap();

    // List of Domains in order of creation.  This list is created
    // by using a depth first seach algorithm on the foreign key list of each domain.
    private ArrayList orderedDomains = new ArrayList();
    
    private Stack callStack = new Stack();

    private HashSet xmlFileList;

    private ArrayList masterForeignKeyList = new ArrayList();
    private HashMap masterForeignKeyMap = new HashMap();
    private String scriptCommandSeparator = ";";
    private String scriptFilePath = ".";
    private String defaultUniqueIndexStorageKey = null;
    private String defaultNonUniqueIndexStorageKey = null;
    private String defaultSequenceStorageKey = null;
    private String defaultTableStorageKey = null;
    private String additionalForeignKeyInfo = null;
    private ArrayList packageNames = new ArrayList();
    private boolean initCapNameOnly = false;
    private HashSet modulesToGenerate = new HashSet();
    private Boolean supportComments;

    public GenerateDatabase(String propFile, List schemaXML, String storageXML, boolean generateScriptOnly)
            throws IOException, SecurityException, IntrospectionException,
                        SAXException, ParserConfigurationException,SQLException {
        readStorageXML(storageXML);
        Properties properties = new Properties();
        properties.load(new FileInputStream(propFile)); 
        BeanSearchUtil beanSearch = new BeanSearchUtil(this.getClass());
        beanSearch.processProperties(properties,this,true);
        if (packageNames.size() == 0) {
            throw new IllegalArgumentException("You must specify at least one package name under "+
                "'PackageNames' in properties file.");
        }
        if (xmlFileList != null)
            schemaXML.addAll(xmlFileList);
        Generator.validateXMLList(schemaXML);
        Generator.displayXML(schemaXML);
        if (supportComments == null)
            supportComments = new Boolean(false);
        run(schemaXML,storageXML,generateScriptOnly);   
    }

    /** Generates database or script files.
    * @param schemaXML      Database schema XMLs.
    * @param storageXML     Storage XML.
    * @param generateScriptOnly Generate scripts only?
    */      
    private void run(List schemaXML, String storageXML, boolean generateScriptOnly)
            throws IOException, SecurityException, IntrospectionException,
                        SAXException, ParserConfigurationException,SQLException {
        readStorageXML(storageXML);
        readSchemaXML(schemaXML);
        // Build the list of domains in the correct order
        // via usual depth first search algorithm.
        // Resolve any duplicate constraint names.
        Iterator iter = domains.values().iterator();
        while (iter.hasNext()) {
            Domain d = (Domain) iter.next();
            if (!d.visited) {
                callStack.clear();
                processDomain(d);           
            }
        }
        
        System.out.println("Domains to process: "+orderedDomains.size());
        // Finish up -- create script and database.
        PrintWriter writer = new PrintWriter(new FileOutputStream(scriptFilePath));
        CodeGenUtil.generateCodeGenHeader(writer,"Generate Database Script Builder",
                "",
                CodeGenUtil.SOURCETYPE_SQL);
        StatementExecuter sqlExec = null;
        JRFConnection conn = null;
        if (!generateScriptOnly) {
            conn = JRFConnectionFactory.create();
            sqlExec = conn.getStatementExecuter();
        }
        else {
            System.out.println("Generating "+scriptFilePath+" only.");
        }

        // Drop all the tables in reverse order.
        int i = orderedDomains.size() - 1;
        while (i >= 0) {
            Domain d = (Domain) orderedDomains.get(i);
            if (d.domain.getTableName().length() > 32)
                LOG.info("WARNING: "+d.domain.getTableName()+" exceeds 32 characters.");
            writer.println("Drop table "+d.domain.getTableName()+scriptCommandSeparator);
            if (!generateScriptOnly)
                d.domain.dropTable(true);
            // TODO -- Put policy name.
            if (d.hasSequence && policy.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL) {
                writer.println("/** External sequence drop  "+d.domain.getTableName()+"*/");
                writer.println("DROP SEQUENCE "+d.sequenceName);
                writer.println(scriptCommandSeparator);
                writer.flush(); 
            }   
            i--;
        }
        iter = orderedDomains.iterator();
        while (iter.hasNext()) {
            Domain d = (Domain) iter.next();
            CreateTableSQLBuilder builder = d.domain.getCreateTableSQLBuilder();
            writer.println("/** Generation for table "+d.domain.getTableName()+". "
                        +d.description+"**/");  
            writer.println(builder.buildSQL(d.domain.getTableName(),d.domain.getColumnSpecs(),
                               null,d.tableStorage,true));
            writer.println(scriptCommandSeparator);
            writer.flush(); 
            if (d.hasSequence && policy.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL) {
                writer.println("/** External sequence generation for "+d.domain.getTableName()+"*/");
                writer.println(d.domain.getDatabasePolicy().getCreateSequenceSQL(d.sequenceName,
                            d.sequenceStorage));
                writer.println(scriptCommandSeparator);
                writer.flush(); 
            }
            // TODO -- pull this from db Policy.
            String tableCommentsSQL = null;
            if (supportComments.booleanValue()) {
                tableCommentsSQL = getCreateCommentsTableSQL(d.domain.getTableName(),d.description);
                writer.println(tableCommentsSQL);
                writer.println(scriptCommandSeparator);
            }
            if (!generateScriptOnly) {
                LOG.debug("Creating table "+d.domain.getTableName());
                d.domain.createTable(null,d.tableStorage,d.sequenceStorage);
                if (supportComments.booleanValue()) {
                    sqlExec.executeUpdate(tableCommentsSQL);
                }
            }
            if (supportComments.booleanValue()) {
                Iterator colIter = d.columnNames.keySet().iterator();
                while (colIter.hasNext()) {
                    String colName = (String) colIter.next();
                    String colComments = (String) d.columnNames.get(colName);
                    if (colComments == null || colComments.length() == 0) {
                        LOG.warn("No description specified for "+d.domain.getTableName()+"."+
                        colName+". This suggests an out-of-date XML file!");
                    }
                    else {
                        // TODO -- pull this from db Policy.
                        String columnCommentsSQL = getCreateCommentsColumnSQL(d.domain.getTableName(),
                                colName,colComments);
                        writer.println(columnCommentsSQL);
                        writer.println(scriptCommandSeparator);
                        if (!generateScriptOnly) {
                            LOG.debug("executing ["+columnCommentsSQL+"]");
                            sqlExec.executeUpdate(columnCommentsSQL);
                        }
                    }
                }
            }
            masterForeignKeyList.addAll(d.foreignKeys);
            Iterator indexIterator = d.indexes.iterator();
            writer.println("/** Indexes for "+d.domain.getTableName()+"*/");
            while (indexIterator.hasNext()) {
                String index = (String) indexIterator.next();
                writer.println(index);
                writer.println(scriptCommandSeparator);
                writer.flush(); 
                if (!generateScriptOnly) {
                    LOG.debug("Executing ["+index+"]");
                    sqlExec.executeUpdate(index);
                    logWarnings(sqlExec,index);
                    conn.commit();
                }
            }
        }
        iter = masterForeignKeyList.iterator();
        while (iter.hasNext()) {
            ForeignKey k = (ForeignKey) iter.next();
            String stmt = policy.getForeignKeySQLStatement(k);
            writer.println(stmt);
            writer.println(scriptCommandSeparator);
            writer.flush(); 
            if (!generateScriptOnly) {
                LOG.debug("Executing ["+stmt+"]");
                sqlExec.executeUpdate(stmt);
                logWarnings(sqlExec,stmt);
                conn.commit();
            }
        }
        writer.close();
    }

    // TODO -- These are temporary methods to be moved to DatabasePolicy.
    private String getCreateCommentsTableSQL(String tableName, String comments) {
        return "COMMENT ON TABLE "+tableName+" IS '"+comments+"'";

    }
    private String getCreateCommentsColumnSQL(String tableName,String columnName, String comments) {
        return "COMMENT ON COLUMN "+tableName+"."+columnName+" IS '"+comments+"'";
    }


    private void logWarnings(StatementExecuter sqlExec, String stmt) {
        SQLWarning w = sqlExec.getStaticSqlWarnings();
        if (w != null) {
            StringBuffer b = new StringBuffer();
            b.append(w.getMessage());
            LOG.warn(b.toString(),w);
        }
    }

    // Recursive method that employs depth-first tree search in order to build
    // a list of domains that may be executed in order without generating a
    // "table not found" database error for foreign keys declarations.
    private void processDomain(Domain d) {
        Iterator iter = d.foreignKeys.iterator();
        LOG.debug("processDomain("+d.domain.getTableName()+")");
        callStack.push(d.domain.getTableName());
        while (iter.hasNext()) {
            ForeignKey f = (ForeignKey) iter.next();
            // Check for dup constraint names.
            ForeignKey find = (ForeignKey) masterForeignKeyMap.get(f.getConstraintName());
            if (find != null && !find.equals(f)) {
                throw new IllegalArgumentException(f+" contains the same constraint name as "+
                        "\n"+find);
            }
            masterForeignKeyMap.put(f.getConstraintName(),f);
            Domain fd = (Domain) domains.get(f.getReferencedTableName());
            if (fd == null)
                throw new IllegalArgumentException(d+" claims to be a foreign key of "+
                        "table "+f.getReferencedTableName()+" which does not exist. "+
                        "Foreign key info: "+f);
            // Validate the foreign key stuff.
            String validateContext =
                "Foreign Key constraint "+f.getConstraintName()+" for table "+d.domain.getTableName();
            validateColumns(validateContext,fd,f.getReferencedTableColumns());
            validateColumns(validateContext,d,f.getLocalTableColumns());
            LOG.debug("processDomain("+d.domain.getTableName()+"): "+f.toString());
            if (callStack.search(fd.domain.getTableName()) != -1) {
                // Ignore this reference; already on the stack. - will generate an infinite loop.
                LOG.info("Cyclical reference detected on "+fd.domain.getTableName()+
                        ".  Most database will allow this.");
                continue;   //
            }
            if (!fd.visited) {
                processDomain(fd);
            }
        }
        callStack.pop();    // pop?
        if (LOG.isDebugEnabled())
            LOG.debug("Adding to execute list. Table: "+d.domain.getTableName());
        d.visited = true;
        orderedDomains.add(d);
    }
                        
    private void readStorageXML(String storageXML)
            throws IOException, SecurityException, IntrospectionException,
                        SAXException, ParserConfigurationException {
        XMLReadHandler rx = new XMLReadHandler();
        Document doc = rx.getDocument(storageXML);
        Element root = doc.getDocumentElement();
        HashMap loader;
        for (Node mainChild = root.getFirstChild(); mainChild != null; mainChild = mainChild.getNextSibling()) {
            loader = null;
            if (mainChild instanceof Element) {
                Element object = (Element) mainChild;
                if (object.getTagName().equals("Sequence")) {
                    loader = sequences;
                }
                else if (object.getTagName().equals("Index")) {
                    loader = indexes;
                }   
                else if (object.getTagName().equals("Table")) {
                    loader = tableStorageParameters;
                }
                else {
                    LOG.info("Unknown parameter in "+storageXML+": "+object.getTagName()+
                            " was ignored.");
                }
            }
            if (loader != null) {
                for (Node detailChild = root.getFirstChild(); detailChild != null;
                        detailChild = detailChild.getNextSibling()) {
                    if (detailChild instanceof Element) {
                        Element object = (Element) detailChild;
                        loader.put(object.getAttribute("key"),object.getAttribute("value"));
                    }
                }   
            }
        }
    }
                        
    private void readSchemaXML(List schemaXML)
            throws IOException, SecurityException, IntrospectionException,
                        SAXException, ParserConfigurationException {
        Element roots [] = Generator.parseXML(schemaXML);
        for (int i = 0; i < roots.length; i++)
            readSchema(roots[i]);
    }

    private void readSchema(Element root)
            throws IOException, SecurityException, IntrospectionException,
                        SAXException, ParserConfigurationException {
        String util;
        for (Node mainChild = root.getFirstChild(); mainChild != null; mainChild = mainChild.getNextSibling()) {
            if (mainChild instanceof Element) {
                Element object = (Element) mainChild;
                if (object.getTagName().equals("Table")) {
                    if (!Generator.generateEntity(this.modulesToGenerate,
                         Generator.parseTokenList(object.getAttribute("moduleList")))  )
                        continue;
                    String tableName = object.getAttribute("tableName");
                    //System.out.println("Processing "+tableName);
                    if (tableName.length() == 0)
                        throw new IllegalArgumentException("Bad XML: tableName token does not exist.");
                    String objName = object.getAttribute("objectName");
                    if (objName.length() == 0) {
                        if (initCapNameOnly)
                            objName = initCap(tableName);
                        else
                            objName = JRFGeneratorUtil.databaseNameToFieldName(tableName);
                    }
                    Domain d = new Domain(objName,tableName);
                    util = object.getAttribute("storageParameterKey");
                    if (util.length() == 0) {
                        util = defaultTableStorageKey;
                    }
                    if (util == null) {
                        throw new IllegalArgumentException(
                            "Table storage key for table  "+tableName+
                            " not set and there is no default setting to use.");
                    }       
                    d.tableStorage = (String) tableStorageParameters.get(util);
                    if (d.tableStorage == null) {
                        throw new IllegalArgumentException("Table storage parameter "+
                                util+" specified for table "+tableName+" does not"+
                                " exist in storage XML file.");
                    }
                    // Replace {0} in table storage with actual table name
                    d.tableStorage = MessageFormat.format(d.tableStorage,
                                new Object[] {tableName});
                    util = object.getAttribute("description");
                    if (util.length() == 0)
                        d.description = "";
                    else
                        d.description = util;
                    processTableColumnAndIndexes(object,d,tableName);
                    domains.put(tableName,d);
                }
            }
        }
    }

    private void processTableColumnAndIndexes(Element tableElement, Domain d,String tableName)
    {
        String util;
        HashMap foreignColumns = new HashMap();
        HashMap tableIndexes = new HashMap();
        int indexCount = 0;
        for (Node child = tableElement.getFirstChild(); child != null; child = child.getNextSibling()) {
            if (child instanceof Element) {
                Element object = (Element) child;
                if (object.getTagName().equals("Column")) {
                    // Need to check for three things:
                    // 1. Sequences.
                    // 2. Foreign key info.
                    // 3. Add comments to domain.columnNames.
                    d.columnNames.put(object.getAttribute("name"),object.getAttribute("description"));
                    util = object.getAttribute("isSeq");
                    if (util.equals("true") && policy.getSequenceSupportType() ==
                            DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL) {
                        d.hasSequence = true;
                        d.sequenceName = object.getAttribute("seqName");
                        if (d.sequenceName.length() == 0) {
                            throw new IllegalArgumentException("Table "+tableName+
                                ", column "+object.getAttribute("name")+" specifies a "+
                                "sequence with a database that requires a create sequence statement. "+
                                "No sequence name is specified.");

                        }   
                        // Look for sequence storage:
                        util = object.getAttribute("sequenceStorageKey");
                        if (util.length() == 0 ) {
                            util = defaultSequenceStorageKey;
                        }
                        if (util == null) {
                            throw new IllegalArgumentException(
                                "Storage key for sequence "+d.sequenceName+
                                " not set and there is no default setting to use.");
                        }
                        d.sequenceStorage = (String) sequences.get(util);
                        if (d.sequenceStorage.length() == 0)
                            throw new IllegalArgumentException(
                                    "Storage key for sequence "+
                                    util+" specified in column "+
                                    object.getAttribute("name")+" for "+
                                    "table "+tableName+
                                    "does not exist in storage xml listing.");
                        LOG.debug("Seq data is "+d.sequenceStorage);
                    }
                    ForeignKey f = createFKFromImport(d.foreignKeys.size(),object,additionalForeignKeyInfo,
                                d.domain.getTableName());
                    if (f != null) {
                        d.foreignKeys.add(f);
                    }
                }
                else if (object.getTagName().equals("Index")) {
                    String indexName = object.getAttribute("name");
                    boolean unique = object.getAttribute("unique").equals("true");
                    indexCount++;
                    if (indexName.length() == 0) {
                        indexName = tableName+"_idx"+indexCount;
                    }
                    String storageKey = object.getAttribute("indexStorageKey");
                    if (storageKey.length() == 0) {
                        storageKey = unique ? defaultUniqueIndexStorageKey:defaultNonUniqueIndexStorageKey;
                        if (storageKey == null)
                           throw new IllegalArgumentException(
                                "For table "+tableName+": "+
                                "required storage key 'indexStorageKey' has no value for index "
                                +indexName+" and no "+(unique ? "unique":"non-unique")+
                                " default has been specified.");
                    }
                    IndexTemp indexInfo = new IndexTemp(storageKey);
                    for (Node indexChild = object.getFirstChild(); indexChild != null;
                                indexChild = indexChild.getNextSibling()) {
                        if (indexChild instanceof Element) {
                            Element idxCol = (Element) indexChild;
                            if (idxCol.getTagName().equals("IndexColumn")) {
                                String columnName = idxCol.getAttribute("name");
                                validateColumns("Index",d,columnName);
                                indexInfo.cols.addElement(new IndexTempCol(columnName,
                                    java.lang.Integer.parseInt(idxCol.getAttribute("position"))));
                            }
                        }
                    }
                    tableIndexes.put(indexName,indexInfo);
                }
                else if (object.getTagName().equals("ForeignKeyConstraint")) {
                    d.foreignKeys.add(createFKFromConstraint(object,additionalForeignKeyInfo,
                        d.domain.getTableName()));
                }
            }
        }
        Iterator iter;
        // Resolve all indexes
        iter = tableIndexes.keySet().iterator();
        while (iter.hasNext()) {
            String indexName = (String) iter.next();
            IndexTemp indexInfo = (IndexTemp) tableIndexes.get(indexName);
            String storage;
            if (indexInfo.cols.size() == 0)
                throw new IllegalArgumentException("For table "+tableName+": "+
                                    "index "+indexName+" has no columns specified.");
            if ((storage = (String) indexes.get(indexInfo.storageKey)) == null)
                        throw new IllegalArgumentException("For table "+tableName+
                                    "index storage key "+indexInfo.storageKey+
                            " does not exist in storage xml for index "+indexName);
            IndexTempCol [] result = (IndexTempCol []) indexInfo.cols.toArray(new IndexTempCol[indexInfo.cols.size()]);
            Arrays.sort(result);
            StringBuffer colNames = new StringBuffer();
            for (int i = 0; i < result.length; i++) {
                if (i > 0)
                    colNames.append(",");
                colNames.append(result[i].columnName);
            }
            // Now run, the message formatter on the data {0} = index name,{1} = table name; {2} = column list.
            String idxStmt = MessageFormat.format(storage, new Object [] {indexName,tableName,colNames});
            LOG.debug("For "+tableName+","+indexName+","+colNames+": Added "+idxStmt);
            d.indexes.add(idxStmt);
        }
        // Resolve all foreign keys.
    }

    public static ForeignKey createFKFromImport(int num, Element object,String additionalForeignKeyInfo,
            String tableName) {
            String util = object.getAttribute("importedFromTable");
            if (util.length() > 0) {
                String forColumn = object.getAttribute("importedFromColumn");
                String localColumn = object.getAttribute("name");
                return createFKFromImport(num,additionalForeignKeyInfo,util,tableName,forColumn,localColumn);
            }
            return null;
    }   

    public static ForeignKey createFKFromImport(int num, String additionalForeignKeyInfo,
            String importedFromTable, String tableName,String forColumn,String localColumn) {
            if (forColumn.length() == 0)
                    forColumn = localColumn;
            return new ForeignKey(createFKConstraintName(tableName,num),
                tableName,importedFromTable,localColumn,forColumn,additionalForeignKeyInfo);
    }

    /** Creates a foreign key constraint name for a single column reference,
     * assuring that that name will not exceed thirty-two
     * characters (a limitation on many databases).
     * @param tableName name of the table.
     * @param num number of key (e.g. first, second, etc).
     * @return a foriegn key constraint name.
     */
    public static String createFKConstraintName(String tableName, int num) {
        String postFix = "_FK"+num;
        if (tableName.length() + postFix.length() <= 32) {
            return tableName + postFix;
        }
        String tab = abbreviateName(tableName);
        int len = tab.length() + postFix.length();
        // trim back  table name until we get to 32.
        while (len > 32) {
            tab = tab.substring(0,tab.length() - 2);
            len--;
        }                   
        return tab + postFix;
    }

    private static String vowels = "aeiou";

    private static String abbreviateName(String name) {
        StringBuffer result = new StringBuffer();
        result.append(name.charAt(0));
        int i = 1;
        while (i < name.length()) {
            char c = name.charAt(i++);
            if (vowels.indexOf(c) == -1) {
                result.append(c);
            }                           
        }   
        return result.toString();
    }

    public static ForeignKey createFKFromConstraint(Element object,String additionalForeignKeyInfo,
                    String tableName) { 
        return new ForeignKey(
                        object.getAttribute("constraintName"),
                        tableName,
                        object.getAttribute("foreignTable"),
                        object.getAttribute("localColumns"),
                        object.getAttribute("foreignColumns"),additionalForeignKeyInfo);
    }
    
    private void validateColumns(String context, Domain d, String columnName) {
        validateColumns(context,d, (List) parseToList(columnName,new ArrayList()) );
    }

    private Collection parseToList(String columns,Collection list) {
        StringTokenizer t = new StringTokenizer(columns,",");
        while (t.hasMoreTokens()) {
            list.add(t.nextToken());
        }
        return list;
    }

        
    private void validateColumns(String context, Domain d, List columnNames) {
        Iterator iter = columnNames.iterator();
        while (iter.hasNext()) {
            String colName = (String) iter.next();
            if (!d.columnNames.containsKey(colName)) {
                throw new IllegalArgumentException("For "+context+": "+
                "there is no such column name ["+colName+"] in table "+d.domain.getTableName()+". \nColumn names are "
                +d.showColumnNames());  
            }
        }   
    }

    public void setPackageNames(String names) {
        StringTokenizer tok = new StringTokenizer(names,",");
        while (tok.hasMoreTokens()) {
            packageNames.add(tok.nextToken());
        }
    }

    public void setScriptCommandSeparator(String scriptCommandSeparator) {
        this.scriptCommandSeparator = scriptCommandSeparator;
    }

    public void setScriptFilePath(String scriptFilePath) {
        this.scriptFilePath = scriptFilePath;
    }

    public void setDefaultUniqueIndexStorageKey(String defaultUniqueIndexStorageKey) {
        this.defaultUniqueIndexStorageKey = defaultUniqueIndexStorageKey;
    }

    public void setDefaultNonUniqueIndexStorageKey(String defaultNonUniqueIndexStorageKey) {
        this.defaultNonUniqueIndexStorageKey = defaultNonUniqueIndexStorageKey;
    }
    public void setInitCapObjectNameOnly(boolean initCapNameOnly) {
        this.initCapNameOnly = initCapNameOnly;
    }

    /** Sets list of modules to use.
    * @param tokenList of modules for entity generation.
    */
    public void setModulesToGenerate(String tokenList) {
        modulesToGenerate = Generator.parseTokenList(tokenList);
    }

    public void setDefaultSequenceStorageKey(String defaultSequenceStorageKey) {
        this.defaultSequenceStorageKey = defaultSequenceStorageKey;
    }

    public void setDefaultTableStorageKey(String defaultTableStorageKey) {
        this.defaultTableStorageKey = defaultTableStorageKey;
    }

    private String initCap(String name) {
        return java.lang.Character.toUpperCase(name.charAt(0)) + name.substring(1);
    }
    public void setAdditionalForeignKeyInfo(String additionalForeignKeyInfo) {
        this.additionalForeignKeyInfo = additionalForeignKeyInfo;
    }


    /** Sets list of xml files to use.  This is only useful if multiple
    * xml files are required.  If only one file is to be used, specify it
    * on the command line.
    * @param tokenList list of xmlFiles.
    */
    public void setXMLFiles(String tokenList) {
        xmlFileList = Generator.parseTokenList(tokenList);
    }

    /** Sets whether comments are supported.
    * @param supportComments
    */
    public void setSupportComments(Boolean supportComments) {
        this.supportComments = supportComments;
    }

    /** Main processing function.   
         * @param args launch arguments.
     *  <ol>
     *      <li>    Full path of properties file..
     *  <li>    GenerateScriptOnly ("true/false")
     *  <li>    Full path of database storage XML.
     *      <li>    Full path of database schema XMLs.
     *  </ol>
     **/
    public static void main(String args[]) {
        if (args.length < 3) {
            System.out.println(
        "Usage: org.vmguys.appgen.GenerateDatabase propertiesFile generateScriptOnly storageXML [schemaXML]");
            System.exit(1);
        }
        try {
            Boolean b = new Boolean(args[1]);   // generateScriptOnly
            ArrayList a = new ArrayList();
            if (args.length > 3)
                a.add(args[3]);
            GenerateDatabase gd = new GenerateDatabase(args[0],a,args[2],b.booleanValue()); 
        }
        catch (Exception ex) {
            LOG.fatal("Fatal error generating database.",ex);
            System.err.println("Execution failed. See logs.");
        }
    }

}
                        
