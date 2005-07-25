
This is the README file for the EUNIS Database application

All the documentation on EUNIS Database has been uploaded, as requested by
contractual aggreements, on CIRCA, in December 2003
See:
http://eea.eionet.eu.int/Members/irc/eionet-circle/chm/library?l=/specific_agreement_1/contractual_documents/cw3_data_management&vm=compact&sb=Title


1. How to create Java documentation:
------------------------------------
Run 'ant javadoc' from the command prompt.


2.How to install:
-----------------
Run 'ant'. This will compile the classes and deploy the application within
tomcat's webapps directory. If you want to install in an other location you
change the TOMCAT_HOME environment variable.

    export TOMCAT_HOME=/home/roug/tomcat
    mkdir /home/roug/tomcat
    ant


3.How to use lowercase.sh script:
---------------------------------
tolowercase.sh is used to rename MySQL's database table file names
to correct name ( from uppercase - default on Windows to lowercase, as used on Linux ).
    - stop mysql
    - make a copy of this script into 'eunis' directory from MySQL's databases directory ( ex. /var/lib/mysql/eunis )
    - execute this script with the 'uppercase' command line argument ( without the quotes ).
                  linux_prompt$>./tolowercase.sh uppercase
    - start mysql
    - check if all files are now in lowercase.
    - remove the script from there.
    