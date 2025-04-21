# MySQL JDBC Driver

To connect to the MySQL database, you need to download the MySQL JDBC driver and place it in this directory.

## Instructions

1. Download the MySQL Connector/J JDBC driver from the [MySQL website](https://dev.mysql.com/downloads/connector/j/).
2. Extract the downloaded archive.
3. Copy the `mysql-connector-j-x.x.x.jar` file (where x.x.x is the version number) to this directory.
4. Restart your application server (Tomcat) to ensure the driver is loaded.

## Recommended Version

MySQL Connector/J 8.0.28 or later is recommended for this application.

## Alternative Approach

If you prefer to use Maven for dependency management, you can add the following dependency to your pom.xml file:

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.28</version>
</dependency>
```

However, if you're having issues with Maven dependencies, manually adding the JAR file to this directory is a reliable alternative.