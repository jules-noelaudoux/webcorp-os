#!/bin/bash
[ "$EUID" -ne 0 ] && exec sudo "$0" "$@"

source /etc/webcorp/backup.env
export RESTIC_REPOSITORY RESTIC_PASSWORD
restic snapshots
