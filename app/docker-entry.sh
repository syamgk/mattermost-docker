#!/bin/bash
config=/mattermost/config/config.json

function updatejson() {
  set -o nounset
  key=$1
  value=$2
  file=$3
  jq "$key = \"$value\"" $file | awk 'BEGIN{RS="";getline<"-";print>ARGV[1]}' $file
  echo "Updated file $file"
  set +o nounset
}

if [ -f "$config" ]
then
    echo "old $config found."
else
    echo "$config not found."
    curl https://raw.githubusercontent.com/syamgk/mattermost-docker/master/app/config.template.json > $config;
    echo -ne "Updating mattermost configuration..."
    if [[ -z $DB_HOST ]]; then echo "DB_HOST not set."; exit 1; fi
    if [[ -z $DB_PORT ]]; then echo "DB_PORT not set."; exit 1; fi
    if [[ -z $MM_USERNAME ]]; then echo "MM_USERNAME not set."; exit 1; fi
    if [[ -z $MM_PASSWORD ]]; then echo "MM_PASSWORD not set."; exit 1; fi
    if [[ -z $MM_DBNAME ]]; then echo "MM_DBNAME not set."; exit 1; fi
    updatejson ".SqlSettings.DriverName" "postgres" $config
    updatejson ".SqlSettings.DataSource" "postgres://${MM_USERNAME}:${MM_PASSWORD}@${DB_HOST}:${DB_PORT}/${MM_DBNAME}?sslmode=disable&connect_timeout=10" $config
fi

timeout=30
curtime=0
while ! echo | nc -w1 $DB_HOST $DB_PORT > /dev/null 2>&1; do
  echo "Waiting ${timeout}s for database to be available at ${DB_HOST}:${DB_PORT}... ${curtime}s"
  sleep 1
  curtime=$(($curtime+1))
  if [[ $curtime -ge $timeout ]]; then
    echo "Could not connect to the database. Aborting after $timeout seconds."
    exit 1
  fi  
done
# Wait to avoid "panic: Failed to open sql connection pq: the database system is starting up"
sleep 1
echo "Starting platform"
cd /mattermost/bin
./platform $*
