/*
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.mozilla.org/MPL
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
 * Contributor: Ralph Schaer (ralphschaer@yahoo.com)
 * Contributor: Jonathan Carlson (joncrlsn@users.sourceforge.net)
 * Contributor: Don Lyon (don.lyon@momentx.com)
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
package net.sf.jrf.codegen;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;
import net.sf.jrf.JRFProperties;

import net.sf.jrf.sql.JRFConnectionFactory;

import org.apache.log4j.Category;
import org.exolab.javasource.JClass;

import org.exolab.javasource.JConstructor;
import org.exolab.javasource.JMember;
import org.exolab.javasource.JMethod;
import org.exolab.javasource.JParameter;
import org.exolab.javasource.JSourceCode;

/**
 *  Generate AbstractDomain and PersistentObject subclasses based on the
 *  JDBC database metadata.
 *
 *  Thank you to Ralph Schaer for suggesting and submitting his code to do
 *  this.
 *
 *  Before using this, there are some properties in the jrf.properties file
 *  that you should be aware of.  The JDBC properties are taken from there
 *  and a couple other of properties (like SourceGen.package and
 *  SourceGen.outputdir) need to be populated as well.
 */
public class SourceGen
{

    private String i_outputdir;
    private String i_packageName;
    private String i_subPackageName;
    private String i_policy;
    private String i_schema;
    private String i_persistSuffix;
    private String i_domainSuffix;
    private DatabaseMetaData i_metaData;
    private String i_staticTables[];
    private final static boolean CAPITALIZE = true;// used in javaName()
    private final static boolean UNCAPITALIZE = false;// used in javaName()
    /** log4j category for debugging and errors */
    private final static Category LOG =
        Category.getInstance("SourceGen.class.getName()");

    /**
     *Constructor for the SourceGen object
     *
     * @param outputDir         Description of the Parameter
     * @param genPackageName    Description of the Parameter
     * @param subPackageName    Description of the Parameter
     * @param policy            Description of the Parameter
     * @param schema            Description of the Parameter
     * @param persistSuffix     Description of the Parameter
     * @param domSuffix         Description of the Parameter
     * @param staticTableList   Description of the Parameter
     * @exception SQLException  Description of the Exception
     */
    public SourceGen(
        String outputDir,
        String genPackageName,
        String subPackageName,
        String policy,
        String schema,
        String persistSuffix,
        String domSuffix,
        String staticTableList)
        throws SQLException
    {
        i_outputdir = outputDir;
        i_packageName = genPackageName;
        i_subPackageName = subPackageName;
        i_policy = policy;
        i_schema = schema;
        i_persistSuffix = persistSuffix;
        i_domainSuffix = domSuffix;

        if (staticTableList != null)
        {
            StringTokenizer st = new StringTokenizer(staticTableList, ",");
            i_staticTables = new String[st.countTokens()];
            int i = 0;
            while (st.hasMoreTokens())
            {
                i_staticTables[i] = st.nextToken();
                i++;
            }
        }

        try
        {
            i_metaData = JRFConnectionFactory.create().getDatabaseMetaData();
        }
        catch (Exception e)
        {
            LOG.error("Exception occured in SourceGen", e);
            System.exit(-1);
        }
    }

    /**
     * Description of the Method
     *
     * @param tableName   Description of the Parameter
     * @param columnList  Description of the Parameter
     */
    public void generatePersistentObjectClass(String tableName, List columnList)
    {
        LOG.info("Generating PersistentObject subclass for table " + tableName);

        JClass newClass;
        if (i_packageName != null &&
            i_packageName.length() > 0)
        {
            newClass =
                new JClass(
                i_packageName + "."
                + this.className(tableName) + i_persistSuffix);
        }
        else
        {
            newClass = new JClass(this.className(tableName) + i_persistSuffix);
        }

        newClass.addImport("net.sf.jrf.domain.PersistentObject");
        newClass.getModifiers().makePublic();
        newClass.setSuperClass("PersistentObject");

        // add basic contructor
        JConstructor constructor = newClass.createConstructor();
        constructor.setSourceCode("super();");
        newClass.addConstructor(constructor);

        Iterator iterator = columnList.iterator();
        while (iterator.hasNext())
        {
            ColumnData cd = (ColumnData) iterator.next();

            // Define a member field
            JMember member = new JMember(this.getJClass(cd.colType),
                this.fieldName(cd.colName));
            member.getModifiers().makePrivate();
            member.setInitString("null");
            member.setComment("This is a database field.");
            newClass.addMember(member);

            // Define a getter method
            JMethod meth = new JMethod(this.getJClass(cd.colType),
                this.getterName(cd.colName));
            meth.getModifiers().makePublic();
            meth.setComment("Getter for a database field.");
            meth.getSourceCode().add("return " + this.fieldName(cd.colName) + ";");
            newClass.addMethod(meth);

            // Define a setter method.
            meth = new JMethod(
                null,
                this.setterName(cd.colName));

            String parmName = this.javaName(cd.colName, UNCAPITALIZE);
            meth.addParameter(
                new JParameter(
                this.getJClass(cd.colType),
                parmName));
            meth.getModifiers().makePublic();
            meth.setComment("Setter for a database field.");
            JSourceCode sc = meth.getSourceCode();
            sc.add(this.fieldName(cd.colName)
                + " = "
                + parmName
                + ";");
            if (cd.isPrimaryKey)
            {
                sc.add("// Changing a primary key so we force this to new.");
                sc.add("this.forceNewPersistentState();");
            }
            else
            {
                sc.add("this.markModifiedPersistentState();");
            }
            newClass.addMethod(meth);
        }

        newClass.print(i_outputdir, null, 2);
    }


    /**
     * Description of the Method
     *
     * @param tableName   Description of the Parameter
     * @param columnList  Description of the Parameter
     */
    public void generateDomainClass(String tableName, List columnList)
    {
        LOG.info("Generating AbstractDomain subclass for table " + tableName);

        JClass newClass;

        if (i_packageName != null &&
            i_packageName.length() > 0)
        {
            newClass = new JClass(
                i_packageName + "." + this.className(tableName) + i_domainSuffix);

        }
        else
        {
            newClass = new JClass(
                this.className(tableName) + i_domainSuffix);
        }

        newClass.addImport("net.sf.jrf.*");
        newClass.addImport("net.sf.jrf.domain.*");
        newClass.addImport("net.sf.jrf.sql.JDBCHelperFactory");
        newClass.addImport("net.sf.jrf.column.*");
        newClass.addImport("net.sf.jrf.column.columnspecs.*");
        newClass.addImport(i_subPackageName + "." + this.className(tableName));
        newClass.getModifiers().makePublic();
        newClass.setSuperClass(getDomainSuperClass(tableName));

        JMethod meth = new JMethod(null, "setup");
        meth.getModifiers().makePublic();

        JSourceCode sc = new JSourceCode();
        sc.add("// These setters could be used to override the default.");
        sc.add("// this.setDatabasePolicy(new " + i_policy + "());");
        sc.add("// this.setJDBCHelper(JDBCHelperFactory.create());");
        sc.add("");
        sc.add("this.setTableName(\"" + tableName + "\");");
        sc.add("");

        Iterator iterator = columnList.iterator();
        boolean inCompoundKey = false;
        while (iterator.hasNext())
        {
            ColumnData cd = (ColumnData) iterator.next();

            if (cd.colSpecName != null)
            {
                if (!cd.isCompoundPrimaryKey && inCompoundKey)
                {
                    sc.add(")));");
                    inCompoundKey = false;
                }
                else if (inCompoundKey)
                {
                    sc.add("),");
                }
                if (cd.isCompoundPrimaryKey && !inCompoundKey)
                {
                    inCompoundKey = true;
                    sc.add("this.addColumnSpec(");
                    sc.add("new CompoundPrimaryKeyColumnSpec (", (short) 2);
                }
                else if (!inCompoundKey)
                {
                    sc.add("this.addColumnSpec(");
                }
                sc.add("new " + cd.colSpecName + "(", (short) 2);
                sc.add("\"" + cd.colName + "\",", (short) 4);
                sc.add("\"" + this.getterName(cd.colName) + "\",",
                    (short) 4);
                sc.add("\"" + this.setterName(cd.colName) + "\",",
                    (short) 4);

                sc.add(
                    this.getDefaultValue(cd.colType, cd.isNullable),
                    (short) 4);

                if (cd.isPrimaryKey)
                {
                    if (cd.isSequencedKey)
                    {
                        // convention assumption: sequenced primary  keys end with "sid"
                        sc.add(",SEQUENCED_PRIMARY_KEY", (short) 4);
                    }
                    else
                    {
                        sc.add(",NATURAL_PRIMARY_KEY", (short) 4);
                    }
                }
                else if (cd.isIntOptimisticLock || cd.isTimeOptimisticLock)
                {
                    // convention assumption: integer optimistic locks are all called "tx_lock"
                    // timestamp optimistic locks are all called "last_updated"
                    sc.add(",OPTIMISTIC_LOCK", (short) 4);
                }
                else
                {
                    if (!cd.isNullable)
                    {
                        sc.add(",REQUIRED", (short) 4);
                    }
                }

                if (!inCompoundKey)
                {
                    sc.add("));");
                }
                // check if the last field is still part of the key, i.e. primary key is the whole table
                if (!iterator.hasNext() && inCompoundKey)
                {
                    sc.add(")));");
                }
            }
        }

        meth.setSourceCode(sc);

        newClass.addMethod(meth);
        meth = new JMethod(new JClass("PersistentObject"), "newPersistentObject");
        meth.getModifiers().makePublic();
        meth.getSourceCode().add(
            "return new " + this.className(tableName) + "();");
        newClass.addMethod(meth);
        newClass.print(i_outputdir, null, 2);

    }


    private JClass getJClass(short type)
    {

        switch (type)
        {
            case -9:
            case -10:
            case Types.LONGVARCHAR:
            case Types.CHAR:
            case Types.VARCHAR:
                return JClass.String;
            case Types.BINARY:
            case Types.VARBINARY:
            case Types.LONGVARBINARY:
                return new JClass("Byte[]");
            case Types.BIT:
                return JClass.Boolean;
            case Types.TINYINT:// use Short because byte is signed -128 to 127
            case Types.SMALLINT:
                return JClass.Short;
            case Types.INTEGER:
                return JClass.Integer;
            case Types.BIGINT:
                return JClass.Long;
            case Types.REAL:
                return JClass.Float;
            // JDBC Guide: Getting Started: 8 - Mapping SQL and Java Types
            // recommends FLOAT be represented as Java Double.
            case Types.FLOAT:
            case Types.DOUBLE:
                return JClass.Double;
            case Types.NUMERIC:
            case Types.DECIMAL:
                return JClass.BigDecimal;
            case Types.DATE:
                return new JClass("java.sql.Date");
            case Types.TIME:
                return new JClass("java.sql.Time");
            case Types.TIMESTAMP:
                return new JClass("java.sql.Timestamp");
            case Types.OTHER:
                return JClass.Object;
        }

        return null;
    }


    private String getDefaultValue(short type, boolean nullable)
    {

        switch (type)
        {
            case -9:
            case -10:
            case Types.LONGVARCHAR:
            case Types.CHAR:
            case Types.VARCHAR:
                if (nullable)
                {
                    return "DEFAULT_TO_NULL";
                }
                else
                {
                    return "DEFAULT_TO_EMPTY_STRING";
                }

            case Types.INTEGER:
                if (nullable)
                {

                    return "DEFAULT_TO_NULL";
                }
                else
                {
                    return "DEFAULT_TO_ZERO";
                }

            case Types.TIMESTAMP:

                if (nullable)
                {
                    return "DEFAULT_TO_NULL";
                }
                else
                {
                    return "DEFAULT_TO_NOW";
                }

        }

        return null;
    }


    private String getColumnSpecName(short type)
    {

        switch (type)
        {

            case -9:
            case -10:
            case Types.LONGVARCHAR:
            case Types.CHAR:
            case Types.VARCHAR:
                return "StringColumnSpec";
            case Types.BINARY:
            case Types.VARBINARY:
            case Types.LONGVARBINARY:
                return "ByteArrayColumnSpec";
            case Types.BIT:
                return "BooleanColumnSpec";
            case Types.TINYINT:
            case Types.SMALLINT:
                return "ShortColumnSpec";
            case Types.INTEGER:
                return "IntegerColumnSpec";
            case Types.BIGINT:
                return "LongColumnSpec";
            case Types.REAL:
                return "FloatColumnSpec";
            // JDBC Guide: Getting Started: 8 - Mapping SQL and Java Types
            // recommends FLOAT be represented as Java Double.
            case Types.FLOAT://
            case Types.DOUBLE:
                return "DoubleColumnSpec";
            case Types.NUMERIC:
            case Types.DECIMAL:
                return "BigDecimalColumnSpec";
            case Types.DATE:
                return "SQLDateColumnSpec";
            case Types.TIME:
                return "SQLTimeColumnSpec";
            case Types.TIMESTAMP:
                return "TimestampColumnSpec";
            case Types.OTHER:
                return "OtherColumnSpec";
            case Types.NULL:
                return "NullColumnSpec";
        }
        return null;
    }

    /**
     * Convert a table name to a class name.
     *
     * @param tableName  a value of type 'String'
     * @return           a value of type 'String'
     */
    private String className(String tableName)
    {
        return this.javaName(tableName, CAPITALIZE);
    }


    /**
     * Convert a column name to a getter name.
     *
     * @param columnName  a value of type 'String'
     * @return            a value of type 'String'
     */
    private String getterName(String columnName)
    {
        return "get" + this.javaName(columnName, CAPITALIZE);
    }


    /**
     * Convert a column name to a setter name.
     *
     * @param columnName  a value of type 'String'
     * @return            a value of type 'String'
     */
    private String setterName(String columnName)
    {
        return "set" + this.javaName(columnName, CAPITALIZE);
    }


    /**
     * convert a column name to a field name.
     *
     * @param columnName  a value of type 'String'
     * @return            a value of type 'String'
     */
    private String fieldName(String columnName)
    {
        return "i_" + this.javaName(columnName, UNCAPITALIZE);
    }


    /**
     * Remove underscores and properly case things.
     *
     * @param sqlName     a value of type 'String'
     * @param capitalize  a value of type 'boolean' - if true, capitalize the
     *                   first letter.
     * @return            a value of type 'String'
     */
    private String javaName(String sqlName, boolean capitalize)
    {
        String name = null;
        if (capitalize)
        {
            if (sqlName.length() == 1)
            {
                return sqlName.toUpperCase();
            }
            else
            {
                name = (sqlName.substring(0, 1).toUpperCase()
                    + sqlName.substring(1).toLowerCase());
            }
        }
        else
        {
            name = sqlName.toLowerCase();
        }
        int ix = name.indexOf('_');
        if (ix < 0)
        {
            return name;
        }
        else
        {
            // If it's the last character, just omit it
            if (ix == (name.length() - 1))
            {
                return name.substring(0, ix);
            }
            else
            {
                return name.substring(0, ix)
                    + this.javaName(name.substring(ix + 1),
                    CAPITALIZE);
            }
        }
    }



    /**
     * Gets the metaData attribute of the SourceGen object
     *
     * @return   The metaData value
     */
    public DatabaseMetaData getMetaData()
    {
        return i_metaData;
    }


    /**
     * Gets the domainSuperClass attribute of the SourceGen object
     *
     * @param tableName  Description of the Parameter
     * @return           The domainSuperClass value
     */
    public String getDomainSuperClass(String tableName)
    {

        if (i_staticTables != null)
        {
            for (int i = 0; i < i_staticTables.length; ++i)
            {
                if (i_staticTables[i].equalsIgnoreCase(tableName))
                {
                    return "AbstractStaticDomain";
                }
            }
        }
        return "AbstractDomain";
    }


    /**
     * Main processing method for the SourceGen object
     *
     * @exception SQLException  Description of the Exception
     */
    public void run()
        throws SQLException
    {
        // Create a list of table names
        String[] tableTypes =
            {"TABLE"};
        ResultSet tables =
            i_metaData.getTables(null, i_schema, "%", tableTypes);

        List tableList = new ArrayList();
        while (tables.next())
        {
            String tableName = tables.getString("TABLE_NAME");
            tableList.add(tableName);
        }
        tables.close();

        // Loop through the tables and generate the files
        Iterator iterator = tableList.iterator();
        while (iterator.hasNext())
        {
            String tableName = (String) iterator.next();

            // Create a set of primary key column names.
            Set primaryKeys = new HashSet();
            ResultSet rs =
                i_metaData.getPrimaryKeys(null, null, tableName);
            while (rs.next())
            {
                primaryKeys.add(rs.getString("COLUMN_NAME"));
            }

            // Create a list of ColumnData objects
            rs = i_metaData.getColumns(null, null, tableName, "%");
            List columnList = new ArrayList();
            while (rs.next())
            {
                columnList.add(this.new ColumnData(rs, primaryKeys));
            }

            // Create the java files
            this.generatePersistentObjectClass(tableName, columnList);
            this.generateDomainClass(tableName, columnList);

        }// while (iterator.hasNext())
    }// run()


    /**
     * The main program for the SourceGen class
     *
     * @param args              The command line arguments
     * @exception SQLException  Description of the Exception
     */
    public static void main(String[] args)
        throws SQLException
    {

        try
        {
            SourceGen jrfsg =
                new SourceGen(
                JRFProperties.getProperty("SourceGen.outputdir"),
                JRFProperties.getProperty("SourceGen.genPackage"),
                JRFProperties.getProperty("SourceGen.subclassPackage"),
                JRFProperties.getProperty("databasePolicy"),
                JRFProperties.getProperty("SourceGen.schema"),
                JRFProperties.getProperty("SourceGen.PersistSuffix"),
                JRFProperties.getProperty("SourceGen.DomainSuffix"),
                JRFProperties.getProperty("SourceGen.StaticTables"));

            jrfsg.run();
        }
        catch (SQLException e)
        {
            LOG.error("SQLException occurred in SourceGen", e);
            throw e;
        }

        System.exit(0);
    }


    /**  This is a private inner class that is used to hold column data. */
    private class ColumnData
    {

        String colName = null;
        short colType = 0;
        int colSize = 0;
        boolean isNullable = true;
        int decimalDigits = 0;
        String colSpecName = null;
        boolean isPrimaryKey = false;
        boolean isCompoundPrimaryKey = false;
        boolean isSequencedKey = false;
        boolean isIntOptimisticLock = false;
        boolean isTimeOptimisticLock = false;

        /**
         *Constructor for the ColumnData object
         *
         * @param rs                Description of the Parameter
         * @param primaryKeys       Description of the Parameter
         * @exception SQLException  Description of the Exception
         */
        public ColumnData(ResultSet rs, Set primaryKeys)
            throws SQLException
        {
            this.colName = rs.getString("COLUMN_NAME");
            this.colType = rs.getShort("DATA_TYPE");
            this.colSize = rs.getInt("COLUMN_SIZE");
            this.colSpecName = getColumnSpecName(colType);
            String nullable = rs.getString("IS_NULLABLE");
            if (nullable == null ||
                nullable.trim().equalsIgnoreCase("NO"))
            {
                this.isNullable = false;
            }
            this.decimalDigits = rs.getInt("DECIMAL_DIGITS");
            this.isPrimaryKey = primaryKeys.contains(colName);

            if (isPrimaryKey)
            {
                this.isCompoundPrimaryKey = primaryKeys.size() > 1;
            }
            else
            {
                this.isCompoundPrimaryKey = false;
            }
            if (colName.length() > 3 &&
                colName.substring(colName.length() - 3, colName.length()).equalsIgnoreCase("SID"))
            {
                this.isSequencedKey = true;
            }
            if (colName.equalsIgnoreCase("TX_LOCK"))
            {
                this.isIntOptimisticLock = true;
                this.colType = Types.INTEGER;
            }
            if (colName.equalsIgnoreCase("LAST_UPDATED"))
            {
                this.isTimeOptimisticLock = true;
            }

            this.colSpecName = getColumnSpecName(colType);
        }

    }// ColumnData

}// SourceGen

