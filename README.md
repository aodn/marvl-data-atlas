# Outline
\<something about what the Marvl Data Atlas is goes here\>

## Licensing
This project is licensed under the terms of the GNU GPLv3 license.

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
# Reload + provision po node:
private/bin/po-box.sh

# Restore database from backups:
vagrant ssh po -- sudo /var/backups/restore/restore.sh

# Run the liquibase migrations.:
vagrant ssh po -- sudo /var/lib/database_migrations/bin/run_marvl_data_atlas_migration.sh
```

### Changing backups for restore

In order to change backups for restore, edit `nodes/po.json`:
```
$ vim nodes/po.json
```

Modify the `imos_backup/restore` section to your liking:
```
    "imos_backup": {
        "restore": {
            "allow": true,
            "ssh_opts": "-o StrictHostKeyChecking=no",
            "directives": [
                {
                    "from_host":  "2-nsp-mel.emii.org.au",
                    "from_model": "pgsql",
                    "files":      [
                        "harvest/MY_AWESOME_BACKUP1.dump",
                        "harvest/MY_AWESOME_BACKUP2.dump",
                        "harvest/MY_AWESOME_BACKUP3.dump",
                        "harvest/MY_AWESOME_BACKUP4.dump",
                        "harvest/MY_AWESOME_BACKUP5.dump"
                    ]
                }
            ]
        }
    },
```

The different dumps for each collection are backed up in /mnt/imos-t4/backups/backups/2-nsp-mel.emii.org.au/pgsql/<YYYY.MM.DD.HH.MN.SS>/harvest on 10-nsp.

Run the following:
```
# Reload + provision box:
private/bin/po-box.sh

# Rerun restoration:
vagrant ssh po -- sudo /var/backups/restore/restore.sh
```

### Updating the box

In order to apply the latest changes to the box, run the following:
```
$ git pull && (cd private && git pull) && private/bin/po-box.sh
```

### Connecting to database

Use the following credentials:
```
host: po.aodn.org.au (10.11.12.13)
port: 5432
user: admin
pass: admin
database: harvest
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
$ private/bin/po-box.sh
```
