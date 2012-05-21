#!/bin/sh

eunis=@WEBAPP.HOME@/WEB-INF
cd $eunis/classes
java=/usr/bin/java

cp=@MYSQL.JAR@
cp=$cp:@LOG4J.JAR@
cp=$cp:@JRF.JAR@
cp=$cp:$CLASSPATH

if [ "$1" = "" ]; then
    echo "Missing argument! Possible first arguments are: sites, species_tab, sites_tab, habitats_tab, linkeddata_tab, taxonomy_tree"
else
    $java -cp $cp eionet.eunis.scripts.PostImportScriptsCmd $@
fi;
