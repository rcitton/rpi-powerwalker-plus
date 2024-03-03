#!/bin/bash

set -e

stop_pmaster() {
    echo "Stopping pmasterpd service..."
    service pmasterpd stop
    exit
}

trap stop_pmaster SIGTERM SIGINT

if ! [ -f /opt/pmasterp/data/pmasterpd ]; then
    echo "First run, installing pmasterpd into /opt/pmasterp/data..."
    cd $(dirname "$0")
    unzip -o pmasterp_linux64.zip
    bash pmasterp*-linux-x86_x64.sh -q -dir /opt/pmasterp/data -varfile response.varfile
    rm -f pmasterp*-linux-x86_x64.sh
    echo "Installation done."
fi

service pmasterpd start

sleep infinity &
wait $!
