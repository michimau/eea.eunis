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
 * Contributor: Elmar Fasel
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
package net.sf.jrf.dbpolicies;

import java.util.HashMap;
import net.sf.jrf.*;

import net.sf.jrf.exceptions.*;

/** Description of the Class */
public class OracleCharsets
{

    // based on Oracle8i National Language Support Guide, Release 2 (8.1.6), Part Number A76966-01
    // http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a76966/appa.htm#969074
    // Copyright Â© 1996-2000, Oracle Corporation. All Rights Reserved.

    /** Holds the bits per char for every charset. */
    private HashMap charsetbits;

    /**
     * An OracleCharsets object contains a HashMap, defining the used bytes
     * per character for all charsets known by Oracle.
     */
    public OracleCharsets()
    {
        charsetbits = new HashMap(300);

        charsetbits.put("AL24UTFFSS", new Integer(24));
        charsetbits.put("AR8ADOS710", new Integer(8));
        charsetbits.put("AR8ADOS710T", new Integer(8));
        charsetbits.put("AR8ADOS720", new Integer(8));
        charsetbits.put("AR8ADOS720T", new Integer(8));
        charsetbits.put("AR8APTEC715", new Integer(8));
        charsetbits.put("AR8APTEC715T", new Integer(8));
        charsetbits.put("AR8ARABICMAC", new Integer(8));
        charsetbits.put("AR8ARABICMACS", new Integer(8));
        charsetbits.put("AR8ARABICMACT", new Integer(8));
        charsetbits.put("AR8ASMO708PLUS", new Integer(8));
        charsetbits.put("AR8ASMO8X", new Integer(8));
        charsetbits.put("AR8EBCDIC420S", new Integer(8));
        charsetbits.put("AR8EBCDICX", new Integer(8));
        charsetbits.put("AR8HPARABIC8T", new Integer(8));
        charsetbits.put("AR8MSWIN1256", new Integer(8));
        charsetbits.put("AR8MUSSAD768", new Integer(8));
        charsetbits.put("AR8MUSSAD768T", new Integer(8));
        charsetbits.put("AR8NAFITHA711", new Integer(8));
        charsetbits.put("AR8NAFITHA711T", new Integer(8));
        charsetbits.put("AR8NAFITHA721", new Integer(8));
        charsetbits.put("AR8NAFITHA721T", new Integer(8));
        charsetbits.put("AR8SAKHR706", new Integer(8));
        charsetbits.put("AR8SAKHR707", new Integer(8));
        charsetbits.put("AR8SAKHR707T", new Integer(8));
        charsetbits.put("AR8XBASIC", new Integer(8));
        charsetbits.put("BG8MSWIN", new Integer(8));
        charsetbits.put("BG8PC437S", new Integer(8));
        charsetbits.put("BLT8CP921", new Integer(8));
        charsetbits.put("BLT8EBCDIC1112", new Integer(8));
        charsetbits.put("BLT8EBCDIC1112S", new Integer(8));
        charsetbits.put("BLT8MSWIN1257", new Integer(8));
        charsetbits.put("BLT8PC775", new Integer(8));
        charsetbits.put("BN8BSCII", new Integer(8));
        charsetbits.put("CDN8PC863", new Integer(8));
        charsetbits.put("CH7DEC", new Integer(7));
        charsetbits.put("CL8BS2000", new Integer(8));
        charsetbits.put("CL8EBCDIC1025", new Integer(8));
        charsetbits.put("CL8EBCDIC1025C", new Integer(8));
        charsetbits.put("CL8EBCDIC1025S", new Integer(8));
        charsetbits.put("CL8EBCDIC1025X", new Integer(8));
        charsetbits.put("CL8KOI8R", new Integer(8));
        charsetbits.put("CL8MACCYRILLIC", new Integer(8));
        charsetbits.put("CL8MACCYRILLICS", new Integer(8));
        charsetbits.put("CL8MSWIN1251", new Integer(8));
        charsetbits.put("D7DEC", new Integer(7));
        charsetbits.put("D7SIEMENS9780X", new Integer(7));
        charsetbits.put("D8BS2000", new Integer(8));
        charsetbits.put("D8EBCDIC1141", new Integer(8));
        charsetbits.put("D8EBCDIC273", new Integer(8));
        charsetbits.put("DK7SIEMENS9780X", new Integer(7));
        charsetbits.put("DK8BS2000", new Integer(8));
        charsetbits.put("DK8EBCDIC1142", new Integer(8));
        charsetbits.put("DK8EBCDIC277", new Integer(8));
        charsetbits.put("E7DEC", new Integer(7));
        charsetbits.put("E7SIEMENS9780X", new Integer(7));
        charsetbits.put("E8BS2000", new Integer(8));
        charsetbits.put("EE8EBCDIC870", new Integer(8));
        charsetbits.put("EE8EBCDIC870C", new Integer(8));
        charsetbits.put("EE8EBCDIC870S", new Integer(8));
        charsetbits.put("EE8MACCE", new Integer(8));
        charsetbits.put("EE8MACCES", new Integer(8));
        charsetbits.put("EE8MACCROATIAN", new Integer(8));
        charsetbits.put("EE8MACCROATIANS", new Integer(8));
        charsetbits.put("EE8MSWIN1250", new Integer(8));
        charsetbits.put("EE8PC852", new Integer(8));
        charsetbits.put("EEC8EUROPA3", new Integer(8));
        charsetbits.put("EL8DEC", new Integer(8));
        charsetbits.put("EL8EBCDIC875", new Integer(8));
        charsetbits.put("EL8EBCDIC875S", new Integer(8));
        charsetbits.put("EL8GCOS7", new Integer(8));
        charsetbits.put("EL8MACGREEK", new Integer(8));
        charsetbits.put("EL8MACGREEKS", new Integer(8));
        charsetbits.put("EL8MSWIN1253", new Integer(8));
        charsetbits.put("EL8PC437S", new Integer(8));
        charsetbits.put("EL8PC737", new Integer(8));
        charsetbits.put("EL8PC851", new Integer(8));
        charsetbits.put("EL8PC869", new Integer(8));
        charsetbits.put("ET8MSWIN923", new Integer(8));
        charsetbits.put("F7DEC", new Integer(7));
        charsetbits.put("F7SIEMENS9780X", new Integer(7));
        charsetbits.put("F8BS2000", new Integer(8));
        charsetbits.put("F8EBCDIC1147", new Integer(8));
        charsetbits.put("F8EBCDIC297", new Integer(8));
        charsetbits.put("HU8ABMOD", new Integer(8));
        charsetbits.put("HU8CWI2", new Integer(8));
        charsetbits.put("I7DEC", new Integer(7));
        charsetbits.put("I7SIEMENS9780X", new Integer(7));
        charsetbits.put("I8EBCDIC1144", new Integer(8));
        charsetbits.put("I8EBCDIC280", new Integer(8));
        charsetbits.put("IN8ISCII", new Integer(8));
        charsetbits.put("IS8MACICELANDIC", new Integer(8));
        charsetbits.put("IS8MACICELANDICS", new Integer(8));
        charsetbits.put("IS8PC861", new Integer(8));
        charsetbits.put("IW7IS960", new Integer(7));
        charsetbits.put("IW8EBCDIC1086", new Integer(8));
        charsetbits.put("IW8EBCDIC424", new Integer(8));
        charsetbits.put("IW8EBCDIC424S", new Integer(8));
        charsetbits.put("IW8MACHEBREW", new Integer(8));
        charsetbits.put("IW8MACHEBREWS", new Integer(8));
        charsetbits.put("IW8MSWIN1255", new Integer(8));
        charsetbits.put("IW8PC1507", new Integer(8));
        charsetbits.put("JA16DBCS", new Integer(16));
        charsetbits.put("JA16DBCSFIXED", new Integer(16));
        charsetbits.put("JA16EBCDIC930", new Integer(16));
        charsetbits.put("JA16EUC", new Integer(24));
        charsetbits.put("JA16EUCFIXED", new Integer(16));
        charsetbits.put("JA16EUCYEN", new Integer(24));
        charsetbits.put("JA16MACSJIS", new Integer(16));
        charsetbits.put("JA16SJIS", new Integer(16));
        charsetbits.put("JA16SJISFIXED", new Integer(16));
        charsetbits.put("JA16SJISYEN", new Integer(16));
        charsetbits.put("JA16VMS", new Integer(16));
        charsetbits.put("KO16DBCS", new Integer(16));
        charsetbits.put("KO16DBCSFIXED", new Integer(16));
        charsetbits.put("KO16KSC5601", new Integer(16));
        charsetbits.put("KO16KSC5601FIXED", new Integer(16));
        charsetbits.put("KO16KSCCS", new Integer(16));
        charsetbits.put("LA8ISO6937", new Integer(8));
        charsetbits.put("LA8PASSPORT", new Integer(8));
        charsetbits.put("LT8MSWIN921", new Integer(8));
        charsetbits.put("LT8PC772", new Integer(8));
        charsetbits.put("LT8PC774", new Integer(8));
        charsetbits.put("LV8PC1117", new Integer(8));
        charsetbits.put("LV8PC8LR", new Integer(8));
        charsetbits.put("LV8RST104090", new Integer(8));
        charsetbits.put("N7SIEMENS9780X", new Integer(7));
        charsetbits.put("N8PC865", new Integer(8));
        charsetbits.put("NDK7DEC", new Integer(7));
        charsetbits.put("NL7DEC", new Integer(7));
        charsetbits.put("RU8BESTA", new Integer(8));
        charsetbits.put("RU8PC855", new Integer(8));
        charsetbits.put("RU8PC866", new Integer(8));
        charsetbits.put("S7DEC", new Integer(7));
        charsetbits.put("S7SIEMENS9780X", new Integer(7));
        charsetbits.put("S8BS2000", new Integer(8));
        charsetbits.put("S8EBCDIC1143", new Integer(8));
        charsetbits.put("S8EBCDIC278", new Integer(8));
        charsetbits.put("SF7ASCII", new Integer(7));
        charsetbits.put("SF7DEC", new Integer(7));
        charsetbits.put("TH8MACTHAI", new Integer(8));
        charsetbits.put("TH8MACTHAIS", new Integer(8));
        charsetbits.put("TH8TISASCII", new Integer(8));
        charsetbits.put("TH8TISEBCDIC", new Integer(8));
        charsetbits.put("TH8TISEBCDICS", new Integer(8));
        charsetbits.put("TR7DEC", new Integer(7));
        charsetbits.put("TR8DEC", new Integer(8));
        charsetbits.put("TR8EBCDIC1026", new Integer(8));
        charsetbits.put("TR8EBCDIC1026S", new Integer(8));
        charsetbits.put("TR8MACTURKISH", new Integer(8));
        charsetbits.put("TR8MACTURKISHS", new Integer(8));
        charsetbits.put("TR8MSWIN1254", new Integer(8));
        charsetbits.put("TR8PC857", new Integer(8));
        charsetbits.put("TR8PC857", new Integer(8));
        charsetbits.put("US7ASCII", new Integer(7));
        charsetbits.put("US8BS2000", new Integer(8));
        charsetbits.put("US8ICL", new Integer(8));
        charsetbits.put("US8PC437", new Integer(8));
        charsetbits.put("UTF8", new Integer(24));
        charsetbits.put("UTFE", new Integer(32));
        charsetbits.put("VN8MSWIN1258", new Integer(8));
        charsetbits.put("VN8VN3", new Integer(8));
        charsetbits.put("WE8BS2000", new Integer(8));
        charsetbits.put("WE8BS2000L5", new Integer(8));
        charsetbits.put("WE8DEC", new Integer(8));
        charsetbits.put("WE8DG", new Integer(8));
        charsetbits.put("WE8EBCDIC1047", new Integer(8));
        charsetbits.put("WE8EBCDIC1140", new Integer(8));
        charsetbits.put("WE8EBCDIC1140C", new Integer(8));
        charsetbits.put("WE8EBCDIC1145", new Integer(8));
        charsetbits.put("WE8EBCDIC1146", new Integer(8));
        charsetbits.put("WE8EBCDIC1148", new Integer(8));
        charsetbits.put("WE8EBCDIC1148C", new Integer(8));
        charsetbits.put("WE8EBCDIC284", new Integer(8));
        charsetbits.put("WE8EBCDIC285", new Integer(8));
        charsetbits.put("WE8EBCDIC37", new Integer(8));
        charsetbits.put("WE8EBCDIC37C", new Integer(8));
        charsetbits.put("WE8EBCDIC500", new Integer(8));
        charsetbits.put("WE8EBCDIC500C", new Integer(8));
        charsetbits.put("WE8EBCDIC871", new Integer(8));
        charsetbits.put("WE8GCOS7", new Integer(8));
        charsetbits.put("WE8HP", new Integer(8));
        charsetbits.put("WE8ICL", new Integer(8));
        charsetbits.put("WE8ISO8859P1", new Integer(8));
        charsetbits.put("WE8MACROMAN8", new Integer(8));
        charsetbits.put("WE8MACROMAN8S", new Integer(8));
        charsetbits.put("WE8MSWIN1252", new Integer(8));
        charsetbits.put("WE8NCR4970", new Integer(8));
        charsetbits.put("WE8NEXTSTEP", new Integer(8));
        charsetbits.put("WE8PC850", new Integer(8));
        charsetbits.put("WE8PC858", new Integer(8));
        charsetbits.put("WE8PC860", new Integer(8));
        charsetbits.put("WE8ROMAN8", new Integer(8));
        charsetbits.put("YUG7ASCII", new Integer(7));
        charsetbits.put("ZHS16CGB231280", new Integer(16));
        charsetbits.put("ZHS16CGB231280FIXED", new Integer(16));
        charsetbits.put("ZHS16DBCS", new Integer(16));
        charsetbits.put("ZHS16DBCSFIXED", new Integer(16));
        charsetbits.put("ZHS16GBK", new Integer(16));
        charsetbits.put("ZHS16GBKFIXED", new Integer(16));
        charsetbits.put("ZHS16MACCGB231280", new Integer(16));
        charsetbits.put("ZHT16BIG5", new Integer(16));
        charsetbits.put("ZHT16BIG5FIXED", new Integer(16));
        charsetbits.put("ZHT16CCDC", new Integer(16));
        charsetbits.put("ZHT16DBCS", new Integer(16));
        charsetbits.put("ZHT16DBCSFIXED", new Integer(16));
        charsetbits.put("ZHT16DBT", new Integer(16));
        charsetbits.put("ZHT32EUC", new Integer(32));
        charsetbits.put("ZHT32EUCFIXED", new Integer(32));
        charsetbits.put("ZHT32SOPS", new Integer(32));
        charsetbits.put("ZHT32TRIS", new Integer(32));
        charsetbits.put("ZHT32TRISFIXED", new Integer(32));
        charsetbits.put("WE8ISOICLUK", new Integer(8));
        charsetbits.put("EE8ISO8859P2", new Integer(8));
        charsetbits.put("SE8ISO8859P3", new Integer(8));
        charsetbits.put("NEE8ISO8859P4", new Integer(8));
        charsetbits.put("CL8ISO8859P5", new Integer(8));
        charsetbits.put("AR8ISO8859P6", new Integer(8));
        charsetbits.put("EL8ISO8859P7", new Integer(8));
        charsetbits.put("IW8ISO8859P8", new Integer(8));
        charsetbits.put("WE8ISO8859P9", new Integer(8));
        charsetbits.put("NE8ISO8859P10", new Integer(8));
        charsetbits.put("WE8ISO8859P15", new Integer(8));
        charsetbits.put("EEC8EUROASCI", new Integer(8));

        // no definition of used bytes found so we take 4 bytes to be an the safe side
        charsetbits.put("KO16MSWIN949", new Integer(32));
        charsetbits.put("ZHT16MSWIN950", new Integer(32));
    }

    /**
     * Gets the bytes per character for the given charset.
     *
     * @param charset                        name of the charset
     * @return                               bytes per character
     * @exception UndefinedCharSetException  Description of the Exception
     */
    public int getBytes_per_charset(String charset)
        throws UndefinedCharSetException
    {
        try
        {
            int bits = ((Integer) charsetbits.get(charset)).intValue();
            int bytes = bits / 8;
            if ((bits % 8) != 0)
            {
                bytes = bytes + 1;
            }
            return bytes;
        }
        catch (NullPointerException e)
        {
            throw new UndefinedCharSetException();
        }
    }
}
