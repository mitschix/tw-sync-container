#!/usr/bin/env sh
# sync shell script for cronjob

# workaround to source env variables for caldav
. "$HOME/.cron-env"

echo ">>> Sync job running at $(date)"

echo ">> Running 1st sync with task server (fetch before caldav)"
task sync

echo ">> Running caldav <-> tw sync"
tw_caldav_sync --all --caldav-url "$CALDAV_SERVER" --caldav-calendar "$CALDAV_CALENDAR"

echo ">> Running 2nd sync with task server (update after caldav)"
task sync

echo ">>> Sync job done"
echo "---"
