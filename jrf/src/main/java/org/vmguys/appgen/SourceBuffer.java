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
package org.vmguys.appgen;
import java.util.*;
import java.io.*;

/** A utility source buffer.  Code generation from templates
 * can use this class as a sub-buffer or a full source file
 * buffer.
 */
public class SourceBuffer {

    // Buffer of Strings (XML attributes) or StringBuffers
    private HashMap appendableKeys = new HashMap();
    private HashMap transientKeys = new HashMap();
    private HashMap permanentKeys = new HashMap();
    // Code gen map
    private HashMap map = new HashMap();
    private String sourceTemplate = null;
    private String outputDirectory = ".";
    private String generatorName = "";
    private int sourceType = CodeGenUtil.SOURCETYPE_JAVA;

    /** Default constructor **/
    public SourceBuffer() {
    }


    /** Constructs an instance with supplied template.
     * @param sourceTemplate source template to use.
     */
    public SourceBuffer(String sourceTemplate) {
        this.sourceTemplate = sourceTemplate;
    }

    /** Sets the source type. (Defaults to java).
    * @param sourceType
    * @see org.vmguys.appgen.CodeGenUtil#SOURCETYPE_JAVA
    * @see org.vmguys.appgen.CodeGenUtil#SOURCETYPE_XML
    * @see org.vmguys.appgen.CodeGenUtil#SOURCETYPE_UNIXSCRIPT
    * @see org.vmguys.appgen.CodeGenUtil#SOURCETYPE_SQL
    * @see org.vmguys.appgen.CodeGenUtil#SOURCETYPE_BAT
    * @see org.vmguys.appgen.CodeGenUtil#SOURCETYPE_C
    */
    public void setSourceType(int sourceType) {
        this.sourceType = sourceType;
    }

    /** Sets generator name if this instance will actually generate a file.
     * @param generatorName source generator name.
     * @see #flushToFile(String)
     */
    public void setGeneratorName(String generatorName) {
        this.generatorName = generatorName;
    }

    /** Sets the output directory for writing source if this instance will
     * write to file.
     * @param outputDirectory output directory to write source file.
     * @see #flushToFile(String)
     */
    public void setOutputDirectory(String outputDirectory) {
        this.outputDirectory = outputDirectory;
    }

    /** Builds and returns a source buffer from all tokens supplied
     * in instance buffers.  A template must be assigned or this method
     * will throw an <code>IllegalStateException</code>.
     * @return source code buffer will template filled in with appropriate
     * tokens.
     * @throws IllegalStateException if no template has been assigned.
     * @see #setSourceTemplate(String)
     */
    public String buildSource() throws CodeGenException {

        Iterator iter = permanentKeys.keySet().iterator();
        while (iter.hasNext()) {
            String key = (String) iter.next();
            String data = (String) permanentKeys.get(key);
            map.put(key,data);
        }
        iter = transientKeys.keySet().iterator();
        while (iter.hasNext()) {
            String key = (String) iter.next();
            String data = (String) transientKeys.get(key);
            map.put(key,data);
        }
        iter = appendableKeys.keySet().iterator();
        while (iter.hasNext()) {
            String key = (String) iter.next();
            StringBuffer data = (StringBuffer) appendableKeys.get(key);
            map.put(key,data.toString());
        }
        String result = CodeGenUtil.generateFromTemplate(CodeGenUtil.TEMPLATE_TAG_BEGIN,
          CodeGenUtil.TEMPLATE_TAG_END,sourceTemplate,map);
        return result;
    }


    /** Sets the source template to use.
     * @param sourceTemplate source template to use.
     */
    public void setSourceTemplate(String sourceTemplate) {
        this.sourceTemplate = sourceTemplate;
    }

    /** Adds a new key for a template token.
     * @param key key used in template to replace with actual data.
     */
    public void addAppendableKey(String key) {
        appendableKeys.put(key,new StringBuffer());
    }

    /*** Sets the entire transient map to use.
     * @param transientKeys <code>HashMap</code> of transient keys.
     */
    public void setTransientKeys(HashMap transientKeys) {
        this.transientKeys = transientKeys;
    }

    /*** Gets the entire transient map to use.
     * @return  <code>HashMap</code> of transient keys.
     */
    public HashMap getTransientKeys() {
        return this.transientKeys;
    }

    /** Adds transient keys and values from <code>HashMap</code>,
     *  @param map <code>HashMap</code> with <code>String</code> key and value.
     */
    public void addTransientKeysAndValues(HashMap map) {
        Iterator iter = map.keySet().iterator();
        while (iter.hasNext()) {
            String key = (String) iter.next();
            transientKeys.put(key,map.get(key));
        }
    }

    /** Adds or updates a key and a value.
     * @param key key.
     * @param value value.
     * @see #addAppendableKey(String)
     */
    public void addTransientKeyAndValue(String key,String value) {
        transientKeys.put(key,value);
    }

    /** Adds a permament key to used for all buffer generation by this instance.
     * @param key key.
     * @param value value.
     * @see #addAppendableKey(String)
     */
    public void addPermanentKeyAndValue(String key,String value) {
        permanentKeys.put(key,value);
    }

    /** Appends data at given key that must have been added with <code>addAppendableKey()</code>.
     * Key hash to be one of the keys added
     * @param key key added using one the <code>addKey()</code> methods.
     * @param contents data to append to key contents.
     * @see #addAppendableKey(String)
     */
    public void append(String key, String contents) {
        StringBuffer buf = (StringBuffer) appendableKeys.get(key);
        if (buf == null)
            throw new IllegalArgumentException("Invalid key: "+key);
        buf.append(contents);
    }

    /** Returns <code>StringBuffer</code> associated with a key.
     * @param key key added with <code>addAppendableKey()</code>.
     */
    public StringBuffer getAppendableBuffer(String key) {
        return (StringBuffer) appendableKeys.get(key);
    }

    /** Resets all key data.
     */
    public void reset() {
        transientKeys.clear();
        Iterator iter = appendableKeys.values().iterator();
        while (iter.hasNext()) {
            StringBuffer data = (StringBuffer) iter.next();
            data.setLength(0);
        }
        map.clear();
    }

    /** Writes data to file generate through a call to <code>buildSource</code>.
     * @param fileName name of file to generate.
     * @see #buildSource()
     */
    public void flushToFile(String fileName) throws CodeGenException,IOException,FileNotFoundException {
        PrintWriter writer = CodeGenUtil.createFile(outputDirectory,fileName,sourceType);
        CodeGenUtil.generateCodeGenHeader(writer,generatorName,"",sourceType);
        writer.println(buildSource());
        writer.close();
    }
}
