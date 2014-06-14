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
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
 */
package org.vmguys.appgen;
import java.util.*;
import java.io.*;
import java.lang.reflect.*;

/** A data class to use for storing raw class and array class 
* instances for a particular primitive or object.
*/
public class ClassHandle {

	protected Class rawClass = null;

	protected Class arrayClass = null;

	/** Constructs class handle.
	 * @param rawClass an instance of the raw class.
	 * @param arrayInstance instance of an array of the class type.
	 */
	public ClassHandle(Class rawClass, Object arrayInstance) {
		this.rawClass = rawClass;
		if (arrayInstance != null) {
			this.arrayClass = arrayInstance.getClass();
		}
	}

	/** Constructs class handle.
	 * @param rawClass an instance of the raw class.
	 * @param arrayClass an instance of the array class.
	 */
	public ClassHandle(Class rawClass, Class arrayClass) {
		this.rawClass = rawClass;
		this.arrayClass = arrayClass;
	}


	/** Returns the raw class instance.
	* @return raw class instance.
	*/
	public Class getRawClass() {
		return this.rawClass;
	}

	/** Returns the array class instance.
	* @return array class instance.
	*/
	public Class getArrayClass() {
		return this.arrayClass;
	}

	/** Returns the appropriate <code>Class</code> instance under the 
	 * assumption that supplied hash table contains group of <code>
	 * ClassHandle</code>s. 
	 * @param ht hash table of <code>ClassHandle</code>s.
	 * @param name name to search for.
	 * @param getArray if <code>true</code>, get array class instance.
	 * @return class instance or <code>null</code> if not found.
	 */
	public static Class findClass(Hashtable ht,String name, boolean getArray) {
		ClassHandle h = (ClassHandle) ht.get(name);
		if (h == null)
			return null;
		return getArray ? h.arrayClass:h.rawClass;
	}
}
