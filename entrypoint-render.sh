#!/bin/bash
# entrypoint-render.sh
# This script ensures Freqtrade runs correctly on Render's free tier.

set -e

# Map Render's dynamic $PORT to Freqtrade's expected environment variable.
if [ -n "$PORT" ]; then
    export FREQTRADE__API_SERVER__LISTEN_PORT="$PORT"
    echo "Info: Mapping Render PORT ($PORT) to FREQTRADE__API_SERVER__LISTEN_PORT"
fi

# Filter out the '--api-server-listen-port' argument that Render automatically appends.
# Freqtrade's 'trade' command doesn't recognize this flag and will crash if it's present.
args=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --api-server-listen-port)
            # Skip the flag and its value
            shift 2
            ;;
        *)
            args+=("$1")
            shift
            ;;
    esac
done

# Execute Freqtrade with the remaining arguments.
# We use 'exec' so Freqtrade becomes the main process (PID 1) and handles signals correctly.
# We use the absolute path to ensure it's found regardless of PATH settings.
echo "Info: Starting Freqtrade with arguments: ${args[*]}"
exec /home/ftuser/.local/bin/freqtrade "${args[@]}"
