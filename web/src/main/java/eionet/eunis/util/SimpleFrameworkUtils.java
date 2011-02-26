package eionet.eunis.util;


import java.io.ByteArrayOutputStream;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;


/**
 * Utility class to provide several handy methods for convertion using
 * simplexml framework.
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleks21@gmail.com">contact</a>
 */

public final class SimpleFrameworkUtils {

    private static final Logger log = Logger.getLogger(
            SimpleFrameworkUtils.class);

    private static Persister persister = new Persister(new AnnotationStrategy(),
            new Format(4));

    public static String convertToString(String header, Object target, String footer) {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();

        try {
            if (StringUtils.isNotEmpty(header)) {
                buffer.write(header.getBytes("UTF-8"));
            }
            persister.write(target, buffer, "UTF-8");
            if (StringUtils.isNotEmpty(footer)) {
                buffer.write(footer.getBytes("UTF-8"));
            }
            buffer.flush();
            return buffer.toString("UTF-8");
        } catch (Exception fatal) {
            log.error("exception in converting target object", fatal);
            throw new RuntimeException(fatal);
        }
    }
}
