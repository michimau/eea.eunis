#!/bin/sh

# !!!!!!!!!!!!!!!!!! ADJUST THESE !!!!!!!!!!!!!!!!!!
eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

libpath=$eunis/lib

# !!!!!!!!!!!!!!!!! CHECK, if mysql JAR is correct !!!!!!!!!!!!!!
cp=@MYSQL.JAR@
cp=$cp:$libpath/log4j-1.2.13.jar:$libpath/jrf-ver.unknown.jar
cp=$cp:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Missing argument what to import!"
else
	$java -cp $cp eionet.eunis.rdf.RdfExporter $@
fi;
