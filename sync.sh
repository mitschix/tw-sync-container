#!/usr/bin/env sh

# configure tw sync with env variables at startup
echo "> Setup tw sync config"
task config recurrence off
task config sync.server.url "$TW_SYNC_SERVER"
task config sync.server.client_id "$TW_SYNC_ID"
task config sync.encryption_secret "$TW_SYNC_SECRET"

echo "> Setup env var file for sync (caldav)"
export CALDAV_SERVER="$CALDAV_SERVER"
export CALDAV_CALENDAR="$CALDAV_CALENDAR"
export CALDAV_USERNAME="$CALDAV_USERNAME"
export CALDAV_PASSWD="$CALDAV_PASSWD"

echo ">>> Sync job running at $(date)"

echo ">> Running 1st sync with task server (fetch before caldav)"
task sync

echo ">> Running caldav <-> tw sync"
tw_caldav_sync --all --caldav-url "$CALDAV_SERVER" --caldav-calendar "$CALDAV_CALENDAR"

echo ">> Running 2nd sync with task server (update after caldav)"
task sync

echo ">>> Sync job done"
echo "---"
