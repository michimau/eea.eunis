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
import java.util.*;
import org.vmguys.appgen.*;


/** Master metadata base for the composite to map to
* XML element EmbeddedInfo
<pre>
!ATTLIST EmbeddedInfo
            classNameObj            CDATA   #REQUIRED
            classNameDomain     CDATA   #IMPLIED
            fieldName               CDATA   #REQUIRED
            description         CDATA   #REQUIRED
            see                 CDATA   #IMPLIED
            variableType            (base|aggregate) "aggregate"
            aggregateClassName      CDATA   "java.util.ArrayList"
            aggregateReturnClassName    CDATA   "java.util.List"
            aggregateRowHandler     CDATA   "net.sf.jrf.rowhandlers.ApplicationRowHandlerList"
            rowHandlerNeedsDomain   (true|false) "false"
            iteratorGet          CDATA  ".iterator()"   
            constructObjectContext  (eachrow|allrows) "eachrow"
            constructObjectType     (query|byjoin) "query"
            whereClause         CDATA   #REQUIRED
            orderBy             CDATA   #IMPLIED

</pre>
*/
public class EmbeddedInfoXMLEntity extends SourceGenXMLEntity  {

    /** Token for object description **/
    static public final String DESCRIPTION = "description";

    /** Token for composite class name of the <code>PersistentObject</code>. **/
    static public final String CLASSNAME_OBJ = "classNameObj";

    /** Token for composite lass name of the <code>AbstractDomain</code>. **/
    static public final String CLASSNAME_DOMAIN = "classNameDomain";

    /** Handler class name **/
    static private final String CLASSNAME_HANDLER = "handlerClassName";
    static private final String ROWARGS = "rowHandlerArgs";
    static private final String DOMAINVARNAME = "handlerDomainVariableName";
    static private final String FIELDNAME = "fieldName";
    private List joinFields = null;
    private boolean rowHandlerNeedsDomain = false;
    private String cVarClassName;
    private String cVarDeclareClassName;
    private boolean isBase = false;
    private boolean isJoinType = false;
    private String see = null;
    /*** Default constructor
    */
    public EmbeddedInfoXMLEntity() {
    }


    /**
    */
    public void resolveImpliedKeys() {
        String util;
        String classNameObj = (String) super.transientKeys.get(CLASSNAME_OBJ);
        String domainName = (String) super.transientKeys.get(CLASSNAME_DOMAIN);
        if (domainName == null) {
            domainName = (String) classNameObj+"Domain";
        }
        super.transientKeys.put(CLASSNAME_DOMAIN,domainName);
        super.transientKeys.put(CLASSNAME_HANDLER,super.transientKeys.get(
                CLASSNAME_OBJ)+"Handler");

        String handlerDomainVariableName = "domainVar"+domainName;
        super.transientKeys.put(DOMAINVARNAME,handlerDomainVariableName);
        if (rowHandlerNeedsDomain) {
            super.transientKeys.put(ROWARGS,handlerDomainVariableName);
        }
        else
            super.transientKeys.put(ROWARGS,"");
        super.transientKeys.put("childClassName",classNameObj);
        if (!super.transientKeys.containsKey("orderBy"))
            super.transientKeys.put("orderBy","");
        if (!super.transientKeys.containsKey("see"))
            super.transientKeys.put("see","");
        util = (String) super.transientKeys.get("variableType");
        if (util.equals("base")) {
            isBase = true;
            cVarClassName = classNameObj;
            cVarDeclareClassName = classNameObj;
            //cVarClassName = JRFGeneratorUtil.translateWrapper(cVarClassName);
            //cVarDeclareClassName = cVarClassName;
        }
        else {
            isBase = false;
            cVarDeclareClassName = (String) super.transientKeys.get("aggregateClassName");
            cVarClassName = (String) super.transientKeys.get("aggregateReturnClassName");
        }
        util = (String) super.transientKeys.get("constructObjectType");
        if (util.equals("byjoin")) {
            isJoinType = true;
        }
        else {
            isJoinType = false;
        }
        // Compute as set bean attribute.
        String fieldName = (String) super.transientKeys.get(FIELDNAME);
        int i = 0;
        for ( ; i < fieldName.length(); i++) {
            if ( Character.isLowerCase(fieldName.charAt(i)) )
                break;
        }
        if (i == fieldName.length()) // All upper case.
            util = fieldName;
        else
            util = Character.toLowerCase(fieldName.charAt(0)) + fieldName.substring(1);
        super.transientKeys.put("attributeName",util);
    }
    //  buf.append("Total Stuff records = "+getStuff.size()+"\n");

    static private final String toStringTemplateAggregate =
        "       $buf$.append(\"Total $fieldName$ records = \"+get$fieldName$().size()+\"\\n\");\n"+
        "       $iterVar$ = get$fieldName$()$iteratorGet$;\n"+
        "       while (iter.hasNext()) {\n"+
        "           $buf$.append(iter.next().toString()+\"\\n\");\n"+
        "       }\n"+
        "       \n";    

        
        
    public String getToString(String strBufVar,String iterVar) throws CodeGenException {
        String fieldName = (String) super.transientKeys.get(FIELDNAME);
        
        if  (isBase) {
            return  "   "+strBufVar+".append(\""+fieldName+"=\"get"+fieldName+"());\n";
        }
        else {
            super.transientKeys.put("buf",strBufVar);
            super.transientKeys.put("iterVar",iterVar);
            return CodeGenUtil.generateFromTemplate(
                            CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
                            toStringTemplateAggregate,super.transientKeys);
        
        }

    }

    public boolean isJoinType() {
        return this.isJoinType;
    }


    /** Returns code for instantiating field name.
    */
    public String getObjectDeclaration() {
        return "    private "+cVarClassName+" f_"+super.transientKeys.get(FIELDNAME)+" = new "+cVarDeclareClassName+"();\n";        
    }

    public void appendGetterSetter(StringBuffer buf) throws CodeGenException {
        String description = (String) super.transientKeys.get(DESCRIPTION);
        String objName = (String) super.transientKeys.get(FIELDNAME);
        String fieldName = "f_"+objName;
        CodeGenUtil.appendSetter(description,objName,fieldName,cVarClassName,see,null,buf);
        CodeGenUtil.appendGetter(description,objName,fieldName,cVarClassName,see,buf);
    }
    
    /** Returns code for domain declaration
    */
    public String getDomainDeclaration() {
        return "    "+super.transientKeys.get(CLASSNAME_DOMAIN)+" "+
                super.transientKeys.get(DOMAINVARNAME)+";\n";
    }

    /** Returns domain instantiation code.
    */
    public String getDomainInstantiations() {
        return
            "       "+super.transientKeys.get(DOMAINVARNAME)+" = new "+
                super.transientKeys.get(CLASSNAME_DOMAIN)+"();\n";
    }

    /** Returns embedded apppend code.
    */
    public String getEmbeddedAdd() {
        return "        addEmbeddedPersistentObjectHandler(new "+
            super.transientKeys.get(CLASSNAME_HANDLER)+"());\n";
    }

    public void setRowHandlerNeedsDomain(boolean rowHandlerNeedsDomain) {
        this.rowHandlerNeedsDomain = rowHandlerNeedsDomain;
    }   

    /** Returns list of join fields.
    * @return <code>List</code> of <code>JoinFieldXMLEntity</code> instances.
    */
    public List getJoinFields() {
        return joinFields;  
    }

    public void setSee(String see) {
        this.see = see;
    }

    /** Sets list of join fields.
    * @param list <code>List</code> of <code>JoinFieldXMLEntity</code> instances.
    */
    public void setJoinFields(List joinFields) {
        this.joinFields = joinFields;
    }

}
