#!/bin/bash
set -e

# allow the container to be started with `--user`
if [ "$1" = *'nginx'* -a "$(id -u)" = '0' ]; then
	chown -R nginx .
	exec gosu nginx "$BASH_SOURCE" "$@"
fi

exec "$@"
