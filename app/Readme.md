
## For building it locally

```
git clone https://github.com/syamgk/mattermost-docker
cd mattermost-docker/app/
cp Dockerfile.centos7 Dockerfile
docker build .
```
If you like to Push it to a registry then skip the
last line from above script

and build it using below commands.

make sure the variable `REGISTRY` is present before running the commands
```
docker build -t $REGISTRY .
docker push $REGISTRY
```

## For deploying it on Openshift

mattermost-app requires a postgresql instance 

to pass the postgresql credentials to `mattermost-app.json`. we use few variables as below,

#### Environment variables.

* `DB_HOST` - postgresql service name
* `DB_PORT_5432_TCP_PORT` - database port to use when checking the database
* `MM_USERNAME` - database user account to use when checking the database
* `MM_PASSWORD` -  the password for the MM_USERNAME database user
* `MM_DBNAME` -  database that is being consumed by mattermost

eg:
```
oc new-app -p PG_SERVICE=postgresql-92-centos7 -f mattermost-app.json
```
