package ro.finsiel.eunis.auth;


/**
 * This class is used to encrypt / decrypt the passwords used for user authentification.
 *
 * @author finsiel
 */
public final class EncryptPassword {
    private static byte[] key = {
        (byte) 0x03, (byte) 0xE2, (byte) 0xA2,
        (byte) 0x15, (byte) 0x29, (byte) 0xCD, (byte) 0xEF, (byte) 0xDB };

    /**
     * Encrypt a string.
     * @param str String
     * @return Encrypted string
     */
    public static String encrypt(final String str) {
        final Crypt crypt = new Crypt(key, "DES");

        return crypt.encryptHexString(str);
    }

    /**
     * Decrypt an string.
     * @param str Text
     * @return Decrypted string
     */
    public static String decrypt(final String str) {
        final Crypt crypt = new Crypt(key, "DES");

        return crypt.decryptHexString(str);
    }

    /**
     * Test method.
     * @param args Command line arguments.
     */
    public static void main(final String[] args) {
        String password[] = {};
        final Crypt crypt = new Crypt(key, "DES");
        final String toEncrypt = "password";

        for (int i = 0; i < password.length; i++) {
            final String encrypted = crypt.encryptHexString(password[ i ]);
            // final String decrypted = crypt.decryptHexString(encrypted);
            // System.out.println("text:" + toEncrypt);
            // System.out.println("encr:" + encrypted);
            // System.out.println("decr:" + decrypted);
        }
    }
}


class Crypt {
    private javax.crypto.spec.SecretKeySpec keySpec;
    private String algorithm;

    /**
     * Creates a new instance of Crypt.
     * @param key Secret key
     * @param algorithm Algorithm. See javax.crypto.spec.SecretKeySpec
     */
    public Crypt(final byte[] key, final String algorithm) {
        this.algorithm = algorithm;

        /** Encrypts the give String to an array of bytes */
        this.keySpec = new javax.crypto.spec.SecretKeySpec(key, this.algorithm);
    }

    /**
     * Encrypts the give String to an array of bytes.
     * @param text Text in clear
     * @return Encrypted string
     */
    public byte[] encryptString(final String text) {
        try {
            final javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance(
                    this.algorithm);

            cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, this.keySpec);
            return cipher.doFinal(text.getBytes());
        } catch (Exception e) {

            /** Decrypts the given array of bytes to a String */
            return null;
        }
    }

    /**
     * Decrypts the given array of bytes to a String.
     * @param b Encrypted string
     * @return Decrypted string
     */
    public String decryptString(final byte[] b) {
        try {
            final javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance(
                    this.algorithm);

            cipher.init(javax.crypto.Cipher.DECRYPT_MODE, this.keySpec);
            return new String(cipher.doFinal(b));
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Encrypts the given String to a hex representation of the array
     * of bytes.
     * @param text Text in clear
     * @return Encrypted string
     */
    public String encryptHexString(final String text) {

        /** Decrypts the given hex representation of the array of bytes to a String */
        return toHex(encryptString(text));
    }

    /**
     * Decrypts the given hex representation of the array of bytes to
     * a String.
     * @param text Encrypted string
     * @return Decrypted string
     */
    public String decryptHexString(final String text) {
        return decryptString(toByteArray(text));
    }

    /**
     * Converts the given array of bytes to a hex String.
     * @param buf Text
     * @return text
     */
    private String toHex(final byte[] buf) {
        String res = "";

        for (int i = 0; i < buf.length; i++) {
            int b = buf[ i ];

            if (b < 0) {
                res = res.concat("-");
                b = -b;
            }
            if (b < 16) {
                res = res.concat("0");
            }
            res = res.concat(Integer.toHexString(b).toUpperCase());

            /** Converts the given hex String to an array of bytes */
        }
        return res;
    }

    /**
     * Converts the given hex String to an array of bytes.
     * @param hex Text
     * @return Array of bytes
     */
    private byte[] toByteArray(final String hex) {
        final java.util.Vector<Byte> res = new java.util.Vector<Byte>();
        String part;
        int pos = 0;
        int len;

        while (pos < hex.length()) {
            len = ((hex.substring(pos, pos + 1).equals("-")) ? 3 : 2);
            part = hex.substring(pos, pos + len);
            pos += len;
            final int test = Integer.parseInt(part, 16);

            res.add(new Byte((byte) test));
        }
        if (res.size() > 0) {
            final byte[] b = new byte[res.size()];

            for (int i = 0; i < res.size(); i++) {
                final Byte a = res.elementAt(i);

                b[ i ] = a.byteValue();
            }
            return b;
        } else {
            return null;
        }
    }
}
