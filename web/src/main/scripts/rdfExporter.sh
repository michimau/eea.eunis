#!/bin/sh

eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

cp=@MYSQL.JAR@
cp=$cp:@LOG4J.JAR@
cp=$cp:@JRF.JAR@
cp=$cp:@RDF-EXPORTER.JAR@
cp=$cp:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Missing argument what to import!"
else
	$java -cp $cp eionet.eunis.rdf.RdfExporter $@
fi;
