#!/usr/bin/env sh
# use hacky workaround syslog socket fake
python3 fake_syslog.py &

# configure tw sync with env variables at startup
echo "> Setup tw sync config"
task config recurrence off
task config sync.server.url "$TW_SYNC_SERVER"
task config sync.server.client_id "$TW_SYNC_ID"
task config sync.encryption_secret "$TW_SYNC_SECRET"

echo "> Setup env var file for cronjob (caldav)"
cat <<EOF >.cron-env
export CALDAV_SERVER=$CALDAV_SERVER
export CALDAV_CALENDAR=$CALDAV_CALENDAR
export CALDAV_USERNAME=$CALDAV_USERNAME
export CALDAV_PASSWD=$CALDAV_PASSWD
EOF

echo "> Start cron"
cron
echo "> cron started"

# Run forever
echo "> running endless tail"
tail -f /dev/null
