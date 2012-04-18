#!/bin/sh

eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

cp=@MYSQL.JAR@

cp=$cp:@COMMONS-LANG.JAR@
cp=$cp:@COMMONS-LOGGING.JAR@
cp=$cp:@COMMONS-CODEC.JAR@
cp=$cp:@COMMONS-HTTPCLIENT.JAR@
cp=$cp:@SLF4J.JAR@
cp=$cp:@SLF4J-API.JAR@
cp=$cp:@SPARQL-CLIENT.JAR@
cp=$cp:@SESAME.JAR@
cp=$cp:@LOG4J.JAR@:$CLASSPATH

$java -cp $cp eionet.eunis.scripts.LinkedDataQueriesScript $@

