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
////////////////////////////////////////////////////////////
package org.vmguys.appgen.jrf;
import org.vmguys.appgen.*;
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
import org.apache.log4j.Category;
import net.sf.jrf.column.*;
import net.sf.jrf.column.columnspecs.*;
import java.text.*;

/** Code generator for generating base <code>PersistentObject</code>s
* and <code>AbstractDomain</code>s that map field-to-field with the database.
*/
public class BaseGenerator extends Generator {

    static Category LOG = Category.getInstance(BaseGenerator.class.getName());
    static {
        // Set so Main can correctly run.
        generatorClassName = BaseGenerator.class.getName();
    }
    
    /** Output directory for generated <code>PersistentObject</code>. **/
    protected String sourceOutputDbObj;
    
    /** Output directory for generated <code>AbstractDomain</code>. **/
    protected String sourceOutputDomain;

    /** Package name of <code>AbstractDomain</code>. **/
    protected String packageNameDomain;

    /** Package name of <code>PersistentObject</code>. **/
    protected String packageNameDbObj;

    /** Generate init cap names only flag. */
    protected Boolean initCapNameOnly;

    private static final String POKEY_IMPORTLIST = "importList";
    private static final String POKEY_ACCESSORS = "accessors";
    private static final String POKEY_DECLARATIONS = "declarations";
    private static final String POKEY_ADDITIONAL = "additional";
    private static final String POKEY_TOSTRING = "tostring";
    private static final String POKEY_ENCODED = "encoded";
    
    private SourceBuffer poBuffer;
    static private final String persistentObjectTemplate =
        "package $packageNameDbObj$;"+
        "\n"+
        "$"+POKEY_IMPORTLIST+"$\n"+
        "import net.sf.jrf.domain.PersistentObject;\n"+
        "\n"+
        "/** \n"+
        "* $description$\n"+
        "*/\n"+
        "public class $classNameObj$ extends PersistentObject $interfaces$ {\n"+
        "$"+POKEY_DECLARATIONS+"$\n"+
        "   /** Default constructor **/\n"+
        "   public $classNameObj$() {\n"+
        "   }\n"+
        "\n"+
        "$"+POKEY_ACCESSORS+"$\n"+
        "   /** Returns a list of field values. *\n"+
        "    * @return list of field values.\n"+
        "    */\n"+
        "   public String toString(){\n"+
        "       return \"\\n\"+super.toString()+\"\\n\"+\n"+
        "        \"Persistent State: \"+this.getPersistentState()+\"\\n\"+\n"+
        "$"+POKEY_TOSTRING+"$\"\";\n"+
        "   }\n"+
        "   /** Returns a value that represents the  \n"+
        "    * encoded primary key value for this object. This value may then be used to\n"+
        "    * search for the object. \n"+
        "    * @return encoded key value.\n"+
        "    */\n"+
        "   public String getEncodedKey() {\n"+
        "       return \n"+
        "$"+POKEY_ENCODED+"$\n"+
        "       ;\n"+
        "   }\n\n"+ 
        "$"+POKEY_ADDITIONAL+"$\n"+
        "}\n";

    private void initPersistentObjectBuffer() {
        poBuffer = new SourceBuffer(persistentObjectTemplate);
        poBuffer.setOutputDirectory(this.sourceOutputDbObj);
        poBuffer.addPermanentKeyAndValue("packageNameDbObj",this.packageNameDbObj);
        poBuffer.addAppendableKey(POKEY_DECLARATIONS);
        poBuffer.addAppendableKey(POKEY_IMPORTLIST);
        poBuffer.addAppendableKey(POKEY_ACCESSORS);
        poBuffer.addAppendableKey(POKEY_ADDITIONAL);
        poBuffer.addAppendableKey(POKEY_TOSTRING);
        poBuffer.addAppendableKey(POKEY_ENCODED);
    }

    private SourceBuffer domainBuffer;

    static private final String DOMKEY_COLUMNSPECS = "columnSpecs";
    static private final String DOMKEY_GETTERSETTERS = "getterSetters";
    static private final String DOMKEY_ADDITIONAL = "additional";
    static private final String DOMKEY_SETUPADDITIONAL = "setupadditional";
    private static final String DOMKEY_IMPORTLIST = "importList";

    private void initDomainBuffer() {
        domainBuffer = new SourceBuffer(domainTemplate);
        domainBuffer.setOutputDirectory(this.sourceOutputDomain);
        domainBuffer.addPermanentKeyAndValue("packageNameDomain",this.packageNameDomain);
        domainBuffer.addPermanentKeyAndValue("packageNameDbObj",this.packageNameDbObj);
        domainBuffer.addAppendableKey(DOMKEY_COLUMNSPECS);
        domainBuffer.addAppendableKey(DOMKEY_GETTERSETTERS);
        domainBuffer.addAppendableKey(DOMKEY_ADDITIONAL);
        domainBuffer.addAppendableKey(DOMKEY_SETUPADDITIONAL);
        domainBuffer.addAppendableKey(DOMKEY_IMPORTLIST);
    }

    private static final String domainTemplate =
        "package $packageNameDomain$;\n"+
        "import $packageNameDbObj$.$classNameObj$;"+
        "\n"+
        "$"+DOMKEY_IMPORTLIST+"$\n"+
        "import java.util.*;\n"+
        "import java.io.Serializable;\n"+
        "import net.sf.jrf.domain.*;\n"+
        "import net.sf.jrf.column.ColumnSpec;\n"+
        "import net.sf.jrf.column.GetterSetter;\n"+
        "import net.sf.jrf.column.columnoptions.*;\n"+
        "import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;\n"+
        "\n"+
        "/** Abstract Domain extension for $tableName$ \n"+
        " * $description$\n"+
        "*/\n"+
        "public class $classNameDomain$ extends $domainExtension$ $domainInterfaces$ {\n"+
        "\n"+
        "   \n"+
        "   public $classNameDomain$() {\n"+
        "       super();\n"+
        "   }\n"+
        "\n"+
        "   public $classNameDomain$(Properties properties) {\n"+
        "       super(properties);\n"+
        "   }\n"+
        "\n"+
        "   public PersistentObject newPersistentObject() {\n"+
        "       return new $packageNameDbObj$.$classNameObj$();\n"+
        "   }\n"+
        "   \n"+
        "   protected void setup() {\n"+
        "       this.setTableName(\"$tableName$\");\n"+
        "       PersistentObjectCache.setCacheAll(this.getClass(),$cacheAll$);\n"+
        "       PersistentObjectCache.setMaxCacheSize(this.getClass(),$lruCacheSize$);\n"+
        "$sequence$\n"+
        "$"+DOMKEY_COLUMNSPECS+"$\n"+
        "$"+DOMKEY_SETUPADDITIONAL+"$\n"+
        "   }\n"+
        "$"+DOMKEY_GETTERSETTERS+"$\n"+
        "$"+DOMKEY_ADDITIONAL+"$\n"+
        "}\n";

    // {0] = table name {1} = primary key {2} = synthetic/natural {3} = description {4} = foreign keys
    static public final String descriptionTemplate =
        "<p>\n"+
        "This object represents an exact one-to-one mapping to the database table <em><code>{0}</code></em>.\n"+
        "<p>\n"+
        "<table border=4>\n"+
        "<thead>\n"+
        "<tr align='left' bgcolor='gold'>\n"+
        "<th>Primary Key</th><th>Primary Key</br>type</th><th>Description</th><th>Foreign Keys</th>\n"+
        "</tr>\n"+
        "</thead>\n"+
        "<tbody>\n"+
        "<tr align='left'>\n"+  
        "<th>{1}</th>\n"+
        "<th>{2}</th>\n"+
        "<th>{3}</th>\n"+
        "<th>{4}</th>\n"+
        "</tr>\n"+
        "<tbody>\n"+
            "</table>\n"+
        "<p>\n";
        
    static public final String colorKeyTemplate =   
    "<p>\n"+
    "<strong>Method Description Color Key</strong><p>\n"+
    "<ul>\n"+
    "<li>Bean methods of primary key fields are displayed in <font color={0}><strong>{0}</strong></font>\n"+
    "<li>Methods that map to any interface are displayed in <font color={1}><strong>{1}</strong></font>\n"+
    "<li>Methods that to do NOT map to any interface are displayed in <font color={2}><strong>{2}</strong></font>\n"+
    "</ul>\n";

        

    private String tableXMLMetaEntityClassName;
    private String columnXMLMetaEntityClassName;
    // Method description colors
    private String primaryKeyColor;
    private String nonInterfaceColor;
    private String interfaceColor;

    private String interfaceBase;


    private List getTableList(Element root)
                        throws SAXException,IntrospectionException,
                        java.lang.reflect.InvocationTargetException,ParseException,
                        java.lang.IllegalAccessException,NoSuchMethodException {
        SourceGenXMLEntityMetaData tableMeta = new SourceGenXMLEntityMetaData(
                            tableXMLMetaEntityClassName,
                            "Table");
        SourceGenXMLEntityMetaData columnMeta = new SourceGenXMLEntityMetaData(
                            columnXMLMetaEntityClassName,
                            "Column");
        SourceGenXMLEntityMetaData lovMeta = new SourceGenXMLEntityMetaData(
                            "org.vmguys.appgen.jrf.ListOfValuesXMLEntity",
                            "ListOfValues");
        SourceGenXMLEntityMetaData foreignKeyMeta = new SourceGenXMLEntityMetaData(
                            "org.vmguys.appgen.jrf.ForeignKeyXMLEntity",
                            "ForeignKeyConstraint");
        columnMeta.addChild(lovMeta);
        tableMeta.addChild(columnMeta);
        tableMeta.addChild(foreignKeyMeta);
        List tableList = null;
        return SourceGenXMLEntityMetaData.createEntityTreeFromXML(root,tableMeta);
    }

    private List getInterfaceColumns(Element root)
                        throws SAXException,IntrospectionException,
                        java.lang.reflect.InvocationTargetException,ParseException,
                        java.lang.IllegalAccessException,NoSuchMethodException {
        // Now fetch a list of all interface columns.
        SourceGenXMLEntityMetaData interfaceMeta = new SourceGenXMLEntityMetaData(
                                "org.vmguys.appgen.jrf.InterfaceColumnsXMLEntity",
                                "InterfaceColumns");
        
        SourceGenXMLEntityMetaData columnMeta = new SourceGenXMLEntityMetaData(
                            columnXMLMetaEntityClassName,
                            "Column");
        interfaceMeta.addChild(columnMeta);
        return SourceGenXMLEntityMetaData.createEntityTreeFromXML(root,interfaceMeta);
    }

    private List tableList = null;
    
    /** Initializes XML document and reads the properites file, calling all set methods
     * specified in the file.
     * @param prop properties file path
     * @param xml xml file paths
     */
    public BaseGenerator(String prop,ArrayList xml)
        throws IOException, SecurityException, CodeGenException,FileNotFoundException,
                        SAXException, ParserConfigurationException, IntrospectionException,
                        java.lang.reflect.InvocationTargetException,ParseException,
                        java.lang.IllegalAccessException,NoSuchMethodException {
        super(prop,xml);
        checkParameters(prop);
        initPersistentObjectBuffer();
        initDomainBuffer();
        init(); // Init any sub-class stuff.
        ColumnXMLEntity.defaultPKColor = primaryKeyColor;   
        ColumnXMLEntity.defaultColor = nonInterfaceColor;   
        //////////////////////////////////////////////////////////////////////////////////
        // Combine all XML files (some resusable for multiple application projects) into single lists.
        //////////////////////////////////////////////////////////////////////////////////
        tableList = getTableList(super.roots[0]);
        List interfaceColumns = getInterfaceColumns(super.roots[0]);
        for (int j = 1; j < super.roots.length; j++) {
            tableList.addAll( getTableList(super.roots[j]) );
            interfaceColumns.addAll( getInterfaceColumns(super.roots[j]) );
        }
        String colorMethodKey = MessageFormat.format(colorKeyTemplate,
                new String [] {primaryKeyColor,interfaceColor,nonInterfaceColor});

        Iterator interfaceIter = interfaceColumns.iterator();
        while (interfaceIter.hasNext())  {
            InterfaceColumnsXMLEntity i = (InterfaceColumnsXMLEntity) interfaceIter.next();
            Iterator icols = i.getColumns().iterator();
            while (icols.hasNext()) {
                ColumnXMLEntity c = (ColumnXMLEntity) icols.next();
                c.setDescriptionColor(interfaceColor);
            }       
        }   
        Iterator tableIter = tableList.iterator();
        // For each table.
        ArrayList primaryKeys = new ArrayList();
        ArrayList nonPrimaryKeys = new ArrayList();
        HashSet importsPO = new HashSet();
        HashSet importsDomain = new HashSet();
        StringBuffer compoundKey = new StringBuffer();
        String [] tableInfoParams = new String[5];
        StringBuffer pkDesc = new StringBuffer();
        while (tableIter.hasNext()) {
            TableXMLEntity table = (TableXMLEntity) tableIter.next();
            if (table.skipGenerate || !generateEntity(table.getModuleList()) )
                continue;
            // Add in all interface columns.
            importsPO.clear();
            importsDomain.clear();
            primaryKeys.clear();
            nonPrimaryKeys.clear();
            poBuffer.reset();
            domainBuffer.reset();
            compoundKey.setLength(0);
            pkDesc.setLength(0);
            initTableAdditional(table);     
            tableInfoParams[0] = table.getTableName();
            tableInfoParams[3] = table.getDescription();
            poBuffer.setTransientKeys(table.getTransientKeys());        
            domainBuffer.setTransientKeys(table.getTransientKeys());
            addInterfaceColumns(interfaceColumns,table);
            Iterator columnIter = table.getColumn().iterator();
            String classNameObj = (String) table.getTransientKeys().get(CompositeObjectXMLEntity.CLASSNAME_OBJ);
            domainBuffer.addTransientKeyAndValue("sequence","");    

            while (columnIter.hasNext()) {
                ColumnXMLEntity column = (ColumnXMLEntity) columnIter.next();
                String seqName = column.getSequenceName();
                if (seqName != null) {
                    domainBuffer.addTransientKeyAndValue("sequence",    
                            "       setSequenceName(\""+seqName+"\");\n");
                }
                // Take care of the imports.
                String importItem;
                importItem = CodeGenUtil.getActualClassName(column.getColumnClassName());
                if (CodeGenUtil.getPrimitiveClass(importItem,false) == null) {
                    if (!importsPO.contains(importItem)) {  
                        importsPO.add(importItem);
                        poBuffer.append(POKEY_IMPORTLIST,"import "+importItem+";\n");
                    }
                }
                importItem = column.getColumnImplClassName();
                if (!importsDomain.contains(importItem)) {  
                    importsDomain.add(importItem);
                    domainBuffer.append(DOMKEY_IMPORTLIST,"import "+importItem+";\n");
                }
                if (column.isPrimaryKey()) {
                    primaryKeys.add(column);
                    pkDesc.append(column.getTransientKeys().get("name")+"</br>");
                }
                else {
                    nonPrimaryKeys.add(column);
                }
                poBuffer.append(POKEY_TOSTRING,column.getToStringInfo());
                String setterAdditional = processColumnAdditional(table,column);
                poBuffer.append(POKEY_DECLARATIONS,column.getFieldDeclaration());
                column.appendGetterSetter(poBuffer.getAppendableBuffer(POKEY_ACCESSORS),
                        setterAdditional);
                domainBuffer.append(DOMKEY_GETTERSETTERS,
                    column.getGetterSetterImpl(classNameObj));  
            }
            // Handle the column spec setting..
            if (primaryKeys.size() == 0) {
                throw new IllegalArgumentException("table "+table.getTableName()+" has no primary key.");
            }
            if (primaryKeys.size() == 1) {
                ColumnXMLEntity column = (ColumnXMLEntity) primaryKeys.get(0);
                domainBuffer.append(DOMKEY_COLUMNSPECS,column.getColumnSpecDeclare("this",false));
                tableInfoParams[2] = column.sequence ? "Synthetic (sequence)":"Natural";
            }
            else {
                tableInfoParams[2] = "Natural";
                compoundKey.append("    CompoundPrimaryKeyColumnSpec    cpk = new CompoundPrimaryKeyColumnSpec();\n");
                Iterator specIter = primaryKeys.iterator();
                while (specIter.hasNext()) {
                    ColumnXMLEntity column = (ColumnXMLEntity) specIter.next();
                    compoundKey.append(column.getColumnSpecDeclare("cpk",true));    
                }
                compoundKey.append("    this.addColumnSpec(cpk);\n");
                domainBuffer.append(DOMKEY_COLUMNSPECS,compoundKey.toString());
            }
            handleEncodedKeyImplementation(primaryKeys);    
            Iterator specIter = nonPrimaryKeys.iterator();
            while (specIter.hasNext()) {
                ColumnXMLEntity column = (ColumnXMLEntity) specIter.next();
                domainBuffer.append(DOMKEY_COLUMNSPECS,column.getColumnSpecDeclare("this",false));
            }
            tableInfoParams[1] = pkDesc.toString();
            tableInfoParams[4] = table.getForeignKeyDescriptions();
            table.setDescription(MessageFormat.format(descriptionTemplate,tableInfoParams)+colorMethodKey);
            // Let any sub-classes write what they want.
            completeTableAdditional(table);     
            // Generate the files.
            poBuffer.flushToFile(classNameObj);
            domainBuffer.flushToFile( (String) table.getTransientKeys().get(TableXMLEntity.CLASSNAME_DOMAIN) );
        } // End for each table.
        close();
    }

    /** Handles the implementation of the method <code>PersistentObject.getEncodedKey()</code>.
     * Sub-classes should not normally override unless non-standard (e.g. not in base package)
     * column specifications are used.
     * @param primaryKeys list of primary keys.
     */
    protected void handleEncodedKeyImplementation(List primaryKeys) {
        Iterator specIter = primaryKeys.iterator();
        int i = 0;
        while (specIter.hasNext()) {
            ColumnXMLEntity column = (ColumnXMLEntity) specIter.next();
            if (++i > 1) {
                poBuffer.append(POKEY_ENCODED," +\"|\"+\n");
            }
            String key = column.getEncodedKeyCode();
            if (i > 1 && column.isTextColumn())
                key = "net.sf.jrf.column.TextColumnSpec.encodeCompoundKeyTextObject("+key+")";
            poBuffer.append(POKEY_ENCODED," "+key);
        }

    }
    /** Initializes any sub-classe data.  This version does nothing.
    */
    protected void init() {
    }

    /** Allow user to do anything after all tables have been processed.
    */
    protected void close() {
    }

    /** Allows a sub-class to add additional code for base object <code>PersistentObject</code>.
    * @param code code to append.
    */
    protected void  appendAdditionalPersistentObjectCode(String code) {
        poBuffer.append(POKEY_ADDITIONAL,code);
    }

    /** Adds in interface columns.  If the table implements an interface, columns
     * will be added to the table unless the column name already exists.  Sub-classes may
     * override this method to provide more sophisticated processing.  Method is called <em>after</em>
     * <code>initTableAdditional</code>.
     * @param interfaceColumns <code>List</code> of <code>InterfaceColumnsXMLEntity</code>s.
     * @param table <code>TableXMLEntity</code> entity.
     * @see #initTableAdditional(TableXMLEntity)
     */
    protected void addInterfaceColumns(List interfaceColumns, TableXMLEntity table) {
        Iterator interfaceIter = interfaceColumns.iterator();
        while (interfaceIter.hasNext())  {
            InterfaceColumnsXMLEntity i = (InterfaceColumnsXMLEntity) interfaceIter.next();
            if (table.implementsDbObjInterface(i.getInterfaceName()) ) {
                // Only add what user has not already added manually.
                Iterator icols = i.getColumns().iterator();
                while (icols.hasNext()) {
                    ColumnXMLEntity column = (ColumnXMLEntity) icols.next();
                    if (!table.hasColumn(column))
                        table.getColumn().add(column);
                }
            }       
        }   
    }

    /** Returns <code>TableXMLEntity</code> for table name or <code>null</code> if not found.
     * @param tableName name to search.
     * @return <code>TableXMLEntity</code> for table name or <code>null</code> if not found.
     */
        protected TableXMLEntity findTableEntity(String tableName) {
        Iterator tableIter = tableList.iterator();
        while (tableIter.hasNext()) {
            TableXMLEntity table = (TableXMLEntity) tableIter.next();
            //System.out.println("IT IS "+table);
            if (table.getTableName() != null && table.getTableName().equals(tableName))
                return table;
        }
        return null;
    }

    /** Returns <code>ColumnXMLEntity</code> for column name or <code>null</code> if not found.
     * @param table table entity.
     * @param columnName name to search.
     * @return <code>ColumnXMLEntity</code> for column name or <code>null</code> if not found.
     */
        protected ColumnXMLEntity findColumnEntity(TableXMLEntity table, String columnName) {
        Iterator columnIter = table.getColumn().iterator();
        while (columnIter.hasNext()) {
            ColumnXMLEntity column = (ColumnXMLEntity) columnIter.next();
            if (column.getColumnName().equals(columnName))
                return column;
        }
        return null;
    }

    /** Allows a sub-class to add additional code for <code>AbstractDomain</code> outside of
    * <code>setup()</code>.
    * @param code code to append.
    */
    protected void  appendAdditionalDomainCode(String code) {
        domainBuffer.append(DOMKEY_ADDITIONAL,code);
    }

    /** Allows a sub-class to add additional code for <code>AbstractDomain</code> inside of
    * <code>setup()</code>.
    * @param code code to append.
    */
    protected void  appendAdditionalSetupDomainCode(String code) {
        domainBuffer.append(DOMKEY_SETUPADDITIONAL,code);
    }

    /** Allows a sub-class to add additional imports <code>AbstractDomain</code>.
    * @param importCode import code.
    */
    protected void  appendAdditionalDomainImport(String importCode) {
        domainBuffer.append(DOMKEY_IMPORTLIST,importCode);
    }

    /** Allows a sub-class to add additional imports <code>PersistentObject</code>.
    * @param importCode import code.
    */
    protected void  appendAdditionalPersistentObjectImport(String importCode) {
        poBuffer.append(POKEY_IMPORTLIST,importCode);
    }


    /** Allows a sub-class to process a table entity for generating specific code for
     * <code>appendAdditionalDomainCode()</code> or <code>appendAdditionalPersistentObjectCode()</code>.
     *  Base version does nothing.  This method is called before any column processing has taken place.
     * @param table table entity.
     */
    protected void  initTableAdditional(TableXMLEntity table) throws CodeGenException {
    }

    /** Allows a sub-class to process a table entity for generating specific code for
     * <code>appendAdditionalDomainCode()</code> or <code>appendAdditionalPersistentObjectCode()</code>.
     *  Base version does nothing.  This method is called after all column processing.
     * @param table table entity.
     */
    protected void  completeTableAdditional(TableXMLEntity table) throws CodeGenException,IOException  {
    }

    /** Allows a sub-class to process a column entity for generating specific code for
     * <code>appendAdditionDomainCode()</code>.  Base version does nothing.
     * @param table table entity.
     * @param column column entity.
     * @return returns any code to be added to the setter for this column or <code>null</code> if
     * not applicable.
     */
    protected String processColumnAdditional(TableXMLEntity table, ColumnXMLEntity column) throws
            CodeGenException {
        return null;
    }

    /** Validate args and set defaults.
    */
    private void checkParameters(String prop) {
        if (sourceOutputDbObj == null)
            throw new IllegalArgumentException(prop+" needs to specify SourceOutputDbObj.");
        if (sourceOutputDomain == null)
            throw new IllegalArgumentException(prop+" needs to specify SourceOutputDomain.");
        if (packageNameDomain == null)
            throw new IllegalArgumentException(prop+" needs to specify PackageNameDomain.");
        if (packageNameDbObj == null)
            throw new IllegalArgumentException(prop+" needs to specify PackageNameDbObj.");
        if (initCapNameOnly == null) { // default to true.
            initCapNameOnly = new Boolean(true);
        }
        if (primaryKeyColor == null)
            primaryKeyColor = "red";
        if (nonInterfaceColor == null)
            nonInterfaceColor = "green";
        if (interfaceColor == null)
            interfaceColor = "black";
        // Set up static values in init cap
        TableXMLEntity.initCapNameOnly = initCapNameOnly.booleanValue();
        ColumnXMLEntity.initCapNameOnly = initCapNameOnly.booleanValue();
        TableXMLEntity.interfaceBase = interfaceBase;
        if (tableXMLMetaEntityClassName == null)
            tableXMLMetaEntityClassName = "org.vmguys.appgen.jrf.TableXMLEntity";
        if (columnXMLMetaEntityClassName == null)
            columnXMLMetaEntityClassName = "org.vmguys.appgen.jrf.ColumnXMLEntity";
    }

    /** Sets inteface base package for all unqualified table definition elements.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param interfaceBase interface base package to pre-pend to all unqualified interface
     * specfication elements.
     */
    public void setInterfaceBase(String interfaceBase) {
        this.interfaceBase = interfaceBase;
    }

    /** Sets the sub-class instance of <code>TableXMLEntity</code> to use.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param tableXMLMetaEntityClassName subclass name instance of <code>TableXMLEntity</code>.
     */
    public void setTableXMLEntityClassName(String tableXMLMetaEntityClassName) {
        this.tableXMLMetaEntityClassName = tableXMLMetaEntityClassName;
    }

    /** Sets the sub-class instance of <code>ColumnXMLEntity</code> to use.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param columnXMLMetaEntityClassName subclass name instance of <code>ColumnXMLEntity</code>.
     */
    public void setColumnXMLEntityClassName(String columnXMLMetaEntityClassName) {
        this.columnXMLMetaEntityClassName = columnXMLMetaEntityClassName;
    }

    /** Sets the output directory for the <code>PersistentObject</code>.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param sourceOutputDbObj Output directory name for generated <code>PersistentObject</code>.
     */
    public void setSourceOutputDbObj(String sourceOutputDbObj) {
        this.sourceOutputDbObj = sourceOutputDbObj;
    }

    /** Sets the output directory for the <code>AbstractDomain</code>.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param sourceOutputDomain Output directory name for generated <code>AbstractDomain</code>.
     */
    public void setSourceOutputDomain(String sourceOutputDomain) {
        this.sourceOutputDomain = sourceOutputDomain;
    }

    /** Sets the package name for the <code>AbstractDomain</code>.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param packageNameDomain package name for the generated <code>AbstractDomain</code>.
     */
    public void setPackageNameDomain(String packageNameDomain) {
        this.packageNameDomain = packageNameDomain;
    }
    
    /** Sets the package name for the <code>PersistentObject</code>.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param packageNameDbObj package name for the generated <code>PersistentObject</code>.
     */
    public void setPackageNameDbObj(String packageNameDbObj) {
        this.packageNameDbObj = packageNameDbObj;
    }

    /** Sets whether table and columns names should be left alone except for capitilizing the first character.
    */
    public void setInitCapObjectNameOnly(Boolean initCapNameOnly) {
        this.initCapNameOnly = initCapNameOnly;
    }

    /** Sets the javadoc method description color for primary key fields in the <code>PersistentObject</code>.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param primaryKeyColor color to use for javadoc primary key method descriptions in <code>PersistentObject</code>.
     */
    public void setPrimaryKeyColor(String primaryKeyColor) {
        this.primaryKeyColor = primaryKeyColor;
    }

    /** Sets the javadoc method description color for non-interface fields in the <code>PersistentObject</code>.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param nonInterfaceColor color to use for javadoc non-interface method descriptions in
     *  <code>PersistentObject</code>.
     */
    public void setNonInterfaceColor(String nonInterfaceColor) {
        this.nonInterfaceColor = nonInterfaceColor;
    }

    /** Sets the javadoc method description color for interface fields in the <code>PersistentObject</code>.
     * <em>This method is normally evoked programatically through reflection rather
     * then evoked by program code.</em>
     * @param interfaceColor color to use for javadoc interface method descriptions in
     *  <code>PersistentObject</code>.
     */
    public void setInterfaceColor(String interfaceColor) {
        this.interfaceColor = interfaceColor;
    }
}
