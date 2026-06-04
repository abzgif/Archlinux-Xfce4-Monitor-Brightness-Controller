#!/usr/bin/env bash

# 1. Get raw numbers. -t mode outputs: VCP 10 CNC current_value max_value
RAW_OUTPUT=$(ddcutil getvcp 10 --display 1 -t 2>/dev/null)

# Extract the 4th value from the terse string (which is the current brightness)
CURRENT_BRIGHT=$(echo "$RAW_OUTPUT" | awk '{print $4}')

# Hard fallback only if the monitor completely disconnects
if [ -z "$CURRENT_BRIGHT" ] || [ "$CURRENT_BRIGHT" -eq 0 ]; then
    CURRENT_BRIGHT=50
fi

# 2. Check if the script was triggered to open the slider window
if [ "$1" = "--popup" ]; then
    # Open the YAD scale slider with your dynamic, real-time value
    NEW_VAL=$(yad --scale --value="$CURRENT_BRIGHT" --min-value=10 --max-value=100 \
        --step=5 --page=10 --width=250 --height=40 \
        --title="Monitor Brightness" \
        --text="Brightness Control:" --undecorated --fixed --close-on-unfocus --button="Apply:0")
    
    # Extract the chosen number
    FINAL_VAL=$(echo "$NEW_VAL" | awk -F'|' '{print $1}' | tr -d ' ')

    # Apply the change instantly to the monitor
    if [ ! -z "$FINAL_VAL" ] && [ "$FINAL_VAL" -gt 0 ]; then
        ddcutil setvcp 10 "$FINAL_VAL" --display 1
    fi
    exit 0
fi

# 3. Output string for the XFCE Top Panel (Pure Minimalist Style)
echo "<txt><span font='Cascadia Code 10' weight='bold'>☀️ ${CURRENT_BRIGHT}%</span></txt>"
echo "<tool>Click to adjust brightness</tool>"

# Trigger command
echo "<txtclick>/home/abuzar/.local/bin/monitor_brightness.sh --popup</txtclick>"