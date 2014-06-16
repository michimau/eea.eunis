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
import org.vmguys.appgen.SourceGenXMLEntity;
import org.vmguys.appgen.Generator;

/** Master metadata base for the composite to map to
* XML element "CompositeObject"
<pre>
        classNameObj            CDATA   #REQUIRED
        baseClassNameObj        CDATA   #REQUIRED
        description         CDATA   #REQUIRED
        cached              (true|false) "false"
        cacheSize               CDATA   #IMPLIED
        classNameDomain     CDATA   #IMPLIED
        objInterfaces           CDATA   #IMPLIED
        domainInterfaces        CDATA   #IMPLIED
        baseClassNameDomain     CDATA   #IMPLIED
        moduleList          CDATA   #IMPLIED
</pre>
*/
public class CompositeObjectXMLEntity extends SourceGenXMLEntity  {

    /** Token for object description **/
    static public final String DESCRIPTION = "description";

    /** Token for composite base class name of the <code>PersistentObject</code>. **/
    static public final String BASECLASSNAME_OBJ = "baseClassNameObj";

    /** Token for composite base class name of the <code>AbstractDomain</code>. **/
    static public final String BASECLASSNAME_DOMAIN = "baseClassNameDomain";

    /** Token for composite class name of the <code>PersistentObject</code>. **/
    static public final String CLASSNAME_OBJ = "classNameObj";

    /** Token for composite lass name of the <code>AbstractDomain</code>. **/
    static public final String CLASSNAME_DOMAIN = "classNameDomain";

    static private final String CACHESIZE = "cacheSize";
    static private final String OBJINTERFACES = "objInterfaces";
    static private final String DOMAININTERFACES = "domainInterfaces";

    private HashSet dbObjInterfaces = new HashSet();
    private HashSet domainInterfaces = new HashSet();
    private List embeddedInfo = new ArrayList();
    private List joinTables = new ArrayList();
    private List poMethods = new ArrayList();
    private List domainMethods = new ArrayList();

    static public String interfaceBase = null;

    private HashSet moduleList;
    private boolean cached = false;

    /*** Default constructor
    */
    public CompositeObjectXMLEntity() {
        // Put in default cache size.
    }

    /*** Sets cache flag.
    * @param cached if <code>true</code> data is cached.
    */
    public void setCached(boolean cached) {
        this.cached = cached;
    }

    /** Sets up domain names and cache size, if required.
    */
    public void resolveImpliedKeys() {
        moduleList = Generator.parseTokenList((String) super.transientKeys.get("moduleList"));
        String util;
        if (!super.transientKeys.containsKey(BASECLASSNAME_DOMAIN)) {
            super.transientKeys.put(BASECLASSNAME_DOMAIN,
                super.transientKeys.get(BASECLASSNAME_OBJ)+"Domain");
        }
        if (!super.transientKeys.containsKey(CLASSNAME_DOMAIN)) {
            super.transientKeys.put(CLASSNAME_DOMAIN,
                super.transientKeys.get(CLASSNAME_OBJ)+"Domain");
        }
        /*
        if (cached) {
            util = super.transientKeys.get(CACHESIZE);
            if (util == null)
                super.transientKeys.put(CACHESIZE," setCacheSize(100);");
            else
                super.transientKeys.put(CACHESIZE," setCacheSize("+util+");");
        }
        else*/
            super.transientKeys.put(CACHESIZE,"");
        TableXMLEntity.processInterfaces(transientKeys,dbObjInterfaces,OBJINTERFACES,interfaceBase);
        TableXMLEntity.processInterfaces(transientKeys,domainInterfaces,DOMAININTERFACES,interfaceBase);
    }

    public boolean implementsDbObjInterface(String interfaceName) {
        return dbObjInterfaces.contains(interfaceName);
    }

    public boolean implementsDomainInterface(String interfaceName) {
        return domainInterfaces.contains(interfaceName);
    }

    public String getBaseClassDomainName() {
        return (String) super.transientKeys.get(BASECLASSNAME_DOMAIN);
    }

    public String getClassDomainName() {
        return (String) super.transientKeys.get(CLASSNAME_DOMAIN);
    }

    public String getClassDbObjName() {
        return (String) super.transientKeys.get(CLASSNAME_OBJ);
    }

    public HashSet getModuleList() {
        return moduleList;
    }

    /** Returns list of embedded objects.
    * @return <code>List</code> of <code>EmbeddedObjectXMLEntity</code> instances.
    */
    public List getEmbeddedInfo() {
        return embeddedInfo;
    }

    /** Sets list of embedded objects.
    * @param list <code>List</code> of <code>EmbeddedObjectXMLEntity</code> instances.
    */
    public void setEmbeddedInfo(List embeddedInfo) {
        this.embeddedInfo = embeddedInfo;
    }

    /** Gets embedded join tables
    */
    public List getJoinTable() {
        return joinTables;
    }

    /** Sets join columns.
    */
    public void setJoinTable(List joinTables) {
        this.joinTables = joinTables;
    }

    /** Gets <code>AbstractDomain</code> methods.
    * @return <code>AbstractDomain</code> methods.
    */
    public List getDomainMethods() {
        return domainMethods;
    }

    /** Sets <code>AbstractDomain</code> methods.
    * @param methods <code>AbstractDomain</code> methods.
    */
    public void setDomainMethods(List methods) {
        this.domainMethods = methods;
    }

    /** Gets <code>PersistentObject</code> methods.
    * @return <code>PersistentObject</code> methods.
    */
    public List getPersistentObjectMethods() {
        return poMethods;
    }

    /** Sets <code>PersistentObject</code> methods.
    * @param methods <code>PersistentObject</code> methods.
    */
    public void setPersistentObjectMethods(List methods) {
        this.poMethods = methods;
    }
}
