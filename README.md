EUNIS web application
=====================

How to build:
-------------

You can build the application and run the unit tests with an embedded database. You don't need a database installation. Just do:

 * mvn -Denv=unittest test

If you encounter problems, take a look at web/unittest.properties. This configuration is the one that is used by the Continuous Integration.

If you want your own database, then install MySQL, create a database and a user with full rights to the database. Then you copy web/unittest.propertiesto web/local.properties and modify the values. You should run the unit tests on the database to ensure your database connection is properly configured.

If you use Linux, then add this to the /etc/my.cnf:

    lower_case_table_names=1

To create the tables do:

    cd web; mvn -Dmaven.test.skip=true liquibase:update

How to install:
---------------

When you build on the same machine as you use to install in production, you don't want to run the unit tests as it will empty your database. So always remember to tell it to skip tables.

    mvn -Dmaven.test.skip=true install
    cd web; mvn -Dmaven.test.skip=true liquibase:update
    cp web/target/eunis.war /var/lib/tomcat5/eunis_apps/ROOT.war

