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

A changelog should be created for each schema for which we want to run migrations.  It *must* be named as such:

```
src/changelog/<schema_name>_changelog.groovy
```

e.g. 

```
src/changelog/aodn_dsto_changelog.groovy
```

To apply all migrations:

```
$ ./gradlew update
```



## Workflow

A similar workflow as for geoserver content development is used, i.e.

1. develop changes locally (against a subset of production)
2. check in to git, create PR etc.
3. `master` branch is continuously deployed to a staging environment, against a full copy of production  
