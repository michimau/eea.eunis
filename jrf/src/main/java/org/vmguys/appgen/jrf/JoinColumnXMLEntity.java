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

/** Join column XML entity.
* XML element "JoinColumn"
<pre>
!ATTLIST JoinColumn
        columnName CDATA #REQUIRED
        fieldName CDATA #REQUIRED
        joinColumnSpec CDATA #REQUIRED
        fieldClassName CDATA #REQUIRED
        usePrimitives (true|false) "true"   
</pre>
*/
public class JoinColumnXMLEntity extends SourceGenXMLEntity  {

    boolean usePrimitives;

    
    /*** Default constructor
    */
    public JoinColumnXMLEntity() {
    }

    /**
    */
    public void resolveImpliedKeys() {
        String util = (String) super.transientKeys.get("joinColumnSpec");
        if (util.indexOf(".") == -1) {
            util = "net.sf.jrf.join.joincolumns."+util;
            super.transientKeys.put("joinColumnSpec",util);
        }
    }

    public String getObjectDeclaration() {

        return ColumnXMLEntity.getFieldDeclaration(usePrimitives,
                    (String) super.transientKeys.get("fieldClassName"),
                    "f_"+(String) super.transientKeys.get("fieldName"),null);
    }

    /** Returns join column declaration.
    */
    public String getJoinColumnDeclare() {
        return " new "+super.transientKeys.get("joinColumnSpec")+"(\""+
                     super.transientKeys.get("columnName")+"\", new "+
                     super.transientKeys.get("fieldName")+"GetterSetter())";
    }

    public String getToString(String strBufVar) {
        String fieldName = (String) super.transientKeys.get("fieldName");
        return  "       "+strBufVar+".append(\"\\n"+fieldName+"=\"+f_"+fieldName+");\n";
    }
    
    /** Returns getter-setter impl code for the column.
     * @param dbObjClassName class name of the PO.
    */
    public String getGetterSetterImpl(String dbObjClassName) throws CodeGenException {
        String fieldName = (String) super.transientKeys.get("fieldName");
        return  JRFGeneratorUtil.getGetterSetterImplCode(
                    fieldName+"GetterSetter",
                    dbObjClassName,
                    fieldName,
                    (String) super.transientKeys.get("fieldClassName"),
                    usePrimitives);
    }

    public void appendGetterSetter(StringBuffer buf) throws CodeGenException {
        String description = (String) super.transientKeys.get("description");
        String cVarClassName = (String) super.transientKeys.get("fieldClassName");
        if (usePrimitives)
            cVarClassName = JRFGeneratorUtil.translateWrapper(cVarClassName);
        String postFix = (String) super.transientKeys.get("fieldName");
        String fieldName = "f_"+postFix;
        CodeGenUtil.appendSetter(description,postFix,fieldName,cVarClassName,null,null,buf);
        CodeGenUtil.appendGetter(description,postFix,fieldName,cVarClassName,null,buf);

    }

    public void setUsePrimitives(boolean usePrimitives) {
        this.usePrimitives = usePrimitives;
    }
}
