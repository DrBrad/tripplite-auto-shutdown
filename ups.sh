#!/bin/bash

UPS_NAME="tripplite"
RUNTIME_THRESHOLD=300
SERVERS=( "server1" "server2" "server3" )

UPS_STATUS=$(upsc tripplite ups.status 2>&1 | grep -v "Init SSL without certificate database")
BATTERY_RUNTIME=$(upsc tripplite battery.runtime 2>&1 | grep -v "Init SSL without certificate database")

while true; do
    #echo "$UPS_STATUS"
    #echo "Battery runtime: $BATTERY_RUNTIME seconds"

    if [[ "$UPS_STATUS" == "OB" && "$BATTERY_RUNTIME" -lt "$RUNTIME_THRESHOLD" ]]; then
        echo "Power outage detected and battery runtime is less than 5 minutes! Initiating shutdown..."

        for server in "${SERVERS[@]}"; do
            echo "Shutting down $server..."
            #ssh $server 'sudo shutdown -h now' &
        done

        #sudo shutdown -h now
    else
        echo "UPS status: $UPS_STATUS | Battery runtime: $BATTERY_RUNTIME seconds. No action required."
    fi

    sleep 10
done
