#! /usr/bin/bash
set -x

# Fixed order of monitors
MONITOR_ARR=("HDMI-A-0" "DP-1-0" "eDP")
WORKSPACES=("I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X")
WORKSPACE_COUNT=10

num_monitors="$(xrandr --query | grep ' connected' | wc -l)"

if [[ $num_monitors = "1" ]]; then 
    echo "Only internal monitor connected"
    bspc monitor -d "${WORKSPACES[*]}"
    exit 0;
fi

# Temporary patch
if [[ $(xrandr -q | grep "DP-1-0 connected") ]]; then
    xrandr --display :0 --output "DP-1-0" --auto
    sleep 1
fi

monitor_present=()

disp_ptr=0
for i in ${!MONITOR_ARR[@]}; do
    if [[ $(xrandr -q | grep "${MONITOR_ARR[$i]} connected") ]]; then
        echo "${MONITOR_ARR[$i]} is connected"
        monitor_present+=("${MONITOR_ARR[$i]}")

        # Arrange monitor output
        if [[ $num_monitors = "3" ]]; then
            if [[ ${MONITOR_ARR[$i]} = "HDMI-A-0" ]]; then 
                xrandr --output ${MONITOR_ARR[$i]} --left-of "DP-1-0"
            fi
            if [[ ${MONITOR_ARR[$i]} = "DP-1-0" ]]; then 
                xrandr --output ${MONITOR_ARR[$i]} --left-of "eDP"
            fi
        elif [[ $num_monitors = "2" ]]; then
            if [[ ${MONITOR_ARR[$i]} != "eDP" ]]; then 
                xrandr --output ${MONITOR_ARR[$i]} --left-of "eDP"
            fi
        fi

        # Find workspaces for current monitor
        curr_mon_workspaces=()
        for (( j=disp_ptr ; j < WORKSPACE_COUNT ; j+=num_monitors )); do
            curr_mon_workspaces+=("${WORKSPACES[$j]}")
        done
        ((disp_ptr++))
        echo "Assigning workspace ${curr_mon_workspaces[*]} to monitor ${MONITOR_ARR[$i]}"
        bspc monitor "${MONITOR_ARR[$i]}" -d "${curr_mon_workspaces[*]}"
    fi
done

echo "Reordering display sequence: ${monitor_present[*]}"
bspc wm --reorder-monitors "${monitor_present[*]}"
