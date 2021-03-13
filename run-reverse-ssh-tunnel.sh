#!/usr/bin/env sh

set -euo pipefail

if test -S /tmp/sshtunnel; then
    echo "SSH tunnel is up $(date)"
else
    ssh -oStrictHostKeyChecking=no -f -N -M -S /tmp/sshtunnel -R 1991:localhost:5900 operation-nigeria@34.68.234.52
fi;
