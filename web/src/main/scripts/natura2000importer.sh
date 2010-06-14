#!/bin/sh

# !!!!!!!!!!!!!!!!!! ADJUST THESE !!!!!!!!!!!!!!!!!!
eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

libpath=$eunis/lib

# !!!!!!!!!!!!!!!!! CHECK, if mysql JAR is correct !!!!!!!!!!!!!!
cp=@MYSQL.JAR@

cp=$cp:$libpath/xmlParserAPIs-2.2.1.jar
cp=$cp:$libpath/xml-apis-1.0.b2.jar:$CLASSPATH

if [ "$1" = "" ]; then
	echo "Usage: ro.finsiel.eunis.dataimport.Natura2000Importer {folderName}"
else
	$java -cp $cp ro.finsiel.eunis.dataimport.Natura2000Importer $1
fi;
