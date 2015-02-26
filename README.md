# Outline
\<something about what the Marvl Data Atlas is goes here\>

# Development

## Environment Initialisation

For development, we use:

* a vagrant machine, with a subset of the production data
* liquibase for defining the configuration of the data atlas itself.  This includes:
  * additional views/tables, for the atlas
  * cleanup of data, e.g. removal of duplicates etc.

The steps to initialise are:

* Set up chef environment as described here: [https://github.com/aodn/chef/blob/master/README.md](https://github.com/aodn/chef/blob/master/README.md)

* Get `restore.json` key from the dev team and place it under `data_bags/users/restore.json`:

```
mkdir data_bags/users
mv ~/restore.json data_bags/users/restore.json
```

* Execute the following commands in the `chef` directory:

```
# We use the "project officer" (po) node.
NODE_NAME=po

# Use 10.11.12.13 as a static IP for the VM
export VAGRANT_STATIC_IP=10.11.12.13

# "up" the VM
vagrant up $NODE_NAME

# Restore database from backups.
vagrant ssh $NODE_NAME -- sudo /var/backups/restore/restore.sh

# Run the liquibase migrations.
vagrant ssh $NODE_NAME -- sudo /var/lib/database_migrations/bin/run_marvl_data_atlas_migration.sh
```


## Workflow

A similar workflow as for geoserver content development is used, i.e.

1. develop changes locally (against a subset of production data)
2. check in to git on a branch, create PR etc.
3. `master` branch is continuously deployed to a staging environment, against a full copy of production  


By adding the following to your `Vagrantfile`, you are able to edit migrations and perform git magic etc *on the host* (e.g. at ~/marvl-data-atlas) and have changes synchronised in the VM (you'll still need to run migrations as above each time an edit is made):

```
config.vm.synced_folder  File.join(ENV['HOME'], 'marvl-data-atlas'), "/var/lib/database_migrations/changelogs/marvl_data_atlas",
    create: true, owner: 'migrations', group: 'migrations'
```

To have this configuration change take effect, run:

```
$ vagrant reload $NODE_NAME --provision
```
