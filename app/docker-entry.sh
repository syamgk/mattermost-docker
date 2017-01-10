#!/bin/bash
config=/mattermost/config/config.json
DB_HOST=${DB_HOST:-db}
DB_PORT_5432_TCP_PORT=${DB_PORT_5432_TCP_PORT:-5432}
MM_USERNAME=${MM_USERNAME:-mmuser}
MM_PASSWORD=${MM_PASSWORD:-mmuser_password}
MM_DBNAME=${MM_DBNAME:-mattermost}
MM_MIGRATE=${MM_MIGRATE:-no}

if [[ $MM_MIGRATE == "no" ]]; then 
curl https://raw.githubusercontent.com/syamgk/mattermost-docker/master/app/config.template.json > $config;
fi

echo -ne "Configure database connection..."
sed -Ei "s/DB_HOST/$DB_HOST/" $config
sed -Ei "s/DB_PORT/$DB_PORT_5432_TCP_PORT/" $config
sed -Ei "s/MM_USERNAME/$MM_USERNAME/" $config
sed -Ei "s/MM_PASSWORD/$MM_PASSWORD/" $config
sed -Ei "s/MM_DBNAME/$MM_DBNAME/" $config
echo OK

echo "Wait until database $DB_HOST:$DB_PORT_5432_TCP_PORT is ready..."
until nc $DB_HOST $DB_PORT_5432_TCP_PORT
do
    sleep 1
done
# Wait to avoid "panic: Failed to open sql connection pq: the database system is starting up"
sleep 1
echo "Starting platform"
cd /mattermost/bin
./platform $*
