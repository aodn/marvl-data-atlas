# Outline
\<something about what the Marvl Data Atlas is goes here\>

# Development

## Environment Initialisation

For development, we use:

* a vagrant machine, with a subset of the production data
* liquibase for defining the configuration of the data atlas itself.  This includes:
  * additional views/tables, for the atlas
  * cleanup of data, e.g. removal of duplicates etc.


## Database migrations

Supposing a changelog file exists, the migrations can be run as follows:

```
$ ./gradlew update -PchangeLogFile=<changelog.groovy> -PjdbcUrl="<url>" -PdefaultSchemaName=<schema name> -PdbUsername=<username> -PdbPassword=<password>
```

e.g.:
```
$ ./gradlew update -PchangeLogFile=src/changelog/changelog.groovy -PjdbcUrl="jdbc:postgresql://localhost:5432/harvest?ssl=true&amp;sslfactory=org.postgresql.ssl.NonValidatingFactory" -PdefaultSchemaName=public -PdbUsername=marvl_data_atlas -PdbPassword=marvl_data_atlas
```

## Workflow

A similar workflow as for geoserver content development is used, i.e.

1. develop changes locally (against a subset of production data)
2. check in to git on a branch, create PR etc.
3. `master` branch is continuously deployed to a staging environment, against a full copy of production  
