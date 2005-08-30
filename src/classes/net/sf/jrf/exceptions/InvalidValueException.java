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
 * Contributor: ____________________________________
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
package net.sf.jrf.exceptions;

import java.util.*;

import net.sf.jrf.domain.PersistentObject;

/**
 *  This exception is thrown when a call to <code>net.sf.jrf.column.ColumnSpec.validateValue()</code>
 *  fails.
 *
 * @see   net.sf.jrf.column.ColumnSpec#validateValue(PersistentObject)
 */
public class InvalidValueException extends DomainException {
  private List listOfValues = null;
  private Object errantValue = null;
  private Object boundaryValue = null;
  private int type = TYPE_OTHER;
  private int maxLength = 0;

  /** Constant for invalid value with a reason of value not in list. * */
  public final static int TYPE_NOT_IN_LIST = 0;

  /** Constant for invalid value with a reason of value is greater than maximum. * */
  public final static int TYPE_GREATER_THAN_MAXIMUM = 1;

  /** Constant for invalid value with a reason of value is less than minimum. * */
  public final static int TYPE_LESS_THAN_MINIMUM = 2;

  /**
   * Constant for invalid value when a maximum length allowable for underlying column
   *has been exceeded for a propective database insert or update. *
   */
  public final static int TYPE_MAX_LENGTH_EXCEEDED = 3;

  /** Constant for invalid value for a a null required value */
  public final static int TYPE_REQUIRED = 4;

  /** Constant for invalid type for value. */
  public final static int TYPE_INVALID_VALUE_TYPE = 5;

  /** Constant for invalid value for a general, miscellaneous reason. * */
  public final static int TYPE_OTHER = 6;

  /**
   * Constructs an exception with a message parameter. This constructor is for
   * error types of <code>TYPE_OTHER</code>
   *
   * @param msg  error message.
   */
  public InvalidValueException(String msg) {
    super(msg);
  }

  /**
   * Constructs an exception with a message parameter and type.
   * @param msg  error message.
   * @param type error type.
   */
  public InvalidValueException(String msg, int type) {
    super(msg);
    this.type = type;
  }

  /**
   * Constructs a maximum length exceeded exception (<code>TYPE_MAX_LENGTH_EXCEEDED</code>).
   *
   * @param errantValue  value that cause the error.
   * @param maxLength    Description of the Parameter
   * @see                #TYPE_MAX_LENGTH_EXCEEDED
   */
  public InvalidValueException(int maxLength, Object errantValue) {
    super("");
    this.type = TYPE_MAX_LENGTH_EXCEEDED;
    this.maxLength = maxLength;
    this.errantValue = errantValue;
  }

  /**
   * Constructs an exception for error types of <code>TYPE_LESS_THAN_MINIMUM</code>
   * or <code>TYPE_GREATER_THAN_MAXIMUM</code>.
   *
   * @param boundaryValue  boundary value (maximum or minimum depending on error type).
   * @param errantValue    value that cause the error.
   * @param type           Description of the Parameter
   * @see                  #TYPE_LESS_THAN_MINIMUM
   * @see                  #TYPE_GREATER_THAN_MAXIMUM
   */
  public InvalidValueException(int type, Object boundaryValue, Object errantValue) {
    super("");
    this.type = type;
    this.boundaryValue = boundaryValue;
    this.errantValue = errantValue;
  }

  /**
   * Constructs an exception for error type of <code>TYPE_NOT_IN_LIST</code>
   *
   * @param listOfValues  list of acceptable values.
   * @param errantValue   value that cause the error.
   * @see                 #TYPE_NOT_IN_LIST
   */
  public InvalidValueException(List listOfValues, Object errantValue) {
    super("");
    this.type = TYPE_NOT_IN_LIST;
    this.listOfValues = listOfValues;
    this.errantValue = errantValue;
  }

  /**
   * Returns error type.
   *
   * @return   one of the <code>TYPE_</code> constant values.
   */
  public int getErrorType() {
    return type;
  }

  /**
   * Returns maximum length.
   *
   * @return   maximum length for <code>TYPE_MAX_LENGTH_EXCEEDED</code> errors.
   */
  public int getMaxLength() {
    return this.maxLength;
  }

  /**
   * Returns the boundary value that errant value was less than for minimum
   * value and greater than for maximum values
   *
   * @return   maximum value allowed if error type was <code>TYPE_GREATER_THAN_MAXIMUM</code>
   * 	     or mininum value if error type was <code>TYPE_LESS_THAN_MINIMUM</code>
   */
  public Object getBoundaryValue() {
    return this.boundaryValue;
  }

  /**
   * Returns the errant value that caused this exception.
   *
   * @return   errant value that caused this exception.
   */
  public Object getErrantValue() {
    return this.errantValue;
  }

  /**
   * Returns the list of acceptable values for this object or <code>null</code>
   * if not applicable.
   *
   * @return   list of acceptable values.
   */
  public List getListOfValues() {
    return this.listOfValues;
  }

  /**
   * Returns a formatted message of the error. User interfaces will not
   * normally call this method, but rather use the value accessor methods
   * to construct their own message.
   *
   * @return   formatted error message.
   * @see      #getErrorType()
   * @see      #getErrantValue()
   * @see      #getBoundaryValue()
   * @see      #getMaxLength()
   */
  public String getMessage() {
    String msg = super.getMessage();
    StringBuffer buf = new StringBuffer();
    switch (type) {
      case TYPE_OTHER:
        buf.append(msg + " Errant value [" + errantValue + "]");
        break;
      case TYPE_INVALID_VALUE_TYPE:
        buf.append(msg + " Errant value [" + errantValue + "] is not valid for type.");
        break;
      case TYPE_MAX_LENGTH_EXCEEDED:
        buf.append("Value specified (" + errantValue + ") exceeds the maximum allowable length of " +
                maxLength);
        break;
      case TYPE_GREATER_THAN_MAXIMUM:
        buf.append("Value specified (" + errantValue + ") exceeds the maximum allowable value of " +
                boundaryValue);
        break;
      case TYPE_LESS_THAN_MINIMUM:
        buf.append("Value specified (" + errantValue + ") is less than the minimum allowable value of " +
                boundaryValue);
        break;
      case TYPE_NOT_IN_LIST:
        buf.append("Value specified (" + errantValue + ") is not in list of allowable values. ");
        if (listOfValues != null) {
          buf.append(" List: ");
          Iterator iter = listOfValues.iterator();
          int i = 0;
          while (iter.hasNext()) {
            if (++i > 1) {
              buf.append(",");
            }
            buf.append(iter.next());
          }
        }
        break;
      default:
        buf.append(msg);
        break;
    }
    return buf.toString();
  }

}// InvalidValueException

